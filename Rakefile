# Rakefile for Texdoc.
# Public domain.
require 'rake/clean'
require 'pathname'
require 'optparse'
require 'date'

# basics
TEXDOC_VERSION = "3.2.1"
PKG_NAME = "texdoc-#{TEXDOC_VERSION}"

# woking/temporaly dirs
PWD = Pathname.pwd
TMP_DIR = PWD / "tmp"

# Texdoc files/dirs
TEXDOC_SCRIPT_DIR = PWD / "script"
TEXDOC_CNF = PWD / "texdoc.cnf"
TEXDOC_TLU = TEXDOC_SCRIPT_DIR / "texdoc.tlu"

# output dir
OUTPUT_DIR = PWD / "output"
directory OUTPUT_DIR

# TEXMF
if system("which kpsewhich > #{File::NULL} 2> #{File::NULL}")
  texmf_root = `kpsewhich --var-value TEXMFROOT`.chomp
  texmf_home = `kpsewhich --var-value TEXMFHOME`.chomp
  texmf_var = `kpsewhich --var-value TEXMFVAR`.chomp
else
  # from ENV or dummy
  texmf_root = ENV["TEXMFROOT"] || "texmfroot"
  texmf_home = ENV["TEXMFHOME"] || "texmfhome"
  texmf_var = ENV["TEXMFVAR"] || "texmfvar"
end
TEXMFROOT = Pathname(texmf_root)
TEXMFHOME = Pathname(texmf_home)
TEXMFVAR = Pathname(texmf_var)

TEXMFHOME_SCRIPTS_DIR = TEXMFHOME / "scripts"
TEXMFHOME_TEXDOC_DIR = TEXMFHOME / "texdoc"
directory TEXMFHOME_SCRIPTS_DIR
directory TEXMFHOME_TEXDOC_DIR

# symlinks
TEXDOC_LINK = TEXMFHOME_SCRIPTS_DIR / "texdoc"
TEXDOC_CNF_LINK = TEXMFHOME_TEXDOC_DIR / "texdoc-dist.cnf"

# pseudo TEXMF
PS_TEXMF = TMP_DIR / "texmf"
PS_TEXMF_SCRIPTS_DIR = PS_TEXMF / "scripts"
PS_TEXMF_TEXDOC_DIR = PS_TEXMF / "texdoc"
directory PS_TEXMF_SCRIPTS_DIR
directory PS_TEXMF_TEXDOC_DIR

PS_TEXDOC_LINK = PS_TEXMF_SCRIPTS_DIR / "texdoc"
PS_TEXDOC_CNF_LINK = PS_TEXMF_TEXDOC_DIR / "texdoc-dist.cnf"
file PS_TEXDOC_LINK => PS_TEXMF_SCRIPTS_DIR do
  ln_s TEXDOC_SCRIPT_DIR, PS_TEXDOC_LINK
end
file PS_TEXDOC_CNF_LINK => PS_TEXMF_TEXDOC_DIR do
  ln_s TEXDOC_CNF, PS_TEXDOC_CNF_LINK
end

# link to texlive.tlpdb
PS_TEXLIVE_TLPDB = TMP_DIR / "texlive.tlpdb"
file PS_TEXLIVE_TLPDB do
  ln_s TEXMFROOT / "tlpkg/texlive.tlpdb", PS_TEXLIVE_TLPDB
end

# sample files
SAMPLE_DOC_DIR = PS_TEXMF / "doc/sample"
directory SAMPLE_DOC_DIR

SAMPLE_FILES = []
["html", "htm", "dvi", "md", "txt", "pdf", "ps", "tex"].each do |ext|
  sample_file = SAMPLE_DOC_DIR / "sample.#{ext}"
  file sample_file => SAMPLE_DOC_DIR do
    touch sample_file
  end
  SAMPLE_FILES << sample_file
end

# dummy texdoc.cnf
PS_TEXMFDIST = TMP_DIR / "texmf-dist"
PS_TEXMFDIST_TEXDOC_DIR = PS_TEXMFDIST / "texdoc"
directory PS_TEXMFDIST_TEXDOC_DIR

DUMMY_TEXDOC_CNFS = []
[PS_TEXMF_TEXDOC_DIR, PS_TEXMFDIST_TEXDOC_DIR].each do |texmf|
  texdoc_cnf = texmf / "texdoc.cnf"
  file texdoc_cnf => texmf do touch texdoc_cnf end
  DUMMY_TEXDOC_CNFS << texdoc_cnf
end

# options for ronn
OPT_MAN = "--manual=\"Texdoc manual\""
OPT_ORG = "--organization=\"Texdoc #{TEXDOC_VERSION}\""
OPT_DATE = "--date=\"#{Time.now.strftime('%F')}\""

# cleaning
CLEAN.include(["doc/*", "tmp"])
CLEAN.exclude(["doc/*.md", "doc/*.cls", "doc/*.tex", "doc/*.pdf", "doc/*.1"])
CLOBBER.include(["doc/*.pdf", "doc/*.1", "script/*.lua", "*.zip"])

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

