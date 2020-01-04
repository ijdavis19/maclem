set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000

//set environment variables
//global projects: env projects
//global storage: env storage

//general locations
global dataraw = "$storage\selection_research"
global output = "$projects\selection_research"
global dofiles = "$dofiles\selection_research"

//run the csv conversion
do "$dofiles\selection_research\do_files\ipums\ppp_ex_csv_conv.do"
