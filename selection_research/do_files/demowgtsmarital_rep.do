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

//Based off of demowgtsmarital.do
//weights for marital groups, based on 1975-9 and 1995-5 pooled

use "$dataraw\demowgtsfixed", clear
replace widowed = 0
replace divorced = 0
replace separated = 0
replace nevermarried = 0

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

replace widowed = 1 if syntheticobs==1
replace divorced = 1 if syntheticobs==2
replace separated = 1 if syntheticobs==3
replace nevermarried = 1 if syntheticobs==4
sort female syntheticobs
drop syntheticobs
save "$output\demowgtsmarital_rep", replace
