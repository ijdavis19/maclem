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

// Bring in the dataset
import delimited "$dataraw/dataset.csv"

// Save the dataset
gen expSquared = exp*exp
save "$output/dataset.dta", replace

// (a)
global variables = "id earnings occ ability age region female education exp"
foreach variable in $variables {
    sum `variable'
}
