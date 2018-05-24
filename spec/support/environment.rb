require 'aruba/rspec'
require 'pathname'

RSpec.shared_context "environment" do
  # check the existence of the texdoc source
  texdoc_script_dir = Pathname.pwd.join("script")
  texdoc_spec_dir = Pathname.pwd.join("spec")
  fail("Directory #{texdoc_script_dir} does not exists") if !texdoc_script_dir.directory?
  fail("Directory #{texdoc_spec_dir} does not exists") if !texdoc_spec_dir.directory?

  # check the existence of texlua
  texlua = "texlua"
  fail("Command #{texlua} does not exist") if `type #{texlua}`.empty?

  # use a controled environment
  RSpec.configure do |config|
    config.before(:suite) do
      ENV["TEXMFHOME"] = texdoc_spec_dir.join("texmf").to_s
      ENV["LC_ALL"] = "C"
    end
  end

  # constract texdoc command
  texdoc = texdoc_script_dir.join("texdoc.tlu")
  fail("File #{texdoc} does not exists") if !texdoc.file?
  let(:cmd) { texlua + " " + texdoc.to_s }
end
