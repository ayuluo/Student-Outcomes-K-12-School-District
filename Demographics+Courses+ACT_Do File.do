***********************Merging data files and cleaning data**********************
*Importing "Demographics.csv" as the master data set

import delimited "/Users/sivanluo/Documents/STATA data/Hanover Research/Demographics.csv"

*Merging using "Courses_Data File_Cleaned" and "studentid" as key variable

merge 1:1 studentid using "/Users/sivanluo/Documents/STATA data/Hanover Research/Courses_Data File_Cleaned.dta"

**Merging report: 
**not matched 0 
**matched     1,000  (_merge==3) 
 
*Dropping variable "_merge" to avoid error message while merging another data file

drop _merge

*Merging using "ACT_Data File_Cleaned" and "studentid" as key variable

merge 1:1 studentid using "/Users/sivanluo/Documents/STATA data/Hanover Research/ACT_Data File_Cleaned.dta"

**Merging report:
**not matched            200
**      from master      200  (_merge==1) (those who DID NOT TAKE ACT test)
**      from using       0    (_merge==2)

**matched                800  (_merge==3) (those who DID TAKE ACT test)

*Dropping all non-essential variables

drop gradelevel lgathletics apenglish lgenglish aphistory lghistory apmath lgmath apscience lgscience ngenglish nghistory ngmath ngscience testscore1 testscore2 testscore3 testscore4 _merge

*Converting string variables into numeric

**Converting string variable "gender" into numeric "num_gender". Let 0 = M and 1 = F

gen num_gender = 0 if gender == "M"
replace num_gender = 1 if gender == "F"
label variable num_gender "Gender"

**Converting string variable "ethnicity" into numeric "num_ethnicity". Let 1 = African American, 2 = White, 3 = Asian, 4 = Other

gen num_ethnicity = 1 if ethnicity == "African American"
replace num_ethnicity = 2 if ethnicity == "White"
replace num_ethnicity = 3 if ethnicity == "Asian"
replace num_ethnicity = 4 if ethnicity == "Other"
label variable num_ethnicity "Ethnicity"

**Converting string variable "specialed" into numeric "num_specialed". Let 0 = N and 1 = Y

gen num_specialed = 0 if specialed == "N"
replace num_specialed = 1 if specialed == "Y"
label variable num_specialed "Specialed"

*Dropping all non-essential string variables

drop gender ethnicity specialed

*Reordering variables so that dependent variables come before independent variables

order graduated avg_testscore num_gender num_ethnicity num_specialed, before(age)

*****************************Running regressions*************************

*1. What are factors that might influence graduation?

**Letting "graduated" be the dependent variable, running logistic regression on all independent variables

logit graduated avg_testscore num_gender i.num_ethnicity num_specialed age householdincome performanceindex apclass athlete GPA

**Noticing that independent variable "num_gender" is ommitted, regressing "graduated" and "num_gender" along with other variables gradually added to the model to see which independent variable has dependency with "num_gender"

logit graduated avg_testscore
logit graduated avg_testscore num_gender
logit graduated avg_testscore num_gender i.num_ethnicity
logit graduated avg_testscore num_gender i.num_ethnicity num_specialed
logit graduated avg_testscore num_gender i.num_ethnicity num_specialed age
logit graduated avg_testscore num_gender i.num_ethnicity num_specialed age householdincome
logit graduated avg_testscore num_gender i.num_ethnicity num_specialed age householdincome performanceindex

**"num_gender" starts being omitted when "performanceindex" is added to the model. Tabulating these three variables - "graduated", "num_gender", and "performanceindex" to check for any discrepancy/interdependency among these variables

tab performanceindex num_gender
tab performanceindex graduated

**Noticing that "performanceindex" is missing when "num_gender" = 0. That is to say, no performance index was recorded for male students. Hence this variable will be dropped in our following analysis to avoid gender bias. Changing to logistic command because interpretation in terms of odds ratio is easier for non-technical readers to understand. In num_ethnicity, White (num_ethnicity = 2), Asian (num_ethnicity = 3) and Other (num_ethnicity = 4) are compared to African American (num_ethnicity = 1)

logistic graduated avg_testscore num_gender i.num_ethnicity num_specialed age householdincome apclass athlete GPA

**Creating dummy variables for different ethnicities to interpret the categorical variable "num_ethnicity"

gen dummy_black = 1 if num_ethnicity == 1
replace dummy_black = 0 if num_ethnicity != 1
gen dummy_white = 1 if num_ethnicity == 2
replace dummy_white = 0 if num_ethnicity != 2
gen dummy_asian = 1 if num_ethnicity == 3
replace dummy_asian = 0 if num_ethnicity != 3
gen dummy_other = 1 if num_ethnicity == 4
replace dummy_other = 0 if num_ethnicity!= 4
label variable dummy_black "Student who identifies as African American"
label variable dummy_white "Student who identifies as White"
label variable dummy_asian "Student who identifies as Asian"
label variable dummy_other "Student who identifies as Other Ethnicity"

**Running different regression models to compare graduation among different ethnicities

***Regression comparing all other ethnicities to White in terms of graduation

logistic graduated avg_testscore num_gender num_specialed age householdincome apclass athlete GPA dummy_black dummy_asian dummy_other

***Regression comparing all other ethnicities to Asian in terms of graduation

logistic graduated avg_testscore num_gender num_specialed age householdincome apclass athlete GPA dummy_black dummy_white dummy_other

**Regression comparing all other ethnicities to Other in terms of graduation

logistic graduated avg_testscore num_gender num_specialed age householdincome apclass athlete GPA dummy_black dummy_white dummy_asian

*2. What are factors that might influence ACT scores?

**Noticing that independent variable "GPA" and dependent variable "avg_testscore" might be very correlational, we are running a correlational test between these two variables to avoid imperfect multicollinearity in our overall regression model

pwcorr avg_testscore GPA, sig star (0.05)

**The correlation coefficient is 0.2431 so these two variables are not very correlational. Hence both of them can be used in our regression model.

**Letting "avg_testscore" be the dependent variable, running linear regression on all independent variables except "performanceindex". In num_ethnicity, White (num_ethnicity = 2), Asian (num_ethnicity = 3) and Other (num_ethnicity = 4) are compared to African American (num_ethnicity = 1)

reg avg_testscore graduated num_gender i.num_ethnicity num_specialed age householdincome apclass athlete GPA

**Running different regression models to compare ACT test score among different ethnicities

***Regression comparing all other ethnicities to White in terms of ACT test score

reg avg_testscore graduated num_gender num_specialed age householdincome apclass athlete GPA dummy_black dummy_asian dummy_other

***Regression comparing all other ethnicities to Asian in terms of ACT test score

reg avg_testscore graduated num_gender num_specialed age householdincome apclass athlete GPA dummy_black dummy_white dummy_other

**Regression comparing all other ethnicities to Other in terms of ACT test score

reg avg_testscore graduated num_gender num_specialed age householdincome apclass athlete GPA dummy_black dummy_white dummy_asian
