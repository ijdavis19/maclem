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

//Pull out geneq as a local macro
levels geneq if abxnum == 2, local(testmac)

//Jump to new dataset
use "$dataraw\namcs2010-stata.dta", replace

//gen variable for geneq
