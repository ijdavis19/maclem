/*Do file brings in data from OECD (PPP and EX)
which are in csv format and reformats them as 
.dta files*/

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
import delim "$dataraw\oecd_ppp.csv"
save "$output/oecd_ppp.dta", replace

******************************EXR**********************************
import delim "$dataraw/oecd_exr.csv", clear
save "$output/oecd_exr.dta", replace
