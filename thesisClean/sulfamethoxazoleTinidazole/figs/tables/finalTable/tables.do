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
eststo: reg prescriptionIndicator timeSinceGeneric age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 1 & unspecCellAbscess  == 1
estimate store SkinAfter
// esttab using "$tables/abscess.tex", stats(r2 N) title(Before and After Generic Comparison\label{tab1}) replace
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

*****************************************************************************************************************************************
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
local vars = "timeSinceGeneric age ageSQ offLabel govInsurance nonwhite genericOn"
foreach var in `vars'{
    sum `var' [w = PATWT]
    sum `var' [w = PATWT] if genericOn == 0
    sum `var' [w = PATWT] if genericOn == 1
}


********************************************************************************************************************************
regress prescriptionIndicator timeSinceGeneric offLabel offLabelINT age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 0
mat Before = e(b)
regress prescriptionIndicator timeSinceGeneric offLabel offLabelINT age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 1
mat After = e(b)
reg prescriptionIndicator timeSinceGeneric age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 0 & unspecCellAbscess  == 1
mat SkinBefore = e(b)
reg prescriptionIndicator timeSinceGeneric age ageSQ ageINT AgeSQINT govInsurance nonwhite [w = PATWT] if genericOn == 1 & unspecCellAbscess  == 1
mat SkinAfter = e(b)
drop if _n > 132
replace timeSinceGeneric = _n - 83
keep timeSinceGeneric
gen genericOn = 0
replace genericOn = 1 if timeSinceGeneric >= 0

// Standard On and Off Label
gen ONfit = Before[1,10] + timeSinceGeneric*Before[1,1] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*Before[1,6]*timeSinceGeneric + `ageSQ0'*timeSinceGeneric*Before[1,7] + `govInsurance0'*Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace ONfit = After[1,10] + timeSinceGeneric*After[1,1] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + `govInsurance0'*After[1,8] + `nonwhite0'*After[1,9] if genericOn == 1
gen OFFfit = Before[1,10] + timeSinceGeneric*Before[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*timeSinceGeneric*Before[1,6] + `ageSQ0'*timeSinceGeneric*Before[1,7] + `govInsurance1'*Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace OFFfit = After[1,10] + timeSinceGeneric*After[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + `govInsurance1'*After[1,8] + `nonwhite1'*After[1,9] if genericOn == 1
sum ONfit   
sum OFFfit
line ONfit OFFfit timeSinceGeneric

// GovInsurance
gen ONfitGI = Before[1,10] + timeSinceGeneric*Before[1,1] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*Before[1,6]*timeSinceGeneric + `ageSQ0'*timeSinceGeneric*Before[1,7] + Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace ONfitGI = After[1,10] + timeSinceGeneric*After[1,1] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + After[1,8] + `nonwhite0'*After[1,9] if genericOn == 1
gen OFFfitGI = Before[1,10] + timeSinceGeneric*Before[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*timeSinceGeneric*Before[1,6] + `ageSQ0'*timeSinceGeneric*Before[1,7] + Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace OFFfitGI = After[1,10] + timeSinceGeneric*After[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + After[1,8] + `nonwhite1'*After[1,9] if genericOn == 1
sum ONfitGI  
sum OFFfitGI
line ONfitGI OFFfitGI timeSinceGeneric

// NonWhite
gen ONfitNW = Before[1,10] + timeSinceGeneric*Before[1,1] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*Before[1,6]*timeSinceGeneric + `ageSQ0'*timeSinceGeneric*Before[1,7] + `govInsurance0'*Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace ONfitNW = After[1,10] + timeSinceGeneric*After[1,1] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + `govInsurance1'*After[1,8] + After[1,9] if genericOn == 1
gen OFFfitNW = Before[1,10] + timeSinceGeneric*Before[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age0'*Before[1,4] + `ageSQ0'*Before[1,5] + `age0'*timeSinceGeneric*Before[1,6] + `ageSQ0'*timeSinceGeneric*Before[1,7] + `govInsurance0'*Before[1,8] + `nonwhite0'*Before[1,9] if genericOn == 0
replace OFFfiTNW = After[1,10] + timeSinceGeneric*After[1,1] + Before[1,2] + timeSinceGeneric*Before[1,3] + `age1'*After[1,4] + `ageSQ1'*After[1,5] + `age1'*timeSinceGeneric*After[1,6] + `ageSQ1'*timeSinceGeneric*After[1,7] + `govInsurance1'*After[1,8] + After[1,9] if genericOn == 1
sum ONfitNW
sum OFFfitNW
line ONfitNW OFFfitNW timeSinceGeneric

// Abcess and Cellulitis
gen ONfitCell = SkinBefore[1,8] + timeSinceGeneric*SkinBefore[1,1] + `age0AC'*SkinBefore[1,2] + `ageSQ0AC'*SkinBefore[1,3] + `age0AC'*SkinBefore[1,4]*timeSinceGeneric + `ageSQ0AC'*timeSinceGeneric*SkinBefore[1,5] + `govInsurance0AC'*SkinBefore[1,6] + `nonwhite0AC'*SkinBefore[1,7] if genericOn == 0
replace ONfitCell = SkinAfter[1,8] + timeSinceGeneric*SkinAfter[1,1] + `age1AC'*SkinAfter[1,2] + `ageSQ1AC'*SkinAfter[1,3] + `age1AC'*timeSinceGeneric*SkinAfter[1,4] + `ageSQ1AC'*timeSinceGeneric*SkinAfter[1,5] + `govInsurance1AC'*SkinAfter[1,6] + `nonwhite1AC'*SkinAfter[1,7] if genericOn == 1
sum ONfitCell
line ONfitCell timeSinceGeneric