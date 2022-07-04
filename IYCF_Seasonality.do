* IYCF Seasonality Analysis
* Five pooled datasets from India 2005-21

mum_work inst_birth bord 

* Data requirements for following analysis:  All months of the year must be represented in the data.
* Analysis with 5 datasets

* Add dependencies
* ssc install combomarginsplot

* Combomarginsplot
* help combomarginsplot
* Coefplot -  http://repec.sowi.unibe.ch/stata/coefplot/getting-started.html

* Don't forget
* make one NFHS5 dataset with EIBF and EBF
* 	or insert drop vars into code before analysis
* decide to use RSOC - yes or no? 

* Analysis Plan
* 1 Graph of percent data collected by month by survey
* 2 Data by background variables (weighted estimates)
* 3 Tests for seasonal variation by month12
* 4 Amplitude of seasonal variation by vars
* 5 Adjusted vs unadjusted survey estimates of breastfeeding vars / complementary feeding vars
* 		significant/ relevant differences
* 6 Adjusted survey estimates by month
* 7 Trend analysis
* Excel EBF graph by 12 months by survey (centred on midpoint of data collection) without trend lines
* Excel Water graph by 12 months by survey (centred on midpoint of data collection) without trend lines

* Analysis by region by month

* Analysis by rural / urban by month
* Analysis by wealth index by month

 

* Dependent variables

* General
// evbf currently_bf
* First day of life
// eibf eibf_timing ebf3d
// prelacteal_milk prelacteal_sugarwater prelacteal_water prelacteal_gripewater prelacteal_saltwater prelacteal_juice prelacteal_formula prelacteal_tea prelacteal_honey prelacteal_janamghuti prelacteal_other prelacteal_otherthanmilk prelacteal_milk_form 
* Breastfeeding and liquids
// ebf mixed_milk water juice tea other_liq milk formula broth bottle
// freq_milk freq_formula freq_other_milk

* if vars are not represented by each survey - like ebf3d, tea, freq_milk, freq_formula, do not include

// set scheme plotplainblind

* Include paths 
include "C:\Users\stupi\OneDrive - UNICEF\1 UNICEF Work\1 moved to ECM\IIT-B\IYCF\analysis\robert_paths.do"
// include "dnyaneshwar_paths.do"

* Load Data
use iycf_5surveys.dta, clear 

* path for graphs to apply to word doc. 
cd C:\Temp\Junk

tab int_month round, m
tab round if agemos<24, m
sum agemos


* for independent variables in analysis, we do not need to create dummies if we specify variable type in code
* for categorical vars use "i."
* for continuous vars use "c."
* for use of age and age squared use - c.age c.age#c.age

* wi and mum_educ are considered categorical variables, as agegrp is considered categorical in stata manual

local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work i.anc4+ i.early_anc i.c_section i.inst_birth i.bord c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
di "`ContVars'"






tab ebf round
gen ebf_x = ebf*100
tab ebf_denom round

version 16: table round [pw = national_wgt] if ebf_denom==1, c(mean ebf_x n ebf_x) format(%9.1f)
version 16: table round [pw = national_wgt] , c(mean ebf_x n ebf_x) format(%9.1f)
* Reported results from survey reports
// youngest child < 6 months living with mother
// NFHS-3 REPORT  EBF<6M  	46.4     5,081 -
//										   - uses age in months v008-b3  & child is alive, most recent birth & child living with mother
// RSOC   REPORT  EBF<6M  	64.9     9,281
// NFHS-4 REPORT  EBF<6M  	55.0    21,365 - 
//                                         - uses age in months v008-b3  & child is alive
//                                         - does not use most recent birth & child living with mother
// CNNS   REPORT  EBF<6M  	58.0     3,615 - is old estimate from CNNS Report.  This has been updated by new code
// NFHS-5 REPORT  EBF<6M  	63.7  	22,406 

* Test for inclusion of only youngest child of woman
egen ebf_count = tag(caseid v003 ebf)
* Child is twin
tab b0 ebf_count,m
tab round ebf_count ,m
* 103 cases from NFHS-5 of mulitiple births with EBF data collected


* Analysis
* Data by background variables (weighted estimates)

* Add code from Dnyaneshwar here
**********
* Table 1
**********

* Table for prevalence estimate from dependent variables

foreach var of varlist ebf mixed_milk water juice other_liq milk formula broth bottle {
	replace `var' = . if agemos>=6
}
foreach var of varlist evbf currently_bf eibf prelacteal_milk prelacteal_sugarwater prelacteal_water prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey prelacteal_janamghuti prelacteal_other {
	replace `var' = . if agemos>=24
}

putexcel set prev_table, replace
putexcel A1 = "Table 2: Prevalence of breastfeeding and giving liquids variables by survey, India Surveys 2005-2021"
putexcel A2 = "Variable"
putexcel C2 = "NFHS-3"
putexcel D2 = "RSOC"
putexcel E2 = "NFHS-4"
putexcel F2 = "CNNS"
putexcel G2 = "NFHS-5"

// evbf currently_bf
// ebf mixed_milk water juice other_liq milk formula broth bottle
// eibf prelacteal_milk prelacteal_sugarwater prelacteal_water prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey prelacteal_janamghuti prelacteal_other


local RowNum = 1

