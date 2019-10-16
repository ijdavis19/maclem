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
global dataraw =  "$storage/econ816_presentation"
global output = "$projects/econ816_presentation"

* Dataset contains observations for women aged 24-45 who gave birth in CA, NJ, NY, FL, or TX during one of SIPP panels (1996, 2001, 2004 or 2008)
use "$dataraw\SIPP_Paid_Leave.dta", clear

sort ssuid epppnum spanel swave srefmon

//give every individual a unique id
egen sippid=group(spanel ssuid epppnum)

bys sippid: gen months=_n
xtset sippid months

gen date=ym(rhcalyr, rhcalmn)
format date %tm

//generate variable that indicates month relative to birth
sort ssuid epppnum swave srefmon
bys ssuid epppnum: gen birth=date - birth_month

//occasionally individuals are missing from a wave during the panel, if a birth occurs during a missing wave, I assign the next month after the birth as the reference month (in order to determine education level, for example)
gen birth_seen_f=0
replace birth_seen_f=1 if birth == 0
bys sippid: egen birth_seen=max(birth_seen_f)
bys sippid: egen ref_month_ns=min(birth) if birth>0 & birth_seen==0
gen ref_month=1 if birth == 0 & birth_seen==1
replace ref_month=1 if ref_month_ns==birth & birth_seen==0

gen state=tfipsst
label define state 6 "California" 34 "New Jersey" 12 "Florida" 48 "Texas" 36 "New York" , replace
label values state state

//weights: each observation has its own weight, but xtreg requires a single weight -- use the weight in the individual's last observation (results robust to using from other observations)
bys sippid: egen end_date=max(date)
format end_date %tm
gen double end_weight_f=wpfinwgt if end_date==date
bys sippid: egen double end_weight=max(end_weight_f)
replace end_weight=round(end_weight)

//policy variables
gen CA_date=ym(2004, 7)
format CA_date %tm

gen NJ_date=ym(2009, 7)
format NJ_date %tm

//generate variable identifies births that occured when a paid leave was in effect in the mother's state
gen post_policy=0
replace post_policy=1 if tfipsst==34 & birth_month>=NJ_date
replace post_policy=1 if tfipsst==6 & birth_month>=CA_date

// SIPP coding of Labor-Market Outcomes:

/*  
RMESR: Employment status recode for month 
V         -1 .Not in Universe
V          1 .With a job entire month, worked all weeks.
V          2 .With a job entire month, absent from work without pay 1+ weeks, absence not due to layoff
V          3 .With a job entire month, absent from work without pay 1+ weeks, absence due to layoff
V          4 .With a job at least 1 but not all weeks, no time on layoff and no time looking for work
V          5 .With a job at least 1 but not all weeks, remaining weeks on layoff or looking for work
V          6 .No job all month, on layoff or looking for work all weeks.
V          7 .No job all month, at least one but not all weeks on layoff or looking for work
V          8 .No job all month, no time on layoff and no time looking for work.
*/

gen rm_lfp=rmesr<=7
replace rm_lfp=. if rmesr==-1

//working all weeks (INCLUDES paid leave, which is NOT coded seperately in SIPP)
gen working=rmesr==1
replace working =. if rmesr==-1

gen looking=rmesr==5 | rmesr==6 | rmesr==7
replace looking =. if rmesr==-1

gen lt_college_f=ref_month==1 & eeducate<44
by sippid: egen lt_college=max(lt_college_f)

//Event-study dummies with month -24 as reference month
gen Birth=birth+25 if birth>=-24 & birth~=.
replace Birth=50 if birth<=-25
replace Birth=51 if birth>24

//Event-study dummies interacted with indicator for whether birth occured in CA or NJ after the paid leave mandate was implemented
xi i.Birth*i.post_policy


//Event-study dummies with months -24 to -18 as reference period
gen IBirth=birth+25 if birth>=-23 & birth<=24 & birth~=.
replace IBirth=1 if birth>=-24 & birth<=-18
replace IBirth=2 if birth<-24
replace IBirth=50 if birth>24
//Event-study dummies interacted with indicator for whether the birth occured in CA or NJ after the paid leave mandate was implemented
xi, prefix(_L) i.IBirth*i.post_policy

save "$storage/econ816_presentation/US_PAID_leave_analysis.dta", replace
