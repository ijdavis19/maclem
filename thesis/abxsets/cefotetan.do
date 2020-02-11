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

save "$output/cefotetan/drugPanel.dta", replace

forval year = 2006/2016 {
  use "$output/cefotetan/diag`year'", replace
  gen vist =_n
  gen year = `year'
  sum _n
  gen visitSplit = floor(r(max)/1100)
  local split = visitSplit
  forval slice = 1/`split' {
    mkmat visit year script if visit > 1100*(`splice' - 1) & visit <= 1100*`splice', mat(M)
    svmat M[1..,1], name(visit)
    svmat M[1..,2], name(year)
    svmat M[1..,3], name(visit)
    mat drop M
   }
   /*
   ***************All very subject to change***************
   use "$output/refinedpanel.dta", replace
   drop if drugnum != 9
   gen normObsMonth = obsmonth - 72
   mkmat normObsMonth
   */
}
