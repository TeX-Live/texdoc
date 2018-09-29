require 'fileutils'

shared_context "sample_files" do
  TEXMFHOME = ENV["TEXMFHOME"]
  DOC_DIR = TEXMFHOME + '/doc/sample'

  before(:all) { FileUtils.mkdir_p(DOC_DIR) }

  # create sample file in TEXMFHOME
  def cleate_sample_file ext
    FileUtils.touch("#{DOC_DIR}/sample.#{ext}")[0]
  end
end
