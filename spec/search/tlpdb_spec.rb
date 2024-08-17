require 'spec_helper'

RSpec.describe "Document search in tlpdb", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  context "for a runfile, tlp, and docfile name query" do
    let(:test_res_name) { "latex/babel/babel.pdf" }
    let(:test_res_hash) { "b26f92e" }
    let(:test_res_realpath) { normalize_path(texmf_dist / "doc" / test_res_name) }

    let(:test_query) { "babel" }
    before(:each) { run_texdoc "-ddocfile", test_query }

    it "should find the document from both tlpdb and texdocs" do
      expect(stderr).to include(debug_line "search", "Searching documents for pattern \"#{test_query}\"")
      expect(stderr).to include(debug_line "search", "(#{test_res_hash}) File #{test_res_realpath} found")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) name: #{test_res_name}")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) matches: #{test_query}")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) runtodoc: true")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) tlptodoc: true")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) sources: tlpdb, texdocs")
    end
  end

  context "for a tlp and docfile name query" do
    let(:test_res_name) { "texmf-dist/doc/man/man1/dvipdfmx.man1.pdf" }
    let(:test_res_hash) { "e49c24d" }
    let(:test_res_realpath) { normalize_path(texmf_dist.parent / test_res_name) }

    let(:test_query) { "dvipdfmx" }
    before(:each) { run_texdoc "-ddocfile", test_query }

    it "should find the document from tlpdb" do
      expect(stderr).to include(debug_line "search", "Searching documents for pattern \"#{test_query}\"")
      expect(stderr).to include(debug_line "search", "(#{test_res_hash}) File #{test_res_realpath} found")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) name: #{test_res_name}")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) matches: #{test_query}")
      expect(stderr).not_to include(debug_line "docfile", "(#{test_res_hash}) runtodoc: true")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) tlptodoc: true")
    end
  end

  context "for a runfile and docfile name query" do
    let(:test_res_name) { "latex/tools/xspace.pdf" }
    let(:test_res_hash) { "9146ab6" }
    let(:test_res_realpath) { normalize_path(texmf_dist / "doc" / test_res_name) }

    let(:test_query) { "xspace" }
    before(:each) { run_texdoc "-ddocfile", test_query }

    it "should find the document from tlpdb" do
      expect(stderr).to include(debug_line "search", "Searching documents for pattern \"#{test_query}\"")
      expect(stderr).to include(debug_line "search", "(#{test_res_hash}) File #{test_res_realpath} found")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) name: #{test_res_name}")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) matches: #{test_query}")
      expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) runtodoc: true")
      expect(stderr).not_to include(debug_line "docfile", "(#{test_res_hash}) tlptodoc: true")
    end
  end
end
