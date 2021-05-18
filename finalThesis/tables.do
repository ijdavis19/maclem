// replace timeSinceGeneric = timeSinceGeneric - 4
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
rename offLabelUnspecCellandAbscess unspecCellAbscess
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

//Test
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
********* More interesting tests and figures *************
sum age if genericOn == 0
local ageEXPB = r(mean)*Before[1,4]
sum ageSQ if genericOn == 0
local ageSQEXP = r(mean)
sum ageINT if genericOn == 0
local ageINTEXP = r(mean)
sum AgeSQINT if genericOn == 0
local AgeSQINTEXP = r(mean)
sum GOgovInsurance if genericOn == 0
local GOgovInsuranceEXP = r(mean)
sum nonwhite if genericOn == 0
local nonwhiteEXP = r(mean)

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

// More strict tests
test [Before_mean]_cons + [Before_mean]govInsurance = [After_mean]_cons + [After_mean]govInsurance
test [Before_mean]_cons + [Before_mean]nonwhite = [After_mean]_cons + [After_mean]nonwhite
reg prescriptionIndicator timeSinceGeneric age ageSQ ageINT AgeSQINT govInsurance nonwhite offLabel offLabelINT [w = PATWT] if genericOn == 0
reg prescriptionIndicator timeSinceGeneric age ageSQ ageINT AgeSQINT govInsurance nonwhite offLabel offLabelINT [w = PATWT] if genericOn == 1

// Abcess
eststo: reg prescriptionIndicator timeSinceGeneric age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 0 & unspecCellAbscess  == 1
estimate store SkinBefore
mat SkinBefore = e(b)
eststo: reg prescriptionIndicator timeSinceGeneric age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 1 & unspecCellAbscess  == 1
estimate store SkinAfter
mat SkinAfter = e(b)
// esttab using "$tables/abscess.tex", stats(r2 N) title(Before and After Generic Comparison\label{tab1}) replace

