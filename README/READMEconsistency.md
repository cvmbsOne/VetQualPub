### Description of the Analysis
The consistency and completeness analyzer is designed to find erroneous/missing entries in the data. The first 4 sheets search for combinations of species and breed type where the weight of the animal shouldn't be possible. The next two sheets search for dates that imply impossible circumstances such as a patient's date of treatment being before the date the patient was injured. The final sheet checks for completeness.

### Requirements
To run analyzerConsistency.R, you simply need to follow the 'Run' section of README.md

### Output
Excel sheets in Output_Consistency_And_Completeness.xlsx include Small Canines > 10kg, Canines > 40kg, Felines > 10kg, Large Breeds > 3m0 and < 15kg, Presentation Date < Trauma Date, Outcome < Presentation, and Completeness.
* Each of the four weight comparison sheets contain the case number, breed, weight, and age for the animal that fits the criteria.
* The presentation date comparison sheets contain the case number and relevant dates.
* The Completeness sheet assesses the amount of data collected per variable. It contains the following columns:
  - **Variable**: data variable name as recorded by the trauma registry\
  - **Total entries**: number of case entries in REDCap
  - **Fields left blank**: number of instances where an entry was not entered for a variable (this does not necessarily mean an error, the entry may have been optional)
  - **Percent completeness**: number of data entries/total entries * 100

