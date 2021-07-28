# Automatically Generated Documentation for .\analyzerAccuracyV2.R
## createRenamedVetCot
Creates a copy of the VetCot input in a format we can compare
### Parameters
| Parameter | Description |
| --- | --- |
| VetCotInput | A data frame, the VetCot sheet of a trauma center |

### Return
A copy of the VetCotInput variable in a format we can use

---
## fillUnusedVetCotColumns
Any columns that aren't in the EMR data can't be used for analysis. This function
### Parameters
| Parameter | Description |
| --- | --- |
| renamedVetCotInput | The VetCot input |
| EMRinput | Data extracted from the EMR sheet |
| allVariables | A vector of all the variables (optional and mandatory)  |

### Return
The VetCot input with any column that can't be used for analysis filled with na

---
## supplementRequiredVariables
Add columns which are needed for analysis if they aren't there
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |

### Return
The same dataframe with additional columns initilized to na

---
## dataExists
Determine if the passed value is a value other than NA or NULL
### Parameters
| Parameter | Description |
| --- | --- |
| data | any data, to be checked |

### Return
a boolean, True if data is non-NA and non-NULL, false otherwise

---
## unifySpeciesVariables
Combine species-specific variables into unified fields
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |

### Return
A data frame, a natural join of VetCOT and EMR values with new unified columns added, all other data unchanged

---
## columnIsNumeric
Determine if a column is numeric or character
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |
| field | A string, the field in question |

### Return
A boolean, True if numeric, false if otherwise.

---
## getMatches
Get the number of matches in a field between VetCot and EMR
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |
| field | A string, the field to be compared |
| total | A number, the total valid observations |

### Return
A number, the total number of matching fields

---
## getMismatches
Get the number of mismatches in a field between VetCot and EMR
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |
| field | A string, the field to be compared |

### Return
A number, the total number of mismatched entries in a fields

---
## getTotalValid
Get the number of calculation-valid rows
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |
| field | A string, the field in question |
| optionalTotal | A number, the number of records containing optional fields |

### Return
A number, the total valid rows

---
## getMissing<-
Get the number of observations that are missing in a given field
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |
| field | A string, the field in question |
| optionalTotal | A number, the number of records containing optional fields |

### Return
A number, the total missing fields

---
## getAllErrors
Get all Error calculations for the trauma center
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |
| optionalTotal | A number, the number of records containing optional fields |

### Return
A data frame, containing the error calculations

---
## atomicEquality
Test equality of two values, either of which may be na
### Parameters
| Parameter | Description |
| --- | --- |
| a | Any data, so long as it is the same type as b |
| b | Any data, so long as it is the same type as a |

### Return
a boolean, a == b (the way you would expect that to work)

---
## incrementMismatchIfNeeded
If the two values taken don't match, an incremented mismatch is returned, otherwise mismatch is returned
### Parameters
| Parameter | Description |
| --- | --- |
| mismatch | The number of mismatches found so far |
| VetCotField | The name of the field being compared |
| VetCotFieldValue | The value found in the VetCot field for this entry |
| EMRfieldValue | The value found in the EMR field for this entry |
| dataset | A data frame, a natural join of VetCOT and EMR values |

### Return
The new number of mismatches

---
## createMissingSummaryRow
Helper function for createMissingSummary. Creates one missing summary row and returns it.
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |
| total | The total number of comparisons that can be made |
| mismatch | The total number of mismatches found |

### Return
A row to be inserted into the missing summary

---
## getMissingSummary
Get a summary of the number of mismatched field entries by case number from the trauma center
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |

### Return
A data frame, the number of mismatched field entries organized by case number

---
## getDiscrepancyDF
Generate a Data Frame of discrepancies between VetCot and EMR fields
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |
| flip | A boolean, indicating the subtraction direction, T=Vetcot-EMR, F=EMR-Vetcot |

### Return
A data frame, the discrepancy between VetCot and EMR for all fields in original dataset

---
## getPercentDiscrepancyRangeDF
Get the percentage of the VetCot value that each discrepancy represents for all fields
### Parameters
| Parameter | Description |
| --- | --- |
| discrep | A data frame, the discrepancies for continuous fields by case number |
| dataset | A data frame, a natural join of VetCOT and EMR values |
| fields | A vector, containing the fields to be considered (usually continuous, defined above) |

### Return
A data frame, the % discrepancy between VetCot and EMR for all fields, relative to VetCot value

---
## getResults
Get various discrepancy calculations for all fields in a trauma set
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |
| columns | A list of fields to be considered for append operation |
| toAppend | A data frame, the result of getAllErrors(dataset) |

### Return
A data frame, containing the % errors and discrepancy calculations for dataset

---
## extractDuplicateRows
Takes a dataset and a case number and returns only 
### Parameters
| Parameter | Description |
| --- | --- |
| caseNumber | A case number to be searched for |
| dataset | A data frame, a natural join of VetCOT and EMR values |

### Return
A dataframe with only the rows matching the given case number

---
## countRepeats
Counts the number of times that an item occures in a vector
### Parameters
| Parameter | Description |
| --- | --- |
| vectorWithDuplicates | A vector which has multiple entries and may have duplicates |
| itemToCompare | The item to test if it has duplicates |

### Return
All the rows where the duplicate item appears

---
## createDuplicatesRow
Prepares a row to be appended after a duplicate has been found in a dataset
### Parameters
| Parameter | Description |
| --- | --- |
| caseNum | The caseNumber of the duplicate |
| dataset | A data frame, a natural join of VetCOT and EMR values |

### Return
A row to append to the duplicates already found

---
## getDuplicateCaseNums
Takes a dataset and returns a data frame of duplicate case numbers
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |

### Return
A dataframe with all the duplicate case numbers in the dataset

---
## getSideBySide
Create a data frame with VetCot and EMR any variable reading side by side
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, a natural join of VetCOT and EMR values |
| var | A string, the variable to compare side by side |

### Return
A data frame, the pcv readings side by side

---
## getAllResults
Get all discrepancy calculations for multiple data sets
### Parameters
| Parameter | Description |
| --- | --- |
| sets | A list of a data frame, a natural join of VetCOT and EMR values |
| columns | A vector of strings, the fields that will be included in analysis (must be continuous, numerical variables) |
| errors | A list of a data frame, the ERROR sheets for the trauma center (as calculated by getAllErrors()) |
| names | A vector of strings, the names of each sheet in the exported .xlsx file |

### Return
Void, but will export .xlsx file

---
