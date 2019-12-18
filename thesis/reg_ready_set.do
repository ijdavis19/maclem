//Takes end result of indv_prescription_rates

set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000

//set environmet variables
global projects: env projects
global storage: env storage
global maclem: env maclem

//general locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"

//TODO: Bring in pdr_info.csv and make new dataset
do $maclem/thesis/indv_prescription_rates.do

//TODO: 'Reshape' with regression ready format
//TODO: Year Column
//TODO: Anitbiotic Column
//TODO: On or off patent indicator column for each ABx
//TODO: Deal with Month Year formatting problem
//TODO: Consilidate everything for true event study opportunity
