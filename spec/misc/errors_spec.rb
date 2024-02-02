require 'spec_helper'

RSpec.describe "Errors", :type => :aruba do
  include_context "messages"

  context "when any document for input cannot be found" do
    let(:nonexist_pkg) { "never_never_existing_package_foooooooooo" }

    before(:each) { run_texdoc nonexist_pkg }

    it 'should result in the "not found" error' do
      expect(stderr).to include("Unfortunately, there are no good matches for")
    end
  end
end
