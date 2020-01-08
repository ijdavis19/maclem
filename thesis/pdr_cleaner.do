set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


//set environmet variables
//global projects: env projects
//global storage: env storage

//general locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"

///import the pdr_info.csv
import delim "$dataraw/pdr_info.csv"

//rename variable originally titled 'int' who's name didn't carry over
rename v12 interest


//fix generic appearance dates
gen firstgenyear = firstgenapp
gen firstgenmonth=.
replace firstgenmonth = XX if drug == "amikacin"
replace firstgenmonth = XX if drug == "amoxicillin"
replace firstgenmonth = XX if drug == "aztreonam"
replace firstgenmonth = XX if drug == "cefdinir"
replace firstgenmonth = XX if drug == "cefepime"
replace firstgenmonth = XX if drug == "cefotetan"
replace firstgenmonth = XX if drug == "cefpodoxime"
replace firstgenmonth = XX if drug == "cefproxil"
replace firstgenmonth = XX if drug == "ceftazidime"
replace firstgenmonth = XX if drug == "ceftibuten"
replace firstgenmonth = XX if drug == "ciprofloxacin"
replace firstgenmonth = XX if drug == "ethambutol"
replace firstgenmonth = XX if drug == "levofloxacin"
replace firstgenmonth = XX if drug == "lincomycin"
replace firstgenmonth = XX if drug == "linezolid"
replace firstgenmonth = XX if drug == "moxifloxacin"
replace firstgenmonth = XX if drug == "muprocin"
replace firstgenmonth = XX if drug == "sulfamethoxazole/trimethroprim"
replace firstgenmonth = XX if drug == "tinidazole"
