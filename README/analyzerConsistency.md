# Automatically Generated Documentation for .\analyzerConsistency.R
## getCompletenessByVariable
Get the completeness of each variable in a dataset by case number
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, the VetCot sheet of a trauma center |

### Return
A data frame, containing the entered and blank counts of each variable 

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
## getDateInconsistency
Get all cases where two dates are metaphysically impossible
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, the VetCot sheet of a trauma center |
| indate |  A number, the int representation of a date code - the supposed "before" time. |
| indate |  A number, the int representation of a date code - the supposed "after" time. |

### Return
A number, a total in dataset where the dates are impossible.

---
## getSubsetDogs
Get a subset of dog cases where a specified breed is above or below a weight threshold 
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, the VetCot sheet of a trauma center |
| breeds | A list, containing numerical codes for each dog breed to be considered |
| weight | A number, a threshold that dogs will be included if ABOVE |
| toAppend | A data frame, to which the subset will be added (usually blank) |

### Return
A data frame, containing all dogs of specified breeds that exceed threshold.

---
## getSubsetCats
Get a subset of cat cases where a specified breed is above or below a weight threshold 
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, the VetCot sheet of a trauma center |
| weight | A number, a threshold that cats will be included if ABOVE |

### Return
A data frame, containing all cats of specified breeds that exceed threshold.

---
## getAgeSubsetDogs
Get all dogs exceeding a certain age
### Parameters
| Parameter | Description |
| --- | --- |
| dataset | A data frame, the VetCot sheet of a trauma center |
| age | A number, the age threshold |
| weightTreshold | A number, the lower limit of weights to filter out, i.e. all dogs this weight and above will be filtered out |

### Return
A data frame, all dog cases where the patient exceeds the age threshold

---
