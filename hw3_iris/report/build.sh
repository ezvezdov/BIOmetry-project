#!/bin/bash

pdflatex --shell-escape report.tex 
bibtex report.aux
pdflatex --shell-escape report.tex 