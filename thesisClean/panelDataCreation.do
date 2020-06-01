set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


// Set environmet variables
global projects: env projects
global storage: env storage

// General locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"

// Cycle through NAMCS surveys and retain varibales which appear each years
forval year = 2006/2016 {
  use "$dataraw/namcs`year'-stata.dta", replace
  if `year' < 2012 {
    forval codeNumber = 9/30 {
      gen DRUGID`codeNumber' =""
    }
    forval diagNumber = 4/5 {
      gen DIAG`diagNumber' = ""
    }
  }
  else if `year' == 2012 | `year' == 2013 {
    forval codeNumber = 13/30 {
      gen DRUGID`codeNumber' =""
    }
    forval diagNumber = 4/5 {
      gen DIAG`diagNumber' = ""
    }
  }
  keep YEAR VMONTH AGE SEX ETHNIC PAYPRIV PAYMCARE PAYMCAID PAYSELF PAYNOCHG PAYOTH PAYDK DIAG1 DIAG2 DIAG3 DRUGID1 DRUGID2 DRUGID3 DRUGID4 DRUGID5 DRUGID6 DRUGID7 DRUGID8 DRUGID9 DRUGID10 DRUGID11 DRUGID12 DRUGID13 DRUGID14 DRUGID15 DRUGID16 DRUGID17 DRUGID18 DRUGID19 DRUGID20 DRUGID21 DRUGID22 DRUGID23 DRUGID24 DRUGID25 DRUGID26 DRUGID27 DRUGID28 DRUGID29 DRUGID30 CANCER CEBVD CHF COPD NOCHRON TOTCHRON TEMPF BPSYS BPDIAS PELVIC SKIN ANYIMAGE MRI XRAY OTHIMAGE CBC GLUCOSE EKG URINE WOUND NOPROVID PHYSASST RNLPN OTHPROV NODISP OTHDISP PATWT REGION PATCODE RACER AGEDAYS AGER SETTYPE
  save "$output/temp`year'.dta", replace
}


// Append the dataset starting with 2006
use "$output/temp2006.dta", replace
forval year = 2007/2016 {
	append using "$output/temp`year'.dta"
  erase "$output/temp`year'.dta"
}


// Save the new dataset and delete the 2006 set
save "$output/NAMCSPanel.dta", replace
erase "$output/temp2006.dta"

