set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


//set environmet variables
global projects: env projects
global storage: env storage

//general locations
global dataraw =  "$storage/econ816_presentation"
global output = "$projects/econ816_presentation"


clear
set obs 6
save "$output/paid_leave_t", replace emptyok

matrix T = [.]
foreach i of numlist 4 5 6 {
use "$output/US_PAID_leave_analysis.dta"
local X4  " i.rhcalyr i.IBirth i.rhcalyr#i.state i.IBirth#i.state i.IBirth#i.rhcalyr _LIBiXpos_2_1 _LIBiXpos_8_1-_LIBiXpos_50_1 [pweight=end_weight] "
local X5  " i.rhcalyr i.IBirth i.rhcalyr#i.state i.IBirth#i.state i.IBirth#i.rhcalyr _LIBiXpos_2_1 _LIBiXpos_8_1-_LIBiXpos_50_1 [pweight=end_weight] if  lt_college==0 "
local X6  " i.rhcalyr i.IBirth i.rhcalyr#i.state i.IBirth#i.state i.IBirth#i.rhcalyr _LIBiXpos_2_1 _LIBiXpos_8_1-_LIBiXpos_50_1 [pweight=end_weight] if  lt_college==1 "
qui xtreg rm_lfp `X`i'', fe  vce(cluster sippid)

qui test _LIBiXpos_22_1 _LIBiXpos_23_1 _LIBiXpos_24_1 _LIBiXpos_25_1 _LIBiXpos_26_1 _LIBiXpos_27_1 _LIBiXpos_28_1

matrix t_`i' = r(p)
matrix T = T\t_`i'
}

foreach i of numlist 7 8 {
use "$output/US_PAID_leave_analysis.dta", clear
local X7  " looking i.rhcalyr i.IBirth i.rhcalyr#i.state i.IBirth#i.state i.IBirth#i.rhcalyr _LIBiXpos_2_1 _LIBiXpos_8_1-_LIBiXpos_50_1 [pweight=end_weight] if  lt_college==1 "
local X8  " working i.rhcalyr i.IBirth i.rhcalyr#i.state i.IBirth#i.state i.IBirth#i.rhcalyr _LIBiXpos_2_1 _LIBiXpos_8_1-_LIBiXpos_50_1 [pweight=end_weight] if  lt_college==1 "
qui xtreg `X`i'', fe  vce(cluster sippid)

qui test _LIBiXpos_31_1 _LIBiXpos_32_1 _LIBiXpos_33_1 _LIBiXpos_34_1 _LIBiXpos_35_1 _LIBiXpos_36_1 

matrix t_`i' = r(p)
matrix T = T\t_`i'
}

matrix T = T[2...,1...]
use "$output/paid_leave_t", clear
svmat T, name(pvalues)
save "$output/paid_leave_t", replace
