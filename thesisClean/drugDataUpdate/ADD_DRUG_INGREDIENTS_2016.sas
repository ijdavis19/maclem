
/*****************************************************************
This program will add up to 6 ingredients for each medication
listed on the 2016 National Ambulatory Medical Care Survey public use 
file along with Multum's therapeutic category for each ingredient.
******************************************************************/

OPTIONS MERGENOBY=ERROR MSGLEVEL=I;

/*  NOTE: THESE PATHS WILL NEED TO CHANGE DEPENDING ON WHERE DATA AND STATEMENTS ARE
	STORED ON COMPUTER OR NETWORK. PROGRAM IS CURRENTLY SET UP TO APPLY INGREDIENTS TO 
    THE 2016 NAMCS PUBLIC USE FILE. THIS PROGRAM ASSUMES YOU ARE USING THE SAS INPUT STATEMENTS 
    AVAILABLE AT THE AMBULATORY HEALTH CARE WEB SITE FOR NAMCS AND NHAMCS. 
    (www.cdc.gov/nchs/namcs or www.cdc.gov/nchs/nhamcs)
    PLEASE CONTACT THE AMBULATORY AND HOSPITAL CARE STATISTICS BRANCH AT
    301-458-4600 IF YOU HAVE QUESTIONS.
	UPDATED 1/3/2019
*/

FILENAME DRGINGR		'C:\MyFiles\NAMCS2016\drug_ingredients_2016.data';  *DRUG INGREDIENT FILE;
FILENAME VIS 			'C:\MyFiles\NAMCS2016\namcs2016';	                *INPUT DATA FILE;
FILENAME INPUT			'C:\MyFiles\NAMCS2016\nam16inp.txt';                *INPUT STATEMENT FOR INPUT DATA FILE;

LIBNAME  LIBOUT	     	'C:\MyFiles\NAMCS2016';                             *PATH FOR OUTPUT DATASET;

%LET VISOUT=NEWFILE; 

PROC DATASETS LIBRARY=WORK KILL;
QUIT;

* CREATING VISIT FILE;
DATA VIS;
INFILE VIS LRECL=9999 MISSOVER;
%INC INPUT;
RUN;


* CREATING DRUG INGREDIENT FILE;

data drging;
INFILE DRGINGR LRECL=999 MISSOVER PAD;
INPUT
@001 DRUG_ID	$CHAR6.
@007 MEMBER1 	$CHAR6.
@013 MEMBER2 	$CHAR6.
@019 MEMBER3 	$CHAR6.
@025 MEMBER4 	$CHAR6.
@031 MEMBER5 	$CHAR6.
@037 MEMBER6 	$CHAR6.
@043 MEM1CAT1 	$CHAR3.
@046 MEM1CAT2	$CHAR3.
@049 MEM1CAT3	$CHAR3.
@052 MEM1CAT4	$CHAR3.
@055 MEM2CAT1	$CHAR3.
@058 MEM2CAT2	$CHAR3.
@061 MEM2CAT3	$CHAR3.
@064 MEM2CAT4	$CHAR3.
@067 MEM3CAT1	$CHAR3.
@070 MEM3CAT2	$CHAR3.
@073 MEM3CAT3	$CHAR3.
@076 MEM3CAT4	$CHAR3.
@079 MEM4CAT1 	$CHAR3.
@082 MEM4CAT2	$CHAR3.
@085 MEM4CAT3	$CHAR3.
@088 MEM4CAT4	$CHAR3.
@091 MEM5CAT1	$CHAR3.
@094 MEM5CAT2	$CHAR3.
@097 MEM5CAT3	$CHAR3.
@100 MEM5CAT4	$CHAR3.
@103 MEM6CAT1	$CHAR3.
@106 MEM6CAT2 	$CHAR3.
@109 MEM6CAT3	$CHAR3.
@112 MEM6CAT4	$CHAR3.
;
run;

data drging;
set drging;
length iddata $36 memall $72;
iddata=member1||member2||member3||member4||member5||member6;
memall=	mem1cat1||mem1cat2||mem1cat3||mem1cat4||
		mem2cat1||mem2cat2||mem2cat3||mem2cat4||
		mem3cat1||mem3cat2||mem3cat3||mem3cat4||
		mem4cat1||mem4cat2||mem4cat3||mem4cat4||
		mem5cat1||mem5cat2||mem5cat3||mem5cat4||
		mem6cat1||mem6cat2||mem6cat3||mem6cat4;
