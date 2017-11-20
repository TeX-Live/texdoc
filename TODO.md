# For the next release (version 3.0)

## Fuzzy search

Texdoc will run fuzzy search when texdoc can't find any document with
traditional searching method. The basic concept of the fuzzy search
implementation is already written:

* <https://gist.github.com/wtsnjp/2b193a5b8096126050055f12ea90ee43>

Maybe we will provide a new config file option like:

```
fuzzy_search = true | false | interact
```

## New option parser

We would like to follow POSIX demands as much as possible.

* cf. <http://lua-users.org/wiki/AlternativeGetOpt>

Texdoc will provide better error messages as well.

## Documentation update

Write explanations for new features and make the information (e.g. current
maintainers) up-to-date.

# Future works

## Documents not included in TeX Live

### Method 1

A variety of alias to specify absolute path. Allow to write `texdoc.cnf`
something like:

```
alias* foo = /path/to/your/foobar.pdf
```

### Method 2

Make it possible to specify particular directory (e.g. `~/texdoc`) and search
the documents in the directory with ordinal way.
([Frank's suggestion](https://github.com/latex3/latex3/issues/384#issuecomment-344206155))

## Scoring overhaul

Good package (either from the tlpdb or directory name) should be much more
important for scoring. E.g.

* With `texdoc article`
	* `spie/article.pdf` should never get such a high score
* With `texdoc todo`
	* `todo/todo-spl.pdf` should win over `todonotes/todonotes.pdf`
* With `texdoc ean`
	* `ean/Readme` should win over `barcodes/eandoc` (probably)
* With `texdoc bxtexlogo`
	* `bxtexlogo-sample.pdf` is not necessary to be the best
	* but also it should not be judged as "bad" (get score <0)

Files found using the tlpdb only should be scored heuristically as if
`<pkgname>` were asked for. Make sure heuristic scoring returns a higher score
for names actually containing the string. (Check the result with `psnfss2e`
aliases.)

See aliases marked `XXX` in `texdoc.cnf`.

## Using tlpdb

There are some ideas to make this better:

* Using `texlive/tlpdb.tlu` for tlpdb reading
* Make the parsing faster so that the no cache file is needed

## Misc

* Wirte many test scripts (for internal functions as well)
* Make the list of good and/or bad comments from the catalogue configurable?
  * Currently, "readme" is only hard-coded as "bad"
  * e.g. "package documentation" might get a bonus
* Provide interfaces for Plug-ins?
  * cf. Some people want to search document by macro name
* Try to guess which `*.tex` files are examples and allow them?

## Notes by former maintainer (mpg)

```
New options
-----------

--html-lists options: output the lists as html (à la mthelp)

--index-by-topic: build on the fly a local version of the catalogue's
bytopic.html page (see also --apropos)


Not sure about that
-------------------

Information from the tlpdb isn't always as up-to-date as the catalogue, in case
the catalogue has been fixed for a package that wasn't update. Should I generate
Data.meta.lua directly from a fresh catalogue version?
    For now, just force update of the packages in TL when I notice.

Try guessin lang from file name when there is no info in the catalogue?

What to do with tools/coverage? May want to discuss this with Phlipp S.

tlpdb cache should check if ext_list has changed, in theory.
    Is it worth it in practice? I'll do it if someone complains...

BUG: finds non-existing files in tl2010 (probably from another tlpdb?)
ex: texdoc luasseq on my machine while tl10 is active
    Ok, got it: tlpdb cache is not invalidated when switching to an older
    tlpdb files from the same release. I wonder if it's worth fixing.

Caching: now used only for tlpdb. Is it worth using it for ls-R files?
Configuration files?

Add support for shell-style globs (standard regex is probably too hard)
    Well, would anyone really use it? (would be for patterns in texdoc.cnf, not
    for texdoc arguments)

Use the 2-links trick from kpse when exploring trees? Check how it works on
windows.


Using the catalogue
-------------------

Obsolescence information could be useful (Phil's suggestion), but may be hard to
obtain (not in the tlpdb)... Well, if it's in the catalogue, I can ship a
Data.obsolete.lua file with the information...

Do something with the description from the catalogue?

Help maintainers standardise comments in order to allow for more accurate
scoring/classification?

--apropos using Jim's keywords and categorization, see Karl's mail:
http://tug.org/pipermail/texdoc/2010q3/000213.html


Auto-generation of doc files ???
--------------------------------

To allow installing TL without the doc trees (cuts off the size by 2).
Suggested by Will.


Port on MikTeX ???
------------------

Lots of TeX-live specific stuff (implicitly) embedded in various places...

Add a function in texlua's kpse library returning all files for which a certain
Lua function (given as argument) returns true. Use only it.

What to do with all the functions using tlpdb? Is it possible to use an
equivalent on MikTeX?

Adapt to the different tree layout in MikTeX (TEXMFHOME etc don't exist).

How to detect the distro? What to do with aliases?


Notes and references
--------------------

Texdoc GUI project going on since early May 2010, see messages from Enrico
Gregorio in my (mpg) inbox.

Used by vim script #2945 (AutomaticTexPlugin) as F1 and :TexDoc.

```
