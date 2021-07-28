# Automatically Generated Documentation for .\analyzerClinicallyRelevant.R
## getAFASTOutliers
Get cases with AFAST score greater than or equal to 3
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, the VetCot sheet of a trauma center |

### Return
a data frame, containing all AFAST outlier cases

---
## integerToDate
Turns an Excel style date into a human style date. It allows the 
### Parameters
| Parameter | Description |
| --- | --- |
| dateNumber | A number which Excel used to represent a date |

### Return
A date in a format a human would recognize

---
## integersToDates
Turns a column of Excel dates into human readable format
### Parameters
| Parameter | Description |
| --- | --- |
| dateColumn | A column tibble of Excel format dates |

### Return
A column of dates in human readable format

---
## fixDates
Turns all the dates on a VetCot sheet into human readable format
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, the VetCot sheet of a trauma center |

### Return
A sheet of VetCot data with dates in human readable format

---
## getScoreThreshold
Get all records where a chosen field exceeds or falls below a given threshold
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, the VetCot sheet of a trauma center |
| field | A string, the massaged field to be targeted |
| tC | A string, the trauma center's code in the VetCotInput dataset, -1 for no filter, not used for this version |
| threshold | A number, the threshold |
| greater | A boolean, True=Greater than threshold, False=Less than threshold |

### Return
A data frame, the subset where the field exceeds or falls below the threshold

---
