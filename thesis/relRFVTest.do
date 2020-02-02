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

//Month After Probabilities & Graphs
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


//Drop everything that isn't my test antibiotic
gen relReasons = 0
gen relDiagnoses = 0
drop if drugnum != 44
save "$output/RVFTest.dta", replace
	 
// Relevant Reasons for Visit and Diagnoses (NOT USING ABx RELATIONS)
//Collect Local Variables
local geneq = geneq
forval year = 2006/2016 {
	use "$dataraw/namcs`year'-stata.dta", replace
	gen script`j'=.
	if `year' >= 2006 & `year' < 2014{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "`v`j''"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "`v`j''"
		}
	}
	sum script
	local rel`year' = r(total)
	local RelMax = rel`year' + `RFVMax'
	drop if script != 1
	gen runner = _n
	forval runner =  1/`Rel`year'' {
		if `year' < 2014 {
			forval k =  1/3 {
				local `year'reason`runner'k`k' = RFV`k' if runner == `runner'
				local `year'diag`runner'k`k' = DIAG`k' if runner == `runner'			
			}
		}
		else {
			forval k = 1/5 {
				local `year'reason`runner'k`k' = RFV`k' if runner == `runner'
				local `year'diag`runner'k`k' = DIAG`k' if runner == `runner'
			}	
		}
	}
}

forval dataset = 2006/2016 {
	use "$dataraw/namcs`dataset'-stata.dta", replace
	gen relRFV=0
	gen relDIAG=0
	forval year = 2006/2016 {
		forval runner = 1/`Rel`year'' {
			if `year' < 2014 {	
				forval k = 1/3 {
					if `dataset' < 2014 {
						forval i = 1/3 {
							replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k''
							replace relDIAG = 1 if RFV`i' == ``year'diag`runner'k`k''
						}
					}
					else {
						forval i = 1/5 {
							replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k''
               	                                        replace relDIAG = 1 if RFV`i' == ``year'diag`runner'k`k''
						}
					}
				}
			}
			else {
				forval k = 1/5 {
					if `dataset' < 2014 {
						forval i = 1/3 {
							replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k''
                                                        replace relDIAG = 1 if RFV`i' == ``year'diag`runner'k`k''
						}
					}
					else {
						forval i = 1/5 {
							replace relRFV = 1 if RFV`i' == ``year'reason`runner'k`k''
                                                        replace relDIAG = 1 if RFV`i' == ``year'diag`runner'k`k''
						}
					}
				}
			}
		}
	}
	forval month = 1/12 {
		sum relRFV if VMONTH == `month'
		local `dataset'reason`month' = r(total)
		sum relDIAG if VMONTH == `month'
		local `dataset'diag`month' =r(total)
	}
	use "$output/RVFTest.dta", replace
	forval month = 1/12 {
		replace relReasons = ``dataset'reason`month'' if month == `month' & year == `year'
		replace relDiag = ``dataset'diag`month'' if month == `month' & year == `year'
	}
	save "$output/RVFTest.dta", replace
}
