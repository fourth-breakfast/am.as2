//ssc install estout, replace

// reg table format
global regcells "cells((b(fmt(4)) se(fmt(4) par) p(fmt(3))))"
global regcollabels "collabels("Coefficient" "\shortstack{Robust\\std. err.}" P>|t|)"
global regstats "stats(N p r2 r2_a, fmt(0 4 4 4)"
global regstatslabels "labels("Observations" "Prob > F" "R-squared" "Adj. R-squared"))"
global regstyle "label booktabs nomtitle nonumber"
global regformat "$regcells $regcollabels $regstats $regstatslabels $regstyle"

// xtreg table format
global xtregcells "cells((b(fmt(4)) se(fmt(4) par) p(fmt(3))))"
global xtregcollabels "collabels("Coefficient" "Std. err." P>|t|)"
global xtregstats "stats(N p r2 r2_a, fmt(0 4 4 4)"
global xtregstatslabels "labels("Observations" "Prob > F" "R-squared" "Adj. R-squared"))"
global xtregstyle "label booktabs nomtitle nonumber"
global xtregformat "$regcells $regcollabels $regstats $regstatslabels $regstyle"

// question two
eststo: reg log_income edyears age i.male i.child_birth ib4.ethnicity ib0.mstatus, r
esttab using "$tables/tab21.tex", replace $regformat ///
	refcat(edyears "\textbf{Treatment variable}" age "\\ \textbf{Control variables}" 1.ethnicity "" 1.mstatus "" _cons "\\ \textbf{Constant}", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth) ///
	addnotes("Dependent variable: log(income)")
eststo clear

eststo: reg log_income i.edyears_cat i.edyears_cat#i.male age i.male i.child_birth ib4.ethnicity ib0.mstatus, r
esttab using "$tables/tab22.tex", replace $regformat ///
	refcat(2.edyears_cat "\textbf{Treatment variable}" 2.edyears_cat#1.male "" age "\\ \textbf{Control variables}" 1.ethnicity "" 1.mstatus "" _cons "\\ \textbf{Constant}", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth *#0.male 1.edyears_cat*) ///
	addnotes("Dependent variable: log(income)")
	
test 2.edyears_cat#1.male 3.edyears_cat#1.male 4.edyears_cat#1.male
file open tab23 using "$tables/tab23.tex", write replace
file write tab23 "\begin{tabular}{lr}" _n
file write tab23 "\toprule" _n
file write tab23 "F-statistic & " %9.2f (r(F)) " \\" _n
file write tab23 "Prob > F & " %9.4f (r(p)) " \\" _n
file write tab23 "\bottomrule" _n
file write tab23 "\multicolumn{2}{l}{\footnotesize (1) HS graduate $\times$ Male = 0}\\" _n
file write tab23 "\multicolumn{2}{l}{\footnotesize (2) Some college $\times$ Male = 0}\\" _n
file write tab23 "\multicolumn{2}{l}{\footnotesize (3) College degree or more $\times$ Male = 0}\\" _n
file write tab23 "\end{tabular}" _n
file close tab23
eststo clear

// question three
eststo: xtreg log_income edyears age i.male ib0.mstatus ib4.ethnicity i.child_birth, re
esttab using "$tables/tab31.tex", replace $regformat ///
	refcat(age "\\ \textbf{Individual characteristics}" 1.ethnicity "\\ \textbf{Ethnicity}" 1.mstatus "\\ \textbf{Married status}"  1.child_birth "\\ \textbf{Childbirth}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth) ///
	addnotes("Dependent variable: log(income)")
eststo clear

// question four
xtreg log_income edyears age i.male ib0.mstatus ib4.ethnicity i.child_birth, fe

hausman fixed random

// question five
xtreg log_income edyears age i.male ib0.mstatus ib4.ethnicity i.child_birth age_mean mstatus_mean, re

// question six
xtreg log_income i.child_birth age i.male ib0.mstatus ib4.ethnicity edyears age_mean mstatus_mean, re

xtreg log_income i.child_birth##i.male age ib0.mstatus ib4.ethnicity edyears age_mean mstatus_mean, re

test 1.child_birth#1.male

// question seven
xtreg log_income i.child_birth##i.male age ib0.mstatus ib4.ethnicity edyears age_mean mstatus_mean all_waves, re

xtreg log_income i.child_birth##i.male age ib0.mstatus ib4.ethnicity edyears age_mean mstatus_mean next_wave, re

xtreg log_income i.child_birth##i.male age ib0.mstatus ib4.ethnicity edyears age_mean mstatus_mean n_waves, re