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

desc "Generate all documentation"
task :doc do
  origin = Pathname.pwd

  # generate PDF documentation
  FileUtils.cd("doc")
  sh "latexmk -quiet texdoc.tex > #{File::NULL} 2> #{File::NULL}", verbose: false

  # generate manpage
  FileUtils.cd("man")
  opt_man = '--manual="Texdoc manual"'
  opt_org = '--organization="Texdoc #{TEXDOC_VERSION}"'
  sh "ronn -r #{opt_man} #{opt_org} texdoc.1.md 2> #{File::NULL}", verbose: false
  sh "groff -man -rS11 texdoc.1 | ps2pdf -sPAPERSIZE=a4 - texdoc.man1.pdf", verbose: false

  # finish
  FileUtils.cd(origin)
end

desc "Cleanup the Texdoc directroy"
task :clean do
  FileUtils.rm_rf("tmp")
  FileUtils.rm_f(Dir.glob("texdoc-*.zip"))
  FileUtils.cd("doc")
  sh "latexmk -C -quiet", verbose: false
  FileUtils.rm_f(["man/texdoc.1", "man/texdoc.man1.pdf"])
end

desc "Create archive for CTAN"
task :ctan do
  # generate documentation
  Rake::Task["doc"].invoke()

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
  man_dir = doc_dir.join("man")
  FileUtils.mkdir_p(target.join(man_dir))
  FileUtils.cp([doc_dir.join("texdoc.tex"), doc_dir.join("texdoc.pdf")], target.join(doc_dir))
  FileUtils.cp([man_dir.join("texdoc.1"), man_dir.join("texdoc.man1.pdf")], target.join(man_dir))

  # create zip archive
  sh "zip -q -r #{pkg_name}.zip #{target}", verbose: false
end

