set more off
clear all
set matsize 1100
set maxvar 32000
set seed 0
global bootstraps 1000


// Set environmet variables and locations
global projects: env projects
global storage: env storage
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"

// Bring in data
use "$output/cefotetan/diag/panel.dta", replace



forval z = 1/5{
    encode DIAG`z', gen(nDIAG`z')
    sum nDIAG`z'
}
reg script i.nDIAG1


forval z = 1/5 {
    sum nDIAG`z'
    local diagMax = r(max)
    qui forval i = 1/`diagMax' {
        gen counter = 1 if nDIAG`z' == `i'
        sum counter
        gen diagTotal = r(sum) if nDIAG`z' == `i'
        replace nDIAG`z' = 0 if diagTotal < 10
        drop counter
        drop diagTotal
    }
}

forval z = 1/5 {
    sum nDIAG`z' if nDIAG`z'== 0
}

// See unique values of nDIAG1
bysort nDIAG1 : gen oneCount = _n
replace oneCount = 0 if oneCount > 1
tab oneCount