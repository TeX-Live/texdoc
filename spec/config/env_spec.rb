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

  context "BROWSER" do
    before(:each) { delete_environment_variable "BROWSER_texdoc" }
    before(:each) { set_environment_variable "BROWSER", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(set_env_line "viewer_html=#{mock_viewer}", "BROWSER")
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

  # check if texdoc works when an environment variable contains colon
  # https://github.com/TeX-Live/texdoc/issues/48
  context "comma-separated list for BROWSER" do
    before(:each) {
      set_environment_variable "BROWSER_texdoc", "#{mock_viewer}:should-be-truncated"
    }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should pick the first occurrence" do
      expect(stderr).to include(set_env_line "viewer_html=#{mock_viewer}", "BROWSER_texdoc")
    end
  end

  context "DVIVIEWER" do
    before(:each) { delete_environment_variable "DVIVIEWER_texdoc" }
    before(:each) { set_environment_variable "DVIVIEWER", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(set_env_line "viewer_dvi=#{mock_viewer}", "DVIVIEWER")
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

  context "MDVIEWER" do
    before(:each) { delete_environment_variable "MDVIEWER_texdoc" }
    before(:each) { set_environment_variable "MDVIEWER", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(set_env_line "viewer_md=#{mock_viewer}", "MDVIEWER")
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

  context "PAGER" do
    before(:each) { delete_environment_variable "PAGER_texdoc" }
    before(:each) { set_environment_variable "PAGER", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(set_env_line "viewer_txt=#{mock_viewer}", "PAGER")
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

  context "PDFVIEWER" do
    before(:each) { delete_environment_variable "PDFVIEWER_texdoc" }
    before(:each) { set_environment_variable "PDFVIEWER", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(set_env_line "viewer_pdf=#{mock_viewer}", "PDFVIEWER")
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

  context "PSVIEWER" do
    before(:each) { delete_environment_variable "PSVIEWER_texdoc" }
    before(:each) { set_environment_variable "PSVIEWER", mock_viewer }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(set_env_line "viewer_ps=#{mock_viewer}", "PSVIEWER")
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

  context "LANGUAGE_texdoc" do
    before(:each) { set_environment_variable "LANGUAGE_texdoc", "ja" }
    before(:each) { set_environment_variable "LANGUAGE", "en" }
    before(:each) { set_environment_variable "LC_ALL", "en" }
    before(:each) { set_environment_variable "LANG", "en" }
    before(:each) { run_texdoc "-dconfig", "texlive-en" }

    it "should be effective and given priority to anything else" do
      expect(stderr).to include(set_env_line "lang=ja", "LANGUAGE_texdoc")
      expect(stderr).to include(ignore_env_line "lang=en", "LANGUAGE")
      expect(stderr).to include(ignore_env_line "lang=en", "LC_ALL")
      expect(stderr).to include(ignore_env_line "lang=en", "LANG")
    end
  end

  context "LANGUAGE" do
    before(:each) { set_environment_variable "LANGUAGE", "fr" }
    before(:each) { set_environment_variable "LC_ALL", "en" }
    before(:each) { set_environment_variable "LANG", "en" }
    before(:each) { run_texdoc "-dconfig", "texlive-en" }

    it "should be effective and given priority to anything but LANGUAGE_texdoc" do
      expect(stderr).to include(set_env_line "lang=fr", "LANGUAGE")
      expect(stderr).to include(ignore_env_line "lang=en", "LC_ALL")
      expect(stderr).to include(ignore_env_line "lang=en", "LANG")
    end
  end

  context "LC_ALL" do
    before(:each) { set_environment_variable "LC_ALL", "ja_JP.UTF-8" }
    before(:each) { run_texdoc "-dconfig", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(set_env_line "lang=ja", "LC_ALL")
    end
  end

  context "LANG" do
    before(:each) { set_environment_variable "LC_ALL", "Japanese_Japan.932" }
    before(:each) { set_environment_variable "LANG", "en_US.UTF-8" }
    before(:each) { run_texdoc "-dconfig", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(set_env_line "lang=en", "LANG")
    end
  end
end
