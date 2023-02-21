# Test scripts for Texdoc

We are using [RSpec](http://rspec.info/documentation/) + [Aruba](https://github.com/cucumber/aruba) for testing Texdoc.

Files under this directory are public domain.

## How the Texdoc test works

The Texdoc test mechanism is a bit complicated because it needs to run in concert with the TEXMF trees of TeX Live. Here is an overview of how it works.

First, a local installation of TeX Live is required to run the Texdoc test: we assume that the `PATH` is also properly set. During the test run, `TEXMFDIST` will use the locally installed TeX Live's `TEXMFDIST` tree, except in a few exceptional cases.

`TEXMFHOME`, on the other hand, is dynamically generated. When executing tests, as a rule, do not run `rspec` directly, but always use the `rake test` command. In this rake task, the contents of the TEXMF trees used in the test are automatically generated in a temporary directory.

For testing by Aruba, the working and HOME directories are in principle `tmp/aruba`. In Texdoc tests, the entire contents of `TEXMFHOME` generated above are copied under `tmp/aruba` before each example is executed (see [`support/helpers/texdoc.rb`](./support/helpers/texdoc.rb)). Then, by setting the environment variable `TEXMFHOME` to this path location, the Texdoc to be tested will refer to this tree.
