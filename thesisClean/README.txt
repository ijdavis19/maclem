The purpose of this directory is to unfuck the maclem/thesis directory
starting from the very beginning and creating the NAMCS panel first.

	panelDataCreation.do


After the panel is created, we also want to create the data from the 
drug information csv file.

	drugInformationDatasetCreation

We then perform the following for all of our drugs of interest
	1. Create the indicator variable for if the drug was prescribed or not
	2. Determine relevant diagnoses
	3. Create a seperate dataset of just those visits
	4. Pray that it is less than 229,000


Actual Order of do compilation
	1. pdr_cleaner.do
		fixes some of the pdr information and creates the pdr_cleaned.dta
	2. 