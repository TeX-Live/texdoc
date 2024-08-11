require 'spec_helper'

RSpec.describe "Alias", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  let(:texdoc_cnf) { texmf_home / "texdoc/texdoc.cnf" }

  context "is set in texdoc.cnf" do
    let(:config_content) {
      <<~EOF
        alias testalias = texlive
      EOF
    }
    before(:each) { File.write(texdoc_cnf, config_content) }

    context "and query the exact alias" do
      before(:each) { run_texdoc "-ddocfile", "testalias" }

      it "should find aliased documents" do
        expect(stderr).to include(debug_line "search", 'Searching documents for pattern "testalias"')
        expect(stderr).to match(/texdoc debug-search: \(0da8ec4\) File \S*texlive\/texlive-en\/texlive-en.pdf found/)
        expect(stderr).to include(debug_line "docfile", "(0da8ec4) name: texlive/texlive-en/texlive-en.pdf")
        expect(stderr).to include(debug_line "docfile", "(0da8ec4) matches: texlive (alias)")
        expect(last_command_started).to be_successfully_executed
      end
    end

    context "and query a misspelled alias" do
      before(:each) { run_texdoc "-M", "-ddocfile", "testaliases" }

      it "should not find aliased documents" do
        expect(stderr).to include(debug_line "search", 'Searching documents for pattern "testaliases"')
        expect(stderr).not_to match(/texdoc debug-search: \(0da8ec4\) File \S*texlive\/texlive-en\/texlive-en.pdf found/)
        expect(stderr).not_to include(debug_line "docfile", "(0da8ec4) name: texlive/texlive-en/texlive-en.pdf")
        expect(stderr).not_to include(debug_line "docfile", "(0da8ec4) matches: texlive (alias)")
      end
    end
  end
end
