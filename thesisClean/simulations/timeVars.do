set more off
clear all
set seed 0



// Two constants with no slope
set obs 10000
gen x =.
gen n = _n

// Generate first half of cont. variable with mean 50 and standard deviation 5
replace x = rnormal(50,5) if n <= 5000
sum x if n <= 5000 // real mean: 50.12
                   // real standard deviation: 5.03

// Generate second half of cont. variable with mean 75 and standard deviation 5
replace x = rnormal(75,5) if n > 5000
sum x if n > 5000 // real mean: 74.99
                  // real standard deviation: 5.05

// Generate indicator 
gen ind = 1 if n > 5000
replace ind = 0 if ind != 1

// Run Regression
reg x ind

// constant: 50.12 ~ mean of first half of x
// ind coefficient: 24.87 ~ difference between second and first

// Add slope of +1 for obs > 5000
replace x = x + (n - 5000) if n > 5000
sum x if n > 5000 // real mean: 74.99
                  // real standard deviation: 5.05
gen cont = n - 5000
gen inter = cont*ind

reg x ind inter

// Make categorical variable
gen quarter = 1 if n <= 2500
replace quarter = 2 if n > 2500 & n <= 5000
replace quarter = 3 if n > 5000 & n <= 7500
replace quarter = 4 if n > 7500
replace x = x - (n - 5000) if n > 5000 // deslope x

reg x i.quarter ind inter // indicator coefficient gets eaten by quarter

// Bring slope back into x
replace x = x + (n - 5000) if n > 5000
reg x i.quarter ind inter

// Replace quarters with something that relfects my data more
drop quarter
gen part = 1 if n <= 2500
replace part = 2 if n > 2500 & n <= 7500
replace part = 3 if n > 7500

replace x = x - (n - 5000) if n > 5000 // deslope x
sum x if part == 1 // mean: 50.06
sum x if part == 2 // mean: 62.56
sum x if part == 3 // mean: 75.05

reg x i.part
reg x i.part ind


replace x = x + (n - 5000) if n > 5000
reg x i.part ind inter
