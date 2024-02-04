require 'spec_helper'

RSpec.describe 'The "list" mode', :type => :aruba do
  include_context "messages"

  let(:mock_viewer) { SpecHelplers::Texdoc::MOCK_VIEWER }

  context "with -I" do
    before(:each) { run_texdoc "-lI", "texlive-en" }

    it "should show the result list without interaction" do
      expect(stdout).to match(/^ 1 .+\n 2 .+$/)
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "with -M" do
    before(:each) { run_texdoc "-lM", "texlive-en" }
  
    it "should show the machine-readable list without interaction" do
      expect(stdout).to match(/^texlive-en\t\d(|\.\d)\t.+$/)
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "in the interactive mode" do
    before(:each) { run_texdoc "-vl", "texlive-en", interactive: true }

    context "when RET is typed" do
      before(:each) { type "" }
      before(:each) { stop_all_commands }

      it "should view the first item in the list" do
        first_item = stdout[/^ 1 (.*)$/, 1]
        expect(stderr).to include(info_line "View command: #{mock_viewer} \"#{first_item}\"")
        expect(last_command_started).to be_successfully_executed
      end
    end

    context 'when "1" is typed' do
      before(:each) { type "1" }
      before(:each) { stop_all_commands }

      it "should view the first item in the list" do
        first_item = stdout[/^ 1 (.*)$/, 1]
        expect(stderr).to include(info_line "View command: #{mock_viewer} \"#{first_item}\"")
        expect(last_command_started).to be_successfully_executed
      end
    end

    context 'when "2" is typed' do
      before(:each) { type "2" }
      before(:each) { stop_all_commands }

      it "should view the second item in the list" do
        second_item = stdout[/^ 2 (.*)$/, 1]
        expect(stderr).to include(info_line "View command: #{mock_viewer} \"#{second_item}\"")
        expect(last_command_started).to be_successfully_executed
      end
    end

    context 'when "x" is typed' do
      before(:each) { type "x" }
      before(:each) { stop_all_commands }

      it "should exit without viewing" do
        expect(stderr).not_to include(info_line "View command: ")
        expect(last_command_started).to be_successfully_executed
      end
    end
  end

  context "in the interactive mode, if the list length is greater than max_lines" do
    before(:each) { run_texdoc "-vl", "latex", interactive: true }

    it 'should show the top 10 (`max_lines`) results' do
      type ""
      stop_all_commands

      expect(stdout).to match(/\A\d+ results. Only the top 10 are shown below./)
      expect(stdout).to match(/^ 1 (.*)$/)
      expect(stdout).to match(/^10 (.*)$/)
      expect(stdout).not_to match(/^11 (.*)$/)
      expect(last_command_started).to be_successfully_executed
    end

    context "when RET is typed" do
      before(:each) { type "" }
      before(:each) { stop_all_commands }

      it "should view the first item in the list" do
        first_item = stdout[/^ 1 (.*)$/, 1]
        expect(stderr).to include(info_line "View command: #{mock_viewer} \"#{first_item}\"")
        expect(last_command_started).to be_successfully_executed
      end
    end

    context 'when "1" is typed' do
      before(:each) { type "1" }
      before(:each) { stop_all_commands }

      it "should view the first item in the list" do
        first_item = stdout[/^ 1 (.*)$/, 1]
        expect(stderr).to include(info_line "View command: #{mock_viewer} \"#{first_item}\"")
        expect(last_command_started).to be_successfully_executed
      end
    end

    context 'when "2" is typed' do
      before(:each) { type "2" }
      before(:each) { stop_all_commands }

      it "should view the second item in the list" do
        second_item = stdout[/^ 2 (.*)$/, 1]
        expect(stderr).to include(info_line "View command: #{mock_viewer} \"#{second_item}\"")
        expect(last_command_started).to be_successfully_executed
      end
    end

    context 'when "S" is typed' do
      before(:each) { type "S" }
      before(:each) { type "" }
      before(:each) { stop_all_commands }

      it 'should show all results' do
        expect(stdout).to include ("Enter number of file to view, RET to view 1, anything else to skip:")
        expect(last_command_started).to be_successfully_executed
      end
    end

    context 'when "x" is typed' do
      before(:each) { type "x" }
      before(:each) { stop_all_commands }

      it "should exit without viewing" do
        expect(stderr).not_to include(info_line "View command: ")
        expect(last_command_started).to be_successfully_executed
      end
    end
  end
end
