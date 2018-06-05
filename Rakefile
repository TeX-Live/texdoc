# Rakefile for Texdoc.
# Public domain.

require 'rake'
require 'pathname'
require 'fileutils'

TEXDOC_VERSION = "3.0"

desc "Install Texdoc to your system"
task :install do
  # check the existence of the texdoc source
  texdoc_scriptdir = Pathname.pwd.join("script")
  texdoc_cnf = Pathname.pwd.join("texdoc.cnf")
  texdoc_tlu = texdoc_scriptdir.join("texdoc.tlu")
  fail("Directory #{texdoc_scriptdir} does not exists") if !texdoc_scriptdir.directory?
  fail("File #{texdoc_cnf} does not exists") if !texdoc_cnf.file?
  fail("File #{texdoc_tlu} does not exists") if !texdoc_tlu.file?

  # get TEXMFHOME
  texmf = Pathname(`kpsewhich --var-value TEXMFHOME`.chomp)

  # create target dirs if not exists
  texmf_scripts = texmf.join("scripts")
  texmf_texdoc = texmf.join("texdoc")
  FileUtils.mkdir_p([texmf_scripts, texmf_texdoc])

  # create the symbolic links
  FileUtils.ln_s(texdoc_scriptdir, texmf_scripts.join("texdoc"))
  FileUtils.ln_s(texdoc_cnf, texmf_texdoc.join("texdoc-dist.cnf"))
end

desc "Uninstall Texdoc from your system"
task :uninstall do
  # get TEXMFHOME
  texmf = Pathname(`kpsewhich --var-value TEXMFHOME`.chomp)

  # check the symlinks
  texdoc = texmf.join("scripts/texdoc")
  texdoc_cnf = texmf.join("texdoc/texdoc-dist.cnf")
  fail("#{texdoc} is not a symbolic link") if !texdoc.symlink?
  fail("#{texdoc_cnf} is not a symbolic link") if !texdoc_cnf.symlink?

  # check this Texdoc is installed to the system
  if texdoc.readlink != Pathname.pwd.join("script") \
      or texdoc_cnf.readlink != Pathname.pwd.join("texdoc.cnf")
    fail("Another texdoc is installed; stop uninstalling")
  end

  # execute unlink
  FileUtils.safe_unlink([texdoc, texdoc_cnf])
end

desc "Run all tests"
task :test do
  sh "bundle exec rspec"
end

desc "Generate a pre-hashed cache file"
task :gen_datafile do
  # construct pseudo TEXMF
  texdoc_scriptdir = Pathname.pwd.join("script")
  texdoc_cnf = Pathname.pwd.join("texdoc.cnf")
  texdoc_tlu = texdoc_scriptdir.join("texdoc.tlu")

  texdoc_tmpdir = Pathname.pwd.join("tmp")
  texmf = Pathname(texdoc_tmpdir).join("texmf")

  texmf_scripts = texmf.join("scripts")
  texmf_texdoc = texmf.join("texdoc")
  FileUtils.mkdir_p([texmf_scripts, texmf_texdoc])
  FileUtils.ln_s(texdoc_scriptdir, texmf_scripts.join("texdoc"))
  FileUtils.ln_s(texdoc_cnf, texmf_texdoc.join("texdoc.cnf"))

  # set ENV
  ENV["TEXMFHOME"] = texmf.to_s
  ENV["LC_ALL"] = "C"

  # run Texdoc to generate a flesh cache file
  sh "texlua #{texdoc_tlu.to_s} -lM texlive-en > #{File::NULL}", verbose: false

  # copy the cache file
  cache = Pathname(`kpsewhich --var-value TEXMFVAR`.chomp).join("texdoc/cache-tlpdb.lua")
  FileUtils.cp(cache, texdoc_scriptdir.join("Data.tlpdb.lua"))

  # remove pseudo TEXMF
  FileUtils.rm_rf(texmf)
end

desc "Generate all documentation"
task :doc do
  FileUtils.cd("doc")

  # generate PDF documentation
  sh "latexmk -quiet texdoc.tex > #{File::NULL} 2> #{File::NULL}", verbose: false

  # generate manpage
  opt_man = "--manual=\"Texdoc manual\""
  opt_org = "--organization=\"Texdoc #{TEXDOC_VERSION}\""
  sh "bundle exec ronn -r #{opt_man} #{opt_org} texdoc.1.md 2> #{File::NULL}", verbose: false
end

desc "Preview the manpage"
task :man do
  FileUtils.cd("doc")

  opt_man = "--manual=\"Texdoc manual\""
  opt_org = "--organization=\"Texdoc #{TEXDOC_VERSION}\""
  sh "bundle exec ronn -m #{opt_man} #{opt_org} texdoc.1.md", verbose: false
end

desc "Cleanup the Texdoc directroy"
task :clean do
  FileUtils.rm_rf("tmp")
  FileUtils.rm_f("script/Data.tlpdb.lua")
  FileUtils.cd("doc")
  sh "latexmk -C -quiet", verbose: false
  FileUtils.rm_f("texdoc.1")
end

desc "Create archive for CTAN"
task :ctan do
  # generate documentation
  origin = Pathname.pwd
  Rake::Task["doc"].invoke()
  FileUtils.cd(origin)

  # prepare the structure under tmp
  pkg_name = "texdoc-#{TEXDOC_VERSION}"
  target = Pathname("tmp").join(pkg_name)
  FileUtils.rm_rf(target)
  FileUtils.mkdir_p(target)

  script_dir = target.join("script")
  FileUtils.mkdir_p(script_dir)
  FileUtils.cp(["COPYING", "README.md", "NEWS", "texdoc.cnf"], target)
  FileUtils.cp_r(Dir.glob("script/*"), script_dir)

  doc_dir = Pathname("doc")
  docs = ["texdoc.tex", "texdoc.pdf", "texdoc.1"].map{ |n| doc_dir.join(n) }
  FileUtils.mkdir_p(target.join(doc_dir))
  FileUtils.cp(docs, target.join(doc_dir))

  # create zip archive
  FileUtils.cd("tmp")
  sh "zip -q -r #{pkg_name}.zip #{pkg_name}", verbose: false
end

