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
global output = "$projects/thesis_antibiotics"

// Import the pdr_info.csv
import delim "$dataraw/pdr_info.csv"

// Rename variable originally titled 'int' who's name didn't carry over
rename v12 interest

// Give every antibiotic an easier identifying number to work with
egen abxnum = group(geneq)

// For simplicity, drop all but 3 observations
drop if abxnum >= 4

// Replace empty classes 'null' so code will run
qui forval i = 1/7{
	replace cl`i' = "null" if cl`i' == ""
}
// Determine how many similarities exist between abx classes
qui forval i = 1/3{
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
// Generate number for each indicator of each antibiotic
bys abxnum: gen indnum=_n
