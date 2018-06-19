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
  def run_texdoc(arg)
    run "texlua #{TEXDOC_TLU} #{arg}"
  end

  # use controlled environment
  def set_default_env
    # clear all
    ENV.clear

    # set the default values
    ENV["PATH"] = PATH
    ENV["TEXMFHOME"] = TEXMFHOME
    ENV["LC_ALL"] = LC_ALL
  end
end