run;

* creating temporary format for member drug ids;
data memform(keep=start label fmtname hlo);
set drging end=eof;
fmtname = '$IDDATA';
start = drug_id;
label = iddata;
output;
if eof then do;
	label = 'NOMATCH';
	hlo = 'O';
	output;
	end;

data memall(keep=start label fmtname);
set drging;
length label $72;
fmtname = '$MEMALL';
start = drug_id;
label = memall;

PROC FORMAT CNTLIN=memform LIBRARY=WORK;
run;

proc format cntlin=memall library=work;
run;

* MERGING INGREDIENTS TO VISIT FILE;

%macro adddata;
data visingr;
set vis;
length memberdata $36 catdata $72; 
array meds(30) med1-med30;
array drgid(30) drugid1-drugid30;
array memberid(30,6)$6 	drg1mem1-drg1mem6
						drg2mem1-drg2mem6
						drg3mem1-drg3mem6
						drg4mem1-drg4mem6
						drg5mem1-drg5mem6
						drg6mem1-drg6mem6
						drg7mem1-drg7mem6
						drg8mem1-drg8mem6
						drg9mem1-drg9mem6
						drg10mem1-drg10mem6
						drg11mem1-drg11mem6
						drg12mem1-drg12mem6
						drg13mem1-drg13mem6
						drg14mem1-drg14mem6
						drg15mem1-drg15mem6
						drg16mem1-drg16mem6
						drg17mem1-drg17mem6
						drg18mem1-drg18mem6
						drg19mem1-drg19mem6
						drg20mem1-drg20mem6
						drg21mem1-drg21mem6
						drg22mem1-drg22mem6
						drg23mem1-drg23mem6
						drg24mem1-drg24mem6
						drg25mem1-drg25mem6
						drg26mem1-drg26mem6
						drg27mem1-drg27mem6
						drg28mem1-drg28mem6
						drg29mem1-drg29mem6
						drg30mem1-drg30mem6
;
array drg1(24) $3 	drg1mem1cat1 drg1mem1cat2 drg1mem1cat3 drg1mem1cat4
					drg1mem2cat1 drg1mem2cat2 drg1mem2cat3 drg1mem2cat4
					drg1mem3cat1 drg1mem3cat2 drg1mem3cat3 drg1mem3cat4
					drg1mem4cat1 drg1mem4cat2 drg1mem4cat3 drg1mem4cat4
					drg1mem5cat1 drg1mem5cat2 drg1mem5cat3 drg1mem5cat4
					drg1mem6cat1 drg1mem6cat2 drg1mem6cat3 drg1mem6cat4;
array drg2(24) $3 	drg2mem1cat1 drg2mem1cat2 drg2mem1cat3 drg2mem1cat4
					drg2mem2cat1 drg2mem2cat2 drg2mem2cat3 drg2mem2cat4
					drg2mem3cat1 drg2mem3cat2 drg2mem3cat3 drg2mem3cat4
					drg2mem4cat1 drg2mem4cat2 drg2mem4cat3 drg2mem4cat4
					drg2mem5cat1 drg2mem5cat2 drg2mem5cat3 drg2mem5cat4
					drg2mem6cat1 drg2mem6cat2 drg2mem6cat3 drg2mem6cat4;
array drg3(24) $3 	drg3mem1cat1 drg3mem1cat2 drg3mem1cat3 drg3mem1cat4
					drg3mem2cat1 drg3mem2cat2 drg3mem2cat3 drg3mem2cat4
					drg3mem3cat1 drg3mem3cat2 drg3mem3cat3 drg3mem3cat4
					drg3mem4cat1 drg3mem4cat2 drg3mem4cat3 drg3mem4cat4
					drg3mem5cat1 drg3mem5cat2 drg3mem5cat3 drg3mem5cat4
					drg3mem6cat1 drg3mem6cat2 drg3mem6cat3 drg3mem6cat4;
array drg4(24) $3 	drg4mem1cat1 drg4mem1cat2 drg4mem1cat3 drg4mem1cat4
					drg4mem2cat1 drg4mem2cat2 drg4mem2cat3 drg4mem2cat4
					drg4mem3cat1 drg4mem3cat2 drg4mem3cat3 drg4mem3cat4
					drg4mem4cat1 drg4mem4cat2 drg4mem4cat3 drg4mem4cat4
					drg4mem5cat1 drg4mem5cat2 drg4mem5cat3 drg4mem5cat4
					drg4mem6cat1 drg4mem6cat2 drg4mem6cat3 drg4mem6cat4;
