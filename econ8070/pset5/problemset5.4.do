set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


// Global projects: env projects
global storage: env storage
global projects: env projects

// General locations
/*
global dataraw =  // No data input
global output = // Nothing saved
global figures = //No Figures "/home/ian/economics/maclem/econ8070/pset5"
*/

// Make the variables
set obs 10000
gen beta0 = 50
gen beta1 = 1
gen beta2 = -3
gen beta3 = 5
gen gamma1 = 2
gen gamma2 = 3
gen gamma3 = 1
gen gamma4 = 1
gen gamma5 = 6
gen gamma6 = 5
gen r1 = rnormal(0,50)
gen r2 = rnormal(0,80)
gen z1 = runiform(0,100)
gen z2 = runiform(0,100)
gen xi1 = rnormal(0,10)
gen xi2 = rnormal(0,10)
gen x1 = gamma1*z1 + xi1
gen x2 = gamma2*z2 + xi2
gen x3 = runiform(0,100)
gen eps = rnormal(0,100)
gen y = beta0 + beta1*x1 + beta2*x2 + beta3 + gamma5*r1 + gamma6+r2 + eps

// (a)
reg y x1 x2 x3
ivreg y (x1 x2 = z1 z2) x3

// (b)
replace z1 = z1 + gamma3*r1
replace z2 = z2 + gamma4*r2

reg y x1 x2 x3
ivreg y (x1 x2 = z1 z2) x3