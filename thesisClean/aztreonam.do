set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


// Set environmet variables
global projects: env projects
global storage: env storage

// General locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean"

// Dataset
do "$dofiles/panelDataCreation"
use "$output/NAMCSPanel.dta", replace

//set local variables
local genEQ = "d00067"
local firstGenYear = 2009
local firstGenMonth = 11

gen prescriptionIndicator =.

// indicator for prescription
forval number = 1/30 {
    replace prescriptionIndicator = 1 if DRUGID`number' == "`genEQ'"
    replace prescriptionIndicator = 0 if prescriptionIndicator != 1
}
save "$output/NAMCSPanel.dta", replace

// create local variables for each diagnosis
forval diagNumber = 1/5 {
    use "$output/NAMCSPanel.dta", replace
    drop if prescriptionIndicator == 0
    bysort DIAG`diagNumber': gen spec`diagNumber'DiagCount = _n
    drop if spec`diagNumber'DiagCount > 1
    gen diagCount`diagNumber' = _n
    save "$output/temp.dta", replace
    sum diagCount`diagNumber'
    local diagMax`diagNumber' = r(max)
    display "cleared 1"
    forval diagCounter = 1/`diagMax`diagNumber''{
        use "$output/temp.dta", replace
        drop if diagCount`diagNumber' != `diagCounter'
        local `diagNumber'diag`diagCounter' = DIAG`diagNumber'
    }
}
erase "$output/temp.dta"
ma list

// Loop through all diagnoses to determine if relevant diagnosis was made
log using $dofiles/aztreonamLog.txt, replace
use "$output/NAMCSPanel.dta", replace
gen relevantDiagIndicator = 0
forval diagNumber = 1/5 {
    forval diagCounter = 1/`diagMax`diagNumber'' {
        forval diagNumberComp = 1/5{
	    display "``diagNumber'diag`diagCounter''"
            replace relevantDiagIndicator = 1 if DIAG`diagNumberComp' == "``diagNumber'diag`diagCounter''"
        }
    }
}

tab prescriptionIndicator
tab relevantDiagIndicator
tab relevantDiagIndicator if DIAG1 == "-9" | DIAG2 == "-9" | DIAG3 == "-9" | DIAG4 == "-9" | DIAG5 == "-9"
replace relevantDiagIndicator = 0 if DIAG1 == "-9" | DIAG2 == "-9" | DIAG3 == "-9" | DIAG4 == "-9" | DIAG5 == "-9"
log close