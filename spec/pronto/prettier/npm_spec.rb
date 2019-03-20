# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pronto::Prettier::Npm do
  let(:prettier) { Check.new(patches) }
  let(:patches) { [] }

  describe "#run" do
    subject(:run) { prettier.run }

    context "patches are nil" do
      let(:patches) { nil }

      it "returns an empty array" do
        expect(run).to eql([])
      end
    end

    context "no patches" do
      let(:patches) { [] }

      it "returns an empty array" do
        expect(run).to eql([])
      end
    end
  end

  #   context "patches with a one and a four warnings" do
  #     # include_context "test repo"

  #     let(:patches) { repo.diff("master") }

  #     it "returns correct number of errors" do
  #       expect(run.count).to eql(5)
  #     end

  #     it "has correct first message" do
  #       expect(run.first.msg).to eql("'foo' is not defined.")
  #     end

  #     context(
  #       "with files to lint config that never matches",
  #       config: { "files_to_lint" => "will never match" },
  #     ) do
  #       it "returns zero errors" do
  #         expect(run.count).to eql(0)
  #       end
  #     end

  #     context(
  #       "with files to lint config that matches only .js",
  #       config: { "files_to_lint" => '\.js$' },
  #     ) do
  #       it "returns correct amount of errors" do
  #         expect(run.count).to eql(2)
  #       end
  #     end

  #     context(
  #       "with cmd_line_opts to include .html",
  #       config: { "cmd_line_opts" => "--ext .html" },
  #     ) do
  #       it "returns correct number of errors" do
  #         expect(run.count).to eql 5
  #       end
  #     end

  #     context(
  #       "with different prettier executable",
  #       config: { "prettier_executable" => "./custom_prettier.sh" },
  #     ) do
  #       it "calls the custom prettier prettier_executable" do
  #         expect { run }.to raise_error(JSON::ParserError, /custom prettier called/)
  #       end
  #     end
  #   end

  #   context "repo with ignored and not ignored file, each with three warnings" do
  #     include_context "prettierignore repo"

  #     let(:patches) { repo.diff("master") }

  #     it "returns correct number of errors" do
  #       expect(run.count).to eql(3)
  #     end

  #     it "has correct first message" do
  #       expect(run.first.msg).to eql("'HelloWorld' is defined but never used.")
  #     end
  #   end
  # end

  describe "#files_to_lint" do
    subject(:files_to_lint) { prettier.files_to_lint }

    it "matches .js by default" do
      expect(files_to_lint).to match("javascript_example.js")
    end

    it "matches .jsx by default" do
      expect(files_to_lint).to match("jsx_example.jsx")
    end

    it "matches .scss by default" do
      expect(files_to_lint).to match("scss_example.scss")
    end
  end

  describe "#prettier_executable" do
    subject(:prettier_executable) { prettier.prettier_executable }

    it "is `prettier` by default" do
      expect(prettier_executable).to eql("prettier")
    end

    # context(
    #   "with different prettier executable config",
    #   config: { "prettier_executable" => "custom_prettier" },
    # ) do
    #   it "is correct" do
    #     prettier.read_config
    #     expect(prettier_executable).to eql("custom_prettier")
    #   end
    # end
  end

  describe "#prettier_command_line" do
    subject(:prettier_command_line) { prettier.send(:prettier_command_line, path) }
    let(:path) { "/some/path.rb" }

    it "adds json output flag" do
      expect(prettier_command_line).to include("-f json")
    end

    it "adds path" do
      expect(prettier_command_line).to include(path)
    end

    it "starts with prettier executable" do
      expect(prettier_command_line).to start_with(prettier.prettier_executable)
    end

    context "with path that should be escaped" do
      let(:path) { "/must be/$escaped" }

      it "escapes the path correctly" do
        expect(prettier_command_line).to include('/must\\ be/\\$escaped')
      end

      it "does not include unescaped path" do
        expect(prettier_command_line).not_to include(path)
      end
    end

    # context(
    #   "with some command line options",
    #   config: { "cmd_line_opts" => "--my command --line opts" },
    # ) do
    #   it "includes the custom command line options" do
    #     prettier.read_config
    #     expect(prettier_command_line).to include("--my command --line opts")
    #   end
    # end
  end
end
