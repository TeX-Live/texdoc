require 'aruba/rspec'
require 'pathname'
require 'fileutils'

module SpecHelplers
  module Texdoc
    # from repository
    REPO_ROOT = Pathname.pwd

    TEXDOC_SCRIPT_DIR = REPO_ROOT / "script"
    TEXDOC_TLU = TEXDOC_SCRIPT_DIR / "texdoc.tlu"

    REPO_TMP_DIR = REPO_ROOT / "tmp"

    REPO_TEXMF = REPO_TMP_DIR / "texmf"
    REPO_TEXMF_DIST = REPO_TMP_DIR / "texmf-dist"
    REPO_TEXLIVE_TLPDB = REPO_TMP_DIR / "texlive.tlpdb"

    # for testing
    HOME_DIR = REPO_TMP_DIR / "aruba"

    PS_TEXMF = HOME_DIR / "texmf"
    PS_TEXMF_DIST = HOME_DIR / "texmf-dist"
    PS_TEXMF_VAR = HOME_DIR / "texmf-var"

    # mock
    MOCK_VIEWER = "true"

    # prevent to pop-up documents during testing
    def setup_mock_viewers
      viewer_list = [
        "PAGER",
        "BROWSER",
        "DVIVIEWER",
        "PSVIEWER",
        "PDFVIEWER",
        "MDVIEWER"
      ]
      viewer_list.each { |v| ENV[v + "_texdoc"] = MOCK_VIEWER }
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
