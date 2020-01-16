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
global dataraw =  "$storage/selection_research"
global output = "$projects/selection_research"

///import the ipums_vars.csv
import delim "$dataraw/ipums_vars.csv"

//name variables and correct typos
rename v1 variable
rename v2 description
rename v3 link
rename v4 country
rename v5 year

//number country appearances
bys variable country: gen varappnum = _n

//table of countries appearing more than 4 times
tab country if varappnum >= 4

//table of countries appearing more than 4 times with wage data
tab country if varappnum >= 4 & variable == "INCWAGE"

//table of countries appearing more than 4 times with hours/week data
tab country if varappnum >= 4 & variable == "HRSMAIN"

//table of countries appearing more than 4 times with weekly income data
tab country if varappnum >= 4 & variable == "INCTOT"

//table of countries with rough wage data
tab country if (varappnum >= 4 & variable == "INCWAGE") | (varappnum >= 4 & variable == "HRSMAIN") | (varappnum >= 4 & variable == "INCTOT")

tab country if (varappnum >= 4 & variable == "HRSWORKED1") | (varappnum >= 4 & variable == "HRSMAIN")
