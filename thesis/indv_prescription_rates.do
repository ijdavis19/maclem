/*Note: this do file is set to use the cut down csv file relating antibiotics.
Once re_abx.do is debugged, new code should be made importing the end product
of that process
*/

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

///import the pdr_info.csv
import delim "$dataraw/pdr_info.csv"

//rename variable originally titled 'int' who's name didn't carry over
rename v12 interest

//give every antibiotic an easier identifying number to work with
egen abxnum = group(geneq)

//determine highest abxnum
sum abxnum
local abh = r(max)

qui forval i = 2006/2016{
	gen p`i' = 0
	save "$output/prescript_rates.dta", replace
	forval j = 1/`abh'{
		drop if abxnum != `j'
		local v`j' = geneq
		use "$dataraw\namcs`i'-stata.dta", replace
		gen script`j' = 0
		if `i' >= 2006 & `i' < 2012{
			forval k = 1/8{
				replace script`j' = 1 if DRUGID`k' == "`v`j''"
			}
		}
		else if `i' == 2012 | `i' == 2013{
			forval k = 1/9{
				replace script`j' = 1 if DRUGID`k' == "`v`j''" 
			}
		}
		else {
			forval k = 1/30{
				replace script`j' = 1 if DRUGID`k' == "`v`j''"
			}
		}
		total script`j'
		mat script`j' = e(b)
		drop script`j'
		use "$output/prescript_rates.dta", replace
		replace p`i' = script`j'[1,1] if abxnum == `j'
		mat drop script`j'
		save "$output/prescript_rates.dta", replace
	}
}

//Improving readibility 
bys abxnum: gen indnum=_n
drop if indnum > 1
drop indicator
save "$output/prescript_rates.dta", replace
