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

library(readxl)
library(writexl)
library(dplyr)

##### REMEMBER #####
#Set working directory to project directory
#Session -> Set Working Directory -> To Project Directory


#File path for the school trauma center's .xlsx file
##################################################################################
######### THIS VARIABLE MUST BE ADJUSTED IF YOU WANT TO RUN ######################
############## ANALYSIS AGAINST YOUR OWN INPUT FILES #############################
##################################################################################
schoolInputPath  = "./Current Build/Input/TestInput.xlsx"

#A string that is the column name of the variable for the side by side comparison
#Only change this if you want to compare something other than pcv in the SBS comparison
SideBySideComparisonVariable = "pcv"

##################################################################################
##################################################################################
###### IF RUNNING FOR DEFAULT ANALYSIS, DO NOT EDIT ANYTHING PAST THIS LINE ######
##################################################################################
##################################################################################

VetCotInput <- read_excel(schoolInputPath, sheet=1, col_types = "text")
EMRinput    <- read_excel(schoolInputPath, sheet=2, col_types = "text")

#ACCURACY
#   The accuracy of the veterinary trauma registry will be evaluated
#   by measuring the congruity with the medical record of each animal


requiredEMRvars <- c("ID",                     "presentationDate","species",
                     "catBreed",               "dogBreed",        "dogAge",
                     "catAge",                 "sex",             "weightDog",
                     "weightCat",              "priorDVM",        "opK9",
                     "priorNonDVM",            "traumaType",      "bluntScale",
                     "penetratingScale",       "traumaDateYN",    "traumaTimeYN",
                     "presentation_time_known","ICU",             "motorScale",
                     "brainScale",             "consciousScale",  "MGCSscore",
                     "headinjYN",              "spinalinjYN",     "perfusionScale",
                     "cardiacScale",           "respScale",       "eyeMuscleSkinScale",
                     "skeletalScale",          "neuroScale",      "ATTscore",
                     "surgeryYN",              "bloodProductsYN", "outcome",
                     "outcomeDate")

requiredVetCotVars <- c("tr_subject_id", "tr_date_of_hosp", "tr_species",
                        "tr_cat_breed", "tr_dog_breed", "tr_age_canine",
                        "tr_feline_age", "tr_sex", "tr_weight",
                        "tr_weight2_436", "tr_prior_treat", "opk9_status",
                        "pre_hosp_non_dvm_yn", "tr_trauma_type", "tr_trauma_blunt",
                        "tr_trauma_penet", "tr_trauma_dt_known", "tr_time_trauma_known",
                        "presentation_time_known", "tr_icu", "tr_mgcs_motor",
                        "tr_mgcs_brain", "tr_mgcs_cons", "tr_mgcs_score",
                        "tr_head_inj_yn", "tr_spinal_trauma_yn", "tr_att_perf",
                        "tr_att_card", "tr_att_resp", "tr_att_emi",
                        "tr_att_skel", "tr_att_neuro", "tr_att_score",
                        "o_surgery", "o_blood_yn", "o_outcome",
                        "o_outcome_dt")

optionalEMRvars <- c("AFASTYN",
              "TFASTYN",
              "bloodLactate",
              "baseExcess",
              "ionCalcium",
              "pcv",
              "TS",
              "bloodGlucose")

optionalVetCotVars <- c("trs_afast",
                    "trs_tfast",
                    "trs_blood_lac",
                    "trs_base_ex",
                    "trs_ion_ca",
                    "trs_pcv",
                    "trs_solids",
                    "trs_glucose")


#' Creates a copy of the VetCot input in a format we can compare
#' 
#' @param VetCotInput A data frame, the VetCot sheet of a trauma center
#' @return A copy of the VetCotInput variable in a format we can use
createRenamedVetCot <- function(VetCotInput, EMRvars, VetCotVars){
  renamedVetCotInput <- VetCotInput
  for(i in 1:length(VetCotVars)){
    if(VetCotVars[i] %in% names(renamedVetCotInput)){
      names(renamedVetCotInput)[names(renamedVetCotInput)==VetCotVars[i]] <- EMRvars[i]
    }
  }
  
  return(renamedVetCotInput)
}

