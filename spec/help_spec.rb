require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Showing help", :type => :aruba do
  let(:help_text) do
<<~EXPECTED
Usage: texdoc [OPTION...] NAME...
  or:  texdoc ACTION

Try to find appropriate TeX documentation for the specified NAME(s).
Alternatively, perform the given ACTION and exit.

Options:
  -w, --view        Use view mode: start a viewer. (default)
  -m, --mixed       Use mixed mode (view or list).
  -l, --list        Use list mode: show a list of results.
  -s, --showall     Use showall mode: show also "bad" results.

  -i, --interact    Use interactive menus. (default)
  -I, --nointeract  Use plain lists, no interaction required.
  -M, --machine     Machine-readable output for lists (implies -I).

  -q, --quiet       Suppress warnings and most error messages.
  -v, --verbose     Print additional information (e.g., viewer command).
  -D, --debug       Activate all debug output (equal to "--debug=all").
  -d LIST, --debug=LIST
                    Activate debug output restricted to LIST.
  -c NAME=VALUE     Set configuration item NAME to VALUE.

Actions:
  -h, --help        Print this help message.
  -V, --version     Print the version number.
  -f, --files       Print the list of configuration files used.
  --just-view FILE  Display FILE, given with full path (no searching).

Full manual available via `texdoc texdoc'.

Website: <https://tug.org/texdoc/>
Repository: <https://github.com/TeX-Live/texdoc>
Please email bugs to <texdoc@tug.org>.
EXPECTED
  end

  before(:all) { set_default_env }

  context "with --help" do
    before(:each) { run_texdoc "--help" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stdout.gsub("\r", "")).to eq help_text }
  end

  context "with -h" do
    before(:each) { run_texdoc "-h" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stdout.gsub("\r", "")).to eq help_text }
  end

  context "with -h -l" do
    before(:each) { run_texdoc "-h -l" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stdout.gsub("\r", "")).to eq help_text }
  end
end
