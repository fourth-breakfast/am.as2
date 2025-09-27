// question one
graph bar (mean) income, over(edyears_cat, gap(*5) relabel(1 "1" 2 "2" 3 "3" 4 "4")) ///
    ytitle("Mean Income (USD)") ///
	ylabel(0(10000)40000) ///
    note("1=Less than HS  2=HS Graduate  3=Some College  4=College degree or more", size(medium))
graph export "$figures/fig11.png", replace

graph bar (mean) income, over(edyears_cat, relabel(1 "1" 2 "2" 3 "3" 4 "4")) ///
    by(male, note("		  1=Less than HS  2=HS Graduate  3=Some College  4=College degree or more", size(medium))) ///
    ytitle("Mean Income (USD)") ///
    ylabel(0(10000)40000)
graph export "$figures/fig12.png", replace