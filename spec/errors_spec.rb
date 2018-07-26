require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Error case:", :type => :aruba do
  before(:all) { set_default_env }

  let(:stderr) { last_command_started.stderr }

  context "running texdoc with no option nor argument" do
    before(:each) { run_texdoc }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to have_exit_status(2) }
    it { expect(stderr).to include(error_line "No action specified.") }
    it { expect(stderr).to include(
      error_line "Try `texdoc --help' for short help, `texdoc texdoc' for full manual.") }
  end

  context "running texdoc --just-view without an argument" do
    before(:each) { run_texdoc "--just-view" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to have_exit_status(2) }
    it { expect(stderr).to include(error_line "Missing file operand to --just-view.") }
    it { expect(stderr).to include(
      error_line "Try `texdoc --help' for short help, `texdoc texdoc' for full manual.") }
  end

  context "try to open not existing file with --just-view" do
    before(:each) { run_texdoc "--just-view", "not_exist" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to have_exit_status(1) }
    it { expect(stderr).to include(error_line 'File "not_exist" does not exist.') }
  end

  context "when any document for input cannot be found" do
    before(:each) { run_texdoc "never_never_existing_package_foooooooooo" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to have_exit_status(3) }
  end
end