mat Diff = [.]
forval x = 1/8 {
    mat diff`x' = SkinAfter[1,`x'] - SkinBefore[1,`x']
    mat Diff = Diff\diff`x'
}
mat Diff = Diff[2...,1...]
mat list Diff

suest SkinBefore SkinAfter
test [SkinBefore_mean]_cons = [SkinAfter_mean]_cons
test [SkinBefore_mean]timeSinceGeneric = [SkinAfter_mean]timeSinceGeneric
test [SkinBefore_mean]age = [SkinAfter_mean]age
test [SkinBefore_mean]ageSQ = [SkinAfter_mean]ageSQ
test [SkinBefore_mean]ageINT = [SkinAfter_mean]ageINT
test [SkinBefore_mean]AgeSQINT = [SkinAfter_mean]AgeSQINT
test [SkinBefore_mean]govInsurance = [SkinAfter_mean]govInsurance
test [SkinBefore_mean]nonwhite = [SkinAfter_mean]nonwhite

// Exp Differences Table
sum age [w = PATWT] if genericOn == 0
local age0 = r(mean)
sum age [w = PATWT] if genericOn == 1
local age1 = r(mean)
sum ageSQ [w = PATWT] if genericOn == 0
local ageSQ0 = r(mean)
sum ageSQ [w = PATWT] if genericOn == 1
local ageSQ1 = r(mean)
sum govInsurance [w = PATWT] if genericOn == 0
local govInsurance0 = r(mean)
sum govInsurance [w = PATWT] if genericOn == 1
local govInsurance1 = r(mean)
sum nonwhite [w = PATWT] if genericOn == 0
local nonwhite0 = r(mean)
sum nonwhite [w = PATWT] if genericOn == 1
local nonwhite1 = r(mean)
regress prescriptionIndicator timeSinceGeneric offLabel offLabelINT age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 0
estimate store Before
regress prescriptionIndicator timeSinceGeneric offLabel offLabelINT age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 1
estimate store After
suest Before After

// On Label
local onLabelEst0 = [Before_mean]_cons + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + `govInsurance0'*[Before_mean]govInsurance + `nonwhite0'*[Before_mean]nonwhite
local onLabelEst1 = [After_mean]_cons + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + `govInsurance1'*[After_mean]govInsurance + `nonwhite1'*[After_mean]nonwhite
local onLabelDiff = `onLabelEst1' - `onLabelEst0'
display "First Estimate: `onLabelEst0'"
display "Second Estimate: `onLabelEst1'"
display "Difference: `onLabelDiff'"
test [Before_mean]_cons + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + `govInsurance0'*[Before_mean]govInsurance + `nonwhite0'*[Before_mean]nonwhite = 0
test [After_mean]_cons + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + `govInsurance1'*[After_mean]govInsurance + `nonwhite1'*[After_mean]nonwhite = 0
test [Before_mean]_cons + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + `govInsurance0'*[Before_mean]govInsurance + `nonwhite0'*[Before_mean]nonwhite = [After_mean]_cons + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + `govInsurance1'*[After_mean]govInsurance + `nonwhite1'*[After_mean]nonwhite

// Off Label
local offLabelEst0 = [Before_mean]_cons + [Before_mean]offLabel + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + `govInsurance0'*[Before_mean]govInsurance + `nonwhite0'*[Before_mean]nonwhite
local offLabelEst1 = [After_mean]_cons + [After_mean]offLabel + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + `govInsurance1'*[After_mean]govInsurance + `nonwhite1'*[After_mean]nonwhite
local offLabelDiff = `offLabelEst1' - `offLabelEst0'
display "First Estimate: `offLabelEst0'"
display "Second Estimate: `offLabelEst1'"
display "Difference: `offLabelDiff'"
test [Before_mean]_cons + [Before_mean]offLabel + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + `govInsurance0'*[Before_mean]govInsurance + `nonwhite0'*[Before_mean]nonwhite = 0
test [After_mean]_cons + [After_mean]offLabel + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + `govInsurance1'*[After_mean]govInsurance + `nonwhite1'*[After_mean]nonwhite = 0
test [Before_mean]_cons + [Before_mean]offLabel + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + `govInsurance0'*[Before_mean]govInsurance + `nonwhite0'*[Before_mean]nonwhite = [After_mean]_cons + [After_mean]offLabel + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + `govInsurance1'*[After_mean]govInsurance + `nonwhite1'*[After_mean]nonwhite

// Government Insurance
local govInsuranceEst0 = [Before_mean]_cons + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + [Before_mean]govInsurance + `nonwhite0'*[Before_mean]nonwhite
local govInsuranceEst1 = [After_mean]_cons + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + [After_mean]govInsurance + `nonwhite1'*[After_mean]nonwhite
local govInsuranceDiff = `govInsuranceEst1' - `govInsuranceEst0'
display "First Estimate: `govInsuranceEst0'"
display "Second Estimate: `govInsuranceEst1'"
display "Difference: `govInsuranceDiff'"
test [Before_mean]_cons + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + [Before_mean]govInsurance + `nonwhite0'*[Before_mean]nonwhite = 0
test [After_mean]_cons + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + [After_mean]govInsurance + `nonwhite1'*[After_mean]nonwhite = 0
test [Before_mean]_cons + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + [Before_mean]govInsurance + `nonwhite0'*[Before_mean]nonwhite = [After_mean]_cons + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + [After_mean]govInsurance + `nonwhite1'*[After_mean]nonwhite

// Non White
local nonWhiteEst0 = [Before_mean]_cons + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + `govInsurance0'*[Before_mean]govInsurance + [Before_mean]nonwhite
local nonWhiteEst1 = [After_mean]_cons + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + `govInsurance1'*[After_mean]govInsurance + [After_mean]nonwhite
local nonWhiteDiff = `nonWhiteEst1' - `nonWhiteEst0'
display "First Estimate: `nonWhiteEst0'"
display "Second Estimate: `nonWhiteEst1'"
display "Difference: `nonWhiteDiff'"
test [Before_mean]_cons + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + `govInsurance0'*[Before_mean]govInsurance + [Before_mean]nonwhite = 0
test [After_mean]_cons + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + `govInsurance1'*[After_mean]govInsurance + [After_mean]nonwhite = 0
test [Before_mean]_cons + `age0'*[Before_mean]age + `ageSQ0'*[Before_mean]ageSQ + `govInsurance0'*[Before_mean]govInsurance + [Before_mean]nonwhite = [After_mean]_cons + `age1'*[After_mean]age + `ageSQ1'*[After_mean]ageSQ + `govInsurance1'*[After_mean]govInsurance + [After_mean]nonwhite

