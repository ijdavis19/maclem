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
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"

//Bring in dataset
use "$output/cefotetan/diag/panel.dta"

//Describe the Data
label data "This is something"

//Describe the unlabeled variables
label variable DIAG4 "Diagnosis #4 - specific"
label variable DIAG5 "Diagnosis #5 - specific"
label variable month "Month of visit"
rename firstgenyear firstGenYear
label variable firstGenYear "Year of First Generic Appearance"
rename obsmonth obsMonth
label variable obsMonth "Months after December 1999"
rename genmonth genericMonth
label variable genericMonth "Month of First Generic Entry"
label variable monthsAfterGen "Months Since First Generic Entry"
rename genon genericInMarket
label variable genericInMarket "Generics in Market at Time of Visit"
rename genon1year genericInMarket1Year
label variable genericInMarket1Year "Generics in Market for a Year at Time of Visit"
