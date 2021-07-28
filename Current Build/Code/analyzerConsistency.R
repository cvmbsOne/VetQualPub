#Copyright 2020 Owen Davidson, Carson Eliasen, & James Rudd, Colorado State University
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
#to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
#and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
#WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

library(readxl)
library(writexl)
library(dplyr)

##### REMEMBER #####
#Set working directory to project directory
#Session -> Set Working Directory -> To Project Directory


#File path for the school trauma center's .xlsx file
schoolInputPath  = "./Current Build/Input/CopyOfCSU-sep.xlsx"

##################################################################################
##################################################################################
###### IF RUNNING FOR DEFAULT ANALYSIS, DO NOT EDIT ANYTHING PAST THIS LINE ######
##################################################################################
##################################################################################

VetCotInput <- read_excel(schoolInputPath, sheet=1, col_types = "text")

dogVars <- c("tr_dog_breed", "tr_age_canine", "tr_weight")
catVars <- c("tr_cat_breed", "tr_feline_age", "tr_weight2_436")

#' Get the completeness of each variable in a dataset by case number
#' 
#' @param dataset A data frame, the VetCot sheet of a trauma center
#' @return A data frame, containing the entered and blank counts of each variable 
getCompletenessByVariable <- function(dataset) {
  out <- data.frame()
  fields <- as.vector(colnames(dataset))
  for(field in fields) {
    entered <- 0 
    blank <- 0
    
    #the nest of if statements in this function exists because the trauma type variable is counted 
    #differently to other variables in terms of completeness calculations, because they are only to 
    #be counted as incomplete if certain preconditions are also met
    
    for(x in 1:nrow(dataset)) {
      if(field %in% dogVars) {
        if(dataset[["tr_species"]][x] == 1) {
          if(!is.na(dataset[[field]][x])) {
            entered <- entered + 1
          } else {
            blank <- blank + 1
          }
        }
      } else if (field %in% catVars) {
        if(dataset[["tr_species"]][x] == 2) {
          if(!is.na(dataset[[field]][x])) {
            entered <- entered + 1
          } else {
            blank <- blank + 1
          }
        } 
      } else if (field == "tr_trauma_blunt") {
        if(!is.na(dataset[["tr_trauma_type"]][x])) {
          if(dataset[["tr_trauma_type"]][x] == 1 || dataset[["tr_trauma_type"]][x] == 3) {
            if(!is.na(dataset[[field]][x])) {
              entered <- entered + 1
            } else {
              blank <- blank + 1
            }
          }
        }
      } else if (field == "tr_trauma_penet") {
        if(!is.na(dataset[["tr_trauma_type"]][x])) {
          if(dataset[["tr_trauma_type"]][x] == 2 || dataset[["tr_trauma_type"]][x] == 3) {
            if(!is.na(dataset[[field]][x])) {
              entered <- entered + 1
            } else {
              blank <- blank + 1
            }
          }
        }
      }
      else {
        if(!is.na(dataset[[field]][x])) {
          entered <- entered + 1
        } else {
          blank <- blank + 1
        }
      }
      perc <- round(entered / (entered + blank) * 100, 2)
      out[field, "Variable"] <- field
      out[field, "Total Entries"] <- entered
      out[field, "Fields Left Blank"] <- blank
      out[field, "Percent completeness"] <- perc
    }
  }
  return(out)
}

#date consistency analysis

regIndate  = 'tr_date_of_hosp'
regOutdate = 'o_outcome_dt'

traumaDate = 'tr_date_of_trauma'

#' Turns an Excel style date into a human style date. It allows the 
#' final results to be human readable.
#' 
#' @param dateNumber A number which Excel used to represent a date
#' @return A date in a format a human would recognize
integerToDate <- function(dateNumber){
  return(as.Date.numeric(as.numeric(dateNumber), origin="1899-12-30"))
}

#' Get all cases where two dates are metaphysically impossible
#' 
#' @param dataset A data frame, the VetCot sheet of a trauma center
#' @param indate  A number, the int representation of a date code - the supposed "before" time.
#' @param indate  A number, the int representation of a date code - the supposed "after" time.
#' @return A number, a total in dataset where the dates are impossible.
getDateInconsistency <- function(dataset, indate, outdate) {
  out <- data.frame()
  inconsistent <- filter(dataset, dataset[[indate]] > dataset[[outdate]])
  if(!is.na(inconsistent$tr_case_number[1])){
    for(x in 1:nrow(inconsistent)) {
      out[inconsistent$tr_case_number[x], "caseNum"] <- inconsistent$tr_case_number[x]
      out[inconsistent$tr_case_number[x], "ID"] <- inconsistent$tr_subject_id[x]
      out[inconsistent$tr_case_number[x], indate] <- integerToDate(inconsistent[[indate]][x])
      out[inconsistent$tr_case_number[x], outdate] <-integerToDate(inconsistent[[outdate]][x])
    }
  }
  return(out)
}

