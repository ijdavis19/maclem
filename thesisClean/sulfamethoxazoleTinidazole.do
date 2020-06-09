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
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole.do"


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
gen signsAndSymptoms = 0
gen injAndPoison = 0
gen suppFactors = 0
gen general = 0

qui forval diagNumber = 1/3 {
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

    // "Unrelated" Diagnoses
    replace DIAG`diagNumber' = "00861" if DIAG`diagNumber' == "A08-"
    replace DIAG`diagNumber' = "0088" if DIAG`diagNumber' == "A084"
    replace DIAG`diagNumber' = "0090" if DIAG`diagNumber' == "A09-"
    replace DIAG`diagNumber' = "0639" if DIAG`diagNumber' == "A41-"
    replace DIAG`diagNumber' = "13100" if DIAG`diagNumber' == "A59-"
    replace DIAG`diagNumber' = "05410" if DIAG`diagNumber' == "A600"
    replace DIAG`diagNumber' = "099" if DIAG`diagNumber' == "A64-"
    replace DIAG`diagNumber' = "08881" if DIAG`diagNumber' == "A692"
    replace DIAG`diagNumber' = "07998" if DIAG`diagNumber' == "A749"
    replace DIAG`diagNumber' = "0540" if DIAG`diagNumber' == "B00-"
    replace DIAG`diagNumber' = "05473" if DIAG`diagNumber' == "B001"
    replace DIAG`diagNumber' = "05440" if DIAG`diagNumber' == "B005"
    replace DIAG`diagNumber' = "0548" if DIAG`diagNumber' == "B009"
    replace DIAG`diagNumber' = "05319" if DIAG`diagNumber' == "B02-"
    replace DIAG`diagNumber' = "05311" if DIAG`diagNumber' == "B022"
    replace DIAG`diagNumber' = "05329" if DIAG`diagNumber' == "B023"
    replace DIAG`diagNumber' = "0539" if DIAG`diagNumber' == "B029"
    replace DIAG`diagNumber' = "07812" if DIAG`diagNumber' == "B070"
    replace DIAG`diagNumber' = "07810" if DIAG`diagNumber' == "B079"
    replace DIAG`diagNumber' = "05101" if DIAG`diagNumber' == "B08-"
    replace DIAG`diagNumber' = "0780" if DIAG`diagNumber' == "B081"
    replace DIAG`diagNumber' = "0743" if DIAG`diagNumber' == "B084"
    replace DIAG`diagNumber' = "07030" if DIAG`diagNumber' == "B191"
    replace DIAG`diagNumber' = "07070" if DIAG`diagNumber' == "B192"
    replace DIAG`diagNumber' = "07799" if DIAG`diagNumber' == "B309"
    replace DIAG`diagNumber' = "7908" if DIAG`diagNumber' == "B349"
    replace DIAG`diagNumber' = "1101" if DIAG`diagNumber' == "B351"
    replace DIAG`diagNumber' = "1104" if DIAG`diagNumber' == "B353"
    replace DIAG`diagNumber' = "1105" if DIAG`diagNumber' == "B354"
    replace DIAG`diagNumber' = "1103" if DIAG`diagNumber' == "B356"
    replace DIAG`diagNumber' = "1109" if DIAG`diagNumber' == "B359"
    replace DIAG`diagNumber' = "1110" if DIAG`diagNumber' == "B360"
    replace DIAG`diagNumber' = "1119" if DIAG`diagNumber' == "B369"
    replace DIAG`diagNumber' = "1123" if DIAG`diagNumber' == "B372"
    replace DIAG`diagNumber' = "1121" if DIAG`diagNumber' == "B373"
    replace DIAG`diagNumber' = "1129" if DIAG`diagNumber' == "B379"
    replace DIAG`diagNumber' = "1330" if DIAG`diagNumber' == "B86-"
    replace DIAG`diagNumber' = "04100" if DIAG`diagNumber' == "B955"
    replace DIAG`diagNumber' = "04110" if DIAG`diagNumber' == "B958"
    replace DIAG`diagNumber' = "07953" if DIAG`diagNumber' == "B97-"
    replace DIAG`diagNumber' = "1450" if DIAG`diagNumber' == "C06-"
    replace DIAG`diagNumber' = "1519" if DIAG`diagNumber' == "C169"
    replace DIAG`diagNumber' = "1534" if DIAG`diagNumber' == "C18-"
    replace DIAG`diagNumber' = "1539" if DIAG`diagNumber' == "C189"
    replace DIAG`diagNumber' = "1543" if DIAG`diagNumber' == "C210"
    replace DIAG`diagNumber' = "1550" if DIAG`diagNumber' == "C22-"
    replace DIAG`diagNumber' = "1570" if DIAG`diagNumber' == "C25-"
    replace DIAG`diagNumber' = "1622" if DIAG`diagNumber' == "C34-"
    replace DIAG`diagNumber' = "1623" if DIAG`diagNumber' == "C341"
    replace DIAG`diagNumber' = "1629" if DIAG`diagNumber' == "C349"
    replace DIAG`diagNumber' = "1709" if DIAG`diagNumber' == "C419"
    replace DIAG`diagNumber' = "1720" if DIAG`diagNumber' == "C43-"
    replace DIAG`diagNumber' = "1726" if DIAG`diagNumber' == "C436"
    replace DIAG`diagNumber' = "1729" if DIAG`diagNumber' == "C439"
    replace DIAG`diagNumber' = "17300" if DIAG`diagNumber' == "C44-"
    replace DIAG`diagNumber' = "17310" if DIAG`diagNumber' == "C441"
    replace DIAG`diagNumber' = "17330" if DIAG`diagNumber' == "C443"
    replace DIAG`diagNumber' = "17340" if DIAG`diagNumber' == "C444"
    replace DIAG`diagNumber' = "17350" if DIAG`diagNumber' == "C445"
    replace DIAG`diagNumber' = "17360" if DIAG`diagNumber' == "C446"
    replace DIAG`diagNumber' = "17370" if DIAG`diagNumber' == "C447"
    replace DIAG`diagNumber' = "17390" if DIAG`diagNumber' == "C449"
    replace DIAG`diagNumber' = "1710" if DIAG`diagNumber' == "C49-"
    replace DIAG`diagNumber' = "1740" if DIAG`diagNumber' == "C50-"
    replace DIAG`diagNumber' = "1742" if DIAG`diagNumber' == "C502"
    replace DIAG`diagNumber' = "1744" if DIAG`diagNumber' == "C504"
    replace DIAG`diagNumber' = "1749" if DIAG`diagNumber' == "C509"
    replace DIAG`diagNumber' = "1809" if DIAG`diagNumber' == "C539"
    replace DIAG`diagNumber' = "1820" if DIAG`diagNumber' == "C549"
    replace DIAG`diagNumber' = "1860" if DIAG`diagNumber' == "C62-"
    replace DIAG`diagNumber' = "1890" if DIAG`diagNumber' == "C64-"
    replace DIAG`diagNumber' = "1880" if DIAG`diagNumber' == "C67-"
    replace DIAG`diagNumber' = "1899" if DIAG`diagNumber' == "C689"
    replace DIAG`diagNumber' = "193" if DIAG`diagNumber' == "C73-"
    replace DIAG`diagNumber' = "1969" if DIAG`diagNumber' == "C779"
    replace DIAG`diagNumber' = "1970" if DIAG`diagNumber' == "C78-"
    replace DIAG`diagNumber' = "1980" if DIAG`diagNumber' == "C79-"
    replace DIAG`diagNumber' = "19881" if DIAG`diagNumber' == "C798"
    replace DIAG`diagNumber' = "1990" if DIAG`diagNumber' == "C80-"
    replace DIAG`diagNumber' = "1991" if DIAG`diagNumber' == "C801"
    replace DIAG`diagNumber' = "20280" if DIAG`diagNumber' == "C859"
    replace DIAG`diagNumber' = "20300" if DIAG`diagNumber' == "C900"
    replace DIAG`diagNumber' = "20400" if DIAG`diagNumber' == "C91-"
    replace DIAG`diagNumber' = "20500" if DIAG`diagNumber' == "C92-"
    replace DIAG`diagNumber' = "2309" if DIAG`diagNumber' == "D019"
    replace DIAG`diagNumber' = "1720" if DIAG`diagNumber' == "D03-"
    replace DIAG`diagNumber' = "2320" if DIAG`diagNumber' == "D04-"
    replace DIAG`diagNumber' = "2330" if DIAG`diagNumber' == "D05-"
    replace DIAG`diagNumber' = "2331" if DIAG`diagNumber' == "D069"
    replace DIAG`diagNumber' = "2332" if DIAG`diagNumber' == "D07-"
    replace DIAG`diagNumber' = "2100" if DIAG`diagNumber' == "D10-"
    replace DIAG`diagNumber' = "2102" if DIAG`diagNumber' == "D119"
    replace DIAG`diagNumber' = "2113" if DIAG`diagNumber' == "D12-"
    replace DIAG`diagNumber' = "2120" if DIAG`diagNumber' == "D14-"
    replace DIAG`diagNumber' = "2140" if DIAG`diagNumber' == "D17-"
    replace DIAG`diagNumber' = "2419" if DIAG`diagNumber' == "D179"
    replace DIAG`diagNumber' = "22800" if DIAG`diagNumber' == "D180"
    replace DIAG`diagNumber' = "2150" if DIAG`diagNumber' == "D21-"
    replace DIAG`diagNumber' = "2165" if DIAG`diagNumber' == "D225"
    replace DIAG`diagNumber' = "2166" if DIAG`diagNumber' == "D226"
    replace DIAG`diagNumber' = "2168" if DIAG`diagNumber' == "D229"
    replace DIAG`diagNumber' = "2162" if DIAG`diagNumber' == "D232"
    replace DIAG`diagNumber' = "2163" if DIAG`diagNumber' == "D233"
    replace DIAG`diagNumber' = "2165" if DIAG`diagNumber' == "D235"
    replace DIAG`diagNumber' = "2166" if DIAG`diagNumber' == "D236"
    replace DIAG`diagNumber' = "2169" if DIAG`diagNumber' == "D239"
    replace DIAG`diagNumber' = "217" if DIAG`diagNumber' == "D24-"
    replace DIAG`diagNumber' = "217" if DIAG`diagNumber' == "D241"
    replace DIAG`diagNumber' = "2189" if DIAG`diagNumber' == "D259"
    replace DIAG`diagNumber' = "2243" if DIAG`diagNumber' == "D31-"
    replace DIAG`diagNumber' = "2246" if DIAG`diagNumber' == "D313"
    replace DIAG`diagNumber' = "2270" if DIAG`diagNumber' == "D35-"
    replace DIAG`diagNumber' = "2290" if DIAG`diagNumber' == "D36-"
    replace DIAG`diagNumber' = "23691" if DIAG`diagNumber' == "D41-"
    replace DIAG`diagNumber' = "23875" if DIAG`diagNumber' == "D469"
    replace DIAG`diagNumber' = "23879" if DIAG`diagNumber' == "D479"
    replace DIAG`diagNumber' = "99812" if DIAG`diagNumber' == "D78-"
    replace DIAG`diagNumber' = "2382" if DIAG`diagNumber' == "D485"
    replace DIAG`diagNumber' = "2389" if DIAG`diagNumber' == "D489"
    replace DIAG`diagNumber' = "2390" if DIAG`diagNumber' == "D49-"
    replace DIAG`diagNumber' = "2390" if DIAG`diagNumber' == "D492"
    replace DIAG`diagNumber' = "2399" if DIAG`diagNumber' == "D499"
    replace DIAG`diagNumber' = "2809" if DIAG`diagNumber' == "D509"
    replace DIAG`diagNumber' = "2810" if DIAG`diagNumber' == "D510"
    replace DIAG`diagNumber' = "28981" if DIAG`diagNumber' == "D685"
    replace DIAG`diagNumber' = "2869" if DIAG`diagNumber' == "D689"
    replace DIAG`diagNumber' = "2870" if DIAG`diagNumber' == "D69-"
    replace DIAG`diagNumber' = "2872" if DIAG`diagNumber' == "D692"
    replace DIAG`diagNumber' = "28739" if DIAG`diagNumber' == "D693"
    replace DIAG`diagNumber' = "135" if DIAG`diagNumber' == "D860"
    replace DIAG`diagNumber' = "135" if DIAG`diagNumber' == "D869"
    replace DIAG`diagNumber' = "2448" if DIAG`diagNumber' == "E038"
    replace DIAG`diagNumber' = "2410" if DIAG`diagNumber' == "E041"
    replace DIAG`diagNumber' = "2411" if DIAG`diagNumber' == "E042"
    replace DIAG`diagNumber' = "24200" if DIAG`diagNumber' == "E050"
    replace DIAG`diagNumber' = "24290" if DIAG`diagNumber' == "E059"
    replace DIAG`diagNumber' = "2452" if DIAG`diagNumber' == "E063"
    replace DIAG`diagNumber' = "25011" if DIAG`diagNumber' == "E10-"
    replace DIAG`diagNumber' = "25001" if DIAG`diagNumber' == "E109"
    replace DIAG`diagNumber' = "25050" if DIAG`diagNumber' == "E113"
    replace DIAG`diagNumber' = "25201" if DIAG`diagNumber' == "E21-"
    replace DIAG`diagNumber' = "25200" if DIAG`diagNumber' == "E213"
    replace DIAG`diagNumber' = "2530" if DIAG`diagNumber' == "E22-"
    replace DIAG`diagNumber' = "2532" if DIAG`diagNumber' == "E23-"
    replace DIAG`diagNumber' = "2560" if DIAG`diagNumber' == "E28-"
    replace DIAG`diagNumber' = "2662" if DIAG`diagNumber' == "E538"
    replace DIAG`diagNumber' = "2689" if DIAG`diagNumber' == "E559"
    replace DIAG`diagNumber' = "27801" if DIAG`diagNumber' == "E660"
    replace DIAG`diagNumber' = "27802" if DIAG`diagNumber' == "E663"
    replace DIAG`diagNumber' = "2720" if DIAG`diagNumber' == "E780"
    replace DIAG`diagNumber' = "2721" if DIAG`diagNumber' == "E781"
    replace DIAG`diagNumber' = "2722" if DIAG`diagNumber' == "E782"
    replace DIAG`diagNumber' = "2724" if DIAG`diagNumber' == "E784"
    replace DIAG`diagNumber' = "2724" if DIAG`diagNumber' == "E785"
    replace DIAG`diagNumber' = "2752" if DIAG`diagNumber' == "E834"
    replace DIAG`diagNumber' = "27700" if DIAG`diagNumber' == "E849"
    replace DIAG`diagNumber' = "27651" if DIAG`diagNumber' == "E860"
    replace DIAG`diagNumber' = "2779" if DIAG`diagNumber' == "E889"
    replace DIAG`diagNumber' = "29410" if DIAG`diagNumber' == "F028"
    replace DIAG`diagNumber' = "2900" if DIAG`diagNumber' == "F039"
    replace DIAG`diagNumber' = "3102" if DIAG`diagNumber' == "F078"
    replace DIAG`diagNumber' = "3109" if DIAG`diagNumber' == "F09-"
    replace DIAG`diagNumber' = "30500" if DIAG`diagNumber' == "F101"
    replace DIAG`diagNumber' = "30390" if DIAG`diagNumber' == "F102"
    replace DIAG`diagNumber' = "30550" if DIAG`diagNumber' == "F111"
    replace DIAG`diagNumber' = "30400" if DIAG`diagNumber' == "F112"
    replace DIAG`diagNumber' = "3051" if DIAG`diagNumber' == "F172"
    replace DIAG`diagNumber' = "30580" if DIAG`diagNumber' == "F19-"
    replace DIAG`diagNumber' = "30580" if DIAG`diagNumber' == "F191"
    replace DIAG`diagNumber' = "30460" if DIAG`diagNumber' == "F192"
    replace DIAG`diagNumber' = "29590" if DIAG`diagNumber' == "F209"
    replace DIAG`diagNumber' = "2970" if DIAG`diagNumber' == "F22-"
    replace DIAG`diagNumber' = "29570" if DIAG`diagNumber' == "F250"
    replace DIAG`diagNumber' = "29570" if DIAG`diagNumber' == "F259"
    replace DIAG`diagNumber' = "2989" if DIAG`diagNumber' == "F29-"
    replace DIAG`diagNumber' = "29640" if DIAG`diagNumber' == "F31-"
    replace DIAG`diagNumber' = "29660" if DIAG`diagNumber' == "F316"
    replace DIAG`diagNumber' = "2967" if DIAG`diagNumber' == "F317"
    replace DIAG`diagNumber' = "29689" if DIAG`diagNumber' == "F318"
    replace DIAG`diagNumber' = "29621" if DIAG`diagNumber' == "F32-"
    replace DIAG`diagNumber' = "29623" if DIAG`diagNumber' == "F322"
    replace DIAG`diagNumber' = "29626" if DIAG`diagNumber' == "F325"
    replace DIAG`diagNumber' = "29682" if DIAG`diagNumber' == "F328"
    replace DIAG`diagNumber' = "29620" if DIAG`diagNumber' == "F329"
    replace DIAG`diagNumber' = "29631" if DIAG`diagNumber' == "F330"
    replace DIAG`diagNumber' = "29632" if DIAG`diagNumber' == "F331"
    replace DIAG`diagNumber' = "29633" if DIAG`diagNumber' == "F332"
    replace DIAG`diagNumber' = "29630" if DIAG`diagNumber' == "F339"
    replace DIAG`diagNumber' = "3004" if DIAG`diagNumber' == "F341"
    replace DIAG`diagNumber' = "29699" if DIAG`diagNumber' == "F349"
    replace DIAG`diagNumber' = "29690" if DIAG`diagNumber' == "F39-"
    replace DIAG`diagNumber' = "30022" if DIAG`diagNumber' == "F400"
    replace DIAG`diagNumber' = "30023" if DIAG`diagNumber' == "F401"
    replace DIAG`diagNumber' = "30001" if DIAG`diagNumber' == "F410"
    replace DIAG`diagNumber' = "30002" if DIAG`diagNumber' == "F411"
    replace DIAG`diagNumber' = "30009" if DIAG`diagNumber' == "F418"
    replace DIAG`diagNumber' = "3003" if DIAG`diagNumber' == "F42-"
    replace DIAG`diagNumber' = "3089" if DIAG`diagNumber' == "F43-"
    replace DIAG`diagNumber' = "30089" if DIAG`diagNumber' == "F458"
    replace DIAG`diagNumber' = "30082" if DIAG`diagNumber' == "F459"
    replace DIAG`diagNumber' = "3009" if DIAG`diagNumber' == "F489"
    replace DIAG`diagNumber' = "30754" if DIAG`diagNumber' == "F508"
    replace DIAG`diagNumber' = "30750" if DIAG`diagNumber' == "F509"
    replace DIAG`diagNumber' = "30742" if DIAG`diagNumber' == "F510"
    replace DIAG`diagNumber' = "30740" if DIAG`diagNumber' == "F519"
    replace DIAG`diagNumber' = "3013" if DIAG`diagNumber' == "F603"
    replace DIAG`diagNumber' = "31231" if DIAG`diagNumber' == "F63-"
    replace DIAG`diagNumber' = "29699" if DIAG`diagNumber' == "F349"
    replace DIAG`diagNumber' = "319" if DIAG`diagNumber' == "F79"
    replace DIAG`diagNumber' = "31539" if DIAG`diagNumber' == "F80-"
    replace DIAG`diagNumber' = "31539" if DIAG`diagNumber' == "F809"
    replace DIAG`diagNumber' = "3159" if DIAG`diagNumber' == "F89-"
    replace DIAG`diagNumber' = "31400" if DIAG`diagNumber' == "F900"
    replace DIAG`diagNumber' = "31401" if DIAG`diagNumber' == "F901"
    replace DIAG`diagNumber' = "31401" if DIAG`diagNumber' == "F902"
    replace DIAG`diagNumber' = "31400" if DIAG`diagNumber' == "F909"
    replace DIAG`diagNumber' = "31381" if DIAG`diagNumber' == "F91-"
    replace DIAG`diagNumber' = "30721" if DIAG`diagNumber' == "F95-"
    replace DIAG`diagNumber' = "3076" if DIAG`diagNumber' == "F98-"
    replace DIAG`diagNumber' = "31389" if DIAG`diagNumber' == "F988"
    replace DIAG`diagNumber' = "3009" if DIAG`diagNumber' == "F99-"
    replace DIAG`diagNumber' = "3229" if DIAG`diagNumber' == "G039"
    replace DIAG`diagNumber' = "3320" if DIAG`diagNumber' == "G20-"
    replace DIAG`diagNumber' = "33392" if DIAG`diagNumber' == "G21-"
    replace DIAG`diagNumber' = "33385" if DIAG`diagNumber' == "G24-"
    replace DIAG`diagNumber' = "3310" if DIAG`diagNumber' == "G309"
    replace DIAG`diagNumber' = "3308" if DIAG`diagNumber' == "G318"
    replace DIAG`diagNumber' = "34550" if DIAG`diagNumber' == "G40-"
    replace DIAG`diagNumber' = "34550" if DIAG`diagNumber' == "G401"
    replace DIAG`diagNumber' = "34540" if DIAG`diagNumber' == "G402"
    replace DIAG`diagNumber' = "3453" if DIAG`diagNumber' == "G403"
    replace DIAG`diagNumber' = "34612" if DIAG`diagNumber' == "G430"
    replace DIAG`diagNumber' = "34672" if DIAG`diagNumber' == "G437"
    replace DIAG`diagNumber' = "34622" if DIAG`diagNumber' == "G438"
    replace DIAG`diagNumber' = "33900" if DIAG`diagNumber' == "G44-"
    replace DIAG`diagNumber' = "33910" if DIAG`diagNumber' == "G442"
    replace DIAG`diagNumber' = "4350" if DIAG`diagNumber' == "G45-"
    replace DIAG`diagNumber' = "4359" if DIAG`diagNumber' == "G459"
    replace DIAG`diagNumber' = "32710" if DIAG`diagNumber' == "G471"
    replace DIAG`diagNumber' = "78050" if DIAG`diagNumber' == "G479"
    replace DIAG`diagNumber' = "3501" if DIAG`diagNumber' == "G500"
    replace DIAG`diagNumber' = "3509" if DIAG`diagNumber' == "G509"
    replace DIAG`diagNumber' = "3510" if DIAG`diagNumber' == "G510"
    replace DIAG`diagNumber' = "3519" if DIAG`diagNumber' == "G519"
    replace DIAG`diagNumber' = "3539" if DIAG`diagNumber' == "G549"
    replace DIAG`diagNumber' = "3540" if DIAG`diagNumber' == "G560"
    replace DIAG`diagNumber' = "3541" if DIAG`diagNumber' == "G561"
    replace DIAG`diagNumber' = "3542" if DIAG`diagNumber' == "G562"
    replace DIAG`diagNumber' = "3549" if DIAG`diagNumber' == "G569"
    replace DIAG`diagNumber' = "3551" if DIAG`diagNumber' == "G571"
    replace DIAG`diagNumber' = "3558" if DIAG`diagNumber' == "G579"
    replace DIAG`diagNumber' = "3559" if DIAG`diagNumber' == "G589"
    replace DIAG`diagNumber' = "3569" if DIAG`diagNumber' == "G609"
    replace DIAG`diagNumber' = "3576" if DIAG`diagNumber' == "G62-"
    replace DIAG`diagNumber' = "3579" if DIAG`diagNumber' == "G629"
    replace DIAG`diagNumber' = "35789" if DIAG`diagNumber' == "G64-"
    replace DIAG`diagNumber' = "35800" if DIAG`diagNumber' == "G70-"
    replace DIAG`diagNumber' = "3432" if DIAG`diagNumber' == "G80-"
    replace DIAG`diagNumber' = "3441" if DIAG`diagNumber' == "G82-"
    replace DIAG`diagNumber' = "32811" if DIAG`diagNumber' == "G891"
    replace DIAG`diagNumber' = "33701" if DIAG`diagNumber' == "G90-"
    replace DIAG`diagNumber' = "3313" if DIAG`diagNumber' == "G91-"
    replace DIAG`diagNumber' = "3480" if DIAG`diagNumber' == "G93-"
    replace DIAG`diagNumber' = "3482" if DIAG`diagNumber' == "G932"
    replace DIAG`diagNumber' = "3499" if DIAG`diagNumber' == "G969"
    replace DIAG`diagNumber' = "3499" if DIAG`diagNumber' == "G988"
    replace DIAG`diagNumber' = "3732" if DIAG`diagNumber' == "H001"
    replace DIAG`diagNumber' = "37300" if DIAG`diagNumber' == "H010"
    replace DIAG`diagNumber' = "73732" if DIAG`diagNumber' == "H011"
    replace DIAG`diagNumber' = "3739" if DIAG`diagNumber' == "H019"
    replace DIAG`diagNumber' = "37400" if DIAG`diagNumber' == "H020"
    replace DIAG`diagNumber' = "37410" if DIAG`diagNumber' == "H021"
    replace DIAG`diagNumber' = "37430" if DIAG`diagNumber' == "H024"
    replace DIAG`diagNumber' = "37486" if DIAG`diagNumber' == "H028"
    replace DIAG`diagNumber' = "3749" if DIAG`diagNumber' == "H029"
    replace DIAG`diagNumber' = "37511" if DIAG`diagNumber' == "H041"
    replace DIAG`diagNumber' = "37520" if DIAG`diagNumber' == "H042"
    replace DIAG`diagNumber' = "37557" if DIAG`diagNumber' == "H045"
    replace DIAG`diagNumber' = "37600" if DIAG`diagNumber' == "H05-"
    replace DIAG`diagNumber' = "37202" if DIAG`diagNumber' == "H100"
    replace DIAG`diagNumber' = "37205" if DIAG`diagNumber' == "H101"
    replace DIAG`diagNumber' = "37200" if DIAG`diagNumber' == "H103"
    replace DIAG`diagNumber' = "37210" if DIAG`diagNumber' == "H104"
    replace DIAG`diagNumber' = "37234" if DIAG`diagNumber' == "H108"
    replace DIAG`diagNumber' = "37230" if DIAG`diagNumber' == "H109"
    replace DIAG`diagNumber' = "37240" if DIAG`diagNumber' == "H110"
    replace DIAG`diagNumber' = "37250" if DIAG`diagNumber' == "H111"
    replace DIAG`diagNumber' = "37272" if DIAG`diagNumber' == "H113"
    replace DIAG`diagNumber' = "37900" if DIAG`diagNumber' == "H15-"
    replace DIAG`diagNumber' = "37000" if DIAG`diagNumber' == "H160"
    replace DIAG`diagNumber' = "37020" if DIAG`diagNumber' == "H161"
    replace DIAG`diagNumber' = "37040" if DIAG`diagNumber' == "H162"
    replace DIAG`diagNumber' = "3709" if DIAG`diagNumber' == "H169"
    replace DIAG`diagNumber' = "37104" if DIAG`diagNumber' == "H17-"
    replace DIAG`diagNumber' = "37110" if DIAG`diagNumber' == "H18-"
    replace DIAG`diagNumber' = "37140" if DIAG`diagNumber' == "H184"
    replace DIAG`diagNumber' = "37150" if DIAG`diagNumber' == "H185"
    replace DIAG`diagNumber' = "37160" if DIAG`diagNumber' == "H186"
    replace DIAG`diagNumber' = "36400" if DIAG`diagNumber' == "H200"
    replace DIAG`diagNumber' = "36410" if DIAG`diagNumber' == "H201"
    replace DIAG`diagNumber' = "3643" if DIAG`diagNumber' == "H209"
    replace DIAG`diagNumber' = "36441" if DIAG`diagNumber' == "H21-"
    replace DIAG`diagNumber' = "36615" if DIAG`diagNumber' == "H250"
    replace DIAG`diagNumber' = "36616" if DIAG`diagNumber' == "H251"
    replace DIAG`diagNumber' = "36619" if DIAG`diagNumber' == "H258"
    replace DIAG`diagNumber' = "36610" if DIAG`diagNumber' == "H259"
    replace DIAG`diagNumber' = "36645" if DIAG`diagNumber' == "H26-"
    replace DIAG`diagNumber' = "36650" if DIAG`diagNumber' == "H264"
    replace DIAG`diagNumber' = "3669" if DIAG`diagNumber' == "H269"
    replace DIAG`diagNumber' = "37931" if DIAG`diagNumber' == "H27-"
    replace DIAG`diagNumber' = "36320" if DIAG`diagNumber' == "H309"
    replace DIAG`diagNumber' = "3630" if DIAG`diagNumber' == "H310"
    replace DIAG`diagNumber' = "36100" if DIAG`diagNumber' == "H330"
    replace DIAG`diagNumber' = "3612" if DIAG`diagNumber' == "H332"
    replace DIAG`diagNumber' = "36130" if DIAG`diagNumber' == "H333"
    replace DIAG`diagNumber' = "36181" if DIAG`diagNumber' == "H334"
    replace DIAG`diagNumber' = "36235" if DIAG`diagNumber' == "H348"
    replace DIAG`diagNumber' = "36210" if DIAG`diagNumber' == "H35-"
    replace DIAG`diagNumber' = "36210" if DIAG`diagNumber' == "H350"
    replace DIAG`diagNumber' = "36250" if DIAG`diagNumber' == "H353"
    replace DIAG`diagNumber' = "36240" if DIAG`diagNumber' == "H357"
    replace DIAG`diagNumber' = "36283" if DIAG`diagNumber' == "H358"
    replace DIAG`diagNumber' = "36500" if DIAG`diagNumber' == "H40-"
    replace DIAG`diagNumber' = "36500" if DIAG`diagNumber' == "H400"
    replace DIAG`diagNumber' = "36544" if DIAG`diagNumber' == "H401"
    replace DIAG`diagNumber' = "36544" if DIAG`diagNumber' == "H402"
    replace DIAG`diagNumber' = "3659" if DIAG`diagNumber' == "H409"
    replace DIAG`diagNumber' = "37926" if DIAG`diagNumber' == "H43-"
    replace DIAG`diagNumber' = "37923" if DIAG`diagNumber' == "H431"
    replace DIAG`diagNumber' = "37925" if DIAG`diagNumber' == "H433"
    replace DIAG`diagNumber' = "36000" if DIAG`diagNumber' == "H44-"
    replace DIAG`diagNumber' = "37741" if DIAG`diagNumber' == "H47-"
    replace DIAG`diagNumber' = "37723" if DIAG`diagNumber' == "H473"
    replace DIAG`diagNumber' = "3779" if DIAG`diagNumber' == "H479"
    replace DIAG`diagNumber' = "37800" if DIAG`diagNumber' == "H50-"
    replace DIAG`diagNumber' = "37800" if DIAG`diagNumber' == "H500"
    replace DIAG`diagNumber' = "37820" if DIAG`diagNumber' == "H503"
    replace DIAG`diagNumber' = "37830" if DIAG`diagNumber' == "H504"
    replace DIAG`diagNumber' = "3789" if DIAG`diagNumber' == "H519"
    replace DIAG`diagNumber' = "3670" if DIAG`diagNumber' == "H520"
    replace DIAG`diagNumber' = "3671" if DIAG`diagNumber' == "H521"
    replace DIAG`diagNumber' = "36720" if DIAG`diagNumber' == "H522"
    replace DIAG`diagNumber' = "37631" if DIAG`diagNumber' == "H523"
    replace DIAG`diagNumber' = "3674" if DIAG`diagNumber' == "H524"
    replace DIAG`diagNumber' = "3679" if DIAG`diagNumber' == "H527"
    replace DIAG`diagNumber' = "36800" if DIAG`diagNumber' == "H530"
    replace DIAG`diagNumber' = "36810" if DIAG`diagNumber' == "H531"
    replace DIAG`diagNumber' = "3682" if DIAG`diagNumber' == "H532"
    replace DIAG`diagNumber' = "36840" if DIAG`diagNumber' == "H534"
    replace DIAG`diagNumber' = "3688" if DIAG`diagNumber' == "H538"
    replace DIAG`diagNumber' = "3689" if DIAG`diagNumber' == "H539"
    replace DIAG`diagNumber' = "36900" if DIAG`diagNumber' == "H54-"
    replace DIAG`diagNumber' = "3699" if DIAG`diagNumber' == "H547"
    replace DIAG`diagNumber' = "37950" if DIAG`diagNumber' == "H550"
    replace DIAG`diagNumber' = "37991" if DIAG`diagNumber' == "H571"
    replace DIAG`diagNumber' = "3798" if DIAG`diagNumber' == "H578"
    replace DIAG`diagNumber' = "34940" if DIAG`diagNumber' == "H579"
    replace DIAG`diagNumber' = "99799" if DIAG`diagNumber' == "H59-"
    replace DIAG`diagNumber' = "38010" if DIAG`diagNumber' == "H60-"
    replace DIAG`diagNumber' = "38010" if DIAG`diagNumber' == "H603"
    replace DIAG`diagNumber' = "38022" if DIAG`diagNumber' == "H605"
    replace DIAG`diagNumber' = "38023" if DIAG`diagNumber' == "H606"
    replace DIAG`diagNumber' = "38023" if DIAG`diagNumber' == "H609"
    replace DIAG`diagNumber' = "38081" if DIAG`diagNumber' == "H618"
    replace DIAG`diagNumber' = "38013" if DIAG`diagNumber' == "H62-"
    replace DIAG`diagNumber' = "38102" if DIAG`diagNumber' == "H651"
    replace DIAG`diagNumber' = "38110" if DIAG`diagNumber' == "H652"
    replace DIAG`diagNumber' = "38120" if DIAG`diagNumber' == "H653"
    replace DIAG`diagNumber' = "3814" if DIAG`diagNumber' == "H659"
    replace DIAG`diagNumber' = "38200" if DIAG`diagNumber' == "H660"
    replace DIAG`diagNumber' = "3823" if DIAG`diagNumber' == "H663"
    replace DIAG`diagNumber' = "38150" if DIAG`diagNumber' == "H680"
    replace DIAG`diagNumber' = "38181" if DIAG`diagNumber' == "H698"
    replace DIAG`diagNumber' = "3831" if DIAG`diagNumber' == "H701"
    replace DIAG`diagNumber' = "38421" if DIAG`diagNumber' == "H720"
    replace DIAG`diagNumber' = "38420" if DIAG`diagNumber' == "H729"
    replace DIAG`diagNumber' = "3859" if DIAG`diagNumber' == "H749"
    replace DIAG`diagNumber' = "38600" if DIAG`diagNumber' == "H810"
    replace DIAG`diagNumber' = "38611" if DIAG`diagNumber' == "H811"
    replace DIAG`diagNumber' = "3869" if DIAG`diagNumber' == "H819"
    replace DIAG`diagNumber' = "38630" if DIAG`diagNumber' == "H83-"
    replace DIAG`diagNumber' = "38901" if DIAG`diagNumber' == "H901"
    replace DIAG`diagNumber' = "38900" if DIAG`diagNumber' == "H902"
    replace DIAG`diagNumber' = "38922" if DIAG`diagNumber' == "H906"
    replace DIAG`diagNumber' = "38921" if DIAG`diagNumber' == "H907"
    replace DIAG`diagNumber' = "38801" if DIAG`diagNumber' == "H911"
    replace DIAG`diagNumber' = "3882" if DIAG`diagNumber' == "H912"
    replace DIAG`diagNumber' = "38811" if DIAG`diagNumber' == "H918"
    replace DIAG`diagNumber' = "3899" if DIAG`diagNumber' == "H919"
    replace DIAG`diagNumber' = "38870" if DIAG`diagNumber' == "H920"
    replace DIAG`diagNumber' = "38860" if DIAG`diagNumber' == "H921"
    replace DIAG`diagNumber' = "38830" if DIAG`diagNumber' == "H931"
    replace DIAG`diagNumber' = "3888" if DIAG`diagNumber' == "H938"
    replace DIAG`diagNumber' = "40201" if DIAG`diagNumber' == "I110"
    replace DIAG`diagNumber' = "40200" if DIAG`diagNumber' == "I119"
    replace DIAG`diagNumber' = "4139" if DIAG`diagNumber' == "I209"
    replace DIAG`diagNumber' = "4148" if DIAG`diagNumber' == "I255"
    replace DIAG`diagNumber' = "41512" if DIAG`diagNumber' == "I269"
    replace DIAG`diagNumber' = "4241" if DIAG`diagNumber' == "I359"
    replace DIAG`diagNumber' = "4254" if DIAG`diagNumber' == "I42-"
    replace DIAG`diagNumber' = "4254" if DIAG`diagNumber' == "I429"
    replace DIAG`diagNumber' = "4264" if DIAG`diagNumber' == "I451"
    replace DIAG`diagNumber' = "4269" if DIAG`diagNumber' == "I459"
    replace DIAG`diagNumber' = "4275" if DIAG`diagNumber' == "I46-"
    replace DIAG`diagNumber' = "4270" if DIAG`diagNumber' == "I471"
    replace DIAG`diagNumber' = "42731" if DIAG`diagNumber' == "I48-"
    replace DIAG`diagNumber' = "42731" if DIAG`diagNumber' == "I480"
    replace DIAG`diagNumber' = "42731" if DIAG`diagNumber' == "I481"
    replace DIAG`diagNumber' = "42731" if DIAG`diagNumber' == "I489"
    replace DIAG`diagNumber' = "42769" if DIAG`diagNumber' == "I493"
    replace DIAG`diagNumber' = "4279" if DIAG`diagNumber' == "I499"
    replace DIAG`diagNumber' = "4281" if DIAG`diagNumber' == "I501"
    replace DIAG`diagNumber' = "4280" if DIAG`diagNumber' == "I502"
    replace DIAG`diagNumber' = "4280" if DIAG`diagNumber' == "I503"
    replace DIAG`diagNumber' = "4280" if DIAG`diagNumber' == "I504"
    replace DIAG`diagNumber' = "4280" if DIAG`diagNumber' == "I509"
    replace DIAG`diagNumber' = "4293" if DIAG`diagNumber' == "I517"
    replace DIAG`diagNumber' = "4299" if DIAG`diagNumber' == "I519"
    replace DIAG`diagNumber' = "43391" if DIAG`diagNumber' == "I63-"
    replace DIAG`diagNumber' = "43310" if DIAG`diagNumber' == "I652"
    replace DIAG`diagNumber' = "4379" if DIAG`diagNumber' == "I679"
    replace DIAG`diagNumber' = "4389" if DIAG`diagNumber' == "I693"
    replace DIAG`diagNumber' = "44020" if DIAG`diagNumber' == "I702"
    replace DIAG`diagNumber' = "4414" if DIAG`diagNumber' == "I714"
    replace DIAG`diagNumber' = "17300" if DIAG`diagNumber' == "I73-"
    replace DIAG`diagNumber' = "4479" if DIAG`diagNumber' == "I779"
    replace DIAG`diagNumber' = "4481" if DIAG`diagNumber' == "I781"
    replace DIAG`diagNumber' = "4510" if DIAG`diagNumber' == "I80-"
    replace DIAG`diagNumber' = "45340" if DIAG`diagNumber' == "I824"
    replace DIAG`diagNumber' = "4541" if DIAG`diagNumber' == "I831"
    replace DIAG`diagNumber' = "4548" if DIAG`diagNumber' == "I838"
    replace DIAG`diagNumber' = "4549" if DIAG`diagNumber' == "I839"
    replace DIAG`diagNumber' = "45910" if DIAG`diagNumber' == "I87-"
    replace DIAG`diagNumber' = "45981" if DIAG`diagNumber' == "I872"
    replace DIAG`diagNumber' = "4599" if DIAG`diagNumber' == "I879"
    replace DIAG`diagNumber' = "2893" if DIAG`diagNumber' == "I889"
    replace DIAG`diagNumber' = "4571" if DIAG`diagNumber' == "I890"
    replace DIAG`diagNumber' = "4581" if DIAG`diagNumber' == "I925"
    replace DIAG`diagNumber' = "4589" if DIAG`diagNumber' == "I959"
    replace DIAG`diagNumber' = "45989" if DIAG`diagNumber' == "I99-"
    replace DIAG`diagNumber' = "4610" if DIAG`diagNumber' == "J010"
    replace DIAG`diagNumber' = "4611" if DIAG`diagNumber' == "J011"
    replace DIAG`diagNumber' = "4618" if DIAG`diagNumber' == "J014"
    replace DIAG`diagNumber' = "462" if DIAG`diagNumber' == "J028"
    replace DIAG`diagNumber' = "462" if DIAG`diagNumber' == "J029"
    replace DIAG`diagNumber' = "0340" if DIAG`diagNumber' == "J030"
    replace DIAG`diagNumber' = "463" if DIAG`diagNumber' == "J039"
    replace DIAG`diagNumber' = "46400" if DIAG`diagNumber' == "J040"
    replace DIAG`diagNumber' = "46401" if DIAG`diagNumber' == "J050"
    replace DIAG`diagNumber' = "4870" if DIAG`diagNumber' == "J10-"
    replace DIAG`diagNumber' = "4870" if DIAG`diagNumber' == "J11-"
    replace DIAG`diagNumber' = "4871" if DIAG`diagNumber' == "J111"
    replace DIAG`diagNumber' = "486" if DIAG`diagNumber' == "J189"
    replace DIAG`diagNumber' = "4660" if DIAG`diagNumber' == "J208"
    replace DIAG`diagNumber' = "46619" if DIAG`diagNumber' == "J219"
    replace DIAG`diagNumber' = "5198" if DIAG`diagNumber' == "J22-"
    replace DIAG`diagNumber' = "4779" if DIAG`diagNumber' == "J300"
    replace DIAG`diagNumber' = "4770" if DIAG`diagNumber' == "J301"
    replace DIAG`diagNumber' = "4778" if DIAG`diagNumber' == "J302"
    replace DIAG`diagNumber' = "4720" if DIAG`diagNumber' == "J31-"
    replace DIAG`diagNumber' = "4719" if DIAG`diagNumber' == "J339"
    replace DIAG`diagNumber' = "4811" if DIAG`diagNumber' == "J348"
    replace DIAG`diagNumber' = "47411" if DIAG`diagNumber' == "J351"
    replace DIAG`diagNumber' = "47412" if DIAG`diagNumber' == "J352"
    replace DIAG`diagNumber' = "47410" if DIAG`diagNumber' == "J353"
    replace DIAG`diagNumber' = "4742" if DIAG`diagNumber' == "J358"
    replace DIAG`diagNumber' = "4749" if DIAG`diagNumber' == "J359"
    replace DIAG`diagNumber' = "4760" if DIAG`diagNumber' == "J370"
    replace DIAG`diagNumber' = "4784" if DIAG`diagNumber' == "J381"
    replace DIAG`diagNumber' = "47871" if DIAG`diagNumber' == "J387"
    replace DIAG`diagNumber' = "490" if DIAG`diagNumber' == "J40-"
    replace DIAG`diagNumber' = "49322" if DIAG`diagNumber' == "J441"
    replace DIAG`diagNumber' = "49300" if DIAG`diagNumber' == "J453"
    replace DIAG`diagNumber' = "49300" if DIAG`diagNumber' == "J454"
    replace DIAG`diagNumber' = "4940" if DIAG`diagNumber' == "J479"
    replace DIAG`diagNumber' = "5082" if DIAG`diagNumber' == "J70-"
    replace DIAG`diagNumber' = "53084" if DIAG`diagNumber' == "J86-"
    replace DIAG`diagNumber' = "51911" if DIAG`diagNumber' == "J98-"
    replace DIAG`diagNumber' = "51911" if DIAG`diagNumber' == "J980"
    replace DIAG`diagNumber' = "51889" if DIAG`diagNumber' == "J984"
    replace DIAG`diagNumber' = "5198" if DIAG`diagNumber' == "J988"
    replace DIAG`diagNumber' = "5200" if DIAG`diagNumber' == "K00-"
    replace DIAG`diagNumber' = "5207" if DIAG`diagNumber' == "K007"
    replace DIAG`diagNumber' = "52100" if DIAG`diagNumber' == "K029"
    replace DIAG`diagNumber' = "5229" if DIAG`diagNumber' == "K049"
    replace DIAG`diagNumber' = "5239" if DIAG`diagNumber' == "K056"
    replace DIAG`diagNumber' = "5258" if DIAG`diagNumber' == "K088"
    replace DIAG`diagNumber' = "5284" if DIAG`diagNumber' == "K099"
    replace DIAG`diagNumber' = "5270" if DIAG`diagNumber' == "K11-"
    replace DIAG`diagNumber' = "5272" if DIAG`diagNumber' == "K112"
    replace DIAG`diagNumber' = "5282" if DIAG`diagNumber' == "K12-"
    replace DIAG`diagNumber' = "5285" if DIAG`diagNumber' == "K13-"
    replace DIAG`diagNumber' = "5289" if DIAG`diagNumber' == "K137"
    replace DIAG`diagNumber' = "5290" if DIAG`diagNumber' == "K14-"
    replace DIAG`diagNumber' = "53011" if DIAG`diagNumber' == "K210"
    replace DIAG`diagNumber' = "5300" if DIAG`diagNumber' == "K22-"
    replace DIAG`diagNumber' = "53500" if DIAG`diagNumber' == "K29-"
    replace DIAG`diagNumber' = "5369" if DIAG`diagNumber' == "K319"
    replace DIAG`diagNumber' = "5400" if DIAG`diagNumber' == "K35-"
    replace DIAG`diagNumber' = "5439" if DIAG`diagNumber' == "K389"
    replace DIAG`diagNumber' = "55012" if DIAG`diagNumber' == "K40-"
    replace DIAG`diagNumber' = "55092" if DIAG`diagNumber' == "K402"
    replace DIAG`diagNumber' = "5521" if DIAG`diagNumber' == "K42-"
    replace DIAG`diagNumber' = "55329" if DIAG`diagNumber' == "K469"
    replace DIAG`diagNumber' = "5559" if DIAG`diagNumber' == "K509"
    replace DIAG`diagNumber' = "5566" if DIAG`diagNumber' == "K51-"
    replace DIAG`diagNumber' = "5589" if DIAG`diagNumber' == "K529"
    replace DIAG`diagNumber' = "5579" if DIAG`diagNumber' == "K559"
    replace DIAG`diagNumber' = "5601" if DIAG`diagNumber' == "K56-"
    replace DIAG`diagNumber' = "56201" if DIAG`diagNumber' == "K57-"
    replace DIAG`diagNumber' = "56210" if DIAG`diagNumber' == "K573"
    replace DIAG`diagNumber' = "56210" if DIAG`diagNumber' == "K579"
    replace DIAG`diagNumber' = "5641" if DIAG`diagNumber' == "K589"
    replace DIAG`diagNumber' = "5650" if DIAG`diagNumber' == "K60-"
    replace DIAG`diagNumber' = "566" if DIAG`diagNumber' == "K61-"
    replace DIAG`diagNumber' = "5693" if DIAG`diagNumber' == "K625"
    replace DIAG`diagNumber' = "56943" if DIAG`diagNumber' == "K628"
    replace DIAG`diagNumber' = "5695" if DIAG`diagNumber' == "K63-"
    replace DIAG`diagNumber' = "2113" if DIAG`diagNumber' == "K635"
    replace DIAG`diagNumber' = "4550" if DIAG`diagNumber' == "K64-"
    replace DIAG`diagNumber' = "4553" if DIAG`diagNumber' == "K644"
    replace DIAG`diagNumber' = "4550" if DIAG`diagNumber' == "K648"
    replace DIAG`diagNumber' = "4556" if DIAG`diagNumber' == "K649"
    replace DIAG`diagNumber' = "5728" if DIAG`diagNumber' == "K729"
    replace DIAG`diagNumber' = "5718" if DIAG`diagNumber' == "K76-"
    replace DIAG`diagNumber' = "57400" if DIAG`diagNumber' == "K80-"
    replace DIAG`diagNumber' = "57410" if DIAG`diagNumber' == "K801"
    replace DIAG`diagNumber' = "57420" if DIAG`diagNumber' == "K802"
    replace DIAG`diagNumber' = "5750" if DIAG`diagNumber' == "K81-"
    replace DIAG`diagNumber' = "5758" if DIAG`diagNumber' == "K828"
    replace DIAG`diagNumber' = "5759" if DIAG`diagNumber' == "K829"
    replace DIAG`diagNumber' = "5770" if DIAG`diagNumber' == "K85-"
    replace DIAG`diagNumber' = "5780" if DIAG`diagNumber' == "K92-"
    replace DIAG`diagNumber' = "5781" if DIAG`diagNumber' == "K921"
    replace DIAG`diagNumber' = "684" if DIAG`diagNumber' == "L010"
    replace DIAG`diagNumber' = "6823" if DIAG`diagNumber' == "L024"
    replace DIAG`diagNumber' = "6829" if DIAG`diagNumber' == "L029"
    replace DIAG`diagNumber' = "68102" if DIAG`diagNumber' == "L03-"
    replace DIAG`diagNumber' = "6829" if DIAG`diagNumber' == "L039"
    replace DIAG`diagNumber' = "6850" if DIAG`diagNumber' == "L05-"
    replace DIAG`diagNumber' = "6494" if DIAG`diagNumber' == "L139"
    replace DIAG`diagNumber' = "6918" if DIAG`diagNumber' == "L208"
    replace DIAG`diagNumber' = "6918" if DIAG`diagNumber' == "L209"
    replace DIAG`diagNumber' = "69011" if DIAG`diagNumber' == "L210"
    replace DIAG`diagNumber' = "69018" if DIAG`diagNumber' == "L218"
    replace DIAG`diagNumber' = "7063" if DIAG`diagNumber' == "L219"
    replace DIAG`diagNumber' = "6910" if DIAG`diagNumber' == "L22-"
    replace DIAG`diagNumber' = "6939" if DIAG`diagNumber' == "L279"
    replace DIAG`diagNumber' = "6929" if DIAG`diagNumber' == "L239"
    replace DIAG`diagNumber' = "6929" if DIAG`diagNumber' == "L249"
    replace DIAG`diagNumber' = "6929" if DIAG`diagNumber' == "L259"
    replace DIAG`diagNumber' = "6983" if DIAG`diagNumber' == "L281"
    replace DIAG`diagNumber' = "6988" if DIAG`diagNumber' == "L298"
    replace DIAG`diagNumber' = "6989" if DIAG`diagNumber' == "L299"
    replace DIAG`diagNumber' = "69589" if DIAG`diagNumber' == "L304"
    replace DIAG`diagNumber' = "6965" if DIAG`diagNumber' == "L305"
    replace DIAG`diagNumber' = "6929" if DIAG`diagNumber' == "L308"
    replace DIAG`diagNumber' = "6929" if DIAG`diagNumber' == "L309"
    replace DIAG`diagNumber' = "6961" if DIAG`diagNumber' == "L40-"
    replace DIAG`diagNumber' = "6961" if DIAG`diagNumber' == "L400"
    replace DIAG`diagNumber' = "6960" if DIAG`diagNumber' == "L405"
    replace DIAG`diagNumber' = "6961" if DIAG`diagNumber' == "L409"
    replace DIAG`diagNumber' = "6963" if DIAG`diagNumber' == "L42-"
    replace DIAG`diagNumber' = "6970" if DIAG`diagNumber' == "L439"
    replace DIAG`diagNumber' = "7080" if DIAG`diagNumber' == "L50-"
    replace DIAG`diagNumber' = "7080" if DIAG`diagNumber' == "L500"
    replace DIAG`diagNumber' = "7089" if DIAG`diagNumber' == "L509"
    replace DIAG`diagNumber' = "6950" if DIAG`diagNumber' == "L532"
    replace DIAG`diagNumber' = "6959" if DIAG`diagNumber' == "L539"
    replace DIAG`diagNumber' = "69272" if DIAG`diagNumber' == "L56-"
    replace DIAG`diagNumber' = "69272" if DIAG`diagNumber' == "L568"
    replace DIAG`diagNumber' = "7020" if DIAG`diagNumber' == "L570"
    replace DIAG`diagNumber' = "69270" if DIAG`diagNumber' == "L578"
    replace DIAG`diagNumber' = "7030" if DIAG`diagNumber' == "L60-"
    replace DIAG`diagNumber' = "70401" if DIAG`diagNumber' == "L639"
    replace DIAG`diagNumber' = "70409" if DIAG`diagNumber' == "L64-"
    replace DIAG`diagNumber' = "70400" if DIAG`diagNumber' == "L659"
    replace DIAG`diagNumber' = "70409" if DIAG`diagNumber' == "L669"
    replace DIAG`diagNumber' = "7041" if DIAG`diagNumber' == "L680"
    replace DIAG`diagNumber' = "7061" if DIAG`diagNumber' == "L708"
    replace DIAG`diagNumber' = "6962" if DIAG`diagNumber' == "L410"
    replace DIAG`diagNumber' = "6953" if DIAG`diagNumber' == "L718"
    replace DIAG`diagNumber' = "6953" if DIAG`diagNumber' == "L719"
    replace DIAG`diagNumber' = "7062" if DIAG`diagNumber' == "L720"
    replace DIAG`diagNumber' = "7062" if DIAG`diagNumber' == "L723"
    replace DIAG`diagNumber' = "7062" if DIAG`diagNumber' == "L729"
    replace DIAG`diagNumber' = "7051" if DIAG`diagNumber' == "L74-"
    replace DIAG`diagNumber' = "99811" if DIAG`diagNumber' == "L76-"
    replace DIAG`diagNumber' = "70901" if DIAG`diagNumber' == "L80-"
    replace DIAG`diagNumber' = "70909" if DIAG`diagNumber' == "L81-"
    replace DIAG`diagNumber' = "70909" if DIAG`diagNumber' == "L811"
    replace DIAG`diagNumber' = "70909" if DIAG`diagNumber' == "L814"
    replace DIAG`diagNumber' = "70909" if DIAG`diagNumber' == "L818"
    replace DIAG`diagNumber' = "70900" if DIAG`diagNumber' == "L819"
    replace DIAG`diagNumber' = "70211" if DIAG`diagNumber' == "L820"
    replace DIAG`diagNumber' = "70219" if DIAG`diagNumber' == "L821"
    replace DIAG`diagNumber' = "700" if DIAG`diagNumber' == "L84-"
    replace DIAG`diagNumber' = "7068" if DIAG`diagNumber' == "L853"
    replace DIAG`diagNumber' = "7018" if DIAG`diagNumber' == "L858"
    replace DIAG`diagNumber' = "7010" if DIAG`diagNumber' == "L900"
    replace DIAG`diagNumber' = "7019" if DIAG`diagNumber' == "L909"
    replace DIAG`diagNumber' = "7014" if DIAG`diagNumber' == "L910"
    replace DIAG`diagNumber' = "7018" if DIAG`diagNumber' == "L918"
    replace DIAG`diagNumber' = "7078" if DIAG`diagNumber' == "L984"
    replace DIAG`diagNumber' = "7098" if DIAG`diagNumber' == "L988"
    replace DIAG`diagNumber' = "7018" if DIAG`diagNumber' == "L99-"
    replace DIAG`diagNumber' = "7141" if DIAG`diagNumber' == "M05-"
    replace DIAG`diagNumber' = "7142" if DIAG`diagNumber' == "M056"
    replace DIAG`diagNumber' = "7140" if DIAG`diagNumber' == "M057"
    replace DIAG`diagNumber' = "7140" if DIAG`diagNumber' == "M060"
    replace DIAG`diagNumber' = "7140" if DIAG`diagNumber' == "M069"
    replace DIAG`diagNumber' = "24700" if DIAG`diagNumber' == "M100"
    replace DIAG`diagNumber' = "2749" if DIAG`diagNumber' == "M109"
    replace DIAG`diagNumber' = "71650" if DIAG`diagNumber' == "M130"
    replace DIAG`diagNumber' = "71509" if DIAG`diagNumber' == "M15-"
    replace DIAG`diagNumber' = "71509" if DIAG`diagNumber' == "M150"
    replace DIAG`diagNumber' = "71515" if DIAG`diagNumber' == "M160"
    replace DIAG`diagNumber' = "71515" if DIAG`diagNumber' == "M161"
    replace DIAG`diagNumber' = "71516" if DIAG`diagNumber' == "M170"
    replace DIAG`diagNumber' = "71516" if DIAG`diagNumber' == "M171"
    replace DIAG`diagNumber' = "71526" if DIAG`diagNumber' == "M173"
    replace DIAG`diagNumber' = "71536" if DIAG`diagNumber' == "M179"
    replace DIAG`diagNumber' = "71514" if DIAG`diagNumber' == "M181"
    replace DIAG`diagNumber' = "71511" if DIAG`diagNumber' == "M190"
    replace DIAG`diagNumber' = "7138" if DIAG`diagNumber' == "M1A-"
    replace DIAG`diagNumber' = "73620" if DIAG`diagNumber' == "M20-"
    replace DIAG`diagNumber' = "7369" if DIAG`diagNumber' == "M21-"
    replace DIAG`diagNumber' = "734" if DIAG`diagNumber' == "M214"
    replace DIAG`diagNumber' = "71789" if DIAG`diagNumber' == "M222"
    replace DIAG`diagNumber' = "7177" if DIAG`diagNumber' == "M224"
    replace DIAG`diagNumber' = "7179" if DIAG`diagNumber' == "M229"
    replace DIAG`diagNumber' = "7175" if DIAG`diagNumber' == "M23-"
    replace DIAG`diagNumber' = "71740" if DIAG`diagNumber' == "M232"
    replace DIAG`diagNumber' = "7179" if DIAG`diagNumber' == "M239"
    replace DIAG`diagNumber' = "71810" if DIAG`diagNumber' == "M24-"
    replace DIAG`diagNumber' = "71900" if DIAG`diagNumber' == "M254"
    replace DIAG`diagNumber' = "71980" if DIAG`diagNumber' == "M258"
    replace DIAG`diagNumber' = "71990" if DIAG`diagNumber' == "M259"
    replace DIAG`diagNumber' = "52460" if DIAG`diagNumber' == "M266"
    replace DIAG`diagNumber' = "7103" if DIAG`diagNumber' == "M33-"
    replace DIAG`diagNumber' = "7101" if DIAG`diagNumber' == "M34-"
    replace DIAG`diagNumber' = "7102" if DIAG`diagNumber' == "M350"
    replace DIAG`diagNumber' = "725" if DIAG`diagNumber' == "M353"
    replace DIAG`diagNumber' = "7109" if DIAG`diagNumber' == "M359"
    replace DIAG`diagNumber' = "73739" if DIAG`diagNumber' == "M419"
    replace DIAG`diagNumber' = "7384" if DIAG`diagNumber' == "M430"
    replace DIAG`diagNumber' = "7201" if DIAG`diagNumber' == "M46-"
    replace DIAG`diagNumber' = "72191" if DIAG`diagNumber' == "M471"
    replace DIAG`diagNumber' = "72190" if DIAG`diagNumber' == "M472"
    replace DIAG`diagNumber' = "7210" if DIAG`diagNumber' == "M478"
    replace DIAG`diagNumber' = "72190" if DIAG`diagNumber' == "M479"
    replace DIAG`diagNumber' = "72271" if DIAG`diagNumber' == "M50-"
    replace DIAG`diagNumber' = "7224" if DIAG`diagNumber' == "M503"
    replace DIAG`diagNumber' = "72291" if DIAG`diagNumber' == "M509"
    replace DIAG`diagNumber' = "72211" if DIAG`diagNumber' == "M512"
    replace DIAG`diagNumber' = "72251" if DIAG`diagNumber' == "M513"
    replace DIAG`diagNumber' = "72290" if DIAG`diagNumber' == "M519"
    replace DIAG`diagNumber' = "7232" if DIAG`diagNumber' == "M53-"
    replace DIAG`diagNumber' = "7246" if DIAG`diagNumber' == "M533"
    replace DIAG`diagNumber' = "7292" if DIAG`diagNumber' == "M541"
    replace DIAG`diagNumber' = "7231" if DIAG`diagNumber' == "M542"
    replace DIAG`diagNumber' = "7243" if DIAG`diagNumber' == "M543"
    replace DIAG`diagNumber' = "7243" if DIAG`diagNumber' == "M544"
    replace DIAG`diagNumber' = "7241" if DIAG`diagNumber' == "M546"
    replace DIAG`diagNumber' = "7245" if DIAG`diagNumber' == "M549"
    replace DIAG`diagNumber' = "7280" if DIAG`diagNumber' == "M60-"
    replace DIAG`diagNumber' = "72884" if DIAG`diagNumber' == "M62-"
    replace DIAG`diagNumber' = "72885" if DIAG`diagNumber' == "M624"
    replace DIAG`diagNumber' = "72887" if DIAG`diagNumber' == "M628"
    replace DIAG`diagNumber' = "72789" if DIAG`diagNumber' == "M65"
    replace DIAG`diagNumber' = "72709" if DIAG`diagNumber' == "M656"
    replace DIAG`diagNumber' = "72704" if DIAG`diagNumber' == "M654"
    replace DIAG`diagNumber' = "72700" if DIAG`diagNumber' == "M659"
    replace DIAG`diagNumber' = "72743" if DIAG`diagNumber' == "M67-"
    replace DIAG`diagNumber' = "72743" if DIAG`diagNumber' == "M674"
    replace DIAG`diagNumber' = "7272" if DIAG`diagNumber' == "M70-"
    replace DIAG`diagNumber' = "7265" if DIAG`diagNumber' == "M706"
    replace DIAG`diagNumber' = "72789" if DIAG`diagNumber' == "M71-"
    replace DIAG`diagNumber' = "72871" if DIAG`diagNumber' == "M722"
    replace DIAG`diagNumber' = "7260" if DIAG`diagNumber' == "M75-"
    replace DIAG`diagNumber' = "7260" if DIAG`diagNumber' == "M750"
    replace DIAG`diagNumber' = "72610" if DIAG`diagNumber' == "M751"
    replace DIAG`diagNumber' = "72612" if DIAG`diagNumber' == "M752"
    replace DIAG`diagNumber' = "7262" if DIAG`diagNumber' == "M754"
    replace DIAG`diagNumber' = "72610" if DIAG`diagNumber' == "M755"
    replace DIAG`diagNumber' = "7265" if DIAG`diagNumber' == "M76-"
    replace DIAG`diagNumber' = "72671" if DIAG`diagNumber' == "M766"
    replace DIAG`diagNumber' = "72631" if DIAG`diagNumber' == "M770"
    replace DIAG`diagNumber' = "72632" if DIAG`diagNumber' == "M771"
    replace DIAG`diagNumber' = "72670" if DIAG`diagNumber' == "M774"
    replace DIAG`diagNumber' = "7291" if DIAG`diagNumber' == "M791"
    replace DIAG`diagNumber' = "7295" if DIAG`diagNumber' == "M796"
    replace DIAG`diagNumber' = "72992" if DIAG`diagNumber' == "M798"
    replace DIAG`diagNumber' = "2682" if DIAG`diagNumber' == "M84-"
    replace DIAG`diagNumber' = "73399" if DIAG`diagNumber' == "M858"
    replace DIAG`diagNumber' = "73340" if DIAG`diagNumber' == "M870"
    replace DIAG`diagNumber' = "73340" if DIAG`diagNumber' == "M879"
    replace DIAG`diagNumber' = "7337" if DIAG`diagNumber' == "M89-"
    replace DIAG`diagNumber' = "73399" if DIAG`diagNumber' == "M898"
    replace DIAG`diagNumber' = "7336" if DIAG`diagNumber' == "M94-"
    replace DIAG`diagNumber' = "73390" if DIAG`diagNumber' == "M949"
    replace DIAG`diagNumber' = "99649" if DIAG`diagNumber' == "M96-"
    replace DIAG`diagNumber' = "7390" if DIAG`diagNumber' == "M990"
    replace DIAG`diagNumber' = "58389" if DIAG`diagNumber' == "N05-"
    replace DIAG`diagNumber' = "591" if DIAG`diagNumber' == "N132"
    replace DIAG`diagNumber' = "591" if DIAG`diagNumber' == "N133"
    replace DIAG`diagNumber' = "5929" if DIAG`diagNumber' == "N139"
    replace DIAG`diagNumber' = "5852" if DIAG`diagNumber' == "N182"
    replace DIAG`diagNumber' = "5853" if DIAG`diagNumber' == "N183"
    replace DIAG`diagNumber' = "5856" if DIAG`diagNumber' == "N186"
    replace DIAG`diagNumber' = "586" if DIAG`diagNumber' == "N19-"
    replace DIAG`diagNumber' = "5921" if DIAG`diagNumber' == "N201"
    replace DIAG`diagNumber' = "5949" if DIAG`diagNumber' == "N219"
    replace DIAG`diagNumber' = "587" if DIAG`diagNumber' == "N26-"
    replace DIAG`diagNumber' = "5932" if DIAG`diagNumber' == "N281"
    replace DIAG`diagNumber' = "5931" if DIAG`diagNumber' == "N288"
    replace DIAG`diagNumber' = "5952" if DIAG`diagNumber' == "N302"
    replace DIAG`diagNumber' = "59589" if DIAG`diagNumber' == "N308"
    replace DIAG`diagNumber' = "59651" if DIAG`diagNumber' == "N328"
    replace DIAG`diagNumber' = "09940" if DIAG`diagNumber' == "N341"
    replace DIAG`diagNumber' = "78831" if DIAG`diagNumber' == "N394"
    replace DIAG`diagNumber' = "60010" if DIAG`diagNumber' == "N402"
    replace DIAG`diagNumber' = "6019" if DIAG`diagNumber' == "N419"
    replace DIAG`diagNumber' = "6081" if DIAG`diagNumber' == "N434"
    replace DIAG`diagNumber' = "60820" if DIAG`diagNumber' == "N44-"
    replace DIAG`diagNumber' = "605" if DIAG`diagNumber' == "N47-"
    replace DIAG`diagNumber' = "605" if DIAG`diagNumber' == "N471"
    replace DIAG`diagNumber' = "6070" if DIAG`diagNumber' == "N48-"
    replace DIAG`diagNumber' = "60785" if DIAG`diagNumber' == "N486"
    replace DIAG`diagNumber' = "6084" if DIAG`diagNumber' == "N499"
    replace DIAG`diagNumber' = "6083" if DIAG`diagNumber' == "N50-"
    replace DIAG`diagNumber' = "60884" if DIAG`diagNumber' == "N508"
    replace DIAG`diagNumber' = "6100" if DIAG`diagNumber' == "N60-"
    replace DIAG`diagNumber' = "6101" if DIAG`diagNumber' == "N601"
    replace DIAG`diagNumber' = "6109" if DIAG`diagNumber' == "N609"
    replace DIAG`diagNumber' = "6110" if DIAG`diagNumber' == "N61-"
    replace DIAG`diagNumber' = "61171" if DIAG`diagNumber' == "N644"
    replace DIAG`diagNumber' = "61179" if DIAG`diagNumber' == "N645"
    replace DIAG`diagNumber' = "61181" if DIAG`diagNumber' == "N648"
    replace DIAG`diagNumber' = "61610" if DIAG`diagNumber' == "N76-"
    replace DIAG`diagNumber' = "61610" if DIAG`diagNumber' == "N760"
    replace DIAG`diagNumber' = "61803" if DIAG`diagNumber' == "N81-"
    replace DIAG`diagNumber' = "61801" if DIAG`diagNumber' == "N811"
    replace DIAG`diagNumber' = "6202" if DIAG`diagNumber' == "N832"
    replace DIAG`diagNumber' = "6209" if DIAG`diagNumber' == "N839"
    replace DIAG`diagNumber' = "6210" if DIAG`diagNumber' == "N84-"
    replace DIAG`diagNumber' = "62130" if DIAG`diagNumber' == "N85-"
    replace DIAG`diagNumber' = "6218" if DIAG`diagNumber' == "N858"
    replace DIAG`diagNumber' = "62211" if DIAG`diagNumber' == "N87-"
    replace DIAG`diagNumber' = "6234" if DIAG`diagNumber' == "N898"
    replace DIAG`diagNumber' = "6239" if DIAG`diagNumber' == "N899"
    replace DIAG`diagNumber' = "62401" if DIAG`diagNumber' == "N90-"
    replace DIAG`diagNumber' = "62920" if DIAG`diagNumber' == "N908"
    replace DIAG`diagNumber' = "6260" if DIAG`diagNumber' == "N91-"
    replace DIAG`diagNumber' = "6260" if DIAG`diagNumber' == "N912"
    replace DIAG`diagNumber' = "6261" if DIAG`diagNumber' == "N915"
    replace DIAG`diagNumber' = "6262" if DIAG`diagNumber' == "N92-"
    replace DIAG`diagNumber' = "6262" if DIAG`diagNumber' == "N920"
    replace DIAG`diagNumber' = "6266" if DIAG`diagNumber' == "N921"
    replace DIAG`diagNumber' = "6269" if DIAG`diagNumber' == "N926"
    replace DIAG`diagNumber' = "6269" if DIAG`diagNumber' == "N939"
    replace DIAG`diagNumber' = "6252" if DIAG`diagNumber' == "N94-"
    replace DIAG`diagNumber' = "6250" if DIAG`diagNumber' == "N941"
    replace DIAG`diagNumber' = "6254" if DIAG`diagNumber' == "N943"
    replace DIAG`diagNumber' = "6271" if DIAG`diagNumber' == "N950"
    replace DIAG`diagNumber' = "6272" if DIAG`diagNumber' == "N951"
    replace DIAG`diagNumber' = "6273" if DIAG`diagNumber' == "N952"
    replace DIAG`diagNumber' = "6279" if DIAG`diagNumber' == "N959"
    replace DIAG`diagNumber' = "6280" if DIAG`diagNumber' == "N97-"
    replace DIAG`diagNumber' = "6289" if DIAG`diagNumber' == "N979"
    replace DIAG`diagNumber' = "9975" if DIAG`diagNumber' == "N99-"
    replace DIAG`diagNumber' = "63390" if DIAG`diagNumber' == "O009"
    replace DIAG`diagNumber' = "6318" if DIAG`diagNumber' == "O029"
    replace DIAG`diagNumber' = "63492" if DIAG`diagNumber' == "O039"
    replace DIAG`diagNumber' = "V230" if DIAG`diagNumber' == "O09-"
    replace DIAG`diagNumber' = "V2341" if DIAG`diagNumber' == "O092"
    replace DIAG`diagNumber' = "V237" if DIAG`diagNumber' == "O093"
    replace DIAG`diagNumber' = "65951" if DIAG`diagNumber' == "O095"
    replace DIAG`diagNumber' = "V2385" if DIAG`diagNumber' == "O098"
    replace DIAG`diagNumber' = "V239" if DIAG`diagNumber' == "O099"
    replace DIAG`diagNumber' = "64201" if DIAG`diagNumber' == "O100"
    replace DIAG`diagNumber' = "64221" if DIAG`diagNumber' == "O11-"
    replace DIAG`diagNumber' = "64231" if DIAG`diagNumber' == "O13-"
    replace DIAG`diagNumber' = "64240" if DIAG`diagNumber' == "O14-"
    replace DIAG`diagNumber' = "64003" if DIAG`diagNumber' == "O20-"
    replace DIAG`diagNumber' = "64660" if DIAG`diagNumber' == "O234"
    replace DIAG`diagNumber' = "64660" if DIAG`diagNumber' == "O239"
    replace DIAG`diagNumber' = "64881" if DIAG`diagNumber' == "O24-"
    replace DIAG`diagNumber' = "64881" if DIAG`diagNumber' == "O244"
    replace DIAG`diagNumber' = "64630" if DIAG`diagNumber' == "O262"
    replace DIAG`diagNumber' = "64681" if DIAG`diagNumber' == "O268"
    replace DIAG`diagNumber' = "7965" if DIAG`diagNumber' == "O289"
    replace DIAG`diagNumber' = "65190" if DIAG`diagNumber' == "O309"
    replace DIAG`diagNumber' = "65400" if DIAG`diagNumber' == "O34-"
    replace DIAG`diagNumber' = "65421" if DIAG`diagNumber' == "O342"
    replace DIAG`diagNumber' = "65491" if DIAG`diagNumber' == "O35-"
    //replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "O358"
    //replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "O360"
    //replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "O365"
    //replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "O366"
    //replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "O368"
    //replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "O40-"
    //replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "O60-"
    replace DIAG`diagNumber' = "66602" if DIAG`diagNumber' == "O72-"
    replace DIAG`diagNumber' = "650" if DIAG`diagNumber' == "O80-"
    replace DIAG`diagNumber' = "67412" if DIAG`diagNumber' == "O90-"
    replace DIAG`diagNumber' = "67501" if DIAG`diagNumber' == "O91-"
    replace DIAG`diagNumber' = "64731" if DIAG`diagNumber' == "O98-"
    replace DIAG`diagNumber' = "64821" if DIAG`diagNumber' == "O99-"
    replace DIAG`diagNumber' = "64821" if DIAG`diagNumber' == "O990"
    replace DIAG`diagNumber' = "64910" if DIAG`diagNumber' == "O992"
    replace DIAG`diagNumber' = "64840" if DIAG`diagNumber' == "O993"
    replace DIAG`diagNumber' = "64891" if DIAG`diagNumber' == "O995"
    replace DIAG`diagNumber' = "64881" if DIAG`diagNumber' == "O998"
    replace DIAG`diagNumber' = "76400" if DIAG`diagNumber' == "P05-"
    replace DIAG`diagNumber' = "76500" if DIAG`diagNumber' == "P07-"
    replace DIAG`diagNumber' = "7746" if DIAG`diagNumber' == "P599"
    replace DIAG`diagNumber' = "7789" if DIAG`diagNumber' == "P839"
    replace DIAG`diagNumber' = "77931" if DIAG`diagNumber' == "P929"
    replace DIAG`diagNumber' = "74330" if DIAG`diagNumber' == "Q120"
    replace DIAG`diagNumber' = "7439" if DIAG`diagNumber' == "Q159"
    replace DIAG`diagNumber' = "Q189" if DIAG`diagNumber' == "Q189"
    replace DIAG`diagNumber' = "7455" if DIAG`diagNumber' == "Q211"
    replace DIAG`diagNumber' = "7459" if DIAG`diagNumber' == "Q219"
    replace DIAG`diagNumber' = "7470" if DIAG`diagNumber' == "Q250"
    replace DIAG`diagNumber' = "7509" if DIAG`diagNumber' == "Q409"
    replace DIAG`diagNumber' = "75239" if DIAG`diagNumber' == "Q519"
    replace DIAG`diagNumber' = "7529" if DIAG`diagNumber' == "Q559"
    replace DIAG`diagNumber' = "7539" if DIAG`diagNumber' == "Q649"
    replace DIAG`diagNumber' = "75430" if DIAG`diagNumber' == "Q65-"
    replace DIAG`diagNumber' = "75451" if DIAG`diagNumber' == "Q66-"
    replace DIAG`diagNumber' = "7569" if DIAG`diagNumber' == "Q799"
    replace DIAG`diagNumber' = "75739" if DIAG`diagNumber' == "Q829"
    replace DIAG`diagNumber' = "23770" if DIAG`diagNumber' == "Q85-"
    replace DIAG`diagNumber' = "7590" if DIAG`diagNumber' == "Q89-"
    replace DIAG`diagNumber' = "7580" if DIAG`diagNumber' == "Q909"
    replace DIAG`diagNumber' = "7589" if DIAG`diagNumber' == "Q999"
    replace DIAG`diagNumber' = "42781" if DIAG`diagNumber' == "R001"
    replace DIAG`diagNumber' = "7851" if DIAG`diagNumber' == "R002"
    replace DIAG`diagNumber' = "7852" if DIAG`diagNumber' == "R011"
    replace DIAG`diagNumber' = "7962" if DIAG`diagNumber' == "R030"
    replace DIAG`diagNumber' = "78630" if DIAG`diagNumber' == "R042"
    replace DIAG`diagNumber' = "7868" if DIAG`diagNumber' == "R066"
    replace DIAG`diagNumber' = "78651" if DIAG`diagNumber' == "R072"
    replace DIAG`diagNumber' = "78652" if DIAG`diagNumber' == "R078"
    replace DIAG`diagNumber' = "78650" if DIAG`diagNumber' == "R079"
    replace DIAG`diagNumber' = "5110" if DIAG`diagNumber' == "R091"
    replace DIAG`diagNumber' = "47819" if DIAG`diagNumber' == "R098"
    replace DIAG`diagNumber' = "78909" if DIAG`diagNumber' == "R101"
    replace DIAG`diagNumber' = "78909" if DIAG`diagNumber' == "R103"
    replace DIAG`diagNumber' = "5362" if DIAG`diagNumber' == "R111"
    replace DIAG`diagNumber' = "78701" if DIAG`diagNumber' == "R112"
    replace DIAG`diagNumber' = "78720" if DIAG`diagNumber' == "R131"
    replace DIAG`diagNumber' = "7873" if DIAG`diagNumber' == "R140"
    replace DIAG`diagNumber' = "78760" if DIAG`diagNumber' == "R159"
    replace DIAG`diagNumber' = "78930" if DIAG`diagNumber' == "R190"
    replace DIAG`diagNumber' = "78791" if DIAG`diagNumber' == "R197"
    replace DIAG`diagNumber' = "7820" if DIAG`diagNumber' == "R200"
    replace DIAG`diagNumber' = "7820" if DIAG`diagNumber' == "R202"
    replace DIAG`diagNumber' = "7820" if DIAG`diagNumber' == "R209"
    replace DIAG`diagNumber' = "7821" if DIAG`diagNumber' == "R21-"
    replace DIAG`diagNumber' = "7842" if DIAG`diagNumber' == "R220"
    replace DIAG`diagNumber' = "7822" if DIAG`diagNumber' == "R221"
    replace DIAG`diagNumber' = "7866" if DIAG`diagNumber' == "R222"
    replace DIAG`diagNumber' = "7822" if DIAG`diagNumber' == "R223"
    replace DIAG`diagNumber' = "7822" if DIAG`diagNumber' == "R224"
    replace DIAG`diagNumber' = "7822" if DIAG`diagNumber' == "R229"
    replace DIAG`diagNumber' = "7828" if DIAG`diagNumber' == "R234"
    replace DIAG`diagNumber' = "7829" if DIAG`diagNumber' == "R238"
    replace DIAG`diagNumber' = "7829" if DIAG`diagNumber' == "R239"
    replace DIAG`diagNumber' = "7810" if DIAG`diagNumber' == "R251"
    replace DIAG`diagNumber' = "7810" if DIAG`diagNumber' == "R258"
    replace DIAG`diagNumber' = "7812" if DIAG`diagNumber' == "R260"
    replace DIAG`diagNumber' = "7197" if DIAG`diagNumber' == "R262"
    replace DIAG`diagNumber' = "7891" if DIAG`diagNumber' == "R169"
    replace DIAG`diagNumber' = "7813" if DIAG`diagNumber' == "R278"
    replace DIAG`diagNumber' = "78199" if DIAG`diagNumber' == "R296"
    replace DIAG`diagNumber' = "78194" if DIAG`diagNumber' == "R298"
    replace DIAG`diagNumber' = "78830" if DIAG`diagNumber' == "R32-"
    replace DIAG`diagNumber' = "78842" if DIAG`diagNumber' == "R358"
    replace DIAG`diagNumber' = "60882" if DIAG`diagNumber' == "R361"
    replace DIAG`diagNumber' = "78891" if DIAG`diagNumber' == "R398"
    replace DIAG`diagNumber' = "78002" if DIAG`diagNumber' == "R404"
    replace DIAG`diagNumber' = "78097" if DIAG`diagNumber' == "R410"
    replace DIAG`diagNumber' = "78093" if DIAG`diagNumber' == "R413"
    replace DIAG`diagNumber' = "797" if DIAG`diagNumber' == "R418"
    replace DIAG`diagNumber' = "7804" if DIAG`diagNumber' == "R42-"
    replace DIAG`diagNumber' = "7811" if DIAG`diagNumber' == "R438"
    replace DIAG`diagNumber' = "3079" if DIAG`diagNumber' == "R458"
    replace DIAG`diagNumber' = "7843" if DIAG`diagNumber' == "R470"
    replace DIAG`diagNumber' = "78451" if DIAG`diagNumber' == "R471"
    replace DIAG`diagNumber' = "78469" if DIAG`diagNumber' == "R482"
    replace DIAG`diagNumber' = "78442" if DIAG`diagNumber' == "R490"
    replace DIAG`diagNumber' = "78440" if DIAG`diagNumber' == "R499"
    replace DIAG`diagNumber' = "78060" if DIAG`diagNumber' == "R509"
    replace DIAG`diagNumber' = "33819" if DIAG`diagNumber' == "R52-"
    replace DIAG`diagNumber' = "78079" if DIAG`diagNumber' == "R531"
    replace DIAG`diagNumber' = "78079" if DIAG`diagNumber' == "R538"
    replace DIAG`diagNumber' = "797" if DIAG`diagNumber' == "R54-"
    replace DIAG`diagNumber' = "7802" if DIAG`diagNumber' == "R55-"
    replace DIAG`diagNumber' = "78039" if DIAG`diagNumber' == "R569"
    replace DIAG`diagNumber' = "4590" if DIAG`diagNumber' == "R58-"
    replace DIAG`diagNumber' = "7859" if DIAG`diagNumber' == "R591"
    replace DIAG`diagNumber' = "7856" if DIAG`diagNumber' == "R599"
    replace DIAG`diagNumber' = "7823" if DIAG`diagNumber' == "R600"
    replace DIAG`diagNumber' = "7823" if DIAG`diagNumber' == "R609"
    replace DIAG`diagNumber' = "7808" if DIAG`diagNumber' == "R61-"
    replace DIAG`diagNumber' = "78340" if DIAG`diagNumber' == "R625"
    replace DIAG`diagNumber' = "7830" if DIAG`diagNumber' == "R630"
    replace DIAG`diagNumber' = "7833" if DIAG`diagNumber' == "R633"
    replace DIAG`diagNumber' = "78321" if DIAG`diagNumber' == "R634"
    replace DIAG`diagNumber' = "7831" if DIAG`diagNumber' == "R635"
    replace DIAG`diagNumber' = "7839" if DIAG`diagNumber' == "R638"
    replace DIAG`diagNumber' = "78092" if DIAG`diagNumber' == "R681"
    replace DIAG`diagNumber' = "78094" if DIAG`diagNumber' == "R688"
    replace DIAG`diagNumber' = "79989" if DIAG`diagNumber' == "R69-"
    replace DIAG`diagNumber' = "79579" if DIAG`diagNumber' == "R760"
    replace DIAG`diagNumber' = "79099" if DIAG`diagNumber' == "R772"
    replace DIAG`diagNumber' = "7906" if DIAG`diagNumber' == "R790"
    replace DIAG`diagNumber' = "79501" if DIAG`diagNumber' == "R876"
    replace DIAG`diagNumber' = "79505" if DIAG`diagNumber' == "R878"
    replace DIAG`diagNumber' = "79311" if DIAG`diagNumber' == "R911"
    replace DIAG`diagNumber' = "79319" if DIAG`diagNumber' == "R918"
    replace DIAG`diagNumber' = "79381" if DIAG`diagNumber' == "R920"
    replace DIAG`diagNumber' = "79389" if DIAG`diagNumber' == "R921"
    replace DIAG`diagNumber' = "79382" if DIAG`diagNumber' == "R922"
    replace DIAG`diagNumber' = "79380" if DIAG`diagNumber' == "R928"
    replace DIAG`diagNumber' = "7930" if DIAG`diagNumber' == "R930"
    replace DIAG`diagNumber' = "7934" if DIAG`diagNumber' == "R933"
    replace DIAG`diagNumber' = "7937" if DIAG`diagNumber' == "R937"
    replace DIAG`diagNumber' = "79399" if DIAG`diagNumber' == "R938"
    replace DIAG`diagNumber' = "79402" if DIAG`diagNumber' == "R940"
    replace DIAG`diagNumber' = "79430" if DIAG`diagNumber' == "R943"
    replace DIAG`diagNumber' = "7945" if DIAG`diagNumber' == "R946"
    /*
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S002"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S003"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S004"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S008"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S009"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S012"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S015"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S018"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S019"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S021"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S022"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S050"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S051"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S060"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S065"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S069"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S092"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S099"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S109"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S134"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S161"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S202"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S224"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S241"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S290"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S300"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S314"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S335"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S339"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S370"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S390"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S398"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S399"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S400"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S420"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S421"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S422"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S423"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S424"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S430"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S434"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S438"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S460"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S468"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S469"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S499"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S508"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S518"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S521"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S523"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S525"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S526"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S531"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S541"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S542"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S550"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S551"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S599"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S600"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S602"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S605"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S610"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S612"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S614"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S621"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S623"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S635"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S636"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S671"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S681"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S699"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S700"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S701"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S720"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S721"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S723"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S760"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S762"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S763"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S768"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S769"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S800"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S808"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S810"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S820"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S821"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S822"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S824"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S825"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S826"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S828"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S829"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S830"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S831"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S832"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S834"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S835"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S861"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S862"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S868"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S869"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S899"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S904"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S913"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S921"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S922"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S923"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S914"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S929"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S934"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S935"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S936"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S968"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S969"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S978"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "S999"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T07-"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T148"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T149"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T150"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T159"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T161"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T162"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T169"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T210"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T230"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T232"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T235"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T240"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T242"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T243"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T266"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T300"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T384"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T393"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T435"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T528"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T550"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T633"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T634"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T656"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T700"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T758"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T781"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T782"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T784"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T813"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T821"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T830"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T840"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T841"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T848"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T852"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T854"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T869"
    replace DIAG`diagNumber' = "" if DIAG`diagNumber' == "T889"
    */




    replace DIAG`diagNumber' = "800" if substr(DIAG`diagNumber',1,1) == "S"
    replace DIAG`diagNumber' = "800" if substr(DIAG`diagNumber',1,1) == "T"
    replace DIAG`diagNumber' = "general" if substr(DIAG`diagNumber',1,1) == "Z"

    replace DIAG`diagNumber' = "07811" if DIAG`diagNumber' == "A630"
    replace DIAG`diagNumber' = "2380" if DIAG`diagNumber' == "D48-"
    replace DIAG`diagNumber' = "3026" if DIAG`diagNumber' == "F649"
    replace DIAG`diagNumber' = "38101" if DIAG`diagNumber' == "H650"
    replace DIAG`diagNumber' = "6926" if DIAG`diagNumber' == "L237"
    replace DIAG`diagNumber' = "71535" if DIAG`diagNumber' == "M169"
    replace DIAG`diagNumber' = "72789" if DIAG`diagNumber' == "M65-"
    replace DIAG`diagNumber' = "72703" if DIAG`diagNumber' == "M653"
    replace DIAG`diagNumber' = "6253" if DIAG`diagNumber' == "N946"
    replace DIAG`diagNumber' = "67811" if DIAG`diagNumber' == "O358"
    replace DIAG`diagNumber' = "67811" if DIAG`diagNumber' == "O360"
    replace DIAG`diagNumber' = "67811" if DIAG`diagNumber' == "O365"
    replace DIAG`diagNumber' = "67811" if DIAG`diagNumber' == "O368"
    replace DIAG`diagNumber' = "64400" if DIAG`diagNumber' == "O60-"
    replace DIAG`diagNumber' = "7449" if DIAG`diagNumber' == "Q189"
    replace DIAG`diagNumber' = "7812" if DIAG`diagNumber' == "R269"

    replace DIAG`diagNumber' = "0039" if DIAG`diagNumber' == "A029"
    replace DIAG`diagNumber' = "1179" if DIAG`diagNumber' == "B49-"
    replace DIAG`diagNumber' = "1369" if DIAG`diagNumber' == "B89-"
    replace DIAG`diagNumber' = "220" if DIAG`diagNumber' == "D279"
    replace DIAG`diagNumber' = "2890" if DIAG`diagNumber' == "D751"
    replace DIAG`diagNumber' = "2512" if DIAG`diagNumber' == "E162"
    replace DIAG`diagNumber' = "2797" if DIAG`diagNumber' == "E875"
    replace DIAG`diagNumber' = "30022" if DIAG`diagNumber' == "F40-"
    replace DIAG`diagNumber' = "3159" if DIAG`diagNumber' == "F819"
    replace DIAG`diagNumber' = "4785" if DIAG`diagNumber' == "J383"
    replace DIAG`diagNumber' = "55221" if DIAG`diagNumber' == "K43-"
    replace DIAG`diagNumber' = "6953" if DIAG`diagNumber' == "L710"
    replace DIAG`diagNumber' = "73731" if DIAG`diagNumber' == "M41-"
    replace DIAG`diagNumber' = "6020" if DIAG`diagNumber' == "N42-"
    replace DIAG`diagNumber' = "6170" if DIAG`diagNumber' == "N80-"
    replace DIAG`diagNumber' = "62981" if DIAG`diagNumber' == "N96-"
    replace DIAG`diagNumber' = "67811" if DIAG`diagNumber' == "O366"
    replace DIAG`diagNumber' = "67811" if DIAG`diagNumber' == "O40-"
    replace DIAG`diagNumber' = "7741" if DIAG`diagNumber' == "P58-"
    replace DIAG`diagNumber' = "7443" if DIAG`diagNumber' == "Q179"
    replace DIAG`diagNumber' = "7454" if DIAG`diagNumber' == "Q210"
    replace DIAG`diagNumber' = "7489" if DIAG`diagNumber' == "Q349"
    replace DIAG`diagNumber' = "75732" if DIAG`diagNumber' == "Q825"
    replace DIAG`diagNumber' = "79901" if DIAG`diagNumber' == "R090"
    replace DIAG`diagNumber' = "7871" if DIAG`diagNumber' == "R12-"

    replace DIAG`diagNumber' = "2875" if DIAG`diagNumber' == "D696"
    replace DIAG`diagNumber' = "42789" if DIAG`diagNumber' == "I498"
    replace DIAG`diagNumber' = "99939" if DIAG`diagNumber' == "N98-"
    replace DIAG`diagNumber' = "64393" if DIAG`diagNumber' == "O219"
    replace DIAG`diagNumber' = "78829" if DIAG`diagNumber' == "R330"

    replace DIAG`diagNumber' = "31500" if DIAG`diagNumber' == "F81-"
    replace DIAG`diagNumber' = "79029" if DIAG`diagNumber' == "R739"
}