// Abscess
sum age [w = PATWT] if genericOn == 0 & unspecCellAbscess == 1
local age0AC = r(mean)
sum age [w = PATWT] if genericOn == 1 & unspecCellAbscess == 1
local age1AC = r(mean)
sum ageSQ [w = PATWT] if genericOn == 0 & unspecCellAbscess == 1
local ageSQ0AC = r(mean)
sum ageSQ [w = PATWT] if genericOn == 1 & unspecCellAbscess == 1
local ageSQ1AC = r(mean)
sum govInsurance [w = PATWT] if genericOn == 0 & unspecCellAbscess == 1
local govInsurance0AC = r(mean)
sum govInsurance [w = PATWT] if genericOn == 1 & unspecCellAbscess == 1
local govInsurance1AC = r(mean)
sum nonwhite [w = PATWT] if genericOn == 0 & unspecCellAbscess == 1
local nonwhite0AC = r(mean)
sum nonwhite [w = PATWT] if genericOn == 1 & unspecCellAbscess == 1
local nonwhite1AC = r(mean)
reg prescriptionIndicator timeSinceGeneric age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 0 & unspecCellAbscess  == 1
estimate store SkinBefore
reg prescriptionIndicator timeSinceGeneric age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 1 & unspecCellAbscess  == 1
estimate store SkinAfter
suest SkinBefore SkinAfter
local abscessEst0 = [SkinBefore_mean]_cons + `age0AC'*[SkinBefore_mean]age + `ageSQ0AC'*[SkinBefore_mean]ageSQ + `govInsurance0AC'*[SkinBefore_mean]govInsurance + `nonwhite0AC'*[SkinBefore_mean]nonwhite
local abscessEst1 = [SkinAfter_mean]_cons + `age1AC'*[SkinAfter_mean]age + `ageSQ1AC'*[SkinAfter_mean]ageSQ + `govInsurance1AC'*[SkinAfter_mean]govInsurance + `nonwhite1AC'*[SkinAfter_mean]nonwhite
local abscessDiff = `abscessEst1' - `abscessEst0'
display "First Estimate: `abscessEst0'"
display "Second Estimate: `abscessEst1'"
display "Difference: `abscessDiff'"
test [SkinBefore_mean]_cons + `age0AC'*[SkinBefore_mean]age + `ageSQ0AC'*[SkinBefore_mean]ageSQ + `govInsurance0AC'*[SkinBefore_mean]govInsurance + `nonwhite0AC'*[SkinBefore_mean]nonwhite = 0
test [SkinAfter_mean]_cons + `age1AC'*[SkinAfter_mean]age + `ageSQ1AC'*[SkinAfter_mean]ageSQ + `govInsurance1AC'*[SkinAfter_mean]govInsurance + `nonwhite1AC'*[SkinAfter_mean]nonwhite = 0
test [SkinBefore_mean]_cons + `age0AC'*[SkinBefore_mean]age + `ageSQ0AC'*[SkinBefore_mean]ageSQ + `govInsurance0AC'*[SkinBefore_mean]govInsurance + `nonwhite0AC'*[SkinBefore_mean]nonwhite = [SkinAfter_mean]_cons + `age1AC'*[SkinAfter_mean]age + `ageSQ1AC'*[SkinAfter_mean]ageSQ + `govInsurance1AC'*[SkinAfter_mean]govInsurance + `nonwhite1AC'*[SkinAfter_mean]nonwhite


save "$output/temp.dta", replace


// Exp Graphs
use "$output/temp.dta", replace
regress prescriptionIndicator timeSinceGeneric offLabel offLabelINT age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 0
mat Before = e(b)
regress prescriptionIndicator timeSinceGeneric offLabel offLabelINT age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 1
mat After = e(b)
reg prescriptionIndicator timeSinceGeneric age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 0 & unspecCellAbscess  == 1
mat SkinBefore = e(b)
reg prescriptionIndicator timeSinceGeneric age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 1 & unspecCellAbscess  == 1
mat SkinAfter = e(b)
drop if _n > 132
replace timeSinceGeneric = _n - 80
keep timeSinceGeneric
gen genericOn = 0
replace genericOn = 1 if timeSinceGeneric >= 0