regDateInconsistency <- getDateInconsistency(VetCotInput, regIndate, regOutdate)
traumaDateInconsistency <- getDateInconsistency(VetCotInput, traumaDate, regIndate)



smallDogBreeds <- list("5001" = "Affenpinscher",              "5009" = "American Eskimo", 
                       "5011" = "American Hairless Terrier",  "5018" = "Australian Terrier", 
                       "5019" = "Basenji",                    "5024" = "Bedlington Terrier", 
                       "5032" = "Bichon Frise",               "5037" = "Bolognese",
                       "5041" = "Boston Terrier",             "5049" = "Brussels Griffon", 
                       "5057" = "Cavalier King Charles Span", "5060" = "Chihuahua", 
                       "5061" = "Chihuahua L Hair",           "5067" = "Cocker Spaniel", 
                       "5076" = "Dachshund",                  "5077" = "Dachshund L Hair",
                       "5078" = "Dachshund Wire-Hair",        "5094" = "English Toy Spaniel", 
                       "5110" = "German Spitz",               "5113" = "Glen of Imaal Terrier", 
                       "5123" = "Havanese",                   "5134" = "Italian Greyhound", 
                       "5135" = "Jack Russell Terrier",       "5136" = "Japanese Chin",
                       "5154" = "Maltese Dog",                "5155" = "Manchester Terrier", 
                       "5161" = "Miniature Dachshund",        "5162" = "Miniature Pinscher", 
                       "5164" = "Miniature Schnauzer",        "5171" = "Norfolk Terrier", 
                       "5175" = "Norwich Terrier",            "5180" = "Papillon",
                       "5182" = "Pekingese",                  "5188" = "Pomeranian", 
                       "5192" = "Pug",                        "5203" = "Schipperke", 
                       "5204" = "Scottish Terrier",           "5207" = "Shetland Sheepdog", 
                       "5208" = "Shiba Inu",                  "5209" = "Shih Tzu",
                       "5212" = "Silky Terrier",              "5233" = "Tibetan Terrier", 
                       "5234" = "Toy Poodle",                 "5246" = "Yorkshire Terrier",
                       "5163" = "Minuiature Poodle")

largeDogBreeds <- list("5002" = "AFGHAN HOUND",               "5004" = "AKITA",
                       "5007" = "ALASKAN MALAMUTE",           "5023" = "BEAUCERON",
                       "5026" = "BELGIAN MALINOIS",           "5027" = "BELGIAN SHEEPDOG",
                       "5028" = "BELGIAN TERVUREN",           "5030" = "BERGER PICARD",
                       "5031" = "BERNESE MOUNTAIN DOG",       "5033" = "BLACK RUSSIAN TERRIER",
                       "5034" = "BLOODHOUND",                 "5043" = "BOXER",
                       "5045" = "BRACCO ITALIANO",            "5050" = "BULL MASTIFF",
                       "5055" = "CANE CORSO",                 "5075" = "CURLY COAT RETRIEVER",
                       "5085" = "DOBERMAN PINSCHER",          "5086" = "DOGO ARGENTINO",
                       "5087" = "DOGUE DE BORDEAUX",          "5118" = "GREAT DANE",
                       "5119" = "GREAT PYRENEES",             "5125" = "IBIZAN HOUND",
                       "5133" = "IRISH WOLFHOUND",            "5142" = "KOMONDOR",
                       "5143" = "KUVASZ",                     "5148" = "LEONBERGER",
                       "5157" = "MASTIFF",                    "5168" = "NEOPOLITAN MASTIFF",
                       "5170" = "NEWFOUNDLAND",               "5179" = "OTTERHOUND", 
                       "5199" = "ROTTWEILER",                 "5221" = "ST BERNARD",
                       "5231" = "TIBETAN MASTIFF",            "5239" = "WEIMARANER")

#' Get a subset of dog cases where a specified breed is above or below a weight threshold 
#' 
#' @param dataset A data frame, the VetCot sheet of a trauma center
#' @param breeds A list, containing numerical codes for each dog breed to be considered
#' @param weight A number, a threshold that dogs will be included if ABOVE
#' @param toAppend A data frame, to which the subset will be added (usually blank)
#' @return A data frame, containing all dogs of specified breeds that exceed threshold.
getSubsetDogs <- function(dataset, breeds, weight, toAppend) {
  subsetDogs <- toAppend
  dogsOfBreed <- filter(dataset, (dataset[['tr_dog_breed']] %in% names(breeds)))
  dogsOfBreed <- filter(dogsOfBreed, as.numeric(dogsOfBreed[['tr_weight']]) > weight)
  if(nrow(dogsOfBreed) == 0) {
    return(NULL)
  }
  for(x in 1:nrow(dogsOfBreed)) {
    subsetDogs[dogsOfBreed$tr_case_number[x], 'REDCap ID']      <- dogsOfBreed$tr_subject_id[x]
    subsetDogs[dogsOfBreed$tr_case_number[x], 'Case Number']    <- dogsOfBreed$tr_case_number[x]
    subsetDogs[dogsOfBreed$tr_case_number[x], 'Dog Breed Code'] <- dogsOfBreed$tr_dog_breed[x]
    subsetDogs[dogsOfBreed$tr_case_number[x], 'Weight(kg)']     <- dogsOfBreed$tr_weight[x]
    subsetDogs[dogsOfBreed$tr_case_number[x], 'Age(yrs)']       <- dogsOfBreed$tr_age_canine[x]
    subsetDogs[dogsOfBreed$tr_case_number[x], 'Breed Name']     <- breeds[[dogsOfBreed$tr_dog_breed[x]]]
  }
  return(subsetDogs)
}

