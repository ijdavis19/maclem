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
/*
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

//5: ethambutol: d00068

//6: cefprozil: d00073

//7: clarithromycin: d00097

//8: ofloxacin: d00114

//9: sulfamethoxazol/trim: d00119

//10: lincomycin: d00279

//11: moxifloxacin: d01196

//12 mupirocin: d01267

//13: amikacin: d01405

//14: amoxicillin: d01630

//15: meropenem: d02077

//16: gatifloxacin: d02102

//17: sulfanilamide: d02805

//18: cefdinir: d03283

//19: linezolid: d03368

//20: bacitracin: d03410

//21: cefotetan: d00055

//22: cefotetan: d00055

//23: cefotetan: d00055

//24: cefotetan: d00055

//25: cefotetan: d00055

//26: cefotetan: d00055

//27: cefotetan: d00055

//28: cefotetan: d00055

//29: cefotetan: d00055

//30: cefotetan: d00055

//31: cefotetan: d00055

//32: cefotetan: d00055

//33: cefotetan: d00055

//34: cefotetan: d00055

//35: cefotetan: d00055

//36: cefotetan: d00055

//37: cefotetan: d00055

//38: cefotetan: d00055

//39: cefotetan: d00055

//40: cefotetan: d00055

//41: cefotetan: d00055

//42: cefotetan: d00055

//43: cefotetan: d00055

//44: cefotetan: d00055

//45: cefotetan: d00055

//46: cefotetan: d00055

//47: cefotetan: d00055

//48: cefotetan: d00055

//49: cefotetan: d00055

//50: cefotetan: d00055

//51: cefotetan: d00055

//52: cefotetan: d00055

//53: cefotetan: d00055

//54: cefotetan: d00055

//55: cefotetan: d00055

//56: cefotetan: d00055

//57: cefotetan: d00055

//58: cefotetan: d00055

//59: cefotetan: d00055

//60: cefotetan: d00055

//61: cefotetan: d00055

//62: cefotetan: d00055

//63: cefotetan: d00055

//64 cefotetan: d00055

//65: cefotetan: d00055

//66: cefotetan: d00055

//67: cefotetan: d00055

//68: cefotetan: d00055

//69: cefotetan: d00055

//70: cefotetan: d00055

*/
