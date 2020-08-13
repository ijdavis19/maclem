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

// Append NAMCS Data and Flag Prescriptions
do "$dofiles/dataCreation.do"

// Convert ICD values
do "$dofiles/icdConverter.do"

// Create dummies for named diagnoses the drug fights against
do "$dofiles/icdDiags.do"

// Create dummies for more general sections where the drug can be used
do "$dofiles/icdSections.do"

// Create dummies for chapters of ICD book
// Code halts
do "$dofiles/icdChapters.do"

// Assign Variables for Covariates
do "$dofiles/variables.do"

// Save dataset
save "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace

// Make Analysis Variables
do "$dofiles/slopedAnalysis.do"

// Tables 
do "$dofiles/tables.do"
