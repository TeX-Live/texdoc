require 'os'
require 'spec_helper'

RSpec.describe "Configuration item", :type => :aruba do
  include_context "messages"

  context "texlive_tlpdb" do
    context "to set invalid path" do
      before(:each) { run_texdoc "-dtlpdb", "-c texlive_tlpdb=foo", "texlive-en" }

      it "should output warnings" do
        expect(stderr).to include(
          warning_line "Specified texlive.tlpdb does not exist: foo")
        expect(stderr).to include(
          warning_line "Fallback to use the texlive.tlpdb in the distribution.")
      end
    end
  end
end
