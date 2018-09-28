require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Viewing", :type => :aruba do
  include_context "doc"

  let(:stderr) { last_command_started.stderr.gsub("\r", "") }

  before(:all) { set_default_env }

  context "HTML file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_HTML }
    before(:each) { stop_all_commands }

    it "should be opend with the viewer_html" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_html" to open the file.')
    end
  end

  context "DVI file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_DVI }
    before(:each) { stop_all_commands }

    it "should be opend with the viewer_dvi" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_dvi" to open the file.')
    end
  end

  context "MD file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_MD }
    before(:each) { stop_all_commands }

    it "should be opend with the viewer_md" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_md" to open the file.')
    end
  end

  context "TXT file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_TXT }
    before(:each) { stop_all_commands }

    it "should be opend with the viewer_txt" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_txt" to open the file.')
    end
  end

  context "PDF file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_PDF }
    before(:each) { stop_all_commands }

    it "should be opend with the viewer_pdf" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_pdf" to open the file.')
    end
  end

  context "PS file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_PS }
    before(:each) { stop_all_commands }

    it "should be opend with the viewer_ps" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_ps" to open the file.')
    end
  end
end
