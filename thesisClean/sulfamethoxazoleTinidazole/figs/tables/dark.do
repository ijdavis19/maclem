//Gives everything significance and ruins everything
// Basic Table

clear all

// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"
global tables = "$dofiles/figs/tables"


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace

eststo: reg prescriptionIndicator genericOn AGE ageSQ [w = PATWT]
eststo: reg prescriptionIndicator monthsAfterGeneric GOmonthsAfter genericOn AGE ageSQ [w = PATWT]
eststo: reg prescriptionIndicator offLabel genericOn GOmonthsAfter GOoffLabel AGE ageSQ [w = PATWT]
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT]


// esttab using "$tables/uncontrolled.tex", stats(r2 N) title(Basic Model\label{tab1}) replace


// Regional Table
clear all

// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"
global tables = "$dofiles/figs/tables"


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if REGION == 1
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if REGION == 2
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if REGION == 3
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if REGION == 4
// esttab using "$tables/regions.tex", stats(r2 N) title(regions\label{tab1}) replace

// Gender Table
clear all

// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"
global tables = "$dofiles/figs/tables"


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if SEX == 1
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if SEX == 2
// esttab using "$tables/gender.tex", stats(r2 N) title(Genders\label{tab1}) replace

// Major Pay Types
clear all

// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"
global tables = "$dofiles/figs/tables"


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if payRecode == 1
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if payRecode == 2
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if payRecode == 5
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if payRecode == 6
// esttab using "$tables/majpay.tex", stats(r2 N) title(Major Payment Types\label{tab1}) replace

// Minor Pay Types
clear all

// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"
global tables = "$dofiles/figs/tables"


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if payRecode == 3
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if payRecode == 4
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if payRecode == 7
// esttab using "$tables/minpay.tex", stats(r2 N) title(Minor Payment Types\label{tab1}) replace

// Seasons
clear all

// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"
global tables = "$dofiles/figs/tables"


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if season == 0
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if season == 1
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if season == 2
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if season == 3
// esttab using "$tables/seasons.tex", stats(r2 N) title(Seasons\label{tab1}) replace

// Race
clear all

// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"
global tables = "$dofiles/figs/tables"


use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if RACER == 1
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if RACER == 2
eststo: reg prescriptionIndicator offLabel monthsAfterGeneric OFmonthsAfter GOmonthsAfter genericOn GOoffLabel OFGOmonthsAfter AGE ageSQ [w = PATWT] if RACER == 3
// esttab using "$tables/race.tex", stats(r2 N) title(Race\label{tab1}) replace