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

// Bring in the dataset
import delimited "$dataraw/dataset.csv"

// Save the dataset
save "$output/dataset.dta", replace

// (a)
global variables = "id earnings occ ability age region female education exp"
foreach variable in $variables {
    sum `variable'
}

// (b)
gen expSquared = exp*exp
reg earnings education ability region exp expSquared

// (c)
reg earnings education ability region exp expSquared female
// (d)
reg earnings education ability region exp expSquared female occ

// (e)
reg earnings education ability region exp

// (f)
gen expCubed = expSquared*exp
gen expFourth = expCubed*exp
reg earnings education ability region exp expSquared

// (g) (same as b?)
reg earnings education ability region exp expSquared

// (h)
preserve
sample 2000, count
reg earnings education ability region exp expSquared
restore

// (j)
bysort region: reg earnings education region exp expSquared

// (k)
bysort female: reg earnings region education region exp expSquared

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
gen expSquared = exp*exp
reg earnings education ability region exp expSquared
