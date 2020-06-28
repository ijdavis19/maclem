// Set environmet variables
global projects: env projects
global storage: env storage

// General locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace

gen onLabel = 0
foreach diag in $specDiags {
    replace onLabel = 1 if `diag' == 1
}
tab prescriptionIndicator if onLabel == 0
gen intOnLabel = genericOn*onLabel
gen offLabel = 0
replace offLabel = 1 if onLabel == 0
gen intOffLabel = genericOn*offLabel

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
reg prescriptionIndicator $intControls $specDiags genericOn $intSpecDiags [pweight = PATWT]

reg prescriptionIndicator $intControls genericOn onLabel intOnLabel $offLabelDiags $intOffLabelDiags [w = PATWT]
*/