renamedVetCotInput <- createRenamedVetCot(VetCotInput, requiredEMRvars, requiredVetCotVars)
renamedVetCotInput <- createRenamedVetCot(renamedVetCotInput, optionalEMRvars, optionalVetCotVars)
renamedVetCotInput <- createRenamedVetCot(renamedVetCotInput, c("caseNum"), c("tr_case_number"))

EMRvars <- c(requiredEMRvars, optionalEMRvars) 

#' Any columns that aren't in the EMR data can't be used for analysis. This function
#' fills those columns with na
#' 
#' @param renamedVetCotInput The VetCot input
#' @param EMRinput Data extracted from the EMR sheet
#' @param allVariables A vector of all the variables (optional and mandatory) 
#' that can be used for analysis
#' @return The VetCot input with any column that can't be used for analysis filled with na
fillUnusedVetCotColumns <- function(renamedVetCotInput, EMRinput, allVariables){
  for(varName in allVariables){
    if(!(varName %in% names(EMRinput))){
      renamedVetCotInput[[varName]] <- NA
    }
  }
  
  return(renamedVetCotInput)
}

renamedVetCotInput <- fillUnusedVetCotColumns(renamedVetCotInput, EMRinput, EMRvars)

#' Add columns which are needed for analysis if they aren't there
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @return The same dataframe with additional columns initilized to na
supplementRequiredVariables <- function(dataset) {
  for(x in 1:length(requiredEMRvars)) {
    if(!(requiredEMRvars[x] %in% colnames(dataset))) {
      dataset[[requiredEMRvars[x]]] <- NA
    }
  }
  return(dataset)
}

renamedVetCotInput <- supplementRequiredVariables(renamedVetCotInput)
EMRinput <- supplementRequiredVariables(EMRinput)


# Create schoolInput dataframe
# convention: <field>.x = Digital (VetCOT), <field>.y = Paper (EMR)

schoolInput <- merge(renamedVetCotInput, EMRinput, by = "caseNum")

schoolO <- nrow(filter(renamedVetCotInput, is.na("presentationDate")))

schoolInput[schoolInput=="NA"]<-NA

#' Determine if the passed value is a value other than NA or NULL
#' 
#' @param data any data, to be checked
#' @return a boolean, True if data is non-NA and non-NULL, false otherwise
dataExists <- function(data) {
  if(!is.null(data)) {
    if(!is.na(data)) {
      return(T)
    }
  }
  return(F)
}


#' Combine species-specific variables into unified fields
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @return A data frame, a natural join of VetCOT and EMR values with new unified columns added, all other data unchanged
unifySpeciesVariables <- function(dataset) {
  out <- dataset
  
  targets <- c("weightDog", "weightCat",
               "dogAge",    "catAge",
               "dogBreed",  "catBreed")
  
  tgtpair <- c("weightCat", "weightDog",
               "catAge",    "dogAge",
               "catBreed",  "dogBreed")
  
  destinations <- c("weight", "weight",
                    "age",    "age",
                    "breed",  "breed")
  
  for(x in 1:nrow(dataset)) {
    for(y in 1:length(targets)) {
      srcx <- paste(targets[y], ".x", sep="")
      srcy <- paste(targets[y], ".y", sep="")
      pairx <- paste(tgtpair[y], ".x", sep="")
      pairy <- paste(tgtpair[y], ".y", sep="")
      dstx <- paste(destinations[y], ".x", sep="")
      dsty <- paste(destinations[y], ".y", sep="")
      
      if(dataExists(dataset[[srcx]][x])) {
        out[[dstx]][x] <- dataset[[srcx]][x]
      } else if(!dataExists(dataset[[pairx]][x])) {
        out[[dstx]][x] <- NA
      }
      if(dataExists(dataset[[srcy]][x])) {
        out[[dsty]][x] <- dataset[[srcy]][x]
      } else if(!dataExists(dataset[[pairy]][x])) {
        out[[dsty]][x] <- NA
      }
    }
  }
  return(out)
}

schoolInput <- unifySpeciesVariables(schoolInput)

#' Determine if a column is numeric or character
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @param field A string, the field in question
#' @return A boolean, True if numeric, false if otherwise.
columnIsNumeric <- function(dataset, field) {
  for( x in 1:nrow(dataset)) {
    if(suppressWarnings(!is.na(as.numeric(dataset[[field]][[x]])))) {
      return(T)
    }
  }
  return(F)
}

