require 'os'
require 'pathname'

shared_context "texmf" do
  # pseudo TEXMF trees
  let(:texmf_dist) { Pathname.pwd + "tmp/texmf-dist" }
  let(:texmf_home) { Pathname.pwd + "tmp/texmf" }
  let(:texmf_var) { Pathname.pwd + "tmp/texmf-var" }

  # link to texlive.tlpdb
  let(:tlpdb) { Pathname.pwd + "tmp/texlive.tlpdb" }

  # sample files
  ["html", "htm", "dvi", "md", "txt", "pdf", "ps", "tex"].each do |ext|
    let("sample_#{ext}".to_sym) {
      Pathname.pwd + "tmp/texmf/doc/sample/sample.#{ext}"
    }
  end

  # path utility
  def normalize_path path
    if OS.windows?
      return `kpsewhich -expand-path #{path}`.chomp.gsub("\\", "/")
    else
      return `kpsewhich -expand-path #{path}`.chomp
    end
  end
end
