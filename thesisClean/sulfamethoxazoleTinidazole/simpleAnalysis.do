// Set environmet variables
global projects: env projects
global storage: env storage

// General locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace

// The simplest possible regression [No slope, no controls]
reg prescriptionIndicator if genericOn == 0 // constant: 0105486
reg prescriptionIndicator if genericOn == 1 // constant: 0205407
reg prescriptionIndicator genericOn // Regression 1

// Add monthly slopes [already have a monthsAfterGeneric variable so we only need to adjust that]
gen monthsBeforeGeneric = monthsAfterGeneric
replace monthsBeforeGeneric = 0 if monthsAfterGeneric > 0
replace monthsBeforeGeneric = abs(monthsBeforeGeneric)
replace monthsAfterGeneric = 0 if monthsAfterGeneric < 0
reg prescriptionIndicator monthsBeforeGeneric if genericOn == 0
reg prescriptionIndicator monthsAfterGeneric if genericOn == 1
reg prescriptionIndicator monthsBeforeGeneric monthsAfterGeneric genericOn // Regession 2

/*
// Add month indicators
reg prescriptionIndicator i.VMONTH genericOn
sum prescriptionIndicator if VMONTH == 1 & genericOn == 0
*/

// Make seasonal indicators
gen season = 0 // Season which majority of days fall into 
// Winter
replace season = 0 if VMONTH == 1 | VMONTH == 2 | VMONTH == 3
// Spring
replace season = 1 if VMONTH == 4 | VMONTH == 5 | VMONTH == 6
// Summer
replace season = 2 if VMONTH == 7 | VMONTH == 8 | VMONTH == 9
// Fall
replace season = 3 if VMONTH == 10 | VMONTH == 11 | VMONTH == 12
label define SEASON 0 "Winter" 1 "Spring" 2 "Summer" 3 "Fall"
label values season SEASON
gen intSeason = season*genericOn
label values intSeason SEASON
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

reg prescriptionIndicator i.season i.intSeason genericOn
sum prescriptionIndicator if season == 0 & genericOn == 0
sum prescriptionIndicator if season == 0 & genericOn == 1

// Include Gender, Race, and Region
gen intSex = SEX*genericOn
label values intSex SEXF
gen intRace = RACER*genericOn
label values intRace RACERF
gen intRegion = REGION*genericOn
label value intRegion REGIONF
reg prescriptionIndicator i.season i.intSeason o1.i.SEX o1.i.intSex i.RACER o1.i.intRace i.REGION o1.i.intRegion genericOn
sum prescriptionIndicator if season == 0 & SEX == 1 & RACER == 1 & REGION == 1 & genericOn == 0
sum prescriptionIndicator if season == 0 & SEX == 1 & RACER == 1 & REGION == 1 & genericOn == 1

// Adding On Label Designation
global specDiags = "travelersDiarrhea urinaryTractInfection earInfection chronicBronchitis shigellosis pneumonia listeria nocardia salmonella paracoccidioides melioidoisis burkholderia stenotrophomonas cyclospora isospora whipplesDisease toxoplasmosis mrsaSkinInfection"
gen onLabel = 0
foreach diag in $specDiags {
  replace onLabel = 1 if `diag' == 1
}
gen intOnLabel = onLabel*genericOn
reg prescriptionIndicator monthsBeforeGeneric monthsAfterGeneric i.season i.intSeason o1.i.SEX o1.i.intSex i.RACER o1.i.intRace i.REGION o1.i.intRegion onLabel intOnLabel genericOn [w = PATWT]


/*
// Years Before/After
gen yearsBeforeGeneric = floor(monthsBeforeGeneric/12)
gen yearsAfterGeneric = floor(monthsAfterGeneric/12)
reg prescriptionIndicator yearsBeforeGeneric 
reg prescriptionIndicator yearsBeforeGeneric yearsAfterGeneric genericOn
reg prescriptionIndicator i.VMONTH yearsBeforeGeneric yearsAfterGeneric genericOn

// Unspecified Skin Infection
reg prescriptionIndicator monthsBeforeGeneric monthsAfterGeneric genericOn offLabelUnspecCellandAbscess intOffLabelUnspecCellandAbscess // Regression 3
*/

