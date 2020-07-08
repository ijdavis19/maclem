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

// Simplify Indicators
gen govInsurance = 0
replace govInsurance = 1 if payRecode == 1 | payRecode == 2
gen GOgovInsurance = govInsurance*genericOn
gen south = 0
replace south = 1 if REGION == 3
gen intAge = AGE*monthsAfterGeneric
gen intAgeSQ = ageSQ*monthsAfterGeneric
gen nonwhite = 0
replace nonwhite = 1 if RACER != 1

// Relabel Indicators
rename monthsAfterGeneric timeSinceGeneric
rename OFmonthsAfter offLabelINT
rename AGE age
rename intAge ageINT
rename intAgeSQ AgeSQINT


eststo: reg prescriptionIndicator timeSinceGeneric offLabel offLabelINT age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 0
mat Before = e(b)
eststo: reg prescriptionIndicator timeSinceGeneric offLabel offLabelINT age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 1
mat After = e(b)

// esttab using "$tables/comp.tex", stats(r2 N) title(Before and After Generic Comparison\label{tab1}) replace

// Get differences
mat Diff = [.]
forval x = 1/10 {
    mat diff`x' = After[1,`x'] - Before[1,`x']
    mat Diff = Diff\diff`x'
}
mat Diff = Diff[2...,1...]
mat list Diff


//Use SUR to account for correlation across four periods and conduct tests about
//means of scarce quantities sold in each period of all markets for r = 0.25.
regress prescriptionIndicator timeSinceGeneric offLabel offLabelINT age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 0
estimate store Before
regress prescriptionIndicator timeSinceGeneric offLabel offLabelINT age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 1
estimate store After
suest Before After

//Does the mean of the quantity sold in any one of four periods of all markets 
//differ from the mean in at least one other period for r = 0.25? 
test [Before_mean]_cons = [After_mean]_cons
test [Before_mean]timeSinceGeneric = [After_mean]timeSinceGeneric
test [Before_mean]offLabel = [After_mean]offLabel
test [Before_mean]offLabelINT = [After_mean]offLabelINT
test [Before_mean]age = [After_mean]age
test [Before_mean]ageSQ = [After_mean]ageSQ
test [Before_mean]ageINT = [After_mean]ageINT
test [Before_mean]AgeSQINT = [After_mean]AgeSQINT
test [Before_mean]govInsurance = [After_mean]govInsurance
test [Before_mean]nonwhite = [After_mean]nonwhite

// More interesting tests
// Base Case
mat Base = [Before_mean]_cons // Before
test [Before_mean]_cons = 0
mat Base = Base\r(p)
mat Base = Base\[After_mean]_cons // After
test [After_mean]_cons = 0
mat Base = Base\r(p)
mat Base = Base\([After_mean]_cons - [Before_mean]_cons) // Difference
test [Before_mean]_cons = [After_mean]_cons
mat Base = Base\r(p)

// Off Label
mat Off = [Before_mean]_cons + [Before_mean]offLabel 
test [Before_mean]_cons + [Before_mean]offLabel = 0
mat Off = Off\r(p)
mat Off = Off\([After_mean]_cons  + [After_mean]offLabel)
test [After_mean]_cons + [After_mean]offLabel = 0
mat Off = Off\r(p)
mat Off = Off\([After_mean]_cons + [After_mean]offLabel  - [Before_mean]_cons - [Before_mean]offLabel)
test [Before_mean]_cons + [Before_mean]offLabel = [After_mean]_cons + [After_mean]offLabel
mat Off = Off\r(p)

// Government Insurance
mat Gov = [Before_mean]_cons
test [Before_mean]_cons = 0
mat Gov = Gov\r(p)
mat Gov = Gov\([After_mean]_cons  + [After_mean]govInsurance)
test [After_mean]_cons + [After_mean]govInsurance = 0
mat Gov = Gov\r(p)
mat Gov = Gov\([After_mean]_cons + [After_mean]govInsurance  - [Before_mean]_cons)
test [Before_mean]_cons = [After_mean]_cons + [After_mean]govInsurance
mat Gov = Gov\r(p)

// Non White
mat NonWhite = [Before_mean]_cons
test [Before_mean]_cons = 0
mat NonWhite = NonWhite\r(p)
mat NonWhite = NonWhite\([After_mean]_cons  + [After_mean]nonwhite)
test [After_mean]_cons + [After_mean]nonwhite = 0
mat NonWhite = NonWhite\r(p)
mat NonWhite = NonWhite\([After_mean]_cons + [After_mean]nonwhite  - [Before_mean]_cons)
test [Before_mean]_cons = [After_mean]_cons + [After_mean]nonwhite
mat NonWhite = NonWhite\r(p)

