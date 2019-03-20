# frozen_string_literal: true

require "fileutils"
require "bundler/setup"
require "pronto/prettier/npm"
require "simplecov"
require "pry"
SimpleCov.start

%w(test prettierignore).each do |repo_name|
  RSpec.shared_context "#{repo_name} repo" do
    let(:git) { "spec/fixtures/#{repo_name}.git/git" }
    let(:dot_git) { "spec/fixtures/#{repo_name}.git/.git" }

    before { FileUtils.mv(git, dot_git) }
    let(:repo) { Pronto::Git::Repository.new("spec/fixtures/#{repo_name}.git") }
    after { FileUtils.mv(dot_git, git) }
  end
end

RSpec.shared_context "with config", config: true do
  requested_config = metadata[:config]

  before(:each) do
    allow_any_instance_of(Check).to receive(:config_options).and_return(requested_config)

    # make sure the config is actually read in the example
    expect_any_instance_of(Check).to receive(:read_config).and_call_original
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
