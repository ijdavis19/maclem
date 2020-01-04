* demowgtssch.do  11/17/07
* weights for schooling groups, based on 1975-9 and 1995-9 pooled

use demowgtsfixed, clear
replace hsd08 = 0
replace hsd911 = 0
replace hsg = 0
replace cg = 0
replace ad = 0

save c:\junk\#tmp0001, replace
gen byte syntheticobs=1
append using c:\junk\#tmp0001
replace syntheticobs=2 if syntheticobs==.
append using c:\junk\#tmp0001
replace syntheticobs=3 if syntheticobs==.
append using c:\junk\#tmp0001
replace syntheticobs=4 if syntheticobs==.
append using c:\junk\#tmp0001
replace syntheticobs=5 if syntheticobs==.
append using c:\junk\#tmp0001
replace syntheticobs=6 if syntheticobs==.

replace hsd08 = 1 if syntheticobs==1
replace hsd911 = 1 if syntheticobs==2
replace hsg = 1 if syntheticobs==3
replace cg = 1 if syntheticobs==4
replace ad = 1 if syntheticobs==5
sort female syntheticobs
list

drop syntheticobs
save demowgtssch, replace
