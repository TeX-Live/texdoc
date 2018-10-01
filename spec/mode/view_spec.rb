require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe 'The "view" mode', :type => :aruba do
  include_context "messages"

  let(:stderr) { last_command_started.stderr.gsub("\r", "") }

  before(:all) { set_default_env }

  context "with normal input" do
    it 'should open a file without interaction' do
      run_texdoc "-dconfig", "-wv", "texlive-en"
      stop_all_commands

      expect(stderr).to include(info_line "View command: ")
      expect(last_command_started).to be_successfully_executed
    end
  end
end
