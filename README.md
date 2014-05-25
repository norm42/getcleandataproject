GetCleanDataCoursera
Getting and Cleaning Data Project
Norm Zeck, May 2004
========================================================

R scripts for project
--------------------------------------------------------

There are two R scrips for the project:
1. run_analysis.R  This one does steps 1-4 generating xtraintestDataFinal which has the merged training and test sets with some cleaning of the variable names.  It also does part of step 5 in computing the average of the merged data set.  However, my analysis to generate the Tidy data set required a separate file of the variable names.  So the second script finishes part 5, but needs this data file to run.

2. makenormstidy.R  My analysis generated a set of variables:  "Acceleration Type""  Device	Domain	Statistics	Signal	Axis	Motion.  To make the generation of the new variable set I wrote out the original names file, edited that file to add in the variable values for each of the 88 sample variables from the zip file.  While there may have been a way to programatically generate this file by selective use of many greps (maybe as much as 88), this was much easier to do via an editor.  
 
Script Requirements
--------------------------------------------------------
run_analysis.R  requires the directory  "UCI HAR Dataset" in the directory the script is run from.  This directory has the file/directory structure from the project data zip file.

makenormstidy.R requires the file normstidynames.csv which has the variable names to generate the tidy data set.

The package reshape2 needs to be in the environment.  

Code Book
-------------------------------------------------------
The file CodeBook.md contains the description of the codebook and variable names for the resulting files

