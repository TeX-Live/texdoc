require 'aruba/rspec'
require 'pathname'
require 'fileutils'

module SpecHelplers
  module Texdoc
    # constants
    PWD = Pathname.pwd
    TEXDOC_SCRIPT_DIR = PWD / "script"
    TEXDOC_TLU = TEXDOC_SCRIPT_DIR / "texdoc.tlu"

    PATH = ENV["PATH"]
    TEXMFHOME = ENV["TEXMFHOME"]
    LC_ALL = "C"

    MOCK_VIEWER = "true"

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

    # use controlled environment
    def set_default_env
      # clear all
      ENV.clear

      # basic ENVs
      ENV["PATH"] = PATH
      ENV["TEXMFHOME"] = TEXMFHOME
      ENV["LC_ALL"] = LC_ALL

      # prevent to pop-up documents during testing
      viewer_list = [
        "PAGER", "BROWSER", "DVIVIEWER", "PSVIEWER", "PDFVIEWER", "MDVIEWER"
      ]
      viewer_list.each { |v| ENV[v + "_texdoc"] = MOCK_VIEWER }
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelplers::Texdoc
  config.before(:each) { set_default_env }
end
