set more off
clear all
set matsize 11000
set maxvar 32000
set seed 0
global bootstraps 1000


//set environmet variables
global projects: env projects
global storage: env storage

//general locations
global dataraw =  "$storage/thesis_antibiotics"
global output = "$projects/thesis_antibiotics"

///import the pdr_info.csv
import delim "$dataraw/pdr_info.csv"

//rename variable originally titled 'int' who's name didn't carry over
rename v12 interest

//give every antibiotic an easier identifying number to work with
egen abxnum = group(geneq)

//determine highest abxnum
sum abxnum
local abh = r(max)

//replace empty classes 'null' so code will run
qui forval i = 1/7{
	replace cl`i' = "null" if cl`i' == ""
}
//determine how many similarities exist between abx classes
qui forval i = 1/$_abh{
	gen grrelto`i' = 0
	forval j = 1/7 {
			levels cl`j' if abxnum == `i', local(holder)
				if $_holder != "null" {
					forval k = 1/7{
						replace grrelto`i' = grrelto`i' + 1 if cl`k' == $_holder
					}
					ma drop _holder
				}
				else {
					ma drop _holder
					}
		}
	}
//generate number for each indicator of each antibiotic
bys abxnum: gen indnum=_n

//determine how many similarities exist between abx indicators
qui forval i = 1/$_abh{
	gen indrelto`i' = 0
	sum indnum if abxnum == `i'
	local indmax1 = r(max)
	forval j = 1/$_indmax1{
		levels indicator if indnum == `j' & abxnum == `i', local(hold1)
		forval k = 1/$_abh{
			sum indnum if abxnum == `k'
			local indmax2 = r(max)
			forval z = 1/$_indmax2{
				levels indicator if indnum == `z' & abxnum == `k', local(hold2)
				if $_hold1 == $_hold2 {
					replace indrelto`i' = indrelto`i' + 1 if abxnum == `k'
					ma drop _hold2
				}
				else {
					ma drop hold2
				}
				}
			ma drop _indmax2
			}
		ma drop _hold1
		}
	ma drop _indmax1
}
drop if indnum > 1
drop indicator

save "$output/drug_relations.dta", replace
