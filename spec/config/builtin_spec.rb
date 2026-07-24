require 'os'
require 'spec_helper'

RSpec.describe "The built-in configs", :type => :aruba do
  include_context "messages"

  context "if no other sources of config is set" do
    before(:each) { run_texdoc "-D", "texlive-en" }

    it "should be set to the default values" do
      defaults = [
        "badext_list=txt, dat, ",
        "mode=view",
        "verbosity_level=2",
        "badbasename_list=readme, 00readme",
        "machine_switch=false",
        "max_lines=10",
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
  end
end
