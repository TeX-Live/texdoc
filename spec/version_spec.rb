require 'spec_helper'

RSpec.describe "Showing version", :type => :aruba do
  include_context "environment"

  let(:version) { "3.0" }

  context "with --version" do
    before(:each) { run_texdoc "--version" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stdout).to start_with "Texdoc #{version}" }
  end

  context "with -V" do
    before(:each) { run_texdoc "-V" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stdout).to start_with "Texdoc #{version}" }
  end

  context "with -V -l" do
    before(:each) { run_texdoc "-V -l" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stdout).to start_with "Texdoc #{version}" }
  end
end