forval diagNumber = 1/3 {
    // Infectious and Parasitic Diseases (001-139)
    replace infAndPara = 1 if real(substr(DIAG`diagNumber',1,1)) == 0 & relevantDiagIndicator == 1
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
    //replace skinAndSubCut = 1 if real(substr(DIAG`diagNumber',1,3)) >= 680 & real(substr(DIAG`diagNumber',1,3)) <= 709

    // Diseases of Musculoskeletal and Connective Tissue (710-739)
    replace muscAndConnect = 1 if real(substr(DIAG`diagNumber',1,3)) >= 710 & real(substr(DIAG`diagNumber',1,3)) <= 739

    // Congenital Anomalies (740-759)
    replace congenitalAnomaly = 1 if real(substr(DIAG`diagNumber',1,3)) >= 740 & real(substr(DIAG`diagNumber',1,3)) <= 759

    // Newborn Guidelines (760-779)
    replace newborn = 1 if real(substr(DIAG`diagNumber',1,3)) >= 760 & real(substr(DIAG`diagNumber',1,3)) <= 779

    // Signs, Symptoms, and Ill-Defined Conditions (780-799)
    replace signsAndSymptoms = 1 if real(substr(DIAG`diagNumber',1,3)) >= 780 & real(substr(DIAG`diagNumber',1,3)) <= 799

    // Injury and Poisoning (800-999)
    replace injAndPoison = 1 if real(substr(DIAG`diagNumber',1,3)) >= 800 & real(substr(DIAG`diagNumber',1,3)) <= 999

    // Classification of Factors Influencing Health Status and Contact with Health Services (Supplemental V01-V91)
    replace suppFactors = 1 if substr(DIAG`diagNumber',1,1) == "V"

    // Supplemental Classification of External Causes of Injury and Poisoning (E800-E999) []

    // General/Undefinable
    replace general = 1 if DIAG`diagNumber' == "general"
}

// More Specific Diagnoses
gen travelerDiarrhea = 0
gen urinaryTractInfection = 0
gen earInfection = 0
gen chronicBronchitis = 0
gen shigellosis = 0
gen pneumonia = 0
gen listeria = 0
gen brucella = 0
gen nocardia = 0
gen salmonella = 0
gen paracoccidioides = 0
gen melioidoisis = 0
gen burkholderia = 0
gen stenotrophomonas = 0
gen cyclospora = 0
gen isospora = 0
gen whipplesDisease = 0
gen toxoplasmosis = 0
gen mrsaSkinInfection = 0
gen generalSkinInfection = 0

// Traveler's Diarrhea
forval diagNumber = 1/3 {
  // Traveler's Diarrhea
  replace travelerDiarrhea = 1 if real(substr(DIAG`diagNumber',1,5)) == 78791 // Diarhhea
  // 787 -> Symptoms involving the digestive system

  // Urinary Tract Infection
  replace urinaryTractInfection = 1 if real(substr(DIAG`diagNumber',1,4)) == 5990 // Urinary tract infection, site unspecified
  // 599 -> other disorders of urethra and urinary tract

  // Ear Infections
  replace earInfection = 1 if real(substr(DIAG`diagNumber',1,3)) == 382 // Otitis media
  // 380-389 -> Diseases of the ear and mastoid process

  // Chronic Bronchitis
  replace chronicBronchitis = 1 if real(substr(DIAG`diagNumber',1,3)) == 491 // Chronic Bronchitis
  // 490-496 Chronic obstructive Pulmonary Diseases and Allied Conditions

  // Shigellosis
  replace shigellosis = 1 if substr(DIAG`diagNumber',1,3) == "004" // Shigellosis
  // 001-009 Chronic Bronchitis

  // Treatment and Prophylaxis of Pneumonia
  replace pneumonia = 1 if real(substr(DIAG`diagNumber',1,3)) >= 480 & real(substr(DIAG`diagNumber',1,3)) <= 486 // Various classification of Pneumonia
  // 480-488 Pneumonia and Influenza

  // Brucella
  replace brucella = 1 if substr(DIAG`diagNumber',1,3) == "023" // Brucellosis
  // 020-027 -> Zoonotic Bacterial Diseases

  // Nocardia
  replace nocardia = 1 if substr(DIAG`diagNumber',1,3) == "039" // Actinomycotic infections
  // 030-041 -> Other Bacterial diseases

  // Salmonella Infections
  replace salmonella = 1 if substr(DIAG`diagNumber',1,3) == "003" // Other Salmonella Infections
  // 001-009 -> Intestinal Infectious Diseases

  // Paracoccidioides
  replace paracoccidioides = 1 if real(substr(DIAG`diagNumber',1,4)) == 1161 //Paracoccidiodomycosis
  // 116 -> Blastomycotic Infection

  // Melioidoisis
  replace melioidoisis = 1 if substr(DIAG`diagNumber',1,3) == "025" // Melioidosis
  // 020-027 -> Zoonotic Bacterial Diseases

  // Burkholderia
  replace burkholderia = 1 if real(substr(DIAG`diagNumber',1,4)) == 2002 // Burckett's Tumors of Lymphatic Tissue
  // 200 Lymphosarcoma and reticulosarcoma and other specified malignant tumors of lymphatic tissue


  // Stenotrophomonas
  // No code found

  // Cyclospora
  replace cyclospora = 1 if substr(DIAG`diagNumber',1,4) == "0075" // Cyclosporiasis
  // 007 -> other Protozoal Intestinal Disease
  
  // Isospora
  replace isospora = 1 if substr(DIAG`diagNumber',1,4) == "0072" // Coccidiosis
  // 007 -> other Protozoal Intestinal Disease

  // Whipple's Disease
  replace whipplesDisease = 1 if substr(DIAG`diagNumber',1,4) == "0402" // Whipple's Disease
  // 040 -> Other bacterial diseases

  // Toxoplasmoisis
  replace toxoplasmosis = 1 if substr(DIAG`diagNumber',1,3) == "130" // Toxoplasmosis
  // 130-163 Other Infections and Parasitic Diseases

  // MRSA Skin Infections
  replace mrsaSkinInfection = 1 if substr(DIAG`diagNumber',1,4) == "0412" // Pneumococcus infection in conditions classified elsewhere and of unspecified site
  // 041 -> Bacterial infection in conditions classified elsewhere and of unspecified site

  // General Skin Infection (Not mentioned in drug handbook but appears many times in data. Could be because MRSA needs to be tested for while these diagnoses are unspecified. Most likely every doc isn't testing every skin infection he/she sees.)
  replace generalSkinInfection = 1 if substr(DIAG`diagNumber',1,3) == "682" // Other cellulitis and abscess
  // 680-686 -> Infections of Skin and Subcutaneous Tissue
  
}

forval diagNumber = 1/3 {
  replace genDigestiveSystem = 1 if real(substr(DIAG`diagNumber',1,3)) == 787
  // 787 -> Symptoms involving the digestive system

  // Urinary Tract Infection
  replace urinaryDisorders = 1 if real(substr(DIAG`diagNumber',1,3)) == 599
  // 599 -> other disorders of urethra and urinary tract

  // Ear Infections
  replace diseasesOfEar = 1 if real(substr(DIAG`diagNumber',1,3)) >= 380 & real(substr(DIAG`diagNumber',1,3)) <= 389 // Otitis media
  // 380-389 -> Diseases of the ear and mastoid process

  // Chronic Bronchitis
  replace chronichPulmonaryDiseases = 1 if real(substr(DIAG`diagNumber',1,3)) >= 490 & real(substr(DIAG`diagNumber',1,3)) <= 496 // Chronic Bronchitis
  // 490-496 Chronic obstructive Pulmonary Diseases and Allied Conditions

  // Shigellosis
  // replace intenstinalInfectiousDiseases = 1 if substr(DIAG`diagNumber',1,3) == "004" // Shigellosis
  // 001-009 Chronic Bronchitis

  // Treatment and Prophylaxis of Pneumonia
  replace pneumoniaAndInfluenza = 1 if real(substr(DIAG`diagNumber',1,3)) >= 480 & real(substr(DIAG`diagNumber',1,3)) <= 486
  // 480-488 Pneumonia and Influenza

  // Brucella
  //replace brucella = 1 if substr(DIAG`diagNumber',1,3) == "023" // Brucellosis
  // 020-027 -> Zoonotic Bacterial Diseases

  // Nocardia
  //replace otherBacterialDiseases = 1 if substr(DIAG`diagNumber',1,3) == "039" // Actinomycotic infections
  // 030-041 -> Other Bacterial diseases

  // Salmonella Infections
  replace intenstinalInfectiousDiseases = 1 if substr(DIAG`diagNumber',1,2) == "00" & real(substr(DIAG`diagNumber',3,1)) >= 1 & real(substr(DIAG`diagNumber',3,1)) <= 9 // Other Salmonella Infections
  // 001-009 -> Intestinal Infectious Diseases

  // Paracoccidioides
  replace blastomycoticInfection = 1 if real(substr(DIAG`diagNumber',1,3)) == 116 //Paracoccidiodomycosis
  // 116 -> Blastomycotic Infection

  // Melioidoisis
  replace zoonoticBactDiseases = 1 if substr(DIAG`diagNumber',1,1) == "0" & real(substr(DIAG`diagNumber',2,2)) >= 25 & real(substr(DIAG`diagNumber',2,2)) <= 27 // Melioidosis
  // 020-027 -> Zoonotic Bacterial Diseases

  // Burkholderia
  replace lymphosarcoma = 1 if real(substr(DIAG`diagNumber',1,3)) == 200
  // 200 Lymphosarcoma and reticulosarcoma and other specified malignant tumors of lymphatic tissue


  // Stenotrophomonas
  // No code found

  // Cyclospora
  // replace cyclospora = 1 if substr(DIAG`diagNumber',1,3) == "007" // Cyclosporiasis
  // 007 -> other Protozoal Intestinal Disease
  
  // Isospora
  // replace protozoalIntDisease = 1 if substr(DIAG`diagNumber',1,3) == "007" // Coccidiosis
  // 007 -> other Protozoal Intestinal Disease

  // Whipple's Disease
  replace otherBacterialDiseases = 1 if substr(DIAG`diagNumber',1,3) == "040" // Whipple's Disease
  // 040 -> Other bacterial diseases

  // Toxoplasmoisis
  replace otherInfectionsAndParasiticDiseases = 1 if real(substr(DIAG`diagNumber',1,3)) == "130" & real(substr(DIAG`diagNumber',1,3)) == "163" // Toxoplasmosis
  // 130-163 Other Infections and Parasitic Diseases

  // MRSA Skin Infections
  replace unspecBacterialInfections = 1 if substr(DIAG`diagNumber',1,3) == "041" // Pneumococcus infection in conditions classified elsewhere and of unspecified site
  // 041 -> Bacterial infection in conditions classified elsewhere and of unspecified site

  // General Skin Infection (Not mentioned in drug handbook but appears many times in data. Could be because MRSA needs to be tested for while these diagnoses are unspecified. Most likely every doc isn't testing every skin infection he/she sees.)
  replace skinAndSubCut = 1 if real(substr(DIAG`diagNumber',1,3)) >= "680" & real(substr(DIAG`diagNumber',1,3)) <= "686"  // Other cellulitis and abscess
  // 680-686 -> Infections of Skin and Subcutaneous Tissue
  
}

gen offPatent = 1 if YEAR > `firstGenYear'
replace offPatent = 1 if YEAR == `firstGenYear' & VMONTH >= `firstGenMonth'
replace offPatent = 0 if offPatent != 1

gen observationMonth = (YEAR - 2000)*12 + VMONTH
gen genericMonth = (`firstGenYear' - 2000)*12 + `firstGenMonth'
gen monthsAfterGeneric = observationMonth - genericMonth
gen genericOn = 1 if monthsAfterGeneric >= 0
replace genericOn = 0 if monthsAfterGeneric < 0 

/* forval diagNumber = 1/5 {
    tab DIAG`diagNumber' if infAndPara == 0 & neoplasm == 0 & endoNutMeta == 0 & bloodAndBloodOrgans == 0 & mental == 0 & nervousSystem == 0 & circSystem == 0 & respSystem == 0 & digSystem == 0 & genSystem == 0 & pregAndChildBirth == 0 & skinAndSubCut == 0 & muscAndConnect == 0 & congenitalAnomaly == 0 & newborn == 0 & illDefined == 0 & injAndPoison == 0 & suppFactors == 0 & general == 0
}
*/
save "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace
