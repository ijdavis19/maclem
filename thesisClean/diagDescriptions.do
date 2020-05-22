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
global dofiles = "economics/maclem/thesisClean"


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

// Categorize Diagnoses
gen infAndPara = 0
gen neoplasm = 0
gen endoNutMeta = 0
gen bloodAndBloodOrgans = 0
gen mental = 0
gen nervousSystem = 0
gen circSystem = 0
gen respSystem = 0
gen digSystem = 0
gen genSystem = 0
gen pregAndChildBirth = 0
gen skinAndSubCut = 0
gen muscAndConnect = 0
gen congenitalAnomaly = 0
gen newborn = 0
gen illDefined = 0
gen injAndPoison = 0
gen suppFactors = 0
gen general = 0

forval diagNumber = 1/5 {
    //Change ICD-10-CM to ICD-9-CM
    replace DIAG`diagNumber' = "0419" if DIAG`diagNumber' == "A499"
    replace DIAG`diagNumber' = "0979" if DIAG`diagNumber' == "A539"
    replace DIAG`diagNumber' = "07819" if DIAG`diagNumber' == "B078"
    replace DIAG`diagNumber' = "07054" if DIAG`diagNumber' == "B182"
    replace DIAG`diagNumber' = "042" if DIAG`diagNumber' == "B20-"
    replace DIAG`diagNumber' = "1369" if DIAG`diagNumber' == "B64-"
    replace DIAG`diagNumber' = "1619" if DIAG`diagNumber' == "C329"
    replace DIAG`diagNumber' = "1830" if DIAG`diagNumber' == "C569"
    replace DIAG`diagNumber' = "185" if DIAG`diagNumber' == "C61-"
    replace DIAG`diagNumber' = "1890" if DIAG`diagNumber' == "C649"
    replace DIAG`diagNumber' = "1889" if DIAG`diagNumber' == "C679"
    replace DIAG`diagNumber' = "20410" if DIAG`diagNumber' == "C911"
    replace DIAG`diagNumber' = "2163" if DIAG`diagNumber' == "D223"
    replace DIAG`diagNumber' = "2164" if DIAG`diagNumber' == "D224"
    replace DIAG`diagNumber' = "2239" if DIAG`diagNumber' == "D309"
    replace DIAG`diagNumber' = "2859" if DIAG`diagNumber' == "D649"
    replace DIAG`diagNumber' = "28861" if DIAG`diagNumber' == "D728"
    replace DIAG`diagNumber' = "2449" if DIAG`diagNumber' == "E039"
    replace DIAG`diagNumber' = "2469" if DIAG`diagNumber' == "E079"
    replace DIAG`diagNumber' = "24920" if DIAG`diagNumber' == "E08-"
    replace DIAG`diagNumber' = "25060" if DIAG`diagNumber' == "E114"
    replace DIAG`diagNumber' = "25060" if DIAG`diagNumber' == "E116"
    replace DIAG`diagNumber' = "25000" if DIAG`diagNumber' == "E119"
    replace DIAG`diagNumber' = "2564" if DIAG`diagNumber' == "E282"
    replace DIAG`diagNumber' = "2572" if DIAG`diagNumber' == "E291"
    replace DIAG`diagNumber' = "27800" if DIAG`diagNumber' == "E669"
    replace DIAG`diagNumber' = "29530" if DIAG`diagNumber' == "F200"
    replace DIAG`diagNumber' = "29680" if DIAG`diagNumber' == "F319"
    replace DIAG`diagNumber' = "30000" if DIAG`diagNumber' == "F419"
    replace DIAG`diagNumber' = "30981" if DIAG`diagNumber' == "F431"
    replace DIAG`diagNumber' = "30410" if DIAG`diagNumber' == "F132"
    replace DIAG`diagNumber' = "29900" if DIAG`diagNumber' == "F840"
    replace DIAG`diagNumber' = "3331" if DIAG`diagNumber' == "G250"
    replace DIAG`diagNumber' = "3394" if DIAG`diagNumber' == "G258"
    replace DIAG`diagNumber' = "340" if DIAG`diagNumber' == "G35-"
    replace DIAG`diagNumber' = "34590" if DIAG`diagNumber' == "G409"
    replace DIAG`diagNumber' = "34602" if DIAG`diagNumber' == "G431"
    replace DIAG`diagNumber' = "34932" if DIAG`diagNumber' == "G439"
    replace DIAG`diagNumber' = "48052" if DIAG`diagNumber' == "G470"
    replace DIAG`diagNumber' = "32721" if DIAG`diagNumber' == "G473"
    replace DIAG`diagNumber' = "3384" if DIAG`diagNumber' == "G894"
    replace DIAG`diagNumber' = "3732" if DIAG`diagNumber' == "H000"
    replace DIAG`diagNumber' = "36100" if DIAG`diagNumber' == "H33-"
    replace DIAG`diagNumber' = "37921" if DIAG`diagNumber' == "H438"
    replace DIAG`diagNumber' = "3804" if DIAG`diagNumber' == "H612"
    replace DIAG`diagNumber' = "38200" if DIAG`diagNumber' == "H66-"
    replace DIAG`diagNumber' = "3829" if DIAG`diagNumber' == "H669"
    replace DIAG`diagNumber' = "3819" if DIAG`diagNumber' == "H699"
    replace DIAG`diagNumber' = "3810" if DIAG`diagNumber' == "H80-"
    replace DIAG`diagNumber' = "38901" if DIAG`diagNumber' == "H900"
    replace DIAG`diagNumber' = "38911" if DIAG`diagNumber' == "H903"
    replace DIAG`diagNumber' = "38910" if DIAG`diagNumber' == "H905"
    replace DIAG`diagNumber' = "4010" if DIAG`diagNumber' == "I10-"
    replace DIAG`diagNumber' = "40300" if DIAG`diagNumber' == "I129"
    replace DIAG`diagNumber' = "41401" if DIAG`diagNumber' == "I251"
    replace DIAG`diagNumber' = "1272" if DIAG`diagNumber' == "I272"
    replace DIAG`diagNumber' = "4240" if DIAG`diagNumber' == "I340"
    replace DIAG`diagNumber' = "4241" if DIAG`diagNumber' == "I350"
    replace DIAG`diagNumber' = "42731" if DIAG`diagNumber' == "I482"
    replace DIAG`diagNumber' = "43491" if DIAG`diagNumber' == "I639"
    replace DIAG`diagNumber' = "4409" if DIAG`diagNumber' == "I709"
    replace DIAG`diagNumber' = "4439" if DIAG`diagNumber' == "I739"
    replace DIAG`diagNumber' = "4540" if DIAG`diagNumber' == "I83-"
    replace DIAG`diagNumber' = "460" if DIAG`diagNumber' == "J00-"
    replace DIAG`diagNumber' = "4618" if DIAG`diagNumber' == "J018"
    replace DIAG`diagNumber' = "4619" if DIAG`diagNumber' == "J019"
    replace DIAG`diagNumber' = "0340" if DIAG`diagNumber' == "J020"
    replace DIAG`diagNumber' = "4658" if DIAG`diagNumber' == "J069"
    replace DIAG`diagNumber' = "4660" if DIAG`diagNumber' == "J209"
    replace DIAG`diagNumber' = "4772" if DIAG`diagNumber' == "J308"
    replace DIAG`diagNumber' = "4779" if DIAG`diagNumber' == "J309"
    replace DIAG`diagNumber' = "4720" if DIAG`diagNumber' == "J310"
    replace DIAG`diagNumber' = "4730" if DIAG`diagNumber' == "J320"
    replace DIAG`diagNumber' = "4731" if DIAG`diagNumber' == "J321"
    replace DIAG`diagNumber' = "4732" if DIAG`diagNumber' == "J322"
    replace DIAG`diagNumber' = "4738" if DIAG`diagNumber' == "J324"
    replace DIAG`diagNumber' = "4739" if DIAG`diagNumber' == "J329"
    replace DIAG`diagNumber' = "4710" if DIAG`diagNumber' == "J330"
    replace DIAG`diagNumber' = "470" if DIAG`diagNumber' == "J342"
    replace DIAG`diagNumber' = "4780" if DIAG`diagNumber' == "J343"
    replace DIAG`diagNumber' = "47819" if DIAG`diagNumber' == "J349"
    replace DIAG`diagNumber' = "47400" if DIAG`diagNumber' == "J350"
    replace DIAG`diagNumber' = "4920" if DIAG`diagNumber' == "J439"
    replace DIAG`diagNumber' = "49120" if DIAG`diagNumber' == "J449"
    replace DIAG`diagNumber' = "49310" if DIAG`diagNumber' == "J452"
    replace DIAG`diagNumber' = "49392" if DIAG`diagNumber' == "J459"
    replace DIAG`diagNumber' = "51900" if DIAG`diagNumber' == "J95-"
    replace DIAG`diagNumber' = "53081" if DIAG`diagNumber' == "K219"
    replace DIAG`diagNumber' = "53390" if DIAG`diagNumber' == "K279"
    replace DIAG`diagNumber' = "55090" if DIAG`diagNumber' == "K409"
    replace DIAG`diagNumber' = "5531" if DIAG`diagNumber' == "K429"
    replace DIAG`diagNumber' = "55321" if DIAG`diagNumber' == "K432"
    replace DIAG`diagNumber' = "55329" if DIAG`diagNumber' == "K439"
    replace DIAG`diagNumber' = "5533" if DIAG`diagNumber' == "K449"
    replace DIAG`diagNumber' = "56400" if DIAG`diagNumber' == "K590"
    replace DIAG`diagNumber' = "5689" if DIAG`diagNumber' == "K669"
    replace DIAG`diagNumber' = "5715" if DIAG`diagNumber' == "K746"
    replace DIAG`diagNumber' = "6820" if DIAG`diagNumber' == "L02-"
    replace DIAG`diagNumber' = "68100" if DIAG`diagNumber' == "L030"
    replace DIAG`diagNumber' = "6823" if DIAG`diagNumber' == "L031"
    replace DIAG`diagNumber' = "68600" if DIAG`diagNumber' == "L08-"
    replace DIAG`diagNumber' = "6869" if DIAG`diagNumber' == "L089"
    replace DIAG`diagNumber' = "6983" if DIAG`diagNumber' == "L280"
    replace DIAG`diagNumber' = "6980" if DIAG`diagNumber' == "L29-"
    replace DIAG`diagNumber' = "6929" if DIAG`diagNumber' == "L300"
    replace DIAG`diagNumber' = "7030" if DIAG`diagNumber' == "L600"
    replace DIAG`diagNumber' = "7061" if DIAG`diagNumber' == "L700"
    replace DIAG`diagNumber' = "7061" if DIAG`diagNumber' == "L709"
    replace DIAG`diagNumber' = "7062" if DIAG`diagNumber' == "L728"
    replace DIAG`diagNumber' = "70583" if DIAG`diagNumber' == "L732"
    replace DIAG`diagNumber' = "7048" if DIAG`diagNumber' == "L738"
    replace DIAG`diagNumber' = "7049" if DIAG`diagNumber' == "L739"
    replace DIAG`diagNumber' = "70909" if DIAG`diagNumber' == "L810"
    replace DIAG`diagNumber' = "7092" if DIAG`diagNumber' == "L905"
    replace DIAG`diagNumber' = "6954" if DIAG`diagNumber' == "L93-"
    replace DIAG`diagNumber' = "70715" if DIAG`diagNumber' == "L975"
    replace DIAG`diagNumber' = "70710" if DIAG`diagNumber' == "L979"
    replace DIAG`diagNumber' = "7099" if DIAG`diagNumber' == "L989"
    replace DIAG`diagNumber' = "7144" if DIAG`diagNumber' == "M12-"
    replace DIAG`diagNumber' = "71530" if DIAG`diagNumber' == "M199"
    replace DIAG`diagNumber' = "71940" if DIAG`diagNumber' == "M255"
    replace DIAG`diagNumber' = "7100" if DIAG`diagNumber' == "M329"
    replace DIAG`diagNumber' = "72400" if DIAG`diagNumber' == "M480"
    replace DIAG`diagNumber' = "7242" if DIAG`diagNumber' == "M545"
    replace DIAG`diagNumber' = "7238" if DIAG`diagNumber' == "M548"
    replace DIAG`diagNumber' = "7291" if DIAG`diagNumber' == "M79-"
    replace DIAG`diagNumber' = "7291" if DIAG`diagNumber' == "M797"
    replace DIAG`diagNumber' = "73301" if DIAG`diagNumber' == "M810"
    replace DIAG`diagNumber' = "73000" if DIAG`diagNumber' == "M86-"
    replace DIAG`diagNumber' = "5934" if DIAG`diagNumber' == "N138"
    replace DIAG`diagNumber' = "5909" if DIAG`diagNumber' == "N159"
    replace DIAG`diagNumber' = "5854" if DIAG`diagNumber' == "N184"
    replace DIAG`diagNumber' = "5859" if DIAG`diagNumber' == "N189"
    replace DIAG`diagNumber' = "5920" if DIAG`diagNumber' == "N200"
    replace DIAG`diagNumber' = "5920" if DIAG`diagNumber' == "N202"
    replace DIAG`diagNumber' = "5941" if DIAG`diagNumber' == "N210"
    replace DIAG`diagNumber' = "5939" if DIAG`diagNumber' == "N289"
    replace DIAG`diagNumber' = "5950" if DIAG`diagNumber' == "N300"
    replace DIAG`diagNumber' = "5951" if DIAG`diagNumber' == "N301"
    replace DIAG`diagNumber' = "5959" if DIAG`diagNumber' == "N309"
    replace DIAG`diagNumber' = "5960" if DIAG`diagNumber' == "N320"
    replace DIAG`diagNumber' = "5970" if DIAG`diagNumber' == "N34-"
    replace DIAG`diagNumber' = "5989" if DIAG`diagNumber' == "N359"
    replace DIAG`diagNumber' = "5990" if DIAG`diagNumber' == "N390"
    replace DIAG`diagNumber' = "6256" if DIAG`diagNumber' == "N393"
    replace DIAG`diagNumber' = "60000" if DIAG`diagNumber' == "N40-"
    replace DIAG`diagNumber' = "60000" if DIAG`diagNumber' == "N400"
    replace DIAG`diagNumber' = "60001" if DIAG`diagNumber' == "N401"
    replace DIAG`diagNumber' = "611" if DIAG`diagNumber' == "N411"
    replace DIAG`diagNumber' = "6039" if DIAG`diagNumber' == "N433"
    replace DIAG`diagNumber' = "60490" if DIAG`diagNumber' == "N45-"
    replace DIAG`diagNumber' = "60490" if DIAG`diagNumber' == "N453"
    replace DIAG`diagNumber' = "6071" if DIAG`diagNumber' == "N481"
    replace DIAG`diagNumber' = "60784" if DIAG`diagNumber' == "N529"
    replace DIAG`diagNumber' = "6111" if DIAG`diagNumber' == "N62-"
    replace DIAG`diagNumber' = "61172" if DIAG`diagNumber' == "N63-"
    replace DIAG`diagNumber' = "6268" if DIAG`diagNumber' == "N938"
    replace DIAG`diagNumber' = "7850" if DIAG`diagNumber' == "R000"
    replace DIAG`diagNumber' = "7847" if DIAG`diagNumber' == "R040"
    replace DIAG`diagNumber' = "7862" if DIAG`diagNumber' == "R05-"
    replace DIAG`diagNumber' = "78609" if DIAG`diagNumber' == "R060"
    replace DIAG`diagNumber' = "78607" if DIAG`diagNumber' == "R062"
    replace DIAG`diagNumber' = "7841" if DIAG`diagNumber' == "R070"
    replace DIAG`diagNumber' = "6089" if DIAG`diagNumber' == "R102"
    replace DIAG`diagNumber' = "78961" if DIAG`diagNumber' == "R108"
    replace DIAG`diagNumber' = "78900" if DIAG`diagNumber' == "R109"
    replace DIAG`diagNumber' = "78702" if DIAG`diagNumber' == "R110"
    replace DIAG`diagNumber' = "7810" if DIAG`diagNumber' == "R252"
    replace DIAG`diagNumber' = "7812" if DIAG`diagNumber' == "R268"
    replace DIAG`diagNumber' = "7881" if DIAG`diagNumber' == "R300"
    replace DIAG`diagNumber' = "59971" if DIAG`diagNumber' == "R310"
    replace DIAG`diagNumber' = "59972" if DIAG`diagNumber' == "R312"
    replace DIAG`diagNumber' = "59970" if DIAG`diagNumber' == "R319"
    replace DIAG`diagNumber' = "78829" if DIAG`diagNumber' == "R338"
    replace DIAG`diagNumber' = "78820" if DIAG`diagNumber' == "R339"
    replace DIAG`diagNumber' = "78841" if DIAG`diagNumber' == "R350"
    replace DIAG`diagNumber' = "78843" if DIAG`diagNumber' == "R351"
    replace DIAG`diagNumber' = "78864" if DIAG`diagNumber' == "R391"
    replace DIAG`diagNumber' = "78899" if DIAG`diagNumber' == "R399"
    replace DIAG`diagNumber' = "7811" if DIAG`diagNumber' == "R430"
    replace DIAG`diagNumber' = "7840" if DIAG`diagNumber' == "R51-"
    replace DIAG`diagNumber' = "7856" if DIAG`diagNumber' == "R590"
    replace DIAG`diagNumber' = "79009" if DIAG`diagNumber' == "R718"
    replace DIAG`diagNumber' = "79021" if DIAG`diagNumber' == "R730"
    replace DIAG`diagNumber' = "79551" if DIAG`diagNumber' == "R761"
    replace DIAG`diagNumber' = "7919" if DIAG`diagNumber' == "R829"
    replace DIAG`diagNumber' = "79093" if DIAG`diagNumber' == "R972"
    replace DIAG`diagNumber' = "800" if DIAG`diagNumber' == "S604"
    replace DIAG`diagNumber' = "800" if DIAG`diagNumber' == "S629"
    replace DIAG`diagNumber' = "800" if DIAG`diagNumber' == "S731"
    replace DIAG`diagNumber' = "800" if DIAG`diagNumber' == "T214"
    replace DIAG`diagNumber' = "800" if DIAG`diagNumber' == "T509"
    replace DIAG`diagNumber' = "800" if DIAG`diagNumber' == "T819"
    replace DIAG`diagNumber' = "800" if DIAG`diagNumber' == "T839"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z000"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z028"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z029"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z09-"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z123"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z223"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z433"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z518"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z720"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z795"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z798"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z861"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z874"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z922"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z950"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "Z988"
    replace DIAG`diagNumber' = "general" if DIAG`diagNumber' == "ZZZ0"
    replace DIAG`diagNumber' = "3099" if DIAG`diagNumber' == "F432"
    replace DIAG`diagNumber' = "5350" if DIAG`diagNumber' == "K297"
    replace DIAG`diagNumber' = "800" if DIAG`diagNumber' == "S626"

    // Infectious and Parasitic Diseases (001-139)
    replace infAndPara = 1 if real(substr(DIAG`diagNumber',1,1)) == 0
    replace infAndPara = 1 if real(substr(DIAG`diagNumber',1,1)) == 1 & real(substr(DIAG`diagNumber',2,1)) <= 3

    // Neoplasms (140-239)
    replace neoplasm = 1 if real(substr(DIAG`diagNumber',1,3)) >= 140 & real(substr(DIAG`diagNumber',1,3)) <= 239

    // Endocrine, Nutritional, and Metabolic (240-279)
    replace endoNutMeta = 1 if real(substr(DIAG`diagNumber',1,3)) >= 240 & real(substr(DIAG`diagNumber',1,3)) <= 279

    // Diseases of Blood and Blood Forming Organs (280-289)
    replace bloodAndBloodOrgans = 1 if real(substr(DIAG`diagNumber',1,3)) >= 280 & real(substr(DIAG`diagNumber',1,3)) <= 289

    // Mental Disorders (290-319)
    replace mental = 1 if real(substr(DIAG`diagNumber',1,3)) >= 290 & real(substr(DIAG`diagNumber',1,3)) <= 319

    // Diseases of Nervous System and Sense Organs (320-389)
    replace nervousSystem = 1 if real(substr(DIAG`diagNumber',1,3)) >= 320 & real(substr(DIAG`diagNumber',1,3)) <= 389

    // Diseases of Circulatory System (390-459)
    replace circSystem = 1 if real(substr(DIAG`diagNumber',1,3)) >= 390 & real(substr(DIAG`diagNumber',1,3)) <= 459

    // Diseases of Respiratory System (460-519)
    replace respSystem = 1 if real(substr(DIAG`diagNumber',1,3)) >= 460 & real(substr(DIAG`diagNumber',1,3)) <= 519

    // Diseases of Digestive System (520-579)
    replace digSystem = 1 if real(substr(DIAG`diagNumber',1,3)) >= 520 & real(substr(DIAG`diagNumber',1,3)) <= 579

    // Diseases of Genitourinary System (580-629)
    replace genSystem = 1 if real(substr(DIAG`diagNumber',1,3)) >= 580 & real(substr(DIAG`diagNumber',1,3)) <= 629

    // Complications of Pregnancy, Childbirth, and the Puerperium (630-679)
    replace pregAndChildBirth = 1 if real(substr(DIAG`diagNumber',1,3)) >= 630 & real(substr(DIAG`diagNumber',1,3)) <= 679

    // Diseases Skin and Subcutaneous Tissue (680-709)
    replace skinAndSubCut = 1 if real(substr(DIAG`diagNumber',1,3)) >= 680 & real(substr(DIAG`diagNumber',1,3)) <= 709

    // Diseases of Musculoskeletal and Connective Tissue (710-739)
    replace muscAndConnect = 1 if real(substr(DIAG`diagNumber',1,3)) >= 710 & real(substr(DIAG`diagNumber',1,3)) <= 739

    // Congenital Anomalies (740-759)
    replace congenitalAnomaly = 1 if real(substr(DIAG`diagNumber',1,3)) >= 740 & real(substr(DIAG`diagNumber',1,3)) <= 759

    // Newborn Guidelines (760-779)
    replace newborn = 1 if real(substr(DIAG`diagNumber',1,3)) >= 760 & real(substr(DIAG`diagNumber',1,3)) <= 779

    // Signs, Symptoms, and Ill-Defined Conditions (780-799)
    replace illDefined = 1 if real(substr(DIAG`diagNumber',1,3)) >= 780 & real(substr(DIAG`diagNumber',1,3)) <= 799

    // Injury and Poisoning (800-999)
    replace injAndPoison = 1 if real(substr(DIAG`diagNumber',1,3)) >= 800 & real(substr(DIAG`diagNumber',1,3)) <= 999

    // Classification of Factors Influencing Health Status and Contact with Health Services (Supplemental V01-V91)
    replace suppFactors = 1 if substr(DIAG`diagNumber',1,1) == "V"

    // Supplemental Classification of External Causes of Injury and Poisoning (E800-E999) []

    // General/Undefinable
    replace general = 1 if DIAG`diagNumber' == "general"
}



gen offPatent = 1 if YEAR > `firstGenYear'
replace offPatent = 1 if YEAR == `firstGenYear' & VMONTH >= `firstGenMonth'
replace offPatent = 0 if offPatent != 1

gen observationMonth = (YEAR - 2000)*12 + VMONTH
gen genericMonth = (`firstGenYear' - 2000)*12 + `firstGenMonth'
gen monthsAfterGeneric = observationMonth - genericMonth
gen genericOn = 1 if monthsAfterGeneric >= 0
replace genericOn = 0 if monthsAfterGeneric < 0 

forval diagNumber = 1/5 {
    tab DIAG`diagNumber' if infAndPara == 0 & neoplasm == 0 & endoNutMeta == 0 & bloodAndBloodOrgans == 0 & mental == 0 & nervousSystem == 0 & circSystem == 0 & respSystem == 0 & digSystem == 0 & genSystem == 0 & pregAndChildBirth == 0 & skinAndSubCut == 0 & muscAndConnect == 0 & congenitalAnomaly == 0 & newborn == 0 & illDefined == 0 & injAndPoison == 0 & suppFactors == 0 &prescriptionIndicator == 1
}

tab prescriptionIndicator if infAndPara == 1
tab prescriptionIndicator if neoplasm == 1
tab prescriptionIndicator if endoNutMeta == 1
tab prescriptionIndicator if mental == 1
tab prescriptionIndicator if nervousSystem == 1
tab prescriptionIndicator if circSystem == 1
tab prescriptionIndicator if respSystem == 1
tab prescriptionIndicator if digSystem == 1
tab prescriptionIndicator if genSystem == 1
tab prescriptionIndicator if pregAndChildBirth == 1
tab prescriptionIndicator if skinAndSubCut == 1
tab prescriptionIndicator if muscAndConnect == 1
tab prescriptionIndicator if congenitalAnomaly == 1
tab prescriptionIndicator if newborn == 1
tab prescriptionIndicator if illDefined == 1
tab prescriptionIndicator if injAndPoison == 1
tab prescriptionIndicator if suppFactors == 1

save "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace
