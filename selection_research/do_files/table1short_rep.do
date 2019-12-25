//Replication of Table1short.do
//Analysis holds but doesn't have bootstrapped errors

set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


//set environmet variables
global projects: env projects
global storage: env storage
global maclem: env maclem

//general locations
global dataraw =  "$storage/selection_research"
global output = "$projects/selection_research"

***********************************************
do "$maclem/selection_research/do_files/demowgtsmarital_rep.do"
do "$maclem/selection_research/do_files/demowgtssch_rep.do"

use $dataraw\cps6403mini if age>=26 & age<=55 & race==1 & hispanic==0 & group_quarters==0 & _state~=25 & _state~=27 & married~=. & wgt~=. & wgt>0 & ((wrkyr>=1975 & wrkyr<=1979) | (wrkyr>=1995 & wrkyr<=1999)), clear
sort wrkyr
merge wrkyr using $dataraw\#tmptrim
tab _merge
drop if _merge==2
drop _merge
gen byte wagesmpl = (age>=26 & age<=55 & wageworker==1 & race==1 & hispanic==0 & group_quarters==0 & _state~=25 & _state~=27 & agriculture==0 & _popstat==1 & phh==0 & allocated==0 & selfemp==0 & wage_cpi~=. & wage_cpi~=0 & wgt~=.)
capture ren yr wkyr
capture ren wrkyr wkyr
ren ever_married evermarried
gen byte nevermarried = 1-evermarried
gen byte agely = age-1
gen hrwg_cpi = wage_cpi / wrkhrlyr
gen lnw = log(hrwg_cpi)
gen byte ftfy50 = wksly>=50 & hrslyr>=35
gen byte trim = 0
replace  trim = -1 if hrwg_cpi<p01wghr
replace  trim = -1 if hrwg_cpi < 2.8
replace trim = 1 if hrwg_cpi>p98wghr
egen sumwgt = sum(wgt), by(wkyr)
replace wgt = wgt/sumwgt

*Define regressors
keep wkyr lnw ftfy50 trim widowed separated divorced nevermarried wkyr education agely evermarried exp _state wgt female ftfy50 __child06 wagesmpl occlyr
gen byte hsd08=(education==1)
gen byte hsd911=(education >=2 & education <=4)
gen byte hsg=(education==5)
gen byte sc=(education==6)
gen byte cg=(education==7)
gen byte ad=(education==8)
rename exp exp1
replace exp1 = exp1-15
gen exp2 = (exp1^2)/100
gen exp3 = (exp1^3)/1000
gen exp4 = (exp1^4)/10000
gen exp1_hsd08  = exp1*hsd08
gen exp1_hsd911 = exp1*hsd911
gen exp1_hsg = exp1*hsg
gen exp1_sc  = exp1*sc
gen exp1_cg  = exp1*cg
gen exp1_ad  = exp1*ad
gen exp2_hsd08  = exp2*hsd08
gen exp2_hsd911 = exp2*hsd911
gen exp2_hsg = exp2*hsg
gen exp2_sc  = exp2*sc
gen exp2_cg  = exp2*cg
gen exp2_ad  = exp2*ad
gen exp3_hsd08  = exp3*hsd08
gen exp3_hsd911 = exp3*hsd911
gen exp3_hsg = exp3*hsg
gen exp3_sc  = exp3*sc
gen exp3_cg  = exp3*cg
gen exp3_ad  = exp3*ad
gen exp4_hsd08  = exp4*hsd08
gen exp4_hsd911 = exp4*hsd911
gen exp4_hsg = exp4*hsg
gen exp4_sc  = exp4*sc
gen exp4_cg  = exp4*cg
gen exp4_ad  = exp4*ad
gen byte ne=_state>= 1 & _state<= 5
gen byte mw=_state>= 6 & _state<=10
gen byte so=_state>=11 & _state<=18
gen byte we=_state>=19 & _state<=21

