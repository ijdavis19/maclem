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
do "$dofiles/panelDataCreation"
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

// Create a new dataset with each diag code
clear
gen diagnosisCode = ""
local i = 1
forval diagNumber = 1/5 {
    forval diagCounter = 1/`diagMax`diagNumber'' {
        set obs `i'
        replace diagnosisCode = "``diagNumber'diag`diagCounter''" if _n == `i'
        local i = `i' + 1
    }
}
bysort diagnosisCode: gen repeatCount = _n
drop if repeatCount > 1

//Change ICD-10-CM to ICD-9-CM
replace diagnosisCode = "0419" if diagnosisCode == "A499"
replace diagnosisCode = "0979" if diagnosisCode == "A539"
replace diagnosisCode = "07819" if diagnosisCode == "B078"
replace diagnosisCode = "07054" if diagnosisCode == "B182"
replace diagnosisCode = "042" if diagnosisCode == "B20-"
replace diagnosisCode = "1369" if diagnosisCode == "B64-"
replace diagnosisCode = "1619" if diagnosisCode == "C329"
replace diagnosisCode = "1830" if diagnosisCode == "C569"
replace diagnosisCode = "185" if diagnosisCode == "C61-"
replace diagnosisCode = "1890" if diagnosisCode == "C649"
replace diagnosisCode = "1889" if diagnosisCode == "C679"
replace diagnosisCode = "20410" if diagnosisCode == "C911"
replace diagnosisCode = "2163" if diagnosisCode == "D223"
replace diagnosisCode = "2164" if diagnosisCode == "D224"
replace diagnosisCode = "2239" if diagnosisCode == "D309"
replace diagnosisCode = "2859" if diagnosisCode == "D649"
replace diagnosisCode = "28861" if diagnosisCode == "D728"
replace diagnosisCode = "2449" if diagnosisCode == "E039"
replace diagnosisCode = "2469" if diagnosisCode == "E079"
replace diagnosisCode = "24920" if diagnosisCode == "E08-"
replace diagnosisCode = "25060" if diagnosisCode == "E114"
replace diagnosisCode = "25060" if diagnosisCode == "E116"
replace diagnosisCode = "25000" if diagnosisCode == "E119"
replace diagnosisCode = "2564" if diagnosisCode == "E282"
replace diagnosisCode = "2572" if diagnosisCode == "E291"
replace diagnosisCode = "27800" if diagnosisCode == "E669"
replace diagnosisCode = "29530" if diagnosisCode == "F200"
replace diagnosisCode = "29680" if diagnosisCode == "F319"
replace diagnosisCode = "30000" if diagnosisCode == "F419"
replace diagnosisCode = "30981" if diagnosisCode == "F431"
replace diagnosisCode = "30410" if diagnosisCode == "F132"
replace diagnosisCode = "29900" if diagnosisCode == "F840"
replace diagnosisCode = "3331" if diagnosisCode == "G250"
replace diagnosisCode = "3394" if diagnosisCode == "G258"
replace diagnosisCode = "340" if diagnosisCode == "G35-"
replace diagnosisCode = "34590" if diagnosisCode == "G409"
replace diagnosisCode = "34602" if diagnosisCode == "G431"
replace diagnosisCode = "34932" if diagnosisCode == "G439"
replace diagnosisCode = "48052" if diagnosisCode == "G470"
replace diagnosisCode = "32721" if diagnosisCode == "G473"
replace diagnosisCode = "3384" if diagnosisCode == "G894"
replace diagnosisCode = "3732" if diagnosisCode == "H000"
replace diagnosisCode = "36100" if diagnosisCode == "H33-"
replace diagnosisCode = "37921" if diagnosisCode == "H438"
replace diagnosisCode = "3804" if diagnosisCode == "H612"
replace diagnosisCode = "38200" if diagnosisCode == "H66-"
replace diagnosisCode = "3829" if diagnosisCode == "H669"
replace diagnosisCode = "3819" if diagnosisCode == "H699"
replace diagnosisCode = "3810" if diagnosisCode == "H80-"
replace diagnosisCode = "38901" if diagnosisCode == "H900"
replace diagnosisCode = "38911" if diagnosisCode == "H903"
replace diagnosisCode = "38910" if diagnosisCode == "H905"
replace diagnosisCode = "4010" if diagnosisCode == "I10-"
replace diagnosisCode = "40300" if diagnosisCode == "I129"
replace diagnosisCode = "41401" if diagnosisCode == "I251"
replace diagnosisCode = "1272" if diagnosisCode == "I272"
replace diagnosisCode = "4240" if diagnosisCode == "I340"
replace diagnosisCode = "4241" if diagnosisCode == "I350"
replace diagnosisCode = "42731" if diagnosisCode == "I482"
replace diagnosisCode = "43491" if diagnosisCode == "I639"
replace diagnosisCode = "4409" if diagnosisCode == "I709"
replace diagnosisCode = "4439" if diagnosisCode == "I739"
replace diagnosisCode = "4540" if diagnosisCode == "I83-"
replace diagnosisCode = "460" if diagnosisCode == "J00-"
replace diagnosisCode = "4618" if diagnosisCode == "J018"
replace diagnosisCode = "4619" if diagnosisCode == "J019"
replace diagnosisCode = "0340" if diagnosisCode == "J020"
replace diagnosisCode = "4658" if diagnosisCode == "J069"
replace diagnosisCode = "4660" if diagnosisCode == "J209"
replace diagnosisCode = "4772" if diagnosisCode == "J308"
replace diagnosisCode = "4779" if diagnosisCode == "J309"
replace diagnosisCode = "4720" if diagnosisCode == "J310"
replace diagnosisCode = "4730" if diagnosisCode == "J320"
replace diagnosisCode = "4731" if diagnosisCode == "J321"
replace diagnosisCode = "4732" if diagnosisCode == "J322"
replace diagnosisCode = "4738" if diagnosisCode == "J324"
replace diagnosisCode = "4739" if diagnosisCode == "J329"
replace diagnosisCode = "4710" if diagnosisCode == "J330"
replace diagnosisCode = "470" if diagnosisCode == "J342"
replace diagnosisCode = "4780" if diagnosisCode == "J343"
replace diagnosisCode = "47819" if diagnosisCode == "J349"
replace diagnosisCode = "47400" if diagnosisCode == "J350"
replace diagnosisCode = "4920" if diagnosisCode == "J439"
replace diagnosisCode = "49120" if diagnosisCode == "J449"
replace diagnosisCode = "49310" if diagnosisCode == "J452"
replace diagnosisCode = "49392" if diagnosisCode == "J459"
replace diagnosisCode = "51900" if diagnosisCode == "J95-"
replace diagnosisCode = "53081" if diagnosisCode == "K219"
replace diagnosisCode = "53390" if diagnosisCode == "K279"
replace diagnosisCode = "55090" if diagnosisCode == "K409"
replace diagnosisCode = "5531" if diagnosisCode == "K429"
replace diagnosisCode = "55321" if diagnosisCode == "K432"
replace diagnosisCode = "55329" if diagnosisCode == "K439"
replace diagnosisCode = "5533" if diagnosisCode == "K449"
replace diagnosisCode = "56400" if diagnosisCode == "K590"
replace diagnosisCode = "5689" if diagnosisCode == "K669"
replace diagnosisCode = "5715" if diagnosisCode == "K746"
replace diagnosisCode = "6820" if diagnosisCode == "L02-"
replace diagnosisCode = "68100" if diagnosisCode == "L030"
replace diagnosisCode = "6823" if diagnosisCode == "L031"
replace diagnosisCode = "68600" if diagnosisCode == "L08-"
replace diagnosisCode = "6869" if diagnosisCode == "L089"
replace diagnosisCode = "6983" if diagnosisCode == "L280"
replace diagnosisCode = "6980" if diagnosisCode == "L29-"
replace diagnosisCode = "6929" if diagnosisCode == "L300"
replace diagnosisCode = "7030" if diagnosisCode == "L600"
replace diagnosisCode = "7061" if diagnosisCode == "L700"
replace diagnosisCode = "7061" if diagnosisCode == "L709"
replace diagnosisCode = "7062" if diagnosisCode == "L728"
replace diagnosisCode = "70583" if diagnosisCode == "L732"
replace diagnosisCode = "7048" if diagnosisCode == "L738"
replace diagnosisCode = "7049" if diagnosisCode == "L739"
replace diagnosisCode = "70909" if diagnosisCode == "L810"
replace diagnosisCode = "7092" if diagnosisCode == "L905"
replace diagnosisCode = "6954" if diagnosisCode == "L93-"
replace diagnosisCode = "70715" if diagnosisCode == "L975"
replace diagnosisCode = "70710" if diagnosisCode == "L979"
replace diagnosisCode = "7099" if diagnosisCode == "L989"
replace diagnosisCode = "7144" if diagnosisCode == "M12-"
replace diagnosisCode = "71530" if diagnosisCode == "M199"
replace diagnosisCode = "71940" if diagnosisCode == "M255"
replace diagnosisCode = "7100" if diagnosisCode == "M329"
replace diagnosisCode = "72400" if diagnosisCode == "M480"
replace diagnosisCode = "7242" if diagnosisCode == "M545"
replace diagnosisCode = "7238" if diagnosisCode == "M548"
replace diagnosisCode = "7291" if diagnosisCode == "M79-"
replace diagnosisCode = "7291" if diagnosisCode == "M797"
replace diagnosisCode = "73301" if diagnosisCode == "M810"
replace diagnosisCode = "73000" if diagnosisCode == "M86-"
replace diagnosisCode = "5934" if diagnosisCode == "N138"
replace diagnosisCode = "5909" if diagnosisCode == "N159"
replace diagnosisCode = "5854" if diagnosisCode == "N184"
replace diagnosisCode = "5859" if diagnosisCode == "N189"
replace diagnosisCode = "5920" if diagnosisCode == "N200"
replace diagnosisCode = "5920" if diagnosisCode == "N202"
replace diagnosisCode = "5941" if diagnosisCode == "N210"
replace diagnosisCode = "5939" if diagnosisCode == "N289"
replace diagnosisCode = "5950" if diagnosisCode == "N300"
replace diagnosisCode = "5951" if diagnosisCode == "N301"
replace diagnosisCode = "5959" if diagnosisCode == "N309"
replace diagnosisCode = "5960" if diagnosisCode == "N320"
replace diagnosisCode = "5970" if diagnosisCode == "N34-"
replace diagnosisCode = "5989" if diagnosisCode == "N359"
replace diagnosisCode = "5990" if diagnosisCode == "N390"
replace diagnosisCode = "6256" if diagnosisCode == "N393"
replace diagnosisCode = "60000" if diagnosisCode == "N40-"
replace diagnosisCode = "60000" if diagnosisCode == "N400"
replace diagnosisCode = "60001" if diagnosisCode == "N401"
replace diagnosisCode = "611" if diagnosisCode == "N411"
replace diagnosisCode = "6039" if diagnosisCode == "N433"
replace diagnosisCode = "60490" if diagnosisCode == "N45-"
replace diagnosisCode = "60490" if diagnosisCode == "N453"
replace diagnosisCode = "6071" if diagnosisCode == "N481"
replace diagnosisCode = "60784" if diagnosisCode == "N529"
replace diagnosisCode = "6111" if diagnosisCode == "N62-"
replace diagnosisCode = "61172" if diagnosisCode == "N63-"
replace diagnosisCode = "6268" if diagnosisCode == "N938"
replace diagnosisCode = "7850" if diagnosisCode == "R000"
replace diagnosisCode = "7847" if diagnosisCode == "R040"
replace diagnosisCode = "7862" if diagnosisCode == "R05-"
replace diagnosisCode = "78609" if diagnosisCode == "R060"
replace diagnosisCode = "78607" if diagnosisCode == "R062"
replace diagnosisCode = "7841" if diagnosisCode == "R070"
replace diagnosisCode = "6089" if diagnosisCode == "R102"
replace diagnosisCode = "78961" if diagnosisCode == "R108"
replace diagnosisCode = "78900" if diagnosisCode == "R109"
replace diagnosisCode = "78702" if diagnosisCode == "R110"
replace diagnosisCode = "7810" if diagnosisCode == "R252"
replace diagnosisCode = "7812" if diagnosisCode == "R268"
replace diagnosisCode = "7881" if diagnosisCode == "R300"
replace diagnosisCode = "59971" if diagnosisCode == "R310"
replace diagnosisCode = "59972" if diagnosisCode == "R312"
replace diagnosisCode = "59970" if diagnosisCode == "R319"
replace diagnosisCode = "78829" if diagnosisCode == "R338"
replace diagnosisCode = "78820" if diagnosisCode == "R339"
replace diagnosisCode = "78841" if diagnosisCode == "R350"
replace diagnosisCode = "78843" if diagnosisCode == "R351"
replace diagnosisCode = "78864" if diagnosisCode == "R391"
replace diagnosisCode = "78899" if diagnosisCode == "R399"
replace diagnosisCode = "7811" if diagnosisCode == "R430"
replace diagnosisCode = "7840" if diagnosisCode == "R51-"
replace diagnosisCode = "7856" if diagnosisCode == "R590"
replace diagnosisCode = "79009" if diagnosisCode == "R718"
replace diagnosisCode = "79021" if diagnosisCode == "R730"
replace diagnosisCode = "79551" if diagnosisCode == "R761"
replace diagnosisCode = "7919" if diagnosisCode == "R829"
replace diagnosisCode = "79093" if diagnosisCode == "R972"
replace diagnosisCode = "800" if diagnosisCode == "S604"
replace diagnosisCode = "800" if diagnosisCode == "S629"
replace diagnosisCode = "800" if diagnosisCode == "S731"
replace diagnosisCode = "800" if diagnosisCode == "T214"
replace diagnosisCode = "800" if diagnosisCode == "T509"
replace diagnosisCode = "800" if diagnosisCode == "T819"
replace diagnosisCode = "800" if diagnosisCode == "T839"
replace diagnosisCode = "general" if diagnosisCode == "Z000"
replace diagnosisCode = "general" if diagnosisCode == "Z028"
replace diagnosisCode = "general" if diagnosisCode == "Z029"
replace diagnosisCode = "general" if diagnosisCode == "Z09-"
replace diagnosisCode = "general" if diagnosisCode == "Z123"
replace diagnosisCode = "general" if diagnosisCode == "Z223"
replace diagnosisCode = "general" if diagnosisCode == "Z433"
replace diagnosisCode = "general" if diagnosisCode == "Z518"
replace diagnosisCode = "general" if diagnosisCode == "Z720"
replace diagnosisCode = "general" if diagnosisCode == "Z795"
replace diagnosisCode = "general" if diagnosisCode == "Z798"
replace diagnosisCode = "general" if diagnosisCode == "Z861"
replace diagnosisCode = "general" if diagnosisCode == "Z874"
replace diagnosisCode = "general" if diagnosisCode == "Z922"
replace diagnosisCode = "general" if diagnosisCode == "Z950"
replace diagnosisCode = "general" if diagnosisCode == "Z988"
replace diagnosisCode = "general" if diagnosisCode == "ZZZ0"
replace diagnosisCode = "3099" if diagnosisCode == "F432"
replace diagnosisCode = "5350" if diagnosisCode == "K297"
replace diagnosisCode = "800" if diagnosisCode == "S626"




 


save "$output/diagDescriptions.dta", replace
// Infectious and Parasitic Diseases (001-139)
gen infAndPara = 0
replace infAndPara = 1 if real(substr(diagnosisCode,1,1)) == 0
replace infAndPara = 1 if real(substr(diagnosisCode,1,1)) == 1 & real(substr(diagnosisCode,2,1)) <= 3

// Neoplasms (140-239)
gen neoplasm = 0
replace neoplasm = 1 if real(substr(diagnosisCode,1,3)) >= 140 & real(substr(diagnosisCode,1,3)) <= 239

// Endocrine, Nutritional, and Metabolic (240-279)
gen endoNutMeta = 0
replace endoNutMeta = 1 if real(substr(diagnosisCode,1,3)) >= 240 & real(substr(diagnosisCode,1,3)) <= 279

// Diseases of Blood and Blood Forming Organs (280-289)
gen bloodAndBloodOrgans = 0
replace bloodAndBloodOrgans = 1 if real(substr(diagnosisCode,1,3)) >= 280 & real(substr(diagnosisCode,1,3)) <= 289

// Mental Disorders (290-319)
gen mental = 0
replace mental = 1 if real(substr(diagnosisCode,1,3)) >= 290 & real(substr(diagnosisCode,1,3)) <= 319

// Diseases of Nervous System and Sense Organs (320-389)
gen nervousSystem = 0
replace nervousSystem = 1 if real(substr(diagnosisCode,1,3)) >= 320 & real(substr(diagnosisCode,1,3)) <= 389

// Diseases of Circulatory System (390-459)
gen circSystem = 0
replace circSystem = 1 if real(substr(diagnosisCode,1,3)) >= 390 & real(substr(diagnosisCode,1,3)) <= 459

// Diseases of Respiratory System (460-519)
gen respSystem = 0
replace respSystem = 1 if real(substr(diagnosisCode,1,3)) >= 460 & real(substr(diagnosisCode,1,3)) <= 519

// Diseases of Digestive System (520-579)
gen digSystem = 0
replace digSystem = 1 if real(substr(diagnosisCode,1,3)) >= 520 & real(substr(diagnosisCode,1,3)) <= 579

// Diseases of Genitourinary System (580-629)
gen genSystem = 0
replace genSystem = 1 if real(substr(diagnosisCode,1,3)) >= 580 & real(substr(diagnosisCode,1,3)) <= 629

// Complications of Pregnancy, Childbirth, and the Puerperium (630-679)
gen pregAndChildBirth = 0
replace pregAndChildBirth = 1 if real(substr(diagnosisCode,1,3)) >= 630 & real(substr(diagnosisCode,1,3)) <= 679

// Diseases Skin and Subcutaneous Tissue (680-709)
gen skinAndSubCut = 0
replace skinAndSubCut = 1 if real(substr(diagnosisCode,1,3)) >= 680 & real(substr(diagnosisCode,1,3)) <= 709

// Diseases of Musculoskeletal and Connective Tissue (710-739)
gen muscAndConnect = 0
replace muscAndConnect = 1 if real(substr(diagnosisCode,1,3)) >= 710 & real(substr(diagnosisCode,1,3)) <= 739

// Congenital Anomalies (740-759)
gen congenitalAnomaly = 0
replace congenitalAnomaly = 1 if real(substr(diagnosisCode,1,3)) >= 740 & real(substr(diagnosisCode,1,3)) <= 759

// Newborn Guidelines (760-779)
gen newborn = 0
replace newborn = 1 if real(substr(diagnosisCode,1,3)) >= 760 & real(substr(diagnosisCode,1,3)) <= 779

// Signs, Symptoms, and Ill-Defined Conditions (780-799)
gen illDefined = 0
replace illDefined = 1 if real(substr(diagnosisCode,1,3)) >= 780 & real(substr(diagnosisCode,1,3)) <= 799

// Injury and Poisoning (800-999)
gen injAndPoison = 0
replace injAndPoison = 1 if real(substr(diagnosisCode,1,3)) >= 800 & real(substr(diagnosisCode,1,3)) <= 999

// Classification of Factors Influencing Health Status and Contact with Health Services (Supplemental V01-V91)
gen suppFactors = 0
replace suppFactors = 1 if substr(diagnosisCode,1,1) == "V"

// Supplemental Classification of External Causes of Injury and Poisoning (E800-E999) []

// General/Undefinable
gen general = 0
replace general = 1 if diagnosisCode == "general"

tab diagnosisCode if infAndPara == 0 & neoplasm == 0 & endoNutMeta == 0 & bloodAndBloodOrgans == 0 & mental == 0 & nervousSystem == 0 & circSystem == 0 & respSystem == 0 & digSystem == 0 & genSystem == 0 & pregAndChildBirth == 0 & skinAndSubCut == 0 & muscAndConnect == 0 & congenitalAnomaly == 0 & newborn == 0 & illDefined == 0 & injAndPoison == 0 & suppFactors == 0