array drg5(24) $3 	drg5mem1cat1 drg5mem1cat2 drg5mem1cat3 drg5mem1cat4
					drg5mem2cat1 drg5mem2cat2 drg5mem2cat3 drg5mem2cat4
					drg5mem3cat1 drg5mem3cat2 drg5mem3cat3 drg5mem3cat4
					drg5mem4cat1 drg5mem4cat2 drg5mem4cat3 drg5mem4cat4
					drg5mem5cat1 drg5mem5cat2 drg5mem5cat3 drg5mem5cat4
					drg5mem6cat1 drg5mem6cat2 drg5mem6cat3 drg5mem6cat4;
array drg6(24) $3 	drg6mem1cat1 drg6mem1cat2 drg6mem1cat3 drg6mem1cat4
					drg6mem2cat1 drg6mem2cat2 drg6mem2cat3 drg6mem2cat4
					drg6mem3cat1 drg6mem3cat2 drg6mem3cat3 drg6mem3cat4
					drg6mem4cat1 drg6mem4cat2 drg6mem4cat3 drg6mem4cat4
					drg6mem5cat1 drg6mem5cat2 drg6mem5cat3 drg6mem5cat4
					drg6mem6cat1 drg6mem6cat2 drg6mem6cat3 drg6mem6cat4;
array drg7(24) $3 	drg7mem1cat1 drg7mem1cat2 drg7mem1cat3 drg7mem1cat4
					drg7mem2cat1 drg7mem2cat2 drg7mem2cat3 drg7mem2cat4
					drg7mem3cat1 drg7mem3cat2 drg7mem3cat3 drg7mem3cat4
					drg7mem4cat1 drg7mem4cat2 drg7mem4cat3 drg7mem4cat4
					drg7mem5cat1 drg7mem5cat2 drg7mem5cat3 drg7mem5cat4
					drg7mem6cat1 drg7mem6cat2 drg7mem6cat3 drg7mem6cat4;
array drg8(24) $3 	drg8mem1cat1 drg8mem1cat2 drg8mem1cat3 drg8mem1cat4
					drg8mem2cat1 drg8mem2cat2 drg8mem2cat3 drg8mem2cat4
					drg8mem3cat1 drg8mem3cat2 drg8mem3cat3 drg8mem3cat4
					drg8mem4cat1 drg8mem4cat2 drg8mem4cat3 drg8mem4cat4
					drg8mem5cat1 drg8mem5cat2 drg8mem5cat3 drg8mem5cat4
					drg8mem6cat1 drg8mem6cat2 drg8mem6cat3 drg8mem6cat4;
array drg9(24) $3 	drg9mem1cat1 drg9mem1cat2 drg9mem1cat3 drg9mem1cat4
					drg9mem2cat1 drg9mem2cat2 drg9mem2cat3 drg9mem2cat4
					drg9mem3cat1 drg9mem3cat2 drg9mem3cat3 drg9mem3cat4
					drg9mem4cat1 drg9mem4cat2 drg9mem4cat3 drg9mem4cat4
					drg9mem5cat1 drg9mem5cat2 drg9mem5cat3 drg9mem5cat4
					drg9mem6cat1 drg9mem6cat2 drg9mem6cat3 drg9mem6cat4;
array drg10(24) $3 	drg10mem1cat1 drg10mem1cat2 drg10mem1cat3 drg10mem1cat4
					drg10mem2cat1 drg10mem2cat2 drg10mem2cat3 drg10mem2cat4
					drg10mem3cat1 drg10mem3cat2 drg10mem3cat3 drg10mem3cat4
					drg10mem4cat1 drg10mem4cat2 drg10mem4cat3 drg10mem4cat4
					drg10mem5cat1 drg10mem5cat2 drg10mem5cat3 drg10mem5cat4
					drg10mem6cat1 drg10mem6cat2 drg10mem6cat3 drg10mem6cat4;
array drg11(24) $3 	drg11mem1cat1 drg11mem1cat2 drg11mem1cat3 drg11mem1cat4
					drg11mem2cat1 drg11mem2cat2 drg11mem2cat3 drg11mem2cat4
					drg11mem3cat1 drg11mem3cat2 drg11mem3cat3 drg11mem3cat4
					drg11mem4cat1 drg11mem4cat2 drg11mem4cat3 drg11mem4cat4
					drg11mem5cat1 drg11mem5cat2 drg11mem5cat3 drg11mem5cat4
					drg11mem6cat1 drg11mem6cat2 drg11mem6cat3 drg11mem6cat4;
