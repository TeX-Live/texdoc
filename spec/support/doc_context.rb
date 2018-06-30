require 'fileutils'

shared_context "doc" do
  TEXMFHOME = ENV["TEXMFHOME"]
  DOC_DIR = TEXMFHOME + '/doc/sample'

  exts = ["html", "dvi", "md", "txt", "pdf", "ps"]

  exts.each do |e|
    eval "SAMPLE_#{e.upcase} = DOC_DIR + \"/sample.#{e}\""
  end

  before(:all) do
    FileUtils.mkdir_p(DOC_DIR)
    exts.each do |e|
      eval "FileUtils.touch(SAMPLE_#{e.upcase})"
    end
  end
end
