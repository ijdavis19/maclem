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
ma list
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
				replace RFV`k' = 0000 if RFV`k' ==.
				replace DIAG`k' = "null" if DIAG`k' ==""
				local `year'reason`runner'k`k' = RFV`k'
				local `year'diag`runner'k`k' = DIAG`k'
			}
		}
		else {
			forval k = 1/5 {
				replace RFV`k' = 0000 if RFV`k' ==.
        replace DIAG`k' = "null" if DIAG`k' ==""
				local `year'reason`runner'k`k' = RFV`k'
				local `year'diag`runner'k`k' = DIAG`k'
			}
		}
		restore
	}
}


qui forval dataset = 2006/2016 {
	use "$output/cefotetan/scripted`dataset'", replace
	gen relRFV=0
	gen relDIAG=0
	forval year = 2006/2016 {
		forval runner = 1/`rel`year'' {
			if `year' < 2014 {
				forval k = 1/3 {
					if `dataset' < 2014 {
						forval i = 1/3 {
							drop if RFV`i' == . & relRFV != 1
							drop if DIAG`i' == "" & relDIAG != 1
							replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k''
							replace relDIAG = 1 if DIAG`i' == "``year'diag`runner'k`k''"
						}
					}
					else {
						forval i = 1/5 {
							drop if RFV`i' == . & relRFV != 1
              drop if DIAG`i' == "" & relDIAG != 1
							replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k''
              replace relDIAG = 1 if DIAG`i' == "``year'diag`runner'k`k''"
						}
					}
				}
			}
			else {
				forval k = 1/5 {
					if `dataset' < 2014 {
						forval i = 1/3 {
							drop if RFV`i' == . & relRFV != 1
							drop if DIAG`i' == "" & relDIAG != 1
							replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k''
              replace relDIAG = 1 if DIAG`i' == "``year'diag`runner'k`k''"
						}
					}
					else {
						forval i = 1/5 {
							drop if RFV`i' == . & relRFV != 1
							drop if DIAG`i' == "" & relDIAG != 1
							replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k''
              replace relDIAG = 1 if DIAG`i' == "``year'diag`runner'k`k''"
						}
					}
				}
			}
		}
	}
	save "$output/cefotetan/scripted`dataset'", replace
	drop if relRFV != 1
	save "$output/cefotetan/rfv/`dataset'", replace
	use "$output/cefotetan/scripted`dataset'", replace
	drop if relDIAG != 1
	save "$output/cefotetan/diag/`dataset'", replace
}
