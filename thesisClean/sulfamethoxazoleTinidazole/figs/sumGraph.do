set more off
clear all
set matsize 1100
set maxvar 32000
set seed 0
global bootstraps 1000


//set environmet variables and locations
global projects: env projects
global storage: env storage

global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"

use "$output/panel_monthly_graphset.dta", replace

/*
// Graph Hacks
drop if drugnum != 21
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
*/

//3
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 3
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
//4
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 4
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//9
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 9
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//12
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 12
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//13
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 13
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//16
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 16
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//21
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 21
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//28
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 28
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//31
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 31
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//34
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 34
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//37
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 37
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//41
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 41
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//42
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 42
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//43
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 43
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//44
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 44
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//47
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 47
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")

//68
use "$output/panel_monthly_graphset.dta", replace
drop if drugnum != 68
sum monthsAfterGen
local monthMin = ceil(r(min)/12)*12
local monthMax = floor(r(max)/12)*12
local antibiotic = strproper(drug)
xtline scriptprob genYearMeanProb, ///
        xtitle(Months After First Generic Entry) xlabel(`monthMin'(12)`monthMax') ///
        title(`antibiotic')
graph export "/home/ian/economics/projects/thesis_antibiotics/figs/`antibiotic'.pdf", as(pdf) name("Graph")


