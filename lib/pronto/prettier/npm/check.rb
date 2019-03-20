# frozen_string_literal: true

require "pronto"
require "shellwords"

class Check
  CONFIG_FILE = ".pronto_prettier_npm.yml"
  CONFIG_KEYS = %w(prettier_executable files_to_lint cmd_line_opts).freeze

  attr_writer :prettier_executable, :cmd_line_opts
  attr_accessor :patches

  def initialize(patches = [])
    @patches = patches
  end

  def prettier_executable
    @prettier_executable || "prettier"
  end

  def files_to_lint
    @files_to_lint || /(\.js|\.jsx|\.scss)$/
  end

  def cmd_line_opts
    @cmd_line_opts || "--check"
  end

  def files_to_lint=(regexp)
    @files_to_lint = regexp.is_a?(Regexp) && regexp || Regexp.new(regexp)
  end

  def config_options
    @config_options ||=
      begin
        config_file = File.join(repo_path, CONFIG_FILE)
        File.exist?(config_file) && YAML.load_file(config_file) || {}
      end
  end

  def read_config
    config_options.each do |key, val|
      next unless CONFIG_KEYS.include?(key.to_s)

      send("#{key}=", val)
    end
  end

  def run
    return [] if !@patches || @patches.count.zero?

    read_config

    @patches.
      select { |patch| patch.additions.positive? }.
      select { |patch| js_file?(patch.new_file_full_path) }.
      map { |patch| inspect(patch) }.
      flatten.compact
  end

  private

  def repo_path
    @repo_path ||= @patches.first.repo.path
  end

  def inspect(patch)
    offenses = run_prettier(patch)
    clean_up_prettier_output(offenses).
      map do |offense|
        patch.
          added_lines.
          select { |line| line.new_lineno == offense["line"] }.
          map { |line| new_message(offense, line) }
      end
  end

  def new_message(offense, line)
    path  = line.patch.delta.new_file[:path]
    level = :warning

    Message.new(path, line, level, offense["message"], nil, self.class)
  end

  def js_file?(path)
    files_to_lint =~ path.to_s
  end

  def run_prettier(patch)
    Dir.chdir(repo_path) do
      JSON.parse `#{prettier_command_line(patch.new_file_full_path.to_s)}`
    end
  end

  def prettier_command_line(path)
    "#{prettier_executable} #{cmd_line_opts} #{Shellwords.escape(path)} -f json"
  end

  def clean_up_prettier_output(output)
    # 1. Filter out offenses without a warning or error
    # 2. Get the messages for that file
    # 3. Ignore errors without a line number for now
    output.
      select { |offense| (offense["errorCount"] + offense["warningCount"]).positive? }.
      map { |offense| offense["messages"] }.
      flatten.select { |offense| offense["line"] }
  end
end
