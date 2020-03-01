
set more off
clear all
set matsize 1100
set maxvar 32000
set seed 0
global bootstraps 1000


//set environmet variables and locations
global projects: env projects
global storage: env storage
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"

//Drop everything that isn't my antibiotic
use "$output/refinedpanel.dta", replace
drop if drugnum != 9

// Relevant Reasons for Visit and Diagnoses (NOT USING ABx RELATIONS)
//Collect Local Variables
use "$output/refinedpanel.dta", replace
drop if drugnum != 9
local geneq = geneq
local relMax = 0
local counter = 0
qui forval year = 2006/2016 {
	use "$dataraw/namcs`year'-stata.dta", replace
	gen script=0
	if `year' >= 2006 & `year' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "`geneq'"
		}
	}
	else if `year' == 2012 | `year' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "`geneq'"
		}
	}
	else {
		forval k = 1/30 {
			replace script = 1 if DRUGID`k' == "`geneq'"
			}
	}
	save "$output/cefotetan/scripted`year'", replace
	sum script
	local rel`year' = r(sum)
	local relMax = `rel`year'' + `relMax'
	drop if script != 1
	gen runner = _n
	forval runner =  1/`rel`year'' {
		preserve
		drop if runner != `runner'
		if `year' < 2014 {
			forval k =  1/3 {
				//replace RFV`k' = 0000 if RFV`k' ==.
				replace DIAG`k' = "null" if DIAG`k' ==""
				//local `year'reason`runner'k`k' = RFV`k'
				local DIAG`counter' = DIAG`k'
				local counter = `counter' + 1
			}
		}
		else {
			forval k = 1/5 {
				//replace RFV`k' = 0000 if RFV`k' ==.
				replace DIAG`k' = "null" if DIAG`k' ==""
				//local `year'reason`runner'k`k' = RFV`k'
				local DIAG`counter' = DIAG`k'
				local counter = `counter'
			}
		}
		restore
	}
}

//For review: diagnoses are now set as diag`x', x in [0,counter]
//We need to clean up the duplicates
//Probably should do some kind of unit testing with the continue command in the loops
//Does the below usage break me out of the `if' or the `for'
local count2 = `counter'
local counter = 0
local 2DIAG0 = "`DIAG0'"
ma list
forval s = 1/`count2' {	//Skipping over the 0 case because it cannot be a repeat
	local ceiling = `s' - 1
	forval t = 0/`ceiling' {
		if `t' < `ceiling' {
			gen interVarS = "`DIAG`s''"
			gen intervarT = "`DIAG`t''"
			gen comp = 0
			replace comp = 1 if interVarS == intervarT
			if comp == 1 {
				ma drop `DIAG`s''
			}
			drop interVarS
			drop intervarT
			drop comp
		}
		/*if `t' == `ceiling'  {	//Theoretically, this should only happen if we never had to "continue" out of the loop
			if `DIAG`s'' != "`DIAG`t''" {
				local 2DIAG`counter' = "`DIAG`s''"
				local counter = `counter' + 1
			}
			if `DIAG`s'' == "`DIAG`t''"{
				ma drop `DIAG`s'' 
			}
		}
				*/
	}
}

//ma list
/*
//This entire loop can be simplified no but iterating from 0 to `count'
qui forval dataset = 2006/2016 {
	use "$output/cefotetan/scripted`dataset'", replace
	gen relRFV=0
	gen relDIAG=0
	if `dataset' < 2014 {
			forval i = 1/3 {
				//drop if RFV`i' == . & relRFV != 1
				drop if DIAG`i' == "" & relDIAG != 1
				//replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k''
				replace relDIAG = 1 if DIAG`i' == "``year'diag`runner'k`k''"
			}
	else {
		forval i = 1/5 {
			//drop if RFV`i' == . & relRFV != 1
			drop if DIAG`i' == "" & relDIAG != 1
			//replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k''
			replace relDIAG = 1 if DIAG`i' == "``year'diag`runner'k`k''"
		}
	}
	save "$output/cefotetan/scripted`dataset'", replace
	drop if relRFV != 1
	save "$output/cefotetan/rfv/`dataset'", replace
	use "$output/cefotetan/scripted`dataset'", replace
	drop if relDIAG != 1
	save "$output/cefotetan/diag/`dataset'", replace
}

forval year = 2006/2016 {
  use "$output/cefotetan/diag/`year'", replace
  gen year = YEAR
  keep year VMONTH AGE SEX PAYPRIV PAYMCARE PAYMCAID PAYWKCMP PAYSELF PAYNOCHG PAYOTH PAYDK PAYTYPE /*USETOBAC*/ /*PRIMCARE*/ /*TIMEMD*/ /*SPECR*/ /*MDDO*/ /*SOLO*/ /*PRMCARER*/ /*PRMAIDR PRPRVTR PRPATR PROTHR PRMANR REVCAPR REVCASER REVOTHR*/ script relRFV relDIAG
  save "$output/cefotetan/diag/`year'", replace
}

use "$output/cefotetan/diag/2006.dta", replace
forval year = 2007/2016 {
	append using "$output/cefotetan/diag/`year'.dta"
}

gen month = VMONTH
drop VMONTH

gen firstgenyear = 2009
gen firstgenmonth = 12
gen obsmonth = (year - 2000)*12 + month
gen genmonth = (firstgenyear - 2000)*12 + firstgenmonth
gen monthsAfterGen = obsmonth - genmonth
gen genon = 1 if  monthsAfterGen >= 0
replace genon = 0 if genon != 1
gen genon1year = 1 if monthsAfterGen >= 12
replace genon1year = 0 if genon1year != 1
save "$output/cefotetan/diag/panel.dta",replace
*/
