require 'spec_helper'

RSpec.describe "Handling texdocs", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  context "if a list of TEXMF trees given in TEXDOCS" do
    before(:each) {
      set_environment_variable "TEXDOCS",
        'path/to/tree4,path/to/tree3//,!!path/to/tree2,!!path/to/tree1//'
    }
    before(:each) { run_texdoc "-dtexdocs", "listings" }

    let(:tree_prefix) { normalize_path("path/to/") }

    it "should be properly interpreted" do
      expect(stderr).to include(
        debug_line "texdocs",
          "texdocs[4] = #{tree_prefix}tree4 (index_mandatory=false, recursion_allowed=false)")
      expect(stderr).to include(
        debug_line "texdocs",
          "texdocs[3] = #{tree_prefix}tree3 (index_mandatory=false, recursion_allowed=true)")
      expect(stderr).to include(
        debug_line "texdocs",
          "texdocs[2] = #{tree_prefix}tree2 (index_mandatory=true, recursion_allowed=false)")
      expect(stderr).to include(
        debug_line "texdocs",
          "texdocs[1] = #{tree_prefix}tree1 (index_mandatory=true, recursion_allowed=true)")
    end
  end

  context "with standard testing setup" do
    before(:each) { run_texdoc "-dtexdocs", "listings" }

    let(:texmf_dist_regex) { Regexp.escape(normalize_path(texmf_dist)) }
    let(:texmf_home_regex) { Regexp.escape(normalize_path(ps_texmf_home)) }

    let(:path_doc_suffix_regex) { Regexp.escape(normalize_path("/doc")) }
    let(:shift_doc_suffix_regex) { Regexp.escape(normalize_path("doc/")) }

    let(:texdocs_n_dist) {
      /texdocs\[(\d+?)\] = #{texmf_dist_regex}#{path_doc_suffix_regex}/.match(stderr).to_a.values_at(1)[0].to_i
    }
    let(:texdocs_n_home) {
      /texdocs\[(\d+?)\] = #{texmf_home_regex}#{path_doc_suffix_regex}/.match(stderr).to_a.values_at(1)[0].to_i
    }

    it "should search TEXMFDIST using index" do
      expect(stderr).to match(
        /texdocs\[#{texdocs_n_dist}\] using index: #{texmf_dist_regex} \(shift=#{shift_doc_suffix_regex}\)/)
    end

    it "should search TEXMFHOME using file system" do
      expect(stderr).to match(/texdocs\[#{texdocs_n_home}\] using filesystem search/)
    end
  end
end

RSpec.describe "Document search in texdocs", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  context "for a docfile name query" do
    let(:test_res_name) { "latex/babel/babel-code.pdf" }
    let(:test_res_hash) { "4abb904" }
    let(:test_res_realpath) { normalize_path(texmf_dist / "doc" / test_res_name) }

    let(:test_query) { "babel-code" }
    before(:each) { run_texdoc "-ddocfile", test_query }

    it "should find the document" do
      expect(stderr).to include(debug_line "search", "Searching documents for pattern \"#{test_query}\"")
      expect(stderr).to include(debug_line "search", "(#{test_res_hash}) File #{test_res_realpath} found")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) name: #{test_res_name}")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) matches: #{test_query}")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) sources: texdocs")
    end
  end
end