// Standard On and Off Label
gen ONfit = Before[1,10] + timeSinceGeneric*Before[1,1] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*Before[1,6]*timeSinceGeneric + `ageSQ0'*timeSinceGeneric*Before[1,7] + `govInsurance0'*Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace ONfit = After[1,10] + timeSinceGeneric*After[1,1] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + `govInsurance0'*After[1,8] + `nonwhite0'*After[1,9] if genericOn == 1
gen OFFfit = Before[1,10] + timeSinceGeneric*Before[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*timeSinceGeneric*Before[1,6] + `ageSQ0'*timeSinceGeneric*Before[1,7] + `govInsurance0'*Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace OFFfit = After[1,10] + timeSinceGeneric*After[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + `govInsurance0'*After[1,8] + `nonwhite0'*After[1,9] if genericOn == 1
label variable ONfit "Probability of On-Label Prescription"
label variable OFFfit "Probability of Off-Label Prescription"
label variable timeSinceGeneric "Months Since Entry of Generic"
line ONfit OFFfit timeSinceGeneric, legend(rows(2))


// GovInsurance
gen ONfitGI = Before[1,10] + timeSinceGeneric*Before[1,1] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*Before[1,6]*timeSinceGeneric + `ageSQ0'*timeSinceGeneric*Before[1,7] + Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace ONfitGI = After[1,10] + timeSinceGeneric*After[1,1] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + After[1,8] + `nonwhite0'*After[1,9] if genericOn == 1
gen OFFfitGI = Before[1,10] + timeSinceGeneric*Before[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*timeSinceGeneric*Before[1,6] + `ageSQ0'*timeSinceGeneric*Before[1,7] + Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace OFFfitGI = After[1,10] + timeSinceGeneric*After[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + After[1,8] + `nonwhite1'*After[1,9] if genericOn == 1
sum ONfitGI
sum OFFfitGI
line ONfitGI OFFfitGI timeSinceGeneric, legend(rows(2))

// NonWhite
gen ONfitNW = Before[1,10] + timeSinceGeneric*Before[1,1] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*Before[1,6]*timeSinceGeneric + `ageSQ0'*timeSinceGeneric*Before[1,7] + `govInsurance0'*Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace ONfitNW = After[1,10] + timeSinceGeneric*After[1,1] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + `govInsurance1'*After[1,8] + After[1,9] if genericOn == 1
gen OFFfitNW = Before[1,10] + timeSinceGeneric*Before[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*timeSinceGeneric*Before[1,6] + `ageSQ0'*timeSinceGeneric*Before[1,7] + `govInsurance0'*Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace OFFfitNW = After[1,10] + timeSinceGeneric*After[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + `govInsurance1'*After[1,8] + After[1,9] if genericOn == 1
sum ONfitNW
sum OFFfitNW
line ONfitNW OFFfitNW timeSinceGeneric, legend(rows(2))

// Abcess and Cellulitis
gen ONfitCell = SkinBefore[1,8] + timeSinceGeneric*SkinBefore[1,1] + `age0AC'*SkinBefore[1,2] + `ageSQ0AC'*SkinBefore[1,3] + `age0AC'*SkinBefore[1,4]*timeSinceGeneric + `ageSQ0AC'*timeSinceGeneric*SkinBefore[1,5] + `govInsurance0AC'*SkinBefore[1,6] + `nonwhite0AC'*SkinBefore[1,7] if genericOn == 0
replace ONfitCell = SkinAfter[1,8] + timeSinceGeneric*SkinAfter[1,1] + `age1AC'*SkinAfter[1,2] + `ageSQ1AC'*SkinAfter[1,3] + `age1AC'*timeSinceGeneric*SkinAfter[1,4] + `ageSQ1AC'*timeSinceGeneric*SkinAfter[1,5] + `govInsurance0AC'*SkinAfter[1,6] + `nonwhite0AC'*SkinAfter[1,7] if genericOn == 1
replace ONfitCell = SkinAfter[1,8] + timeSinceGeneric*SkinAfter[1,1] + `age1AC'*SkinAfter[1,2] + `ageSQ1AC'*SkinAfter[1,3] + `age1AC'*timeSinceGeneric*SkinAfter[1,4] + `ageSQ1AC'*timeSinceGeneric*SkinAfter[1,5] + `govInsurance1AC'*SkinAfter[1,6] + `nonwhite1AC'*SkinAfter[1,7] if genericOn == 1
label variable ONfitCell "Probability of Prescription"
line ONfitCell timeSinceGeneric, legend(rows(2))

*****************************************************************************************************************************************
use "$output/temp.dta", replace
local cats = "offLabel govInsurance nonwhite"
foreach cat in `cats' {
    display "`cat'"
    sum prescriptionIndicator [w = PATWT] if `cat' == 1
    sum prescriptionIndicator [w = PATWT] if genericOn == 0 & `cat' == 1
    sum prescriptionIndicator [w = PATWT] if genericOn == 1 & `cat' == 1
}
// Proportions table
sum prescriptionIndicator [w = PATWT]
tab prescriptionIndicator
sum prescriptionIndicator [w = PATWT] if genericOn == 0
tab prescriptionIndicator if genericOn == 0
sum prescriptionIndicator [w = PATWT] if genericOn == 1
tab prescriptionIndicator if genericOn == 1
local cats = "offLabel govInsurance nonwhite unspecCellAbscess"
foreach cat in `cats' {
    display `cat'
    forval x = 1/2 {
        sum prescriptionIndicator [w = PATWT] if `cat' == 2 -`x'
        tab prescriptionIndicator if `cat' == 2 -`x'
        sum prescriptionIndicator [w = PATWT] if genericOn == 0 & `cat' == 2 -`x'
        tab prescriptionIndicator if genericOn == 0 & `cat' == 2 -`x'
        sum prescriptionIndicator [w = PATWT] if genericOn == 1 & `cat' == 2 -`x'
        tab prescriptionIndicator if genericOn == 1 & `cat' == 2 -`x'
    }
}

// Independent Variable Tables
local vars = "timeSinceGeneric age ageSQ offLabel govInsurance nonwhite unspecCellAbscess"
foreach var in `vars'{
    display "Var:`var'"
    sum `var' [w = PATWT]
    sum `var' [w = PATWT] if genericOn == 0
    sum `var' [w = PATWT] if genericOn == 1
}
********************************************************************************************************************************
// Standard Proportions Graph
preserve
sum timeSinceGeneric
local monthMin = r(min)
local monthMax = r(max)
gen monthProb = 0
gen ONmonthProb = 0
gen OFFmonthProb = 0
forval month = `monthMin'/`monthMax' {
    sum prescriptionIndicator if timeSinceGeneric == `month'
    replace monthProb = r(mean) if timeSinceGeneric == `month'
    sum prescriptionIndicator if timeSinceGeneric == `month' & onLabel == 1
    replace ONmonthProb = r(mean) if timeSinceGeneric == `month'
    sum prescriptionIndicator if timeSinceGeneric == `month' & offLabel == 1
    replace OFFmonthProb = r(mean) if timeSinceGeneric == `month'
}
bysort timeSinceGeneric: gen timeCount = _n
drop if timeCount > 1
tab timeSinceGeneric
line monthProb timeSinceGeneric
restore

// Three Month Moving Average
sum timeSinceGeneric
local monthMin = r(min)
local 3monthMinMA = r(min) + 3
local monthMax = r(max)
gen monthVisits = 0
gen monthScripts = 0
gen counter = 1
forval month = `monthMin'/`monthMax' {
    sum counter if timeSinceGeneric == `month'
    replace monthVisits = r(sum) if timeSinceGeneric == `month'
    sum prescriptionIndicator if timeSinceGeneric == `month'
    replace monthScripts = r(sum) if timeSinceGeneric == `month'
}
gen threeMonthVisits = 0
gen threeMonthScripts = 0
save "$output/temp.dta", replace
forval month = `3monthMinMA'/`monthMax' {
    local 3MONTHV = 0
    local 3MONTHS = 0
    forval x = 0/2 {
        use "$output/temp.dta", replace
        drop if timeSinceGeneric != `month' - `x'
        local VISITADDER = monthVisits
        local 3MONTHV = `3MONTHV' + `VISITADDER'
        local SCRIPTADDER = monthScripts
        local 3MONTHS = `3MONTHS' + `SCRIPTADDER'
    }
    use "$output/temp.dta", replace
    replace threeMonthVisits = `3MONTHV' if timeSinceGeneric == `month'
    replace threeMonthScripts = `3MONTHS' if timeSinceGeneric == `month'
    save "$output/temp.dta", replace
}
gen threeMonthMA = threeMonthScripts/threeMonthVisits
save "$output/temp.dta", replace
bysort timeSinceGeneric: gen timeCount = _n
drop if timeCount > 1
line threeMonthMA timeSinceGeneric

