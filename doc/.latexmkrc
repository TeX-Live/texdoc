#!/usr/bin/perl
$pdflatex = "xelatex -synctex=1 -interaction=nonstopmode -halt-on-error %O %S";
$bibtex = "bibtex";
$pdf_update_command = "open -a Skim.app %S; sleep 0.5; open -a iTerm.app";
$makeindex = "makeindex";
$max_repeat = 5;
$pdf_mode = 1;
$out_dir = "./out";
