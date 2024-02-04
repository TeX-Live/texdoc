# Test scripts for Texdoc

We are using [RSpec](http://rspec.info/documentation/) + [Aruba](https://github.com/cucumber/aruba) for testing Texdoc.

Files under this directory are public domain.

## How the Texdoc test works

The Texdoc test mechanism is a bit complicated because it needs to run in concert with the TEXMF trees of TeX Live. Here is an overview of how it works.

A local installation of TeX Live is required to run the Texdoc test: we assume that the PATH is also properly set. The locally installed TeX Live's `texmf-dist` tree is used for TEXMFDIST during the test run, except in a few exceptional cases.

TEXMFHOME, on the other hand, is dynamically generated. As a rule, you should not run `rspec` directly when executing tests, but always use the `rake test` command. In this rake task, the contents of the TEXMF trees used in the test are automatically generated in a temporary directory.

For testing by Aruba, the working and HOME directories are, in principle, `tmp/aruba`. In Texdoc tests, all the contents of TEXMFHOME generated above are copied under `tmp/aruba` before each example is executed (see [`support/helpers/texdoc.rb`](./support/helpers/texdoc.rb)). Then, by setting the environment variable TEXMFHOME to this path location, the Texdoc to be tested will refer to this tree.

## Tips for spec writers

The `-l` option can be used to save time by limiting the number of tests to be run.

The `-o` option can be used to pass command line options to rspec. The `--format` (`-f`) option is especially useful to see the details of the test: argument `d` can be specified to display the contents of the test being run.

Example:

```shell
$ rake test -- -l action/version -o "-fd"
...
bundle exec rspec -fd spec/action/version_spec.rb

The "version" action
  with --version
    is expected to be successfully executed
  with -V
    is expected to be successfully executed
  with -V -l
    is expected to be successfully executed

Finished in 0.76765 seconds (files took 0.33716 seconds to load)
3 examples, 0 failures
```
