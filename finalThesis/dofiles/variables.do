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
global output = "$projects/finalThesis"
global dofiles = "economics/maclem/finalThesis/dofiles"

// Dataset
use "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace

// Controls
global controls = "i.YEAR i.VMONTH i.SEX i.payRecode i.PHYSASST i.RNLPN i.OTHPROV i.REGION i.RACER"

global intControls = "i.YEAR i.VMONTH o0.genericOn#i.SEX o0.genericOn#i.o5.payRecode genericOn#i.PHYSASST genericOn#i.RNLPN genericOn#i.OTHPROV genericOn#i.REGION o0.genericOn#o1.i.RACER genericOn#c.AGE genericOn#c.ageSQ"

// Diagnosis Categories
global daigCats = "infAndPara neoplasm endoNutMeta bloodAndBloodOrgans mental nervousSystem circSystem respSystem digSystem genSystem pregAndChildBirth skinAndSubCut muscAndConnect congenitalAnomaly newborn illDefined injAndPoison suppFactors"

global intDiagCats = "genericOn#infAndPara genericOn#neoplasm genericOn#endoNutMeta genericOn#bloodAndBloodOrgans genericOn#mental genericOn#nervousSystem genericOn#circSystem genericOn#respSystem genericOn#digSystem genericOn#genSystem genericOn#pregAndChildBirth genericOn#skinAndSubCut genericOn#muscAndConnect genericOn#congenitalAnomaly genericOn#newborn genericOn#illDefined genericOn#injAndPoison genericOn#suppFactors genericOn#general"

global specDiags = "travelersDiarrhea urinaryTractInfection earInfection chronicBronchitis shigellosis pneumonia listeria nocardia salmonella paracoccidioides melioidoisis burkholderia stenotrophomonas cyclospora isospora whipplesDisease toxoplasmosis mrsaSkinInfection"

gen inttravelersDiarrhea = genericOn*travelersDiarrhea
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

global intSpecDiags = "inttravelersDiarrhea inturinaryTractInfection intearInfection intchronicBronchitis intshigellosis intpneumonia intlisteria intbrucella intnocardia intsalmonella intparacoccidioides intmelioidoisis intburkholderia intstenotrophomonas intcyclospora intisospora intwhipplesDisease inttoxoplasmosis intmrsaSkinInfection"

global unSpecDiags = "genDigestiveSystem urinaryDisorders diseasesOfEar chronichPulmonaryDiseases intenstinalInfectiousDiseases pneumoniaAndInfluenza otherBacterialDiseases blastomycoticInfection zoonoticBactDiseases lymphosarcoma otherInfectionsAndParaDiseases unspecBacterialInfections"

gen intGenDigestiveSystem = genericOn*genDigestiveSystem
gen intUrinaryDisorders = genericOn*urinaryDisorders
gen intDiseasesOfEar = genericOn*diseasesOfEar
gen intChronichPulmonaryDiseases = genericOn*chronichPulmonaryDiseases
gen intIntenstinalInfectiousDiseases = genericOn*intenstinalInfectiousDiseases
gen intPneumoniaAndInfluenza = genericOn*pneumoniaAndInfluenza
gen intOtherBacterialDiseases = genericOn*otherBacterialDiseases
gen intBlastomycoticInfection = genericOn*blastomycoticInfection
gen intZoonoticBactDiseases = genericOn*zoonoticBactDiseases
gen intLlymphosarcoma = genericOn*lymphosarcoma
gen intOtherInfectAndParaDiseases = genericOn*otherInfectionsAndParaDiseases
gen intUnspecBacterialInfections = genericOn*unspecBacterialInfections

global intUnSpecDiags = "intGenDigestiveSystem intUrinaryDisorders intDiseasesOfEar intChronichPulmonaryDiseases intIntenstinalInfectiousDiseases intPneumoniaAndInfluenza intOtherBacterialDiseases intBlastomycoticInfection intZoonoticBactDiseases intLlymphosarcoma intOtherInfectAndParaDiseases intUnspecBacterialInfections"

global chapters = "infAndPara neoplasm endoNutMeta bloodAndBloodOrgans mental nervousSystem circSystem respSystem digSystem genSystem pregAndChildBirth skinAndSubCutDiseases muscAndConnect congenitalAnomaly newborn signsAndSymptoms injAndPoison suppFactors general"

gen intinfAndPara = genericOn*infAndPara 
gen intneoplasm = genericOn*neoplasm 
gen intendoNutMeta = genericOn*endoNutMeta 
gen intbloodAndBloodOrgans = genericOn*bloodAndBloodOrgans 
gen intmental = genericOn*mental 
gen intnervousSystem = genericOn*nervousSystem 
gen intcircSystem = genericOn*circSystem
gen intrespSystem = genericOn*respSystem
gen intdigSystem = genericOn*digSystem
gen intgenSystem = genericOn*genSystem
gen intpregAndChildBirth = genericOn*pregAndChildBirth
gen intskinAndSubCutDiseases = genericOn*skinAndSubCutDiseases
gen intmuscAndConnect = genericOn*muscAndConnect
gen intcongenitalAnomaly = genericOn*congenitalAnomaly
gen intnewborn = genericOn*newborn
gen intsignsAndSymptoms = genericOn*signsAndSymptoms
gen intinjAndPoison = genericOn*injAndPoison
gen intsuppFactors = genericOn*suppFactors
gen intgeneral = genericOn*general

global intChapters = "intinfAndPara intneoplasm intendoNutMeta intbloodAndBloodOrgans intmental intnervousSystem intcircSystem intrespSystem intdigSystem intgenSystem intpregAndChildBirth intskinAndSubCutDiseases intmuscAndConnect intcongenitalAnomaly intnewborn intsignsAndSymptoms intinjAndPoison intsuppFactors intgeneral"

save "$output/NAMCSPanelSulfamethoxazoleTinidazoleComp.dta", replace

global offLabelDiags = "offLabelUnspecCellandAbscess offLabelUTI offLabelAbsPelvis offLabelUrinarySymptoms offLabelCellulitisDigit offLabelCystitis"

gen intOffLabelUnspecCellandAbscess = offLabelUnspecCellandAbscess*genericOn
gen intOffLabelUTI = offLabelUTI*genericOn
gen intOfLabelAbsPelvis = offLabelAbsPelvis*genericOn
gen intOffLabelUrinarySymptoms = offLabelUrinarySymptoms*genericOn
gen intOffLabelCellulitisDigit = offLabelCellulitisDigit*genericOn
gen intOffLabelCystitis= offLabelCystitis*genericOn


global intOffLabelDiags = "intOffLabelUnspecCellandAbscess intOffLabelUTI intOfLabelAbsPelvis intOffLabelUrinarySymptoms intOffLabelCellulitisDigit intOffLabelCystitis"
