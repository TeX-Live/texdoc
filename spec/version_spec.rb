require 'spec_helper'

RSpec.describe 'Showing version', :type => :aruba do
  include_context 'environment'

  context 'with --version' do
    before(:each) { run(cmd + ' --version') }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stdout).to start_with 'Texdoc 3.0' }
  end
end
