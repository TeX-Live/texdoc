# Rakefile for Texdoc.
# Public domain.

require 'rake/clean'
require 'pathname'

# basics
TEXDOC_VERSION = "3.0"
PKG_NAME = "texdoc-#{TEXDOC_VERSION}"

# woking/temporaly dirs
PWD = Pathname.pwd
TMP_DIR = PWD + "tmp"

# Texdoc files/dirs
TEXDOC_SCRIPT_DIR = PWD + "script"
TEXDOC_CNF = PWD + "texdoc.cnf"
TEXDOC_TLU = TEXDOC_SCRIPT_DIR + "texdoc.tlu"

# TEXMF
if system("which kpsewhich > #{File::NULL} 2> #{File::NULL}")
  texmf_home = `kpsewhich --var-value TEXMFHOME`.chomp
  texmf_var = `kpsewhich --var-value TEXMFVAR`.chomp
else
  # from ENV or dummy
  texmf_home = ENV["TEXMFHOME"] || "texmfhome"
  texmf_var = ENV["TEXMFVAR"] || "texmfvar"
end
TEXMFHOME = Pathname(texmf_home)
TEXMFVAR = Pathname(texmf_var)

TEXMFHOME_SCRIPTS_DIR = TEXMFHOME + "scripts"
TEXMFHOME_TEXDOC_DIR = TEXMFHOME + "texdoc"
directory TEXMFHOME_SCRIPTS_DIR
directory TEXMFHOME_TEXDOC_DIR

# symlinks
TEXDOC_LINK = TEXMFHOME_SCRIPTS_DIR + "texdoc"
TEXDOC_CNF_LINK = TEXMFHOME_TEXDOC_DIR + "texdoc-dist.cnf"

# pseudo TEXMF
PS_TEXMF = TMP_DIR + "texmf"
PS_TEXMF_SCRIPTS_DIR = PS_TEXMF + "scripts"
PS_TEXMF_TEXDOC_DIR = PS_TEXMF + "texdoc"
directory PS_TEXMF_SCRIPTS_DIR
directory PS_TEXMF_TEXDOC_DIR

PS_TEXDOC_LINK = PS_TEXMF_SCRIPTS_DIR + "texdoc"
PS_TEXDOC_CNF_LINK = PS_TEXMF_TEXDOC_DIR + "texdoc-dist.cnf"
file PS_TEXDOC_LINK => PS_TEXMF_SCRIPTS_DIR do
  ln_s TEXDOC_SCRIPT_DIR, PS_TEXDOC_LINK
end
file PS_TEXDOC_CNF_LINK => PS_TEXMF_TEXDOC_DIR do
  ln_s TEXDOC_CNF, PS_TEXDOC_CNF_LINK
end

# options for ronn
OPT_MAN = "--manual=\"Texdoc manual\""
OPT_ORG = "--organization=\"Texdoc #{TEXDOC_VERSION}\""
OPT_DATE = "--date=\"#{Time.now.strftime('%F')}\""

# cleaning
CLEAN.include(["doc/*", "tmp"])
CLEAN.exclude(["doc/*.md", "doc/*.tex", "doc/*.pdf"])
CLOBBER.include(["doc/*.pdf", "script/*.lua", "*.zip"])

desc "Install Texdoc to your system"
task :install => [TEXMFHOME_SCRIPTS_DIR, TEXMFHOME_TEXDOC_DIR] do
  # check the existence of the texdoc source
  fail "Directory #{TEXDOC_SCRIPT_DIR} does not exists" if !TEXDOC_SCRIPT_DIR.directory?
  fail "File #{TEXDOC_CNF} does not exists" if !TEXDOC_CNF.file?
  fail "File #{TEXDOC_TLU} does not exists" if !TEXDOC_TLU.file?

  # create the symbolic links
  fail "Local Texdoc is already installed" if TEXDOC_LINK.file? or TEXDOC_CNF_LINK.file?
  ln_s TEXDOC_SCRIPT_DIR, TEXDOC_LINK
  ln_s TEXDOC_CNF, TEXDOC_CNF_LINK
end

desc "Uninstall Texdoc from your system"
task :uninstall do
  # check the symlinks
  fail "#{TEXDOC_LINK} is not a symbolic link" if !TEXDOC_LINK.symlink?
  fail "#{TEXDOC_CNF_LINK} is not a symbolic link" if !TEXDOC_CNF_LINK.symlink?

  # check this Texdoc is installed to the system
  if TEXDOC_LINK.readlink != TEXDOC_SCRIPT_DIR or TEXDOC_CNF_LINK.readlink != TEXDOC_CNF
    fail("Another texdoc is installed; stop uninstalling")
  end

  # execute unlink
  safe_unlink [TEXDOC_LINK, TEXDOC_CNF_LINK]
end

desc "Run tests (only listed specs, if specified)"
task :test => [PS_TEXDOC_LINK, PS_TEXDOC_CNF_LINK] do |task, args|
  # use controlled environment
  ENV["TEXMFHOME"] = PS_TEXMF.to_s

  # check version
  sh "texlua #{TEXDOC_TLU} -f"

  # run rspec
  args = args.to_a
  if args.size > 0
    f_list = args.map{|f| "spec/#{f}_spec.rb"}.join(" ")
    sh "bundle exec rspec #{f_list}"
  else
    sh "bundle exec rspec"
  end
end

