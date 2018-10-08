require 'spec_helper'

RSpec.describe "Fuzzy search", :type => :aruba do
  include_context "messages"

  context "if user input is right" do
    before(:each) { run_texdoc "-v", "texlive-en" }

    it "should not be performed" do
      expect(stderr).not_to include(info_line "Fuzzy search result: ")
    end
  end

  context "if user input is incorrect and fuzzy_level > 0" do
    before(:each) { run_texdoc "-v -c fuzzy_level=1", "texlive-eX" }

    it "should be performed" do
      expect(stderr).to include(info_line "Fuzzy search result: ")
    end
  end

  context "if user input is incorrect and fuzzy_level = 0" do
    before(:each) { run_texdoc "-v -c fuzzy_level=0", "texlive-eX" }

    it "should not be performed" do
      expect(stderr).not_to include(info_line "Fuzzy search result: ")
    end
  end

  # TODO: check fuzzy search deliver the correct results
end