desc "Run tests [options available]"
task :test =>
    [PS_TEXDOC_LINK, PS_TEXDOC_CNF_LINK, PS_TEXLIVE_TLPDB] +
    SAMPLE_FILES + DUMMY_TEXDOC_CNFS do
  # parse options
  options = {}
  if ARGV.delete("--")
    OptionParser.new do |opts|
      opts.banner = "Usage: rake test [-- OPTION...]"
      opts.on("-o", "--opts=OPTS", "Pass OPTS to RSpec") do |args|
        options[:args] = args
      end
      opts.on("-l", "--list=LIST", "Load only specified specs in LIST") do |args|
        options[:list] = args
      end
    end.parse!(ARGV)
  end

  # use controlled environment
  ENV["TEXMFHOME"] = PS_TEXMF.to_s

  # check version
  sh "texlua #{TEXDOC_TLU} -f"

  # construct options
  opt_args = if options[:args]
    " " + options[:args].strip
  else
    ""
  end
  opt_files = if options[:list]
    " " + options[:list].split(",").map{|i|"spec/#{i.strip}_spec.rb"}.join(" ")
  else
    ""
  end

  # run rspec
  begin
    sh "bundle exec rspec" + opt_args + opt_files
  rescue
    # show outputs if failed
    log_file = TMP_DIR / "rspec.log"
    sh "cat #{log_file}", verbose: false
    fail
  end

  # make sure to end this process
  exit 0
end

desc "Run Texdoc without installing [options available]"
task :run_texdoc => [PS_TEXDOC_LINK, PS_TEXDOC_CNF_LINK] do
  # parse options
  options = {}
  if ARGV.delete("--")
    OptionParser.new do |opts|
      opts.banner = "Usage: rake run_texdoc [-- OPTION...]"
      opts.on("-a", "--args=ARGS", "Pass ARGS to Texdoc") do |args|
        options[:args] = args
      end
    end.parse!(ARGV)
  end

  # use controlled environment
  ENV["TEXMFHOME"] = PS_TEXMF.to_s

  # run texdoc
  sh "texlua #{TEXDOC_TLU} #{options[:args]}"

  # make sure to end this process
  exit 0
end

desc "Generate a pre-hashed cache file [options available]"
task :gen_datafile => [PS_TEXDOC_LINK, PS_TEXDOC_CNF_LINK] do
  # parse options
  options = {}
  if ARGV.delete("--")
    OptionParser.new do |opts|
      opts.banner = "Usage: rake gen_datafile [-- OPTION...]"
      opts.on("--tlpdb=PATH", "Use texlive.tlpdb at PATH") do |args|
        options[:tlpdb] = args
      end
    end.parse!(ARGV)
  end

  # use controlled environment
  ENV["TEXMFHOME"] = PS_TEXMF.to_s

  # determine command line option for texdoc
  if options[:tlpdb]
    clo = "-c 'texlive_tlpdb=#{options[:tlpdb]}' -lM"
  else
    clo = "-lM"
  end

  # run Texdoc to generate a flesh cache file
  sh "texlua #{TEXDOC_TLU} #{clo} texlive-en > #{File::NULL}"

  # copy the cache file
  cp TEXMFVAR / "texdoc/cache-tlpdb.lua", TEXDOC_SCRIPT_DIR / "Data.tlpdb.lua"

  # make sure to end this process
  exit 0
end

desc "Save some outputs of Texdoc"
task :save_output => [PS_TEXDOC_LINK, PS_TEXDOC_CNF_LINK, OUTPUT_DIR] do
  # settings
  @output_file = OUTPUT_DIR / DateTime.now.strftime('%Y%m%d-%H%M%S.txt')
  queries = %w(texlive-en texdoc bxjscls tikz latex)

  def file_puts msg=""
    File.open(@output_file, 'a') do |file|
      file.puts msg
    end
  end

  # use controlled environment
  ENV["TEXMFHOME"] = PS_TEXMF.to_s
  
  # save the outputs
  queries.each do |q|
    file_puts "* texdoc -lM #{q}"
    sh "texlua #{TEXDOC_TLU} -qlM #{q} >> #{@output_file}"
    file_puts
  end
end

desc "Generate all documentation"
task :doc do
  cd "doc"
  sh "llmk texdoc.tex > #{File::NULL} 2> #{File::NULL}"
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
  TARGET_DIR = TMP_DIR / PKG_NAME
  TARGET_SCRIPT_DIR, TARGET_DOC_DIR = TARGET_DIR / "script", TARGET_DIR / "doc"
  rm_rf TARGET_DIR
  mkdir_p [TARGET_SCRIPT_DIR, TARGET_DOC_DIR]

  # copy all required files
  cd PWD
  cp ["COPYING", "README.md", "NEWS", "texdoc.cnf"], TARGET_DIR
  cp Dir.glob("script/*.tlu"), TARGET_SCRIPT_DIR

  docs = ["texdoc-doc.cls", "texdoc.tex", "texdoc.pdf", "texdoc.1"]
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

    # install dependencies for the installer
    if platform == "osx"
      sh "brew install lz4"
    end

    # prepare the install dir
    HOME = ENV["HOME"]
    INSTALL_DIR = TMP_DIR / Time.now.strftime("%F")
    mkdir_p INSTALL_DIR
    cd INSTALL_DIR

    # download install-tl
    sh "wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
    sh "tar zxvf install-tl-unx.tar.gz"
    cd Dir.glob("install-tl-20[0-9][0-9]*")[0]

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
    INSTALL_DIR = TMP_DIR / Time.now.strftime("%F")
    mkdir_p INSTALL_DIR
    cd INSTALL_DIR

    # download install-tl
    sh "curl -O http://ctan.mirror.rafal.ca/systems/texlive/tlnet/install-tl.zip"
    sh "unzip install-tl.zip"
    cd Dir.glob("install-tl-20[0-9][0-9]*")[0]

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