// Three Month Moving Average (On Label)
use "$output/temp.dta", replace
gen ONmonthVisits = 0
gen ONmonthScripts = 0
forval month = `monthMin'/`monthMax' {
    sum counter if timeSinceGeneric == `month' & onLabel == 1
    replace ONmonthVisits = r(sum) if timeSinceGeneric == `month'
    sum prescriptionIndicator if timeSinceGeneric == `month' & onLabel == 1
    replace ONmonthScripts = r(sum) if timeSinceGeneric == `month'
}
gen ONthreeMonthVisits = 0
gen ONthreeMonthScripts = 0
save "$output/temp.dta", replace
forval month = `3monthMinMA'/`monthMax' {
    local 3MONTHV = 0
    local 3MONTHS = 0
    forval x = 0/2 {
        use "$output/temp.dta", replace
        drop if timeSinceGeneric != `month' - `x'
        local VISITADDER = ONmonthVisits
        local 3MONTHV = `3MONTHV' + `VISITADDER'
        local SCRIPTADDER = ONmonthScripts
        local 3MONTHS = `3MONTHS' + `SCRIPTADDER'
    }
    use "$output/temp.dta", replace
    replace ONthreeMonthVisits = `3MONTHV' if timeSinceGeneric == `month'
    replace ONthreeMonthScripts = `3MONTHS' if timeSinceGeneric == `month'
    save "$output/temp.dta", replace
}
gen ONthreeMonthMA = ONthreeMonthScripts/ONthreeMonthVisits
save "$output/temp.dta", replace
bysort timeSinceGeneric: gen timeCount = _n
drop if timeCount > 1
line ONthreeMonthMA timeSinceGeneric

