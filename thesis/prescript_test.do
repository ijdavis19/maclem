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

//For simplicity, drop all but 3 observations
drop if abxnum >= 4

//Make year variable
gen p2010 = 0

//save dataset
save "$output/prescript_test.dta", replace

//Pull out geneq as a local macro
//levels geneq if abxnum == 2, local(testmac)

//Jump to new dataset
use "$dataraw\namcs2010-stata.dta", replace

//gen variable for geneq
gen script2 = 0
replace script2 = 1 if DRUGID1 == "$k2"
total script2
mat script2 = e(b)
drop script2

//bring variable to new dataset
use "$output/prescript_test.dta", replace
replace p2010 = script2[1,1] if p
if abxnum == 2

//Jump to new dataset
use "$dataraw\namcs2010-stata.dta", replace

//gen variable for geneq
gen script2 = 0
replace script2 = 1 if DRUGID1 == "$k2"
total script2
mat script2 = e(b)
drop script2

//bring variable to new dataset
use "$output/prescript_test.dta", replace
replace p2010 = script2[1,1] if abxnum == 2
