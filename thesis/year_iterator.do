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
forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	if i >= 2006 & i < 2012{
		forval k = 1/8
	}
	else if i == 2012 | i == 2013 {
		forval k = 1/9
	}
	else {
		forval k = 1/30
	}
}
