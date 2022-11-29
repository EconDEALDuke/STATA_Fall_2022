*Version 1.0
*Author -- Jade Peng & Ricardo Miranda
*Date -- Nov 27, 2022

*This dofile illustrates different methods for exporting data analysis results from stata to excel and latex.

use "$Working\FinalDataset.dta", clear

*for loop examples:
forvalues i=1/10{
	di `i'
}

ds
local varlist "`r(varlist)'"
foreach var in `varlist'{
	di "`var'"
}


********************************************************************************
*Putexcel
********************************************************************************
*List of dependent variables
local depvars HouseholdSize FlowIncome EducExpenditure NumberOfResidents NumberOfLightBulbs

*Putexcel- Approach 1
*Create/define file that will store results
putexcel set $Tables\Tables.xlsx , modify sheet(BalanceTests)

*Parenthesis: Results from ttest
ttest EducExpenditureShare, by(FemaleHH)
ret list 

*Approach 1: Loop and ttests
*counter for variables/columns
local j=3
foreach var in `depvars'{
	
	local col : word `j' of `c(ALPHA)'
	
	ttest `var', by(FemaleHH)
	
	putexcel `col'4= `r(mu_1)'
	putexcel `col'5= `r(sd_1)'
	
	putexcel `col'7= `r(mu_2)'
	putexcel `col'8= `r(sd_2)'
	
	local j=`j'+1
	
}

gen MaleHH=1-FemaleHH

*Approach 2: Loop and regression
putexcel set $Tables\Tables.xlsx , modify sheet(BalanceTests_Regression)

local j=3
foreach var in `depvars'{
		
	reg `var' FemaleHH MaleHH, nocons robust
	
	matrix B=e(b)
	matrix B=B'
	matrix V=e(V)
	matrix V=vecdiag(V)
	matrix V=V'
	
	putexcel D`j'= matrix(B)
	putexcel D`j'= matrix(B)
	
	local j=`j'+3
}

local N=e(N)

putexcel C18= `N'
putexcel D18= `N'
********************************************************************************
*Outreg2
********************************************************************************


*Baseline analysis
reg EducExpenditureShare FemaleHH, robust
test FemaleHH
local p=r(p)
local F=r(F)
outreg2 using $Tables/RegressionResults.xls, replace addstat(p, `p', F, `F') dec(3)

*Household characteristics
reg logEducExpenditure FemaleHH logIncome HHeadAge c.HHeadAge#c.HHeadAge HouseholdSize , robust
test FemaleHH
local p=r(p)
local F=r(F)
outreg2 using $Tables/RegressionResults.xls, append addstat(p, `p', F, `F') dec(3)

*Living place characteristics
reg logEducExpenditure FemaleHH logIncome HHeadAge c.HHeadAge#c.HHeadAge HouseholdSize  NumberOfLightBulbs , robust
test FemaleHH
local p=r(p)
local F=r(F)
outreg2 using $Tables/RegressionResults.xls, append addstat(p, `p', F, `F')  dec(3)

*Fixed effects 
reg logEducExpenditure FemaleHH logIncome HHeadAge c.HHeadAge#c.HHeadAge HouseholdSize  NumberOfLightBulbs i.State, robust
test FemaleHH
local p=r(p)
local F=r(F)
outreg2 using $Tables/RegressionResults.xls, append addstat(p, `p', F, `F')  dec(3)

areg logEducExpenditure FemaleHH logIncome HHeadAge c.HHeadAge#c.HHeadAge HouseholdSize NumberOfLightBulbs, robust absorb(MunicipalityID)
test FemaleHH
local p=r(p)
local F=r(F)
outreg2 using $Tables/RegressionResults.xls, append addstat(p, `p', F, `F') dec(3)

********************************************************************************
*Figures
********************************************************************************

*Histograms
hist logEducExpenditure

hist logEducExpenditure, graphregion(color(white)) xtitle("log of Expenditure in Education") color(gs12) lcolor(gs4) ylabel(, nogrid)

graph export "$Figures\Histogram.png", as(png) name("Graph") replace

*Kernel density 
twoway (kdensity logEducExpenditure if FemaleHH,  lcolor(gs2) lpattern(dash_dot)) (kdensity logEducExpenditure if !FemaleHH, lcolor(gs6) lpattern(line)), graphregion(color(white)) xtitle("log of Expenditure in Education") ytitle("Kernel density estimate") ylabel(, nogrid) legend(label(1 "Female HH") label(2 "Male HH")) 

graph export "$Figures\Kdensity.png", as(png) name("Graph") replace

*Scatter plot (Note the advantages of labeling variables)
scatter EducExpenditure FlowIncome

scatter EducExpenditure FlowIncome, graphregion(color(white)) color(gs8) msize(tiny) msymbol(T)

graph export "$Figures\Scatter.png", as(png) name("Graph") replace

*Bar plot (not a twoway function)
graph bar (median) logEducExpenditure logIncome, over(FemaleHH)

label define FemaleHH 0 "Male" 1 "Female"
label values FemaleHH FemaleHH

graph bar  (median) logEducExpenditure  logIncome   , over(FemaleHH) graphregion(color(white)) legend(label(1 "log Exp. in education") label(2 "log Income"))

graph export "$Figures\BarPlot.png", as(png) name("Graph") replace

********************************************************************************
*Coefplot
********************************************************************************
use "$Working\FinalDataset.dta", clear

gen State9=State==9
qui su logEducExpenditure
gen logEducExpenditure_demeaned=logEducExpenditure-`r(mean)'

reg logEducExpenditure i.State o.State9 , robust 
label variable State9 "9"

coefplot
 
coefplot , omitt keep(*.State State9) sort  levels(95) ciopts(recast(rcap) color(gs8)) msymbol(T) msize(small) mcolo(gs4) grid(none) graphregion(color(white))  xtitle("Percent difference in education expenditure wrt national mean by state") xline(0, lpattern(-..) lcolor(gs1)) 





