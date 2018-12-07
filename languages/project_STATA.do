*-----------------------------------------------------------------------------*
* 506 Group Project STATA Script
* 
*
* This script includes the necessary code for testing for the STATA portion of
* the group project, in which we perform an LDA analysis
*
* Data: seeds.csv
* Source: https://archive.ics.uci.edu/ml/datasets/seeds
*
* Authors: Alex Kellner (kellnera@umich.edu),
*          Reed Millek (rmillek@umich.edu)
*          Zhaobo Wu (zhaobowu@umich.edu)
* Date:   Nov. 25, 2018
*-----------------------------------------------------------------------------*
* 80: -------------------------------------------------------------------------
* import the seeds data from local data, rename seeds, and summarize
import delimited seeds.csv
label define labseed 1 Kama 2 Rosa 3 Canadian, replace
label values group labseed
summarize area peri comp l w asym lgroove

// graph correlations between the variables of interest
graph matrix area peri comp l w asym lgroove
graph export graph1.png, replace

// separate into training and test set
set seed 123
generate random = runiform()
sort random
generate trainsamp = _n <= 147

// save test set for later
preserve
keep if !trainsamp
save test.dta, replace
restore

// perform lda analysis on training set, obtain output
keep if trainsamp
candisc area peri comp l w asym lgroove, group(group)

// generate plot to show the separation
label define lab2 1 K 2 R 3 C 
label values group lab2
scoreplot, msymbol(i)

// calculate prediction error by finding incorrect predictions for test set
use test.dta, clear
predict outcome
label values outcome labseed
count if outcome != group

* 80: -------------------------------------------------------------------------
