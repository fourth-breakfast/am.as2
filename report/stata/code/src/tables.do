//ssc install estout, replace

// reg table format
global regcells "cells((b(fmt(4)) se(fmt(4) par) p(fmt(3)) ci(par fmt(3))))"
global regcollabels "collabels("Coefficient" "\shortstack{Robust\\std. err.}" P>|t| "Conf. int.")"
global regstats "stats(N F p r2 r2_a, fmt(0 2 4 4 4)"
global regstatslabels "labels("Number of obs" "F-statistic" "Prob > F" "R-squared" "Adj. R-squared"))"
global regstyle "label booktabs nomtitle nonumber"
global regformat "$regcells $regcollabels $regstats $regstatslabels $regstyle"

// xtreg table format
global xtregcells "cells((b(fmt(4)) se(fmt(4) par) p(fmt(3)) ci(par fmt(3))))"
global xtregcollabels "collabels("Coefficient" "Std. err." P>|t| "Conf. int.")"
global xtregstats "stats(N N_g r2_w r2_b r2_o chi2 p sigma_u sigma_e rho, fmt(0 0 4 4 4 2 4 4 4 4)"
global xtregstatslabels "labels("Number of obs" "Number of groups" "\\ R-squared within" "R-squared between" "R-squared overall" "\\ Wald $\chi^2$" "Prob > $\chi^2$" "\\ $\sigma\text{_u}$" "$\sigma\text{_e}$" "$\rho$"))"
global xtregstyle "label booktabs nomtitle nonumber"
global xtregformat "$xtregcells $xtregcollabels $xtregstats $xtregstatslabels $xtregstyle"

// comparison table format
global cregcells "cells(b(fmt(4) star) se(fmt(4) par))"
global cregcollabels "collabels(none)"
global cregstats "stats(N N_g F chi2 p r2 r2_a r2_w r2_b r2_o sigma_u sigma_e rho, fmt(0 0 2 2 4 4 4 4 4 4 4 4)"
global cregstatslabels "labels("Number of obs" "Number of groups" "\\ F-statistic" "Wald $\chi^2$" P-value "\\ R-squared" "Adj. R-squared" "R-squared within" "R-squared between" "R-squared overall" "\\ $\sigma\text{_u}$" "$\sigma\text{_e}$" "$\rho$"))"
global cregstyle "label booktabs nonumber"
global cregnote "addnotes("Standard errors in parentheses." "* p < 0.05, ** p < 0.01, *** p < 0.001")"
global cregformat "$cregcells $cregcollabels $cregstats $cregstatslabels $cregstyle $cregnote"

