// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/finalThesis"
global dofiles = "economics/maclem/finalThesis/dofiles"

use "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace // Relevant Visit Dataset

// Simple, no slope regression
reg prescriptionIndicator genericOn [w = PATWT]

// Add On Label Base
global specDiags = "travelersDiarrhea urinaryTractInfection earInfection chronicBronchitis shigellosis pneumonia listeria nocardia salmonella paracoccidioides melioidoisis burkholderia stenotrophomonas cyclospora isospora whipplesDisease toxoplasmosis mrsaSkinInfection"
gen onLabel = 0
foreach diag in $specDiags {
  replace onLabel = 1 if `diag' == 1
}
gen offLabel = 0
replace offLabel = 1 if onLabel == 0
gen GOoffLabel = genericOn*offLabel
global specDiags = "travelersDiarrhea urinaryTractInfection earInfection chronicBronchitis shigellosis pneumonia listeria nocardia salmonella paracoccidioides melioidoisis burkholderia stenotrophomonas cyclospora isospora whipplesDisease toxoplasmosis mrsaSkinInfection"
reg prescriptionIndicator offLabel GOoffLabel genericOn [w = PATWT]

// Add Monthly Slopes
gen GOmonthsAfter = genericOn*monthsAfterGeneric
gen OFmonthsAfter = offLabel*monthsAfterGeneric
gen OFGOmonthsAfter = GOmonthsAfter*OFmonthsAfter
reg prescriptionIndicator monthsAfterGeneric OFmonthsAfter GOmonthsAfter OFGOmonthsAfter offLabel GOoffLabel genericOn [w = PATWT]


// Control for Payment Methods
gen GOpayRecode = genericOn*payRecode
label values GOpayRecode PAYCODE
reg prescriptionIndicator monthsAfterGeneric OFmonthsAfter GOmonthsAfter OFGOmonthsAfter offLabel GOoffLabel genericOn o5.i.payRecode o5.i.GOpayRecode [w = PATWT]

// Add Seasonal Indicators
gen season = 0 // Season which majority of days faill into 
// Winter
replace season = 0 if VMONTH == 1 | VMONTH == 2 | VMONTH == 12
// Spring
replace season = 1 if VMONTH == 3 | VMONTH == 4 | VMONTH == 5
// Summer
replace season = 2 if VMONTH == 6 | VMONTH == 7 | VMONTH == 8
// Fall
replace season = 3 if VMONTH == 9 | VMONTH == 10 | VMONTH == 11
label define SEASON 0 "Winter" 1 "Spring" 2 "Summer" 3 "Fall"
label values season SEASON
gen GOseason = season*genericOn
label values GOseason SEASON
reg prescriptionIndicator monthsAfterGeneric GOmonthsAfter o5.i.payRecode o5.i.GOpayRecode i.season i.GOseason genericOn [w = PATWT]

// Include Gender, Race, Age, Age^2, and Region
gen GOsex = SEX*genericOn
label values GOsex SEXF
gen GOrace = RACER*genericOn
label values GOrace RACERF
gen GOregion = REGION*genericOn
label value GOregion REGIONF
gen GOage = genericOn*AGE
gen GOageSQ = genericOn*ageSQ
reg prescriptionIndicator monthsAfterGeneric GOmonthsAfter OFmonthsAfter OFGOmonthsAfter age GOage ageSQ GOageSQ o5.i.payRecode o5.i.GOpayRecode i.season i.GOseason o1.i.SEX o1.i.GOsex i.RACER o1.i.GOrace i.REGION o1.i.GOregion offLabel genericOn GOoffLabel [w = PATWT]

// Specific Off Label Indications
global onLabelDiags = "travelersDiarrhea urinaryTractInfection earInfection chronicBronchitis shigellosis pneumonia listeria nocardia salmonella paracoccidioides melioidoisis burkholderia stenotrophomonas cyclospora isospora whipplesDisease toxoplasmosis mrsaSkinInfection"
global offLabelDiags = "offLabelUnspecCellandAbscess offLabelUTI offLabelAbsPelvis offLabelUrinarySymptoms offLabelCellulitisDigit offLabelCystitis"

gen GOoffLabelCellandAbscess = offLabelUnspecCellandAbscess*genericOn
gen GOoffLabelUTI = offLabelUTI*genericOn
gen GOoffLabelAbsPelvis = offLabelAbsPelvis*genericOn
gen GOoffLabelUrinarySymptoms = offLabelUrinarySymptoms*genericOn
gen GOoffLabelCellulitisDigit = offLabelCellulitisDigit*genericOn
gen GOoffLabelCystitis= offLabelCystitis*genericOn

global globalDiagnoses = "$offLabelDiags $onLabelDiags"

gen placeHolder = 0
gen otherOffLabel = 0
forval x = 1/5 {
  foreach diagnosis in $globalDiagnoses {
    replace placeHolder = 1 if `diagnosis' == 1
  }
  replace otherOffLabel = 1 if placeHolder == 0
  replace placeHolder = 0
}
gen GOotherOffLabel = genericOn*otherOffLabel
reg prescriptionIndicator monthsAfterGeneric GOmonthsAfter ageSQ GOageSQ o5.i.payRecode o5.i.GOpayRecode i.season i.GOseason i.SEX o1.i.GOsex i.RACER o1.i.GOrace offLabelUnspecCellandAbscess GOoffLabelCellandAbscess offLabelUTI GOoffLabelUTI offLabelAbsPelvis GOoffLabelAbsPelvis offLabelUrinarySymptoms GOoffLabelUrinarySymptoms offLabelCellulitisDigit GOoffLabelCellulitisDigit offLabelCystitis GOoffLabelCystitis otherOffLabel GOotherOffLabel genericOn [w = PATWT]

// doxy or clindamycin usually prescribed for unspec skin infection
save "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace
