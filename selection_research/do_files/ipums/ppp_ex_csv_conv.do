/*Do file brings in data from OECD (PPP and EX)
which are in csv format and reformats them as
.dta files*/

//DO NOT NEED EXR MEASURE
//PPP IS ALREADY IN USD
//JUST ADD DEFLATOR TO PPP

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



******************************PPP**********************************
import delim "$dataraw\oecd_ppp.csv", clear
label variable ïlocation "location"
rename ïlocation location
gen country =""
replace country = "brazil" if location == "BRA" //INCTOT //HRSMAIN
replace country = "canada" if location == "CAN" //INCTOT //HRSWORK1
replace country = "india" if location == "IND" //INCWAGE //No hours worked data
replace country = "italy" if location == "ITA" //INCWAGE //HRSWORK1
//NO JAMAICA
replace country = "mexico" if location == "MEX" //INCTOT //HRSWORK1
//NO PANAMA //INCTOT //HRSWORK1
//NO PUERTORICO //INCTOT //HRSWORK1
replace country = "southafrica" if location == "ZAF" //INCTOT //HRSWORK1
recast long time
save "$output/oecd_ppp.dta", replace

******************************DEF**********************************
use "$dataraw\deflator.dta", replace
gen time = 2020 - _n
recast long time
replace value = value * .01
drop date
save "$output\deflator.dta", replace
