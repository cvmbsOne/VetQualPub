### Description of the Analysis
The accuracy analyzer is designed to find duplicates and discrepancies between EMR data and REDCap data. The first page gives a detailed summary of each variable and how that variable matches up between REDCap and EMR. The second page discusses any duplicate case numbers found in either EMR or REDCap data. The third page gives a summary of the PCV variable or the variable you selected. The final page gives a detailed account of discrepancies by case number.

### Requirements
To run analyzerAccuracy.R, you will need to follow the 'Run' section of README.md as well as:
* Select several (10-60) cases from your EMR records
* Combine the EMR data and the REDCap data into one Excel spreadsheet in the format outlined in the 'Data Requirements' section of README.md
* Set SideBySideComparisonVariable (line 41 in the code) to the column you want compared (optional, is automatically PCV)
>Note: It is extremely important that you select ONLY EMR cases where you have the corresponding REDCap data. Failure to do so could result in unexpected behavior. 

### Output
Excel sheets in Output_Accuracy.xlsx include Accuracy Results, Duplicate Count, PCV Comparison, and Mismatches per case.
* **Accuracy Results**: contains results on the comparisons between the variables of the VetCOT trauma registry and hospital's EMR, has the following columns
  - **Variable**: data variable name as recorded by the trauma registry
  - **Total**: number of cases included in the analysis
  - **Comparisons possible**: number of cases where both datasets have a data entry
  - **Matches**: number of cases where both the data entry in REDCap and EMR match
  - **Mismatches**: number of cases where data entries different
  - **% Mismatched**: total mismatches/comparisons possible * 100
  - **Min Diff**: minimum difference (REDCap - EMR) between mismatches of quantitative data
  - **Max Diff**: maximum difference (REDCap - EMR) between mismatches of quantitative data
  - **Median Diff**: median difference (REDCap - EMR) between mismatches of quantitative data
  - **% Min Diff**: Min Diff/REDCap data entry * 100
  - **% Max Diff**: Max Diff/REDCap data entry * 100
  - **% Median Diff**: Median Diff/REDCap data entry * 100
    - columns M to S are absolute values
* **Duplicate Count**: contains cases that are duplicated in REDCap
  - **Case.Number**: unique case ID
  - **Number.of.Occurrences**: number of REDCap entries corresponding to the case number
  - **Presentation.Date.Matches**: number of entries where the presentation date matches between multiple entries of the same case
  - **Presentation.Date.Mismatches**: number of entries where the presentation date does not match for multiple entries of the same case
* **PCV Comparison**: includes the PCV of each dataset, if a transfusion was used for the case, and the case outcome
  - **Case number**: unique case ID
  - **ID**: REDCap unique case ID
  - **RedCap**: PCV entered into REDCap
  - **EMR**: PCV entered into EMR
  - **Blood Products**: REDCap blood products entry
  - **Outcome**: REDCap outcome entry
* **Mismatches per case**: screens cases that have multiple mismatches, species and presentation date should match between REDCap and EMR if the same case is being compared (these are the 'critical factors')
  - **Case.Number**: unique case ID
  - **Total.Mismatches**: number of variables between REDCap and EMR that do not match
  - **Total.Variables.screened**: number of variables compared per case
  - **Species.Match**: does the species variable match? Yes or No
  - **Presentation.Date.Match**: does the presentation data variable match? Yes or No
  - **All.Critical.Factors.Match**: do both the species AND presentation date variable match? Yes or No
