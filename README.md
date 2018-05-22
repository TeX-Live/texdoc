# Texdoc (v3.0)

[![Build Status](https://travis-ci.org/TeX-Live/texdoc.svg?branch=master)](https://travis-ci.org/TeX-Live/texdoc)

Texdoc is a command line program to find and view documentation in TeX Live.

## General Information

* Website: <https://www.tug.org/texdoc/>
* Repository: <https://github.com/TeX-Live/texdoc/>
* Mailing list: <texdoc@tug.org>

## Using Texdoc

Texdoc is part of the TeX Live distribution. Generally, you don't have to install it yourself.

If you want to try/test the develop version, please see below.

## Files in This Repository

- `doc/` contains the documentation,
- `texdoc.cnf` is the default configuration file,
- `script/` contains the source code, and
- `tools/` contains helper scripts for maintenance and/or testing; some of them might run properly only on particular machines.

## How to Install the Develop Version

Here, `$TEXDOC` means the path to the texdoc dev sources you cloned (or downloaded), and `$TEXMFHOME` denotes your personal TEXMF tree (you can get its location with `kpsewhich --var-value TEXMFHOME`).

* **The command.** Symlink or copy `$TEXDOC/script` as `$TEXMFHOME/scripts/texdoc`.
* **The configuration file.** Symlink or copy `$TEXDOC/texdoc.cnf` as `$TEXMFHOME/texdoc/texdoc-dist.cnf` (notice the `-dist` part). It will completely override the other configuration files except `$TEXMFHOME/texdoc/texdoc.cnf` which you can still use for you personal settings.

You can make sure that the right files are used by running `texdoc --files`: the first line contains the full path to the version of used `texdoclib.tlu`, and the rest lists the configuration files in use.

## What's New

Please see the [NEWS](./NEWS) in our repository.

## Copyright and License Information

Copyright (c) 2008-2018 Manuel Pégourié-Gonnard, Takuto Asakura, Karl Berry, and Norbert Preining. All rights reserved.

This package is distributed under [GNU General Public License v3.0](./COPYING).

Previous work (texdoc program) in the public domain:

* Contributions from Reinhard Kotucha (2008).
* First texlua versions by Frank Küster (2007).
* Original shell script by Thomas Esser, David Aspinall, and Simon Wilkinson.
