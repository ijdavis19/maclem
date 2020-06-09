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

// Dataset
use "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace

gen rand = uniform() < .3

// Controls
global controls = "i.VMONTH i.PAYPRIV i.PAYMCARE i.PAYMCAID i.PAYSELF i.PAYNOCHG i.PAYOTH i.PHYSASST i.RNLPN i.OTHPROV i.REGION i.RACER"

global intControls = "genericOn#i.VMONTH genericOn#i.PAYPRIV genericOn#i.PAYMCARE genericOn#i.PAYMCAID genericOn#i.PAYSELF genericOn#i.PAYNOCHG genericOn#i.PAYOTH genericOn#i.PHYSASST genericOn#i.RNLPN genericOn#i.OTHPROV genericOn#i.REGION genericOn#i.RACER"

// Diagnosis Categories
global daigCats = "infAndPara neoplasm endoNutMeta bloodAndBloodOrgans mental nervousSystem circSystem respSystem digSystem genSystem pregAndChildBirth skinAndSubCut muscAndConnect congenitalAnomaly newborn illDefined injAndPoison suppFactors general"

global intDiagCats = "genericOn#infAndPara genericOn#neoplasm genericOn#endoNutMeta genericOn#bloodAndBloodOrgans genericOn#mental genericOn#nervousSystem genericOn#circSystem genericOn#respSystem genericOn#digSystem genericOn#genSystem genericOn#pregAndChildBirth genericOn#skinAndSubCut genericOn#muscAndConnect genericOn#congenitalAnomaly genericOn#newborn genericOn#illDefined genericOn#injAndPoison genericOn#suppFactors genericOn#general"

global relDiags = "travelerDiarrhea urinaryTractInfection earInfection chronicBronchitis shigellosis pneumonia listeria nocardia salmonella paracoccidioides melioidoisis burkholderia stenotrophomonas cyclospora isospora whipplesDisease toxoplasmosis mrsaSkinInfection generalSkinInfection"

gen inttravelerDiarrhea = genericOn*travelerDiarrhea
gen inturinaryTractInfection = genericOn*urinaryTractInfection
gen intearInfection = genericOn*earInfection
gen intchronicBronchitis = genericOn*chronicBronchitis
gen intshigellosis = genericOn*shigellosis
gen intpneumonia = genericOn*pneumonia
gen intlisteria = genericOn*listeria
gen intbrucella = genericOn*brucella
gen intnocardia = genericOn*nocardia
gen intsalmonella = genericOn*salmonella
gen intparacoccidioides = genericOn*paracoccidioides
gen intmelioidoisis = genericOn*melioidoisis
gen intburkholderia = genericOn*burkholderia
gen intstenotrophomonas = genericOn*stenotrophomonas
gen intcyclospora = genericOn*cyclospora
gen intisospora = genericOn*isospora
gen intwhipplesDisease = genericOn*whipplesDisease
gen inttoxoplasmosis = genericOn*toxoplasmosis
gen intmrsaSkinInfection = genericOn*mrsaSkinInfection
gen intgeneralSkinInfection = genericOn*generalSkinInfection

global intRelDiags = "inttravelerDiarrhea inturinaryTractInfection intearInfection intchronicBronchitis intshigellosis intpneumonia intlisteria intbrucella intnocardia intsalmonella intparacoccidioides intmelioidoisis intburkholderia intstenotrophomonas intcyclospora intisospora intwhipplesDisease inttoxoplasmosis intmrsaSkinInfection intgeneralSkinInfection"

foreach diag in $relDiags {
    tab prescriptionIndicator if `diag' == 1
}


// tab prescr if travelerDiarrhea == 0 & urinaryTractInfection == 0 & earInfection == 0 & chronicBronchitis == 0 & shigellosis == 0 & pneumonia == 0 & listeria == 0 & brucella == 0 & nocardia == 0 & salmonella == 0 & paracoccidioides == 0 & melioidoisis == 0 & burkholderia == 0 & stenotrophomonas == 0 & cyclospora == 0 & isospora == 0 & whipplesDisease == 0 & toxoplasmosis == 0 & mrsaSkinInfection == 0 & generalSkinInfection


reg prescriptionIndicator $controls $intControls genericOn $relDiags $intRelDiags [pweight = PATWT]

// logit rand $controls $intControls $relDiags $intRelDiags

// probit rand $controls $intControls $relDiags $intRelDiags


