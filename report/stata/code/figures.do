//ssc install estout, replace
//ssc install outreg2, replace

// question two
eststo: reg income bmi black, robust
esttab using "$tables/reg2.tex", replace ///
    cells("b(pattern(1) fmt(4)) se(pattern(1) fmt(4)) p(pattern(1) fmt(4) star) ci_l(pattern(1) fmt(4)) ci_u(pattern(1) fmt(4))") ///
	varlabels(_cons "cons") ///
	collabels("Coef." "Robust SE" "p-value" "\multicolumn{2}{c}{[95\% Conf. Interval]}") ///
    stats(N F p r2 r2_a rmse, ///
          fmt(0 4 4 4 4) ///
	labels("Number of obs." "F" "Prob > F" "R-squared" "Adj R-squared" "Root MSE")) ///
    nomtitles nonumbers booktabs
eststo clear

// question three b
eststo: reg income bmi bmi2 black, robust
esttab using "$tables/reg3b.tex", replace ///
    cells("b(pattern(1) fmt(4)) se(pattern(1) fmt(4)) p(pattern(1) fmt(4) star) ci_l(pattern(1) fmt(4)) ci_u(pattern(1) fmt(4))") ///
	varlabels(_cons "cons") ///
	collabels("Coef." "Robust SE" "p-value" "\multicolumn{2}{c}{[[95\% Conf. Interval]}") ///
    stats(N F p r2 r2_a rmse, ///
          fmt(0 4 4 4 4) ///
	labels("Number of obs." "F" "Prob > F" "R-squared" "Adj R-squared" "Root MSE")) ///
    nomtitles nonumbers booktabs
eststo clear

// question four b
eststo: reg ln_income ib2.bmi_cat black, robust
esttab using "$tables/reg4b.tex", replace ///
    cells("b(pattern(1) fmt(4)) se(pattern(1) fmt(4)) p(pattern(1) fmt(4) star) ci_l(pattern(1) fmt(4)) ci_u(pattern(1) fmt(4))") ///
	drop(2.bmi_cat) ///
	varlabels(_cons "cons" 1.bmi_cat "bmi_cat 1" 3.bmi_cat "bmi_cat 3" 4.bmi_cat "bmi_cat 4") ///
	collabels("Coef." "Robust SE" "p-value" "\multicolumn{2}{c}{[95\% Conf. Interval]}") ///
    stats(N F p r2 r2_a rmse, ///
          fmt(0 4 4 4 4) ///
	labels("Number of obs." "F" "Prob > F" "R-squared" "Adj R-squared" "Root MSE")) ///
    nomtitles nonumbers booktabs
eststo clear

// question four d
eststo: reg ln_income ib2.bmi_cat##i.black, robust
esttab using "$tables/reg4d.tex", replace ///
    cells("b(pattern(1) fmt(4)) se(pattern(1) fmt(4)) p(pattern(1) fmt(4) star) ci_l(pattern(1) fmt(4)) ci_u(pattern(1) fmt(4))") ///
	drop(0.black 2.bmi_cat 1.bmi_cat#0.black 3.bmi_cat#0.black 4.bmi_cat#0.black 2.bmi_cat#1.black 2.bmi_cat#0.black) ///
	varlabels(_cons "cons" 1.black "black" 1.bmi_cat "bmi_cat 1" 3.bmi_cat "bmi_cat 3" 4.bmi_cat "bmi_cat 4" 1.bmi_cat#1.black "bmi_cat 1 \cdot black" 3.bmi_cat#1.black "bmi_cat 3 \cdot black" 4.bmi_cat#1.black "bmi_cat 4 \cdot black") ///
	collabels("Coef." "Robust SE" "p-value" "\multicolumn{2}{c}{[95\% Conf. Interval]}") ///
    stats(N F p r2 r2_a rmse, ///
          fmt(0 4 4 4 4) ///
	labels("Number of obs." "F" "Prob > F" "R-squared" "Adj R-squared" "Root MSE")) ///
    nomtitles nonumbers booktabs
eststo clear

// question seven
eststo: reg bmi income black, robust
esttab using "$tables/reg7.tex", replace ///
    cells("b(pattern(1) fmt(4)) se(pattern(1) fmt(4)) p(pattern(1) fmt(4) star) ci_l(pattern(1) fmt(4)) ci_u(pattern(1) fmt(4))") ///
	varlabels(_cons "cons") ///
	collabels("Coef." "Robust SE" "p-value" "\multicolumn{2}{c}{[95\% Conf. Interval]}") ///
    stats(N F p r2 r2_a rmse, ///
          fmt(0 4 4 4 4) ///
	labels("Number of obs." "F" "Prob > F" "R-squared" "Adj R-squared" "Root MSE")) ///
    nomtitles nonumbers booktabs
eststo clear

// question eight
eststo: reg bmi black drinks, robust
esttab using "$tables/reg8first.tex", replace ///
    cells("b(pattern(1) fmt(4)) se(pattern(1) fmt(4)) p(pattern(1) fmt(4) star) ci_l(pattern(1) fmt(4)) ci_u(pattern(1) fmt(4))") ///
	varlabels(_cons "cons") ///
	collabels("Coef." "Robust SE" "p-value" "\multicolumn{2}{c}{[95\% Conf. Interval]}") ///
    stats(N F p r2 r2_a rmse, ///
          fmt(0 4 4 4 4) ///
	labels("Number of obs." "F" "Prob > F" "R-squared" "Adj R-squared" "Root MSE")) ///
    nomtitles nonumbers booktabs
eststo clear

eststo: ivregress 2sls income (bmi = drinks) black, robust first
estadd scalar wald_chi2 = e(chi2)
estadd scalar wald_p = chi2tail(e(df_m), e(chi2))
esttab using "$tables/reg8iv.tex", replace ///
    cells("b(pattern(1) fmt(4)) se(pattern(1) fmt(4)) p(pattern(1) fmt(4) star) ci_l(pattern(1) fmt(4)) ci_u(pattern(1) fmt(4))") ///
	varlabels(_cons "cons") ///
	collabels("Coef." "Robust SE" "p-value" "\multicolumn{2}{c}{[95\% Conf. Interval]}") ///
stats(N wald_chi2 wald_p rmse, ///
      fmt(0 2 4 3) ///
      labels("Observations" "Wald χ²" "Prob > χ²" "Root MSE")) ///
    nomtitles nonumbers booktabs
eststo clear