// Three Month Moving Average (Off Label)
use "$output/temp.dta", replace
gen OFFmonthVisits = 0
gen OFFmonthScripts = 0
forval month = `monthMin'/`monthMax' {
    sum counter if timeSinceGeneric == `month' & offLabel == 1
    replace OFFmonthVisits = r(sum) if timeSinceGeneric == `month'
    sum prescriptionIndicator if timeSinceGeneric == `month' & offLabel == 1
    replace OFFmonthScripts = r(sum) if timeSinceGeneric == `month'
}
gen OFFthreeMonthVisits = 0
gen OFFthreeMonthScripts = 0
save "$output/temp.dta", replace
forval month = `3monthMinMA'/`monthMax' {
    local 3MONTHV = 0
    local 3MONTHS = 0
    forval x = 0/2 {
        use "$output/temp.dta", replace
        drop if timeSinceGeneric != `month' - `x'
        local VISITADDER = OFFmonthVisits
        local 3MONTHV = `3MONTHV' + `VISITADDER'
        local SCRIPTADDER = OFFmonthScripts
        local 3MONTHS = `3MONTHS' + `SCRIPTADDER'
    }
    use "$output/temp.dta", replace
    replace OFFthreeMonthVisits = `3MONTHV' if timeSinceGeneric == `month'
    replace OFFthreeMonthScripts = `3MONTHS' if timeSinceGeneric == `month'
    save "$output/temp.dta", replace
}
gen OFFthreeMonthMA = OFFthreeMonthScripts/ONthreeMonthVisits
save "$output/temp.dta", replace
bysort timeSinceGeneric: gen timeCount = _n
drop if timeCount > 1
line OFFthreeMonthMA timeSinceGeneric

// Three Month Moving Average On and Off
line ONthreeMonthMA OFFthreeMonthMA timeSinceGeneric, legend(rows(2))



