*define 'antibiotics of interest' antibiotics that saw first generic entry into the market during the window of time data is available (2006-2016)
//generate variable to determine how closely related antibiotics of interest are with other antibiotics
	//for each antibiotic `y'
		gen x_to_y_rel=0
		//iterate through indicators
		//for each similar indicator
			x_to_y_rel= x_to_y_rel + 1*(possible weight)
		//itereate through ABx classifications
		//for each similar ABx classification
			x_to_y_rel= x_to_y_rel + 1*(possible weight)

//we now should be left with a metric for how closely related our antibiotics of interest

//create an arbitrary cutoff to determine if two antibiotics are 'close substitutes' called `k'
	gen xsub=0
	//for each antibiotic of interest x
		//for each antibiotic y that that is not x
		replace xsub=1 if x_to_y_rel >= k
