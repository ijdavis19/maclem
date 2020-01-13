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

//name the prescription rates
global rates = "$output/prescript_rates.dta"


//set observation number
set obs 9867
//gives an id to every observation
gen id = _n
gen drug = ""
gen drugnum =.
gen year =.
gen month =.
gen scriptraw =.
gen scriptprob =.
qui forval d = 1/69 {
  replace drugnum = `d' if id > (`d' - 1)*143 & id <= `d'*143
  forval y = 1/11 {
    replace year = 2005 + `y' if id >= (`d' -1)*143 + (`y'-1)*13 & id < (`d'-1)*143 + (`y')*13
	  forval m = 0/12 {
	   replace month = `m' if id == (`d' -1)*143 + (`y'-1)*13 + `m' + 1
	  }
  }
}
bys drugnum: gen subdrugobs = _n

save "$output/script_panel.dta", replace
global panel = "$output/script_panel.dta"



//drug names
qui forval d = 1/69{
  use $rates, replace
  drop if abxnum != `d'
  local dr`d' = drug
  ma list
  use $panel, replace
  replace drug = "`dr`d''" if id > (`d' - 1)*143 & id <= `d'*143
  save $panel, replace
}



//this will kinda work for the not strings
qui forval n = 1/69 {
  mat Scripts = [.,.]
  use $rates, replace
  forval y = 2006/2016 {
    forval m = 0/12 {
      if `m' == 0 {
        sum p`y't if abxnum == `n'
        mat drt = r(max)
        sum p`y'tprb if abxnum == `n'
        mat drpr = r(max)
        mat dfull = drt , drpr
        mat Scripts = Scripts\dfull
        mat drop dfull drt drpr
      }
      else {
        sum p`y'mo`m' if abxnum == `n'
        mat drt = r(max)
        sum p`y'mo`m'prb if abxnum == `n'
        mat drpr = r(max)
        mat dfull = drt , drpr
        mat Scripts = Scripts\dfull
        mat drop dfull drt drpr
      }
    }
  }
  mat Scripts = Scripts[2...,1...]
  use $panel, replace
  forval o = 1/143 {
    replace scriptraw = Scripts[`o',1] if subdrugobs == `o' & drugnum == `n'
    replace scriptprob = Scripts[`o',2] if subdrugobs == `o' & drugnum == `n'
  }
  mat drop Scripts
  save $panel, replace
}
