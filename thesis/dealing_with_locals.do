clear all
set obs 1
forval i = 1/30{
	local p`i' = "boop"
	gen v`i' = "base test value"
	display "`p`i''"
}

foreach variable in local{
	display variable
}
