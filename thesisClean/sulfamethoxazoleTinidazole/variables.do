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
global controls = "i.YEAR i.VMONTH i.payRecode i.PHYSASST i.RNLPN i.OTHPROV i.REGION i.RACER i.AGER"

global intControls = "i.YEAR i.VMONTH genericOn#i.payRecode genericOn#i.PHYSASST genericOn#i.RNLPN genericOn#i.OTHPROV genericOn#i.REGION genericOn#i.RACER genericOn#i.AGER"

// Diagnosis Categories
global daigCats = "infAndPara neoplasm endoNutMeta bloodAndBloodOrgans mental nervousSystem circSystem respSystem digSystem genSystem pregAndChildBirth skinAndSubCut muscAndConnect congenitalAnomaly newborn illDefined injAndPoison suppFactors general"

global intDiagCats = "genericOn#infAndPara genericOn#neoplasm genericOn#endoNutMeta genericOn#bloodAndBloodOrgans genericOn#mental genericOn#nervousSystem genericOn#circSystem genericOn#respSystem genericOn#digSystem genericOn#genSystem genericOn#pregAndChildBirth genericOn#skinAndSubCut genericOn#muscAndConnect genericOn#congenitalAnomaly genericOn#newborn genericOn#illDefined genericOn#injAndPoison genericOn#suppFactors genericOn#general"

global specDiags = "travelersDiarrhea urinaryTractInfection earInfection chronicBronchitis shigellosis pneumonia listeria nocardia salmonella paracoccidioides melioidoisis burkholderia stenotrophomonas cyclospora isospora whipplesDisease toxoplasmosis mrsaSkinInfection "

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

global unSpecDiags = "genDigestiveSystem urinaryDisorders diseasesOfEar chronichPulmonaryDiseases intenstinalInfectiousDiseases pneumoniaAndInfluenza otherBacterialDiseases blastomycoticInfection zoonoticBactDiseases lymphosarcoma otherInfectionsAndParaDiseases unspecBacterialInfections generalSkinInfection"

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
gen intGeneralSkinInfection = genericOn*generalSkinInfection

global intUnSpecDiags = "intGenDigestiveSystem intUrinaryDisorders intDiseasesOfEar intChronichPulmonaryDiseases intIntenstinalInfectiousDiseases intPneumoniaAndInfluenza intOtherBacterialDiseases intBlastomycoticInfection intZoonoticBactDiseases intLlymphosarcoma intOtherInfectAndParaDiseases intUnspecBacterialInfections intGeneralSkinInfection"

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

