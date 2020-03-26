set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


//set environmet variables
global projects: env projects
global storage: env storage

//general locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"

//import the 2000-2010 data
import delim "$dataraw/st-est00int-alldata.csv"

//import the 2000-2010 data
//import delim "$dataraw/sc-est2016-alldata6.csv"

//Things are fucky so check the methods in secondaryDatasetDescriptions