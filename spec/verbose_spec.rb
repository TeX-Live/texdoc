require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Verbose outputs", :type => :aruba do
  before(:all) { set_default_env }
  let(:stderr) { last_command_started.stderr.gsub("\r", "") }

  context 'ordinally show "view command" and "setting env"' do
    before(:each) { run_texdoc "-v", "texdoc" }
    before(:each) { stop_all_commands }

    it do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to match(
        /^texdoc info: View command: .+\ntexdoc info: Setting environment LC_CTYPE to: .+\Z/)
    end
  end
end
