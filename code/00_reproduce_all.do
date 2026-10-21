version 18.0
clear all
set more off

args repository_root
if `"`repository_root'"' == "" local repository_root "."
global publication_root `"`repository_root'"'

capture mkdir "$publication_root/output"
capture mkdir "$publication_root/output/figures"
capture mkdir "$publication_root/output/spatial"

do "$publication_root/code/01_reproduce_charts.do"
do "$publication_root/code/02_reproduce_maps.do"

display as result "Reproducción terminada. Revise output/figures/."
