set more off
clear all
set matsize 1100
set maxvar 32000
set seed 0
global bootstraps 1000


//set environmet variables
global projects: env projects
global storage: env storage

// Years after average probabilities

global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"

// Bring in the data and format to time series
use "$output/panel_monthly.dta", replace
xtset drugnum monthsAfterGen

//Month After Probabilities
gen genYearMeanProb =.
gen genYearMeanProbUW=.
sum drugnum
local drugnummax = r(max)
qui forval i = 1/`drugnummax'{
        sum genmonth if drugnum == `i'
        if r(mean) != .{
                sum yearsAfterGen if drugnum == `i'
                local yearMax = r(max)
                local yearMin = r(min)
                forval y = `yearMin'/`yearMax' {
                        sum scriptraw if yearsAfterGen == `y' & drugnum == `i'
                        local numerator = r(sum)
                        sum monthTotalObs if yearsAfterGen == `y' & drugnum == `i'
                        local denominator = r(sum)
                        replace genYearMeanProb = `numerator'/(`denominator'*12)*100 if yearsAfterGen == `y' & drugnum == `i'
                        sum scriptprob if yearsAfterGen == `y' & drugnum == `i'
                        replace genYearMeanProbUW = r(mean)*100 if yearsAfterGen == `y' & drugnum == `i'
                        ma drop numerator
                        ma drop denominator
                }
        }
        ma drop yearMin
        ma drop yearMax
}
	 
// Relevant Reasons for Visit and Diagnoses (NOT USING ABx RELATIONS)
gen relReasons = 0
gen relDiagnoses = 0
save "$output/relOBS.dta", replace
//Collect Local Variables
forval drug = 1/`drugnummax' {
	use "$output/RVFTest.dta", replace
	drop if abxnum != `drug'
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
					local `year'reason`runner'k`k'drug`drug' = RFV`k'
					local `year'diag`runner'k`k'drug`drug' = DIAG`k'	
				}
			}
			else {
				forval k = 1/5 {
					replace RFV`k' = 0000 if RFV`k' ==.
					replace DIAG`k' = "null" if DIAG`k' ==""
					local `year'reason`runner'k`k'drug`drug' = RFV`k'
					local `year'diag`runner'k`k'drug`drug' = DIAG`k
				}	
			}
			restore
		}
	}
	// Count local variable appearances
	forval dataset = 2006/2016 {
		use "$dataraw/namcs`dataset'-stata.dta", replace
		gen relRFV=0
		gen relDIAG=0
		forval year = 2006/2016 {
			forval runner = 1/`rel`year'' {
				if `year' < 2014 {	
					forval k = 1/3 {
						if `dataset' < 2014 {
							forval i = 1/3 {
								drop if RFV`i' == .
								drop if DIAG`i' == ""
								replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k'drug`drug''
								replace relDIAG = 1 if DIAG`i' == "`year'diag`runner'k`k'drug`drug"
							}
						}
						else {
							forval i = 1/5 {
								drop if RFV`i' == .
								drop if DIAG`i' == ""
								replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k'drug`drug''
								replace relDIAG = 1 if DIAG`i' == "`year'diag`runner'k`k'drug`drug"
							}
						}
					}
				}
				else {
					forval k = 1/5 {
						if `dataset' < 2014 {
							forval i = 1/3 {
								drop if RFV`i' == .
								drop if DIAG`i' == ""
								replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k'drug`drug''
								replace relDIAG = 1 if DIAG`i' == "`year'diag`runner'k`k'drug`drug"
							}
						}
						else {
							forval i = 1/5 {
								drop if RFV`i' == .
								drop if DIAG`i' == ""
								replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k'drug`drug''
								replace relDIAG = 1 if DIAG`i' == "`year'diag`runner'k`k'drug`drug"
							}
						}
					}
				}
			}
		}
		forval month = 1/12 {
			sum relRFV if VMONTH == `month'
			local `dataset'reason`month'drug`drug' = r(sum)
			sum relDIAG if VMONTH == `month'
			local `dataset'diag`month'drug`drug' = r(sum)
		}
		//Bring into dataset
		use "$output/relOBS.dta", replace
		forval month = 1/12 {
			replace relReasons = ``dataset'reason`month'drug`drug'' if month == `month' & year == `dataset' & drugnum == `drug'
			replace relDiag = ``dataset'diag`month'drug`drug'' if month == `month' & year == `dataset' & drugnum == `drug'
		}
		save "$output/relOBS.dta" replace
	}
}
