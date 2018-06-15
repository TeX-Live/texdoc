require 'aruba/rspec'
require 'pathname'

module Helplers
  PWD = Pathname.pwd
  TEXDOC_SCRIPT_DIR = PWD + "script"
  TEXDOC_TLU = TEXDOC_SCRIPT_DIR + "texdoc.tlu"

  def run_texdoc(arg)
    run "texlua #{TEXDOC_TLU} #{arg}"
  end

  def set_default_env
    ENV["LC_ALL"] = "C"
  end
end
