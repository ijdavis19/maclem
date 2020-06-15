// Set environmet variables
global projects: env projects
global storage: env storage

// General locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace


// Make proportions for General Skin Infections
drop if generalSkinInfection != 1
gen weightedPrescription = PATWT*prescriptionIndicator
sum weightedPrescription if genericOn == 0
global weightedNumerator0 = r(sum)
sum weightedPrescription if genericOn == 1
global weightedNumerator1 = r(sum)

gen weightedInfection = PATWT*generalSkinInfection
sum weightedInfection if genericOn == 0
global weightedDenominator0 = r(sum)
sum weightedInfection if genericOn == 1
global weightedDenominator1 = r(sum)

global proportion0 = $weightedNumerator0/$weightedDenominator0
global proportion1 = $weightedNumerator1/$weightedDenominator1

display "$proportion0" // .184
display "$proportion1" // .304

// Make graph to see total prescriptions by age
use "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace
drop if generalSkinInfection == 0
gen ageScriptsTotal = 0 // Total number of presciption for a given age
gen ageScripts0 = 0 // Scripts before generic marketing began
gen ageScripts1 = 1 // Scripts after generic marketing began
label var ageScriptsTotal "Total number of Prescriptions"
label var ageScripts0 "Prescriptions before Generic"
label var ageScripts1 "Prescriptions after Generic"

sum AGE
local ageMax = r(max)
forval age = 0/`ageMax' {
    sum prescriptionIndicator if AGE == `age'
    replace ageScriptsTotal = r(sum) if AGE == `age'
    sum prescriptionIndicator if AGE == `age' & genericOn == 0
    replace ageScripts0 = r(sum) if AGE == `age'
    sum prescriptionIndicator if AGE == `age' & genericOn == 1
    replace ageScripts1 = r(sum) if AGE == `age'
}
scatter ageScriptsTotal AGE, saving($output/ageScriptsTotal, asis replace)
scatter ageScripts0 AGE, saving($output/ageScripts0, asis replace)
scatter ageScripts1 AGE, saving($output/ageScripts1, asis replace)


// How exclusive are the diagnoses?
use "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace
gen specDiagCount = 0
foreach diag in $specDiags
    replace specDiagCount = specDiagCount + 1 if `diag' == 1
}
sum specDiagCount
foreach diag in $specDiags {
    tab specDiagCount if `diag' == 1
}
keep if generalSkinInfection == 1 & specDiagCount == 3 
/*
No diagnoses trigger another automatically
One individual had 3 diagnoses
DIAG1 3822: Cellulitis and abscess of trunk
DIAG1 78791: Diarrhea
DIAG1 5990: Urinary Tract Infection, site not specified
^ Really bad day for this guy
*/

// What other drugs are prescribed for general skin infection?
use "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace

drop prescriptionIndicator
forval number = 1/8 {
    replace prescriptionIndicator = 1 if DRUGID`number' == "`genEQ'"
    replace prescriptionIndicator = 0 if prescriptionIndicator != 1
}
tab prescriptionIndicator

