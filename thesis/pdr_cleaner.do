set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


//set environmet variables
//global projects: env projects
//global storage: env storage

//general locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"

///import the pdr_info.csv
import delim "$dataraw/pdr_info.csv"

//rename variable originally titled 'int' who's name didn't carry over
rename v12 interest
rename firstgenericappearance firstgenapp
rename genericequivalentcode  geneq

//fix generic appearance dates
gen firstgenyear = firstgenapp
gen firstgenmonth=.
replace firstgenmonth =. if drug == "amikacin"
replace firstgenmonth =. if drug == "amoxicillin"
replace firstgenmonth =. if drug == "aztreonam"
replace firstgenmonth =. if drug == "cefdinir"
replace firstgenmonth =. if drug == "cefepime"
replace firstgenmonth =. if drug == "cefotetan"
replace firstgenmonth =. if drug == "cefpodoxime"
replace firstgenmonth =. if drug == "cefproxil"
replace firstgenmonth =. if drug == "ceftazidime"
replace firstgenmonth =. if drug == "ceftibuten"
replace firstgenmonth =. if drug == "ciprofloxacin"
replace firstgenmonth =. if drug == "ethambutol"
replace firstgenmonth =. if drug == "levofloxacin"
replace firstgenmonth =. if drug == "lincomycin"
replace firstgenmonth =. if drug == "linezolid"
replace firstgenmonth =. if drug == "moxifloxacin"
replace firstgenmonth =. if drug == "muprocin"
replace firstgenmonth =. if drug == "sulfamethoxazole/trimethroprim"
replace firstgenmonth =. if drug == "tinidazole"


//fix generic equivalent codes
replace geneq = "d00087" if drug == "amikacin" //d01405
replace geneq = "d00088" if drug == "amoxicillin" //d01630
replace geneq = "d00003" if drug == "amplicillin" //d92004
replace geneq = "d00091" if drug == "azithromycin" //d93214
replace geneq = "d01115" if drug == "bacitracin" //d01115
replace geneq = "d00080" if drug == "cefadroxil" //d05983
replace geneq = "d00007" if drug == "cefazolin" //d05995
replace geneq = "d04256" if drug == "cefdinir" //d13283
replace geneq = "d00072" if drug == "cefixime" //d92110
replace geneq = "d00008" if drug == "cefotaxime" //d93303
replace geneq = "d00095" if drug == "cefpodoxime" //d94139
replace geneq = "d00052" if drug == "ceftriazone" //
replace geneq = "d00056" if drug == "cefuroxime" //
replace geneq = "d00043" if drug == "clindamycin" //
replace geneq = "d00098" if drug == "dapsone" //
replace geneq = "d00153" if drug == "dicloxacillin" //
replace geneq = "d00037" if drug == "doxycycline" //
replace geneq = "d04783" if drug == "ertapenem" //
replace geneq = "d00046" if drug == "erythromycin" //
replace geneq = "d04106" if drug == "fosfomycin"
replace geneq = "d03974" if drug == "gentamicin"
replace geneq = "d00101" if drug == "isoazid"
replace geneq = "d04534" if drug == "linezolid"
replace geneq = "d04027" if drug == "meropenem"
replace geneq = "d00108" if drug == "metronidazole"
replace geneq = "d04500" if drug == "moxifloxacin"
replace geneq = "d00312" if drug == "neomycin"
replace geneq = "d00112" if drug == "nitrofurantoin"
replace geneq = "d00116" if drug == "penicillin G"
replace geneq = "d00116" if drug == "penicillin V"
replace geneq = "d00057" if drug == "piperacillin"
replace drug = "sulfamethoxazole" if drug == "sulfamethoxazole/trimethroprim"
replace geneq = "d00041" if drug == "tetracycline"
replace geneq = "d00069" if drug == "tobramycin"
replace geneq = "d00125" if drug == "vancomycin"

save "$output/pdr_cleaned.dta", replace
