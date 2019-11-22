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
qui do "$output/globals.do"
import delim "$dataraw/pdr_info.csv"

//rename variable originally titled 'int' who's name didn't carry over
rename v12 interest

//give every antibiotic an easier identifying number to work with
egen abxnum = group(geneq)

//Make Variables
forval i = 2006/2016{
	gen p`i' = 0
save "$output/prescript_test.dta", replace
}

//1: ceftazidime: d00009
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script2 = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d00009"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d00009" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d00009"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 1
	mat drop script
	save "$output/prescript_test.dta", replace
}

//2: ciplofloxacin: d00011
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d00011"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d00011" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d00011"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 2
	mat drop script
	save "$output/prescript_test.dta", replace
}

//3: cefotetan: d00055
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d00055"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d00055" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d00055"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 3
	mat drop script
	save "$output/prescript_test.dta", replace
}

//4: aztreonam: d00067
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d00067"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d00067" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d00067"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 4
	mat drop script
	save "$output/prescript_test.dta", replace
}

//5: ethambutol: d00068
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d00068"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d00068" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d00068"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 5
	mat drop script
	save "$output/prescript_test.dta", replace
}

//6: cefprozil: d00073
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d00073"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d00073" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d00073"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 7
	mat drop script
	save "$output/prescript_test.dta", replace
}

//7: clarithromycin: d00097
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d00097"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d00097" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d00097"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 7
	mat drop script
	save "$output/prescript_test.dta", replace
}

//8: ofloxacin: d00114
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d00114"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d00114" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d00114"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 8
	mat drop script
	save "$output/prescript_test.dta", replace
}

//9: sulfamethoxazol/trim: d00119
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d00119"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d00119" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d00119"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 9
	mat drop script
	save "$output/prescript_test.dta", replace
}

//10: lincomycin: d00279
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d00279"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d00279" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d00279"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 10
	mat drop script
	save "$output/prescript_test.dta", replace
}

//11: moxifloxacin: d01196
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d01196"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d01196" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d01196"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 11
	mat drop script
	save "$output/prescript_test.dta", replace
}

//12 mupirocin: d01267
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d01267"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d01267" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d01267"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 12
	mat drop script
	save "$output/prescript_test.dta", replace
}

//13: amikacin: d01405
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d01405"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d01405" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d01405"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 13
	mat drop script
	save "$output/prescript_test.dta", replace
}

//14: amoxicillin: d01630
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d01630"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d01630" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d01630"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 14
	mat drop script
	save "$output/prescript_test.dta", replace
}

//15: meropenem: d02077
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d02077"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d02077" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d02077"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 15
	mat drop script
	save "$output/prescript_test.dta", replace
}

//16: gatifloxacin: d02102
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d02102"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d02102" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d02102"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 16
	mat drop script
	save "$output/prescript_test.dta", replace
}

//17: sulfanilamide: d02805
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d02805"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d02805" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d02805"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 17
	mat drop script
	save "$output/prescript_test.dta", replace
}

//18: cefdinir: d03283
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d03283"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d03283" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d03283"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 18
	mat drop script
	save "$output/prescript_test.dta", replace
}

//19: linezolid: d03368
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d03368"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d03368" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d03368"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 19
	mat drop script
	save "$output/prescript_test.dta", replace
}

//20: bacitracin: d03410
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d03410"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d03410" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d03410"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 20
	mat drop script
	save "$output/prescript_test.dta", replace
}

//21: cefepime: d03882
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d03882"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d03882" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d03882"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 21
	mat drop script
	save "$output/prescript_test.dta", replace
}

//22: levofloxacin: d04109
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d04109"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d04109" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d04109"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 22
	mat drop script
	save "$output/prescript_test.dta", replace
}

//23: ertapenem: d04586
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d04586"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d04586" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d04586"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 23
	mat drop script
	save "$output/prescript_test.dta", replace
}

//24: telithromycin: d04586
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d04586"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d04586" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d04586"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 24
	mat drop script
	save "$output/prescript_test.dta", replace
}

//25: tinidazole: d04935
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d04935"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d04935" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d04935"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 25
	mat drop script
	save "$output/prescript_test.dta", replace
}

//26: colistin: d05284
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d05284"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d05284" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d05284"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 26
	mat drop script
	save "$output/prescript_test.dta", replace
}

//27: cefadroxil: d05983
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d05983"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d05983" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d05983"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 27
	mat drop script
	save "$output/prescript_test.dta", replace
}

//28: cefazolin: d05995
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d05995"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d05995" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d05995"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 28
	mat drop script
	save "$output/prescript_test.dta", replace
}

//29: cefuroxime: d06162
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d06162"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d06162" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d06162"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 29
	mat drop script
	save "$output/prescript_test.dta", replace
}

//30: daptomycin: d06229
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d06229"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d06229" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d06229"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 30
	mat drop script
	save "$output/prescript_test.dta", replace
}

//31: oxacillin: d06963
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d06963"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d06963" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d06963"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 31
	mat drop script
	save "$output/prescript_test.dta", replace
}

//32: dapsone: d08440
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d08440"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d08440" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d08440"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 32
	mat drop script
	save "$output/prescript_test.dta", replace
}

//33: dicloxacillin: d09433
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d09433"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d09433" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d09433"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 33
	mat drop script
	save "$output/prescript_test.dta", replace
}

//34: polymyxin B: d10231
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d10231"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d10231" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d10231"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 34
	mat drop script
	save "$output/prescript_test.dta", replace
}

//35: doxycycline: d10355
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d10355"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d10355" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d10355"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 35
	mat drop script
	save "$output/prescript_test.dta", replace
}

//36: doripenem: d10444
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d10444"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d10444" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d10444"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 36
	mat drop script
	save "$output/prescript_test.dta", replace
}

//37: erythromycin: d11665
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d11665"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d11665" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d11665"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 37
	mat drop script
	save "$output/prescript_test.dta", replace
}

//38: fosfomycin: d13156
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d13156"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d13156" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d13156"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 38
	mat drop script
	save "$output/prescript_test.dta", replace
}

//39: gentamicin: d13320
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d13320"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d13320" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d13320"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 39
	mat drop script
	save "$output/prescript_test.dta", replace
}

//40: isoniazid: d15990
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d15990"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d15990" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d15990"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 40
	mat drop script
	save "$output/prescript_test.dta", replace
}

//41: dalbavancin: d16058
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d16058"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d16058" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d16058"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 41
	mat drop script
	save "$output/prescript_test.dta", replace
}

//42: metronidazole: d19233
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d19233"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d19233" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d19233"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 42
	mat drop script
	save "$output/prescript_test.dta", replace
}

//43: nafcillin: d20175
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d20175"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d20175" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d20175"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 43
	mat drop script
	save "$output/prescript_test.dta", replace
}

//44: neomycin: d20690
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d20690"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d20690" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d20690"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 44
	mat drop script
	save "$output/prescript_test.dta", replace
}

//45: nitrofurantoin: d21145
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d21145"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d21145" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d21145"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 45
	mat drop script
	save "$output/prescript_test.dta", replace
}

//46: penicillin V: d23225
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d23225"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d23225" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d23225"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 46
	mat drop script
	save "$output/prescript_test.dta", replace
}

//47: pyrazinamide: d25800
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d25800"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d25800" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d25800"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 47
	mat drop script
	save "$output/prescript_test.dta", replace
}

//48: streptomycin: d29656
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d29656"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d29656" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d29656"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 48
	mat drop script
	save "$output/prescript_test.dta", replace
}

//49: sulfadiazine: d29825
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d29825"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d29825" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d29825"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 49
	mat drop script
	save "$output/prescript_test.dta", replace
}

//50: tetracycline: d31045
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d31045"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d31045" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d31045"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 50
	mat drop script
	save "$output/prescript_test.dta", replace
}

//51: ticarcillin: d31650
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d31650"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d31650" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d31650"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 51
	mat drop script
	save "$output/prescript_test.dta", replace
}

//52: tobramycin: d31725
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d31725"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d31725" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d31725"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 52
	mat drop script
	save "$output/prescript_test.dta", replace
}

//53: vancomycin: d33588
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d33588"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d33588" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d33588"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 53
	mat drop script
	save "$output/prescript_test.dta", replace
}

//54: piperacillin: d61185
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d61185"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d61185" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d61185"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 54
	mat drop script
	save "$output/prescript_test.dta", replace
}

//55: clindamycin: d89018
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d89018"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d89018" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d89018"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 55
	mat drop script
	save "$output/prescript_test.dta", replace
}

//56: ceftriaxone: d91069
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d91069"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d91069" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d91069"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 56
	mat drop script
	save "$output/prescript_test.dta", replace
}

//57: ampicillin: d92004
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d92004"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d92004" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d92004"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 57
	mat drop script
	save "$output/prescript_test.dta", replace
}

//58: cefaclor: d92109
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d92109"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d92109" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d92109"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 58
	mat drop script
	save "$output/prescript_test.dta", replace
}

//59: cefixime: d92110
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d92110"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d92110" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d92110"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 59
	mat drop script
	save "$output/prescript_test.dta", replace
}

//60: azithromycin: d93214
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d93214"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d93214" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d93214"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 60
	mat drop script
	save "$output/prescript_test.dta", replace
}

//61: rifabutin: d93246
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d93246"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d93246" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d93246"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 61
	mat drop script
	save "$output/prescript_test.dta", replace
}

//62 cefotaxmime: d93303
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d93303"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d93303" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d93303"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 3
	mat drop script
	save "$output/prescript_test.dta", replace
}

//63: pyrimethamine: d94102
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d94102"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d94102" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d94102"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 63
	mat drop script
	save "$output/prescript_test.dta", replace
}

//64: cefpodoxime: d94139
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d94139"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d94139" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d94139"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 64
	mat drop script
	save "$output/prescript_test.dta", replace
}

//65 penicillin G: d64146
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d64146"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d64146" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d64146"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 65
	mat drop script
	save "$output/prescript_test.dta", replace
}

//66: ethionamide: d95193
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d95193"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d95193" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d95193"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 66
	mat drop script
	save "$output/prescript_test.dta", replace
}

//67: rifapentine: d96034
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d96034"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d96034" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d96034"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 67
	mat drop script
	save "$output/prescript_test.dta", replace
}

//68: cilastatin: d96149
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d96149"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d96149" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d96149"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 68
	mat drop script
	save "$output/prescript_test.dta", replace
}

//69: ceftibuten: d97001
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d97001"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d97001" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d97001"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 69
	mat drop script
	save "$output/prescript_test.dta", replace
}

//70: capreomycin: d97071
qui forval i = 2006/2016{
	use "$dataraw\namcs`i'-stata.dta", replace
	gen script = 0
	if `i' >= 2006 & `i' < 2012{
		forval k = 1/8{
			replace script = 1 if DRUGID`k' == "d97071"
		}
	}
	else if `i' == 2012 | `i' == 2013{
		forval k = 1/9{
			replace script = 1 if DRUGID`k' == "d97071" 
		}
	}
	else {
		forval k = 1/30{
			replace script = 1 if DRUGID`k' == "d97071"
		}
	}
	total script
	mat script = e(b)
	drop script
	use "$output/prescript_test.dta", replace
	replace p`i' = script[1,1] if abxnum == 70
	mat drop script
	save "$output/prescript_test.dta", replace
}

