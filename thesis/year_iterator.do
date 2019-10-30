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
global dataraw =  "$storage\thesis_antibiotics"
global output = "$projects\thesis_antibiotics"

//loop through datasets
forval i = 1992/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
}
