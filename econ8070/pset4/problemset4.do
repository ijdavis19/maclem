set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


// Global projects: env projects
global storage: env storage
global projects: env projecs

// General locations
global dataraw =  "$storage/econ8070"
global output = "$projects/econ8070"

// Bring in the dataset
import delimited "$dataraw/dataset.csv"

// Save the dataset
save "$output/dataset.dta"