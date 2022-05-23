#Copyright 2020 Owen Davidson, Carson Eliasen, & James Rudd, Colorado State University
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
#to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
#and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
#WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#This code was throughly tested with a wide range of data input. However, no testing is perfect. If you come across something you strongly believe is a bug,
#please contact us at ################################ so we can fix that for future users. Before contacting us, please make sure you have found a bug by
#verifying that you can successfully run this script with the example input and output files provided. If anything on this repository is unclear, please
#contact us so we can adjust our documentation.

#The following three lines can be commented out to optimize performance AFTER you have run at least one program from this repository.
#To comment a line, simply place a '#' character before the line.
install.packages("readxl")
install.packages("writexl")
install.packages("dplyr")
install.packages("rgr")

library(readxl)
library(writexl)
library(dplyr)
library(rgr)

##### REMEMBER #####
#Set working directory to project directory
#Session -> Set Working Directory -> To Project Directory


#File path for the trauma center's .xlsx file
##################################################################################
######### THIS VARIABLE MUST BE ADJUSTED IF YOU WANT TO RUN ######################
############## ANALYSIS AGAINST YOUR OWN INPUT FILES #############################
##################################################################################
inputFilePath  = "./Current Build/Input/TestInput.xlsx"

##################################################################################
##################################################################################
###### IF RUNNING FOR DEFAULT ANALYSIS, DO NOT EDIT ANYTHING PAST THIS LINE ######
##################################################################################
##################################################################################

VetCotInput <- read_excel(schoolInputPath, sheet=1, col_types = "text")

#' Get cases with AFAST score greater than or equal to 3
#' 
#' @param dataset A data frame, the VetCot sheet of a trauma center
#' @return a data frame, containing all AFAST outlier cases
getAFASTOutliers <- function(dataset) {
  return(filter(dataset, as.numeric(dataset[['trs_afast_abd']]) >= 3))
}

#' Turns an Excel style date into a human style date. It allows the 
#' final results to be human readable.
#' 
#' @param dateNumber A number which Excel used to represent a date
#' @return A date in a format a human would recognize
integerToDate <- function(dateNumber){
  return(as.Date.numeric(as.numeric(dateNumber), origin="1899-12-30"))
}

#' Turns a column of Excel dates into human readable format
#' 
#' @param dateColumn A column tibble of Excel format dates
#' @return A column of dates in human readable format
integersToDates <- function(dateColumn){
  #This loop is to make the tibble a vector
  for(i in 1:length(dateColumn)){
    dateColumn[[i]] <- integerToDate(dateColumn[[i]])
  }
  
  return(dateColumn)
}

AFASTOutliers <- getAFASTOutliers(VetCotInput)

#' Turns all the dates on a VetCot sheet into human readable format
#' from Excel format
#' 
#' @param dataset A data frame, the VetCot sheet of a trauma center
#' @return A sheet of VetCot data with dates in human readable format
fixDates <- function(dataset){
  dateColumns <- c("tr_date_of_hosp",
                   "tr_entry_date",
                   "tr_date_of_trauma",
                   "o_outcome_dt")
  
  for(dateColumn in dateColumns){
    if(dateColumn %in% names(dataset)){
      dataset[, dateColumn] <- integersToDates(dataset[, dateColumn])
    }
  }
  return(dataset)
}

#' Get all records where a chosen field exceeds or falls below a given threshold
#' 
#' @param dataset A data frame, the VetCot sheet of a trauma center
#' @param field A string, the massaged field to be targeted
#' @param tC A string, the trauma center's code in the VetCotInput dataset, -1 for no filter, not used for this version
#' @param threshold A number, the threshold
#' @param greater A boolean, True=Greater than threshold, False=Less than threshold
#' @return A data frame, the subset where the field exceeds or falls below the threshold
getScoreThreshold <- function(dataset, field, tC, threshold, greater) {
  if(tC != "-1"){
    dataset = subset(dataset, tr_site == tC)
  }
  if(field %in% colnames(dataset)){
    dataset <- fixDates(dataset)
    if(greater) {
      return(filter(dataset, as.numeric(dataset[[field]]) > threshold))
    } else {
      return(filter(dataset, as.numeric(dataset[[field]]) < threshold))
    }
  }
  else{
    return(NULL)
  }
}

ATT  <- getScoreThreshold(VetCotInput, 'tr_att_score', "-1", 0, TRUE)

MGCS <- getScoreThreshold(VetCotInput, 'tr_mgcs_score', "-1", 18, FALSE)

BE   <- getScoreThreshold(VetCotInput, 'trs_base_ex', "-1", -6.6, FALSE)

ICA  <- getScoreThreshold(VetCotInput, 'trs_ion_ca', "-1", 1.24, FALSE)

fname = "./Current Build/Output/Output_Clinically_Relevant_Cases.xlsx"

write_xlsx(list(
  "AFAST >= 3"    = as.data.frame(AFASTOutliers, stringsAsFactors = FALSE),
  "ATT > 0"       = as.data.frame(ATT, stringsAsFactors = FALSE),
  "MGCS < 18"     = as.data.frame(MGCS, stringsAsFactors = FALSE),
  "BE < -6.6"     = as.data.frame(BE, stringsAsFactors = FALSE),
  "ICA < 1.24"    = as.data.frame(ICA, stringsAsFactors = FALSE)), fname)

print("Analysis Complete!")
