require 'spec_helper'

RSpec.describe "Errors:", :type => :aruba do
  include_context "messages"
  context "when any document for input cannot be found" do
    let(:nonexist_pkg) { "some_unknown_name" }

    context "with view mode" do
      before(:each) { run_texdoc nonexist_pkg }

      it 'should result in the "not found" error' do
        expect(stderr).to include("Unfortunately, there are no good matches for")
      end
    end

    context "with mixed mode" do
      before(:each) { run_texdoc '-m', nonexist_pkg }

      it 'should result in the "not found" error' do
        expect(stderr).to include("Unfortunately, there are no good matches for")
      end
    end
  end
end
