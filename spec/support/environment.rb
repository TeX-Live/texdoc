require 'aruba/rspec'
require 'pathname'
require 'fileutils'

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

# check the existence of the texdoc source
texdoc_scriptdir = Pathname.pwd.join("script")
texdoc_cnf = Pathname.pwd.join("texdoc.cnf")
texdoc_tlu = texdoc_scriptdir.join("texdoc.tlu")
fail("Directory #{texdoc_scriptdir} does not exists") if !texdoc_scriptdir.directory?
fail("File #{texdoc_cnf} does not exists") if !texdoc_cnf.file?
fail("File #{texdoc_tlu} does not exists") if !texdoc_tlu.file?

# prepare for pseudo TEXMF
texdoc_tmpdir = Pathname.pwd.join("tmp")
texmf = Pathname(texdoc_tmpdir).join("texmf")

# check the existence of texlua
texlua = "texlua"
fail("Command #{texlua} does not exist") if !which(texlua)

# use a controled environment
RSpec.configure do |config|
  config.before(:suite) do
    # construct pseudo TEXMF
    texmf_scripts = texmf.join("scripts")
    texmf_texdoc = texmf.join("texdoc")
    FileUtils.mkdir_p([texmf_scripts, texmf_texdoc])
    FileUtils.ln_s(texdoc_scriptdir, texmf_scripts.join("texdoc"))
    FileUtils.ln_s(texdoc_cnf, texmf_texdoc.join("texdoc.cnf"))

    # set ENV
    ENV["TEXMFHOME"] = texmf.to_s
    ENV["LC_ALL"] = "C"
  end

  config.after(:suite) do
    # remove pseudo TEXMF
    FileUtils.remove_dir(texmf, force: true)
  end
end

RSpec.shared_context "environment" do
  # compose the target texdoc command
  let(:cmd) { texlua + " " + texdoc_tlu.to_s }
  def run_texdoc(arg)
    run(cmd + " " + arg)
  end
end
