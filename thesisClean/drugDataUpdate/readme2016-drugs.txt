        TRENDING NAMCS AND NHAMCS DRUG DATA AND ANALYZING INGREDIENTS 


     Q.  How can I compare drug data across years when the classification 
     system is different starting with 2006 data? 

     A.  NCHS has developed a SAS program that will read in a previous year 
     of NAMCS or NHAMCS data, match medication codes from that dataset with 
     codes from the current ambulatory care drug database, and then drop the 
     old drug characteristics associated with that medication code, while 
     replacing them with the new Multum characteristics.  The original program 
     DRUGCHAR_MULTUM_2006.SAS can be downloaded from the Ambulatory Health Care 
     Data website, along with the ASCII text file MEDCODE_DRUGID_MAP_2006.DATA 
     that is used to replace the drug characteristics.  Programs and databases 
     will continue to be added for each new year of data.  
     
     The advantage of replacing old drug characteristic data from prior to 2006 
     with the corresponding Multum characteristics is that it allows you to compare
     drugs consistently across years.  Also, newer versions of the drug database may
     incorporate corrections which can be applied to previous years as well.  

     The only caveat is that by updating drug characteristics to the most recent year,
     you may lose older characteristics that may be of interest. For example, if a drug 
     was a prescription-only preparation in 1995 and switched to over-the-counter in 2010, 
     by using a characteristics file from 2010 or later the drug would be coded as 
     over-the-counter for all years of data. The researcher must determine what best meets 
     his or her own needs. 

     The SAS programs are ready to use, only requiring that you change path names
     in the program to reflect your own situation. Each new program should work for
     ALL previous years of data. For example, the 2012 program and database are currently
     the latest version, and can be used to update drug characteristics on all previous years 
     of drug data.  

     IMPORTANT NOTE: The drug characteristics program described above has not been
     produced since the 2012 version due to resource issues and the increasing
     complexity of the drug data.   

     Q.  How can the ingredient data be combined with the basic public use 
     file? 

     A.  NCHS has also developed a SAS program that will add the ingredient file
     to the basic public use file, matching on the DRUGID variable.  This program
     and the corresponding ingredient file were first developed for use with 2006  
     data (ADD_DRUG_INGREDIENTS_2006.SAS and DRUG_INGREDIENTS_2006.DATA). These 
     programs and files continue to be added as each new year of data is released.

     All of these resources can be downloaded at the Ambulatory Health Care Data 
     website in the Dataset Documentation section, under a directory on the ftp server 
     called 'drugs'.

     IMPORTANT NOTE: The ingredient programs and files are year-specific.  In other 
     words, if you want to add ingredients to the 2006 file, use the 2006 program and 
     ingredient file. It is not recommended that you use the 2007 program and 
     ingredient file with non-2007 survey years, or vice versa. The programs only 
     require that you change path names in the programs to reflect your own situation.  

     Need More Information? 

     SAS exercises (including examples of how to use the programs above) and 
     a PowerPoint presentation, which were developed for previous workshops at the 
     NCHS Data Users Conference (since 2015, called the National Conference on Health
     Statistics), are available for downloading at our website under Staff Presentations.  
     They can also be obtained by contacting the Ambulatory and Hospital care Statistics Branch. 

     If you need more information or technical assistance, please contact 
     the Ambulatory and Hospital Care Statistics Branch at 301-458-4600 or
     by email at ambcare@cdc.gov. 


