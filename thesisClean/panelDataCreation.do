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
  keep YEAR VMONTH AGE SEX ETHNIC PAYPRIV PAYMCARE PAYMCAID PAYSELF PAYNOCHG PAYOTH PAYDK DIAG1 DIAG2 DIAG3 DIAG4 DIAG5 CANCER CEBVD CHF COPD NOCHRON TOTCHRON TEMPF BPSYS BPDIAS PELVIC SKIN ANYIMAGE MRI XRAY OTHIMAGE CBC GLUCOSE EKG URINE WOUND NOPROVID PHYSASST RNLPN OTHPROV NODISP OTHDISP PATWT REGION PATCODE RACER AGEDAYS AGER SETTYPE
  save "$ouput/temp`year'.dta", replace
}


// Append the dataset starting with 2006
use "$output/temp2006.dta", replace
forval year = 2007/2016 {
	append using "$output/temp`year'.dta"
    erase "$output/temp`year'.dta"
}


// Save the new dataset and delete the 2006 set
save "output/NAMCSPanel.dta", replace
erase "$output/temp2006.dta"