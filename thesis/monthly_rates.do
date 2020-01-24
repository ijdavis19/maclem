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
replace scriptprob = scriptprob*100

// Label Variables Better
label variable scriptprob "Probability of Prescription"
label variable genYearMeanProb "Yearly Weighted Mean Probability"
save "$output/panel_monthly_graphset.dta", replace

//Graphs
forval i = 1/`drugnummax'{
	use "$output/panel_monthly_graphset.dta", replace
	drop if drugnum != `i'
	sum genmonth
	if r(mean) != .{
		drop if drugnum != `i'
		sum monthsAfterGen
		local monthMin = ceil(r(min)/12)*12
		local monthMax = floor(r(max)/12)*12
		local antibiotic = strproper(drug)
		xtline scriptprob genYearMeanProb, ///
			xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
			title(`antibiotic') ///
		graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")
		ma drop monthMax monthMin antibiotic
	}
}


/*
// Label Variables Better
drop if drugnum != 21
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
	xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
	title(`antibiotic')

*/
