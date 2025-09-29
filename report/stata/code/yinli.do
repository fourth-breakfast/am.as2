//YH Do.file 2025 AS 2

//Q1: Using the panel data provided, begin by constructing a bar chart showing mean income by education group. Group individuals based on their highest level of educational attainment (e.g., less than high school, high school graduate, some college, college degree or more), and plot the average income for each category.

bysort pid: egen maxed = max(edyears)

gen educ_group = .
replace educ_group = 1 if edyears < 12
replace educ_group = 2 if edyears == 12
replace educ_group = 3 if edyears >= 13 & edyears <= 15
replace educ_group = 4 if edyears >= 16

label define educ_label ///
    1 "Less than high school" ///
    2 "High school graduate" ///
    3 "Some college" ///
    4 "College degree or more"

label values educ_group educ_label

graph bar (mean) income, over(educ_group, label(angle(20))) ///
    title("Mean Income by Education Group") ///
    ytitle("Mean Income") ///
    bar(1, bcolor(navy)) ///
    blabel(bar, format(%9.0f))

*Recent debates around student debt and the value of higher education often assume that education "pays off" equally for everyone. Does your analysis support that assumption? To explore this, create separate plots by gender to highlight any differences in the relationship between education and earnings. Discuss your findings.

graph bar (mean) income, over(educ_group, label(angle(20))) ///
    by(male, title("Mean Income by Education and Gender")) ///
    ytitle("Mean Income") ///
    blabel(bar, format(%9.0f))

//Q2
gen lnincome = ln(income)
reg lnincome edyears age male i.mstatus i.ethnicity child_birth, r

local effect=round(100*(exp(_b[edyears])-1),1)
*^ gives us 15.66%
*2A) Each additional year of education significantly (5%) increases income by 15.66%, ceteris paribus

reg lnincome i.educ_group##i.male age i.mstatus i.ethnicity child_birth, r
*2B) Yes there is still labor market discrimination as the returns of schooling differ by gender. Whereby men get more return on schooling than women.

*Returns to education for women
*HS: 46% higher income than women with less than HS educ
*SC: 91% higher income than women with less than HS educ
*C: 177.9% higher income than women with less than HS educ

*Returns to education for men
*HS: 114.5% higher income than men with less than HS educ
*SC: 125.8% higher income than men with less than HS educ
*C: 246.9% higher income than men with less than HS educ

*2C) Linearity: relationship between lnincome and edyears should be linear, i think this is true.
* edyears should be uncorrelated with the error term (exogeneity assumption), unlikely to hold as edyears is often correlated with variables such as parental background which is now in the error term. 
* no omitted variable bias: all relevant variables that influence income and are correlated with education should be included in the model - it is though to say and probably there is omitted variable bias as there are so many factors that could influence income and education. 
* Homoskedasticity and no autocorrelation
*No perfect multicollinearity, this assumption holds 

//Q3
xtset pid wave
xtreg lnincome edyears age male i.mstatus i.ethnicity child_birth

*3A) Each additional year of education significantly (5%) increases income by 16.26%, ceteris paribus.
*STD error Pooled OLS: 0.0026792
*STD error RE: 0.0030528 
*The STD error for RE is a little bit higher than the Pooled OLS because it accounts for indivdual-specific (ai) effects over time, whilt the Pooled OLS does not takes this into account.

*3B) Random Effects is more efficient than pooled OLS because it accounts for individual-specific effects (ai), but only if these effects are uncorrelated with the regressors. 
//"rewrite this^"

//Q4
*4A) Decision relies on which is more efficient: structure of serial correlation in the idiosyncratic error (Eit). If we have a dataset with only 2 time periods, FE and FD will be identical. Thus, no reason to choose. If we have more than 2 time periods, we have to look at the structure of Eit. if the Eit is serially uncorrelated FE is more efficient. But if the Eit is serially correlated FD is more efficient.

xtset pid wave
xtreg lnincome edyears age male i.mstatus i.ethnicity child_birth, fe
xtreg lnincome edyears age male i.mstatus i.ethnicity child_birth, re

*4B) Each additional year of education significantly (5%) increases income by 17.42%, ceteris paribus.
*Pooled OLS: 0.1456
*FE: 0.1607
*RE: 0.1507

xtset pid wave
est clear 
xtreg lnincome edyears age male i.mstatus i.ethnicity child_birth, fe
estimates store fe //save estimates from fe under the name of fe
xtreg lnincome edyears age male i.mstatus i.ethnicity child_birth, re
estimates store re //save estimnates from re under the name of re
hausman fe re

*4C) we can reject the null-hypothesis significantly (1%) that the difference in coefficient is not systematic. therefore the unobserved heterogeneity matters and influences income, the preferable model in this case will be FE. We choose the FE model so we can account for the correlation that exists between the unobserved  heterogeneity and our variable income.

//Q5
*5A) CRE is an extension of RE that (partially) accounts for correlation between Ai and Xcit.
*5B) CRE will allow to include time-invariant characteristics, while FE can't do that. 

xtset pid wave

bysort pid: egen avedyears=mean(edyears)
bysort pid: egen avage=mean(age)
bysort pid: egen avmale=mean(male)
bysort pid: egen avmstatus=mean(mstatus)
bysort pid: egen avethnicity=mean(ethnicity)
bysort pid: egen avchildbirth=mean(child_birth)

xtreg lnincome edyears age male i.mstatus i.ethnicity child_birth avedyears avage avmale avmstatus avethnicity avchildbirth, re

*5C)
*CRE: 0.1604
*FE: 0.1607
*RE: 0.1507

test avedyears=avage=avmale=avmstatus=avethnicity=avchild_birth=0
*5D) 

//Q6
xtset pid wave
xtreg lnincome child_birth age i.male i.ethnicity edyears i.mstatus, fe
*6A) childbirth decreases income significantly (1%) by approximately 5.3%, ceteris paribus.

*could leave gender and ethnicity out of reg as they are time invariant and will be omitted
xtreg lnincome c.child_birth##i.male age i.ethnicity edyears i.mstatus, fe
*6B) women's income decreases about 28.8% after childbirth. While for men, there is a 6.3% increase in income after childbirth. both are significant at 1%. 

//Q7
*7A) 
*7B)

//Q8
xtset pid wave 
xtdescribe 

bysort pid: gen numberwaves=_N
tab numberwaves

xtreg lnincome numberwaves edyears age male i.mstatus i.ethnicity child_birth, fe

*The coefficient of numberwaves is positive and significant at 1%. this means that poorer people drop out of the sample. meaning that attrition is not at random and the people who remain in the panel longer tend to have higher inciomes. 
