require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Viewing", :type => :aruba do
  include_context "doc"

  before(:all) { set_default_env }

  let(:stderr) { last_command_started.stderr }

  context "HTML file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_HTML }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it {
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_html" to open the file.')
    }
  end

  context "DVI file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_DVI }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it {
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_dvi" to open the file.')
    }
  end

  context "MD file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_MD }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it {
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_md" to open the file.')
    }
  end

  context "TXT file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_TXT }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it {
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_txt" to open the file.')
    }
  end

  context "PDF file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_PDF }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it {
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_pdf" to open the file.')
    }
  end

  context "PS file" do
    before(:each) { run_texdoc "-dview --just-view", SAMPLE_PS }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it {
      expect(stderr).to include(
        debug_line "view", 'Using "viewer_ps" to open the file.')
    }
  end
end
