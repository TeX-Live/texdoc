require 'aruba/rspec'
require 'pathname'
require 'fileutils'

module SpecHelplers
  module Texdoc
    # from repository
    BASE_DIR = Pathname.pwd

    TEXDOC_SCRIPT_DIR = BASE_DIR / "script"
    TEXDOC_TLU = TEXDOC_SCRIPT_DIR / "texdoc.tlu"

    TMP_DIR = BASE_DIR / "tmp"

    REPO_TEXMF = TMP_DIR / "texmf"
    REPO_TEXMF_DIST = TMP_DIR / "texmf-dist"
    REPO_TEXLIVE_TLPDB = TMP_DIR / "texlive.tlpdb"

    # for testing
    HOME_DIR = TMP_DIR / "aruba"

    PS_TEXMF = HOME_DIR / "texmf"
    PS_TEXMF_DIST = HOME_DIR / "texmf-dist"
    PS_TEXMF_VAR = HOME_DIR / "texmf-var"

    # mock
    MOCK_VIEWER = "true"

    # prevent to pop-up documents during testing
    def setup_mock_viewers
      set_environment_variable "PAGER_texdoc", MOCK_VIEWER
      set_environment_variable "BROWSER_texdoc", MOCK_VIEWER
      set_environment_variable "DVIVIEWER_texdoc", MOCK_VIEWER
      set_environment_variable "PSVIEWER_texdoc", MOCK_VIEWER
      set_environment_variable "PDFVIEWER_texdoc", MOCK_VIEWER
      set_environment_variable "MDVIEWER_texdoc", MOCK_VIEWER
    end

    # setup TEXMF trees
    def setup_texmf_trees
      FileUtils.cp_r(REPO_TEXMF, HOME_DIR)
      FileUtils.cp_r(REPO_TEXMF_DIST, HOME_DIR)

      set_environment_variable "TEXMFHOME", PS_TEXMF.to_s
      set_environment_variable "TEXMFVAR", PS_TEXMF_VAR.to_s
      # WARNING: leave TEXMFDIST as is for searching local TeX Live docs
    end

    # running the target texdoc
    def run_texdoc(*args, interactive: false)
      # constract the arguments
      arg_str = ""
      arg_str = " " + args.join(" ") if args.size > 0

      # execute the command
      run_command "texlua #{TEXDOC_TLU}" + arg_str

      # stop the command automatically if not interactive execution
      stop_all_commands if !interactive
    end

    # path utility
    def normalize_path path
      pathname = path.to_s

      if OS.windows?
        pathname[0] = pathname[0].downcase
        return pathname.gsub("/", "\\")
      else
        return pathname
      end
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelplers::Texdoc

  config.before(:each) do
    setup_mock_viewers
    setup_texmf_trees
  end
end
