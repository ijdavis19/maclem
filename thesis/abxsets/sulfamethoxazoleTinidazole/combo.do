// sulfamethoxazole abxnumber: 28
// tinidazole abxnumber: 47
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

// Relevant Reasons for Visit and Diagnoses (NOT USING ABx RELATIONS)
//Collect Local Variables
use "$output/refinedpanel.dta", replace
drop if drugnum != 28 | drugnum != 47
//BIG PROBLEM
local geneq1 = "d00119"
local geneq2 = "d04935"
local relMax = 0
ma list
qui forval year = 2006/2016 {
	use "$dataraw/namcs`year'-stata.dta", replace
	gen script=0
	if `year' >= 2006 & `year' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "`geneq1'" | DRUGID`k' == "`geneq2'"
		}
	}
	else if `year' == 2012 | `year' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "`geneq1'" | DRUGID`k' == "`geneq2'"
		}
	}
	else {
		forval k = 1/30 {
			replace script = 1 if DRUGID`k' == "`geneq1'" | DRUGID`k' == "`geneq2'"
			}
	}
	save "$output/combo/scripted`year'", replace
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
	use "$output/combo/scripted`dataset'", replace
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
	save "$output/combo/scripted`dataset'", replace
	drop if relRFV != 1
	save "$output/combo/rfv/`dataset'", replace
	use "$output/combo/scripted`dataset'", replace
	drop if relDIAG != 1
	save "$output/combo/diag/`dataset'", replace
}
 
forval year = 2006/2013 {
	use "$output/combo/diag/`year'", replace
	gen DIAG4=""
	gen DIAG5=""
	save "$output/combo/diag/`year'", replace
}


forval year = 2006/2016 {
  use "$output/combo/diag/`year'", replace
  gen year = YEAR
  keep year VMONTH AGE SEX ETHNIC PAYPRIV PAYMCARE PAYMCAID PAYSELF PAYNOCHG PAYOTH PAYDK DIAG1 DIAG2 DIAG3 DIAG4 DIAG5 CANCER CEBVD CHF COPD NOCHRON TOTCHRON TEMPF BPSYS BPDIAS PELVIC SKIN ANYIMAGE MRI XRAY OTHIMAGE CBC GLUCOSE EKG URINE WOUND NOPROVID PHYSASST RNLPN OTHPROV NODISP OTHDISP PATWT REGION PATCODE RACER AGEDAYS AGER SETTYPE script relRFV relDIAG
  save "$output/combo/diag/`year'", replace
}

use "$output/combo/diag/2006.dta", replace
forval year = 2007/2016 {
	append using "$output/combo/diag/`year'.dta"
}

gen month = VMONTH
drop VMONTH

gen firstgenyear = 2012
gen firstgenmonth = 7 //Tinidazolid is earlier in month 4
gen obsmonth = (year - 2000)*12 + month
gen genmonth = (firstgenyear - 2000)*12 + firstgenmonth
gen monthsAfterGen = obsmonth - genmonth
gen genon = 1 if  monthsAfterGen >= 0
replace genon = 0 if genon != 1
gen genon1year = 1 if monthsAfterGen >= 12
replace genon1year = 0 if genon1year != 1
save "$output/combo/diag/panel.dta",replace
