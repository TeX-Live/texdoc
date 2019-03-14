require 'spec_helper'
require 'fileutils'

RSpec.describe 'Unit test', :type => :aruba do
  include_context "unit"

  context "loading texdoclib" do
    before(:each) { run_unit_test "texdoclib" }

    it { expect(last_command_started).to be_successfully_executed }
  end
end
