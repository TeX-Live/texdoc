require 'os'
require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Running Texdoc", :type => :aruba do
  let(:sample) { "texlive-en" }
  let(:defaults) do
    [
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
  end

  before(:all) { set_default_env }
  let(:stderr) { last_command_started.stderr }

  context "the simplest case" do
    before(:each) { run_texdoc "-D", sample }
    before(:each) { stop_all_commands }

    it "configuration should set from built-in defaults at the first place" do
      defaults.each do |config|
        expect(stderr).to include(
          debug_line "config", "Setting \"#{config}\" from built-in defaults.")
      end
    end

    if not OS.windows?
      it "set lang from the OS locale (except Windows)" do
        expect(stderr).to include(
          debug_line "config", "Setting \"lang=en\" from operating system locale.")
      end
    end
  end
end