desc "Generate a pre-hashed cache file"
task :gen_datafile => [PS_TEXDOC_LINK, PS_TEXDOC_CNF_LINK] do
  # use controlled environment
  ENV["TEXMFHOME"] = PS_TEXMF.to_s

  # run Texdoc to generate a flesh cache file
  sh "texlua #{TEXDOC_TLU} -lM texlive-en > #{File::NULL}"

  # copy the cache file
  cp TEXMFVAR + "texdoc/cache-tlpdb.lua", TEXDOC_SCRIPT_DIR + "Data.tlpdb.lua"
end

desc "Generate all documentation"
task :doc do
  cd "doc"
  sh "latexmk -quiet texdoc.tex > #{File::NULL} 2> #{File::NULL}"
  sh "bundle exec ronn -r #{OPT_DATE} #{OPT_MAN} #{OPT_ORG} texdoc.1.md 2> #{File::NULL}"
end

desc "Preview the manpage"
task :man do
  cd "doc"
  sh "bundle exec ronn -m #{OPT_DATE} #{OPT_MAN} #{OPT_ORG} texdoc.1.md"
end

desc "Create an archive for CTAN"
task :ctan => :doc do
  # initialize the target
  TARGET_DIR = TMP_DIR + PKG_NAME
  TARGET_SCRIPT_DIR, TARGET_DOC_DIR = TARGET_DIR + "script", TARGET_DIR + "doc"
  rm_rf TARGET_DIR
  mkdir_p [TARGET_SCRIPT_DIR, TARGET_DOC_DIR]

  # copy all required files
  cd PWD
  cp ["COPYING", "README.md", "NEWS", "texdoc.cnf"], TARGET_DIR
  cp Dir.glob("script/*.tlu"), TARGET_SCRIPT_DIR

  docs = ["texdoc.tex", "texdoc.pdf", "texdoc.1"]
  docs.each do |name|
    cp "doc/#{name}", TARGET_DOC_DIR
  end

  # create zip archive
  cd TMP_DIR
  sh "zip -q -r #{PKG_NAME}.zip #{PKG_NAME}"
  mv "#{PKG_NAME}.zip", PWD
end

desc "Setup TeX Live on Travis CI"
task :setup_travis do
  # judge platform
  fail "This task only works on Travis CI" if not platform = ENV["TRAVIS_OS_NAME"]

  # install TeX Live if the cached version of TeX Live is not available
  if not system("which texlua > #{File::NULL} 2> #{File::NULL}")
    puts "* Installing TeX Live"

    # prepare the install dir
    HOME = ENV["HOME"]
    INSTALL_DIR = TMP_DIR + Time.now.strftime("%F")
    mkdir_p INSTALL_DIR
    cd INSTALL_DIR

    # download install-tl
    sh "wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
    sh "tar zxvf install-tl-unx.tar.gz"
    cd Dir.glob("install-tl-2018*")[0]

    # config
    profile = <<~EOF
      selected_scheme scheme-small
      TEXDIR #{HOME}/texlive
      TEXMFCONFIG #{HOME}/.texlive/texmf-config
      TEXMFHOME #{HOME}/texmf
      TEXMFLOCAL #{HOME}/texlive/texmf-local
      TEXMFSYSCONFIG #{HOME}/texlive/texmf-config
      TEXMFSYSVAR #{HOME}/texlive/texmf-var
      TEXMFVAR #{HOME}/.texlive/texmf-var
      option_src 0
    EOF

    if platform == "osx"
      File.open("texdoc.profile", "w") {|f| f.puts(profile + "binary_x86_64-darwin 1")}
    else
      File.open("texdoc.profile", "w") {|f| f.puts(profile + "binary_x86_64-linux 1")}
    end

    # run install script
    opt_profile = "-profile ./texdoc.profile"
    opt_repo = "-repository http://ctan.mirror.rafal.ca/systems/texlive/tlnet"
    sh "./install-tl #{opt_profile} #{opt_repo}"
    sh "tlmgr init-usertree"

    # finish
    cd PWD
    rm_rf INSTALL_DIR
  end
end

desc "Setup TeX Live on AppVeyor"
task :setup_appveyor do
  # judge platform
  fail "This task only works on AppVeyor" if not ENV["APPVEYOR"]

  # install TeX Live if the cached version of TeX Live is not available
  if not system("which texlua > #{File::NULL} 2> #{File::NULL}")
    puts "* Installing TeX Live"

    # prepare the install dir
    INSTALL_DIR = TMP_DIR + Time.now.strftime("%F")
    mkdir_p INSTALL_DIR
    cd INSTALL_DIR

    # download install-tl
    sh "curl -O http://ctan.mirror.rafal.ca/systems/texlive/tlnet/install-tl.zip"
    sh "unzip install-tl.zip"
    cd Dir.glob("install-tl-2018*")[0]

    # config
    profile = <<~EOF
      selected_scheme scheme-small
      TEXDIR /texlive
      TEXMFCONFIG /.texlive/texmf-config
      TEXMFHOME /texmf
      TEXMFLOCAL /texlive/texmf-local
      TEXMFSYSCONFIG /texlive/texmf-config
      TEXMFSYSVAR /texlive/texmf-var
      TEXMFVAR /.texlive/texmf-var
      binary_win32 1
      option_src 0
    EOF

    File.open("texdoc.profile", "w") {|f| f.puts(profile)}

    # run install script
    opt_profile = "-profile ./texdoc.profile"
    opt_repo = "-repository http://ctan.mirror.rafal.ca/systems/texlive/tlnet"
    sh "echo y | install-tl-windows.bat #{opt_profile} #{opt_repo}"
    sh "tlmgr.bat init-usertree"

    # finish
    cd PWD
    rm_rf INSTALL_DIR
  end
end
