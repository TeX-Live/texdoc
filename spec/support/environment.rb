require 'aruba/rspec'
require 'pathname'

# closs-platform "which" from https://stackoverflow.com/questions/2108727/
def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each { |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      return exe if File.executable?(exe) && !File.directory?(exe)
    }
  end
  return nil
end

RSpec.shared_context "environment" do
  # check the existence of the texdoc source
  texdoc_script_dir = Pathname.pwd.join("script")
  texdoc_spec_dir = Pathname.pwd.join("spec")
  fail("Directory #{texdoc_script_dir} does not exists") if !texdoc_script_dir.directory?
  fail("Directory #{texdoc_spec_dir} does not exists") if !texdoc_spec_dir.directory?

  # check the existence of texlua
  texlua = "texlua"
  fail("Command #{texlua} does not exist") if !which(texlua)

  # use a controled environment
  RSpec.configure do |config|
    config.before(:suite) do
      ENV["TEXMFHOME"] = texdoc_spec_dir.join("texmf").to_s
      ENV["LC_ALL"] = "C"
    end
  end

  # compose the target texdoc command
  texdoc = texdoc_script_dir.join("texdoc.tlu")
  fail("File #{texdoc} does not exists") if !texdoc.file?
  let(:cmd) { texlua + " " + texdoc.to_s }
end
