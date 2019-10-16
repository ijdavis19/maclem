/*****************************************************************************
Code for

Paid Parental Leave Laws in the United States: 
Does Short-Duration Leave Affect Women’s Labor-Force Attachment?

by Tanya Byker

Date: 01/11/2016
******************************************************************************/


clear all
set maxvar 32000
set matsize 10000
set more off, perm

*data directory (where posted datasets are stored)
global datafiles "C:\Paid_Leave_Data"


* Dataset contains observations for women aged 24-45 who gave birth in CA, NJ, NY, FL, or TX during one of SIPP panels (1996, 2001, 2004 or 2008)
use "$datafiles\SIPP_Paid_Leave.dta", clear

sort ssuid epppnum spanel swave srefmon
* create unique id for each individual
egen sippid=group(spanel ssuid epppnum )

bys sippid: gen months=_n
xtset sippid months

gen date=ym(rhcalyr, rhcalmn)
format date %tm

* generate varible that indicates month relative to birth
sort ssuid epppnum swave srefmon
bys ssuid epppnum: gen birth=date - birth_month

* occasionally individuals are missing from a wave during the panel, if a birth occurs during a missing wave, I assign the next month after the birth as the reference month (in order to determine educations level, for example)
gen birth_seen_f=0
replace birth_seen_f=1 if birth==0
bys sippid: egen birth_seen=max(birth_seen_f)
bys sippid: egen ref_month_ns=min(birth) if birth>0 & birth_seen==0
gen ref_month=1 if birth==0 & birth_seen==1
replace ref_month=1 if ref_month_ns==birth & birth_seen==0

gen state=tfipsst 
label define state 6 "California" 34 "New Jersey" 12 "Florida" 48 "Texas" 36 "New York" , replace
label values state state

* Weights: Each observation has it's own weight, but xtreg requires a single weight -- use the weight in the individual's last observation (results robust to using weights from other observations)
bys sippid: egen end_date=max(date)
format end_date %tm
gen  double end_weight_f=wpfinwgt if end_date==date
bys sippid: egen  double end_weight=max(end_weight_f)
replace end_weight=round(end_weight)

*** Policy Variables
gen CA_date=ym(2004,7)
format CA_date %tm

gen NJ_date=ym(2009,7)
format NJ_date %tm

* generate variable identifies births that occured when a paid leave was in effect in the mother's state
gen post_policy=0
replace post_policy=1 if tfipsst==34 & birth_month>=NJ_date
replace post_policy=1 if tfipsst==6 & birth_month>=CA_date

** SIPP coding of Labor-Market Outcomes:
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

* working all weeks (INCLUDES paid leave, which is NOT coded separately in the SIPP)
gen working=rmesr==1
replace working=. if rmesr==-1

gen looking=rmesr==5 | rmesr==6 | rmesr==7
replace looking=. if rmesr==-1


gen lt_college_f=ref_month==1 & eeducate<44
by sippid: egen lt_college=max(lt_college_f)


**** Event-study dummies with month -24 as reference month
gen Birth=birth+25 if birth>=-24 & birth~=.
replace Birth=50 if birth<=-25
replace Birth=51 if birth>24
  *  Event-study dummies interacted with indicator for whether the birth occured in a CA or NJ after the paid leave mandate was implemented
xi  i.Birth*i.post_policy

***** Event-study dummies with months -24 to -18 as reference period
gen lBirth=birth+25 if birth>=-23 & birth<=24 & birth~=.
replace lBirth=1 if birth>=-24 & birth<=-18
replace lBirth=2 if birth<-24	
replace lBirth=50 if birth>24	
  *  Event-study dummies interacted with indicator for whether the birth occured in a CA or NJ after the paid leave mandate was implemented
xi, prefix(_L) i.lBirth*i.post_policy


save "$datafiles\US_Paid_leave_analysis.dta", replace

** Create an datafile to store Event-Study DD coefficients (can be used to make figures)
clear
set obs 49
gen time = _n -25
save "$datafiles/ES_DD_estimates", replace emptyok

***************** Pattern of LFP around birth for mothers giving birth in CA and NJ before and after paid leave mandates  
foreach i of numlist 1 2 {
use  "$datafiles\US_Paid_leave_analysis.dta", clear
local X1  "_IBirth_2-_IBirth_51  [fweight=end_weight] if  post_policy==1 & (state==6 | state==34) "
local X2  "_IBirth_2-_IBirth_51  [fweight=end_weight] if  post_policy==0 & (state==6 | state==34) "
qui reg rm_lfp `X`i'', vce(cluster sippid)

use "$datafiles/ES_DD_estimates", clear
quietly {
         gen b_X`i'=.
		 forval j=1/49{
		               if `j'==1{
					              replace b_X`i'=_b[_cons] in `j'
							      }
						else {
						      replace b_X`i'=_b[_IBirth_`j'] + _b[_cons] in `j'
							 }
					     }
          }
		save "$datafiles/ES_DD_estimates", replace  
      }   
	  
