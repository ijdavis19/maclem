clear all

// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"
global tables = "$dofiles/figs/tables/finalTable"

use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace

// Simplify Payments
gen govInsurance = 0
replace govInsurance = 1 if payRecode == 1 | payRecode == 2
gen GOgovInsurance = govInsurance*genericOn
gen south = 0
replace south = 1 if REGION == 3

eststo: reg prescriptionIndicator monthsAfterGeneric offLabel OFmonthsAfter govInsurance south AGE ageSQ [w = PATWT] if genericOn == 0
mat Before = e(b)
eststo: reg prescriptionIndicator monthsAfterGeneric offLabel OFmonthsAfter govInsurance south AGE ageSQ [w = PATWT] if genericOn == 1
mat After = e(b)
// esttab using "$tables/comp.tex", stats(r2 N) title(Before and After Generic Comparison\label{tab1}) replace

// Get differences
mat Diff = [.]
forval x = 1/8 {
    mat diff`x' = After[1,`x'] - Before[1,`x']
    mat Diff = Diff\diff`x'
}
mat Diff = Diff[2...,1...]
mat list Diff