require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Verbose outputs", :type => :aruba do
  before(:all) { set_default_env }

  let(:stderr) { last_command_started.stderr }

  context 'ordinally show "view command" and "setting env"' do
    before(:each) { run_texdoc "-v", "texdoc" }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(info_line "View command: ") }
    it { expect(stderr).to include(info_line "Setting environment LC_CTYPE to:") }
  end
end
