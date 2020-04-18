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

// (k)
drop if female == 1
eststo: reg earnings education ability i.region exp expSquared
use "$output/dataset.dta", replace
drop if female != 1
eststo: reg earnings education ability i.region exp expSquared

esttab using "$figures/genderRegressions.tex", stats(r2 N) title(Gendered Regression table (1 = Male 2 = Female)\label{tab1})