nonNumerics <- c("ID.x",
                 "presentationDate.x",
                 "entryDate.x",
                 "ID.y",
                 "presentationDate.y",
                 "entryDate.y")

#definitions of the continuous numeric variables make the following functions more efficient
#only the fields listed here will be considered for in-depth statistical analysis
continuous <- c("weightCat",
                "weightDog",
                "catAge",
                "dogAge",
                "ionCalcium",
                "pcv",
                "TS",
                "bloodGlucose",
                "bloodLactate",
                "baseExcess",
                "weight",
                "age")


MATCH_THRESHOLD <- 0.0

#' Get the number of matches in a field between VetCot and EMR
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @param field A string, the field to be compared
#' @param total A number, the total valid observations
#' @return A number, the total number of matching fields
getMatches <- function(dataset, field, total) {
  field1 <- paste(field, ".x", sep="")
  field2 <- paste(field, ".y", sep="")
  matching <- 0
  if(field %in% continuous) {
    matching <- nrow(filter(dataset, abs(as.numeric(dataset[[field1]]) - as.numeric(dataset[[field2]])) <= MATCH_THRESHOLD))
  } else {
    matching <- nrow(filter(dataset, dataset[[field1]] == dataset[[field2]]))
  }
  return(matching)
}

#' Get the number of mismatches in a field between VetCot and EMR
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @param field A string, the field to be compared
#' @return A number, the total number of mismatched entries in a fields
getMismatches <- function(dataset, field) {
  field1 <- paste(field, ".x", sep="")
  field2 <- paste(field, ".y", sep="")
  mismatches <- 0
  if(field %in% continuous) {
    mismatches <- nrow(filter(dataset, abs(as.numeric(dataset[[field1]]) - as.numeric(dataset[[field2]])) > MATCH_THRESHOLD))
  } else {
    intermediate <- filter(dataset, !is.na(dataset[[field1]]) & !is.na(dataset[[field2]]))
    mismatches <- nrow(filter(intermediate, intermediate[[field1]] != intermediate[[field2]]))
  }
  return(mismatches)
}

#' Get the number of calculation-valid rows
#'
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @param field A string, the field in question
#' @param optionalTotal A number, the number of records containing optional fields
#' @return A number, the total valid rows
getTotalValid <- function(dataset, field, optionalTotal) {
  field1 <- paste(field, ".x", sep="")
  field2 <- paste(field, ".y", sep="")
  return(nrow(filter(dataset, !is.na(dataset[[field1]]) & !is.na(dataset[[field2]]))))
}

#' Get the number of observations that are missing in a given field
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @param field A string, the field in question
#' @param optionalTotal A number, the number of records containing optional fields
#' @return A number, the total missing fields
getMissing<- function(dataset, field, optionalTotal) {
  field1 <- paste(field, ".x", sep="")
  field2 <- paste(field, ".y", sep="")
  missing <- nrow(filter(dataset, is.na(dataset[[field2]]) | is.na(dataset[[field1]])))
  
  if(F && field %in% optionalEMRvars) {
    neg <- nrow(dataset) - optionalTotal
    missing <- missing - neg
  } else if(field == "ID") {
    #ID is not considered for this calculation, as it causes problems when ID protocol differs between data sources
    missing <- 0
  } else {
    if(F && "presentationDate.x" %in% colnames(dataset)) {
      missing <- missing - nrow(filter(dataset, is.na(presentationDate.x) | is.na(presentationDate.y)))
    }
  }
  if(is.null(missing)) {
    return(0)
  }
  return(missing)
}

#' Get all Error calculations for the trauma center
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @param optionalTotal A number, the number of records containing optional fields
#' @return A data frame, containing the error calculations
getAllErrors <- function(dataset, optionalTotal) {
  out <- data.frame()
  #the total records is the same for all fields
  total <- length(dataset$caseNum)
  for(col in as.vector(colnames(dataset))) {
    colStr <- col
    if(grepl(".x", colStr, fixed = TRUE)) {
      colGen <- gsub("\\.x", "", colStr)
      
      
      totVal <- getTotalValid(dataset, colGen, optionalTotal)
      matches <- getMatches(dataset, colGen)
      
      missing <- getMissing(dataset, colGen, optionalTotal)
      
      mismatches <- getMismatches(dataset, colGen)
      congruity <- round(mismatches / totVal * 100, 2)
      
      #TODO: update checksum
      
      out[colGen, "Variable"]   <- colGen
      out[colGen, "Total"]      <- total
      out[colGen, "Comparisons Possible"]<- totVal
      out[colGen, "Matches"]    <- matches
      out[colGen, "Mismatches"] <- mismatches
      out[colGen, "% Mismatched"]    <- congruity
      
      out[colGen, "Missing Values"]    <- missing
    }
  }
  return(out)
}

