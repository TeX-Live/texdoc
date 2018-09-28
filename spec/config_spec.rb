require 'os'
require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Configuration", :type => :aruba do
  let(:stderr) { last_command_started.stderr.gsub("\r", "") }
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

  context "the default behavior" do
    before(:each) { run_texdoc "-D", sample }
    before(:each) { stop_all_commands }

    it "most items should be set from built-in defaults" do
      defaults.each do |config|
        expect(stderr).to include(
          debug_line "config", "Setting \"#{config}\" from built-in defaults.")
      end
    end

    if not OS.windows?
      it 'item "lang" should be set from the OS locale (except Windows)' do
        expect(stderr).to include(
          debug_line "config", "Setting \"lang=en\" from operating system locale.")
      end
    end
  end
end
