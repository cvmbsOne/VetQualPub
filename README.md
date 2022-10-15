# Introduction
This project is designed to help schools assess the quality of their VetCot database. The three programs in this Github allow a school to evaluate things such as improbable entries (i.e. a 240 lb dog), mismatches between EMR and VetCot records, completeness, etc. This document contains the steps to help set up the environment required to run these programs and how to run them. A detailed description of each program and their outputs can be found in the README folder.

### Setup
#### Required Programs
* [R](https://cran.r-project.org/)
* [Rstudio](https://www.rstudio.com/products/rstudio/download/) (Desktop version should work fine)
* [git](https://git-scm.com/downloads) (optional, needed if you want to use git to pull code, fork a copy, or if you already have write permissions in this project)

### Tutorials
If you have not previously used Rstudio, it is recommended that you watch [this](https://www.youtube.com/watch?v=FIrsOBy5k58) tutorial. It is not necessary to fully understand how R works provided you can run the programs in this repository. In addition, it is recommended that you use the files tab in the lower right hand panel on Rstudio to open the programs in this repository as well as to open the output files generated by these programs. The files tab works like the file explorer on your machine. 

### Configure
If you only want to run the code with the provided test data or your own data and don’t need to interact with git version control, download the code by clicking the green "Code" link at the home directory of this repository. Select "download ZIP" and extract the ZIP file.  

![](./Images/Green_Code_Button.png)

If you want to configure RStudio to be compatible with git version control and pull, fork code, etc, you can review [this](https://jennybc.github.io/2014-05-12-ubc/ubc-r/session03_git.html) link for general info on how to integrate Rstudio projects with GitHub repositories.  

Before you run the code, use the files tab in Rstudio to find the downloaded project's home directory. Then click on the file VetCot-R.Rproj.
If you are unable to find this within Rstudio, open VetCot-R.Rproj from your machine's file explorer.

![](./Images/Rproj.png)

> If you're having trouble with the project, see [here](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects).

***\*Two of these programs are designed to run with only RedCAP entries. One program is designed to use data with RedCAP and EMR entries. The EMR entries must follow specific guidlines detailed below in the Data Requirements section and may have to be entered by hand.\**** 

### Run
***\*These steps are sufficient for analyzerClinicallyRelevant.R and analyzerConsistency.R, but analyzerAccuracy.R requires a few additional steps. See READMEaccuracy.md for more info.\****

1. Extract data from VetCot and put it into an Excel spreadsheet
2. Set your working directory in R to the project location 

![](./Images/Set_Working_Directory.png)

3. Open the analyzer that you want to run
   1.  Go to the files tab in the lower right pane in Rstudio. Go to ./Current Build/Code and click on the analyzer.
4. Set inputFilePath to the file path of the data source’s excel spreadsheet.
   1.  Put your input .xlsx file in the input directory (./Current Build/Input) and change the file path in line 37 of the code (the part after ./Current Build/Input/) to match the name of your Excel sheet.
   
   **IMPORTANT:** Be 100% certain that the name in inputFilePath matches the name of the file you uploaded to the input directory. DO NOT change the path portion of inputFilePath. Failure to follow these instructions will likely result in the error message "could not find function read_excel."

![](./Images/Pathnames.png)

5. Run all lines of the program 
   1. Select all the lines by clicking in the script and using the command ctrl+a, then run the script with the command ctrl+enter (if using a Mac, use cmd instead of ctrl) 
   2. Note: This may take a while depending on how powerful your computer is; this is a lot of data for one computer to handle. 
6. An analysis spreadsheet will be created in the folder ./Current Build/Output after “Analysis Complete!” is printed in R’s terminal. To view this file, go to the files tab in the lower right hand panel of Rstudio and go to the folder ./Current Build/Output and click on the file, then click view file. 
   1. Note: you may need to delete, move, or rename previously created spreadsheets before running the program again to receive updated spreadsheets if data/code has changed.

### Data Requirements
***\*This section applies only to the EMR data used for analyzerAccuracy.R.\****
1. The input school’s spreadsheet must be separated into sheets in this order: 
   1. RedCAP entries (with both optional and mandatory variables) 
   2. EMR entries (with both optional and mandatory variables) 
2. There are mandatory and optional variables, the distinction between which is not significant. Mandatory variables are those we recommend encoding if they are available. Optional variables are those that significant value will likely not be gleaned from. The only variable that is truely required is caseNum. Optional variables are defined as the following: 
   - AFASTYN 
   - TFASTYN 
   - bloodLactate 
   - baseExcess 
   - ionCalcium 
   - pcv 
   - TS 
   - bloodGlucose 
3. The following fields may be a combination of string and numeric-typed values, as they have been already specified as non-numeric in code: 
   - caseNum
   - ID 
   - presentationDate 
   - entryDate
4. Records must have matching entries in the ‘caseNum’ field to be correctly joined between sheets - this is the primary key that all comparative analysis hinges on 
5. All continuous, numerical columns MUST be devoid of string-type data in order for the column to be recognized as and included in continuous-variable analysis. *(ex. “?1.0” is not allowed, please use “1.0”)* These fields include: 

   - weightCat 
   - weightDog 
   - catAge 
   - dogAge 
   - ionCalcium 
   - pcv 
   - TS 
   - bloodGlucose 
   - bloodLactate 
   - baseExcess 
6. There should be NO blank rows in the data; this is fatal to the program.
- **Important Note:** The first page of the Excel sheet must be VetCot data and the second page must be EMR data (if EMR data is being used). The programs rely on this fact.
- *Note:* If a spreadsheet is in the above form, it can be used for all three programs. EMR data will be ignored when it isn't needed.
### Testing
If these programs are run with the example input file found in the directory ./Current Build/Input, the output should match the corresponding test output files found in the directory ./Current Build/Output.

### Mapping of RedCap fields to EMR fields
In case there are any questions about the meaning of EMR fields, we have provided the corresponding RedCap fields. For more information about the EMR field, simply look up information on the RedCap field. The list is in the form `EMR field` &rarr; `corresponding RedCap field`.
   - `ID` &rarr; `tr_subject_id`
   - `presentationDate` &rarr; `tr_date_of_hosp`
   - `species` &rarr; `tr_species`
   - `catBreed` &rarr; `tr_cat_breed`
   - `dogBreed` &rarr; `tr_dog_breed`
   - `dogAge` &rarr; `tr_age_canine`
   - `catAge` &rarr; `tr_feline_age`
   - `sex` &rarr; `tr_sex`
   - `weightDog` &rarr; `tr_weight`
   - `weightCat` &rarr; `tr_weight2_436`
   - `priorDVM` &rarr; `tr_prior_treat`
   - `opK9` &rarr; `opk9_status`
   - `priorNonDVM` &rarr; `pre_hosp_non_dvm_yn`
   - `traumaType` &rarr; `tr_trauma_type`
   - `bluntScale` &rarr; `tr_trauma_blunt`
   - `penetratingScale` &rarr; `tr_trauma_penet`
   - `traumaDateYN` &rarr; `tr_trauma_dt_known`
   - `traumaTimeYN` &rarr; `tr_time_trauma_known`
   - `presentation_time_known` &rarr; `presentation_time_known`
   - `ICU` &rarr; `tr_icu`
   - `motorScale` &rarr; `tr_mgcs_motor`
   - `brainScale` &rarr; `tr_mgcs_brain`
   - `consciousScale` &rarr; `tr_mgcs_cons`
   - `MGCSscore` &rarr; `tr_mgcs_score`
   - `headinjYN` &rarr; `tr_head_inj_yn`
   - `spinalinjYN` &rarr; `tr_spinal_trauma_yn`
   - `perfusionScale` &rarr; `tr_att_perf`
   - `cardiacScale` &rarr; `tr_att_card`
   - `respScale` &rarr; `tr_att_resp`
   - `eyeMuscleSkinScale` &rarr; `tr_att_emi`
   - `skeletalScale` &rarr; `tr_att_skel`
   - `neuroScale` &rarr; `tr_att_neuro`
   - `ATTscore` &rarr; `tr_att_score`
   - `surgeryYN` &rarr; `o_surgery`
   - `bloodProductsYN` &rarr; `o_blood_yn`
   - `outcome` &rarr; `o_outcome`
   - `outcomeDate` &rarr; `o_outcome_dt`
   - `AFASTYN` &rarr; `trs_afast`
   - `TFASTYN` &rarr; `trs_tfast`
   - `bloodLactate` &rarr; `trs_blood_lac`
   - `baseExcess` &rarr; `trs_base_ex`
   - `ionCalcium` &rarr; `trs_ion_ca`
   - `pcv` &rarr; `trs_pcv`
   - `TS` &rarr; `trs_solids`
   - `bloodGlucose` &rarr; `trs_glucose`

