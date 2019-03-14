require 'pathname'

shared_context "unit" do
  def run_unit_test name
    run "texlua #{Pathname.pwd}/spec/unit/#{name}_test.lua"
  end
end
