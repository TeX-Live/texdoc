require 'aruba/rspec'
require 'pathname'

module Helplers
  # constants
  PWD = Pathname.pwd
  TEXDOC_SCRIPT_DIR = PWD + "script"
  TEXDOC_TLU = TEXDOC_SCRIPT_DIR + "texdoc.tlu"

  PATH = ENV["PATH"]
  TEXMFHOME = ENV["TEXMFHOME"]
  LC_ALL = "C"

  # running the target texdoc
  def run_texdoc(arg=[])
    if arg.kind_of?(Array)
      if arg.size > 0
        run "texlua #{TEXDOC_TLU} #{arg.join(' ')}"
      else
        run "texlua #{TEXDOC_TLU}"
      end
    else
      run "texlua #{TEXDOC_TLU} #{arg}"
    end
  end

  # use controlled environment
  def set_default_env
    # clear all
    ENV.clear

    # basics
    ENV["PATH"] = PATH
    ENV["TEXMFHOME"] = TEXMFHOME
    ENV["LC_ALL"] = LC_ALL

    # prevent to pop-up documents during testing
    viewer_list = ["PAGER", "MDVIEWER", "BROWSER", "DVIVIEWER", "PSVIEWER"]
    viewer_list.each { |v| ENV[v + "_texdoc"] = ":" }
  end
end
