require 'spec_helper'
require 'pathname'

RSpec.describe "Unit test", :type => :aruba do
  def run_unit_test name
    run_command_and_stop "texlua #{Pathname.pwd}/spec/unit/#{name}_test.lua"
  end

  context 'texdoclib_test.lua' do
    before(:each) { run_unit_test "texdoclib" }

    it { expect(last_command_started).to be_successfully_executed }
  end

  context 'search_test.lua' do
    before(:each) { run_unit_test "search" }

    it { expect(last_command_started).to be_successfully_executed }
  end
  context 'util_test.lua' do
    before(:each) { run_unit_test "util" }

    it { expect(last_command_started).to be_successfully_executed }
  end
end
