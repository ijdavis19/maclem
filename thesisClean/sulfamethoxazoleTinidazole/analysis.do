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


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace

gen specDiagTest = 0
foreach diag in $specDiags {
    replace specDiagTest = 1 if `diag' == 1
}
tab prescriptionIndicator if specDiagTest == 0
gen intSpecDiagTest = genericOn*specDiagTest

gen unSpecDiagTest = 0
foreach diag in $unspecDiags{ 
    replace unSpecDiagTest = 1 if `diag' == 1
}
tab prescriptionIndicator if unSpecDiagTest == 0
gen intUnSpecDiagTest = genericOn*unSpecDiagTest


gen chapterTest = 0
foreach diag in $chapters{ 
    replace chapterTest = 1 if `diag' == 1
}
tab prescriptionIndicator if chapterTest == 0
gen intChapterTest = genericOn*chapterTest



/*
reg prescriptionIndicator $intControls specDiagTest genericOn intSpecDiagTest [pweight = PATWT]

reg prescriptionIndicator $intControls unSpecDiagTest genericOn intUnSpecDiagTest [pweight = PATWT]

reg prescriptionIndicator $intControls chapterTest genericOn intChapterTest [pweight = PATWT]

reg prescriptionIndicator $intControls $specDiags genericOn $intSpecDiags [pweight = PATWT]

reg prescriptionIndicator $intControls $unSpecDiags genericOn $intUnspecDiags [pweight = PATWT]

reg prescriptionIndicator $intControls $chapters genericOn $intChapters [pweight = PATWT]
*/