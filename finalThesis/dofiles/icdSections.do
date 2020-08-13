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
global output = "$projects/finalThesis"
global dofiles = "economics/maclem/finalThesis"

use "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace

gen genDigestiveSystem = 0
gen urinaryDisorders = 0
gen diseasesOfEar = 0
gen chronichPulmonaryDiseases = 0
gen intenstinalInfectiousDiseases = 0
gen pneumoniaAndInfluenza = 0
gen otherBacterialDiseases = 0
gen blastomycoticInfection = 0
gen zoonoticBactDiseases = 0
gen lymphosarcoma = 0
gen otherInfectionsAndParaDiseases = 0
gen unspecBacterialInfections = 0
gen skinAndSubCut = 0


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
  replace otherInfectionsAndParaDiseases = 1 if real(substr(DIAG`diagNumber',1,3)) == 130 & real(substr(DIAG`diagNumber',1,3)) == 163 // Toxoplasmosis
  // 130-163 Other Infections and Parasitic Diseases

  // MRSA Skin Infections
  replace unspecBacterialInfections = 1 if substr(DIAG`diagNumber',1,3) == "041" // Pneumococcus infection in conditions classified elsewhere and of unspecified site
  // 041 -> Bacterial infection in conditions classified elsewhere and of unspecified site

  // General Skin Infection (Not mentioned in drug handbook but appears many times in data. Could be because MRSA needs to be tested for while these diagnoses are unspecified. Most likely every doc isn't testing every skin infection he/she sees.)
  replace skinAndSubCut = 1 if real(substr(DIAG`diagNumber',1,3)) >= 680 & real(substr(DIAG`diagNumber',1,3)) <= 686  // Other cellulitis and abscess
  // 680-686 -> Infections of Skin and Subcutaneous Tissue

  // General Skin Infection (Not mentioned in drug handbook but appears many times in data. Could be because MRSA needs to be tested for while these diagnoses are unspecified. Most likely every doc isn't testing every skin infection he/she sees.)
  //replace generalSkinInfection = 1 if substr(DIAG`diagNumber',1,3) == "682" // Other cellulitis and abscess
  // 680-686 -> Infections of Skin and Subcutaneous Tissue
}


// Off label prescription sections
gen offLabelUnspecCellandAbscess = 0
gen offLabelUTI = 0
gen offLabelAbsPelvis = 0
gen offLabelUrinarySymptoms = 0
gen offLabelCellulitisDigit = 0
gen offLabelCystitis = 0

forval diagNumber = 1/3 {
  replace offLabelUnspecCellandAbscess = 1 if substr(DIAG`diagNumber',1,3) == "682" // Other cellulitis and abscess
  replace offLabelUTI = 1 if substr(DIAG`diagNumber',1,3) == "599" & substr(DIAG`diagNumber',1,4) != "5990"
  replace offLabelAbsPelvis = 1 if substr(DIAG`diagNumber',1,3) == "789"
  replace offLabelUrinarySymptoms = 1 if substr(DIAG`diagNumber',1,3) == "788"
  replace offLabelCellulitisDigit = 1 if substr(DIAG`diagNumber',1,3) == "681"
  replace offLabelCystitis = 1 if substr(DIAG`diagNumber',1,3) == "595"
}


save "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace
