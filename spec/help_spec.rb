require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Showing help", :type => :aruba do
  let(:help_head) do
<<~EXPECTED
Usage: texdoc [OPTION...] NAME...
  or:  texdoc ACTION

Try to find appropriate TeX documentation for the specified NAME(s).
Alternatively, perform the given ACTION and exit.
EXPECTED
  end

  before(:context) { set_default_env }

  context "with --help" do
    before(:each) { run_texdoc "--help" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stdout).to start_with help_head }
  end

  context "with -h" do
    before(:each) { run_texdoc "-h" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stdout).to start_with help_head }
  end

  context "with -h -l" do
    before(:each) { run_texdoc "-h -l" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stdout).to start_with help_head }
  end
end
