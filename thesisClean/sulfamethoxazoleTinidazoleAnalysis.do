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
global dofiles = "economics/maclem/thesisClean"

// Dataset
use "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace

gen rand = uniform() < .3

// Controls
global controls = "i.VMONTH i.PAYPRIV i.PAYMCARE i.PAYMCAID i.PAYSELF i.PAYNOCHG i.PAYOTH i.PHYSASST i.RNLPN i.OTHPROV i.REGION i.RACER"

global intControls = "genericOn#i.VMONTH genericOn#i.PAYPRIV genericOn#i.PAYMCARE genericOn#i.PAYMCAID genericOn#i.PAYSELF genericOn#i.PAYNOCHG genericOn#i.PAYOTH genericOn#i.PHYSASST genericOn#i.RNLPN genericOn#i.OTHPROV genericOn#i.REGION genericOn#i.RACER"

// Diagnosis Categories
global daigCats = "infAndPara neoplasm endoNutMeta bloodAndBloodOrgans mental nervousSystem circSystem respSystem digSystem genSystem pregAndChildBirth skinAndSubCut muscAndConnect congenitalAnomaly newborn illDefined injAndPoison suppFactors general"

global intDiagCats = "genericOn#infAndPara genericOn#neoplasm genericOn#endoNutMeta genericOn#bloodAndBloodOrgans genericOn#mental genericOn#nervousSystem genericOn#circSystem genericOn#respSystem genericOn#digSystem genericOn#genSystem genericOn#pregAndChildBirth genericOn#skinAndSubCut genericOn#muscAndConnect genericOn#congenitalAnomaly genericOn#newborn genericOn#illDefined genericOn#injAndPoison genericOn#suppFactors genericOn#general"

global testVars "i.VMONTH genericOn genericOn"

ma list 

reg rand $controls $intControls $diagCats $intDiagCats

logit rand $controls $intControls $diagCats $intDiagCats

probit rand $controls $intControls $diagCats $intDiagCats
