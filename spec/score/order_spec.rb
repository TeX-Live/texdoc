require 'spec_helper'

RSpec.describe "Document order in the result", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  context "for documents with different scores" do
    before(:each) { run_texdoc "-lM", "babel" }

    let(:res_list_head) do
      <<~EXPECTED
        babel\t7.0\t#{normalize_path(texmf_dist / "doc/latex/babel/babel.pdf")}\t\tUser guide
        babel\t4.0\t#{normalize_path(texmf_dist / "doc/latex/babel/babel-code.pdf")}\t\tCode documentation
      EXPECTED
    end

    it "should be ordered by the scores" do
      expect(stdout).to start_with(res_list_head)
    end
  end

  context "for documents with the same scores and different extentions" do
    before(:each) { run_texdoc "-lM", "texlive-en" }

    let(:res_list_head) do
      <<~EXPECTED
        texlive-en\t10.0\t#{normalize_path(texmf_dist / "doc/texlive/texlive-en/texlive-en.pdf")}\t\t
        texlive-en\t10.0\t#{normalize_path(texmf_dist / "doc/texlive/texlive-en/texlive-en.html")}\t\t
      EXPECTED
    end

    it "should be ordered by the extention position" do
      expect(stdout).to start_with(res_list_head)
    end
  end
end
