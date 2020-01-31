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
drop if drugnum != 44
save "$output/RVFTest.dta"
	 
// Relevant Reasons for Visit (NOT USING ABx RELATIONS)
//Collect RFV's
local geneq = geneq
local RFVMax = 0
forval year = 2006/2016 {
	use "$dataraw/namcs`year'-stata.dta", replace
	gen script`j'=.
	if `year' >= 2006 & `year' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "`v`j''"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "`v`j''"
		}
	}
	else {
		forval k = 1/30{
				replace script = 1 if DRUGID`k' == "`v`j''"
		}
	}
	sum script
	local RFVMax = r(total) + `RFVMax'
	drop if script != 1
	gen runner = _n
	forval reason =  1/`RFVMax' {
		
	}
}


//2006 RFV 3 DIAG 3
//2007 RFV 3 DIAG 3
//2008 RFV 3 DIAG 3
//2009 RFV 3 DIAG 3
//2010 RFV 3 DIAG 3
//2011 RFV 3 DIAG 3
//2012 RFV 3 DIAG 3
//2013 RFV 3 DIAG 3
//2014 RFV 5 DIAG 5
//2015 RFV 5 DIAG 5
//2016 RFV 5 DIAG 5
