set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


//set environmet variables
global projects: env projects
global storage: env storage

//general locations
global dataraw =  "$storage/selection_research"
global output = "$projects/selection_research"

//Based off of demowgtssch.do
//weights for schooling groups, based on 1975-9 and 1995-5 pooled

use "$dataraw\demowgtsfixed", clear
replace hsd08 = 0
replace hsd911 = 0
replace hsg = 0
replace cg = 0
replace ad = 0

save "$output\#tmp0001", replace
gen byte syntheticobs=1
append using "$output\#tmp0001"
replace syntheticobs=2 if syntheticobs==.
append using "$output\#tmp0001"
replace syntheticobs=3 if syntheticobs==.
append using "$output\#tmp0001"
replace syntheticobs=4 if syntheticobs==.
append using "$output\#tmp0001"
replace syntheticobs=5 if syntheticobs==.
append using "$output\#tmp0001"
replace syntheticobs=6 if syntheticobs==.

replace hsd08 = 1 if syntheticobs==1
replace hsd911 = 1 if syntheticobs==2
replace hsg = 1 if syntheticobs==3
replace cg = 1 if syntheticobs==4
replace ad = 1 if syntheticobs==5
sort female syntheticobs
list

drop syntheticobs
save "$output\demowgtssch_rep", replace
