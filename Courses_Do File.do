*Importing data file

import delimited "/Users/sivanluo/Documents/STATA data/Hanover Research/Courses.csv"

*Reshaping data set from wide to long

reshape wide apclass lettergrade, i(studentid) j(course) string

*Renaming variables for simplicity

rename (lettergradeAthletics apclassEnglish lettergradeEnglish apclassHistory lettergradeHistory apclassMath lettergradeMath apclassScience lettergradeScience) (lgathletics apenglish lgenglish aphistory lghistory apmath lgmath apscience lgscience)

*Dropping non-essential variables for simplicity

drop apclassAthletics

*Checking for missing values

tab lgathletics, missing
tab lgenglish, missing
tab lghistory, missing
tab lgmath, missing
tab lgscience, missing

*Converting all letter grade variables from string to numeric

**Converting string variable "lgenglish" to numeric "ngenglish"

gen ngenglish = 4 if lgenglish == "A"
replace ngenglish = 3 if lgenglish == "B"
replace ngenglish = 2 if lgenglish == "C"
replace ngenglish = 1 if lgenglish == "D"
replace ngenglish = 0 if lgenglish == "F"
label variable ngenglish "English numericgrade"

**Converting string variable "lghistory" to numeric "nghistory"

gen nghistory = 4 if lghistory == "A"
replace nghistory = 3 if lghistory == "B"
replace nghistory = 2 if lghistory == "C"
replace nghistory = 1 if lghistory == "D"
replace nghistory = 0 if lghistory == "F"
label variable nghistory "History numericgrade"

**Converting string variable "lgmath" to numeric "ngmath"

gen ngmath = 4 if lgmath == "A"
replace ngmath = 3 if lgmath == "B"
replace ngmath = 2 if lgmath == "C"
replace ngmath = 1 if lgmath == "D"
replace ngmath = 0 if lgmath == "F"
label variable ngmath "Math numericgrade"

**Converting string variable "lgscience" to numeric "ngscience"

gen ngscience = 4 if lgscience == "A"
replace ngscience = 3 if lgscience == "B"
replace ngscience = 2 if lgscience == "C"
replace ngscience = 1 if lgscience == "D"
replace ngscience = 0 if lgscience == "F"
label variable ngscience "Science numericgrade"

*Creating new variable "apclass" to indicate if the given student has taken at least one AP class. Let 1 = Yes and 0 = No

gen apclass = 1 if apenglish == "Y" | aphistory == "Y" | apmath == "Y" | apscience == "Y"
replace apclass = 0 if apclass == .
label variable apclass "AP class"

*Creating new variable "athlete" to indicate if the given student is a student athlete. Let 1 = Yes and 0 = No

gen athlete = 1 if lgathletics == "Y"
replace athlete = 0 if lgathletics != "Y"
label variable athlete "Student athlete"

*Creating new variable "GPA" to calculate the given student's GPA excluding athletic class and missing values

egen GPA = rmean(ngenglish nghistory ngmath ngscience)
label variable GPA "GPA"
