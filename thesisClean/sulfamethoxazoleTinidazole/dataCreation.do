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
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"


// Dataset
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
  keep YEAR VMONTH AGE SEX ETHNIC PAYPRIV PAYMCARE PAYMCAID PAYSELF PAYNOCHG PAYOTH PAYDK DIAG1 DIAG2 DIAG3 DIAG4 DIAG5 DRUGID1 DRUGID2 DRUGID3 DRUGID4 DRUGID5 DRUGID6 DRUGID7 DRUGID8 DRUGID9 DRUGID10 DRUGID11 DRUGID12 DRUGID13 DRUGID14 DRUGID15 DRUGID16 DRUGID17 DRUGID18 DRUGID19 DRUGID20 DRUGID21 DRUGID22 DRUGID23 DRUGID24 DRUGID25 DRUGID26 DRUGID27 DRUGID28 DRUGID29 DRUGID30 CANCER CEBVD CHF COPD NOCHRON TOTCHRON TEMPF BPSYS BPDIAS PELVIC SKIN ANYIMAGE MRI XRAY OTHIMAGE CBC GLUCOSE EKG URINE WOUND NOPROVID PHYSASST RNLPN OTHPROV NODISP OTHDISP PATWT REGION PATCODE RACER AGEDAYS AGER SETTYPE
  save "$output/temp`year'.dta", replace
}

// Append the dataset starting with 2006
use "$output/temp2006.dta", replace
forval year = 2007/2016 {
	append using "$output/temp`year'.dta"
  erase "$output/temp`year'.dta"
}

// Recode expected source of payment
replace PAYDK = 1 if PAYMCAID == 0 & PAYMCARE == 0 & PAYNOCHG == 0 & PAYOTH == 0 & PAYPRIV == 0 & PAYSELF == 0
gen payRecode = 0
replace payRecode = 1 if PAYMCAID == 1
replace payRecode = 2 if PAYMCARE == 1
replace payRecode = 3 if PAYNOCHG == 1
replace payRecode = 4 if PAYOTH == 1
replace payRecode = 5 if PAYPRIV == 1
replace payRecode = 6 if PAYSELF == 1
replace payRecode = 7 if PAYDK == 1

// Save the new dataset and delete the 2006 set
save "$output/NAMCSPanel.dta", replace
erase "$output/temp2006.dta"

use "$output/NAMCSPanel.dta", replace

//set local variables
local genEQ = "d00124"
local firstGenYear = 2012
local firstGenMonth = 11

gen prescriptionIndicator =.

// indicator for prescription
forval number = 1/30 {
    replace prescriptionIndicator = 1 if DRUGID`number' == "`genEQ'"
    replace prescriptionIndicator = 0 if prescriptionIndicator != 1
}
save "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace

// create local variables for each diagnosis
forval diagNumber = 1/5 {
    use "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace
    drop if prescriptionIndicator == 0
    bysort DIAG`diagNumber': gen spec`diagNumber'DiagCount = _n
    drop if spec`diagNumber'DiagCount > 1
    gen diagCount`diagNumber' = _n
    save "$output/temp.dta", replace
    sum diagCount`diagNumber'
    local diagMax`diagNumber' = r(max)
    display "cleared 1"
    forval diagCounter = 1/`diagMax`diagNumber''{
        use "$output/temp.dta", replace
        drop if diagCount`diagNumber' != `diagCounter'
        local `diagNumber'diag`diagCounter' = DIAG`diagNumber'
    }
}
erase "$output/temp.dta"
ma list

// Loop through all diagnoses to determine if relevant diagnosis was made
use "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace
gen relevantDiagIndicator = 0
forval diagNumber = 1/5 {
    forval diagCounter = 1/`diagMax`diagNumber'' {
        forval diagNumberComp = 1/5{
	    display "``diagNumber'diag`diagCounter''"
        replace relevantDiagIndicator = 1 if DIAG`diagNumberComp' == "``diagNumber'diag`diagCounter''"        
        }
    }
}

gen offPatent = 1 if YEAR > `firstGenYear'
replace offPatent = 1 if YEAR == `firstGenYear' & VMONTH >= `firstGenMonth'
replace offPatent = 0 if offPatent != 1

gen observationMonth = (YEAR - 2000)*12 + VMONTH
gen genericMonth = (`firstGenYear' - 2000)*12 + `firstGenMonth'
gen monthsAfterGeneric = observationMonth - genericMonth
gen genericOn = 1 if monthsAfterGeneric >= 0
replace genericOn = 0 if monthsAfterGeneric < 0 

save "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace
