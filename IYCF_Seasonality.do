* IYCF Seasonality Analysis
* Five pooled datasets from India 2005-21


* Data requirements for following analysis:  All months of the year must be represented in the data.
* Analysis with 5 datasets

* Add dependencies
* ssc install combomarginsplot

* Combomarginsplot
* help combomarginsplot
* Coefplot -  http://repec.sowi.unibe.ch/stata/coefplot/getting-started.html


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

******
* Extra analysis
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
* Continued Breastfeeding

* if vars are not represented by each survey - like ebf3d, tea, freq_milk, freq_formula, They are not included

set scheme s1mono

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
replace cont_bf =. if agemos<12 & agemos>23

putexcel set prev_table, replace
putexcel A1 = "Table 2: Prevalence of breastfeeding and giving liquids variables by survey, India Surveys 2005-2021"
putexcel A2 = "Variable"
putexcel C2 = "NFHS-3"
putexcel D2 = "RSOC"
putexcel E2 = "NFHS-4"
putexcel F2 = "CNNS"
putexcel G2 = "NFHS-5"

local RowNum = 1

foreach var of varlist evbf currently_bf eibf prelacteal_milk prelacteal_sugarwater prelacteal_water prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey prelacteal_janamghuti prelacteal_other ebf mixed_milk water juice other_liq milk formula broth bottle cont_bf {
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

cap drop cont_bf_x
gen cont_bf_x = cont_bf*100
version 16: table round [pw = national_wgt] , c(mean cont_bf_x n cont_bf_x) format(%9.1f)

tab broth round [aw = national_wgt], col
tab bottle round [aw = national_wgt], col
sum broth if round==1
sum bottle if round==2
* attempted to insert corrected formatting of result into cell
local Prev =(cond(`r(mean)'==0,"-", string(`r(mean)'*100)))
local Obs =(cond(`r(N)'<=1,"-", string(`r(N)')))
di "`Prev'"
di "`Obs'" 
	

	
	
* Tables for dependent variables, max / min / amplitude / statistical significance of monthly variation

* Assumption, if there is no variation in pooled 5 survey data, then no variation in single survey dataset
* Start Min Max Table 
putexcel set min_max_table, replace
putexcel A1 = "Table 3: Annual prevalence & standard deviation with monthly estimates of minimum, maximum and amplitude of feeding variables adjusted for socio-demographic variation, India Surveys 2005-2021"
putexcel A2 = "Var"
putexcel B2 = "Prevalence"
putexcel C2 = "SD"
putexcel D2 = "Min"
putexcel E2 = "Max"
putexcel F2 = "Amp"
putexcel G2 = "N"

local DepVars = "evbf currently_bf"

local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work i.anc4plus ///
	i.earlyanc i.csection i.inst_birth i.bord c.age_days c.age_days#c.age_days ///
	i.sex i.cat_birth_wt i.diar i.fever i.ari i.round

local RowNum = 2

foreach var of varlist evbf currently_bf {
	di "`var'"
 	local RowNum = `RowNum' +1
	logit `var' `ContVars' [pw = national_wgt] if agemos < 24
	margins 
	* save r(table) to normal matrix
	matrix output = r(table)
	local temp = "`r(predict1_label)'"
	local temp1 = substr("`temp'",4,.)
	local var_name = subinstr("`temp1'",")","",.)
	putexcel A`RowNum' = "`var_name'"
	putexcel B`RowNum' = (output[1,1] * 100), nformat(0.0)  // mean one digit 
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
	putexcel D`RowNum' = `min', nformat(0.0)  		// min
	putexcel E`RowNum' = `max', nformat(0.0) 	  	// max
	putexcel F`RowNum' = `amp', nformat(number_d2)  // amplitude
	putexcel save
	use C:\Temp\Data\iycf_5surveys.dta, clear 
}

* add initiation of breastfeeding variables
local ContVars ib12.birthmonth i.state i.rururb i.wi i.mum_educ i.mum_work i.anc4plus ///
	i.earlyanc i.csection i.inst_birth i.bord c.age_days c.age_days#c.age_days ///
	i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
local RowNum = 5

foreach var of varlist eibf prelacteal_milk prelacteal_sugarwater prelacteal_water prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey prelacteal_janamghuti prelacteal_other { 
	di "`var'"
 	local RowNum = `RowNum' +1
	logit `var' `ContVars' [pw = national_wgt] if agemos < 24
	margins 
	* save r(table) to normal matrix
	matrix output = r(table)
	local temp1 = substr("`r(predict1_label)'",4,.)
	local var_name = subinstr("`temp1'",")","",.)
	putexcel A`RowNum' = "`var_name'"
	putexcel B`RowNum' = (output[1,1] * 100), nformat(0.0)  // mean one digit 
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


local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work  ///
	i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days       ///
	c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
local RowNum = 16

* add cont_bf to end of varlist
replace cont_bf=. if agemos<12 | agemos>23

foreach var of varlist ebf water mixed_milk milk juice other_liq formula broth bottle cont_bf {
	di "`var'"
 	local RowNum = `RowNum' +1
	logit `var' `ContVars' [pw = national_wgt] 
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


local ExportPath "C:/TEMP/Seasonality"
local FileName "IYCF Seasonality.docx"
di "`ExportPath'/`FileName'"

* Create word document with results
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
gen ebf_x = ebf*100 if agemos <6
tab agemos ebf_x 

* Plot adjusted vs unadjusted estimates onto one graph
* Here we use the mean month of data collection for comparison - not perfect for comparison.  That is the point that we are demonstrating. 

* No controls are applied for month of data collection 
logit ebf_x i.round [pw = national_wgt] 
margins round, saving(file1, replace)

* Adjustments are applied using control variables for month of data collection 
local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work  ///
	i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days       ///
	c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round

logit ebf_x `ContVars' [pw = national_wgt] 
* output by round of survey
margins round, saving(file2, replace)

combomarginsplot file1 file2, labels( "Unadjusted" "Adjusted" ) ///
	file1opts(pstyle(p1)) file2opts(pstyle(p2)) lplot1(mfcolor(white)) ///
	title("Exclusive breastfeeding by survey") ytitle("Proportion") ///
	legend(pos(6) ring(0) col(2) region(lstyle(none))) offset
	
* Add combomarginsplot to word file
putdocx begin, font("Calibri") 
putdocx save "`ExportPath'/`FileName'", append


* Giving Water by Round
* selection of correct denominators
gen water_x = water*100 if agemos <6
tab agemos water_x 

logit water_x i.round [pw = national_wgt] 
* here no controls are applied for month of data collection 
margins round, saving(file1, replace)
* output by round of survey

local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work  ///
	i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days       ///
	c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
logit water_x `ContVars' [pw = national_wgt] 

margins round, saving(file2, replace)

combomarginsplot file1 file2, labels( "Unadjusted" "Adjusted" ) ///
	file1opts(pstyle(p1)) file2opts(pstyle(p2)) lplot1(mfcolor(white)) ///
	title("Giving water by survey") ytitle("Proportion") ///
	legend(pos(6) ring(0) col(2) region(lstyle(none))) offset

* Add combomarginsplot to word file1
putdocx begin, font("Calibri") 
putdocx save "`ExportPath'\`FileName'", append

local ExportPath "C:/TEMP/Seasonality"
local FileName "IYCF Seasonality.docx"


* Plot adjusted EBF estimates by month from pooled data in one graph
local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work  ///
	i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days       ///
	c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
	
logit ebf_x `ContVars' [pw = national_wgt] 
margins int_month, saving(file1, replace)
marginsplot, title("Exclusive breastfeeding by month of data collection") ///
	ytitle("Proportion") ylab(0.5(.1)0.7) yscale(range(0.5 0.7)) ///
	name(month_ebf, replace)

	
* Plot adjusted WATER estimates by month from pooled data in one graph
local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work  ///
	i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days       ///
	c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
	
logit water_x `ContVars' [pw = national_wgt] 
margins int_month, saving(file1, replace)
marginsplot, title("Giving water by month of data collection") ///
	ytitle("Proportion") ylab(0.2(.1)0.4) yscale(range(0.2 0.4)) ///
	name(month_water, replace)

* Merge graphs together
graph combine month_ebf month_water , xsize(6.5) ysize(2.7) iscale(.8) name(comb, replace)
graph close month_ebf month_water 
graph export "Feeding variables by month of data collection.png", width(6000) replace

putdocx begin, font("Calibri") 
putdocx save "`ExportPath'\`FileName'", append

* Change the y axis to prevalence
* Change the y label to prevalence


* Exclusive Breastfeeding by Month by Round - ALL SURVEY DATA (adjusted)
* this format is not very interpretable
// local ContVars ib12.int_month i.state i.rururb i.wi i.mum_educ i.mum_work  ///
// 	i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days       ///
// 	c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round
// logit water_x `ContVars' [pw = national_wgt] 
// margins int_month#round,  saving(file1, replace)
// marginsplot, title("Exclusive breastfeeding by month of data collection & round") 
//








* Exclusive breastfeeding	
* Plot the predicted values of the dependent variable for each survey in five graphs for five surveys
* Combomarginsplot - joining five graphs onto one background

* Analysis of interaction between month and round
* 	remove month and round from contvars
local ContVars i.state i.rururb i.wi i.mum_educ i.mum_work  ///
	i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days ///
	c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari 
	
forval x = 1/5 {
	logit ebf_x ib12.int_month##i.round `ContVars' [pw = national_wgt] if round==`x' 
	margins int_month#round, saving(ebf_round`x', replace)
	local RoundValueLabel : value label round
	local GraphLabel: label `RoundValueLabel' `x'
	marginsplot, title("`GraphLabel'") ytitle("Proportion") name(file`x', replace) ///
		ylab(0.2(.1)0.8) yscale(range(0.2 0.8))
}
graph combine file1 file2 file3 file4 file5, xsize(6.5) ysize(2.7) iscale(.8) name(comb, replace)
graph close file1 file2 file3 file4 file5
graph export "EBF by month by survey.png", width(6000) replace

* WATER
* Plot the predicted values of the dependent variable in five graphs for five surveys
* Combomarginsplot - joining five graphs onto one background

local ContVars i.state i.rururb i.wi i.mum_educ i.mum_work  ///
	i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days ///
	c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari 
	
forval x = 1/5 {
	logit water_x ib12.int_month##i.round `ContVars' [pw = national_wgt] if round==`x' 
	margins int_month#round, saving(h20_round`x', replace)
	local RoundValueLabel : value label round
	local GraphLabel: label `RoundValueLabel' `x'
	marginsplot, title("`GraphLabel'")  ytitle("Proportion") name(file`x', replace) ///
		ylab(0.1(.1)0.8) yscale(range(0.1 0.8))
}
graph combine file1 file2 file3 file4 file5, xsize(6.5) ysize(2.7) iscale(.8) name(comb, replace)
graph close file1 file2 file3 file4 file5
graph export "Water by month by survey.png", width(6000) replace

putdocx begin, font("Calibri") 
putdocx save "`ExportPath'\`FileName'", append
	
* For Excel Graph
* Use estimates that assume that all data was collected in April
* see exported data in ebf_roundX


* FOR ANNEXES

putdocx begin, font("Calibri") 

* Giving liquids and continued breastfeeding
* Seasonality of depvar01
local depvar01 mixed_milk milk juice other_liq formula broth bottle cont_bf 
	
* Variables that represent data from date of data collection
local ContVars i.int_month i.state i.rururb i.wi i.mum_educ i.mum_work  ///
	i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days ///
	c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round

foreach var in `depvar01' {
	di `depvar01'
		
	logit `var' `ContVars' [pw = national_wgt] 
	margins int_month
	marginsplot, title(`var' by month of data collection) ytitle("Proportion") 
	graph export `var'.tif, as(tif) replace

	putdocx paragraph, halign(center)
	putdocx image "`var'.tif"
}
local ExportPath "C:/TEMP/Seasonality"
local FileName "IYCF Seasonality.docx"
putdocx save "`ExportPath'/`FileName'", append


putdocx begin, font("Calibri") 

* Ever, current and early initation of breastfeeding
* Seasonality of depvar01
local depvar01 evbf currently_bf eibf prelacteal_milk prelacteal_sugarwater ///
	prelacteal_water prelacteal_gripewater prelacteal_saltwater ///
	prelacteal_formula prelacteal_honey prelacteal_janamghuti prelacteal_other 
* Variables that represent data from date of birth
local ContVars i.birthmonth i.state i.rururb i.wi i.mum_educ i.mum_work  ///
	i.anc4plus i.earlyanc i.csection i.inst_birth i.bord c.age_days ///
	c.age_days#c.age_days i.sex i.cat_birth_wt i.diar i.fever i.ari i.round

foreach var in `depvar01' {
	di `depvar01'
		
	logit `var' `ContVars' [pw = national_wgt] 
	margins int_month
	marginsplot, title(`var' by month of data collection) ytitle("Proportion") 
	graph export `var'.tif, as(tif) replace

	putdocx paragraph, halign(center)
	putdocx image "`var'.tif"
}
local ExportPath "C:/TEMP/Seasonality"
local FileName "IYCF Seasonality.docx"
putdocx save "`ExportPath'/`FileName'", append


* Socio-Economic Status 

* Exclusive Breastfeeding by Month by Socio-Economic Status - ALL SURVEY DATA (adjusted)
* to aid interpretation - convert to SES terciles
logit ebf ib12.int_month##i.wi i.state i.rururb i.mum_educ c.age_days c.age_days2 i.sex i.cat_birth_wt i.diar i.fever i.ari [pw = national_wgt] 
margins int_month#wi,  saving(file1, replace)
marginsplot, title("Exclusive breastfeeding by month of data collection & SES") 
	
* Region

* Rural Urban

* Male vs Female

* END

