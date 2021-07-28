This file gives an in-depth description of analyzerClinicallyRelavent.R.

### Requirements
To run analyzerClinicallyRelavent.R, you will need to:
* Follow the setup in README.md in the home directory of this repository
* Extract data from the REDCap database
* Save the REDCap data as an Excel spreadsheet if it isn't already in that format
* Set the schoolInputPath variable to the path of the Excel sheet
* Set your working directory to the project directory
* Run all the lines of code (cntl + a, cntl + enter)
* After the code finishes running, the output sould be veiwable in the output folder. In Rstudio, simply click on the file name and click view file

### Description of the Analysis
analyzerClinicallyRelavent.R is designed to find anomalies which are clinically relevant. This could be potentially useful in future studies. Each page list only entries which 
have one variable exceeding or being below a certain threshold. Each page is labled with what entry it searches for as well as the threshold.
