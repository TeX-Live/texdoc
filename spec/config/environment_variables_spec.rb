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

  let(:mock_viewer) { SpecHelplers::Texdoc::MOCK_VIEWER }

  if not OS.windows?
    context "BROWSER" do
      before(:each) { delete_environment_variable "BROWSER_texdoc" }
      before(:each) { set_environment_variable "BROWSER", mock_viewer }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_html=#{mock_viewer}", "BROWSER")
      end
    end
  end

  context "BROWSER_texdoc" do
    before(:each) { set_environment_variable "BROWSER", mock_viewer }
    before(:each) { set_environment_variable "BROWSER_texdoc", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to BROWSER" do
      expect(stderr).to include(set_env_line "viewer_html=#{mock_viewer}", "BROWSER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_html=#{mock_viewer}", "BROWSER")
    end
  end

  if not OS.windows?
    context "DVIVIEWER" do
      before(:each) { delete_environment_variable "DVIVIEWER_texdoc" }
      before(:each) { set_environment_variable "DVIVIEWER", mock_viewer }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_dvi=#{mock_viewer}", "DVIVIEWER")
      end
    end
  end

  context "DVIVIEWER_texdoc" do
    before(:each) { set_environment_variable "DVIVIEWER", mock_viewer }
    before(:each) { set_environment_variable "DVIVIEWER_texdoc", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to DVIVIEWER" do
      expect(stderr).to include(set_env_line "viewer_dvi=#{mock_viewer}", "DVIVIEWER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_dvi=#{mock_viewer}", "DVIVIEWER")
    end
  end

  if not OS.windows?
    context "MDVIEWER" do
      before(:each) { delete_environment_variable "MDVIEWER_texdoc" }
      before(:each) { set_environment_variable "MDVIEWER", mock_viewer }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_md=#{mock_viewer}", "MDVIEWER")
      end
    end
  end

  context "MDVIEWER_texdoc" do
    before(:each) { set_environment_variable "MDVIEWER", mock_viewer }
    before(:each) { set_environment_variable "MDVIEWER_texdoc", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to MDVIEWER" do
      expect(stderr).to include(set_env_line "viewer_md=#{mock_viewer}", "MDVIEWER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_md=#{mock_viewer}", "MDVIEWER")
    end
  end

  if not OS.windows?
    context "PAGER" do
      before(:each) { delete_environment_variable "PAGER_texdoc" }
      before(:each) { set_environment_variable "PAGER", mock_viewer }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_txt=#{mock_viewer}", "PAGER")
      end
    end
  end

  context "PAGER_texdoc" do
    before(:each) { set_environment_variable "PAGER", mock_viewer }
    before(:each) { set_environment_variable "PAGER_texdoc", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to PAGER" do
      expect(stderr).to include(set_env_line "viewer_txt=#{mock_viewer}", "PAGER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_txt=#{mock_viewer}", "PAGER")
    end
  end

  if not OS.windows?
    context "PDFVIEWER" do
      before(:each) { delete_environment_variable "PDFVIEWER_texdoc" }
      before(:each) { set_environment_variable "PDFVIEWER", mock_viewer }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_pdf=#{mock_viewer}", "PDFVIEWER")
      end
    end
  end

  context "PDFVIEWER_texdoc" do
    before(:each) { set_environment_variable "PDFVIEWER", mock_viewer }
    before(:each) { set_environment_variable "PDFVIEWER_texdoc", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to PDFVIEWER" do
      expect(stderr).to include(set_env_line "viewer_pdf=#{mock_viewer}", "PDFVIEWER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_pdf=#{mock_viewer}", "PDFVIEWER")
    end
  end


  if not OS.windows?
    context "PSVIEWER" do
      before(:each) { delete_environment_variable "PSVIEWER_texdoc" }
      before(:each) { set_environment_variable "PSVIEWER", mock_viewer }
      before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(set_env_line "viewer_ps=#{mock_viewer}", "PSVIEWER")
      end
    end
  end

  context "PSVIEWER_texdoc" do
    before(:each) { set_environment_variable "PSVIEWER", mock_viewer }
    before(:each) { set_environment_variable "PSVIEWER_texdoc", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective and given priority to PSVIEWER" do
      expect(stderr).to include(set_env_line "viewer_ps=#{mock_viewer}", "PSVIEWER_texdoc")
      expect(stderr).to include(ignore_env_line "viewer_ps=#{mock_viewer}", "PSVIEWER")
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

  if OS.mac?
    context "LC_ALL" do
      before(:each) { set_environment_variable "LC_ALL", "ja_JP.UTF-8" }
      before(:each) { run_texdoc "-dconfig", "texlive-en" }

      it "should be effective" do
        expect(stderr).to include(
          debug_line "config", 'Setting "lang=ja" from operating system locale.')
      end
    end
  else
    # TODO: test as well on Windows and Linux
  end

  # check if texdoc works when an environment variable contains colon
  # https://github.com/TeX-Live/texdoc/issues/48
  context "FIRST_OCCURRENCE_IN_COMMA_SEPARATED_VARIABLE" do
    before(:each) { set_environment_variable "BROWSER_texdoc", "#{mock_viewer}:should-be-truncated" }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be picked" do
      expect(stderr).to include(set_env_line "viewer_html=#{mock_viewer}", "BROWSER_texdoc")
    end
  end
end