***************** Simple difference estimates (note that some combinations of years and relative-to-birth month do not exist (for example if a panel only included part of a year - these will be omitted)	  
use  "$datafiles\US_Paid_leave_analysis.dta", clear
qui reg  rm_lfp i.lBirth  i.post_policy _LlBiXpos_2_1 _LlBiXpos_8_1-_LlBiXpos_50_1 [fweight=end_weight] if (state==6 | state==34),  vce(cluster sippid)

use "$datafiles/ES_DD_estimates", clear
qui {
         gen b_X3=.
		 		 forval j=1/49{       
							local var`j'=`j'+0
							if `j'>=1 & `j'<=7{
					              replace b_X3=0 in `j'
								  }
						else {
		                      replace b_X3=_b[_LlBiXpos_`var`j''_1]  in `j'
							 
			}
			}
          }
		save "$datafiles/ES_DD_estimates", replace  
 
***************** Event-Study DD estimates for full sample and by education	  
foreach i of numlist  4 5 6  {
use  "$datafiles\US_Paid_leave_analysis.dta", clear
local X4  " i.rhcalyr i.lBirth i.rhcalyr#i.state i.lBirth#i.state i.lBirth#i.rhcalyr _LlBiXpos_2_1 _LlBiXpos_8_1-_LlBiXpos_50_1 [pweight=end_weight] "
local X5  " i.rhcalyr i.lBirth i.rhcalyr#i.state i.lBirth#i.state i.lBirth#i.rhcalyr _LlBiXpos_2_1 _LlBiXpos_8_1-_LlBiXpos_50_1 [pweight=end_weight] if  lt_college==0 "
local X6  " i.rhcalyr i.lBirth i.rhcalyr#i.state i.lBirth#i.state i.lBirth#i.rhcalyr _LlBiXpos_2_1 _LlBiXpos_8_1-_LlBiXpos_50_1 [pweight=end_weight] if  lt_college==1 "
qui xtreg rm_lfp `X`i'', fe  vce(cluster sippid)

di "joint test for mth -3 to +3:"
qui test _LlBiXpos_22_1 _LlBiXpos_23_1 _LlBiXpos_24_1 _LlBiXpos_25_1 _LlBiXpos_26_1 _LlBiXpos_27_1 _LlBiXpos_28_1
di r(p)

use "$datafiles/ES_DD_estimates", clear
qui {
         gen b_X`i'=.
		 		 forval j=1/49{       
							local var`j'=`j'+0
							if `j'>=1 & `j'<=7{
					              replace b_X`i'=0 in `j'
								  }
						else {
		                      replace b_X`i'=_b[_LlBiXpos_`var`j''_1]  in `j'
							 
			}
			}
          }
		save "$datafiles/ES_DD_estimates", replace  
      }                    			        
***************** Decomposing LFP DD estimates into component parts: "With a Job" and "Looking"  (note there are a few other small categories not included (see SIPP definitions and coding above)
foreach i of numlist  7 8 {
use  "$datafiles\US_Paid_leave_analysis.dta", clear
local X7  " looking i.rhcalyr i.lBirth i.rhcalyr#i.state i.lBirth#i.state i.lBirth#i.rhcalyr _LlBiXpos_2_1 _LlBiXpos_8_1-_LlBiXpos_50_1 [pweight=end_weight] if  lt_college==1 "
local X8  " working i.rhcalyr i.lBirth i.rhcalyr#i.state i.lBirth#i.state i.lBirth#i.rhcalyr _LlBiXpos_2_1 _LlBiXpos_8_1-_LlBiXpos_50_1 [pweight=end_weight] if  lt_college==1 "
qui xtreg `X`i'', fe  vce(cluster sippid)
di "joint test for mth +6 to +12:"
qui test _LlBiXpos_31_1 _LlBiXpos_32_1 _LlBiXpos_33_1 _LlBiXpos_34_1 _LlBiXpos_35_1 _LlBiXpos_36_1 
di r(p)

use "$datafiles/ES_DD_estimates", clear
qui {
         gen b_X`i'=.
		 		 forval j=1/49{       
							local var`j'=`j'+0
							if `j'>=1 & `j'<=7{
					              replace b_X`i'=0 in `j'
								  }
						else {
		                      replace b_X`i'=_b[_LlBiXpos_`var`j''_1]  in `j'
							 
			}
			}
          }
		save "$datafiles/ES_DD_estimates", replace  
      }                    			        
	  
	  
	