foreach var of varlist evbf currently_bf ebf mixed_milk water juice other_liq milk formula broth bottle eibf prelacteal_milk prelacteal_sugarwater prelacteal_water prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey prelacteal_janamghuti prelacteal_other {
	local RowNum = `RowNum'+2
	putexcel A`RowNum' = "`var'"
	local ObsRowNum = `RowNum' +1
	putexcel B`ObsRowNum' = "N"

	forvalues i=1/5 {
		sum `var' [aw = national_wgt] if round==`i'
		local Cell = char(66 + `i' ) + string(`RowNum')
// 		local Prev =(cond(`r(mean)'==0,"-", string(`r(mean)'*100)))
		local Prev = string(`r(mean)'*100)
		putexcel `Cell' = `Prev', nformat(#0.0)
		local Cell = char(66 + `i') + string(`ObsRowNum')
// 		local Obs =(cond(`r(N)'<=1,"-", string(`r(N)')))
// 		putexcel `Cell' = `Obs', nformat(#,###)
		putexcel `Cell' = `r(N)', nformat(#,###)
	}
}
putexcel save

tab broth round [aw = national_wgt], col
tab bottle round [aw = national_wgt], col
sum broth if round==1
sum bottle if round==2


local Prev =(cond(`r(mean)'==0,"-", string(`r(mean)'*100)))
local Obs =(cond(`r(N)'<=1,"-", string(`r(N)')))
di "`Prev'"
di "`Obs'" 
	
	
	
	
	
	
	
* Tables for dependent variables, max / min / amplitude / statistical significance of monthly variation

* Assumption, if there is no variation in pooled 5 survey data, then no variation in single survey dataset
* Start Min Max Table 
putexcel set min_max_table, replace
putexcel A1 = "Table X: Annual prevalence & standard deviation with monthly estimates of minimum, maximum and amplitude of feeding variables adjusted for socio-demographic variation, India Surveys 2005-2021"
putexcel A2 = "Var"
putexcel B2 = "Prevalence"
putexcel C2 = "SD"
putexcel D2 = "Min"
putexcel E2 = "Max"
putexcel F2 = "Amp"
putexcel G2 = "N"

local DepVars = "evbf currently_bf"
local ControlVars i.int_month i.state i.rururb i.wi i.mum_educ c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
local RowNum = 2

foreach var of varlist evbf currently_bf {
	di "`var'"
 	local RowNum = `RowNum' +1
	logit `var' `ControlVars' [pw = national_wgt] if agemos < 24
	margins 
	* save r(table) to normal matrix
	matrix output = r(table)
	local temp = "`r(predict1_label)'"
	local temp1 = substr("`temp'",4,.)
	local var_name = subinstr("`temp1'",")","",.)
	putexcel A`RowNum' = "`var_name'"
	putexcel B`RowNum' = (output[1,1] * 100), nformat(##.0) // mean one digit 
	* Note SD is calculated as SD = SE * sqrt(N)
	putexcel C`RowNum' = (output[2,1] * sqrt(`r(N)')), nformat(number_d2) // standard deviation two digits
	putexcel G`RowNum' = `r(N)', nformat(#,###) 

	margins int_month
	putexcel set margin_output, replace
	* Add Matrix
	putexcel A1 = matrix(r(table)'), names
	* Add varname to Matrix
	putexcel A1 = "`r(predict1_label)'"
	putexcel save
	import excel "C:\Temp\Junk\margin_output.xlsx", sheet("Sheet1") firstrow clear
	sum b, meanonly
	local min = r(min) *100
	local max = r(max) *100
	local amp = (`max'-`min')/2
	putexcel set min_max_table, modify
	putexcel D`RowNum' = `min', nformat(##.0) 		// min
	putexcel E`RowNum' = `max', nformat(##.0) 	  	// max
	putexcel F`RowNum' = `amp', nformat(number_d2)  // amplitude
	putexcel save
	use C:\Temp\Data\iycf_5surveys.dta, clear 
}

local ControlVars i.int_month i.state i.rururb i.wi i.mum_educ c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
local RowNum = 5

foreach var of varlist ebf mixed_milk water juice other_liq milk formula broth bottle {
	di "`var'"
 	local RowNum = `RowNum' +1
	logit `var' `ControlVars' [pw = national_wgt] if agemos < 6
	margins 
	* save r(table) to normal matrix
	matrix output = r(table)
	local temp1 = substr("`r(predict1_label)'",4,.)
	local var_name = subinstr("`temp1'",")","",.)
	putexcel A`RowNum' = "`var_name'"
	putexcel B`RowNum' = (output[1,1] * 100), nformat(##.0) // mean one digit 
	* Note SD is calculated as SD = SE * sqrt(N)
	putexcel C`RowNum' = (output[2,1] * sqrt(`r(N)')), nformat(number_d2) // standard deviation two digits
	putexcel G`RowNum' = `r(N)', nformat(#,###) 

	margins int_month
	putexcel set margin_output, replace
	* Add Matrix
	putexcel A1 = matrix(r(table)'), names
	* Add varname to Matrix
	putexcel A1 = "`r(predict1_label)'"
	putexcel save
	import excel "C:\Temp\Junk\margin_output.xlsx", sheet("Sheet1") firstrow clear
	sum b, meanonly
	local min = r(min) *100
	local max = r(max) *100
	local amp = (`max'-`min')/2
	putexcel set min_max_table, modify
	putexcel D`RowNum' = `min', nformat(##.0) 		// min
	putexcel E`RowNum' = `max', nformat(##.0) 	  	// max
	putexcel F`RowNum' = `amp', nformat(number_d2)  // amplitude
	putexcel save
	use C:\Temp\Data\iycf_5surveys.dta, clear 
}

* add initiation of breastfeeding variables
local ControlVars i.birthmonth i.state i.rururb i.wi i.mum_educ c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
local RowNum = 14

foreach var of varlist eibf prelacteal_milk prelacteal_sugarwater prelacteal_water prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey prelacteal_janamghuti prelacteal_other { 
	di "`var'"
 	local RowNum = `RowNum' +1
	logit `var' `ControlVars' [pw = national_wgt] if agemos < 24
	margins 
	* save r(table) to normal matrix
	matrix output = r(table)
	local temp1 = substr("`r(predict1_label)'",4,.)
	local var_name = subinstr("`temp1'",")","",.)
	putexcel A`RowNum' = "`var_name'"
	putexcel B`RowNum' = (output[1,1] * 100), nformat(##.0) // mean one digit 
	* Note SD is calculated as SD = SE * sqrt(N)
	putexcel C`RowNum' = (output[2,1] * sqrt(`r(N)')), nformat(number_d2) // standard deviation two digits
	putexcel G`RowNum' = `r(N)', nformat(#,###) 

	margins birthmonth
	putexcel set margin_output, replace
	* Add Matrix
	putexcel A1 = matrix(r(table)'), names
	* Add varname to Matrix
	putexcel A1 = "`r(predict1_label)'"
	putexcel save
	import excel "C:\Temp\Junk\margin_output.xlsx", sheet("Sheet1") firstrow clear
	sum b, meanonly
	local min = r(min) *100
	local max = r(max) *100
	local amp = (`max'-`min')/2
	putexcel set min_max_table, modify
	putexcel D`RowNum' = `min', nformat(0.0) 		// min
	putexcel E`RowNum' = `max', nformat(0.0) 	  	// max
	putexcel F`RowNum' = `amp', nformat(number_d2)  // amplitude
	putexcel save
	use C:\Temp\Data\iycf_5surveys.dta, clear 
}



local ExportPath "C:/TEMP/Seasonality"
local FileName "IYCF Seasonality.docx"
di "`ExportPath'/`FileName'"

* Document containing results
* TITLE PAGE
putdocx clear
putdocx begin, font("Calibri") 
putdocx paragraph, style(Title) halign(center) spacing(line,16 pt)
putdocx text ("Seasonality of IYCF variables ")
putdocx paragraph, style(Title) halign(center) spacing(line,14 pt)
putdocx text ("in Indian 5 Surveys ")
putdocx save "`ExportPath'/`FileName'", replace
	

* Exclusive Breastfeeding by Round
* add corrections for selection of correct denominators
drop if agemos >=6



* Plot adjusted vs unadjusted estimates onto one graph
* Here we use the mean month of data collection for comparison - not perfect for comparison.  That is the point that we are demonstrating. 




// local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round

logit ebf_x i.round [pw = national_wgt] 
logit ebf_x ib12.int_month i.round [pw = national_wgt] 
logit ebf_x ib12.int_month i.round i.mum_work [pw = national_wgt] 

logit ebf_x ib12.int_month i.state i.rururb i.wi i.mum_educ i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round [pw = national_wgt] 

logit ebf_x ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work  i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round [pw = national_wgt] 





local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round

* old list
// local ContVars i.int_month i.state i.rururb i.wi i.mum_educ c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round

logit ebf_x `ContVars' [pw = national_wgt] 
* output by round of survey
margins round, saving(file1, replace)

logit ebf_x i.round [pw = national_wgt] 
* here no controls are applied for month of data collection 
margins round, saving(file2, replace)
* Make combomarginsplot
combomarginsplot file1 file2, labels("Adjusted" "Unadjusted") ///
	file1opts(pstyle(p1)) file2opts(pstyle(p2)) lplot1(mfcolor(white)) ///
	title("Exclusive breastfeeding by survey") legend(col(2))


	
* Add combomarginsplot to word file1
putdocx begin, font("Calibri") 
putdocx save "`ExportPath'/`FileName'", append

* Giving Water by Round
* selection of correct denominators
drop if agemos >=6

// * corrections for NFHS-5
// keep if b19 < 24 & b9 == 0
// // * if caseid is the same as the prior case, then not the last born
// keep if _n == 1 | caseid != caseid[_n-1]

* Plot adjusted vs unadjusted estimates onto one graph
* old
// local ContVars i.int_month i.state i.rururb i.wi i.mum_educ c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round

local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round

logit water `ContVars' [pw = national_wgt] if ebf_denom==1
* output by round of survey
margins round, saving(file1, replace)

logit water i.round [pw = national_wgt] if ebf_denom==1
* here no controls are applied for month of data collection 
margins round, saving(file2, replace)
* Make combomarginsplot
combomarginsplot file1 file2, labels("Adjusted" "Unadjusted") ///
	file1opts(pstyle(p1)) file2opts(pstyle(p2)) lplot1(mfcolor(white)) ///
	title("Giving water by survey") legend(col(2))

// combomarginsplot file1 file2, labels("Adjusted" "Unadjusted") ///
// 	file1opts(pstyle(p1)) file2opts(pstyle(p2)) lplot1(mfcolor(white)) ///
// 	byopt(legend(at(3) pos(1)) title("Probability exclusive breastfeeding by survey")) legend(col(1))
	
* Add combomarginsplot to word file1
putdocx begin, font("Calibri") 
putdocx save "`ExportPath'\`FileName'", append


local ExportPath "C:/TEMP/Seasonality"
local FileName "IYCF Seasonality.docx"
putdocx save "`ExportPath'/`FileName'", append



* Plot adjusted EBF estimates by month for all 5 surveys / pooled data in one graph
local ContVars i.int_month i.state i.rururb i.wi i.mum_educ c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
logit ebf `ContVars' [pw = national_wgt] if ebf_denom==1
margins int_month, saving(file1, replace)
marginsplot, title("Exclusive breastfeeding by month of data collection") ylab(0.1(.1)0.7) yscale(range(0.1 0.7))

* Plot adjusted ebf water estimates by month for all 5 surveys - one graph
local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ c.age_days c.age_days2 i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
// Plot adjusted water, mixed_milk, formula bottle estimates by month for all 5 surveys - one graph
// foreach v of varlist water mixed_milk formula bottle {  
foreach v of varlist ebf water {  
	logit `v' `ContVars' [pw = national_wgt]  if ebf_denom==1
	margins int_month
	marginsplot, title("`v'") name(month_`v', replace) ylab(0.2(.1)0.7) yscale(range(0.2 0.7))
}

graph combine month_ebf month_water , xsize(6.5) ysize(2.7) iscale(.8) name(comb, replace)
graph close month_ebf month_water 
graph export "Feeding variables by month of data collection.png", width(6000) replace

* Change the y axis to prevalence
* Change the y label to prevalence



	
	
	
* Exclusive Breastfeeding by Month by Round - ALL SURVEY DATA (adjusted)
* this format is not very interpretable
logit ebf ib12.int_month##i.round i.state i.rururb i.wi i.mum_educ c.age_days c.age_days2 i.sex i.cat_birth_wt i.diar i.fever i.ari [pw = national_wgt] 
margins int_month#round,  saving(file1, replace)
marginsplot, title("Exclusive breastfeeding by month of data collection & round") 









* Exclusive breastfeeding	
* Plot the predicted values of the dependent variable for each survey in five graphs for five surveys
* Combomarginsplot - joining five graphs onto one background
forval x = 1/5 {
	logit ebf ib12.int_month##i.round i.state i.rururb i.wi i.mum_educ c.age_days ///
		c.age_days2 i.sex i.cat_birth_wt i.diar i.fever i.ari i.round [pw = national_wgt] if round==`x' 
	margins int_month#round
	local RoundValueLabel : value label round
	local GraphLabel: label `RoundValueLabel' `x'
	marginsplot, title("`GraphLabel'") name(file`x', replace) ylab(0(.1)1) yscale(range(0 1))
}
graph combine file1 file2 file3 file4 file5, xsize(6.5) ysize(2.7) iscale(.8) name(comb, replace)
graph close file1 file2 file3 file4 file5
graph export "EBF by month by survey.png", width(6000) replace

* WATER
* Plot the predicted values of the dependent variable in five graphs for five surveys
* Combomarginsplot - joining five graphs onto one background
forval x = 1/5 {
	logit water ib12.int_month##i.round i.state i.rururb i.wi i.mum_educ c.age_days ///
		c.age_days2 i.sex i.cat_birth_wt i.diar i.fever i.ari i.round [pw = national_wgt] if round==`x' 
	margins int_month#round
	local RoundValueLabel : value label round
	local GraphLabel: label `RoundValueLabel' `x'
	marginsplot, title("`GraphLabel'") name(file`x', replace) ylab(0(.1)1) yscale(range(0 1))
}
graph combine file1 file2 file3 file4 file5, xsize(6.5) ysize(2.7) iscale(.8) name(comb, replace)
graph close file1 file2 file3 file4 file5
graph export "Water by month by survey.png", width(6000) replace


	
* WATER by Round
// logit ebf "`ContVars'" [pw = national_wgt] 
* Full list
logit water ib12.int_month i.state i.rururb i.wi i.mum_educ i.sex i.diar i.fever i.ari i.round [pw = national_wgt] 

* does illness drive giving water? 
logit water ib12.int_month i.state i.rururb i.wi i.mum_educ i.sex i.round [pw = national_wgt] 

margins round, saving(file1, replace)

logit water ib12.int_month i.round [pw = national_wgt] 
margins round, saving(file2, replace)
combomarginsplot file1 file2, labels("Adjusted" "Unadjusted") ///
	file1opts(pstyle(p1)) file2opts(pstyle(p2)) lplot1(mfcolor(white)) ///
	byopt(legend(at(3) pos(1)) title("Probability exclusive breastfeeding by survey")) legend(col(1))

	
* For Excel Graph
* Use estimates that assume that all data was collected in April
local ContVars i.int_month i.state i.rururb i.wi i.mum_educ c.age_days c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
logit ebf_x `ContVars' [pw = national_wgt] if ebf_denom==1
* output by round of survey
margins round, at(int_month=4) saving(file1, replace)	
	
	

* Exclusive Breastfeeding by Month by Socio-Economic Status - ALL SURVEY DATA (adjusted)
* to aid interpretation - convert to SES terciles
logit ebf ib12.int_month##i.wi i.state i.rururb i.mum_educ c.age_days c.age_days2 i.sex i.cat_birth_wt i.diar i.fever i.ari [pw = national_wgt] 
margins int_month#wi,  saving(file1, replace)
marginsplot, title("Exclusive breastfeeding by month of data collection & SES") 

	


// Test chi-square differences
tab eibf int_month, chi2
* sample size so large everything is sig. 

logit eibf ib12.int_month [pw = national_wgt] 
margins int_month
marginsplot
* months 8 & 10 are sig different but not public health relevant

logit eibf ib12.birthmonth ib12.int_month [pw = national_wgt] 
margins birthmonth
marginsplot

* beware of results for children > 6 month of age
logit water ib12.int_month [pw = national_wgt] 
margins int_month
marginsplot




























* evbf currently_bf
putdocx begin, font("Calibri", 9)

* Seasonality of depvar01
local depvar01  evbf currently_bf
local contvars state round

foreach var in `depvar01' {
	di `depvar01'
		
	logit `var' ib12.int_month state round [pw = national_wgt] 
	margins int_month
	marginsplot, title(`var' by month of data collection) ylabel(0(0.1)1)
	graph export `var'.tif, as(tif) replace

	putdocx paragraph, halign(center)
	putdocx image "`var'.tif"
}
local ExportPath "C:/TEMP/Seasonality"
local FileName "IYCF Seasonality.docx"
putdocx save "`ExportPath'/`FileName'", append






*  eibf ebf3d 
* ANALYSIS BY MONTH OF BIRTH
putdocx begin, font("Calibri", 9)

* Seasonality of depvar01
local depvar01  eibf ebf3d 
local contvars state round

foreach var in `depvar01' {
	di `depvar01'
		
	logit `var' ib12.birthmonth state round [pw = national_wgt] 
	margins birthmonth
	marginsplot, title(`var' by birth month) ylabel(0(0.1)1)
	graph export `var'.tif, as(tif) replace

	putdocx paragraph, halign(center)
	putdocx image "`var'.tif"
}
local ExportPath "C:/TEMP/Seasonality"
local FileName "IYCF Seasonality.docx"
putdocx save "`ExportPath'/`FileName'", append


* Exclusive Breastfeeding
putdocx begin, font("Calibri", 9)
* Seasonality of depvar01
local depvar01 ebf mixed_milk 
* Mixed-milk formerly labelled predominant_bf - misnomer. 
local contvars state round

// local depvar01  water 
foreach var in `depvar01' {
	drop if agemos>=6
	di `depvar01'
	logit `var' ib12.int_month state round [pw = national_wgt] 
	margins int_month
	marginsplot, title(`var' by month of data collection) ylabel(0(0.1)1)
	graph export `var'.tif, as(tif) replace

	putdocx paragraph, halign(center)
	putdocx image "`var'.tif"
}
local ExportPath "C:/TEMP/Seasonality"
local FileName "IYCF Seasonality.docx"
putdocx save "`ExportPath'/`FileName'", append


* Other liquids
use iycf_5surveys.dta, clear 
* verify the age range to be used here.
putdocx begin, font("Calibri", 9)

* Seasonality of depvar01
local depvar01 water milk formula juice tea other_liq broth bottle
local contvars state round

foreach var in `depvar01' {
	drop if agemos>=6
	di `depvar01'
	logit `var' ib12.int_month state round [pw = national_wgt] 
	margins int_month
	marginsplot, title(`var' by month of data collection) 
	graph export `var'.tif, as(tif) replace

	putdocx paragraph, halign(center)
	putdocx image "`var'.tif"
}
local ExportPath "C:/TEMP/Seasonality"
local FileName "IYCF Seasonality.docx"
putdocx save "`ExportPath'/`FileName'", append


	
* Seasonality of depvar
// local depvar eibf_timing 
local depvar eibf_timing freq_milk freq_formula freq_other_milk
foreach var in `depvar' {
	reg `var' ib12.int_month state round [pw = national_wgt] 
	margins int_month
	marginsplot, title(`depvar01'" by month of data collection") 
	graph export `depvar'.tif, as(tif) replace
	putdocx begin, font("Calibri", 9)
	putdocx paragraph, halign(center)
	putdocx image "`depvar'.tif"
}

putdocx save "`ExportPath'/`FileName'", append
end

* Dependent variables
* Complementary Feeding
fortified_food gruel poultry meat legume nuts bread potato vita_veg leafy_green vita_fruit fruit_veg organ fish leg_nut yogurt semisolid carb dairy all_meat vita_fruit_veg any_solid_semi_food intro_compfood mdd freq_solids mmf_bf mmf_all_bf mad_all_bf egg_meat zero_fv sugar_bev


*Control Variables
* Sex, age, birthweight, mother's labor force participation, children illness



*Sex
gen male = 1 if q102 ==1
replace male = 0 if q102 ==2

*Age by six month blocks
cap drop agecat
gen agecat = floor(agemons/6)+1
tab agemons agecat, m 
gen agecat_m = agecat
replace agecat_m = 11 if agecat ==.
label def agemo 1 "0-5" 2 "6-11" 3 "12-17" 4 "18-23" 5 "24-29" 6 "30-35" 7 "36-41" 8 "42-47" 9 "48-53" 10 "54-59" 11 "Missing" , replace
label val agecat_m agemo
label var agecat_m "Age (in months)"
tab agecat_m, m 



*Birth weight

*Converting Birth Weight into a categorical variable

* Birth weight recall

* Creation of birth weight based on mothers recall or written card

*Status of mother's labor force participation
* CNNS
// gen mother_working = mother_work
// label define working 0 "not in work force" 1 "in work force" 2 "NA/ Not alive" , replace
// label val mother_working working
// label var mother_working "Working Status"
// tab mother_working, m

*Status of mother's education

*Wealth

*Household Size
* number of household members
// gen hhmem = f_size

*Religion
// gen hindu = religion ==1
// label def rel 0 "Other" 1 "Hindu", replace
// label val hindu rel
// label var hindu "Hindu/Other"

*Caste

*Residence

*State

*Month of survey




*Dependent Variables

*Variable of interest
sum month12
*Other covariates
sum male agecat_m bweight mean_height_mother mother_working education_years wealth hhmem hindu caste rural statecode
*Gender of the child
*Age of the child
*Birth weight combined with mother's recall status
*Mother's Height
*Mother's Working status
*Mother's education status
*Wealth
*Household Size
*Religion
*Caste
*Rural





*Variable finalising the sample to be used for a particular dependent variable
local depvar zwfh
foreach var in `depvar' {
gen final_`var' = 1 if `var' != . & month12 !=. & male !=. & bweight !=. & agecat_m !=. & mean_height_mother != . & education_years   !=. & mother_working  !=. & hindu  !=. & caste !=. & rural !=. & hhmem !=. & wealth !=. & statecode !=. 
}

local depvar_01 wasted sev_wasted
foreach var in `depvar_01' {
gen final_`var' = 1 if `var' != . & month12 !=. & male !=. & bweight !=. & agecat_m !=. & mean_height_mother != . & education_years   !=. & mother_working  !=. & hindu  !=. & caste !=. & rural !=. & hhmem !=. & wealth !=. & statecode !=. 
}

* test for missing cases in variables
mdesc zwfh male agecat_m bweight mean_height_mother mother_working education_years wealth hhmem hindu caste rural statecode
mdesc male agecat_m bweight mean_height_mother mother_working education_years wealth hhmem hindu caste rural statecode
 if zwfh !=.

* Removed all data but the CNNS

local depvar zwfh
foreach var in `depvar' {
sum `var' sum_month121 sum_month122 sum_month123 sum_month124 sum_month125 sum_month126 sum_month127 sum_month128 sum_month129 sum_month1210 sum_month1211 sum_month1212 male   sum_agecat_m1 sum_agecat_m2 sum_agecat_m3 sum_agecat_m4 sum_agecat_m5 sum_agecat_m6 sum_agecat_m7 sum_agecat_m8 sum_agecat_m9 sum_agecat_m10 sum_agecat_m11 sum_weight1 sum_weight2 sum_weight3 sum_weight4 sum_weight5 sum_weight6 mean_height_mother sum_mother_working1 sum_mother_working2 sum_mother_working3 sum_education_years1 sum_education_years2 sum_education_years3 sum_education_years4 sum_education_years5 sum_education_years6 sum_education_years7 sum_wealth1 sum_wealth2 sum_wealth3 sum_wealth4 sum_wealth5 hhmem hindu sum_caste1 sum_caste2 sum_caste3 sum_caste4 rural sum_state1 sum_state2 sum_state3 sum_state4 sum_state5 sum_state6 sum_state7 sum_state8 sum_state9 sum_state10 sum_state11 sum_state12 sum_state13 sum_state14 sum_state15 sum_state16 sum_state17 sum_state18 sum_state19 sum_state20 sum_state21 sum_state22 sum_state23 sum_state24 sum_state25 sum_state26 sum_state27 sum_state28 sum_state29 sum_state30 if final_`var' ==1

}

local depvar_01 wasted sev_wasted
foreach var in `depvar_01' {
sum `var' sum_month121 sum_month122 sum_month123 sum_month124 sum_month125 sum_month126 sum_month127 sum_month128 sum_month129 sum_month1210 sum_month1211 sum_month1212 male   sum_agecat_m1 sum_agecat_m2 sum_agecat_m3 sum_agecat_m4 sum_agecat_m5 sum_agecat_m6 sum_agecat_m7 sum_agecat_m8 sum_agecat_m9 sum_agecat_m10 sum_agecat_m11 sum_weight1 sum_weight2 sum_weight3 sum_weight4 sum_weight5 sum_weight6 mean_height_mother sum_mother_working1 sum_mother_working2 sum_mother_working3 sum_education_years1 sum_education_years2 sum_education_years3 sum_education_years4 sum_education_years5 sum_education_years6 sum_education_years7 sum_wealth1 sum_wealth2 sum_wealth3 sum_wealth4 sum_wealth5 hhmem hindu sum_caste1 sum_caste2 sum_caste3 sum_caste4 rural sum_state1 sum_state2 sum_state3 sum_state4 sum_state5 sum_state6 sum_state7 sum_state8 sum_state9 sum_state10 sum_state11 sum_state12 sum_state13 sum_state14 sum_state15 sum_state16 sum_state17 sum_state18 sum_state19 sum_state20 sum_state21 sum_state22 sum_state23 sum_state24 sum_state25 sum_state26 sum_state27 sum_state28 sum_state29 sum_state30 if final_`var' ==1
}



* Establish the method to identify the relevant independant variables that should be included in the model
*Variables of Interest - sum_month121 sum_month122 sum_month123 sum_month124 sum_month125 sum_month126 sum_month127 sum_month128 sum_month129 sum_month1210 sum_month1211 sum_month1212
*Other Covariates
local covariates  male   sum_agecat_m1 sum_agecat_m2 sum_agecat_m3 sum_agecat_m4 sum_agecat_m5 sum_agecat_m6 sum_agecat_m7 sum_agecat_m8 sum_agecat_m9 sum_agecat_m10 sum_agecat_m11 sum_weight1 sum_weight2 sum_weight3 sum_weight4 sum_weight5 sum_weight6 mean_height_mother sum_mother_working1 sum_mother_working2 sum_mother_working3 sum_education_years1 sum_education_years2 sum_education_years3 sum_education_years4 sum_education_years5 sum_education_years6 sum_education_years7 sum_wealth1 sum_wealth2 sum_wealth3 sum_wealth4 sum_wealth5 hhmem hindu sum_caste1 sum_caste2 sum_caste3 sum_caste4 rural sum_state1 sum_state2 sum_state3 sum_state4 sum_state5 sum_state6 sum_state7 sum_state8 sum_state9 sum_state10 sum_state11 sum_state12 sum_state13 sum_state14 sum_state15 sum_state16 sum_state17 sum_state18 sum_state19 sum_state20 sum_state21 sum_state22 sum_state23 sum_state24 sum_state25 sum_state26 sum_state27 sum_state28 sum_state29 sum_state30



* Seasonality of depvar
local depvar zwfh
foreach var in `depvar' {
reg `var' ib12.month12 male i.agecat_m i.bweight mean_height_mother i.mother_working i.education_years i.wealth hhmem hindu i.caste rural i.statecode [pw = survey_weight] 
margins month12
* marginsplot, noci
marginsplot
*graph save "PATH\`var'_1"
}




* recode of SES
gen wealth3 = 1 if wealth ==1 | wealth ==2
replace wealth3 = 2 if wealth ==3 
replace wealth3 = 3 if wealth ==4 | wealth ==5

* Seasonality of depvar by socio-economic status 
* Interaction of month with SES tercile
local depvar zwfh
foreach var in `depvar' {
reg `var' ib12.month12##i.wealth3 male i.agecat_m i.bweight mean_height_mother i.mother_working i.education_years i.wealth3 hhmem hindu i.caste rural i.statecode [pw = survey_weight] 
margins month12#wealth3

* marginsplot, noci
marginsplot
*graph save "PATH\`var'_1"
}



* Rural Urban
*reg zwfh ib12.month12##i.wealth3 i.weight i.agecat_m i.statecode i.education_years i.mother_working hindu i.caste rural hhmem [pw = survey_weight] 
*margins month12##rural
*marginsplot

* Rural Urban
reg zwfh ib12.month12 if rural ==1 [pw = survey_weight]
margins month12, saving("C:\Temp\Junk\temp_1.dta", replace)
reg zwfh ib12.month12 if rural ==0 [pw = survey_weight]
margins month12, saving ("C:\Temp\Junk\temp_0.dta", replace)
combomarginsplot "C:\Temp\Junk\temp_1.dta" "C:\Temp\Junk\temp_0.dta", labels("Rural" "Urban") ytitle(Linear Predictions) noci


* Male vs Female
reg zwfh ib12.month12 if male==1 [pw = survey_weight]
margins month12, saving("C:\Temp\Junk\temp_1.dta", replace)
reg zwfh ib12.month12 if male ==0 [pw = survey_weight]
margins month12, saving ("C:\Temp\Junk\temp_0.dta", replace)
combomarginsplot "C:\Temp\Junk\temp_1.dta" "C:\Temp\Junk\temp_0.dta", labels("Male" "Female") ytitle(Linear Predictions) noci

* recode of agecat
gen age = 0 if agecat<3
replace age = 1 if agecat>=3 & agecat<5
replace age = 2 if agecat>=5 & agecat<7
replace age = 3 if agecat>=7 & agecat<9
replace age = 4 if agecat>=9 & agecat<11
tab agecat age, m

* Does month of birth affect seasonality effect on prevalence of wasting (WHZ<-2SD)  in children under-five
* Month of birth -q103m
* add code - I am trying two different specifications
*1. Including month of birth alongwith age of the child
local depvar zwfh
foreach var in `depvar' {
reg `var' ib12.month12 ib12.q103m male i.agecat_m i.bweight mean_height_mother i.mother_working i.education_years i.wealth hhmem hindu i.caste rural i.statecode [pw = survey_weight] 
margins month12
* marginsplot, noci
marginsplot
*graph save "PATH\`var'_1"
}

local depvar_01 wasted sev_wasted
foreach var in `depvar' {
logit `var' ib12.month12 ib12.q103m male i.agecat_m i.bweight mean_height_mother i.mother_working i.education_years i.wealth hhmem hindu i.caste rural i.statecode [pw = survey_weight] 
margins month12
* marginsplot, noci
marginsplot
*graph save "PATH\`var'_1"
}
*2. Replacing age of the children by month of birth as it is likely to be collinear with the age.
local depvar zwfh
foreach var in `depvar' {
reg `var' ib12.month12 ib12.q103m male  i.bweight mean_height_mother i.mother_working i.education_years i.wealth hhmem hindu i.caste rural i.statecode [pw = survey_weight] 
margins month12
* marginsplot, noci
marginsplot
*graph save "PATH\`var'_1"
}

