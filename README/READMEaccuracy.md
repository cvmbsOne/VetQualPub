This file gives an in-depth description of analyzerAccuracy.R.

### Requirements
To run analyzerAccuracy.R, you will need to:
* Follow the setup in README.md in the home directory of this repository
* Extract data from the REDCap database
* Select several (10-60) cases from your EMR records and put them into the specific format
* Combine the EMR data and the REDCap data into one Excel spreadsheet with the REDCap data on page 1 and the EMR data on page 2
* Set the schoolInputPath variable to the path of the Excel sheet
* Set the SBSvar variable to the column you want compared (optional)
* Set your working directory to the project directory
* Run all the lines of code (cntl + a, cntl + enter)
* After the code finishes running, the output sould be veiwable in the output folder. In Rstudio, simply click on the file name and click view file
- *Note:* it is EXTREMELY IMPORTANT that you select ONLY EMR cases where you have the corresponding REDCap data.
Failure to do so could result in unexpected behavior. 

### Description of the Analysis
The accuracy analyzer is designed to find discrepencies between EMR data and REDCap data. The first page gives a detailed summary of each variable and how that variable
matches up between REDCap and EMR. The second page discusses any duplicate case numbers found in either EMR or REDCap data. The third page gives a summary of the pcv
variable or whatever variable you selected. The final page gives a detailed account of mismatches by case number.