#' Test equality of two values, either of which may be na
#' 
#' @param a Any data, so long as it is the same type as b
#' @param b Any data, so long as it is the same type as a
#' @return a boolean, a == b (the way you would expect that to work)
atomicEquality <- function(a, b) {
  if(is.na(a) && is.na(b)) {
    return(T)
  } else if (xor(is.na(a), is.na(b))){
    return(F)
  } else {
    return(a == b)
  }
}

#' If the two values taken don't match, an incremented mismatch is returned, otherwise mismatch is returned
#' 
#' @param mismatch The number of mismatches found so far
#' @param VetCotField The name of the field being compared
#' @param VetCotFieldValue The value found in the VetCot field for this entry
#' @param EMRfieldValue The value found in the EMR field for this entry
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @return The new number of mismatches
incrementMismatchIfNeeded <- function(mismatch, VetCotField, VetCotFieldValue, EMRfieldValue, dataset){
  if(is.na(VetCotFieldValue) || is.na(EMRfieldValue)) {
    mismatch <- mismatch + 1
  }
  else if(columnIsNumeric(dataset, VetCotField) && !(VetCotField %in% nonNumerics)) {
    if(!is.na(abs(as.numeric(VetCotFieldValue) - as.numeric(EMRfieldValue)) > MATCH_THRESHOLD)) {
      if(abs(as.numeric(VetCotFieldValue) - as.numeric(EMRfieldValue)) > MATCH_THRESHOLD) {
        #this horrendous nest of if statements brought to you by a complete lack agreement between data source protocols
        mismatch <- mismatch + 1
      }
    }
  } else {
    if(is.na(VetCotFieldValue) || is.na(EMRfieldValue)) {
      mismatch <- mismatch + 1
    }
    else if(VetCotFieldValue != EMRfieldValue) {
      mismatch <- mismatch + 1
    }
  }
  
  return(mismatch)
}

#' Helper function for createMissingSummary. Creates one missing summary row and returns it.
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @param total The total number of comparisons that can be made
#' @param mismatch The total number of mismatches found
#' @return A row to be inserted into the missing summary
createMissingSummaryRow <- function(dataset, total, mismatch){
  out <- data.frame()
  
  speciesFlag <- F
  dateFlag <- F
  out[dataset[["caseNum"]][1], "Case Number"] <- dataset[["caseNum"]][1]
  out[dataset[["caseNum"]][1], "Total Mismatches"] <- mismatch
  out[dataset[["caseNum"]][1], "Total variables screened"] <- total
  
  if(atomicEquality(dataset[["species.x"]][1], dataset[["species.y"]][1])) {
    out[dataset[["caseNum"]][1], "Species Match?"] <- "Yes"
    speciesFlag <- T
  } else {
    out[dataset[["caseNum"]][1], "Species Match?"] <- "No"
  }
  if(atomicEquality(dataset[["presentationDate.x"]][1], dataset[["presentationDate.y"]][1])) {
    out[dataset[["caseNum"]][1], "Presentation Date Match?"] <- "Yes"
    dateFlag <- T
  } else {
    out[dataset[["caseNum"]][1], "Presentation Date Match?"] <- "No"
  }
  if(speciesFlag && dateFlag) {
    out[dataset[["caseNum"]][1], "All Critical Factors Match?"] <- "Yes"
  } else {
    out[dataset[["caseNum"]][1], "All Critical Factors Match?"] <- "No"
  }
  
  return(out)
}

