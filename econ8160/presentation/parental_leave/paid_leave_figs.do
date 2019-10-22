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

*Bring in Data
use "$output/ES_DD_estimates", clear


*Figure 1: Impact of California and New Jersey Paid Leave Laws on Women's LFP around Birth
line b_X1 b_X2 time

*Figure 1.1 After-Before difference
line b_X3 time

*Figure 1.2: LFP Change in California and New Jersey and Event-Study DD Estimates
line b_X3 b_X4 time

*Figure 2: Impact of Paid Leave on Labor-Force Status of Women with Less than a BA Degree
line b_X7 b_X8 time

