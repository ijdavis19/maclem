set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


// Global projects: env projects
global storage: env storage
global projects: env projects

// General locations
global dataraw =  "$storage/econ8070"
global output = "$projects/econ8070"
global figures = "/home/ian/economics/maclem/econ8070/pset4"

// Bring in the data
use "$output/dataset.dta", replace

// (j)
drop if region == 1
eststo: reg earnings education ability female exp expSquared
use "$output/dataset.dta", replace
drop if region == 2
eststo: reg earnings education ability female exp expSquared
use "$output/dataset.dta", replace 
drop if region == 3
eststo: reg earnings education ability female exp expSquared
use "$output/dataset.dta", replace 
drop if region == 4
eststo: reg earnings education ability female exp expSquared
use "$output/dataset.dta", replace

esttab using "$figures/regionRegressions.tex", stats(r2 N) title(Regional Regression table\label{tab1})