#' Get a summary of the number of mismatched field entries by case number from the trauma center
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @return A data frame, the number of mismatched field entries organized by case number
getMissingSummary <- function(dataset) {
  out <- data.frame("Case Number" = character(),
                    "Total Mismatches" = numeric(),
                    "Total Variables screened" = numeric(),
                    "Species Match?" = character(),
                    "Presentation Date Match?" = character(),
                    "All Critical Factors Match?" = character())
  
  for(x in 1:nrow(dataset)) {
    mismatch <- 0
    total <- 0
    i <- 1
    for(field in  as.vector(colnames(dataset))) {
      #we only want to consider each variable once, so the '.x' variant is chosen arbitrarily
      if(grepl(".x", field, fixed=TRUE)) {
        VetCotField <- field
        EMRfield <- paste(gsub("\\.x", "", VetCotField), ".y", sep="")
        
        VetCotFieldValue <- dataset[[VetCotField]][x]
        EMRfieldValue <- dataset[[EMRfield]][x]
        
        canCompare <- !is.na(VetCotFieldValue) || !is.na(EMRfieldValue)
        if(canCompare) {
          i<- i+1
          
          total <- total + 1
          mismatch <- incrementMismatchIfNeeded(mismatch, VetCotField, VetCotFieldValue, EMRfieldValue, dataset)
        }
      }
    }
    
    out[x, ] <- createMissingSummaryRow(dataset[x, ], total, mismatch)
  }

  return(out)
}

summary <- getMissingSummary(schoolInput)

schoolError <- getAllErrors(schoolInput, schoolO)

#' Generate a Data Frame of discrepancies between VetCot and EMR fields
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @param flip A boolean, indicating the subtraction direction, T=Vetcot-EMR, F=EMR-Vetcot
#' @return A data frame, the discrepancy between VetCot and EMR for all fields in original dataset
getDiscrepancyDF <- function(dataset, flip=F) {
  cont <- data.frame()
  casenums <- dataset$caseNum
  for(x in 1:length(casenums)) {
    thisCont <- filter(dataset, grepl(casenums[x], caseNum))
    cont[x,"casenum"] <- casenums[x]
    for(y in 1:length(continuous)) {
      field1 <- paste(continuous[y], ".x", sep="")
      field2 <- paste(continuous[y], ".y", sep="")
      
      if(field1 %in% colnames(thisCont) && field2 %in% colnames(thisCont)) {
        l1 <- length(thisCont[[field1]])
        l2 <- length(thisCont[[field2]])
        
        if(l1 == 1 && l2 == 1) {
          vtc <- thisCont[[field1]]
          emr <- thisCont[[field2]]
          
          if(!is.na(vtc) && !is.na(emr)) {
            if(flip) {
              diff <- abs(as.numeric(thisCont[[field1]]) - as.numeric(thisCont[[field2]]))
              if(abs(diff) > MATCH_THRESHOLD || is.na(diff)) {
                cont[x,continuous[y]] <- diff
              } else {
                cont[x,continuous[y]] <- NA
              }
            } else {
              diff<- as.numeric(thisCont[[field1]]) - as.numeric(thisCont[[field2]])
              if(abs(diff) > MATCH_THRESHOLD || is.na(diff)) {
                cont[x,continuous[y]] <- diff
              } else {
                cont[x,continuous[y]] <- NA
              }
            }
          }
          else {
            cont[x,continuous[y]] <- NA
          }
        }
      }
    }
  }
  return(cont)
}

#' Get the percentage of the VetCot value that each discrepancy represents for all fields
#' 
#' @param discrep A data frame, the discrepancies for continuous fields by case number
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @param fields A vector, containing the fields to be considered (usually continuous, defined above)
#' @return A data frame, the % discrepancy between VetCot and EMR for all fields, relative to VetCot value
getPercentDiscrepancyRangeDF <- function(discrep, dataset, fields) {
  perc <- data.frame()
  caseNums <- discrep$casenum
  for(x in 1:length(caseNums)) {
    perc[x, "casenum"] <- caseNums[x]
    #only handling one record at a time
    theseData <- filter(dataset, grepl(caseNums[x], caseNum))
    for(y in 1:length(fields)) {
      field <- fields[y]
      fieldtgt <- paste(field, ".y", sep="")
      if(fieldtgt %in% colnames(theseData) && field %in% colnames(discrep)) {
        if(!is.na(discrep[x,field]) && !is.na(theseData[[fieldtgt]])) {
          if(abs(discrep[x, field]) > MATCH_THRESHOLD) {
            if(as.numeric(theseData[[fieldtgt]]) != 0){
              perc[x, field] <- abs(round(as.numeric(discrep[x, field]) / as.numeric(theseData[[fieldtgt]]) * 100, 2))
            } else{
              perc[x, field] <- 100
            }
          } else {
            perc[x,field] <- NA
          }
        } else {
          perc[x,field] <- NA
        }
      } else {
        perc[x, field] <- NA
      }
    }
  }
  return(perc)
}

