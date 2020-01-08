set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000

//set environment variables
//global projects: env projects
//global storage: env storage

//general locations & variables
global dataraw = "$storage\selection_research"
global output = "$projects\selection_research"
global dofiles = "$maclem\selection_research\do_files"
global COUNTRIES = "brazil canada india italy jamaica mexico panama puertorico southafrica venezuela"

//convert PPP and EXR csv files to
do "$dofiles\ipums\ppp_ex_csv_conv.do"
//'time' and 'location' are the respective year and
//country variables

foreach country in $COUNTRIES {
  use "$dataraw/`country'.dta", replace
  drop if hrswork1 == 998 | hrswork1 == 999 | hrswork1 == 999 //Drop variables with no or unknowned hours worked
  if `country' == "brazil" | `country' ==  "canada"| `country' == "mexico" | `country' == "southafrica" {
		gen week_wage = inctot/52
  }
  else {
    gen week_wage = incage/52
  }
	gen hour_wage = week_wage/hrswork1
  save "$output\`country'.dta", replace
	bysort year: gen yearnum = _n
	drop if yearnum != 1
	replace yearnum = _n
	sum yearnum
	local crosstotal = r(max)
  mat Year = [.]
  mat Ppp = [.]
  mat Exr = [.]
  forval x = 1/$crosstotal {
    // loop through yearnums making 3 column matrix: year, ppp, exchange rate with a row for each year
    mat X = year if yearnum == `x'
    mat Year = Year\X
    drop mat X
  }
  mat Year = Year[2...,1...]
  use "$output/oecd_ppp.dta", replace
  forval x = 1/$crosstotal {
    mat X = value if time == Year[`x',1]
    mat Ppp = Ppp\X
    drop mat X
  }
  mat Ppp = Ppp[2...,1...]
  use "$output/oecd_exr.dta", replace //NEED DEFLATOR INSTEAD!
  forval x = 1/$crosstotal {
    mat X = value if time == Year[`x',1]
    mat Exr = Exr\X
    drop mat X
  }
  mat Exr = Exr[2...,1...]
  use "$output/`country'.dta", replace
  gen normwage =.
  forval x = 1/$crosstotal {
    replace norm_wage = hour_wage*Ppp[`x',1]*Exr[`x',1] if year == Year[`x',1]
  }
  ma drop Year Ppp Exr
}
