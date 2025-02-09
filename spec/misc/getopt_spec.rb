require 'spec_helper'

RSpec.describe "The command-line option parser", :type => :aruba do
  include_context "messages"

  context "with an argument" do
    before(:each) { run_texdoc "texlive-en" }

    it { expect(last_command_started).to be_successfully_executed }
  end

  context "with -D" do
    before(:each) { run_texdoc "-D", "texlive-en" }

    it "should activate all debug categories" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_from_cl_line "debug_list=all", "-D")
    end
  end

  context "with --debug" do
    before(:each) { run_texdoc "--debug", "texlive-en" }

    it "should activate all debug categories" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_from_cl_line "debug_list=all", "--debug")
    end
  end

  context "with -dconfig" do
    before(:each) { run_texdoc "-dconfig", "texlive-en" }

    it 'should activate only debug category "config"' do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_from_cl_line "debug_list=config", "-d")
    end
  end

  context "with --debug=config" do
    before(:each) { run_texdoc "--debug=config", "texlive-en" }

    it 'should activate only debug category "config"' do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_from_cl_line "debug_list=config", "--debug")
    end
  end

  context "with -dconfig -lIv" do
    before(:each) { run_texdoc "-dconfig", "-lIv", "texlive-en" }

    it "all specified options should be effective" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_from_cl_line "debug_list=config", "-d")
      expect(stderr).to include(set_from_cl_line "mode=list", "-l")
      expect(stderr).to include(set_from_cl_line "interact_switch=false", "-I")
      expect(stderr).to include(set_from_cl_line "verbosity_level=3", "-v")
    end
  end

  context "with -dconfig -wmls" do
    before(:each) { run_texdoc "-dconfig", "-wmls", "texlive-en" }

    it "only -w should be effective and others should not be" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_from_cl_line "mode=view", "-w")
      expect(stderr).to include(ignore_from_cl_line "mode=mixed", "-m")
      expect(stderr).to include(ignore_from_cl_line "mode=list", "-l")
      expect(stderr).to include(ignore_from_cl_line "mode=showall", "-s")
    end
  end

  context "with -D -Mdconfig" do
    before(:each) { run_texdoc "-D", "-Mdconfig", "texlive-en" }

    it "-w and -M should be effective, and -d should not be" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_from_cl_line "debug_list=all", "-D")
      expect(stderr).to include(set_from_cl_line "machine_switch=true", "-M")
      expect(stderr).to include(ignore_from_cl_line "debug_list=config", "-d")
    end
  end

  context "with -D -c fuzzy_level=0 -qv" do
    before(:each) { run_texdoc "-D", "-c fuzzy_level=0", "-qv", "texlive-en" }

    it "-c and -q should be effective, and -v should not be" do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_from_cl_line "fuzzy_level=0", "-c")
      expect(stderr).to include(set_from_cl_line "verbosity_level=0", "-q")
      expect(stderr).to include(ignore_from_cl_line "verbosity_level=3", "-v")
    end
  end

  context "with -D texlive-en -l" do
    before (:each) { run_texdoc "-D", "texlive-en", "-l" }

    it "the last argument -l should be treated as non-option argument" do
      expect(stderr).to include(
        debug_line "search", "Searching documents for pattern \"texlive-en\"")
      expect(stderr).to include(
        debug_line "search", "Searching documents for pattern \"-l\"")
    end
  end

  context "with -D -- -texlive-en" do
    before (:each) { run_texdoc "-D", "--", "-texlive-en" }

    it "arguments after -- should be treated as non-option argument" do
      expect(stderr).to include(
        debug_line "search", "Searching documents for pattern \"-texlive-en\"")
    end
  end

  # error cases
  context "without any option nor argument" do
    before(:each) { run_texdoc }

    it 'should result in the "no action" error' do
      expect(last_command_started).to have_exit_status(2)
      expect(stderr).to include(error_line "No action specified.")
      expect(stderr).to include(error_line msg_usage)
    end
  end

  context "missing arguments for Option -d" do
    before(:each) { run_texdoc "-d" }

    it "should result in a getopt parser error" do
      expect(last_command_started).to have_exit_status(1)
      expect(stderr).to include(error_line "Option -d requires an argument.")
    end
  end

  context "missing arguments for Option -c" do
    before(:each) { run_texdoc "-c" }

    it "should result in a getopt parser error" do
      expect(last_command_started).to have_exit_status(1)
      expect(stderr).to include(error_line "Option -c requires an argument.")
    end
  end

  context "missing arguments for Option -c, followed by other options" do
    before(:each) { run_texdoc "-c", "--help" }

    it "should result in a getopt parser error" do
      expect(last_command_started).to have_exit_status(1)
      expect(stderr).to include(error_line "Option -c requires an argument.")
    end
  end

  context "given an unknown option" do
    before(:each) { run_texdoc "-x" }

    it "should result in a getopt parser error" do
      expect(last_command_started).to have_exit_status(2)
      expect(stderr).to include(error_line "unknown option: -x")
    end
  end
end
