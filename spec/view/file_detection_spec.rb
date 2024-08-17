require 'spec_helper'

RSpec.describe "File type", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  context "*.html" do
    before(:each) do
      run_texdoc "-dview --just-view", sample_html
    end

    it "should be opened with the viewer_html" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_html" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "*.htm" do
    before(:each) do
      run_texdoc "-dview --just-view", sample_htm
    end

    it "should be opened with the viewer_html" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_html" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "*.dvi" do
    before(:each) do
      run_texdoc "-dview --just-view", sample_dvi
    end

    it "should be opened with the viewer_dvi" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_dvi" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "*.md" do
    before(:each) do
      run_texdoc "-dview --just-view", sample_md
    end

    it "should be opened with the viewer_md" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_md" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "*.txt" do
    before(:each) do
      run_texdoc "-dview --just-view", sample_txt
    end

    it "should be opened with the viewer_txt" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_txt" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "*.pdf" do
    before(:each) do
      run_texdoc "-dview --just-view", sample_pdf
    end

    it "should be opened with the viewer_pdf" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_pdf" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "*.ps" do
    before(:each) do
      run_texdoc "-dview --just-view", sample_ps
    end

    it "should be opened with the viewer_ps" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_ps" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "*.tex" do
    before(:each) do
      run_texdoc "-dview --just-view", sample_tex
    end

    it "should be opened with the viewer_txt as fallback" do
      expect(stderr).to include(
        warning_line 'No viewer defined for ".tex" files, using "viewer_txt" instead.')
      expect(last_command_started).to be_successfully_executed
    end
  end
end
