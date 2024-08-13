require 'os'
require 'pathname'

shared_context "texmf" do
  # pseudo TEXMF trees (dynamically generated)
  let(:ps_texmf_home) { SpecHelplers::Texdoc::PS_TEXMF_HOME }
  let(:ps_texmf_dist) { SpecHelplers::Texdoc::PS_TEXMF_DIST }

  # the only real TEXMF tree
  let(:texmf_dist) { `kpsewhich --var-value TEXMFDIST`.chomp }

  # link to texlive.tlpdb
  let(:ps_tlpdb) { SpecHelplers::Texdoc::REPO_TEXLIVE_TLPDB }

  # texdoc.cnf for testing
  let(:texdoc_cnf) { ps_texmf_home / "texdoc/texdoc.cnf" }
  let(:texdoc_dist_cnf) { ps_texmf_home / "texdoc/texdoc-dist.cnf" }

  # sample files
  ["html", "htm", "dvi", "md", "txt", "pdf", "ps", "tex"].each do |ext|
    let("sample_#{ext}".to_sym) {
      ps_texmf_home / "doc/sample/sample.#{ext}"
    }
  end
end
