require 'spec_helper'

RSpec.describe 'The "files" action', :type => :aruba do
  context "with --files" do
    before(:each) { run_texdoc "--files" }
    before(:each) { stop_all_commands }

    it { expect(last_command_started).to be_successfully_executed }
  end

  context "with -f" do
    before(:each) { run_texdoc "-f" }
    before(:each) { stop_all_commands }

    it { expect(last_command_started).to be_successfully_executed }
  end

  context "with -f -l" do
    before(:each) { run_texdoc "-f -l" }
    before(:each) { stop_all_commands }

    it { expect(last_command_started).to be_successfully_executed }
  end
end
