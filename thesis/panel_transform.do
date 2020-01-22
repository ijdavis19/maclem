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
gen firstgenyear=.
gen firstgenmonth=.
gen interest=.
qui forval d = 1/69 {
  replace drugnum = `d' if id > (`d' - 1)*143 & id <= `d'*143
  forval y = 1/11 {
    replace year = 2005 + `y' if id > (`d' -1)*143 + (`y'-1)*13 & id <= (`d'-1)*143 + (`y')*13
	  forval m = 0/12 {
	   replace month = `m' if id == (`d' -1)*143 + (`y'-1)*13 + `m' + 1
	  }
  }
}
bys drugnum: gen subdrugobs = _n

save "$output/script_panel.dta", replace
global panel = "$output/script_panel.dta"



// Drug names
qui forval d = 1/69{
  use $rates, replace
  drop if abxnum != `d'
  local dr`d' = drug
  sum firstgenyear
  mat y`d' = r(mean)
  sum firstgenmonth
  mat mo`d' = r(mean)
  sum interest
  mat int`d' = r(mean)
  use $panel, replace
  replace drug = "`dr`d''" if drugnum == `d'
  replace firstgenyear = y`d'[1,1] if drugnum == `d'
  replace firstgenmonth = mo`d'[1,1] if drugnum == `d'
  replace interest = int`d'[1,1] if drugnum == `d'
  ma drop dr`d'
  ma drop y`d'
  ma drop mo`d'
  ma drop int`d'
  save $panel, replace
}


// Pull prescription rates from secondary datasets
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


// Calculate Months and Years After for each observation
replace firstgenyear =. if firstgenyear <= 2000
gen longgen = 1 if firstgenyear ==.
replace longgen = 0 if longgen != 1
gen obsmonth = (year - 2000)*12 + month if month != 0
gen genmonth = (firstgenyear - 2000)*12 + firstgenmonth
gen monthsAfterGen = obsmonth - genmonth
gen genon = 1 if longgen == 1 | monthsAfterGen >= 0
replace genon = 0 if genon != 1
gen genon1year = 1 if longgen == 1 | monthsAfterGen >= 12
replace genon1year = 0 if genon1year != 1
save $panel, replace

// Raw Month Observation totals
gen monthTotalObs =.
gen yearTotalObs =.
save $panel, replace
qui forval year = 2006/2016 {
  forval month = 0/12{
    use "$dataraw/namcs`year'-stata.dta", replace
    if `month' != 0 {
	     drop if VMONTH != `month'
    }
    gen pop = _n
    sum pop
    mat T = r(max)
    use $panel, replace
    if `month' == 0 {
	     replace yearTotalObs = T[1,1] if year == `year'
    }
    replace monthTotalObs = T[1,1] if year == `year' & month == `month'
    save $panel, replace
  }
}

//Split Month and Calender Year Panels
// Calandar Years
drop if month != 0
replace id = _n
save "$output/panel_calyear.dta", replace
//Months
use $panel, replace
drop if month == 0
replace id = _n
gen yearsAfterGen = ceil(monthsAfterGen/12) +1
save "$output/panel_monthly.dta", replace

// Make genYear probabilities