array drg12(24) $3 	drg12mem1cat1 drg12mem1cat2 drg12mem1cat3 drg12mem1cat4
					drg12mem2cat1 drg12mem2cat2 drg12mem2cat3 drg12mem2cat4
					drg12mem3cat1 drg12mem3cat2 drg12mem3cat3 drg12mem3cat4
					drg12mem4cat1 drg12mem4cat2 drg12mem4cat3 drg12mem4cat4
					drg12mem5cat1 drg12mem5cat2 drg12mem5cat3 drg12mem5cat4
					drg12mem6cat1 drg12mem6cat2 drg12mem6cat3 drg12mem6cat4;
array drg13(24) $3 	drg13mem1cat1 drg13mem1cat2 drg13mem1cat3 drg13mem1cat4
					drg13mem2cat1 drg13mem2cat2 drg13mem2cat3 drg13mem2cat4
					drg13mem3cat1 drg13mem3cat2 drg13mem3cat3 drg13mem3cat4
					drg13mem4cat1 drg13mem4cat2 drg13mem4cat3 drg13mem4cat4
					drg13mem5cat1 drg13mem5cat2 drg13mem5cat3 drg13mem5cat4
					drg13mem6cat1 drg13mem6cat2 drg13mem6cat3 drg13mem6cat4;
array drg14(24) $3 	drg14mem1cat1 drg14mem1cat2 drg14mem1cat3 drg14mem1cat4
					drg14mem2cat1 drg14mem2cat2 drg14mem2cat3 drg14mem2cat4
					drg14mem3cat1 drg14mem3cat2 drg14mem3cat3 drg14mem3cat4
					drg14mem4cat1 drg14mem4cat2 drg14mem4cat3 drg14mem4cat4
					drg14mem5cat1 drg14mem5cat2 drg14mem5cat3 drg14mem5cat4
					drg14mem6cat1 drg14mem6cat2 drg14mem6cat3 drg14mem6cat4;
array drg15(24) $3 	drg15mem1cat1 drg15mem1cat2 drg15mem1cat3 drg15mem1cat4
					drg15mem2cat1 drg15mem2cat2 drg15mem2cat3 drg15mem2cat4
					drg15mem3cat1 drg15mem3cat2 drg15mem3cat3 drg15mem3cat4
					drg15mem4cat1 drg15mem4cat2 drg15mem4cat3 drg15mem4cat4
					drg15mem5cat1 drg15mem5cat2 drg15mem5cat3 drg15mem5cat4
					drg15mem6cat1 drg15mem6cat2 drg15mem6cat3 drg15mem6cat4;
array drg16(24) $3 	drg16mem1cat1 drg16mem1cat2 drg16mem1cat3 drg16mem1cat4
					drg16mem2cat1 drg16mem2cat2 drg16mem2cat3 drg16mem2cat4
					drg16mem3cat1 drg16mem3cat2 drg16mem3cat3 drg16mem3cat4
					drg16mem4cat1 drg16mem4cat2 drg16mem4cat3 drg16mem4cat4
					drg16mem5cat1 drg16mem5cat2 drg16mem5cat3 drg16mem5cat4
					drg16mem6cat1 drg16mem6cat2 drg16mem6cat3 drg16mem6cat4;
array drg17(24) $3 	drg17mem1cat1 drg17mem1cat2 drg17mem1cat3 drg17mem1cat4
					drg17mem2cat1 drg17mem2cat2 drg17mem2cat3 drg17mem2cat4
					drg17mem3cat1 drg17mem3cat2 drg17mem3cat3 drg17mem3cat4
					drg17mem4cat1 drg17mem4cat2 drg17mem4cat3 drg17mem4cat4
					drg17mem5cat1 drg17mem5cat2 drg17mem5cat3 drg17mem5cat4
					drg17mem6cat1 drg17mem6cat2 drg17mem6cat3 drg17mem6cat4;
array drg18(24) $3 	drg18mem1cat1 drg18mem1cat2 drg18mem1cat3 drg18mem1cat4
					drg18mem2cat1 drg18mem2cat2 drg18mem2cat3 drg18mem2cat4
					drg18mem3cat1 drg18mem3cat2 drg18mem3cat3 drg18mem3cat4
					drg18mem4cat1 drg18mem4cat2 drg18mem4cat3 drg18mem4cat4
					drg18mem5cat1 drg18mem5cat2 drg18mem5cat3 drg18mem5cat4
					drg18mem6cat1 drg18mem6cat2 drg18mem6cat3 drg18mem6cat4;
