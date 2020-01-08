set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000

//general locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"

///import the pdr_info.csv
import delim "$dataraw/pdr_info.csv"

//clarify year AND month
gen genyear =
