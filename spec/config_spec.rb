require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Running Texdoc", :type => :aruba do
  SAMPLE = "texlive-en"
  DEFAULTS = [
    "badext_list=txt, ",
    "mode=view",
    "verbosity_level=2",
    "badbasename_list=readme, 00readme",
    "machine_switch=false",
    "max_lines=20",
    "basename_list=readme, 00readme",
    "ext_list=pdf, htm, html, txt, ps, dvi, ",
    "interact_switch=true",
    "fuzzy_level=5",
    "rm_dir=rmdir",
    "zipext_list=",
    "rm_file=rm -f",
  ]

  before(:all) { set_default_env }
  let(:stderr) { last_command_started.stderr }

  context "the simplest case" do
    before(:each) { run_texdoc "-D", SAMPLE }
    before(:each) { stop_all_commands }

    it "set from built-in defaults at the first place" do
      DEFAULTS.each do |config|
        expect(stderr).to include(
          debug_line "config", "Setting \"#{config}\" from built-in defaults.")
      end
    end

    it "set lang from the OS locale" do
      expect(stderr).to include(
        debug_line "config", "Setting \"lang=en\" from operating system locale.")
    end
  end
end