// question two
eststo: reg log_income edyears age i.male i.child_birth ib0.mstatus ib4.ethnicity, r
esttab using "$tables/tab21.tex", replace $regformat ///
	refcat(edyears "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth) ///
	addnotes("Dependent variable: log(income)")
eststo clear

eststo: reg log_income i.edyears_cat i.edyears_cat#i.male age i.male i.child_birth ib0.mstatus ib4.ethnicity, r
esttab using "$tables/tab22.tex", replace $regformat ///
	refcat(2.edyears_cat "\textbf{Explanatory variable}" 2.edyears_cat#1.male "\\ \textbf{Interaction terms}" age "\\ \textbf{Control variables}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth *#0.male 1.edyears_cat*) ///
	addnotes("Dependent variable: log(income)")
eststo clear

reg log_income i.edyears_cat i.edyears_cat#i.male age i.male i.child_birth ib0.mstatus ib4.ethnicity, r
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

// question three
eststo: xtreg log_income edyears age i.male i.child_birth ib0.mstatus ib4.ethnicity, re
esttab using "$tables/tab31.tex", replace $xtregformat ///
	refcat(edyears "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth) ///
	addnotes("Dependent variable: log(income)")
eststo clear

// question four
eststo: xtreg log_income edyears age i.male i.child_birth ib0.mstatus ib4.ethnicity, fe
esttab using "$tables/tab41.tex", replace $xtregformat ///
	refcat(edyears "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" _cons "", nolabel) ///
	drop(*.male 0.mstatus *.ethnicity 0.child_birth) ///
	addnotes("Dependent variable: log(income)")
eststo clear

xtreg log_income edyears age i.male i.child_birth ib0.mstatus ib4.ethnicity, fe
hausman fixed random
file open tab42 using "$tables/tab42.tex", write replace
file write tab42 "\begin{tabular}{lr}" _n
file write tab42 "\toprule" _n
file write tab42 "$\chi^2$ & " %9.2f (r(chi2)) " \\" _n
file write tab42 "Prob > $\chi^2$ & " %9.4f (r(p)) " \\" _n
file write tab42 "\bottomrule" _n
file write tab42 "\multicolumn{2}{l}{\footnotesize H0: Difference in $\beta$ not systematic}\\" _n
file write tab42 "\end{tabular}" _n
file close tab42

// question five
eststo: xtreg log_income edyears age i.male i.child_birth ib0.mstatus ib4.ethnicity edyears_mean age_mean male_mean child_birth_mean mstatus_mean ethnicity_mean, re
esttab using "$tables/tab51.tex", replace $xtregformat ///
	refcat(edyears "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" age_mean "\\ \textbf{CRE variables}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth male_mean ethnicity_mean) ///
	addnotes("Dependent variable: log(income)")
eststo clear

xtreg log_income edyears age i.male i.child_birth ib0.mstatus ib4.ethnicity edyears_mean age_mean male_mean child_birth_mean mstatus_mean ethnicity_mean, re
test age_mean mstatus_mean child_birth_mean edyears_mean male_mean ethnicity_mean
file open test5 using "$tables/test5.tex", write replace
file write test5 "\begin{tabular}{lr}" _n
file write test5 "\toprule" _n
file write test5 "$\chi^2$ & " %9.2f (r(chi2)) " \\" _n
file write test5 "Prob > $\chi^2$ & " %9.4f (r(p)) " \\" _n
file write test5 "\bottomrule" _n
file write test5 "\multicolumn{2}{l}{\footnotesize (0) Education mean $\times$ Age mean $\times$}\\" _n
file write test5 "\multicolumn{2}{l}{\footnotesize \space\space\space\space\space Male mean $\times$ Childbirth mean $\times$}\\" _n
file write test5 "\multicolumn{2}{l}{\footnotesize \space\space\space\space\space Marriage Status mean $\times$ Ethnicity mean = 0}\\" _n
file write test5 "\end{tabular}" _n
file close test5

// question six
eststo: xtreg log_income i.child_birth age i.male edyears ib0.mstatus ib4.ethnicity child_birth_mean age_mean male_mean edyears_mean mstatus_mean ethnicity_mean, re
esttab using "$tables/tab61.tex", replace $xtregformat ///
	refcat(1.child_birth "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" age_mean "\\ \textbf{CRE variables}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth male_mean ethnicity_mean) ///
	addnotes("Dependent variable: log(income)")
eststo clear

eststo: xtreg log_income i.child_birth i.child_birth#i.male age i.male edyears ib0.mstatus ib4.ethnicity child_birth_mean age_mean male_mean edyears_mean mstatus_mean ethnicity_mean, re
esttab using "$tables/tab62.tex", replace $xtregformat ///
	refcat(1.child_birth "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" age_mean "\\ \textbf{CRE variables}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth 0.child_birth#* *#0.male male_mean ethnicity_mean) ///
	addnotes("Dependent variable: log(income)")
eststo clear

xtreg log_income i.child_birth i.child_birth#i.male age i.male edyears ib0.mstatus ib4.ethnicity child_birth_mean age_mean male_mean edyears_mean mstatus_mean ethnicity_mean, re
test 1.child_birth#1.male
file open tab63 using "$tables/tab63.tex", write replace
file write tab63 "\begin{tabular}{lr}" _n
file write tab63 "\toprule" _n
file write tab63 "$\chi^2$ & " %9.2f (r(chi2)) " \\" _n
file write tab63 "Prob > $\chi^2$ & " %9.4f (r(p)) " \\" _n
file write tab63 "\bottomrule" _n
file write tab63 "\multicolumn{2}{l}{\footnotesize (1) Childbirth $\times$ Male = 0}\\" _n
file write tab63 "\end{tabular}" _n
file close tab63

// question eight
eststo: xtreg log_income i.child_birth i.child_birth#i.male age i.male edyears ib0.mstatus ib4.ethnicity child_birth_mean age_mean male_mean edyears_mean mstatus_mean ethnicity_mean all_waves, re
esttab using "$tables/tab81.tex", replace $xtregformat ///
	refcat(1.child_birth "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" age_mean "\\ \textbf{CRE variables}" all_waves "\\ \textbf{Bias indicator}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth 0.child_birth#* *#0.male male_mean ethnicity_mean) ///
	addnotes("Dependent variable: log(income)")
eststo clear

eststo: xtreg log_income i.child_birth i.child_birth#i.male age i.male edyears ib0.mstatus ib4.ethnicity child_birth_mean age_mean male_mean edyears_mean mstatus_mean ethnicity_mean next_wave, re
esttab using "$tables/tab82.tex", replace $xtregformat ///
	refcat(1.child_birth "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" age_mean "\\ \textbf{CRE variables}" next_wave "\\ \textbf{Bias indicator}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth 0.child_birth#* *#0.male male_mean ethnicity_mean) ///
	addnotes("Dependent variable: log(income)")
eststo clear

eststo: xtreg log_income i.child_birth i.child_birth#i.male age i.male edyears ib0.mstatus ib4.ethnicity child_birth_mean age_mean male_mean edyears_mean mstatus_mean ethnicity_mean n_waves, re
esttab using "$tables/tab83.tex", replace $xtregformat ///
	refcat(1.child_birth "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" age_mean "\\ \textbf{CRE variables}" n_waves "\\ \textbf{Bias indicator}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth 0.child_birth#* *#0.male male_mean ethnicity_mean) ///
	addnotes("Dependent variable: log(income)")
eststo clear

// comparisons
reg log_income edyears age i.male i.child_birth ib0.mstatus ib4.ethnicity
eststo pols
xtreg log_income edyears age i.male i.child_birth ib0.mstatus ib4.ethnicity, re
eststo re
xtreg log_income edyears age i.male i.child_birth ib0.mstatus ib4.ethnicity, fe
eststo fe
xtreg log_income edyears age i.male i.child_birth ib0.mstatus ib4.ethnicity age_mean mstatus_mean child_birth_mean edyears_mean male_mean ethnicity_mean, re
eststo cre

esttab pols re using "$tables/comp3.tex", replace $cregformat ///
	refcat(edyears "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth) ///
	mtitle("POLS" "RE")
	
esttab pols re fe using "$tables/comp4.tex", replace $cregformat ///
	refcat(edyears "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth) ///
	mtitle("POLS" "RE" "FE")
	
esttab pols re fe cre using "$tables/comp5.tex", replace $cregformat ///
	refcat(edyears "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" age_mean "\\ \textbf{CRE variables}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth male_mean ethnicity_mean) ///
	mtitle("POLS" "RE" "FE" "CRE")
	
eststo clear
	
// question six comparison
reg log_income i.child_birth age i.male edyears ib0.mstatus ib4.ethnicity, r
eststo pols

xtreg log_income i.child_birth age i.male edyears ib0.mstatus ib4.ethnicity, re
eststo re

xtreg log_income i.child_birth age i.male edyears ib0.mstatus ib4.ethnicity, fe
eststo fe

xtreg log_income i.child_birth age i.male edyears ib0.mstatus ib4.ethnicity age_mean mstatus_mean child_birth_mean edyears_mean male_mean ethnicity_mean, re
eststo cre

esttab pols re fe cre using "$tables/comp6.tex", replace $cregformat ///
	refcat(1.child_birth "\textbf{Explanatory variable}" age "\\ \textbf{Control variables}" age_mean "\\ \textbf{CRE variables}" _cons "", nolabel) ///
	drop(0.male 0.mstatus 4.ethnicity 0.child_birth) ///
	mtitle("POLS" "RE" "FE" "CRE")
	
eststo clear

xtreg log_income i.child_birth age i.male edyears ib0.mstatus ib4.ethnicity, re
estimates store re6

xtreg log_income i.child_birth age i.male edyears ib0.mstatus ib4.ethnicity, fe
estimates store fe6

hausman fe6 re6
file open haus6 using "$tables/haus6.tex", write replace
file write haus6 "\begin{tabular}{lr}" _n
file write haus6 "\toprule" _n
file write haus6 "$\chi^2$ & " %9.2f (r(chi2)) " \\" _n
file write haus6 "Prob > $\chi^2$ & " %9.4f (r(p)) " \\" _n
file write haus6 "\bottomrule" _n
file write haus6 "\multicolumn{2}{l}{\footnotesize H0: Difference in $\beta$ not systematic}\\" _n
file write haus6 "\end{tabular}" _n
file close haus6