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

// Append NAMCS Data and Flag Prescriptions
qui do "$dofiles/dataCreation.do"

// Convert ICD values
qui do "$dofiles/icdConverter.do"

// Create dummies for named diagnoses the drug fights against
qui do "$dofiles/icdDiags.do"

// Create dummies for more general sections where the drug can be used
qui do "$dofiles/icdSections.do"

// Create dummies for chapters of ICD book
qui do "$dofiles/icdChapters.do"

// Assign Variables for Covariates
qui do "$dofiles/variables.do"


// Save dataset
save "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace
