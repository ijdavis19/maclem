forval i = 1/30{
tab MED`i' if DRUGID`i' == "d97071"
}



forval i = 1/30{
tab DRUGID`i' if MED`i' == "CEFDITOREN":MEDCODF
}
