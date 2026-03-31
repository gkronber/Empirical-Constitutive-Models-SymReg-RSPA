#!/bin/bash

for file in scatterplots.tex linechart-steel-abb2.tex linechart-steel-abb2_logscale.tex linechart-steel-abb2-tomax.tex linechart-steel-abb2-tomax_logscale.tex linechart-alu.tex linechart-alu_logscale.tex linechart-alu-tomax.tex linechart-alu-tomax_logscale.tex linechart-alu-2row.tex linechart-alu-tomax-2row.tex pareto_fronts_all.tex pareto_fronts_example.tex; do echo $file; echo; dvilualatex $file; dvips -E ${file%%.tex}.dvi; mv ${file%%.tex}.ps ${file%%.tex}.eps; epspdf ${file%%.tex}.eps; done

