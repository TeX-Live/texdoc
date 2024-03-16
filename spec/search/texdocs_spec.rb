require 'spec_helper'

RSpec.describe "TEXDOCS handling", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  context "if a list of TEXMF trees given in TEXDOCS" do
    before(:each) {
      set_environment_variable "TEXDOCS",
        'path/to/tree4,path/to/tree3//,!!path/to/tree2,!!path/to/tree1//'
    }
    before(:each) { run_texdoc "-dtexdocs", "listings" }

    it "should be properly interpreted" do
      expect(stderr).to include(
        debug_line "texdocs",
          "texdocs[4] = path/to/tree4 (index_mandatory=false, recursion_allowed=false)")
      expect(stderr).to include(
        debug_line "texdocs",
          "texdocs[3] = path/to/tree3 (index_mandatory=false, recursion_allowed=true)")
      expect(stderr).to include(
        debug_line "texdocs",
          "texdocs[2] = path/to/tree2 (index_mandatory=true, recursion_allowed=false)")
      expect(stderr).to include(
        debug_line "texdocs",
          "texdocs[1] = path/to/tree1 (index_mandatory=true, recursion_allowed=true)")
    end
  end

  context "with standard testing setup" do
    before(:each) { run_texdoc "-dtexdocs", "listings" }

    let(:texmf_dist_regex) {
      Regexp.escape(normalize_path("/usr/local/texlive/YEAR/texmf-dist")).sub("YEAR", '\d\d\d\d')
    }
    let(:texmf_home_regex) { Regexp.escape(normalize_path(texmf_home)) }

    let(:texdocs_n_dist) {
      /texdocs\[(\d+?)\] = #{texmf_dist_regex}\/doc/.match(stderr).to_a.values_at(1)[0].to_i
    }
    let(:texdocs_n_home) {
      /texdocs\[(\d+?)\] = #{texmf_home_regex}\/doc/.match(stderr).to_a.values_at(1)[0].to_i
    }

    it "should search TEXMFDIST using index" do
      expect(stderr).to match(/texdocs\[#{texdocs_n_dist}\] using index: #{texmf_dist_regex} \(shift=doc\/\)/)
    end

    it "should search TEXMFHOME using file system" do
      expect(stderr).to match(/texdocs\[#{texdocs_n_home}\] using filesystem search/)
    end
  end
end
