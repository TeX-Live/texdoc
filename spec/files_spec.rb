require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Showing files", :type => :aruba do
  before(:all) { set_default_env }

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
