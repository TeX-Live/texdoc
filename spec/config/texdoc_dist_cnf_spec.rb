require 'spec_helper'

RSpec.describe "In the shipped texdoc.cnf", :type => :aruba do
  include_context "messages"
  include_context "texmf"


  context "when it loaded" do
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should not have any syntax error" do
      expect(stderr).not_to include(
        warning_line "syntax error in #{normalize_path(texdoc_dist_cnf)}")
      expect(stderr).to include(
        set_from_file_line "lastfile_switch=true", texdoc_dist_cnf)
      expect(stderr).to include(
        debug_line "files", "active\t#{normalize_path(texdoc_dist_cnf)}")
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "config item \"lastfile_switch\"" do
    let(:config_content) {
      <<~EOF
        lastfile_switch = true
      EOF
    }

    before(:each) { File.write(texdoc_cnf, config_content) }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should disable other config files" do
      expect(stderr).to include(
        set_from_file_line "lastfile_switch=true", texdoc_cnf)
      expect(stderr).to include(
        debug_line "files", "disabled\t#{normalize_path(texdoc_dist_cnf)}")
      expect(last_command_started).to be_successfully_executed
    end
  end
end
