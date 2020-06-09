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

use "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace


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
gen skinAndSubCutDiseases = 0
gen muscAndConnect = 0
gen congenitalAnomaly = 0
gen newborn = 0
gen signsAndSymptoms = 0
gen injAndPoison = 0
gen suppFactors = 0
gen general = 0

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
    replace skinAndSubCutDiseases = 1 if real(substr(DIAG`diagNumber',1,3)) >= 680 & real(substr(DIAG`diagNumber',1,3)) <= 709

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

save "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace
