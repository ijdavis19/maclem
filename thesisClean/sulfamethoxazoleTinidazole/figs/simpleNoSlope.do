// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"

use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace // Relevant Visit Dataset

// Run the regression
reg prescriptionIndicator genericOn [w = PATWT]

clear
set obs 132
gen monthsAfterGeneric = _n - 83
sum monthsAfterGeneric
gen genericOn = 0
replace genericOn = 1 if monthsAfterGeneric >= 0 
matrix list e(b)

gen fit = e(b)[1,2] + e(b)[1,1]*genericOn

line fit monthsAfterGeneric

// offLabel Simple No Slope Regression
use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace
reg prescriptionIndicator offLabel genericOn GOoffLabel
clear
set obs 132
gen monthsAfterGeneric = _n - 83
sum monthsAfterGeneric
gen genericOn = 0
replace genericOn = 1 if monthsAfterGeneric >= 0 
matrix list e(b)

gen ONfit = e(b)[1,4] + e(b)[1,2]*genericOn
gen OFFfit = e(b)[1,4] + e(b)[1,1] + e(b)[1,2]*genericOn  + e(b)[1,3]*genericOn
line ONfit OFFfit monthsAfterGeneric
