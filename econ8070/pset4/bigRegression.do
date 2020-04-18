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

// (b)
eststo: reg earnings education ability female i.region exp expSquared

// (c)
eststo: qui reg earnings education female i.region exp expSquared

// (d)
eststo: reg earnings education ability female i.region exp expSquared  i.occ

// (e)
eststo: reg earnings education ability female i.region exp 

// (f)
gen expCubed = expSquared*exp
gen expFourth = expCubed*exp
eststo: reg earnings education ability female i.region exp expSquared expCubed expFourth

// (g) (same as b?)
eststo: reg earnings education ability female i.region exp expSquared

// (h)
preserve
sample 2000, count
eststo: reg earnings education ability female i.region exp expSquared
restore

// (i) 
eststo: reg earnings education ability female i.region exp expSquared, vce(cl region)

// (l)
forval x = 1/5 {
    use "$output/dataset.dta", replace
    replace id = id + (10000*(`x'-1))
    save "$output/dataset`x'.dta", replace
}
use "$output/dataset1.dta", replace
forval x = 2/5 {
    append using "$output/dataset`x'.dta"
}
save "$output/datasetTimesFive.dta", replace
forval x = 1/5 {
    erase "$output/dataset`x'.dta"
}
use "$output/datasetTimesFive.dta", replace
eststo: reg earnings education ability female i.region exp expSquared

esttab using "$figures/bigRegressions.tex", stats(r2 N) title(Regression table\label{tab1})