* insert the same synthetic male and synthetic female for each year
gen byte syntheticobs=0
forval tyr=1975/1979{
	append using $dataraw/demowgts7579
	*append using demowgtsii70s
	replace syntheticobs=1 if syntheticobs==.
	replace wkyr=`tyr' if wkyr==. & syntheticobs==1
	append using $dataraw/demowgtsfixed
	replace syntheticobs=2 if syntheticobs==.
	replace wkyr=`tyr' if wkyr==. & syntheticobs==2
	append using $dataraw/demowgtsmarital
	replace syntheticobs=3 if syntheticobs==.
	replace wkyr = `tyr' if wkyr==. & syntheticobs==3
	append using $dataraw/demowgtssch
	replace syntheticobs=4 if syntheticobs==.
	replace wkyr=`tyr' if wkyr==. & syntheticobs==4
}
forval tyr=1995/1999{
	append using $dataraw/demowgts9599
	* append using demowgtisii90s
	replace syntheticobs=1 if syntheticobs==.
	replace wkyr=`tyr' if wkyr==. & syntheticobs==1
	append using $dataraw/demowgtsfixed
	replace syntheticobs=2 if syntheticobs==.
	replace wkyr=`tyr' if wkyr==. & syntheticobs==2
	append using $dataraw/demowgtsmarital
	replace syntheticobs=3 if syntheticobs==.
	replace wkyr=`tyr' if wkyr==. & syntheticobs==3
	append using $dataraw/demowgtssch
	replace syntheticobs=4 if syntheticobs==.
	replace wkyr=`tyr' if wkyr==. & syntheticobs==4
}

gen f_widowed = female*widowed
gen f_separated = female*separated
gen f_divorced = female*divorced
gen f_nevermarried = female*nevermarried
gen f_exp1 = female*exp1
gen f_exp2 = female*exp2
gen f_exp3 = female*exp3
gen f_exp4 = female*exp4
gen f_exp1_hsd08 = female*exp1_hsd08
gen f_exp1_hsd911 = female*exp1_hsd911
gen f_exp1_hsg = female*exp1_hsg
gen f_exp1_cg = female*exp1_cg
gen f_exp1_ad = female*exp1_ad
gen f_exp2_hsd08 = female*exp2_hsd08
gen f_exp2_hsd911 = female*exp2_hsd911
gen f_exp2_hsg = female*exp2_hsg
gen f_exp2_cg = female*exp2_cg
gen f_exp2_ad = female*exp2_ad
gen f_exp3_hsd08 = female*exp3_hsd08
gen f_exp3_hsd911 = female*exp3_hsd911
gen f_exp3_hsg = female*exp3_hsg
gen f_exp3_cg = female*exp3_cg
gen f_exp3_ad = female*exp3_ad
gen f_exp4_hsd08 = female*exp4_hsd08
gen f_exp4_hsd911 = female*exp4_hsd911
gen f_exp4_hsg = female*exp4_hsg
gen f_exp4_cg = female*exp4_cg
gen f_exp4_ad = female*exp4_ad
gen f_hsd08 = female*hsd08
gen f_hsd911 = female*hsd911
gen f_hsg = female*hsg
gen f_sc = female*sc
gen f_cg = female*cg
gen f_ad = female*ad
gen f_mw = female*mw
gen f_so = female*so
gen f_we = female*we
gen byte nmkids = nevermarried*__child06
gen byte spkids = separated*__child06
gen byte dvkids = divorced*__child06
gen byte wdkids = widowed*__child06


global REGRESSORS "widowed divorced separated nevermarried exp1 exp2 exp3 exp4 exp1_hsd08 exp1_hsd911 exp1_hsg exp1_cg exp1_ad exp2_hsd08 exp2_hsd911 exp2_hsg exp2_cg exp2_ad exp3_hsd08 exp3_hsd911 exp3_hsg exp3_cg exp3_ad exp4_hsd08 exp4_hsd911 exp4_hsg exp4_cg exp4_ad hsd08 hsd911 hsg cg ad mw so we"
global FREGRESSORS "f_widowed f_divorced f_separated f_nevermarried f_exp1 f_exp2 f_exp3 f_exp4 f_exp1_hsd08 f_exp1_hsd911 f_exp1_hsg f_exp1_cg f_exp1_ad f_exp2_hsd08 f_exp2_hsd911 f_exp2_hsg f_exp2_cg f_exp2_ad f_exp3_hsd08 f_exp3_hsd911 f_exp3_hsg f_exp3_cg f_exp3_ad f_exp4_hsd08 f_exp4_hsd911 f_exp4_hsg f_exp4_cg f_exp4_ad f_hsd08 f_hsd911 f_hsg f_cg f_ad f_mw f_so f_we"

