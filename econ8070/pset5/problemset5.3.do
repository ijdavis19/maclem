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
gen x1 = gamma1*z1 + gamma3*r1 + xi1
gen x2 = gamma2*z2 + gamma4*r2 + xi2
gen x3 = runiform(0,100)
gen eps = rnormal(0,100)
gen y = beta0 + beta1*x1 + beta2*x2 + beta3 + gamma5*r1 + gamma6+r2 + eps

// (b) Simulating Endogeneity for x1 and x2
reg y x1 x2 x3

// (c) Repeat process 1000 times
matrix BootsBetas = [.,.,.,.]

qui forval i = 1/1000 {
    preserve
    bsample 10000
    reg y x1 x2 x3
    matrix Betas`i' = e(b)
    matrix BootsBetas = BootsBetas\Betas`i'
    mat drop Betas`i'
    restore
}
matrix BootsBeta1 = BootsBetas[2...,1]
svmat BootsBeta1, name(bootsBeta1)
mat drop BootsBeta1
matrix BootsBeta2 = BootsBetas[2...,2]
svmat BootsBeta2, name(bootsBeta2)
mat drop BootsBeta2
matrix BootsBeta3 = BootsBetas[2...,3]
svmat BootsBeta3, name(bootsBeta3)
mat drop BootsBeta3
matrix BootsBeta0 = BootsBetas[2...,4]
svmat BootsBeta0, name(bootsBeta0)
mat drop BootsBeta0
mat drop BootsBetas

forval b = 0/3 {
    sum bootsBeta`b'
}

// (d) IV estimator
ivreg y (x1 x2 = z1 z2) x3

// (e)
matrix BootsZBetas = [.,.,.,.]
qui forval i = 1/1000 {
    preserve
    bsample 10000
    ivreg y (x1 x2 = z1 z2) x3
    matrix ZBetas`i' = e(b)
    matrix BootsZBetas = BootsZBetas\ZBetas`i'
    mat drop ZBetas`i'
    restore
}
matrix BootsZBeta1 = BootsZBetas[2...,1]
svmat BootsZBeta1, name(bootsZBeta1)
mat drop BootsZBeta1
matrix BootsZBeta2 = BootsZBetas[2...,2]
svmat BootsZBeta2, name(bootsZBeta2)
mat drop BootsZBeta2
matrix BootsZBeta3 = BootsZBetas[2...,3]
svmat BootsZBeta3, name(bootsZBeta3)
mat drop BootsZBeta3
matrix BootsZBeta0 = BootsZBetas[2...,4]
svmat BootsZBeta0, name(bootsZBeta0)
mat drop BootsZBeta0
mat drop BootsZBetas

forval b = 0/3 {
    sum bootsZBeta`b'
}