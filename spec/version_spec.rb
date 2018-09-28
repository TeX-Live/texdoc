require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe 'The "version" action', :type => :aruba do
  let(:stdout) { last_command_started.stdout.gsub("\r", "") }
  let(:version) { "3.0" }
  let(:version_text) do
    <<~EXPECTED
      Texdoc #{version}

      Copyright 2018 Manuel Pégourié-Gonnard, Takuto Asakura, Karl Berry, and Norbert Preining.
      License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
      This is free software: you are free to change and redistribute it.
    EXPECTED
  end

  before(:all) { set_default_env }

  context "with --version" do
    before(:each) { run_texdoc "--version" }
    before(:each) { stop_all_commands }

    it do
      expect(stdout).to eq version_text
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "with -V" do
    before(:each) { run_texdoc "-V" }
    before(:each) { stop_all_commands }

    it do
      expect(stdout).to eq version_text
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "with -V -l" do
    before(:each) { run_texdoc "-V -l" }
    before(:each) { stop_all_commands }

    it do
      expect(stdout).to eq version_text
      expect(last_command_started).to be_successfully_executed
    end
  end
end
