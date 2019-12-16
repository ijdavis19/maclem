* demowgtsmarital.do  12/31/07
* weights for marital groups, based on 1975-9 and 1995-9 pooled

use demowgtsfixed, clear
replace widowed = 0
replace divorced = 0
replace separated = 0
replace nevermarried = 0

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

replace widowed = 1 if syntheticobs==1
replace divorced = 1 if syntheticobs==2
replace separated = 1 if syntheticobs==3
replace nevermarried = 1 if syntheticobs==4
sort female syntheticobs
drop syntheticobs
save demowgtsmarital, replace