* Probit for 1975-79 & 1995-99
version 7
capture drop ftfyhat xdelta mills
probit ftfy50 $REGRESSORS __child06 spkids dvkids wdkids nmkids if female == 1  & wkyr>=1975 & wkyr<=1979 [aw=wgt]
predict double ftfyhat, p
predict double xdelta, xb
gen double mills = 0
replace mills = normd(xdelta)/ftfyhat if female==1 & syntheticobs==0 & wkyr>=1975 & wkyr<=1979
capture drop ftfyhat xdelta
probit ftfy50 $REGRESSORS __child06 spkids dvkids wdkids nmkids if female == 1  & wkyr>=1995 & wkyr<=1999 [aw=wgt]
predict double ftfyhat, p
predict double xdelta, xb
replace mills = normd(xdelta)/ftfyhat if female==1 & syntheticobs==0 & wkyr>=1995 & wkyr<=1999

* OLS
reg lnw female $REGRESSORS $FREGRESSORS if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1975 & wkyr<=1979 [aw=wgt], robust
predict lnwhatols
replace lnwhatols = lnwhatols - _b[_cons] - (female*_b[female]) if syntheticobs>2
predict sewhatols, stdp
predict residols, resid
capture drop tmp
reg lnw female $REGRESSORS $FREGRESSORS if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1995 & wkyr<=1999 [aw=wgt], robust
predict tmp
replace tmp = tmp - _b[_cons] - (female*_b[female]) if syntheticobs>2
replace lnwhatols=tmp if wkyr>=1995 & wkyr<=1999
capture drop tmp
predict tmp, stdp
replace sewhatols=tmp if wkyr>=1995 & wkyr<=1999
capture drop tmp
predict tmp, resid
replace residols=tmp if wkyr>=1995 & wkyr<=1999

* Heckit
reg lnw female $REGRESSORS $FREGRESSORS mills if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1975 & wkyr<=1979 [aw=wgt], robust
predict lnwhatheck
replace lnwhatheck = lnwhatheck - _b[_cons] - (female*_b[female]) if syntheticobs>2
predict sewhatheck, stdp
predict residheck, resid
capture drop tmp
reg lnw female $REGRESSORS $FREGRESSORS mills if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1995 & wkyr<=1999 [aw=wgt], robust
predict tmp
replace tmp = tmp - _b[_cons] - (female*_b[female]) if syntheticobs>2
replace lnwhatheck=tmp if wkyr>=1995 & wkyr<=1999
capture drop tmp
predict tmp, stdp
replace sewhatheck=tmp if wkyr>=1995 & wkyr<=1999
capture drop tmp
predict tmp, resid
replace residheck=tmp if wkyr>=1995 & wkyr<=1999

* variable weights
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==1
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==1

* variable weights
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==1
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==1
* fixed weights
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==2
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==2
* fixed weights, Table 2 marital deviations
* NOTE the std errors do not properly treat the std error of the constant
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==3 & widowed>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==3 & divorced>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==3 & separated>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==3 & nevermarried>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==3 & widowed<=0 & divorced<=0 & separated<=0 & nevermarried<=0
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==3 & widowed>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==3 & divorced>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==3 & separated>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==3 & nevermarried>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==3 & widowed<=0 & divorced<=0 & separated<=0 & nevermarried<=0
* fixed weights, Table 2 schooling deviations
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==4 & hsd08>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==4 & hsd911>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==4 & hsg>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==4 & hsd08<=0 & hsd911<=0 & hsg<=0 & cg<=0 & ad<=0
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==4 & cg>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1975 & syntheticobs==4 & ad>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==4 & hsd08>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==4 & hsd911>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==4 & hsg>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==4 & hsd08<=0 & hsd911<=0 & hsg<=0 & cg<=0 & ad<=0
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==4 & cg>0
list female lnwhatols lnwhatheck sewhat* if wkyr==1995 & syntheticobs==4 & ad>0

sum residols if female==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1975 & wkyr<=1979 [aw=wgt], detail
sum residols if female==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1995 & wkyr<=1999 [aw=wgt], detail
_pctile residols if female==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1975 & wkyr<=1979 [aw=wgt], percentile(13(7)27)
return list
_pctile residols if female==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1995 & wkyr<=1999 [aw=wgt], percentile(13(7)27)
return list

