require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Showing version", :type => :aruba do
  let(:version) { "3.0" }

  before(:context) { set_default_env }

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
