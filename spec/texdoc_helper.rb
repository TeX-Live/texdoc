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
  def run_texdoc(*args)
    if args.size > 0
      run "texlua #{TEXDOC_TLU} #{args.join(' ')}"
    else
      run "texlua #{TEXDOC_TLU}"
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
    viewer_list = [
      "PAGER", "BROWSER", "DVIVIEWER", "PSVIEWER", "PDFVIEWER", "MDVIEWER"
    ]
    viewer_list.each { |v| ENV[v + "_texdoc"] = ":" }
  end

  # generate debug line
  def error_line(msg)
    return "texdoc error: #{msg}"
  end

  def debug_line(cat, msg="")
    if msg.empty?
      return "texdoc debug-#{cat}:"
    else
      return "texdoc debug-#{cat}: #{msg}"
    end
  end
end
