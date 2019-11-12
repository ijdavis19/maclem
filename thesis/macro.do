clear all
set obs 1
forval i = 1/30{
	global p`i' = "boop"
	gen v`i' = "beep"
}

forval i = 6/7{
	replace v`i' = "$p"
}
