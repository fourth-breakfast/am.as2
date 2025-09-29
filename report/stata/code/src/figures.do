// question one
graph bar (mean) income, over(edyears_cat, label(angle(22.5))) ///
    ytitle("Mean Income (USD)") ///
	ylabel(0(10000)20000) ///
    note("", size(medium)) ///
	blabel(bar, format(%9.0f))
graph export "$figures/fig11.png", replace

graph bar (mean) income, over(edyears_cat, label(angle(22.5))) ///
    by(male, note("", size(medium))) ///
    ytitle("Mean Income (USD)") ///
    ylabel(0(10000)25000) ///
	blabel(bar, format(%9.0f))
graph export "$figures/fig12.png", replace