local depvar_01 wasted sev_wasted
foreach var in `depvar' {
logit `var' ib12.month12 ib12.q103m male i.bweight mean_height_mother i.mother_working i.education_years i.wealth hhmem hindu i.caste rural i.statecode [pw = survey_weight] 
margins month12
* marginsplot, noci
marginsplot
*graph save "PATH\`var'_1"
}

* Age in years
* should control for month of birth
reg zwfh ib12.month12 if age==0 [pw = survey_weight]
margins month12, saving("C:\Temp\Junk\temp_0.dta", replace)
reg zwfh ib12.month12 if age==1  [pw = survey_weight]
margins month12, saving ("C:\Temp\Junk\temp_1.dta", replace)
reg zwfh ib12.month12 if age==2 [pw = survey_weight]
margins month12, saving ("C:\Temp\Junk\temp_2.dta", replace)
reg zwfh ib12.month12 if age==2 [pw = survey_weight]
margins month12, saving ("C:\Temp\Junk\temp_3.dta", replace)
reg zwfh ib12.month12 if age==2 [pw = survey_weight]
margins month12, saving ("C:\Temp\Junk\temp_4.dta", replace)
combomarginsplot "C:\Temp\Junk\temp_0.dta" "C:\Temp\Junk\temp_1.dta" "C:\Temp\Junk\temp_2.dta" "C:\Temp\Junk\temp_3.dta" "C:\Temp\Junk\temp_4.dta", ///
	labels("0 years" "1 year" "2 years" "3 years" "4 years") ytitle(Linear Predictions) noci