// Twelve Month Moving Average
use "$output/temp.dta", replace
sum timeSinceGeneric
local monthMin = r(min)
local 12monthMinMA = r(min) + 12
local monthMax = r(max)
gen twelveMonthVisits = 0
gen twelveMonthScripts = 0
save "$output/temp.dta", replace
forval month = `12monthMinMA'/`monthMax' {
    local 12MONTHV = 0
    local 12MONTHS = 0
    forval x = 0/11 {
        use "$output/temp.dta", replace
        drop if timeSinceGeneric != `month' - `x'
        local VISITADDER = monthVisits
        local 12MONTHV = `12MONTHV' + `VISITADDER'
        local SCRIPTADDER = monthScripts
        local 12MONTHS = `12MONTHS' + `SCRIPTADDER'
    }
    use "$output/temp.dta", replace
    replace twelveMonthVisits = `12MONTHV' if timeSinceGeneric == `month'
    replace  twelveMonthScripts= `12MONTHS' if timeSinceGeneric == `month'
    save "$output/temp.dta", replace
}
gen twelveMonthMA = twelveMonthScripts/twelveMonthVisits
save "$output/temp.dta", replace
bysort timeSinceGeneric: gen timeCount = _n
drop if timeCount > 1
line twelveMonthMA timeSinceGeneric

// Twelve Month Moving Average (On Label)
use "$output/temp.dta", replace
gen ONtwelveMonthVisits = 0
gen ONtwelveMonthScripts = 0
save "$output/temp.dta", replace
forval month = `12monthMinMA'/`monthMax' {
    local 12MONTHV = 0
    local 12MONTHS = 0
    forval x = 0/11 {
        use "$output/temp.dta", replace
        drop if timeSinceGeneric != `month' - `x'
        local VISITADDER = ONmonthVisits
        local 12MONTHV = `12MONTHV' + `VISITADDER'
        local SCRIPTADDER = ONmonthScripts
        local 12MONTHS = `12MONTHS' + `SCRIPTADDER'
    }
    use "$output/temp.dta", replace
    replace ONtwelveMonthVisits = `12MONTHV' if timeSinceGeneric == `month'
    replace ONtwelveMonthScripts = `12MONTHS' if timeSinceGeneric == `month'
    save "$output/temp.dta", replace
}
gen ONtwelveMonthMA = ONtwelveMonthScripts/ONtwelveMonthVisits
save "$output/temp.dta", replace
bysort timeSinceGeneric: gen timeCount = _n
drop if timeCount > 1
line ONtwelveMonthMA timeSinceGeneric

// Twelve Month Moving Average (Off Label)
use "$output/temp.dta", replace
gen OFFtwelveMonthVisits = 0
gen OFFtwelveMonthScripts = 0
save "$output/temp.dta", replace
forval month = `12monthMinMA'/`monthMax' {
    local 12MONTHV = 0
    local 12MONTHS = 0
    forval x = 0/11 {
        use "$output/temp.dta", replace
        drop if timeSinceGeneric != `month' - `x'
        local VISITADDER = OFFmonthVisits
        local 12MONTHV = `12MONTHV' + `VISITADDER'
        local SCRIPTADDER = OFFmonthScripts
        local 12MONTHS = `12MONTHS' + `SCRIPTADDER'
    }
    use "$output/temp.dta", replace
    replace OFFtwelveMonthVisits = `12MONTHV' if timeSinceGeneric == `month'
    replace OFFtwelveMonthScripts = `12MONTHS' if timeSinceGeneric == `month'
    save "$output/temp.dta", replace
}
gen OFFtwelveMonthMA = OFFtwelveMonthScripts/OFFtwelveMonthVisits
save "$output/temp.dta", replace
bysort timeSinceGeneric: gen timeCount = _n
drop if timeCount > 1
line OFFtwelveMonthMA timeSinceGeneric

label variable timeSinceGeneric "Months Since Entry of Generic"
label variable ONtwelveMonthMA "Visits with One or More Diagnoses Associated with On-Label Uses"
label variable OFFtwelveMonthMA "Visits with No Diagnoses Associated with On-Label Uses"
line OFFtwelveMonthMA ONtwelveMonthMA timeSinceGeneric, legend(row(2))

use "$output/temp.dta", replace
save "$output/complete.dta", replace
