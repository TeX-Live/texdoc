# texdoc(1) -- find & view documentation in TeX Live

## SYNOPSIS

`texdoc` [OPTION]... NAME...  
`texdoc` [OPTION]... ACTION

## DESCRIPTION

Try to find appropriate TeX documentation for the specified NAME(s).
Alternatively, perform the given ACTION and exit.

## OPTIONS

* `-w`, `--view`:
  Use view mode: start a viewer. **(default)**
* `-m`, `--mixed`:
  Use mixed mode (view or list).
* `-l`, `--list`:
  Use list mode: show a list of results.
* `-s`, `--showall`:
  Use showall mode: show also "bad" results.

* `-i`, `--interact`:
  Use interactive menus. **(default)**
* `-I`, `--nointeract`:
  Use plain lists, no interaction required.
* `-M`, `--machine`:
  Machine-readable output for lists (implies -I).

* `-q`, `--quiet`:
  Suppress warnings and most error messages.
* `-v`, `--verbose`:
  Print additional information (e.g., viewer command).
* `-D`, `--debug`:
  Activate all debug output (equal to "--debug=all").
* `-d` LIST, `--debug`=LIST:
  Activate debug output restricted to the categories specified in LIST.  
  Available categories: `config`, `files`, `search`, `score`, `texdocs`,
  `tlpdb`, `version`, `view`, and `all` to activate all of these.
* `-c` NAME=VALUE:
  Set configuration item NAME to VALUE.

## ACTIONS

* `-h`, `--help`:
  Print this help message.
* `-V`, `--version`:
  Print the version number.
* `-f`, `--files`:
  Print the list of configuration files used.
* `--just-view` FILE:
  Display FILE, given with full path (no searching).
* `--print-completion` SHELL:
  Print SHELL completion.

## ENVIRONMENT

The following environment variables can be split by colon and used to set viewers:

* `BROWSER`, `BROWSER_texdoc`:
  Set the command to be used for HTML documents.
* `DVIVIEWER`, `DVIVIEWER_texdoc`:
  Set the command to be used for DVI documents.
* `MDVIEWER`, `MDVIEWER_texdoc`:
  Set the command to be used for Markdown documents.
* `PAGER`, `PAGER_texdoc`:
  Set the command to be used for text documents.
* `PDFVIEWER`, `PDFVIEWER_texdoc`:
  Set the command to be used for PDF documents.
* `PSVIEWER`, `PSVIEWER_texdoc`:
  Set the command to be used for PS documents.

The following environment variables are also used:

* `LANG`, `LC_ALL`, `LANGUAGE`, `LANGUAGE_texdoc`:
  Set the locale, which will influence on the search results.
* `TEXDOCS`:
  In addition to the documents included in the TeX Live database, Texdoc also
  searches documentation under TEXMF trees specified by the kpathsea variable
  `TEXDOCS`.

## FILES

`<texmf>/texdoc/texdoc.cnf`, see output of the `--files` option.

## EXIT STATUS

The `texdoc` command exists with one of the following values:

* 0:
  Success.
* 1:
  Internal error.
* 2:
  Usage error.
* 3:
  No documentation found.

## REPORTING BUGS

Report bugs to <texdoc@tug.org>.  
Texdoc home page: <http://tug.org/texdoc/>  
Source: <https://github.com/TeX-Live/texdoc>

## COPYRIGHT

Copyright 2008-2022 Manuel Pe'gourie'-Gonnard, Takuto Asakura, the TeX Live Team.  
License: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.  
This is free software: you are free to change and redistribute it.

## SEE ALSO

The full documentation is maintained as a PDF manual. The command

```
texdoc texdoc
```

should give you access to the complete manual.