* Does seasonality have an effect on prevalence of wasting (WHZ<-2SD)  in children under-five 
* wasted
tab wasted
tab wasted, m 

* Seasonality of wasting WITHOUT control vars
logit wasted ib12.month12  [pw = survey_weight] 
margins month12
marginsplot, title("Seasonality of Wasting")
* There is little seasonal variation with wasting here, from 15 to 20%

* Seasonality of wasting with control vars
logit wasted ib12.month12 male i.agecat_m i.bweight mean_height_mother i.mother_working i.education_years i.wealth hhmem hindu i.caste rural i.statecode [pw = survey_weight] 
margins month12
marginsplot, title("Seasonality of Wasting")
* There is significant seasonal variation here from 11 to 23%





* Does seasonality have an effect on prevalence of overweight / obesity in children under-five 


* END



* Please describe model or hypothesis for code below. 
*This was to plot the regression coefficients instead of predicted values of the dependent variable across the three rounds (NFHS3 NFHS4 combined and CNNS)
reg zwfh mos1-mos11 male i.weight i.agecat_m i.state_comp i.education_years ///
	i.mother_working hindu i.caste rural hhmem i.wealth i.round if round_new ==0 [pw = survey_weight] 
estimates store A
reg zwfh mos1-mos11 male i.weight i.agecat_m i.state_comp i.education_years ///
	i.mother_working hindu i.caste rural hhmem i.wealth if round_new ==1 [pw = survey_weight] 
