require 'spec_helper'

RSpec.describe "Config files for Texdoc", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  context "config lines in texdoc.cnf" do
    let(:config_content) {
      <<~EOF
        suffix_list = foo, bar, baz
        fuzzy_level = 1
        online_url = https://ctan.org
        lastfile_switch = false
      EOF
    }

    before(:each) { File.write(texdoc_cnf, config_content) }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(
        set_from_file_line "suffix_list=foo, bar, baz", texdoc_cnf)
      expect(stderr).to include(
        set_from_file_line "fuzzy_level=1", texdoc_cnf)
      expect(stderr).to include(
        set_from_file_line "online_url=https://ctan.org", texdoc_cnf)
      expect(stderr).to include(
        set_from_file_line "lastfile_switch=false", texdoc_cnf)
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "tailing backslash in texdoc.cnf" do
    let(:config_content) {
      <<~EOF
        suffix_list = foo, bar, baz, \\
                      foobar
      EOF
    }

    before(:each) { File.write(texdoc_cnf, config_content) }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should continue the line" do
      expect(stderr).to include(
        set_from_file_line "suffix_list=foo, bar, baz, foobar", texdoc_cnf)
    end
  end

  context "containes invalid line" do
    let(:config_content) {
      <<~EOF
        XXX
      EOF
    }

    before(:each) { File.write(texdoc_cnf, config_content) }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be warned" do
      expect(stderr).to include(
        warning_line "syntax error in #{normalize_path(texdoc_cnf)}")
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "config item set by a command-line option" do
    let(:config_content) {
      <<~EOF
        machine_switch = false
      EOF
    }

    before(:each) { File.write(texdoc_cnf, config_content) }
    before(:each) { run_texdoc "-dconfig", "-lI", "-M", "texlive-en" }

    it "should be ignored" do
      expect(stderr).to include(
        set_from_cl_line "machine_switch=true", "-M")
      expect(stderr).to include(
        ignore_from_file_line "machine_switch=false", texdoc_cnf)
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "config item set by an environment variable" do
    let(:config_content) {
      <<~EOF
        lang = en
      EOF
    }

    before(:each) { set_environment_variable "LANGUAGE_texdoc", "ja" }
    before(:each) { File.write(texdoc_cnf, config_content) }
    before(:each) { run_texdoc "-dconfig", "-lI", "texlive-en" }

    it "should be ignored" do
      expect(stderr).to include(
        set_from_env_line "lang=ja", "LANGUAGE_texdoc")
      expect(stderr).to include(
        ignore_from_file_line "lang=en", texdoc_cnf)
      expect(last_command_started).to be_successfully_executed
    end
  end
end
