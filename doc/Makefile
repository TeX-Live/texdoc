# $Id$
# Makefile for texdoc documentation.
# Public domain.

TARGETS = texdoc.pdf texdoc.1 texdoc.man1.pdf

H2M_NAME = "find & view documentation in TeX Live"
H2M_INC = include.h2m
H2M_SOURCES = ../script/constants.tlu ../script/texdoc.tlu

all: $(TARGETS)

texdoc.pdf: texdoc.aux
	texfot xelatex '\nonstopmode\input texdoc.tex'
texdoc.aux: texdoc.tex
	texfot xelatex '\nonstopmode\input texdoc.tex'

texdoc.1: texdoc Makefile $(H2M_INC) $(H2M_SOURCES)
	../tools/texdocsh -- help2man -N -n$(H2M_NAME) --include $(H2M_INC) ./$< > $@

texdoc.man1.html: texdoc.1
	groff -man -Thtml $< > $@

texdoc.man1.pdf: texdoc.1
	groff -man -rS11 $< | ps2pdf -sPAPERSIZE=a4 - $@

mrproper: clean
	@rm -f -- $(TARGETS)

clean: 
	@latexmk -c -quiet >/dev/null

.PHONY: clean mrproper