estimates store B
coefplot A B,  vertical keep(  mos* )  citop recast(connected) label (1 "NFHS" 2 "CNNS")

* Please describe model or hypothesis for code below.
*In order to find the predicted values across the three rounds  NFHS3, NFHS4 and CNNS
reg zwfh ib12.month12##i.round [pw = survey_weight]
margins month12#round
marginsplot, noci

* Please describe model or hypothesis for code below. 
*In order to find the predicted values across the three rounds (NFHS3 NFHS4 combined and CNNS)
reg zwfh ib12.month12##i.round_new [pw = survey_weight]
margins month12#round_new
marginsplot, noci

* Please describe model or hypothesis for code below. 
*In order to find the predicted values across the three rounds (NFHS3 NFHS4 combined and CNNS) for a subsample of rural children
reg zwfh ib12.month12##i.round_new if rural ==1 [pw = survey_weight]
margins month12#round_new
marginsplot, noci

* Please describe model or hypothesis for code below. 
*In order to find the predicted values across the three rounds (NFHS3 NFHS4 combined and CNNS) for a subsample of urban children
reg zwfh ib12.month12##i.round_new if rural ==0 [pw = survey_weight]
margins month12#round_new
marginsplot, noci

* Please describe model or hypothesis for code below. 
*In order to find the predicted values across the three rounds (NFHS3 NFHS4 combined and CNNS) for a subsample of boys
reg zwfh ib12.month12##i.round_new if male ==1 [pw = survey_weight]
margins month12#round_new
marginsplot, noci

