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
// Collect every diagnosis and check for duplicates at the same time
gen n = _n
sum n
local nMax = r(max)
local indicatorNumber = 0
forval d= 1/3 {
    replace DIAG`d' = "null" if DIAG`d' == ""
    display `d'
    qui forval i = 1/250 { //i = 1/`nMax'
        preserve
        drop if n != `i'
        local x = `d'*`i'
        local initialDiagIndicator`x' = DIAG`d'
        local indicatorNumber = `indicatorNumber' + 1
        restore 
    }
}
ma list
display "`indicatorNumber'"
// Remove duplicates and null values
forval k = 1/`indicatorNumber'{
    
}

// Set up indicators
