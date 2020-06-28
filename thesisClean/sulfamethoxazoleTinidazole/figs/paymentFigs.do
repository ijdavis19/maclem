// Set environmental variables
global projects: env projects
global storage: env storage

// General locations
global dataraw = "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibioticsCleaned"
global dofiles = "economics/maclem/thesisClean/sulfamethoxazoleTinidazole"

use "$output/NAMCSPanelSulfamethoxazoleTinidazoleCompAnalysis.dta", replace // Relevant Visit Dataset

// One regression per type of healthcare
forval x = 1/7 {
  reg prescriptionIndicator monthsAfterGeneric OFmonthsAfter GOmonthsAfter OFGOmonthsAfter offLabel GOoffLabel genericOn [w = PATWT] if payRecode == `x'
  mat list e(b)
  gen line`x'On = e(b)[1,8] + monthsAfterGeneric*e(b)[1,1] + GOmonthsAfter*e(b)[1,3] + genericOn*e(b)[1,7] 
  gen line`x'Off = e(b)[1,8] + e(b)[1,5] + monthsAfterGeneric*e(b)[1,1] + monthsAfterGeneric*e(b)[1,2] + GOmonthsAfter*e(b)[1,3] + GOmonthsAfter*e(b)[1,4] + genericOn*e(b)[1,7]
}


// Ok guess what this fucking sucks don't do this at all fuck this fuck fuck fuck fuck fuck fuck fuck
line line1On line1Off line2On line2Off line3On line3Off line4On line4Off line5On line5Off line6On line6Off line7On line7Off monthsAfterGeneric
