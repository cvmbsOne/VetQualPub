This file gives an in-depth description of analyzerConsistency.R.

### Requirements
To run analyzerConsistency.R, you will need to:
* Follow the setup in README.md in the home directory of this repository
* Extract data from the REDCap database
* Save the REDCap data as an Excel spreadsheet if it isn't already in that format
* Set the schoolInputPath variable to the path of the Excel sheet
* Set your working directory to the project directory
* Run all the lines of code (cntl + a, cntl + enter)
* After the code finishes running, the output sould be veiwable in the output folder. In Rstudio, simply click on the file name and click view file

### Description of the Analysis
analyzerConsistency.R is designed to find things that are errors in the entry. The first 4 sheets search for combinations where given the species and breed, the weight 
shouldn't be possible. The next two sheets search for dates that imply impossible circumstances such as a patient's date of treatment being before the date the patient was
injured. The final sheet searches for blank rows and gives a corresponding output given a variable.
