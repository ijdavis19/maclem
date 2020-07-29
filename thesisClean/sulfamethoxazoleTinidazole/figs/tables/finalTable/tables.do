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

// replace timeSinceGeneric = timeSinceGeneric - 4

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