#' Get various discrepancy calculations for all fields in a trauma set
#' Requires previous calculation of % error, via getAllErrors()
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @param columns A list of fields to be considered for append operation
#' @param toAppend A data frame, the result of getAllErrors(dataset)
#' @return A data frame, containing the % errors and discrepancy calculations for dataset
getResults <- function(dataset, columns, toAppend) {
  fields <- as.vector(columns)
  results <- as.data.frame(toAppend, check.names=F, fix.empty.names=F)
  A <- getDiscrepancyDF(dataset, F)
  B <- getDiscrepancyDF(dataset, T)
  percA <- getPercentDiscrepancyRangeDF(A, dataset, continuous)
  percB <- getPercentDiscrepancyRangeDF(B, dataset, continuous)
  for(x in 1:length(fields)) {
    if(fields[x] %in% colnames(A)) {
      results[fields[x], "Min Diff"]       <- min(A[[fields[x]]],        na.rm=T)
      results[fields[x], "Max Diff"]       <- max(A[[fields[x]]],        na.rm=T)
      results[fields[x], "Median Diff"]    <- median(A[[fields[x]]],     na.rm=T)
      results[fields[x], "Min % Diff"]     <- min(percA[[fields[x]]],    na.rm=T)
      results[fields[x], "Max % Diff"]     <- max(percA[[fields[x]]],    na.rm=T)
      results[fields[x], "Median % Diff"]  <- median(percA[[fields[x]]], na.rm=T)
      results[fields[x], "Min |Diff|"]     <- min(B[[fields[x]]],        na.rm=T)
      results[fields[x], "Max |Diff|"]     <- max(B[[fields[x]]],        na.rm=T)
      results[fields[x], "Median |Diff|"]  <- median(B[[fields[x]]],     na.rm=T)
      results[fields[x], "Min % |Diff|"]   <- min(percB[[fields[x]]],    na.rm=T)
      results[fields[x], "Max % |Diff|"]   <- max(percB[[fields[x]]],    na.rm=T)
      results[fields[x], "Median % |Diff|"]<- median(percB[[fields[x]]], na.rm=T)
    }
  }
  return(results)
}

#' Takes a dataset and a case number and returns only 
#' the rows of the dataset that have that case number
#' 
#' @param caseNumber A case number to be searched for
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @return A dataframe with only the rows matching the given case number
extractDuplicateRows = function(caseNumber, dataset){
  return(filter(dataset, tr_case_number == caseNumber))
}

#' Counts the number of times that an item occures in a vector
#' 
#' @param vectorWithDuplicates A vector which has multiple entries and may have duplicates
#' @param itemToCompare The item to test if it has duplicates
#' @return All the rows where the duplicate item appears
countRepeats = function(vectorWithDuplicates, itemToCompare){
  return(table(vectorWithDuplicates)[names(table(vectorWithDuplicates)) == itemToCompare])
}

#' Prepares a row to be appended after a duplicate has been found in a dataset
#' 
#' @param caseNum The caseNumber of the duplicate
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @return A row to append to the duplicates already found
createDuplicatesRow = function(caseNum, dataset){
  out = data.frame()
  out[1, "Case Number"] = caseNum
  
  occuranceRows = extractDuplicateRows(caseNum, dataset)
  duplicateCount = nrow(occuranceRows)
  dateMatches = countRepeats(occuranceRows$tr_date_of_hosp, occuranceRows$tr_date_of_hosp[1])
  
  out[1, "Number of Occurrences"] = duplicateCount
  out[1, "Presentation Date Matches"] = dateMatches
  out[1, "Presentation Date Mismatches"] = duplicateCount - dateMatches
  
  return(out[1, ])
}

