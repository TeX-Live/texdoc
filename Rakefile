# Rakefile for Texdoc.
# Public domain.

require 'rake'
require 'pathname'
require 'fileutils'

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
  FileUtils.mkdir_p([texmf_scripts, texmf_texdoc], verbose: true)

  # create the symbolic links
  FileUtils.ln_s(texdoc_scriptdir, texmf_scripts.join("texdoc"), verbose: true)
  FileUtils.ln_s(texdoc_cnf, texmf_texdoc.join("texdoc-dist.cnf"), verbose: true)
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
  FileUtils.safe_unlink([texdoc, texdoc_cnf], verbose: true)
end

desc "Run all tests"
task :test do
  sh "bundle exec rspec"
end

desc "Cleanup the Texdoc directroy"
task :clean do
  FileUtils.rm_rf("tmp", verbose: true)
  FileUtils.cd("doc")
  sh "latexmk -C -quiet"
end

desc "Create archive for CTAN"
task :ctan do
  # not yet
end
