require 'os'
require 'spec_helper'

RSpec.describe "Environment variable", :type => :aruba do
  include_context "messages"

  def set_env_line(config, env)
    debug_line "config",
      "Setting \"#{config}\" from environment variable \"#{env}\"."
  end
  def ignore_env_line(config, env)
    debug_line "config",
      "Ignoring \"#{config}\" from environment variable \"#{env}\"."
  end

  if not OS.windows?
    context "BROWSER" do
      before(:each) { delete_environment_variable "BROWSER_texdoc" }
      before(:each) { set_environment_variable "BROWSER", ":" }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_html=:", "BROWSER")
      end
    end
  end

  context "BROWSER_texdoc" do
    before(:each) { set_environment_variable "BROWSER", ":" }
    before(:each) { set_environment_variable "BROWSER_texdoc", ":" }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to BROWSER" do
      expect(stderr).to include(set_env_line "viewer_html=:", "BROWSER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_html=:", "BROWSER")
    end
  end

  if not OS.windows?
    context "DVIVIEWER" do
      before(:each) { delete_environment_variable "DVIVIEWER_texdoc" }
      before(:each) { set_environment_variable "DVIVIEWER", ":" }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_dvi=:", "DVIVIEWER")
      end
    end
  end

  context "DVIVIEWER_texdoc" do
    before(:each) { set_environment_variable "DVIVIEWER", ":" }
    before(:each) { set_environment_variable "DVIVIEWER_texdoc", ":" }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to DVIVIEWER" do
      expect(stderr).to include(set_env_line "viewer_dvi=:", "DVIVIEWER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_dvi=:", "DVIVIEWER")
    end
  end

  if not OS.windows?
    context "MDVIEWER" do
      before(:each) { delete_environment_variable "MDVIEWER_texdoc" }
      before(:each) { set_environment_variable "MDVIEWER", ":" }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_md=:", "MDVIEWER")
      end
    end
  end

  context "MDVIEWER_texdoc" do
    before(:each) { set_environment_variable "MDVIEWER", ":" }
    before(:each) { set_environment_variable "MDVIEWER_texdoc", ":" }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to MDVIEWER" do
      expect(stderr).to include(set_env_line "viewer_md=:", "MDVIEWER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_md=:", "MDVIEWER")
    end
  end

  if not OS.windows?
    context "PAGER" do
      before(:each) { delete_environment_variable "PAGER_texdoc" }
      before(:each) { set_environment_variable "PAGER", ":" }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_txt=:", "PAGER")
      end
    end
  end

  context "PAGER_texdoc" do
    before(:each) { set_environment_variable "PAGER", ":" }
    before(:each) { set_environment_variable "PAGER_texdoc", ":" }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to PAGER" do
      expect(stderr).to include(set_env_line "viewer_txt=:", "PAGER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_txt=:", "PAGER")
    end
  end

  if not OS.windows?
    context "PDFVIEWER" do
      before(:each) { delete_environment_variable "PDFVIEWER_texdoc" }
      before(:each) { set_environment_variable "PDFVIEWER", ":" }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_pdf=:", "PDFVIEWER")
      end
    end
  end

  context "PDFVIEWER_texdoc" do
    before(:each) { set_environment_variable "PDFVIEWER", ":" }
    before(:each) { set_environment_variable "PDFVIEWER_texdoc", ":" }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to PDFVIEWER" do
      expect(stderr).to include(set_env_line "viewer_pdf=:", "PDFVIEWER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_pdf=:", "PDFVIEWER")
    end
  end


  if not OS.windows?
    context "PSVIEWER" do
      before(:each) { delete_environment_variable "PSVIEWER_texdoc" }
      before(:each) { set_environment_variable "PSVIEWER", ":" }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_ps=:", "PSVIEWER")
      end
    end
  end

  context "PSVIEWER_texdoc" do
    before(:each) { set_environment_variable "PSVIEWER", ":" }
    before(:each) { set_environment_variable "PSVIEWER_texdoc", ":" }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to PSVIEWER" do
      expect(stderr).to include(set_env_line "viewer_ps=:", "PSVIEWER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_ps=:", "PSVIEWER")
    end
  end

  # NOTE: We skip some examples on Windows because Aruba has a bug with
  #       the "delete_environment_variable" method on the platform.
  #       cf. https://github.com/cucumber/aruba/issues/349

  context "TEXDOCS" do
    before(:each) { set_environment_variable "TEXDOCS", "test1,!!test2//" }
    before(:each) { run_texdoc "-dtexdocs", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(
        debug_line "texdocs",
          "texdocs[2] = test1 (index_mandatory=false, recursion_allowed=false)")
      expect(stderr).to include(
        debug_line "texdocs",
          "texdocs[1] = test2 (index_mandatory=true, recursion_allowed=true)")
    end
  end

  if OS.windows?
    # TODO: support locale on Windows
  else
    context "LC_ALL" do
      before(:each) { set_environment_variable "LC_ALL", "ja_JP.UTF-8" }
      before(:each) { run_texdoc "-dconfig", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(
          debug_line "config", 'Setting "lang=ja" from operating system locale.')
      end
    end
  end
end