#' Takes a dataset and returns a data frame of duplicate case numbers
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @return A dataframe with all the duplicate case numbers in the dataset
getDuplicateCaseNums <- function(dataset) {
  out = data.frame("Case Number" = character(),
                   "Number of Occurrences" = numeric(),
                   "Presentation Date Matches" = numeric(),
                   "Presentation Date Mismatches" = numeric())
  
  outRow = 1
  checkedCaseNums = c()
  for(i in 2:nrow(dataset)){
    currCaseNum = dataset$tr_case_number[i]
    for(j in 1:(i - 1)){
      checkCaseNum = dataset$tr_case_number[j]
      if(!is.na(currCaseNum) && !is.na(checkCaseNum)) {
        if(currCaseNum == checkCaseNum && !(currCaseNum %in% checkedCaseNums)){
          out[outRow, ] = createDuplicatesRow(currCaseNum, dataset)
          checkedCaseNums[outRow] = currCaseNum
          outRow = outRow + 1
        }
      }
    }
  }
  
  return(out)
}


dupsSheet = getDuplicateCaseNums(VetCotInput)

#' Create a data frame with VetCot and EMR any variable reading side by side
#' 
#' @param dataset A data frame, a natural join of VetCOT and EMR values
#' @param var A string, the variable to compare side by side
#' @return A data frame, the pcv readings side by side
getSideBySide <- function(dataset, var) {
  out <- data.frame()
  varx = paste(var, ".x", sep = "")
  vecX = dataset[[varx]]
  vary = paste(var, ".y", sep = "")
  vecY = dataset[[vary]]
  count = 1
  for(i in 1:nrow(dataset)) {
    if(!is.na(vecX[i]) && !is.na(vecY[i])){
      out[count, "Case Number"] = dataset[["caseNum"]][i]
      out[count, "ID"]          = dataset[["ID.x"]][i]
      out[count, "RedCAP"]     <- dataset[[varx]][i]
      out[count, "EMR"]        <- dataset[[vary]][i]
      if(var == "pcv"){
        #get bloodProducts value
        if(is.na(dataset[["bloodProductsYN.x"]][i])){
          rowNum = match(dataset[["caseNum"]][i], VetCotInput$tr_case_number)
          out[count, "Blood Products (Y/N)"] = VetCotInput$o_blood_yn[[rowNum]][1]
        } else{
          out[count, "Blood Products (Y/N)"] = dataset[["bloodProductsYN.x"]][i]
        }
        #get outcome value
        if(is.na(dataset[["outcome.x"]][i])){
          rowNum = VetCotInput$tr_case_number == dataset[["caseNum"]][i]
          out[count, "Outcome"] = VetCotInput$o_outcome[rowNum][1]
        } else{
          out[count, "Outcome"] = dataset[["outcome.x"]][i][1]
        }
      }
      count = count + 1
    }
  }
  return(out)
}

sideBySide <- getSideBySide(schoolInput, SideBySideComparisonVariable)

#' Get all discrepancy calculations for multiple data sets
#' 
#' @param sets A list of a data frame, a natural join of VetCOT and EMR values
#' @param columns A vector of strings, the fields that will be included in analysis (must be continuous, numerical variables)
#' @param errors A list of a data frame, the ERROR sheets for the trauma center (as calculated by getAllErrors())
#' @param names A vector of strings, the names of each sheet in the exported .xlsx file
#' @return Void, but will export .xlsx file
getAllResults <- function(sets, columns, errors, names) {
  bundled <- list()
  for(x in 1:length(names)) {
    if(x == length(names)) {
      bundled[[names[x]]] <- summary
    } else if(x == length(names)-2){
      bundled[[names[x]]] = dupsSheet
    } else if(x == length(names)-1){
      bundled[[names[x]]] = sideBySide
    } else {
      theseResults <- getResults(as.data.frame(sets[x], check.names=F, fix.empty.names=F), columns, as.data.frame(errors[x], check.names=F, fix.empty.names=F))
      bundled[[names[x]]] <- as.data.frame(theseResults)
    }
  }
  fname = "./Current Build/Output/Output_Accuracy.xlsx"
  
  write_xlsx(bundled, fname, format_headers=T)
}

sets <- list(schoolInput)
errors <- list(schoolError)
names <- c("Accuracy Results", 
           "Duplicate Count", 
           "PCV Comparison", 
           "Mismatches per Case")

getAllResults(sets, continuous, errors, names)

print("Analysis Complete!")