* Please describe model or hypothesis for code below. 
*In order to find the predicted values across the three rounds (NFHS3 NFHS4 combined and CNNS) for a subsample of girls
reg zwfh ib12.month12##i.round_new if male ==0 [pw = survey_weight]
margins month12#round_new
marginsplot, noci



* END

* Robert testing code

// preserve
// collapse 
// graph twoway (line water int_month if round==1) ///
// 	         (line water int_month if round==2) ///
// 	         (line water int_month if round==3) ///
// 	         (line water int_month if round==4) ///
// 	         (line water int_month if round==5, ///
// 	legend(ring(0) pos(2) col(1) order(2 "NFHS-3" 3 "RSOC" 4 "NFHS-4" 5 "CNNS" 6 "NFHS-5")))


*COLLAPSE
* attempt to calculate estimates by month and test for significant differences
preserve
// collapse (mean) ebf_month=ebf (seb) seb_ebf=ebf (mean) mean_h20=water (seb) seb_h20=water [aw = national_wgt] , by(int_month)
* collapse SEB does not work with aweights or pweights
collapse (mean) ebf_month=ebf (mean) mean_h20=water  [aw = national_wgt] , by(int_month)
* add SD in order to calculate mean and variance
// Test chi-square differences
tabstat ebf_month

* string manipulation
local temp = "`r(predict1_label)'"
di "`temp'"
local temp1 = substr("`temp'",4,.)
di "`temp1'"
local var_name = subinstr("`temp1'",")","",.)
di "`var_name'"






