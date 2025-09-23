// question one

graph bar (mean) income, over(edyears_cat, relabel(1 "1" 2 "2" 3 "3" 4 "4")) ///
	title("Mean Income by Education Level") ///
    ytitle("Mean Income (USD)") ///
	ylabel(0(10000)30000) ///
    note("1=Less than HS  2=HS Graduate  3=Some College  4=College degree or more", justification(center))
graph export "$figures/11.png", replace

graph bar (mean) income, over(edyears_cat, relabel(1 "1" 2 "2" 3 "3" 4 "4")) ///
    by(male, title("Mean Income by Education Level, by Gender") note("1=Less than HS  2=HS Graduate  3=Some College  4=College degree or more", justification(center))) ///
    ytitle("Mean Income (USD)") ///
    ylabel(0(10000)40000)
graph export "$figures/12.png", replace