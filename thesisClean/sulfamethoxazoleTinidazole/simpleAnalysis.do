// Set environmet variables
global projects: env projects
global storage: env storage

// General locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace // Relevant Visit Dataset

// The simplest possible regression [No slope, no controls]
reg prescriptionIndicator if genericOn == 0 // constant: .0105486
reg prescriptionIndicator if genericOn == 1 // constant: .0205407
reg prescriptionIndicator genericOn [w = PATWT] // Regression 1: .0205407 - .0105486 = .0099921

/*
// Add monthly slopes [already have a monthsAfterGeneric variable so we only need to adjust that]
qui gen monthsBeforeGeneric = monthsAfterGeneric
qui replace monthsBeforeGeneric = 0 if monthsAfterGeneric > 0
qui replace monthsBeforeGeneric = abs(monthsBeforeGeneric)
qui replace monthsAfterGeneric = 0 if monthsAfterGeneric < 0
qui reg prescriptionIndicator monthsBeforeGeneric if genericOn == 0 // constant: .0168534
qui reg prescriptionIndicator monthsAfterGeneric if genericOn == 1 // constant: .026218
reg prescriptionIndicator monthsBeforeGeneric monthsAfterGeneric genericOn // Regession 2: .0168534 - .026218 = .0093646
*/
// Better Month Slopes
gen GOmonthsAfter = genericOn*monthsAfterGeneric
reg prescriptionIndicator monthsAfterGeneric GOmonthsAfter genericOn [w = PATWT]

/*
// Add month indicators
reg prescriptionIndicator i.VMONTH genericOn
sum prescriptionIndicator if VMONTH == 1 & genericOn == 0
*/

// Add Payment Indicators
gen GOpayRecode = genericOn*payRecode
label values GOpayRecode PAYCODE
reg prescriptionIndicator monthsAfterGeneric GOmonthsAfter o5.i.payRecode o5.i.GOpayRecode genericOn [w = PATWT]


// Make seasonal indicators
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
sum prescriptionIndicator if season == 0 & genericOn == 0 // .0091542
sum prescriptionIndicator if season == 0 & genericOn == 1 // .0163506
reg prescriptionIndicator monthsAfterGeneric GOmonthsAfter o5.i.payRecode o5.i.GOpayRecode i.season i.GOseason genericOn [w = PATWT] // .0163506 - .0091542 = .0071964
/*
qui forval x = 0/3 {
  sum prescriptionIndicator if genericOn == 0 & season == `x'
  local pre`x'mean = r(mean)
  sum prescriptionIndicator if genericOn == 1 & season == `x'
  local post`x'mean = r(mean)
}
forval x = 0/3 {
  local diff`x' = `post`x'mean' - `pre`x'mean'
  display `diff`x''
}
*/

// Include Gender, Race, Age, Age^2 and Region
gen GOsex = SEX*genericOn
label values GOsex SEXF
gen GOrace = RACER*genericOn
label values GOrace RACERF
gen GOregion = REGION*genericOn
label value GOregion REGIONF
gen GOage = genericOn*AGE
gen GOageSQ = genericOn*ageSQ
sum prescriptionIndicator if season == 0 & SEX == 1 & RACER == 1 & REGION == 1 & genericOn == 0
sum prescriptionIndicator if season == 0 & SEX == 1 & RACER == 1 & REGION == 1 & genericOn == 1
reg prescriptionIndicator monthsAfterGeneric GOmonthsAfter age GOage ageSQ GOageSQ o5.i.payRecode o5.i.GOpayRecode i.season i.GOseason o1.i.SEX o1.i.GOsex i.RACER o1.i.GOrace i.REGION o1.i.GOregion genericOn [w = PATWT]


// Adding On Label Designation
global specDiags = "travelersDiarrhea urinaryTractInfection earInfection chronicBronchitis shigellosis pneumonia listeria nocardia salmonella paracoccidioides melioidoisis burkholderia stenotrophomonas cyclospora isospora whipplesDisease toxoplasmosis mrsaSkinInfection"
gen onLabel = 0
foreach diag in $specDiags {
  replace onLabel = 1 if `diag' == 1
}
gen intOnLabel = onLabel*genericOn
// reg prescriptionIndicator  i.season i.intSeason o1.i.SEX o1.i.intSex i.RACER o1.i.intRace i.REGION o1.i.intRegion onLabel intOnLabel genericOn [w = PATWT]
gen offLabel = 0
replace offLabel = 1 if onLabel == 0
gen GOoffLabel = genericOn*offLabel
reg prescriptionIndicator monthsAfterGeneric GOmonthsAfter ageSQ GOageSQ o5.i.payRecode o5.i.GOpayRecode i.season i.GOseason i.SEX o1.i.GOsex i.RACER o1.i.GOrace offLabel GOoffLabel genericOn [w = PATWT]

// Specific Off Label Infections
global offLabelDiags = "offLabelUnspecCellandAbscess offLabelUTI offLabelAbsPelvis offLabelUrinarySymptoms offLabelCellulitisDigit offLabelCystitis"

gen GOoffLabelCellandAbscess = offLabelUnspecCellandAbscess*genericOn
gen GOoffLabelUTI = offLabelUTI*genericOn
gen GOoffLabelAbsPelvis = offLabelAbsPelvis*genericOn
gen GOoffLabelUrinarySymptoms = offLabelUrinarySymptoms*genericOn
gen GOoffLabelCellulitisDigit = offLabelCellulitisDigit*genericOn
gen GOoffLabelCystitis= offLabelCystitis*genericOn

global intOffLabelDiags = "GOoffLabelCellandAbscess GOoffLabelUTI GOoffLabelAbsPelvis GOoffLabelUrinarySymptoms GOoffLabelCellulitisDigit GOoffLabelCystitis"

global globalDiagnoses = "$offLabelDiags $specDiags"

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
reg prescriptionIndicator monthsAfterGeneric GOmonthsAfter ageSQ GOageSQ o5.i.payRecode o5.i.GOpayRecode i.season i.GOseason i.SEX o1.i.GOsex i.RACER o1.i.GOrace $offLabelDiags $intOffLabelDiags otherOffLabel GOotherOffLabel genericOn [w = PATWT]

