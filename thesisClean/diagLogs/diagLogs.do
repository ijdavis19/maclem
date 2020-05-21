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

// Log for Diagnoses
log using $dofiles/diagLogs/diagOne.txt, replace
tab DIAG1
log close

log using $dofiles/diagLogs/diagTwo.txt, replace
tab DIAG2
log close

log using $dofiles/diagLogs/diagThree.txt, replace
tab DIAG3
log close

log using $dofiles/diagLogs/diagFour.txt, replace
tab DIAG4
log close

log using $dofiles/diagLogs/diagFive.txt, replace
tab DIAG5
log close
