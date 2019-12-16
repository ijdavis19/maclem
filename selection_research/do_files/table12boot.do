* Table12boot.do  04/11/07
* entries for Tables 1 and 2 with bootstrapped standard errors

clear
set mem 350m
set matsize 300

* do demowgts
* clear
* set mem 350m

cd ..

do demowgtsmarital
do demowgtssch

cd "std errors"

use c:\junk\cps6403mini if age>=26 & age<=55 & race==1 & hispanic==0 & group_quarters==0 & _state~=25 & _state~=27 & married~=. & wgt~=. & wgt>0 & ((wrkyr>=1975 & wrkyr<=1979) | (wrkyr>=1995 & wrkyr<=1999)), clear
sort wrkyr
merge wrkyr using c:\junk\#tmptrim
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

* define regressors
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
forvalu tyr=1975/1979 {
append using ../demowgts7579
replace syntheticobs=1 if syntheticobs==.
replace wkyr=`tyr' if wkyr==. & syntheticobs==1
append using ../demowgtsfixed
replace syntheticobs=2 if syntheticobs==.
replace wkyr=`tyr' if wkyr==. & syntheticobs==2
append using ../demowgtsmarital
replace syntheticobs=3 if syntheticobs==.
replace wkyr=`tyr' if wkyr==. & syntheticobs==3
append using ../demowgtssch
replace syntheticobs=4 if syntheticobs==.
replace wkyr=`tyr' if wkyr==. & syntheticobs==4
}
forvalu tyr=1995/1999 {
append using ../demowgts9599
replace syntheticobs=1 if syntheticobs==.
replace wkyr=`tyr' if wkyr==. & syntheticobs==1
append using ../demowgtsfixed
replace syntheticobs=2 if syntheticobs==.
replace wkyr=`tyr' if wkyr==. & syntheticobs==2
append using ../demowgtsmarital
replace syntheticobs=3 if syntheticobs==.
replace wkyr=`tyr' if wkyr==. & syntheticobs==3
append using ../demowgtssch
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
global NMREGRESSORS "exp1 exp2 exp3 exp4 exp1_hsd08 exp1_hsd911 exp1_hsg exp1_cg exp1_ad exp2_hsd08 exp2_hsd911 exp2_hsg exp2_cg exp2_ad exp3_hsd08 exp3_hsd911 exp3_hsg exp3_cg exp3_ad exp4_hsd08 exp4_hsd911 exp4_hsg exp4_cg exp4_ad hsd08 hsd911 hsg cg ad mw so we"
global NMFREGRESSORS "f_exp1 f_exp2 f_exp3 f_exp4 f_exp1_hsd08 f_exp1_hsd911 f_exp1_hsg f_exp1_cg f_exp1_ad f_exp2_hsd08 f_exp2_hsd911 f_exp2_hsg f_exp2_cg f_exp2_ad f_exp3_hsd08 f_exp3_hsd911 f_exp3_hsg f_exp3_cg f_exp3_ad f_exp4_hsd08 f_exp4_hsd911 f_exp4_hsg f_exp4_cg f_exp4_ad f_hsd08 f_hsd911 f_hsg f_cg f_ad f_mw f_so f_we"

* break file into synthetic and organic obs
gen byte timepd = wkyr>=1995
save c:\junk\#tmporg, replace
keep if syntheticobs>0
save c:\junk\#tmpsyn, replace
use c:\junk\#tmporg if syntheticobs==0, clear


capture prog drop bias70s90s

** each loop of the bootstrap

prog define bias70s90s, rclass

version 7
set more off

* get all of the synthetic obs
append using c:\junk\#tmpsyn

* Probits for 1975-79 & 1995-99
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
capture drom millsnm
capture drop ftfyhat xdelta
probit ftfy50 $NMREGRESSORS __child06 if female == 1  & wkyr>=1975 & wkyr<=1979 [aw=wgt]
predict double ftfyhat, p
predict double xdelta, xb
gen double millsnm = 0
replace millsnm = normd(xdelta)/ftfyhat if female==1 & syntheticobs==0 & wkyr>=1975 & wkyr<=1979
capture drop ftfyhat xdelta
probit ftfy50 $NMREGRESSORS __child06 if female == 1  & wkyr>=1995 & wkyr<=1999 [aw=wgt]
predict double ftfyhat, p
predict double xdelta, xb
replace millsnm = normd(xdelta)/ftfyhat if female==1 & syntheticobs==0 & wkyr>=1995 & wkyr<=1999

* OLS
reg lnw female $REGRESSORS $FREGRESSORS if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1975 & wkyr<=1979 [aw=wgt], robust
predict lnwhatols
capture drop tmp
reg lnw female $REGRESSORS $FREGRESSORS if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1995 & wkyr<=1999 [aw=wgt], robust
predict tmp
replace lnwhatols=tmp if wkyr>=1995 & wkyr<=1999
reg lnw female $NMREGRESSORS $NMFREGRESSORS if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1975 & wkyr<=1979 [aw=wgt], robust
predict lnwhatolsnm
capture drop tmp
reg lnw female $NMREGRESSORS $NMFREGRESSORS if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1995 & wkyr<=1999 [aw=wgt], robust
predict tmp
replace lnwhatolsnm=tmp if wkyr>=1995 & wkyr<=1999

* Heckit
reg lnw female $REGRESSORS $FREGRESSORS mills if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1975 & wkyr<=1979 [aw=wgt], robust
predict lnwhathck
capture drop tmp
reg lnw female $REGRESSORS $FREGRESSORS mills if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1995 & wkyr<=1999 [aw=wgt], robust
predict tmp
replace lnwhathck=tmp if wkyr>=1995 & wkyr<=1999
reg lnw female $NMREGRESSORS $NMFREGRESSORS millsnm if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1975 & wkyr<=1979 [aw=wgt], robust
predict lnwhathcknm
capture drop tmp
reg lnw female $NMREGRESSORS $NMFREGRESSORS millsnm if trim==0 & ftfy50==1 & wagesmpl==1 & wkyr>=1995 & wkyr<=1999 [aw=wgt], robust
predict tmp
replace lnwhathcknm=tmp if wkyr>=1995 & wkyr<=1999

drop if syntheticobs==0

* Table 1, variable weights
sum lnwhatols if wkyr==1975 & syntheticobs==1 & female==0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==1 & female==1
local bols75f = r(mean)
return scalar t1vwols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==1 & female==0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==1 & female==1
local bols95f = r(mean)
return scalar t1vwols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==1 & female==0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==1 & female==1
local bols75f = r(mean)
return scalar t1vwhck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==1 & female==0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==1 & female==1
local bols95f = r(mean)
return scalar t1vwhck90s = `bols95f' - `bols95m'

* Table 1, fixed weights
sum lnwhatols if wkyr==1975 & syntheticobs==2 & female==0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==2 & female==1
local bols75f = r(mean)
return scalar t1fwols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==2 & female==0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==2 & female==1
local bols95f = r(mean)
return scalar t1fwols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==2 & female==0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==2 & female==1
local bols75f = r(mean)
return scalar t1fwhck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==2 & female==0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==2 & female==1
local bols95f = r(mean)
return scalar t1fwhck90s = `bols95f' - `bols95m'

* Table 2, marital variables dropped
sum lnwhatolsnm if wkyr==1975 & syntheticobs==2 & female==0
local bols75m = r(mean)
sum lnwhatolsnm if wkyr==1975 & syntheticobs==2 & female==1
local bols75f = r(mean)
return scalar t2nools70s = `bols75f' - `bols75m'
sum lnwhatolsnm if wkyr==1995 & syntheticobs==2 & female==0
local bols95m = r(mean)
sum lnwhatolsnm if wkyr==1995 & syntheticobs==2 & female==1
local bols95f = r(mean)
return scalar t2nools90s = `bols95f' - `bols95m'
sum lnwhathcknm if wkyr==1975 & syntheticobs==2 & female==0
local bols75m = r(mean)
sum lnwhathcknm if wkyr==1975 & syntheticobs==2 & female==1
local bols75f = r(mean)
return scalar t2nohck70s = `bols75f' - `bols75m'
sum lnwhathcknm if wkyr==1995 & syntheticobs==2 & female==0
local bols95m = r(mean)
sum lnwhathcknm if wkyr==1995 & syntheticobs==2 & female==1
local bols95f = r(mean)
return scalar t2nohck90s = `bols95f' - `bols95m'

* Table 2, currently married
sum lnwhatols if wkyr==1975 & syntheticobs==3 & female==0 & widowed<=0 & divorced<=0 & separated<=0 & nevermarried<=0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==3 & female==1 & widowed<=0 & divorced<=0 & separated<=0 & nevermarried<=0
local bols75f = r(mean)
return scalar t2cmols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==3 & female==0 & widowed<=0 & divorced<=0 & separated<=0 & nevermarried<=0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==3 & female==1 & widowed<=0 & divorced<=0 & separated<=0 & nevermarried<=0
local bols95f = r(mean)
return scalar t2cmols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==3 & female==0 & widowed<=0 & divorced<=0 & separated<=0 & nevermarried<=0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==3 & female==1 & widowed<=0 & divorced<=0 & separated<=0 & nevermarried<=0
local bols75f = r(mean)
return scalar t2cmhck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==3 & female==0 & widowed<=0 & divorced<=0 & separated<=0 & nevermarried<=0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==3 & female==1 & widowed<=0 & divorced<=0 & separated<=0 & nevermarried<=0
local bols95f = r(mean)
return scalar t2cmhck90s = `bols95f' - `bols95m'

* Table 2, separated
sum lnwhatols if wkyr==1975 & syntheticobs==3 & female==0 & separated>0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==3 & female==1 & separated>0
local bols75f = r(mean)
return scalar t2seols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==3 & female==0 & separated>0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==3 & female==1 & separated>0
local bols95f = r(mean)
return scalar t2seols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==3 & female==0 & separated>0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==3 & female==1 & separated>0
local bols75f = r(mean)
return scalar t2sehck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==3 & female==0 & separated>0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==3 & female==1 & separated>0
local bols95f = r(mean)
return scalar t2sehck90s = `bols95f' - `bols95m'

* Table 2, widowed
sum lnwhatols if wkyr==1975 & syntheticobs==3 & female==0 & widowed>0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==3 & female==1 & widowed>0
local bols75f = r(mean)
return scalar t2wdols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==3 & female==0 & widowed>0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==3 & female==1 & widowed>0
local bols95f = r(mean)
return scalar t2wdols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==3 & female==0 & widowed>0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==3 & female==1 & widowed>0
local bols75f = r(mean)
return scalar t2wdhck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==3 & female==0 & widowed>0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==3 & female==1 & widowed>0
local bols95f = r(mean)
return scalar t2wdhck90s = `bols95f' - `bols95m'

* Table 2, divorced
sum lnwhatols if wkyr==1975 & syntheticobs==3 & female==0 & divorced>0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==3 & female==1 & divorced>0
local bols75f = r(mean)
return scalar t2dvols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==3 & female==0 & divorced>0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==3 & female==1 & divorced>0
local bols95f = r(mean)
return scalar t2dvols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==3 & female==0 & divorced>0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==3 & female==1 & divorced>0
local bols75f = r(mean)
return scalar t2dvhck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==3 & female==0 & divorced>0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==3 & female==1 & divorced>0
local bols95f = r(mean)
return scalar t2dvhck90s = `bols95f' - `bols95m'

* Table 2, never married
sum lnwhatols if wkyr==1975 & syntheticobs==3 & female==0 & nevermarried>0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==3 & female==1 & nevermarried>0
local bols75f = r(mean)
return scalar t2nmols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==3 & female==0 & nevermarried>0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==3 & female==1 & nevermarried>0
local bols95f = r(mean)
return scalar t2nmols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==3 & female==0 & nevermarried>0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==3 & female==1 & nevermarried>0
local bols75f = r(mean)
return scalar t2nmhck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==3 & female==0 & nevermarried>0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==3 & female==1 & nevermarried>0
local bols95f = r(mean)
return scalar t2nmhck90s = `bols95f' - `bols95m'

* Table 2, 0-8 years of schooling
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==0 & hsd08>0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==1 & hsd08>0
local bols75f = r(mean)
return scalar t208ols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==0 & hsd08>0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==1 & hsd08>0
local bols95f = r(mean)
return scalar t208ols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==0 & hsd08>0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==1 & hsd08>0
local bols75f = r(mean)
return scalar t208hck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==0 & hsd08>0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==1 & hsd08>0
local bols95f = r(mean)
return scalar t208hck90s = `bols95f' - `bols95m'

* Table 2, 0-8 years of schooling
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==0 & hsd911>0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==1 & hsd911>0
local bols75f = r(mean)
return scalar t2hsdols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==0 & hsd911>0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==1 & hsd911>0
local bols95f = r(mean)
return scalar t2hsdols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==0 & hsd911>0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==1 & hsd911>0
local bols75f = r(mean)
return scalar t2hsdhck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==0 & hsd911>0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==1 & hsd911>0
local bols95f = r(mean)
return scalar t2hsdhck90s = `bols95f' - `bols95m'

* Table 2, high school grad
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==0 & hsg>0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==1 & hsg>0
local bols75f = r(mean)
return scalar t2hsgols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==0 & hsg>0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==1 & hsg>0
local bols95f = r(mean)
return scalar t2hsgols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==0 & hsg>0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==1 & hsg>0
local bols75f = r(mean)
return scalar t2hsghck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==0 & hsg>0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==1 & hsg>0
local bols95f = r(mean)
return scalar t2hsghck90s = `bols95f' - `bols95m'

* Table 2, some college
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==0 & hsd08<=0 & hsd911<=0 & hsg<=0 & cg<=0 & ad<=0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==1 & hsd08<=0 & hsd911<=0 & hsg<=0 & cg<=0 & ad<=0
local bols75f = r(mean)
return scalar t2scols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==0 & hsd08<=0 & hsd911<=0 & hsg<=0 & cg<=0 & ad<=0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==1 & hsd08<=0 & hsd911<=0 & hsg<=0 & cg<=0 & ad<=0
local bols95f = r(mean)
return scalar t2scols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==0 & hsd08<=0 & hsd911<=0 & hsg<=0 & cg<=0 & ad<=0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==1 & hsd08<=0 & hsd911<=0 & hsg<=0 & cg<=0 & ad<=0
local bols75f = r(mean)
return scalar t2schck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==0 & hsd08<=0 & hsd911<=0 & hsg<=0 & cg<=0 & ad<=0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==1 & hsd08<=0 & hsd911<=0 & hsg<=0 & cg<=0 & ad<=0
local bols95f = r(mean)
return scalar t2schck90s = `bols95f' - `bols95m'

* Table 2, college grad
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==0 & cg>0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==1 & cg>0
local bols75f = r(mean)
return scalar t2cgols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==0 & cg>0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==1 & cg>0
local bols95f = r(mean)
return scalar t2cgols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==0 & cg>0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==1 & cg>0
local bols75f = r(mean)
return scalar t2cghck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==0 & cg>0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==1 & cg>0
local bols95f = r(mean)
return scalar t2cghck90s = `bols95f' - `bols95m'

* Table 2, advanced degree
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==0 & ad>0
local bols75m = r(mean)
sum lnwhatols if wkyr==1975 & syntheticobs==4 & female==1 & ad>0
local bols75f = r(mean)
return scalar t2adols70s = `bols75f' - `bols75m'
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==0 & ad>0
local bols95m = r(mean)
sum lnwhatols if wkyr==1995 & syntheticobs==4 & female==1 & ad>0
local bols95f = r(mean)
return scalar t2adols90s = `bols95f' - `bols95m'
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==0 & ad>0
local bols75m = r(mean)
sum lnwhathck if wkyr==1975 & syntheticobs==4 & female==1 & ad>0
local bols75f = r(mean)
return scalar t2adhck70s = `bols75f' - `bols75m'
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==0 & ad>0
local bols95m = r(mean)
sum lnwhathck if wkyr==1995 & syntheticobs==4 & female==1 & ad>0
local bols95f = r(mean)
return scalar t2adhck90s = `bols95f' - `bols95m'

end

** end bootstrap loop

bootstrap r(t1vwols70s) r(t1vwhck70s) r(t1vwols90s) r(t1vwhck90s) r(t1fwols70s) r(t1fwhck70s) r(t1fwols90s) r(t1fwhck90s) r(t2nools70s) r(t2nohck70s) r(t2nools90s) r(t2nohck90s) r(t2cmols70s) r(t2cmhck70s) r(t2cmols90s) r(t2cmhck90s) r(t2seols70s) r(t2sehck70s) r(t2seols90s) r(t2sehck90s) r(t2wdols70s) r(t2wdhck70s) r(t2wdols90s) r(t2wdhck90s) r(t2dvols70s) r(t2dvhck70s) r(t2dvols90s) r(t2dvhck90s) r(t2nmols70s) r(t2nmhck70s) r(t2nmols90s) r(t2nmhck90s) r(t208ols70s) r(t208hck70s) r(t208ols90s) r(t208hck90s) r(t2hsdols70s) r(t2hsdhck70s) r(t2hsdols90s) r(t2hsdhck90s) r(t2hsgols70s) r(t2hsghck70s) r(t2hsgols90s) r(t2hsghck90s) r(t2scols70s) r(t2schck70s) r(t2scols90s) r(t2schck90s) r(t2cgols70s) r(t2cghck70s) r(t2cgols90s) r(t2cghck90s) r(t2adols70s) r(t2adhck70s) r(t2adols90s) r(t2adhck90s), reps(1000) seed(123) strata(timepd): bias70s90s

