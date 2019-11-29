clear all
set obs 1
forval i = 1/10{
	local p`i' = "boop"
	gen v`i' = "base test value"
	display "`p`i''"
	local t`i' = v`i'
	display "`t`i''"
}