smallDogs <- getSubsetDogs(VetCotInput, smallDogBreeds, 10, data.frame())

bigDogs <- getSubsetDogs(VetCotInput, largeDogBreeds, 40, data.frame())



#' Get a subset of cat cases where a specified breed is above or below a weight threshold 
#' 
#' @param dataset A data frame, the VetCot sheet of a trauma center
#' @param weight A number, a threshold that cats will be included if ABOVE
#' @return A data frame, containing all cats of specified breeds that exceed threshold.
getSubsetCats <- function(dataset, weight) {
  subsetCats <- data.frame()
  catsOfWeight <- filter(dataset, as.numeric(dataset[['tr_weight2_436']]) > weight)
  if(nrow(catsOfWeight) == 0) {
    return(NULL)
  }
  for(x in 1:nrow(catsOfWeight)) {
    subsetCats[catsOfWeight$tr_case_number[x], 'REDCap ID']   <- catsOfWeight$tr_subject_id[x]
    subsetCats[catsOfWeight$tr_case_number[x], 'Case Number'] <- catsOfWeight$tr_case_number[x]
    subsetCats[catsOfWeight$tr_case_number[x], 'Weight(kg)']  <- catsOfWeight$tr_weight2_436[x]
    subsetCats[catsOfWeight$tr_case_number[x], 'Age(yrs)']    <- catsOfWeight$tr_feline_age[x]
  }
  return(subsetCats)
}

bigCats <- getSubsetCats(VetCotInput, 10)


#' Get all dogs exceeding a certain age
#' 
#' @param dataset A data frame, the VetCot sheet of a trauma center
#' @param age A number, the age threshold
#' @param weightTreshold A number, the lower limit of weights to filter out, i.e. all dogs this weight and above will be filtered out
#' @return A data frame, all dog cases where the patient exceeds the age threshold
getAgeSubsetDogs <- function(dataset, age, weightTreshold) {
  subset <- data.frame()
  dogsOfAge <- filter(dataset, dataset[['tr_dog_breed']] %in% names(largeDogBreeds))
  dogsOfAge <- filter(dogsOfAge, as.numeric(dogsOfAge[['tr_age_canine']]) > age)
  dogsOfAge <- filter(dogsOfAge, as.numeric(dogsOfAge[['tr_weight']]) < weightTreshold)
  if(nrow(dogsOfAge) == 0) {
    return(NULL)
  }
  for(x in 1:nrow(dogsOfAge)) {
    subset[dogsOfAge$tr_case_number[x], 'REDCap ID']      <- dogsOfAge$tr_subject_id[x]
    subset[dogsOfAge$tr_case_number[x], 'Case Number']    <- dogsOfAge$tr_case_number[x]
    subset[dogsOfAge$tr_case_number[x], 'Age(yrs)']       <- dogsOfAge$tr_age_canine[x]
    subset[dogsOfAge$tr_case_number[x], 'Weight(kg)']     <- dogsOfAge$tr_weight[x]
    subset[dogsOfAge$tr_case_number[x], 'Dog Breed Code'] <- dogsOfAge$tr_dog_breed[x]
    subset[dogsOfAge$tr_case_number[x], 'Breed Name']     <- largeDogBreeds[[dogsOfAge$tr_dog_breed[x]]]
  }
  return(subset)
}

oldDogs <- getAgeSubsetDogs(VetCotInput, 0.2, 15)

percentComplete <- getCompletenessByVariable(VetCotInput)

fname = "./Current Build/Output/Output_Consistency_And_Completeness.xlsx"

write_xlsx(list("Small Canines > 10kg"            = as.data.frame(smallDogs),
                "Canines > 40kg"                  = as.data.frame(bigDogs),
                "Felines > 10kg"                  = as.data.frame(bigCats),
                "Large Breeds >3mos and <15kg"    = as.data.frame(oldDogs),
                "Presentation < Trauma"           = as.data.frame(traumaDateInconsistency),
                "Outcome < Presentation"          = as.data.frame(regDateInconsistency),
                Completeness                      = as.data.frame(percentComplete)), fname)

print("Analysis Complete!")
