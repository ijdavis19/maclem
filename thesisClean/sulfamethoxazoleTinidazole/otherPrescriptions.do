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

// Make new variable
gen otherPrescription = 0
save "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace

forval x = 1/8{
    use "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace
    drop if genericOn == 1
    drop if generalSkinInfection == 0
    bysort DRUGID`x': gen scriptCount = _n
    drop if scriptCount > 1
    gen observation = _n
    sum observation
    local uniqueScripts = r(sum)
    save "$output/temp`x'.dta"
    forval script = 1/`uniqueScripts' {
        use "$output/temp`x'.dta"
        drop if observation != `script'
        local code = DRUGID1
        use "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace
        forval y = 1/8 {
            replace otherPrescription = 1 if DRUGID`y' == "`code'" & generalSkinInfection == 1
        }
        save "$output/NAMCSPanelSulfamethoxazoleTinidazole.dta", replace
    }
    erase "$output/temp`x'.dta"
}