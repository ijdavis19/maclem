//Generates Data sets that all of the same variables to be appended after running AbxSplit.do

forval year = 2006/2016 {
  use "$output/cefotetan/diag/`year'.dta", replace
  //gen year = YEAR
  #delimit ;
  keep YEAR
	VMONTH
	VDAYR
	AGE
	SEX
	ETHNIC
	PAYPRIV
	PAYMCARE
	PAYMCAID
	//PAYWKCMD
	PAYSELF
	PAYNOCHG
	PAYOTH
	PAYDK
	PAYTYPE
	INJURY
	//PRDIAG
	CANCER
	CEBVD
	CHF
	COPD
	GLUCOSE
	EKG
	URINE
	NOCHRON
	TOTCHRON
	TEMPF
	BPSYS
	BPDIAS
	PELVIC
	SKIN
	ANYIMAGE
	MRI
	XRAY
	OTHIMAGE
	CBC
	WOUND
	NOPROVID
	PHYSASST
	RNLPN
	OTHPROV
	NODISP
	OTHDISP
	PATWT
	REGION
	PATCODE
	BDATEFL
	SEXFL
	ETHNICFL
	RACER
	AGEDAYS
	AGER
	SETTYPE
	YEAR
	CSTRATM
	CPSUM;
  #delimit cr
  //save "$output/namcsclipped`year'.dta", replace
 }
 /*
use "$output/namcsclipped2006.dta", replace
forval year = 2007/2016 {
	append using "$output/namcsclipped`year'.dta"
}
save "$output/namcstotal.dta", replace*/