array drg19(24) $3 	drg19mem1cat1 drg19mem1cat2 drg19mem1cat3 drg19mem1cat4
					drg19mem2cat1 drg19mem2cat2 drg19mem2cat3 drg19mem2cat4
					drg19mem3cat1 drg19mem3cat2 drg19mem3cat3 drg19mem3cat4
					drg19mem4cat1 drg19mem4cat2 drg19mem4cat3 drg19mem4cat4
					drg19mem5cat1 drg19mem5cat2 drg19mem5cat3 drg19mem5cat4
					drg19mem6cat1 drg19mem6cat2 drg19mem6cat3 drg19mem6cat4;
array drg20(24) $3 	drg20mem1cat1 drg20mem1cat2 drg20mem1cat3 drg20mem1cat4
					drg20mem2cat1 drg20mem2cat2 drg20mem2cat3 drg20mem2cat4
					drg20mem3cat1 drg20mem3cat2 drg20mem3cat3 drg20mem3cat4
					drg20mem4cat1 drg20mem4cat2 drg20mem4cat3 drg20mem4cat4
					drg20mem5cat1 drg20mem5cat2 drg20mem5cat3 drg20mem5cat4
					drg20mem6cat1 drg20mem6cat2 drg20mem6cat3 drg20mem6cat4;
array drg21(24) $3 	drg21mem1cat1 drg21mem1cat2 drg21mem1cat3 drg21mem1cat4
					drg21mem2cat1 drg21mem2cat2 drg21mem2cat3 drg21mem2cat4
					drg21mem3cat1 drg21mem3cat2 drg21mem3cat3 drg21mem3cat4
					drg21mem4cat1 drg21mem4cat2 drg21mem4cat3 drg21mem4cat4
					drg21mem5cat1 drg21mem5cat2 drg21mem5cat3 drg21mem5cat4
					drg21mem6cat1 drg21mem6cat2 drg21mem6cat3 drg21mem6cat4;
array drg22(24) $3 	drg22mem1cat1 drg22mem1cat2 drg22mem1cat3 drg22mem1cat4
					drg22mem2cat1 drg22mem2cat2 drg22mem2cat3 drg22mem2cat4
					drg22mem3cat1 drg22mem3cat2 drg22mem3cat3 drg22mem3cat4
					drg22mem4cat1 drg22mem4cat2 drg22mem4cat3 drg22mem4cat4
					drg22mem5cat1 drg22mem5cat2 drg22mem5cat3 drg22mem5cat4
					drg22mem6cat1 drg22mem6cat2 drg22mem6cat3 drg22mem6cat4;
array drg23(24) $3 	drg23mem1cat1 drg23mem1cat2 drg23mem1cat3 drg23mem1cat4
					drg23mem2cat1 drg23mem2cat2 drg23mem2cat3 drg23mem2cat4
					drg23mem3cat1 drg23mem3cat2 drg23mem3cat3 drg23mem3cat4
					drg23mem4cat1 drg23mem4cat2 drg23mem4cat3 drg23mem4cat4
					drg23mem5cat1 drg23mem5cat2 drg23mem5cat3 drg23mem5cat4
					drg23mem6cat1 drg23mem6cat2 drg23mem6cat3 drg23mem6cat4;
array drg24(24) $3 	drg24mem1cat1 drg24mem1cat2 drg24mem1cat3 drg24mem1cat4
					drg24mem2cat1 drg24mem2cat2 drg24mem2cat3 drg24mem2cat4
					drg24mem3cat1 drg24mem3cat2 drg24mem3cat3 drg24mem3cat4
					drg24mem4cat1 drg24mem4cat2 drg24mem4cat3 drg24mem4cat4
					drg24mem5cat1 drg24mem5cat2 drg24mem5cat3 drg24mem5cat4
					drg24mem6cat1 drg24mem6cat2 drg24mem6cat3 drg24mem6cat4;
