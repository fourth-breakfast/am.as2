/*
	   project: assignment 2
	   course: applied microeconometrics
	   author: group 33
	   date: 30-09-25

	   input: childbirth.dta
	   output: clean dataset, tables, graphs, regression results, log file

	   description: panel data analysis
*/

// setup
clear all
set more off
set graphics off
version 18

// globals
global project "C:/Users/andres/repositories/am.as2/report/stata"
global code "$project/code"
global rawdata "$project/data/raw"
global cleandata "$project/data/clean"
global logs "$project/output/logs"
global tables "$project/output/tables"
global figures "$project/output/figures"

// start log
capture log close
log using "$logs/main.log", replace

// load data
use "$rawdata/childbirth.dta", clear

// clean data
save "$cleandata/childbirth_clean.dta", replace

label define child_lbl ///
	0 "No childbirth" ///
	1 "Childbirth"
label values child_birth child_lbl

// question one
gen edyears_cat = .
replace edyears_cat = 1 if edyears <= 11 & !missing(edyears)
replace edyears_cat = 2 if edyears == 12 & !missing(edyears)
replace edyears_cat = 3 if edyears >= 13 & edyears <= 15 & !missing(edyears)
replace edyears_cat = 4 if edyears >= 16 & !missing(edyears)

label var edyears_cat "Education Category"
label define edyears_lbl ///
	1 "Less than HS" ///
	2 "HS graduate" ///
	3 "Some college" ///
	4 "College degree or more"
label values edyears_cat edyears_lbl

graph bar (mean) income, over(edyears_cat)
graph bar (mean) income, over(edyears_cat) by(male)

// question two
sum income, detail
count if income <= 0

gen log_income = log(income)
reg log_income edyears age i.male ib0.mstatus ib4.ethnicity i.child_birth, r

reg log_income i.edyears_cat##i.male age ib0.mstatus ib4.ethnicity i.child_birth, r
test 2.edyears_cat#1.male 3.edyears_cat#1.male 4.edyears_cat#1.male

// question three
xtset pid wave

xtreg log_income edyears age i.male ib0.mstatus ib4.ethnicity i.child_birth, re
estimates store random

// question four
xtreg log_income edyears age i.male ib0.mstatus ib4.ethnicity i.child_birth, fe
estimates store fixed

hausman fixed random

// question five
by pid: egen age_mean = mean(age)
by pid: egen mstatus_mean = mean(mstatus)

xtreg log_income edyears age i.male ib0.mstatus ib4.ethnicity i.child_birth age_mean mstatus_mean, re

// question six
xtreg log_income i.child_birth age i.male ib0.mstatus ib4.ethnicity edyears age_mean mstatus_mean, re

xtreg log_income i.child_birth##i.male age ib0.mstatus ib4.ethnicity edyears age_mean mstatus_mean, re

test 1.child_birth#1.male

// question eight
bysort pid (wave): gen n_waves = _N
gen all_waves = n_waves == 17

xtreg log_income i.child_birth##i.male age ib0.mstatus ib4.ethnicity edyears age_mean mstatus_mean all_waves, re

bysort pid (wave): gen next_wave = (wave[_n+1] == wave + 1)

xtreg log_income i.child_birth##i.male age ib0.mstatus ib4.ethnicity edyears age_mean mstatus_mean next_wave, re

xtreg log_income i.child_birth##i.male age ib0.mstatus ib4.ethnicity edyears age_mean mstatus_mean n_waves, re

// save data
save "$cleandata/childbirth_clean.dta", replace

// close log
log close