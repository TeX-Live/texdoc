require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe 'The "list" mode', :type => :aruba do
  include_context "messages"

  before(:all) { set_default_env }

  context "with -I" do
    before(:each) { run_texdoc "-lI", "texlive-en" }
    before(:each) { stop_all_commands }

    it "should show the result list without interaction" do
      expect(stdout).to match(/^ 1 .+\n 2 .+$/)
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "with -M" do
    before(:each) { run_texdoc "-lM", "texlive-en" }
    before(:each) { stop_all_commands }
  
    it "should show the machine-readable list without interaction" do
      expect(stdout).to match(/^texlive-en\t\d(|\.\d)\t.+$/)
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "when RET is typed" do
    before(:each) { run_texdoc "-vl", "texlive-en" }
    before(:each) { type "" }
    before(:each) { stop_all_commands }

    it "should view the first item in the list" do
      first_item = stdout[/^ 1 (.*)$/, 1]
      expect(stderr).to include(info_line "View command: : \"#{first_item}\"")
      expect(last_command_started).to be_successfully_executed
    end
  end

  context 'when "1" is typed' do
    before(:each) { run_texdoc "-vl", "texlive-en" }
    before(:each) { type "1" }
    before(:each) { stop_all_commands }

    it "should view the first item in the list" do
      first_item = stdout[/^ 1 (.*)$/, 1]
      expect(stderr).to include(info_line "View command: : \"#{first_item}\"")
      expect(last_command_started).to be_successfully_executed
    end
  end

  context 'when "2" is typed' do
    before(:each) { run_texdoc "-vl", "texlive-en" }
    before(:each) { type "2" }
    before(:each) { stop_all_commands }

    it "should view the second item in the list" do
      second_item = stdout[/^ 2 (.*)$/, 1]
      expect(stderr).to include(info_line "View command: : \"#{second_item}\"")
      expect(last_command_started).to be_successfully_executed
    end
  end
end
