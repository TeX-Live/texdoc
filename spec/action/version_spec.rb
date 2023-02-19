require 'spec_helper'

RSpec.describe 'The "version" action', :type => :aruba do
  include_context "version"
  include_context "messages"

  let(:version_text) do
    <<~EXPECTED
      Texdoc #{version} (#{release_date})

      Copyright 2008-2023 Manuel Pégourié-Gonnard, Takuto Asakura, the TeX Live Team.
      License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
      This is free software: you are free to change and redistribute it.
    EXPECTED
  end

  context "with --version" do
    before(:each) { run_texdoc "--version" }

    it do
      expect(stdout).to eq version_text
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "with -V" do
    before(:each) { run_texdoc "-V" }

    it do
      expect(stdout).to eq version_text
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "with -V -l" do
    before(:each) { run_texdoc "-V -l" }

    it do
      expect(stdout).to eq version_text
      expect(last_command_started).to be_successfully_executed
    end
  end
end
