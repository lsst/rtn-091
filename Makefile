DOCTYPE = RTN
DOCNUMBER = 091
DOCNAME = $(DOCTYPE)-$(DOCNUMBER)

tex = $(filter-out $(wildcard *acronyms.tex) , $(wildcard *.tex))

GITVERSION := $(shell git log -1 --date=short --pretty=%h)
GITDATE := $(shell git log -1 --date=short --pretty=%ad)
GITSTATUS := $(shell git status --porcelain)
ifneq "$(GITSTATUS)" ""
	GITDIRTY = -dirty
endif

export TEXMFHOME ?= lsst-texmf/texmf

$(DOCNAME).pdf: $(tex) local.bib authors.tex
	echo $(TEXMFHOME)
	ls  $(TEXMFHOME)
	latexmk -bibtex -pdf -f $(DOCNAME)

authors.tex:  authors.yaml
	echo $(TEXMFHOME)
	python3 $(TEXMFHOME)/../bin/db2authors.py -m ascom > authors.tex

.PHONY: clean
clean:
	latexmk -c
	rm -f $(DOCNAME).bbl
	rm -f $(DOCNAME).pdf
	rm -f meta.tex
	rm -f authors.tex

.FORCE:
