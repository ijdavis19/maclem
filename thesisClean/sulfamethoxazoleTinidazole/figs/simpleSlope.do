// esttab using "$figures/genderRegressions.tex", stats(r2 N) title(Gendered Regression table (1 = Male 2 = Female)\label{tab1})
// esttab using "$figures/genderRegressions.tex", stats(r2 N) title(Gendered Regression table (1 = Male 2 = Female)\label{tab1})
// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"
global tables = "$output/tables"

use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace // Relevant Visit Dataset

eststo: reg prescriptionIndicator monthsAfterGeneric GOmonthsAfter genericOn [w = PATWT]
esttab using "$tables/simpleSlope.tex", stats(r2 N) title(Simple Slope Table\label{tab1})

mat list e(b)

clear
set obs 132
gen monthsAfterGeneric = _n - 83
sum monthsAfterGeneric
gen genericOn = 0
replace genericOn = 1 if monthsAfterGeneric >= 0
gen GOmonthsAfter = genericOn*monthsAfterGeneric
gen fit = e(b)[1,4] + monthsAfterGeneric*e(b)[1,1] + GOmonthsAfter*e(b)[1,2] + genericOn*e(b)[1,3]

line fit monthsAfterGeneric

// offLabel Simple Regression
use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace
eststo: reg prescriptionIndicator monthsAfterGeneric OFmonthsAfter GOmonthsAfter OFGOmonthsAfter offLabel GOoffLabel genericOn [w = PATWT]
esttab using "$tables/simpleSlopeOnOff.tex", stats(r2 N) title(Simple Slope Table OnOff\label{tab1})

clear
set obs 132
gen monthsAfterGeneric = _n - 83
sum monthsAfterGeneric
gen genericOn = 0
replace genericOn = 1 if monthsAfterGeneric >= 0
gen GOmonthsAfter = genericOn*monthsAfterGeneric
mat list e(b)
gen ONfit = e(b)[1,8] + monthsAfterGeneric*e(b)[1,1] + GOmonthsAfter*e(b)[1,3] + genericOn*e(b)[1,7]
gen OFFfit = e(b)[1,8] + e(b)[1,5] + monthsAfterGeneric*e(b)[1,1] + monthsAfterGeneric*e(b)[1,2] + genericOn*e(b)[1,7] + genericOn*e(b)[1,6]*0 + GOmonthsAfter*e(b)[1,3] + GOmonthsAfter*e(b)[1,4]*0
line ONfit OFFfit monthsAfterGeneric

// offLabelSuperComplex
use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace
reg prescriptionIndicator monthsAfterGeneric OFmonthsAfter GOmonthsAfter OFGOmonthsAfter offLabel GOoffLabel genericOn age GOage ageSQ GOageSQ o5.i.payRecode o5.i.GOpayRecode i.season i.GOseason o1.i.SEX o1.i.GOsex i.RACER o1.i.GOrace i.REGION o1.i.GOregion [w = PATWT]
clear
set obs 132
gen monthsAfterGeneric = _n - 83
sum monthsAfterGeneric
gen genericOn = 0
replace genericOn = 1 if monthsAfterGeneric >= 0
gen GOmonthsAfter = genericOn*monthsAfterGeneric
mat list e(b)
gen ONfit = e(b)[1,56] + monthsAfterGeneric*e(b)[1,1] + GOmonthsAfter*e(b)[1,3]*0 + genericOn*e(b)[1,7]
gen OFFfit = e(b)[1,56] + e(b)[1,5] + monthsAfterGeneric*e(b)[1,1] + monthsAfterGeneric*e(b)[1,2] + genericOn*e(b)[1,7]*0 + genericOn*e(b)[1,6]*0 + GOmonthsAfter*e(b)[1,3]*0 + GOmonthsAfter*e(b)[1,4]*0
line ONfit OFFfit monthsAfterGeneric
