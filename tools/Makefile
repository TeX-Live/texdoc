# $Id$
# Public domain.

tlbin = /usr/local/texlive/dev/bin/x86_64-linux
texlua = texlua
texlua = $(tlbin)/texlua

# a moderately unusual locale to test with.
localetest = de_LU.UTF-8
#
# one-line standalone test file with UTF-8 characters.
localetest-standalone:
# LC_ALL overrides all specific settings:
#	env LC_ALL=$(localetest) $(texlua) localetest.tlu
# change just the one relevant setting:
	unset LC_ALL; env LC_CTYPE=$(localetest) $(texlua) localetest.tlu
#
# locale test of texdoc itself. Explanation of envvars:
# LC_ALL    - must unset (or also set) for LC_CTYPE to be effective.
# LC_CTYPE  - the test value to enable UTF-8.
# LESS      - -f means open "binary" files, -d suppresses useless warning
#             about too-dumb terminals, -F exits immediately if file fits.
# LINES     - make a long "screen" so less won't try to page.
# PAGER     - override whatever might be in the regular environments.
# TEXMFHOME - use
# PATH      - must get TL2017-or-newer texlua
# 
# Then invoking texdoc.tlu from inside TEXMFHOME makes it find the
# subfiles in our development directory. -v says to report informational
# messages too, and the doc for zxjatype is a README text file in UTF-8.
# 
# The output should be true binary characters, not including ASCII
# "<xx>" representations of binary bytes. If you use an older luatex, or
# an older texdoc, you should see those ASCII <xx>'s.
# 
TEXMFHOME = `pwd`/texmf
doc_for_pkg = zxjatype
#
localetest-script:
	unset LC_ALL; env LC_CTYPE=$(localetest) \
	  LESS="-f -d -F" LINES=9999 PAGER=less \
	  TEXMFHOME=$(TEXMFHOME) PATH=$(tlbin):$(PATH) \
	  $(TEXMFHOME)/scripts/texdoc/texdoc.tlu -v $(doc_for_pkg)

# rebuild the predigested database of doc files from tlpdb.
# 
../script/Data.tlpdb.lua data: gen-datafiles TdTools.pm
	./gen-datafiles --tl=$(tlbin)
