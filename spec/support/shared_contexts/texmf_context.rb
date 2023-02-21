require 'os'
require 'pathname'

shared_context "texmf" do
  # pseudo TEXMF trees
  let(:texmf_home) { SpecHelplers::Texdoc::PS_TEXMF }
  let(:texmf_dist) { SpecHelplers::Texdoc::PS_TEXMF_DIST }
  let(:texmf_var) { SpecHelplers::Texdoc::PS_TEXMF_VAR }

  # link to texlive.tlpdb
  let(:tlpdb) { SpecHelplers::Texdoc::REPO_TEXLIVE_TLPDB }

  # sample files
  ["html", "htm", "dvi", "md", "txt", "pdf", "ps", "tex"].each do |ext|
    let("sample_#{ext}".to_sym) {
      texmf_home / "doc/sample/sample.#{ext}"
    }
  end
end