array drg25(24) $3 	drg25mem1cat1 drg25mem1cat2 drg25mem1cat3 drg25mem1cat4
					drg25mem2cat1 drg25mem2cat2 drg25mem2cat3 drg25mem2cat4
					drg25mem3cat1 drg25mem3cat2 drg25mem3cat3 drg25mem3cat4
					drg25mem4cat1 drg25mem4cat2 drg25mem4cat3 drg25mem4cat4
					drg25mem5cat1 drg25mem5cat2 drg25mem5cat3 drg25mem5cat4
					drg25mem6cat1 drg25mem6cat2 drg25mem6cat3 drg25mem6cat4;
array drg26(24) $3 	drg26mem1cat1 drg26mem1cat2 drg26mem1cat3 drg26mem1cat4
					drg26mem2cat1 drg26mem2cat2 drg26mem2cat3 drg26mem2cat4
					drg26mem3cat1 drg26mem3cat2 drg26mem3cat3 drg26mem3cat4
					drg26mem4cat1 drg26mem4cat2 drg26mem4cat3 drg26mem4cat4
					drg26mem5cat1 drg26mem5cat2 drg26mem5cat3 drg26mem5cat4
					drg26mem6cat1 drg26mem6cat2 drg26mem6cat3 drg26mem6cat4;
array drg27(24) $3 	drg27mem1cat1 drg27mem1cat2 drg27mem1cat3 drg27mem1cat4
					drg27mem2cat1 drg27mem2cat2 drg27mem2cat3 drg27mem2cat4
					drg27mem3cat1 drg27mem3cat2 drg27mem3cat3 drg27mem3cat4
					drg27mem4cat1 drg27mem4cat2 drg27mem4cat3 drg27mem4cat4
					drg27mem5cat1 drg27mem5cat2 drg27mem5cat3 drg27mem5cat4
					drg27mem6cat1 drg27mem6cat2 drg27mem6cat3 drg27mem6cat4;
array drg28(24) $3 	drg28mem1cat1 drg28mem1cat2 drg28mem1cat3 drg28mem1cat4
					drg28mem2cat1 drg28mem2cat2 drg28mem2cat3 drg28mem2cat4
					drg28mem3cat1 drg28mem3cat2 drg28mem3cat3 drg28mem3cat4
					drg28mem4cat1 drg28mem4cat2 drg28mem4cat3 drg28mem4cat4
					drg28mem5cat1 drg28mem5cat2 drg28mem5cat3 drg28mem5cat4
					drg28mem6cat1 drg28mem6cat2 drg28mem6cat3 drg28mem6cat4;
array drg29(24) $3 	drg29mem1cat1 drg29mem1cat2 drg29mem1cat3 drg29mem1cat4
					drg29mem2cat1 drg29mem2cat2 drg29mem2cat3 drg29mem2cat4
					drg29mem3cat1 drg29mem3cat2 drg29mem3cat3 drg29mem3cat4
					drg29mem4cat1 drg29mem4cat2 drg29mem4cat3 drg29mem4cat4
					drg29mem5cat1 drg29mem5cat2 drg29mem5cat3 drg29mem5cat4
					drg29mem6cat1 drg29mem6cat2 drg29mem6cat3 drg29mem6cat4;
array drg30(24) $3 	drg30mem1cat1 drg30mem1cat2 drg30mem1cat3 drg30mem1cat4
					drg30mem2cat1 drg30mem2cat2 drg30mem2cat3 drg30mem2cat4
					drg30mem3cat1 drg30mem3cat2 drg30mem3cat3 drg30mem3cat4
					drg30mem4cat1 drg30mem4cat2 drg30mem4cat3 drg30mem4cat4
					drg30mem5cat1 drg30mem5cat2 drg30mem5cat3 drg30mem5cat4
					drg30mem6cat1 drg30mem6cat2 drg30mem6cat3 drg30mem6cat4;
%do i=1 %to 30;
	if meds(&i) not in ('-9' '90000' '88888') then do;
		memberdata	= put(drgid(&i), $IDDATA.);
		catdata = put(drgid(&i),$MEMALL.);
		if memberdata = 'NOMATCH' then do;
			put 'NO MATCH FOR DRUG ID CODE,MISSING DRUG ID ' drgid(&i)=;
		end;
		do j = 1 to 6;
			memberid(&i,j)= substr(memberdata,((6*j)-5),6);
		end;
		do k = 1 to 24;
			drg&i(k)=substr(catdata,((3*k)-2),3);
		end;
	end;
%end;	

drop  j k memberdata catdata;
run;
%mend;
%adddata;

DATA LIBOUT.&VISOUT;
SET VISINGR;
RUN;

proc contents data=visingr;
run; 

