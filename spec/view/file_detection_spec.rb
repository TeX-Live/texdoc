require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "File detection for viewing", :type => :aruba do
  include_context "messages"
  include_context "sample_files"

  before(:all) { set_default_env }

  context "File *.html" do
    before(:each) do
      sample_html = cleate_sample_file "html"
      run_texdoc "-dview --just-view", sample_html
      stop_all_commands
    end

    it "should be opened with the viewer_html" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_html" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "File *.htm" do
    before(:each) do
      sample_htm = cleate_sample_file "htm"
      run_texdoc "-dview --just-view", sample_htm
      stop_all_commands
    end

    it "should be opened with the viewer_html" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_html" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "File *.dvi" do
    before(:each) do
      sample_dvi = cleate_sample_file "dvi"
      run_texdoc "-dview --just-view", sample_dvi
      stop_all_commands
    end

    it "should be opened with the viewer_dvi" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_dvi" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "File *.md" do
    before(:each) do
      sample_md = cleate_sample_file "md"
      run_texdoc "-dview --just-view", sample_md
      stop_all_commands
    end

    it "should be opened with the viewer_md" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_md" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "File *.txt" do
    before(:each) do
      sample_txt = cleate_sample_file "txt"
      run_texdoc "-dview --just-view", sample_txt
      stop_all_commands
    end

    it "should be opened with the viewer_txt" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_txt" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "File *.pdf" do
    before(:each) do
      sample_pdf = cleate_sample_file "pdf"
      run_texdoc "-dview --just-view", sample_pdf
      stop_all_commands
    end

    it "should be opened with the viewer_pdf" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_pdf" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "File *.ps" do
    before(:each) do
      sample_ps = cleate_sample_file "ps"
      run_texdoc "-dview --just-view", sample_ps
      stop_all_commands
    end

    it "should be opened with the viewer_ps" do
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_ps" to open the file.')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "File *.tex" do
    before(:each) do
      sample_tex = cleate_sample_file "tex"
      run_texdoc "-dview --just-view", sample_tex
      stop_all_commands
    end

    it "should be opened with the viewer_txt (fallback)" do
      expect(stderr).to include(
        warning_line 'No viewer defined for ".tex" files, using "viewer_txt" instead.')
      expect(last_command_started).to be_successfully_executed
    end
  end
end
