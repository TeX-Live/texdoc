require 'os'
require 'spec_helper'

RSpec.describe "General configuration", :type => :aruba do
  include_context "messages"

  context "the default behavior" do
    before(:each) { run_texdoc "-D", "texlive-en" }

    it "most items should be set from built-in defaults" do
      defaults = [
        "badext_list=txt, dat, ",
        "mode=view",
        "verbosity_level=2",
        "badbasename_list=readme, 00readme",
        "machine_switch=false",
        "max_lines=20",
        "basename_list=readme, 00readme",
        "ext_list=pdf, htm, html, txt, dat, md, ps, dvi, ",
        "interact_switch=true",
        "fuzzy_level=3",
        "rm_dir=rmdir",
        "zipext_list=",
        "rm_file=rm -f",
      ]

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
