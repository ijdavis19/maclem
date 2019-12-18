//More straight forward documentation of indv_prescription_rates.do
//Retains all of the intermediate data and will allow for browsing of 
//documentations to see if code or variables are incorrect

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

forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
 	save "$output\namcs`i'-stata_BROWSE.dta",replace
}

///import the pdr_info.csv
clear all
import delim "$dataraw/pdr_info.csv"

//rename variable originally titled 'int' who's name didn't carry over
rename v12 interest

//give every antibiotic an easier identifying number to work with
egen abxnum = group(geneq)

//determine highest abxnum
sum abxnum
local abh = r(max)

forval j = 1/`abh'{
	preserve
	drop if abxnum != `j'
	local v`j' = geneq
	restore
}

use "$output\namcs2015-stata_BROWSE.dta", replace

forval j = 1/`abh'{
	tab MED1 if DRUGID1 == "`v`j''"
}
