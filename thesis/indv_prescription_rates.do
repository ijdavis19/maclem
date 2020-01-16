set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


//set environmet variables
global projects: env projects
global storage: env storage
global maclem: env maclem

//general locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"
global dofiles = "$maclem/thesis"

//run pdr_info.csv cleaner
do "$dofiles/pdr_cleaner.do"

use "$output/pdr_cleaned.dta", replace

//give every antibiotic an easier identifying number to work with
egen abxnum = group(geneq)

//determine highest abxnum
sum abxnum
local abh = r(max)

qui forval i = 2006/2016{
	forval m = 0/12 {
		if `m' == 0 {
			gen p`i't = 0
			gen p`i'tprb = 0
		}
		else {
			gen p`i'mo`m' = 0
			gen p`i'mo`m'prb = 0
		}
		save "$output/prescript_rates.dta", replace
		forval j = 1/`abh'{
			drop if abxnum != `j'
			local v`j' = geneq
			if `m' == 0 {
				use "$dataraw/namcs`i'-stata.dta", replace
				gen script`j' = 0
				gen script`j'prb = 0
				gen pop = _n
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
				replace script`j'prb = script`j'
				total script`j'
				mat script`j' = e(b)
				sum pop
				replace script`j'prb = script`j'prb/r(max)
				total script`j'prb
				mat script`j'prb = e(b)
				drop script`j'
				drop script`j'prb
				drop pop
				use "$output/prescript_rates.dta", replace
				replace p`i't = script`j'[1,1] if abxnum == `j'
				replace p`i'tprb = script`j'prb[1,1] if abxnum == `j'
				save "$output/prescript_rates.dta", replace
				mat drop script`j'
				mat drop script`j'prb
			}
			else {
				use "$dataraw/namcs`i'-stata.dta", replace
				gen script`j'mo`m' = 0
				gen script`j'mo`m'prb = 0
				gen pop = _n
					if `i' >= 2006 & `i' < 2012{
						forval k = 1/8{
							replace script`j'mo`m' = 1 if DRUGID`k' == "`v`j''" & VMONTH ==`m'
						}
					}
					else if `i' == 2012 | `i' == 2013{
						forval k = 1/9{
							replace script`j'mo`m'  = 1 if DRUGID`k' == "`v`j''" & VMONTH == `m'
						}
					}
					else {
						forval k = 1/30{
							replace script`j'mo`m' = 1 if DRUGID`k' == "`v`j''" & VMONTH == `m'
						}
					}
				replace script`j'mo`m'prb = script`j'mo`m'
				total script`j'mo`m'
				mat script`j'mo`m' = e(b)
				sum pop if VMONTH == `m'
				replace script`j'mo`m'prb = script`j'mo`m'prb/r(max)
				total script`j'mo`m'prb
				mat script`j'mo`m'prb = e(b)
				drop script`j'mo`m'
				drop script`j'mo`m'prb
				drop pop
				use "$output/prescript_rates.dta", replace
				replace p`i'mo`m' = script`j'mo`m'[1,1] if abxnum == `j'
				replace p`i'mo`m'prb = script`j'mo`m'prb[1,1] if abxnum == `j'
				save "$output/prescript_rates.dta", replace
				mat drop script`j'mo`m'
				mat drop script`j'mo`m'prb
			}
		save "$output/prescript_rates.dta", replace
		}
	}
}

//Improving readibility
/*Note: this do file is set to use the cut down csv file relating antibiotics.
Once re_abx.do is debugged, new code should be made importing the end product
of that process
*/

bys abxnum: gen indnum=_n
drop if indnum > 1
drop indicator
save "$output/prescript_rates.dta", replace

/*Form matrix of new data set
Transpose matrix
make plots*/
