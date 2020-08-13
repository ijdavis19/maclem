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
global dofiles = "economics/maclem/finalThesis/dofiles"

use "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace


// Specific Diagnoses
gen travelersDiarrhea = 0
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


// Traveler's Diarrhea
forval diagNumber = 1/3 {
  // Traveler's Diarrhea
  replace travelersDiarrhea = 1 if real(substr(DIAG`diagNumber',1,5)) == 78791 // Diarhhea
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
}

save "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace

