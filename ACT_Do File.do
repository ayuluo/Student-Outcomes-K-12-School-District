*Importing data file

import delimited "/Users/sivanluo/Documents/STATA data/Hanover Research/ACT.csv"

*Browsing through data to find missing and repetitive values

tab testscore, missing

*Looking for duplicates in terms of studentid to find out what the maximum times of ACT test students in this data set have taken 

duplicates report studentid

**The largest number of copies is 3

*Inspecting duplicates in terms of testdate

tab testdate, missing

**4 duplicates are 6/1/2013, 8/1/2013, 10/1/2013 and 12/1/2013

*Destringing "testdate" and naming the new numeric variable "num_testdate". Let 6/1/2013 = 1, 8/1/2013 = 2, 10/1/2013 = 3, 12/1/2013 = 4.

*encode testdate, generate(num_testdate)

gen num_testdate = 1 if testdate == "6/1/2013"
replace num_testdate = 2 if testdate == "8/1/2013"
replace num_testdate = 3 if testdate == "10/1/2013"
replace num_testdate = 4 if testdate == "12/1/2013"

*Dropping non-essential variable

drop testdate

*Converting data set from long to wide, organizing student ACT test scores by testdate 1, testdate 2, testdate 3 and testdate 4

reshape wide testscore, i(studentid) j(num_testdate)

*Generating new variable "avg_testscore" to calculate average ACT test scores of each student

egen avg_testscore = rmean(testscore1 testscore2 testscore3 testscore4)
label variable avg_testscore "Average ACT score"

