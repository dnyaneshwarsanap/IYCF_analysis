* IYCF REPORT 
* CNNS
* Dec 2021
* RJ

* Add dependencies
* this code uses IYCF vars from CNNS data which are created in in make vars do file

* undercase variables come from datasets
* Camelcase vars are created in the code - used in code and dropped

* path for saving reports / graphs
*cd "C:/IYCF"
cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"

* data
//use "C:\Temp\iycf_cnns.dta", clear 
 use "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged\iycf_cnns.dta", clear

* make IYCF var - Median Duration of Ex. BF  ----> this var is now created in all 4 make IYCF vars do files


* All weights, should be coded in mk_vars do file
* National, Regional, State and District

*gen state_weight = iweight_s                                            // already included in make vars do files as - state_wgt
// gen nat_weight = iw_s_pool                                              // already included in make vars do files as - national_wgt

/*
List of tables for Survey Report
1. Breastfeeding indicators 
 1.1. Ever breastfed (EvBF) 
 1.2. Early initiation of breastfeeding (EIBF) 
 1.3. Exclusively breastfed for the first two days after birth (EBF2D) 
 1.4. Exclusive breastfeeding under six months (EBF) 
 1.5. Mixed milk feeding under six months (MixMF) 
 1.6. Continued breastfeeding 12–23 months (CBF) 

2. Complementary feeding indicators 
 2.1. Introduction of solid, semi-solid or soft foods 6–8 months (ISSSF) 
 2.2. Minimum dietary diversity 6–23 months (MDD) 
 2.3. Minimum meal frequency 6–23 months (mmf_all)  
 2.4. Minimum milk feeding frequency for non-breastfed children 6–23 months (MMFF) 
 2.5. Minimum acceptable diet 6–23 months (MAD) 
 2.6. Egg and/or flesh food consumption 6–23 months (EFF) 
 2.7. Sweet beverage consumption 6–23 months (SwB) 
 2.8. Unhealthy food consumption 6–23 months (UFC) 
 2.9. Zero vegetable or fruit consumption 6–23 months (ZVF) 

3. Other Indicators 
 3.1. Bottle feeding 0–23 months (BoF) 
 3.2. Infant feeding area graphs (AG) 
*/



*Socio-Demographic Indicators
* Caste
* Mothers_education
* Wealth Index
* Sex
* rururb
* Low_birth_weight (lbw)
* anc4plus
* csection
* earlyanc



* when using RowVar as list for looping, the values have to fall in order from 1 to x
* when state is correctly labelled in all datasets, this should not be a problem. 

* to set value label of state from 1 to x
gen state_old = state
decode state, gen(stateString)
tab stateString
cap drop state
// Under certain circumstances, -encode- will number  the numeric version of a string variable starting where it left off at the last encode
// to stop this behavior, drop the labels and start again
cap label drop sector                                          //what is sector?
cap lab drop state
encode stateString, gen(state)
tab state, m 



*https://www.statalist.org/forums/forum/general-stata-discussion/general/1538255-creating-descriptive-stats-table-using-putdocx

putdocx clear
putdocx begin 


* TITLE PAGE
putdocx clear
putdocx begin, font("Calibri") 
putdocx paragraph, style(Title) halign(center) spacing(line,16 pt)
putdocx text ("IYCF REPORT")
putdocx paragraph, style(Title) halign(center) spacing(line,16 pt)
putdocx text ("Analysis by State and Socio-Demographic Indicators")
putdocx paragraph, style(Heading2) halign(center)
putdocx text ("Date of Data Collection Feb 2016 to August 2018 ")

putdocx pagebreak

// 1. Breastfeeding indicators 
// 1.1. Ever breastfed (EvBF) 
// 1.2. Early initiation of breastfeeding (EIBF) 
// 1.3. Exclusively breastfed for the first two days after birth (EBF2D) 
// 1.4. Exclusive breastfeeding under six months (EBF) 
// 1.5. Mixed milk feeding under six months (MixMF) 
// 1.6. Continued breastfeeding 12–23 months (CBF) 



putdocx paragraph, style(Title) halign(center) spacing(line,16 pt)
putdocx text ("1. Breastfeeding Indicators")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("1.1. Ever breastfed (EvBF)")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("1.2. Early initiation of breastfeeding (EIBF)")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("1.3. Exclusively breastfed for the first two days after birth (EBF2D)")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("1.4. Exclusive breastfeeding under six months (EBF)")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("1.5. Mixed milk feeding under six months (MixMF)")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("1.6. Continued breastfeeding 12–23 months (CBF)")
putdocx pagebreak



// 1.1. Ever breastfed (EvBF) 

* Define variables for table
local TableName = "Ever Breastfed (EvBF)"
local TableNum = "table1"
local var1 = "evbf" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.1: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, replace 
*------------------------------------------------------------------------------------*
//1.1.(a) EVBF variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Ever breastfed by caste"
local TableNum = "table2"
local Var = "evbf" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N EvBF"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//1.1 (b) Ever breastfed indicator w.r.t mothers education
*------------------------------------------------------------------------------------
/*
putdocx begin, font("Calibri", 9)

* EVBF by mumeduc 
local TableName = "Ever breastfed by mother's schooling"
local TableNum = "table3"
local Var = "evbf" 
local RowVar = "state"
local ColVar = "mum_educ"

tab mum_educ,m
/*
   Maternal Education |      Freq.     Percent        Cum.
----------------------+-----------------------------------
         No Education |      7,361       19.34       19.34
    5 years completed |      2,037        5.35       24.69
  5-9 years completed |     12,327       32.39       57.08
10-11 years completed |      5,377       14.13       71.21
  12+ years completed |     10,924       28.70       99.91
                    . |         34        0.09      100.00
----------------------+-----------------------------------
                Total |     38,060      100.00
*/
**As 34 missingvalues are there


* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',8), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1(b): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Education"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years completed"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years"), bold halign(center)
putdocx table `TableNum'(2,7) = ("missing"), bold halign(center)
putdocx table `TableNum'(2,8) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local ColNum = `col'+3
			local Result =cond(r(N)>=50,r(mean)*100,.)
			
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*/
*------------------------------------------------------------------------------------*
// 1.1 (c) Ever breastfed indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* EVBF by mumeduc 
local TableName = "Ever breastfed by wealth index"
local TableNum = "table4"
local Var = "evbf" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.1.(d) Ever breastfed indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* EVBF by mumeduc 
local TableName = "Ever breastfed by sex of child"
local TableNum = "table4"
local Var = "evbf" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 1.1 (e) Ever breastfed indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* EVBF by mumeduc 
local TableName = "Ever breastfed by residence (urban/rural)"
local TableNum = "table4"
local Var = "evbf" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.1 (f) Ever breastfed indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Ever breastfed by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "evbf" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 1.1 (g) Ever breastfed indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* EVBF by ANC4Plus 
local TableName = "Ever breastfed by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "evbf" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 1.1 (h) Ever breastfed indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* EVBF by mumeduc 
local TableName = "Ever breastfed by csection"
local TableNum = "table4"
local Var = "evbf" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

****************************************************************************************************************************
****************************************************************************************************************************

*1.2. Early initiation of breastfeeding (EIBF) 				**
**************************************************************
putdocx begin, font("Calibri", 9)

* Define variables for table
local TableName = "Early initiation of breastfeeding (EIBF)"
local TableNum = "table1"
local var1 = "eibf" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.1: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
*------------------------------------------------------------------------------------*
//1.2(a) Early initiation (EIBF) variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Early initiation (EIBF) by caste"
local TableNum = "table2"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.2 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N eibf"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//1.2 (b) Early initiation (EIBF) indicator w.r.t mothers education
*------------------------------------------------------------------------------------
/*
putdocx begin, font("Calibri", 9)

* eibf by mumeduc 
local TableName = "Early initiation (EIBF) by mother's schooling"
local TableNum = "table3"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "mum_educ"

tab mum_educ,m
/*
   Maternal Education |      Freq.     Percent        Cum.
----------------------+-----------------------------------
         No Education |      7,361       19.34       19.34
    5 years completed |      2,037        5.35       24.69
  5-9 years completed |     12,327       32.39       57.08
10-11 years completed |      5,377       14.13       71.21
  12+ years completed |     10,924       28.70       99.91
                    . |         34        0.09      100.00
----------------------+-----------------------------------
                Total |     38,060      100.00
*/
**As 34 missingvalues are there


* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',8), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.2(b): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Education"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years completed"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years"), bold halign(center)
putdocx table `TableNum'(2,7) = ("missing"), bold halign(center)
putdocx table `TableNum'(2,8) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local ColNum = `col'+3
			local Result =cond(r(N)>=50,r(mean)*100,.)
			
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*/
*------------------------------------------------------------------------------------*
// 1.2 (c) Early initiation (EIBF) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* eibf by mumeduc 
local TableName = "Early initiation (EIBF) by wealth index"
local TableNum = "table4"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.2 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.2.(d) Early initiation (EIBF) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* eibf by mumeduc 
local TableName = "Early initiation (EIBF) by sex of child"
local TableNum = "table4"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.2 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 1.2 (e) Early initiation (EIBF) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* eibf by mumeduc 
local TableName = "Early initiation (EIBF) by residence (urban/rural)"
local TableNum = "table4"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.2 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.2 (f) Early initiation (EIBF) indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Early initiation (EIBF) by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.2 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 1.2 (g) Early initiation (EIBF) indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* eibf by ANC4Plus 
local TableName = "Early initiation (EIBF) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.2 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 1.2 (h) Early initiation (EIBF) indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* eibf by mumeduc 
local TableName = "Early initiation (EIBF) by csection"
local TableNum = "table4"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.2 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append







****************************************************************************************************************************
****************************************************************************************************************************

*1.3. Exclusively breastfed for the first two days after birth (EBF2D) 				**
**************************************************************
putdocx begin, font("Calibri", 9)

* Define variables for table
local TableName = "ExBF for first two days (EBF2D)"
local TableNum = "table1"
local var1 = "ebf2d" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.3: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append


*Tables of ebf2d is not significant w.r.t states 
/*
*------------------------------------------------------------------------------------*
//1.3(a) Exclusively breastfed for the first two days after birth (EBF2D)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "ExBF for first two days (EBF2D) by caste"
local TableNum = "table2"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.2 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N ebf2d"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//1.3 (b) ExBF for first two days (EBF2D) indicator w.r.t mothers education
*------------------------------------------------------------------------------------
/*
putdocx begin, font("Calibri", 9)

* ebf2d by mumeduc 
local TableName = "ExBF for first two days (EBF2D) by mother's schooling"
local TableNum = "table3"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "mum_educ"

tab mum_educ,m
/*
   Maternal Education |      Freq.     Percent        Cum.
----------------------+-----------------------------------
         No Education |      7,361       19.34       19.34
    5 years completed |      2,037        5.35       24.69
  5-9 years completed |     12,327       32.39       57.08
10-11 years completed |      5,377       14.13       71.21
  12+ years completed |     10,924       28.70       99.91
                    . |         34        0.09      100.00
----------------------+-----------------------------------
                Total |     38,060      100.00
*/
**As 34 missingvalues are there


* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',8), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.3(b): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Education"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years completed"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years"), bold halign(center)
putdocx table `TableNum'(2,7) = ("missing"), bold halign(center)
putdocx table `TableNum'(2,8) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local ColNum = `col'+3
			local Result =cond(r(N)>=50,r(mean)*100,.)
			
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*/
*------------------------------------------------------------------------------------*
// 1.3 (c) ExBF for first two days (EBF2D) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf2d by mumeduc 
local TableName = "ExBF for first two days (EBF2D) by wealth index"
local TableNum = "table4"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.3 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.3(d) ExBF for first two days (EBF2D) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf2d by mumeduc 
local TableName = "ExBF for first two days (EBF2D) by sex of child"
local TableNum = "table4"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.3 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 1.3 (e) ExBF for first two days (EBF2D) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf2d by mumeduc 
local TableName = "ExBF for first two days (EBF2D) by residence (urban/rural)"
local TableNum = "table4"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.3 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.3 (f) ExBF for first two days (EBF2D) indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "ExBF for first two days (EBF2D) by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.3 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.3 (g) ExBF for first two days (EBF2D) indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf2d by ANC4Plus 
local TableName = "ExBF for first two days (EBF2D) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.3 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 1.3 (h) ExBF for first two days (EBF2D) indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf2d by mumeduc 
local TableName = "ExBF for first two days (EBF2D) by csection"
local TableNum = "table4"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.3 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*/





****************************************************************************************************************************
****************************************************************************************************************************

*1.4. Exclusive breastfeeding under six months (EBF) 		**
**************************************************************
putdocx begin, font("Calibri", 9)
* Define variables for table
local TableName = "ExBF under 6 months (EBF)"
local TableNum = "table1"
local var1 = "ebf" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.4: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
*------------------------------------------------------------------------------------*
//1.4(a) ExBF under 6 months (EBF) variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "ExBF under 6 months (EBF) by caste"
local TableNum = "table2"
local Var = "ebf" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N ebf"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//1.4 (b) ExBF under 6 months (EBF) indicator w.r.t mothers education
*------------------------------------------------------------------------------------
/*
putdocx begin, font("Calibri", 9)

* ebf by mumeduc 
local TableName = "ExBF under 6 months (EBF) by mother's schooling"
local TableNum = "table3"
local Var = "ebf" 
local RowVar = "state"
local ColVar = "mum_educ"

tab mum_educ,m
/*
   Maternal Education |      Freq.     Percent        Cum.
----------------------+-----------------------------------
         No Education |      7,361       19.34       19.34
    5 years completed |      2,037        5.35       24.69
  5-9 years completed |     12,327       32.39       57.08
10-11 years completed |      5,377       14.13       71.21
  12+ years completed |     10,924       28.70       99.91
                    . |         34        0.09      100.00
----------------------+-----------------------------------
                Total |     38,060      100.00
*/
**As 34 missingvalues are there


* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',8), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4(b): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Education"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years completed"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years"), bold halign(center)
putdocx table `TableNum'(2,7) = ("missing"), bold halign(center)
putdocx table `TableNum'(2,8) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local ColNum = `col'+3
			local Result =cond(r(N)>=50,r(mean)*100,.)
			
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*/
*------------------------------------------------------------------------------------*
// 1.4 (c) ExBF under 6 months (EBF) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf by mumeduc 
local TableName = "ExBF under 6 months (EBF) by wealth index"
local TableNum = "table4"
local Var = "ebf" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.4(d) ExBF under 6 months (EBF) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf by mumeduc 
local TableName = "ExBF under 6 months (EBF) by sex of child"
local TableNum = "table4"
local Var = "ebf" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 1.4 (e) ExBF under 6 months (EBF) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf by mumeduc 
local TableName = "ExBF under 6 months (EBF) by residence (urban/rural)"
local TableNum = "table4"
local Var = "ebf" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.4 (f) ExBF under 6 months (EBF) indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "ExBF under 6 months (EBF) by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "ebf" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 1.4 (g) ExBF under 6 months (EBF) indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "ExBF under 6 months (EBF) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "ebf" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 1.4 (h) ExBF under 6 months (EBF) indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf by mumeduc 
local TableName = "ExBF under 6 months (EBF) by csection"
local TableNum = "table4"
local Var = "ebf" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append







****************************************************************************************************************************
****************************************************************************************************************************

*1.5. Mixed milk feeding under six months (MixMF) 		**
**************************************************************
putdocx begin, font("Calibri", 9)
* Define variables for table
local TableName = "Mixed_milk feeding under 6 months (MixMF)"
local TableNum = "table1"
local var1 = "mixed_milk" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.5: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
*------------------------------------------------------------------------------------*
//1.5(a) Mixed_milk feeding under 6 months (MixMF) variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Mixed_milk feeding under 6 months (MixMF) by caste"
local TableNum = "table2"
local Var = "mixed_milk" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N mixed_milk"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//1.5 (b) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t mothers education
*------------------------------------------------------------------------------------
/*
putdocx begin, font("Calibri", 9)

* mixed_milk by mumeduc 
local TableName = "Mixed_milk feeding under 6 months (MixMF) by mother's schooling"
local TableNum = "table3"
local Var = "mixed_milk" 
local RowVar = "state"
local ColVar = "mum_educ"

tab mum_educ,m
/*
   Maternal Education |      Freq.     Percent        Cum.
----------------------+-----------------------------------
         No Education |      7,361       19.34       19.34
    5 years completed |      2,037        5.35       24.69
  5-9 years completed |     12,327       32.39       57.08
10-11 years completed |      5,377       14.13       71.21
  12+ years completed |     10,924       28.70       99.91
                    . |         34        0.09      100.00
----------------------+-----------------------------------
                Total |     38,060      100.00
*/
**As 34 missingvalues are there


* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',8), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5(b): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Education"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years completed"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years"), bold halign(center)
putdocx table `TableNum'(2,7) = ("missing"), bold halign(center)
putdocx table `TableNum'(2,8) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local ColNum = `col'+3
			local Result =cond(r(N)>=50,r(mean)*100,.)
			
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*/
*------------------------------------------------------------------------------------*
// 1.5 (c) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* mixed_milk by mumeduc 
local TableName = "Mixed_milk feeding under 6 months (MixMF)"
local TableNum = "table4"
local Var = "mixed_milk" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.5(d) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* mixed_milk by mumeduc 
local TableName = "Mixed_milk feeding under 6 months (MixMF) by sex of child"
local TableNum = "table4"
local Var = "mixed_milk" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 1.5 (e) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* mixed_milk by mumeduc 
local TableName = "Mixed_milk feeding under 6 months (MixMF) by residence (urban/rural)"
local TableNum = "table4"
local Var = "mixed_milk" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.5 (f) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Mixed_milk feeding under 6 months (MixMF) by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "mixed_milk" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 1.5 (g) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* mixed_milk by ANC4Plus 
local TableName = "Mixed_milk feeding under 6 months (MixMF) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "mixed_milk" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 1.5 (h) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* mixed_milk by mumeduc 
local TableName = "Mixed_milk feeding under 6 months (MixMF) by csection"
local TableNum = "table4"
local Var = "mixed_milk" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append







****************************************************************************************************************************
****************************************************************************************************************************

*1.6.  Continued breastfeeding 12–23 months (CBF) 		**
**************************************************************
putdocx begin, font("Calibri", 9)
* Define variables for table
local TableName = " Continued_bf 12–23 months (CBF) "
local TableNum = "table1"
local var1 = "cont_bf_12_23" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.6: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
*------------------------------------------------------------------------------------*
//1.6(a) Continued_bf 12–23 months (CBF) variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Continued_bf 12–23 months (CBF) by caste"
local TableNum = "table2"
local Var = "cont_bf_12_23" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N cont_bf_12_23"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//1.6 (b) Continued_bf 12–23 months (CBF) indicator w.r.t mothers education
*------------------------------------------------------------------------------------
/*
putdocx begin, font("Calibri", 9)

* cont_bf_12_23 by mumeduc 
local TableName = "Continued_bf 12–23 months (CBF) by mother's schooling"
local TableNum = "table3"
local Var = "cont_bf_12_23" 
local RowVar = "state"
local ColVar = "mum_educ"

tab mum_educ,m
/*
   Maternal Education |      Freq.     Percent        Cum.
----------------------+-----------------------------------
         No Education |      7,361       19.34       19.34
    5 years completed |      2,037        5.35       24.69
  5-9 years completed |     12,327       32.39       57.08
10-11 years completed |      5,377       14.13       71.21
  12+ years completed |     10,924       28.70       99.91
                    . |         34        0.09      100.00
----------------------+-----------------------------------
                Total |     38,060      100.00
*/
**As 34 missingvalues are there


* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',8), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6(b): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Education"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years completed"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years"), bold halign(center)
putdocx table `TableNum'(2,7) = ("missing"), bold halign(center)
putdocx table `TableNum'(2,8) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local ColNum = `col'+3
			local Result =cond(r(N)>=50,r(mean)*100,.)
			
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*/
*------------------------------------------------------------------------------------*
// 1.6 (c) Continued_bf 12–23 months (CBF) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* cont_bf_12_23 by mumeduc 
local TableName = "Continued_bf 12–23 months (CBF)"
local TableNum = "table4"
local Var = "cont_bf_12_23" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.6(d) Continued_bf 12–23 months (CBF) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* cont_bf_12_23 by mumeduc 
local TableName = "Continued_bf 12–23 months (CBF) by sex of child"
local TableNum = "table4"
local Var = "cont_bf_12_23" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 1.6 (e) Continued_bf 12–23 months (CBF) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* cont_bf_12_23 by mumeduc 
local TableName = "Continued_bf 12–23 months (CBF) by residence (urban/rural)"
local TableNum = "table4"
local Var = "cont_bf_12_23" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 1.6 (f) Continued_bf 12–23 months (CBF) indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Continued_bf 12–23 months (CBF) by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "cont_bf_12_23" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 1.6 (g) Continued_bf 12–23 months (CBF) indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* cont_bf_12_23 by ANC4Plus 
local TableName = "Continued_bf 12–23 months (CBF) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "cont_bf_12_23" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 1.6 (h) Continued_bf 12–23 months (CBF) indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* cont_bf_12_23 by mumeduc 
local TableName = "Continued_bf 12–23 months (CBF) by csection"
local TableNum = "table4"
local Var = "cont_bf_12_23" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

**********************************************************************************************************
putdocx begin, font("Calibri", 9)
putdocx pagebreak
putdocx paragraph, style(Title) halign(center) spacing(line,16 pt)
putdocx text ("2. Complementary Feeding Indicators")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("2.1 Introduction of solid, semi-solid or soft foods 6–8 months (ISSSF)")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("2.2. Minimum dietary diversity 6–23 months (MDD)")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("2.3. Minimum meal frequency 6–23 months (MMF) ")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("2.4. Minimum milk feeding frequency for non-breastfed children 6–23 months (MMFF) ")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("2.5. Minimum acceptable diet 6–23 months (MAD)")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("2.6. Egg and/or flesh food consumption 6–23 months (EFF)")
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text (" 2.9. Zero vegetable or fruit consumption 6–23 months (ZVF)")
putdocx pagebreak


/*
putdocx begin, font("Calibri", 9)
putdocx paragraph, style(Title) halign(center) spacing(line,16 pt)
putdocx text ("1. Breastfeeding Indicators")
*/

*--------------------------------------------------------------------------------*
*--------------------------------------------------------------------------------*
*                         2  Complementary feeding indicators                    *
*--------------------------------------------------------------------------------*
*--------------------------------------------------------------------------------*

**************************************************************************
* 2.1 Introduction of solid, semi-solid or soft foods 6–8 months (ISSSF) * 
**************************************************************************
* Define variables for table
local TableName = "Introduction of solid, semi-solid or soft foods 6–8 months (ISSSF)"
local TableNum = "table1"
local var1 = "intro_comp" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.1: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
*------------------------------------------------------------------------------------*
//2.1.(a) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) by caste"
local TableNum = "table2"
local Var = "intro_comp" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N intro_comp"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//2.1 (b) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) indicator w.r.t mothers education
*------------------------------------------------------------------------------------




*------------------------------------------------------------------------------------*
// 2.1 (c) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) by wealth index"
local TableNum = "table4"
local Var = "intro_comp" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.1.(d) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) by sex of child"
local TableNum = "table4"
local Var = "intro_comp" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 2.1 (e) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) by residence (urban/rural)"
local TableNum = "table4"
local Var = "intro_comp" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.1 (f) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)



local TableName = "Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "intro_comp" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.1 (g) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF)by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "intro_comp" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.1 (h) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) by csection"
local TableNum = "table4"
local Var = "intro_comp" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append





**************************************************************************
* 2.2 Minimum dietary diversity 6–23 months (MDD)                        * 
**************************************************************************
putdocx begin, font("Calibri", 9)

* Define variables for table
local TableName = "Minimum dietary diversity 6–23 months (MDD) "
local TableNum = "table1"
local var1 = "mdd" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.2: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
*------------------------------------------------------------------------------------*
//2.2.(a) Minimum dietary diversity 6–23 months (MDD)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Minimum dietary diversity 6–23 months (MDD) by caste"
local TableNum = "table2"
local Var = "mdd" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N mdd"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//2.2 (b) Minimum dietary diversity 6–23 months (MDD) indicator w.r.t mothers education
*------------------------------------------------------------------------------------




*------------------------------------------------------------------------------------*
// 2.2 (c) Minimum dietary diversity 6–23 months (MDD) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum dietary diversity 6–23 months (MDD) by wealth index"
local TableNum = "table4"
local Var = "mdd" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.2.(d) Minimum dietary diversity 6–23 months (MDD) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum dietary diversity 6–23 months (MDD) by sex of child"
local TableNum = "table4"
local Var = "mdd" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 2.2 (e) Minimum dietary diversity 6–23 months (MDD) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Minimum dietary diversity 6–23 months (MDD) by residence (urban/rural)"
local TableNum = "table4"
local Var = "mdd" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.2 (f) Minimum dietary diversity 6–23 months (MDD) n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)



local TableName = "Minimum dietary diversity 6–23 months (MDD) by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "mdd" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.2 (g) Minimum dietary diversity 6–23 months (MDD) w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum dietary diversity 6–23 months (MDD)by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "mdd" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.2 (h) Minimum dietary diversity 6–23 months (MDD) indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Minimum dietary diversity 6–23 months (MDD) by csection"
local TableNum = "table4"
local Var = "mdd" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append






**************************************************************************
* 2.3 Minimum meal frequency 6–23 months (mmf_all)                        * 
**************************************************************************
putdocx begin, font("Calibri", 9)

* Define variables for table
local TableName = "Minimum meal frequency 6–23 months (mmf_all) "
local TableNum = "table1"
local var1 = "mmf_all" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.3: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
*------------------------------------------------------------------------------------*
//2.3.(a) Minimum meal frequency 6–23 months (mmf_all)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Minimum meal frequency 6–23 months (mmf_all) by caste"
local TableNum = "table2"
local Var = "mmf_all" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N mmf_all"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//2.3 (b) Minimum meal frequency 6–23 months (mmf_all) indicator w.r.t mothers education
*------------------------------------------------------------------------------------




*------------------------------------------------------------------------------------*
// 2.3 (c) Minimum meal frequency 6–23 months (mmf_all) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum meal frequency 6–23 months (mmf_all) by wealth index"
local TableNum = "table4"
local Var = "mmf_all" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.3.(d) Minimum meal frequency 6–23 months (mmf_all) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum meal frequency 6–23 months (mmf_all) by sex of child"
local TableNum = "table4"
local Var = "mmf_all" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 2.3 (e) Minimum meal frequency 6–23 months (mmf_all) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Minimum meal frequency 6–23 months (mmf_all) by residence (urban/rural)"
local TableNum = "table4"
local Var = "mmf_all" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.3 (f) Minimum meal frequency 6–23 months (mmf_all) n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)



local TableName = "Minimum meal frequency 6–23 months (mmf_all) by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "mmf_all" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.3 (g) Minimum meal frequency 6–23 months (mmf_all) w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum meal frequency 6–23 months (mmf_all)by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "mmf_all" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.3 (h) Minimum meal frequency 6–23 months (mmf_all) indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Minimum meal frequency 6–23 months (mmf_all) by csection"
local TableNum = "table4"
local Var = "mmf_all" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append




************************************************************************************
* 2.4 Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF)  * 
************************************************************************************
putdocx begin, font("Calibri", 9)

* Define variables for table
local TableName = "Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) "
local TableNum = "table1"
local var1 = "min_milk_freq_nbf" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.3: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
*------------------------------------------------------------------------------------*
//2.4.(a) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) by caste"
local TableNum = "table2"
local Var = "min_milk_freq_nbf" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N min_milk_freq_nbf"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//2.4(b) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) indicator w.r.t mothers education
*------------------------------------------------------------------------------------




*------------------------------------------------------------------------------------*
// 2.4 (c) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) by wealth index"
local TableNum = "table4"
local Var = "min_milk_freq_nbf" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.4 (d) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) by sex of child"
local TableNum = "table4"
local Var = "min_milk_freq_nbf" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 2.4 (e) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) by residence (urban/rural)"
local TableNum = "table4"
local Var = "min_milk_freq_nbf" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.4 (f) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)



local TableName = "Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "min_milk_freq_nbf" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.4 (g) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF)by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "min_milk_freq_nbf" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.4 (h) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) by csection"
local TableNum = "table4"
local Var = "min_milk_freq_nbf" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append







************************************************************************************
* 2.5 Minimum acceptable diet 6–23 months (MAD)  * 
************************************************************************************
putdocx begin, font("Calibri", 9)

* Define variables for table
local TableName = "Minimum acceptable diet 6–23 months (MAD) "
local TableNum = "table1"
local var1 = "mad_all" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.5: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
*------------------------------------------------------------------------------------*
//2.5.(a) Minimum acceptable diet 6–23 months (MAD)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Minimum acceptable diet 6–23 months (MAD) by caste"
local TableNum = "table2"
local Var = "mad_all" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N mad_all"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//2.5 (b) Minimum acceptable diet 6–23 months (MAD) indicator w.r.t mothers education
*------------------------------------------------------------------------------------




*------------------------------------------------------------------------------------*
// 2.5 (c) Minimum acceptable diet 6–23 months (MAD) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum acceptable diet 6–23 months (MAD) by wealth index"
local TableNum = "table4"
local Var = "mad_all" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.5 (d) Minimum acceptable diet 6–23 months (MAD) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum acceptable diet 6–23 months (MAD) by sex of child"
local TableNum = "table4"
local Var = "mad_all" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 2.5 (e) Minimum acceptable diet 6–23 months (MAD) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Minimum acceptable diet 6–23 months (MAD) by residence (urban/rural)"
local TableNum = "table4"
local Var = "mad_all" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.5 (f) Minimum acceptable diet 6–23 months (MAD) n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)



local TableName = "Minimum acceptable diet 6–23 months (MAD) by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "mad_all" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.5 (g) Minimum acceptable diet 6–23 months (MAD) w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum acceptable diet 6–23 months (MAD)by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "mad_all" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.5 (h) Minimum acceptable diet 6–23 months (MAD) indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Minimum acceptable diet 6–23 months (MAD) by csection"
local TableNum = "table4"
local Var = "mad_all" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append







************************************************************************************
* 2.6 Egg and/or flesh food consumption 6–23 months (EFF)                          * 
************************************************************************************
putdocx begin, font("Calibri", 9)

* Define variables for table
local TableName = "Egg and/or flesh food consumption 6–23 months (EFF)  "
local TableNum = "table1"
local var1 = "egg_meat" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.6: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
*------------------------------------------------------------------------------------*
//2.6.(a) Egg and/or flesh food consumption 6–23 months (EFF)   variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Egg and/or flesh food consumption 6–23 months (EFF)  by caste"
local TableNum = "table2"
local Var = "egg_meat" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N egg_meat"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//2.6 (b) Egg and/or flesh food consumption 6–23 months (EFF)  indicator w.r.t mothers education
*------------------------------------------------------------------------------------




*------------------------------------------------------------------------------------*
// 2.6 (c) Egg and/or flesh food consumption 6–23 months (EFF)  indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Egg and/or flesh food consumption 6–23 months (EFF)  by wealth index"
local TableNum = "table4"
local Var = "egg_meat" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.6 (d) Egg and/or flesh food consumption 6–23 months (EFF)  indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Egg and/or flesh food consumption 6–23 months (EFF)  by sex of child"
local TableNum = "table4"
local Var = "egg_meat" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 2.6 (e) Egg and/or flesh food consumption 6–23 months (EFF)  indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Egg and/or flesh food consumption 6–23 months (EFF)  by residence (urban/rural)"
local TableNum = "table4"
local Var = "egg_meat" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.6 (f) Egg and/or flesh food consumption 6–23 months (EFF)  n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)



local TableName = "Egg and/or flesh food consumption 6–23 months (EFF)  by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "egg_meat" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.6 (g) Egg and/or flesh food consumption 6–23 months (EFF)  w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Egg and/or flesh food consumption 6–23 months (EFF) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "egg_meat" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.6 (h) Egg and/or flesh food consumption 6–23 months (EFF)  indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Egg and/or flesh food consumption 6–23 months (EFF)  by csection"
local TableNum = "table4"
local Var = "egg_meat" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append




************************************************************************************
* 2.7  Sweet beverage consumption 6–23 months (SwB)                                * 
************************************************************************************
** Variable is not available for this indicator (Survey Data insufficient)

************************************************************************************
* 2.8 Unhealthy food consumption 6–23 months (UFC) -                         * 
************************************************************************************
** Variable is not available for this indicator (Survey Data insufficient)

putdocx begin, font("Calibri", 9)
putdocx pagebreak
putdocx paragraph, style(Heading2) halign(center) spacing(line,16 pt)
putdocx text ("2.7 Sweet beverage consumption 6–23 months (SwB): Variable is not available for this indicator (Survey Data insufficient)")
putdocx text (" 2.8 Unhealthy food consumption 6–23 months (UFC): Variable is not available for this indicator (Survey Data insufficient)")
putdocx pagebreak



************************************************************************************
* 2.9 Zero vegetable or fruit consumption 6–23 months (ZVF)                      * 
************************************************************************************


* Define variables for table
local TableName = "Zero vegetable or fruit consumption 6–23 months (ZVF)   "
local TableNum = "table1"
local var1 = "zero_fv" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.9: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
*------------------------------------------------------------------------------------*
//2.9.(a) Zero vegetable or fruit consumption 6–23 months (ZVF)    variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Zero vegetable or fruit consumption 6–23 months (ZVF)   by caste"
local TableNum = "table2"
local Var = "zero_fv" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (a): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N zero_fv"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*------------------------------------------------------------------------------------
//2.9 (b) Zero vegetable or fruit consumption 6–23 months (ZVF)   indicator w.r.t mothers education
*------------------------------------------------------------------------------------




*------------------------------------------------------------------------------------*
// 2.9 (c) Zero vegetable or fruit consumption 6–23 months (ZVF)   indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Zero vegetable or fruit consumption 6–23 months (ZVF)   by wealth index"
local TableNum = "table4"
local Var = "zero_fv" 
local RowVar = "state"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (c): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Poorest"), bold 
putdocx table `TableNum'(2,3) = ("Poor"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Middle"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Rich"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Richest"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.9 (d) Zero vegetable or fruit consumption 6–23 months (ZVF)   indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Zero vegetable or fruit consumption 6–23 months (ZVF)   by sex of child"
local TableNum = "table4"
local Var = "zero_fv" 
local RowVar = "state"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (d): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("boy"), bold 
putdocx table `TableNum'(2,3) = ("girl"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*------------------------------------------------------------------------------------*
// 2.9 (e) Zero vegetable or fruit consumption 6–23 months (ZVF)   indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Zero vegetable or fruit consumption 6–23 months (ZVF)   by residence (urban/rural)"
local TableNum = "table4"
local Var = "zero_fv" 
local RowVar = "state"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (e): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("urban"), bold 
putdocx table `TableNum'(2,3) = ("rural"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


*------------------------------------------------------------------------------------*
// 2.9 (f) Zero vegetable or fruit consumption 6–23 months (ZVF)   n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)



local TableName = "Zero vegetable or fruit consumption 6–23 months (ZVF)   by early anc visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "zero_fv" 
local RowVar = "state"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (f): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("no"), bold halign(center)
putdocx table `TableNum'(2,3) = ("yes"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N (sample size)"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' 
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.9 (g) Zero vegetable or fruit consumption 6–23 months (ZVF)   w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Zero vegetable or fruit consumption 6–23 months (ZVF)  by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "zero_fv" 
local RowVar = "state"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (g): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No 4+ANC check-ups"), bold 
putdocx table `TableNum'(2,3) = ("Yes 4+ANC check-ups"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



*------------------------------------------------------------------------------------*
// 2.9 (h) Zero vegetable or fruit consumption 6–23 months (ZVF)   indicator w.r.t csection birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Zero vegetable or fruit consumption 6–23 months (ZVF)   by csection"
local TableNum = "table4"
local Var = "zero_fv" 
local RowVar = "state"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (h): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Not C-section"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  //if `col'==4
		local ColNum = `col'+3
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append



**********************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************



*Variable for breastfeeding area graph

cap drop diet
gen diet=9
replace diet=1 if currently_bf==1 
replace diet=2 if currently_bf==1 & water==1 
replace diet=3 if currently_bf==1 & other_liq==1 
replace diet=3 if currently_bf==1 & juice==1 
replace diet=3 if currently_bf==1 & broth==1 
// replace diet=3 if currently_bf==1 & teas==1 
replace diet=4 if currently_bf==1 & formula==1 
replace diet=4 if currently_bf==1 & milk==1 
replace diet=5 if currently_bf==1 & any_solid_semi_food==1 
replace diet=6 if currently_bf==0 

la def diet 1 "exclusively breastfed" ///
			2 "plain water & breastmilk" ///
			3 "non-milk liquids & breastmilk" ///
			4 "other milks/formula & breastmilk" ///
			5 "comp foods & breastmilk" ///
			6 "not breastfed" ///
			9 "missing"

tab diet, m 

* No cases of bf and form? 
tab diet formula, m 


cap drop d1 d2 d3 d4 d5 d6
// tabulate diet, generate(d) - cannot use this line because sometimes there are missing categories
gen d1 = cond(diet==1, 100, 0)
gen d2 = cond(diet==2, 100, 0)
gen d3 = cond(diet==3, 100, 0)
gen d4 = cond(diet==4, 100, 0)
gen d5 = cond(diet==5, 100, 0)
gen d6 = cond(diet==6, 100, 0)



// https://dhsprogram.com/data/Guide-to-DHS-Statistics/Breastfeeding_and_Complementary_Feeding.htm
// Handling of Missing Values
// Missing data on breastfeeding is treated as not currently breastfeeding in numerator and included in the denominator. Missing and “don’t know” 
// data on foods and liquids given is treated as not given in numerator and included in denominator.


* Create weighted results for graph

preserve // to return data to prior format after commands below

collapse d1 d2 d3 d4 d5 d6 [aw=nat_wgt], by(agemos)
gen total = d1 + d2 + d3 + d4 + d5 + d6

drop if agemos >24
// collapse (sum) mvalue invest kstock, by(year)
gen p1 = d1 
gen p2 = d1 + d2 
gen p3 = d1 + d2 + d3 
gen p4 = d1 + d2 + d3 + d4 
gen p5 = d1 + d2 + d3 + d4 + d5 
gen p6 = d1 + d2 + d3 + d4 + d5 + d6
gen hundred = 100  
gen zero = 0 
twoway rarea zero p1 agemos, col(gold) /// 
    || rarea p1 p2 agemos,   col(ltblue) /// 
    || rarea p2 p3 agemos,   col(eggshell) /// 
	|| rarea p3 p4 agemos,   col(orange_red) ///
	|| rarea p4 p5 agemos,   col(emerald) /// 
    || rarea p5 p6 agemos,   col(olive_teal)  /// 
    ||, legend(ring(0) position(2) col(1) size(tiny) ///
		order(6 "Not BF" 5 "CF & BF" 4 "Formula & BF" 3 "Non-milk liq & BF" 2 "H2O & BF" 1 "Exclusive BF")) /// 
     xla(0(1)24) ytitle(Percent) xtitle(Age in Months) title(Breastfeeding Area Graph)

* see svedberg2.do for area graph
	 
restore  // restore to prior data
	 
	 
	 
	 



cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"

* data
//use "C:\Temp\iycf_cnns.dta", clear 
 use "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged\iycf_cnns.dta", clear

	 
	
graph twoway (lpoly carb  agemos [aw=nat_wgt], lcolor(olive) degree(1) /// Grains roots tubers
		title("IYCF food groups consumed - CNNS 2016-18") ///
		xtitle("Age in months", size(medlarge)) ytitle("%") ///
		legend(size(0.9) pos(3) col(1) order(1 "Grains roots tubers" 2 "Dairy" 3 "Vita A Fruits/Veg" 4 "Other Fruit/Veg" /// 
		5 "Legumes/Nuts" 6 "Eggs" 7 "Animal source foods") stack) ///
		xlabel(2(2)24)) ///
	(lpoly dairy           agemos [aw=nat_wgt], lcolor(gold) lpattern(dash) degree(1)) /// Dairy
	(lpoly vita_fruit_veg  agemos [aw=nat_wgt], lcolor(orange) lpattern(longdash) degree(1)) /// Vita A Fruits/Veg
	(lpoly fruit_veg       agemos [aw=nat_wgt], lcolor(green) lpattern(solid) degree(1)) /// Other Fruit/Veg
	(lpoly leg_nut         agemos [aw=nat_wgt], lcolor(brown) lpattern(dash) degree(1)) /// Legumes
	(lpoly egg             agemos [aw=nat_wgt], lcolor(ebblue) lpattern(longdash) degree(1)) /// Eggs
	(lpoly all_meat        agemos [aw=nat_wgt], lcolor(red) lpattern(solid) degree(1)) 


*Double check with original labels
graph twoway (lpoly carb  agemos [aw=nat_wgt], degree(1)) /// Grains roots tubers
	(lpoly dairy  agemos [aw=nat_wgt], degree(1)) /// Dairy
	(lpoly vita_fruit_veg  agemos [aw=nat_wgt], degree(1)) /// Vita A Fruits/Veg
	(lpoly fruit_veg  agemos [aw=nat_wgt], degree(1)) /// Other Fruit/Veg
	(lpoly leg_nut  agemos [aw=nat_wgt], degree(1)) /// Legumes
	(lpoly egg  agemos [aw=nat_wgt], degree(1)) /// Eggs
	(lpoly all_meat  agemos [aw=nat_wgt], degree(1))
	


* Bottle feeding by age in months
graph twoway (lpoly bottle agemos if agemos>0, lcolor(red) degree(1) ///
	legend(rows(1) order(1 "Bottle Feeding")) ///
	xlabel(0(3)60) xtitle("Age in Months") title("Bottle feeding by age in months")) 
graph export malnutrition_agemos.tif, as(tif) replace

* to put graphs in document
// putdocx pagebreak
// putdocx paragraph, halign(left)
// putdocx image age_in_months.tif, linebreak(1)
// putdocx paragraph, style(Heading2)
// putdocx text ("Figure 1: Count of children by age in months")
// putdocx paragraph, halign(left)
// putdocx text ("In the age in months graph, all ages should be evenly distributed. There should not be heaping or excessive counts of children on ages rounded to full years or half years.")
























































/*

*------------------------------------------------------------------------------------*
// 1.2. Early initiation of breastfeeding (EIBF) 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Define variables for table
local TableName = "Early initiation of breastfeeding (EIBF)"
local TableNum = "table4"
local var1 = "eibf" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, header, footer and overall
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount',3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.2: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(3) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Initiation"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowNum',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowNum',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)


**************************************************************************************

// Early initiation of breastfeeding (EIBF) by c-section
* Must code ColVars with values starting from 1 not 0
recode csection (0=1)(1=2)

* Variable by mumeduc 
local TableName = "Early initiation of breastfeeding (EIBF)"
local TableNum = "table5"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "csection"

tab `ColVar'

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.2.1: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(4) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Normal birth"), bold halign(center)
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' & `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

******************************************************************************************************************************************
// 1.3. Exclusively breastfed for the first two days after birth (EBF2D) 

putdocx begin, font("Calibri", 9)
* Define variables for table
local TableName = "Exclusively breastfed for the first two days (EBF2D)"
local TableNum = "table6"
local var1 = "ebf2d" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.1: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
//------------------------------------------------------------------------------------

//1.3.1 EBF2D variable w.r.t. caste

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "EBF2D by caste"
local TableNum = "table7"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1.1: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Missing/don't know"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N "), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' & `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*----------------------------------------------------------------------------------------------------------------
//1.3.2 Ever breastfed indicator w.r.t mothers education

putdocx begin, font("Calibri", 9)

* EVBF by mumeduc 
local TableName = "EBF2D by mother's schooling"
local TableNum = "table8"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "mum_educ"

tab mum_educ

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1.2: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Education"), bold halign(center)
putdocx table `TableNum'(2,3) = ("<5 years"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' & `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

************************************************************************************************************
//1.4. Exclusive breastfeeding under six months (EBF) 
putdocx begin, font("Calibri", 9)
* Define variables for table
local TableName = "Exclusive BF of children below 6 months of age"
local TableNum = "table9"
local var1 = "exbf" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 

//-------------------------------------------------------------------------------------------
//1.4.1 EXBF variable w.r.t. caste

putdocx begin, font("Calibri", 9)

* Variable by Caste 
local TableName = "exclusivelly breastfed (children <6 months) by caste"
local TableNum = "table10"
local Var = "exbf" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1.1: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Missing/don't know"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N "), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' & `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*----------------------------------------------------------------------------------------------------------------
//1.4.2 EXBF variable w.r.t. mothers education

putdocx begin, font("Calibri", 9)

* EXBF by mumeduc 
local TableName = "Exclusivelly breastfed (children <6 months) by mother's schooling"
local TableNum = "table11"
local Var = "exbf" 
local RowVar = "state"
local ColVar = "mum_educ"

tab mum_educ

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1.1: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Education"), bold halign(center)
putdocx table `TableNum'(2,3) = ("<5 years"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' & `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

*********************************************************************************************
// 1.5. Mixed milk feeding under six months (MixMF) 
putdocx begin, font("Calibri", 9)
* Define variables for table
local TableName = "Mixed milk feeding under six months"
local TableNum = "table12"
local var1 = "mixed_milk" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 

//-------------------------------------------------------------------------------------------
//1.5.1 Mixed milk feeding under six months w.r.t. caste

putdocx begin, font("Calibri", 9)

* Variable by Caste 
local TableName = "Mixed milk feeding under six months by caste"
local TableNum = "table13"
local Var = "mixed_milk" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1.1: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Missing/don't know"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N "), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' & `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*----------------------------------------------------------------------------------------------------------------
//1.5.2 EXBF variable w.r.t. mothers education

putdocx begin, font("Calibri", 9)

* EXBF by mumeduc 
local TableName = "Exclusivelly breastfed (children <6 months) by mother's schooling"
local TableNum = "table11"
local Var = "mixed_milk" 
local RowVar = "state"
local ColVar = "mum_educ"

tab mum_educ

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1.1: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Education"), bold halign(center)
putdocx table `TableNum'(2,3) = ("<5 years"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' & `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

***************************************************************************************************************************




























// 1.4. Exclusively breastfed for the first two days after birth (EBF2D) 

putdocx begin, font("Calibri", 9)
* Define variables for table
local TableName = "Exclusively breastfed for the first two days (EBF2D)"
local TableNum = "table6"
local var1 = "ebf2d" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.1: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' 
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 
//------------------------------------------------------------------------------------

//1.3.1 EBF2D variable w.r.t. caste

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "EBF2D by caste"
local TableNum = "table7"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1.1: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Missing/don't know"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N "), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' & `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum', `ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append
*----------------------------------------------------------------------------------------------------------------
//1.3.2 Ever breastfed indicator w.r.t mothers education

putdocx begin, font("Calibri", 9)

* EVBF by mumeduc 
local TableName = "EBF2D by mother's schooling"
local TableNum = "table8"
local Var = "ebf2d" 
local RowVar = "state"
local ColVar = "mum_educ"

tab mum_educ

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1.2: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Education"), bold halign(center)
putdocx table `TableNum'(2,3) = ("<5 years"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' & `col'==4   
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

















putdocx begin, font("Calibri", 9)
* table state, c(mean bottle n bottle)

* Define variables for table
local TableName = "Bottle feeding"
local TableNum = "table1"
local var1 = "bottle" 
local RowVar = "state"

// local RowVar = "caste"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount',3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Bottle feeding"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row'  // add weights
	* convert proportion into percentage
	local result = r(mean) * 100
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt] // add weights
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 

*******************************************************************************************************************************************************
* Bottle feeding w.r.t mothers education


putdocx begin, font("Calibri", 9)

* Variable by mumeduc 
local TableName = "Bottle Feeding by mother's schooling"
local TableNum = "table2"
local Var = "bottle" 
local RowVar = "state"
local ColVar = "mum_educ"

tab mum_educ

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1.1: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Education"), bold halign(center)
putdocx table `TableNum'(2,3) = ("<5 years"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' & `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append


***************************************************************************************************
*bottle feeding w.r.t. caste

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Bottle Feeding by caste"
local TableNum = "table2"
local Var = "bottle" 
local RowVar = "state"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1.1: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(6) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Missing/don't know"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local RowNum = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`RowNum',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Var' [aw=state_wgt] if `ColVar'==`col' & `RowVar'==`row'
			local Result =cond(r(N)>=50,r(mean)*100,.)
			local ColNum = `col'+1
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' & `col'==4
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]  if `col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save iycf_cnns, append

***************************************************************************************************
 

// gen state_wgt = iweight_s                                           
// gen nat_wgt = iw_s_pool   

//X.X. Median age of exclusive breastfeeding in months
putdocx begin, font("Calibri", 9)
* Define variables for table
local TableName = "Median age of exclusive BF"
local TableNum = "tablex"
local var1 = "age_ebf" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Median age in months EBF"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add state name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if state==`row' , detail
	* convert proportion into percentage
	local result = r(p50) 
	putdocx table `TableNum'(`i',2) = (`result'), nformat(%5.2f) halign(center)
	putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=nat_wgt]   , detail
	local result = r(p50) 
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.2f) halign(center)
	putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save iycf_cnns, append 

* dot graph of median ebf
cap drop order
egen order =median(age_ebf), by(state)
graph dot age_ebf, over(state, sort(order)) ytitle(Median Months of Exclusive Breastfeeding)

* dot graph of median continued bf
cap drop order
egen order =median(age_cbf), by(state)
graph dot age_cbf, over(state, sort(order)) ytitle(Median Months of Continued Breastfeeding)
* how to weight summary states
// https://www.stata.com/support/faqs/data-management/weighted-group-summary-statistics/


*Variable for breastfeeding area graph

cap drop diet
gen diet=9
replace diet=1 if currently_bf==1 
replace diet=2 if currently_bf==1 & water==1 
replace diet=3 if currently_bf==1 & other_liq==1 
replace diet=3 if currently_bf==1 & juice==1 
replace diet=3 if currently_bf==1 & broth==1 
// replace diet=3 if currently_bf==1 & teas==1 
replace diet=4 if currently_bf==1 & formula==1 
replace diet=4 if currently_bf==1 & milk==1 
replace diet=5 if currently_bf==1 & any_solid_semi_food==1 
replace diet=6 if currently_bf==0 

la def diet 1 "exclusively breastfed" ///
			2 "plain water & breastmilk" ///
			3 "non-milk liquids & breastmilk" ///
			4 "other milks/formula & breastmilk" ///
			5 "comp foods & breastmilk" ///
			6 "not breastfed" ///
			9 "missing"

tab diet, m 

* No cases of bf and form? 
tab diet formula, m 


cap drop d1 d2 d3 d4 d5 d6
// tabulate diet, generate(d) - cannot use this line because sometimes there are missing categories
gen d1 = cond(diet==1, 100, 0)
gen d2 = cond(diet==2, 100, 0)
gen d3 = cond(diet==3, 100, 0)
gen d4 = cond(diet==4, 100, 0)
gen d5 = cond(diet==5, 100, 0)
gen d6 = cond(diet==6, 100, 0)



// https://dhsprogram.com/data/Guide-to-DHS-Statistics/Breastfeeding_and_Complementary_Feeding.htm
// Handling of Missing Values
// Missing data on breastfeeding is treated as not currently breastfeeding in numerator and included in the denominator. Missing and “don’t know” 
// data on foods and liquids given is treated as not given in numerator and included in denominator.


* Create weighted results for graph
collapse d1 d2 d3 d4 d5 d6 [aw=nat_wgt], by(agemos)
gen total = d1 + d2 + d3 + d4 + d5 + d6

drop if agemos >24
// collapse (sum) mvalue invest kstock, by(year)
gen p1 = d1 
gen p2 = d1 + d2 
gen p3 = d1 + d2 + d3 
gen p4 = d1 + d2 + d3 + d4 
gen p5 = d1 + d2 + d3 + d4 + d5 
gen p6 = d1 + d2 + d3 + d4 + d5 + d6
gen hundred = 100  
gen zero = 0 
twoway rarea zero p1 agemos, col(gold) /// 
    || rarea p1 p2 agemos,   col(ltblue) /// 
    || rarea p2 p3 agemos,   col(eggshell) /// 
	|| rarea p3 p4 agemos,   col(orange_red) ///
	|| rarea p4 p5 agemos,   col(emerald) /// 
    || rarea p5 p6 agemos,   col(olive_teal)  /// 
    ||, legend(ring(0) position(2) col(1) size(tiny) ///
		order(6 "Not BF" 5 "CF & BF" 4 "Formula & BF" 3 "Non-milk liq & BF" 2 "H2O & BF" 1 "Exclusive BF")) /// 
     xla(0(1)24) ytitle(Percent) xtitle(Age in Months) title(Breastfeeding Area Graph)

* see svedberg2.do for area graph
	 



	
graph twoway (lpoly group1_cdd  agemos [aw=nat_weight_survey], lcolor(olive) degree(1) /// Grains roots tubers
		title("                IYCF food groups consumed - CNNS 2016-18") ///
		xtitle("Age in months", size(medlarge)) ytitle("%") ///
		legend(size(0.9) pos(3) col(1) order(1 "Grains roots tubers" 2 "Dairy" 3 "Vita A Fruits/Veg" 4 "Other Fruit/Veg" /// 
		5 "Legumes/Nuts" 6 "Eggs" 7 "Animal source foods") stack) ///
		xlabel(2(2)24)) ///
	(lpoly group3_cdd  agemos [aw=nat_weight_survey], lcolor(gold) lpattern(dash) degree(1)) /// Dairy
	(lpoly group6_cdd  agemos [aw=nat_weight_survey], lcolor(orange) lpattern(longdash) degree(1)) /// Vita A Fruits/Veg
	(lpoly group7_cdd  agemos [aw=nat_weight_survey], lcolor(green) lpattern(solid) degree(1)) /// Other Fruit/Veg
	(lpoly group2_cdd  agemos [aw=nat_weight_survey], lcolor(brown) lpattern(dash) degree(1)) /// Legumes
	(lpoly group5_cdd  agemos [aw=nat_weight_survey], lcolor(ebblue) lpattern(longdash) degree(1)) /// Eggs
	(lpoly group4_cdd  agemos [aw=nat_weight_survey], lcolor(red) lpattern(solid) degree(1)) 


*Double check with original labels
graph twoway (lpoly group1_cdd  agemos [aw=nat_weight_survey], degree(1)) /// Grains roots tubers
	(lpoly group3_cdd  agemos [aw=nat_weight_survey], degree(1)) /// Dairy
	(lpoly group6_cdd  agemos [aw=nat_weight_survey], degree(1)) /// Vita A Fruits/Veg
	(lpoly group7_cdd  agemos [aw=nat_weight_survey], degree(1)) /// Other Fruit/Veg
	(lpoly group2_cdd  agemos [aw=nat_weight_survey], degree(1)) /// Legumes
	(lpoly group4_cdd  agemos [aw=nat_weight_survey], degree(1)) /// Eggs
	(lpoly group5_cdd  agemos [aw=nat_weight_survey], degree(1)) 
	















* Bottle feeding by age in months
graph twoway (lpoly bottle agemos if agemos>0, lcolor(red) degree(1) ///
	legend(rows(1) order(1 "Bottle Feeding")) ///
	xlabel(0(3)60) xtitle("Age in Months") title("Bottle feeding by age in months")) 
graph export malnutrition_agemos.tif, as(tif) replace


































































/*
putdocx begin, font("Calibri", 9)


 
end




* Malnutrition by age in months
* Stunted, Wasted, Underweight
graph twoway (lpoly wasted agemos if agemos>0, lcolor(red) degree(1)) ///
	(lpoly stunted agemos, lc(forest_green) degree(1)) ///
	(lpoly uwt agemos, lc(midblue) degree(1) ///
	legend(rows(1) order(1 "Wasting" 2 "Stunting" 3 "Underweight")) ///
	xlabel(0(3)60) xtitle("Age in Months") title("Malnutrition by age in months")) 
graph export malnutrition_agemos.tif, as(tif) replace

* Add graph
putdocx paragraph, halign(center)
putdocx image malnutrition_agemos.tif
putdocx save iycf_cnns, append











* Age in Months
drop if agemos<0 | agemos>59
* Note this graph does not work if there are not data for each unit on x axis. 
graph bar (count)one, over(agemos, label(labsize(1) angle(45) alternate)) ///
   ytitle("count") title("Counts of measures of age in months") 
graph export age_in_months.tif, as(tif) replace


















putdocx paragraph, halign(center)
putdocx image Wasting_dist.tif
putdocx image Stunting_dist.tif
putdocx image Underweight_dist.tif


putdocx save test, append 
putdocx begin, font("Calibri", 10) 


* Define variables for table
local TableName = "Wasting"
local TableNum = "table2"
local Glob_Mal = "wasted"
local Sev_Mal = "sev_wasted"
local RowVar = "district"

* How many rows to use for RowVar / number of districts + 3: one for the header, one for the footer (notes) and the other for the table title *
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(90%) layout(autofitcontents) note(Note: Wasting<-2SD WHZ Severe Wasting<-3SD WHZ.)
putdocx table `TableNum'(1,1)=("`TableName' in children under five years by District"), bold font("Calibri", 11) halign(center) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("`TableName'"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count `TableName'"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Severe `TableName'"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Count Severe `TableName'"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N `TableName'"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
// 	local RowValueLabelNum = word("`RowLevels'", `row')
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'

	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	quietly summarize `Glob_Mal' if district==`row'
    putdocx table `TableNum'(`i',2) = (r(mean)), nformat(%5.1f) halign(center)
    putdocx table `TableNum'(`i',3) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)
	// add N to right column of table
	putdocx table `TableNum'(`i',6) = (r(N)), nformat(%16.0gc) halign(center)
	// return to filling rows in order
	quietly summarize `Sev_Mal' if district==`row'
    putdocx table `TableNum'(`i',4) = (r(mean)), nformat(%5.1f) halign(center)
    putdocx table `TableNum'(`i',5) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)
}
 * add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
quietly summarize `Glob_Mal' 
putdocx table `TableNum'(`RowCount',2) = (r(mean)), nformat(%5.1f) halign(center)
putdocx table `TableNum'(`RowCount',3) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)
// add N to right column of table
putdocx table `TableNum'(`RowCount',6) = (r(N)), nformat(%16.0gc) halign(center)
// return to filling rows in order
quietly summarize `Sev_Mal' 
putdocx table `TableNum'(`RowCount',4) = (r(mean)), nformat(%5.1f) halign(center)
putdocx table `TableNum'(`RowCount',5) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)



* Define variables for table
local TableName = "Stunting"
local TableNum = "table3"
local Glob_Mal = "stunted"
local Sev_Mal = "sev_stunted"
local RowVar = "district"

* How many rows to use for RowVar / number of districts + 3: one for the header, one for the footer (notes) and the other for the table title *
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(90%) layout(autofitcontents) note(Note: Stunting<-2SD HAZ Severe Stunting<-3SD HAZ.)
putdocx table `TableNum'(1,1)=("`TableName' in children under five years by District"), bold font("Calibri", 11) halign(center) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("`TableName'"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count `TableName'"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Severe `TableName'"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Count Severe `TableName'"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N `TableName'"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
// 	local RowValueLabelNum = word("`RowLevels'", `row')
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'

	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	quietly summarize `Glob_Mal' if district==`row'
    putdocx table `TableNum'(`i',2) = (r(mean)), nformat(%5.1f) halign(center)
    putdocx table `TableNum'(`i',3) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)
	// add N to right column of table
	putdocx table `TableNum'(`i',6) = (r(N)), nformat(%16.0gc) halign(center)
	// return to filling rows in order
	quietly summarize `Sev_Mal' if district==`row'
    putdocx table `TableNum'(`i',4) = (r(mean)), nformat(%5.1f) halign(center)
    putdocx table `TableNum'(`i',5) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)
}
 * add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
quietly summarize `Glob_Mal' 
putdocx table `TableNum'(`RowCount',2) = (r(mean)), nformat(%5.1f) halign(center)
putdocx table `TableNum'(`RowCount',3) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)
// add N to right column of table
putdocx table `TableNum'(`RowCount',6) = (r(N)), nformat(%16.0gc) halign(center)
// return to filling rows in order
quietly summarize `Sev_Mal' 
putdocx table `TableNum'(`RowCount',4) = (r(mean)), nformat(%5.1f) halign(center)
putdocx table `TableNum'(`RowCount',5) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)



* Define variables for table
local TableName = "Underweight"
local TableNum = "table4"
local Glob_Mal = "uwt"
local Sev_Mal = "sev_uwt"
local RowVar = "district"

* How many rows to use for RowVar / number of districts + 3: one for the header, one for the footer (notes) and the other for the table title *
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(90%) layout(autofitcontents) ///
	note(Note: Underweight<-2SD WAZ Severe Underweight<-3SD WAZ)
putdocx table `TableNum'(1,1)=("`TableName' in children under five years by District"), bold font("Calibri", 11) halign(center) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("`TableName'"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count `TableName'"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Severe `TableName'"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Count Severe `TableName'"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N `TableName'"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
// 	local RowValueLabelNum = word("`RowLevels'", `row')
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'

	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	quietly summarize `Glob_Mal' if district==`row'
    putdocx table `TableNum'(`i',2) = (r(mean)), nformat(%5.1f) halign(center)
    putdocx table `TableNum'(`i',3) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)
	// add N to right column of table
	putdocx table `TableNum'(`i',6) = (r(N)), nformat(%16.0gc) halign(center)
	// return to filling rows in order
	quietly summarize `Sev_Mal' if district==`row'
    putdocx table `TableNum'(`i',4) = (r(mean)), nformat(%5.1f) halign(center)
    putdocx table `TableNum'(`i',5) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)
}
 * add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
quietly summarize `Glob_Mal' 
putdocx table `TableNum'(`RowCount',2) = (r(mean)), nformat(%5.1f) halign(center)
putdocx table `TableNum'(`RowCount',3) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)
// add N to right column of table
putdocx table `TableNum'(`RowCount',6) = (r(N)), nformat(%16.0gc) halign(center)
// return to filling rows in order
quietly summarize `Sev_Mal' 
putdocx table `TableNum'(`RowCount',4) = (r(mean)), nformat(%5.1f) halign(center)
putdocx table `TableNum'(`RowCount',5) = (r(mean)*r(N)/100), nformat(%16.0gc) halign(center)


putdocx save test, append
putdocx begin, font("Calibri", 9)


* Malnutrition by Sex of Child
local TableName = "Wasting"
local TableNum = "table5"
local Glob_Mal = "wasted"
local Sev_Mal = "sev_wasted"
local RowVar = "district"

* How many rows to use for RowVar / number of districts + 3: one for the header, one for the footer (notes) and the other for the table title *
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) 
putdocx table `TableNum'(1,1)=("`TableName' in children under five years by District"), bold font("Calibri", 11) halign(center) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("`TableName' males"), bold halign(center)
putdocx table `TableNum'(2,3) = ("`TableName' females"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Severe `TableName' males"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Severe `TableName' females"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N `TableName'"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
// 	local RowValueLabelNum = word("`RowLevels'", `row')
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'

	* define rows 
	* to change analysis to caste or rural/urban - change sex to caste. 
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	quietly summarize `Glob_Mal' if sex==1 & district==`row'
    putdocx table `TableNum'(`i',2) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Glob_Mal' if sex==2 & district==`row'
    putdocx table `TableNum'(`i',3) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Sev_Mal' if sex==1 & district==`row'
    putdocx table `TableNum'(`i',4) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Sev_Mal' if sex==2 & district==`row'
    putdocx table `TableNum'(`i',5) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Glob_Mal' if district==`row'
	putdocx table `TableNum'(`i',6) = (r(N)), nformat(%16.0gc) halign(center)
}
 * add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
quietly summarize `Glob_Mal'  if sex==1
putdocx table `TableNum'(`RowCount',2) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Glob_Mal'  if sex==2
putdocx table `TableNum'(`RowCount',3) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Sev_Mal'  if sex==1
putdocx table `TableNum'(`RowCount',4) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Sev_Mal'  if sex==2
putdocx table `TableNum'(`RowCount',5) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Glob_Mal' 
putdocx table `TableNum'(`RowCount',6) = (r(N)), nformat(%16.0gc) halign(center)




local TableName = "Stunting"
local TableNum = "table6"
local Glob_Mal = "stunted"
local Sev_Mal = "sev_stunted"
local RowVar = "district"

* How many rows to use for RowVar / number of districts + 3: one for the header, one for the footer (notes) and the other for the table title *
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) 
putdocx table `TableNum'(1,1)=("`TableName' in children under five years by District"), bold font("Calibri", 11) halign(center) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("`TableName' males"), bold halign(center)
putdocx table `TableNum'(2,3) = ("`TableName' females"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Severe `TableName' males"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Severe `TableName' females"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N `TableName'"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
// 	local RowValueLabelNum = word("`RowLevels'", `row')
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'

	* define rows 
	* to change analysis to caste or rural/urban - change sex to caste. 
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	quietly summarize `Glob_Mal' if sex==1 & district==`row'
    putdocx table `TableNum'(`i',2) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Glob_Mal' if sex==2 & district==`row'
    putdocx table `TableNum'(`i',3) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Sev_Mal' if sex==1 & district==`row'
    putdocx table `TableNum'(`i',4) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Sev_Mal' if sex==2 & district==`row'
    putdocx table `TableNum'(`i',5) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Glob_Mal' if district==`row'
	putdocx table `TableNum'(`i',6) = (r(N)), nformat(%16.0gc) halign(center)
}
 * add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
quietly summarize `Glob_Mal'  if sex==1
putdocx table `TableNum'(`RowCount',2) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Glob_Mal'  if sex==2
putdocx table `TableNum'(`RowCount',3) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Sev_Mal'  if sex==1
putdocx table `TableNum'(`RowCount',4) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Sev_Mal'  if sex==2
putdocx table `TableNum'(`RowCount',5) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Glob_Mal' 
putdocx table `TableNum'(`RowCount',6) = (r(N)), nformat(%16.0gc) halign(center)


local TableName = "Underweight"
local TableNum = "table7"
local Glob_Mal = "uwt"
local Sev_Mal = "sev_uwt"
local RowVar = "district"

* How many rows to use for RowVar / number of districts + 3: one for the header, one for the footer (notes) and the other for the table title *
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) 
putdocx table `TableNum'(1,1)=("`TableName' in children under five years by District"), bold font("Calibri", 11) halign(center) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("`TableName' males"), bold halign(center)
putdocx table `TableNum'(2,3) = ("`TableName' females"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Severe `TableName' males"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Severe `TableName' females"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N `TableName'"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
// 	local RowValueLabelNum = word("`RowLevels'", `row')
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'

	* define rows 
	* to change analysis to caste or rural/urban - change sex to caste. 
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	quietly summarize `Glob_Mal' if sex==1 & district==`row'
    putdocx table `TableNum'(`i',2) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Glob_Mal' if sex==2 & district==`row'
    putdocx table `TableNum'(`i',3) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Sev_Mal' if sex==1 & district==`row'
    putdocx table `TableNum'(`i',4) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Sev_Mal' if sex==2 & district==`row'
    putdocx table `TableNum'(`i',5) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize `Glob_Mal' if district==`row'
	putdocx table `TableNum'(`i',6) = (r(N)), nformat(%16.0gc) halign(center)
}
 * add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
quietly summarize `Glob_Mal'  if sex==1
putdocx table `TableNum'(`RowCount',2) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Glob_Mal'  if sex==2
putdocx table `TableNum'(`RowCount',3) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Sev_Mal'  if sex==1
putdocx table `TableNum'(`RowCount',4) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Sev_Mal'  if sex==2
putdocx table `TableNum'(`RowCount',5) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize `Glob_Mal' 
putdocx table `TableNum'(`RowCount',6) = (r(N)), nformat(%16.0gc) halign(center)


putdocx save test, append
putdocx begin, font("Calibri", 9)





// Caste
//     General |     73,351        3.72        3.72
//    Minority |     20,609        1.05        4.77
//         OBC |    854,328       43.34       48.11
//          SC |    348,800       17.70       65.81
//          ST |    673,933       34.19      100.00




* Malnutrition by Caste of Child
local TableName = "Wasting"
local TableNum = "table8"
local Glob_Mal = "wasted"
local Sev_Mal = "sev_wasted"
local RowVar = "district"
local ColVar = "caste"

* How many rows to use for RowVar / number of districts + 5: table title, header, space, Overall,  *
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) 
putdocx table `TableNum'(1,1)=("`TableName' in children under five years by District"), bold font("Calibri", 11) halign(center) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("General"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Minority"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N `TableName'    "), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local i = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Glob_Mal' if `ColVar'==`col' & district==`row'
			local row_num = `col'+1
			putdocx table `TableNum'(`i',`row_num') = (r(mean)), nformat(%5.1f) halign(center)
			// add total N to far right column
			quietly summarize `Glob_Mal' if district==`row' & `row_num'==6
			local row_num = `col'+2
			putdocx table `TableNum'(`i',`row_num') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Glob_Mal' if `ColVar'==`col'
		local row_num = `col'+1
		putdocx table `TableNum'(`RowCount',`row_num') = (r(mean)), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Glob_Mal' if `row_num'==6
		local row_num = `col'+2
		putdocx table `TableNum'(`RowCount',`row_num') = (r(N)), nformat(%16.0gc) halign(center)
	}




local TableName = "Stunting"
local TableNum = "table9"
local Glob_Mal = "stunted"
local Sev_Mal = "sev_stunted"
local RowVar = "district"
local ColVar = "caste"

* How many rows to use for RowVar / number of districts + 3: one for the header, one for the footer (notes) and the other for the table title *
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+3
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) 
putdocx table `TableNum'(1,1)=("`TableName' in children under five years by District"), bold font("Calibri", 11) halign(center) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("General"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Minority"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N `TableName'    "), bold halign(center)
levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local i = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Glob_Mal' if `ColVar'==`col' & district==`row'
			local row_num = `col'+1
			putdocx table `TableNum'(`i',`row_num') = (r(mean)), nformat(%5.1f) halign(center)
			// add total N to far right column
			quietly summarize `Glob_Mal' if district==`row' & `row_num'==6
			local row_num = `col'+2
			putdocx table `TableNum'(`i',`row_num') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Glob_Mal' if `ColVar'==`col'
		local row_num = `col'+1
		putdocx table `TableNum'(`RowCount',`row_num') = (r(mean)), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Glob_Mal' if `row_num'==6
		local row_num = `col'+2
		putdocx table `TableNum'(`RowCount',`row_num') = (r(N)), nformat(%16.0gc) halign(center)
}
	
local TableName = "Underweight"
local TableNum = "table10"
local Glob_Mal = "uwt"
local Sev_Mal = "sev_uwt"
local RowVar = "district"
local ColVar = "caste"

* How many rows to use for RowVar / number of districts + 3: one for the header, one for the footer (notes) and the other for the table title *
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+3
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) 
putdocx table `TableNum'(1,1)=("`TableName' in children under five years by District"), bold font("Calibri", 11) halign(center) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("General"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Minority"), bold halign(center)
putdocx table `TableNum'(2,4) = ("OBC"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Scheduled Caste"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Scheduled Tribe"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N `TableName'    "), bold halign(center)

levelsof `RowVar', local(RowLevels)
levelsof `ColVar', local(columns)
foreach row in `RowLevels' {
	local i = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	* define rows 
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
		* add results in columns
		foreach col in `columns' {
			quietly summarize `Glob_Mal' if `ColVar'==`col' & district==`row'
			local row_num = `col'+1
			putdocx table `TableNum'(`i',`row_num') = (r(mean)), nformat(%5.1f) halign(center)
			// add total N to far right column
			quietly summarize `Glob_Mal' if district==`row' & `row_num'==6
			local row_num = `col'+2
			putdocx table `TableNum'(`i',`row_num') = (r(N)), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Glob_Mal' if `ColVar'==`col'
		local row_num = `col'+1
		putdocx table `TableNum'(`RowCount',`row_num') = (r(mean)), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Glob_Mal' if `row_num'==6
		local row_num = `col'+2
		putdocx table `TableNum'(`RowCount',`row_num') = (r(N)), nformat(%16.0gc) halign(center)
}

putdocx save test, append
putdocx begin, font("Calibri", 9)


* Prevalence not malnourished
preserve
collapse (mean) not_maln, by(district)
la var not_maln "Not Malnourished"
*Wasting
graph hbar not_maln , bar(1, color(orange)) bar(2, color(red*0.25)) ///
	over(district, label(labsize(small)) sort(not_maln))  ///
	title("Prevalence of Not Malnourished by District") ytitle(Not Malnourished) ///
	note("Not malnourished is not stunted, wasted or underweight")
graph export not_maln_dist.tif, as(tif) replace

restore

putdocx paragraph, halign(center)
putdocx image not_maln_dist.tif


putdocx save test, append
putdocx begin, font("Calibri", 10)


local TableName = "Not Malnourished"
local TableNum = "table11"
local RowVar = "district"

* How many rows to use for RowVar / number of districts + 4: table title header, Overall and footer (notes) *
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: "Not malnourished is not stunted wasted or underweight")
putdocx table `TableNum'(1,1)=("`TableName' in children under five years by District"), bold font("Calibri", 11) halign(center) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("Not Stunted"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Not Wasted"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Not Underweight"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Not Malnourished"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N `TableName'"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
// 	local RowValueLabelNum = word("`RowLevels'", `row')
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'

	* define rows 
	* to change analysis, change sum var. 
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	quietly summarize not_stunted if district==`row'
    putdocx table `TableNum'(`i',2) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize not_wasted if district==`row'
    putdocx table `TableNum'(`i',3) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize not_uwt if district==`row'
    putdocx table `TableNum'(`i',4) = (r(mean)), nformat(%5.1f) halign(center)
	quietly summarize not_maln if district==`row'
    putdocx table `TableNum'(`i',5) = (r(mean)), nformat(%5.1f) halign(center)
	putdocx table `TableNum'(`i',6) = (r(N)), nformat(%16.0gc) halign(center)
}
 * add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
quietly summarize not_stunted 
putdocx table `TableNum'(`RowCount',2) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize not_wasted 
putdocx table `TableNum'(`RowCount',3) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize not_uwt 
putdocx table `TableNum'(`RowCount',4) = (r(mean)), nformat(%5.1f) halign(center)
quietly summarize not_maln 
putdocx table `TableNum'(`RowCount',5) = (r(mean)), nformat(%5.1f) halign(center)
putdocx table `TableNum'(`RowCount',6) = (r(N)), nformat(%16.0gc) halign(center)


putdocx save test, append
putdocx begin, font("Calibri", 9)


* table district, c(mean stunted mean not_stunted n stunted n not_stunted)
// District wise list of AWCs with nil undernourished, stunted and wasted children 



* List of AWC by prevalence, coverage, target population
* Create vars for AWC of prevalence, coverage, target population
*Corrected

*destring AWC name
encode ABKendraName, gen(awc_name)
* add dist_id and parojna_id to AWC number to make stronger ID
encode PariyojnaName, gen(par_name)
gen double awc_num = dist_id* 100000000 + par_name*100000 + awc_name

* Registered in AWC
cap drop temp
encode RegInABK, gen(temp)
recode temp (1=0)(2=1), gen(temp_awc_cov)
tab temp_awc_cov RegInABK

* target population for AWC
egen awc_target = total(one), by(awc_num)
// order dist_id par_name awc_name, last

* set max to 200 for children per AWC
gen awc_target100 = awc_target/2
replace awc_target100 = 100 if awc_target100>100

egen awc_reg = total(temp_awc_cov==1), by(awc_num)
gen awc_coverage = awc_reg / awc_target *100
drop temp temp_awc_cov

* Not malnourished by AWC
egen awc_notmaln = mean(not_maln), by(awc_num)

* Composite index of prevalence not malnourished, coverage, and total target population
gen awc_composite = (awc_target100 +  awc_coverage  +  awc_notmaln) /3

preserve

egen uniq = tag(awc_num)
drop if uniq!= 1
tab uniq

gsort -awc_composite
list sector awc_name awc_target awc_reg awc_notmaln awc_composite in 1/20 
// order sector awc_name awc_target awc_reg awc_notmaln awc_composite, last
cap drop casenum
gen casenum = _n
drop if casenum >20
sum casenum  // test drop

*create table and putdocx from 1/20
local TableName = "Best Performing AWC"
local TableNum = "table15"
local RowVar = "district"
* How many rows to use for RowVar / 20 + 3: table title header note
* Only list top 20
local RowCount = 23

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) 
putdocx table `TableNum'(1,1)=("Table 15: `TableName' by composite score"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("AWC Name"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Target #"), bold halign(center)
putdocx table `TableNum'(2,4) = ("# Registered"), bold halign(center)
putdocx table `TableNum'(2,5) = ("% Non-malnourished"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Composite Score"), bold halign(center)

forval row = 1/20 {
	local i = `row'+2

	* value labels are stored internally and numbered in alphabetical order, so have to extract value label number 
	* assign number and then value to local as string before adding to table. 
	local sec = "`=`RowVar'[`row']'"  // takes value label number
	local RowValueLabel : value label  `RowVar'
	local RowLabel: label `RowValueLabel' `sec'
	local awc = "`=awc_name[`row']'"  // takes value label number
	local awcValueLabel : value label  awc_name
	local awcLabel: label `awcValueLabel' `awc'

* define rows 
	putdocx table `TableNum'(`i',1) = ("`RowLabel'") 
    putdocx table `TableNum'(`i',2) = ("`awcLabel'") 
	sum awc_target if casenum ==`row', mean
    putdocx table `TableNum'(`i',3) = (r(mean)), nformat(%5.0f) halign(center)
	sum awc_reg if casenum ==`row', mean
    putdocx table `TableNum'(`i',4) = (r(mean)), nformat(%5.0f) halign(center)
	sum awc_notmaln if casenum ==`row', mean
    putdocx table `TableNum'(`i',5) = (r(mean)), nformat(%5.1f) halign(center)
	sum awc_composite if casenum ==`row', mean
	putdocx table `TableNum'(`i',6) = (r(mean)), nformat(%5.1f) halign(center)
}
restore

putdocx paragraph, halign(left) spacing(line,8 pt)
putdocx text ("Note: Composite score is based on: ")
putdocx paragraph, halign(left) spacing(line,8 pt)
putdocx text ("		the target number divided by 200 (max 100%). One AWC is planned for 1,000 population or every 200 children under-five.")
putdocx paragraph, halign(left) spacing(line,8 pt)
putdocx text ("		the coverage rate (number of children registered/ number of children in coverage area). AWC with <30 children are excluded")
putdocx paragraph, halign(left) spacing(line,8 pt)
putdocx text ("		the prevalence of children under-five not malnourished. Not malnourished is not stunted wasted or underweight")


* Poor Performing AWC
preserve

egen uniq = tag(awc_num)
drop if uniq!= 1

drop if awc_target<30
gsort awc_composite -awc_target 
list sector awc_name awc_target awc_reg awc_notmaln awc_composite in 1/20
cap drop casenum
gen casenum = _n
drop if casenum >20

* create table and putdocx from 1/20
local TableName = "Poor Performing AWC"
local TableNum = "table16"
* How many rows to use for RowVar / 20 + 3: table title header note
local RowCount = 23

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) 
putdocx table `TableNum'(1,1)=("Table 16: `TableName' by composite score"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("AWC Name"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Target #"), bold halign(center)
putdocx table `TableNum'(2,4) = ("# Registered"), bold halign(center)
putdocx table `TableNum'(2,5) = ("% Non-malnourished"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Composite Score"), bold halign(center)

forval row = 1/20 {
	local i = `row'+2

	local sec = "`=`RowVar'[`row']'"  // takes value label number
	local RowValueLabel : value label  `RowVar'
	local RowLabel: label `RowValueLabel' `sec'
	local awc = "`=awc_name[`row']'"  // takes value label number
	local awcValueLabel : value label  awc_name
	local awcLabel: label `awcValueLabel' `awc'
	
	* define rows 
	putdocx table `TableNum'(`i',1) = ("`RowLabel'") 
    putdocx table `TableNum'(`i',2) = ("`awcLabel'") 
	sum awc_target if casenum ==`row', mean
    putdocx table `TableNum'(`i',3) = (r(mean)), nformat(%5.0f) halign(center)
	sum awc_reg if casenum ==`row', mean
    putdocx table `TableNum'(`i',4) = (r(mean)), nformat(%5.0f) halign(center)
	sum awc_notmaln if casenum ==`row', mean
    putdocx table `TableNum'(`i',5) = (r(mean)), nformat(%5.1f) halign(center)
	sum awc_composite if casenum ==`row', mean
	putdocx table `TableNum'(`i',6) = (r(mean)), nformat(%5.1f) halign(center)
}
restore

putdocx paragraph, halign(left) spacing(line,8 pt)
putdocx text ("Note: Composite score is based on: ")
putdocx paragraph, halign(left) spacing(line,8 pt)
putdocx text ("		the target number divided by 200 (max 100%). One AWC is planned for 1,000 population or every 200 children under-five.")
putdocx paragraph, halign(left) spacing(line,8 pt)
putdocx text ("		the coverage rate (number of children registered/ number of children in coverage area). AWC with <30 children are excluded")
putdocx paragraph, halign(left) spacing(line,8 pt)
putdocx text ("		the prevalence of children under-five not malnourished. Not malnourished is not stunted wasted or underweight")


putdocx save test, append
// putdocx save "`FileName'", append
putdocx begin, font("Calibri", 10)


use "$data\CH_WT_2021_Complete.dta", clear

// Data quality analysis based on 
// •	Missing children / heaped children on age in months
// •	Digit preference in height and weight
// •	Correct application of measure (length / height)
// •	WHZ HAZ standard deviations, skewness kurtosis
// •	Month of Birth and Month after completed year biases

*  STUNTING
twoway kdensity haz ||   ///
	function normal=normalden(x,0,1), range(-6 6) xla(-6(1)6) lw(thin)  ///
	legend(order( 1 "Chattisgarrh" 2 "Normal") ///
	col(1) pos(2) ring(0) nobox region(lstyle(none))) ///
	title("Distribution of HAZ-scores - Under 5 year olds")

*  WASTING
twoway kdensity whz ||   ///
	function normal=normalden(x,0,1), range(-6 6) xla(-6(1)6) lw(thin)  ///
	legend(order( 1 "Chattisgarrh" 2 "Normal") ///
	col(1) pos(2) ring(0) nobox region(lstyle(none))) ///
	title("Distribution of WHZ-scores - Under 5 year olds")

*  UNDERWEIGHT
twoway kdensity waz ||   ///
	function normal=normalden(x,0,1), range(-6 6) xla(-6(1)6) lw(thin)  ///
	legend(order( 1 "Chattisgarrh" 2 "Normal") ///
	col(1) pos(2) ring(0) nobox region(lstyle(none))) ///
	title("Distribution of WAZ-scores - Under 5 year olds")
	
// *  UNDERWEIGHT by district (multiple graphs)
// twoway kdensity waz, by(dist_id) ||   ///
// 	function normal=normalden(x,0,1), range(-6 6) xla(-6(1)6) lw(thin)  ///
// 	legend(order( 1 "District" 2 "Normal") ///
// 	col(2) pos(2) ring(0) nobox region(lstyle(none))) ///
// 	title("`: var label dist_name'")

// cap drop count_waz
// bysort waz: egen count_waz = count(waz) 
// twoway line count_waz waz, ytitle("count") title("Heaping in WAZ - Chattisgarrh") 

// set more on
// levelsof dist_id, local(districts)
// foreach d of local districts {
// 	cap drop count_hgt
// 	bysort hgt: egen count_hgt = count(hgt) if dist_id==`d'
// 	twoway line count_hgt hgt if dist_id==`d', ytitle("count") title("Heaping in Height by age in months") 
// 	more
// }
	
	


* Rounding / heaping in height
* Rounded to CM
cap drop count_hgt
bysort hgt: egen count_hgt = count(hgt) 
twoway line count_hgt hgt, ytitle("count") title("Heaping in height by age in months - Chattisgarrh") 
tab hgt if count_hgt > 50000

* Rounding / heaping in weight
* Rounded 
cap drop count_wgt
bysort wgt: egen count_wgt = count(wgt) 
twoway line count_wgt wgt, ytitle("count") title("Heaping in weight by age in months - Chattisgarrh") 
tab wgt if count_wgt > 21000



* WAZ-scores
cap drop count_waz
bysort waz: egen count_waz = count(waz) 
twoway line count_waz waz, ytitle("count") xline(-2) title("Heaping in waz by age in months - Chattisgarrh") 

// * Balrampur
// cap drop count_wgt
// bysort wgt: egen count_wgt = count(wgt) if district==3
// twoway line count_wgt wgt, ytitle("count") title("Heaping in weight by age in months - Balrampur") 
//
// * Balrampur
// cap drop count_waz
// bysort waz: egen count_waz = count(waz) if district==3
// twoway line count_waz waz, ytitle("count") xline(-2) title("Heaping in waz by age in months - Balrampur") 

// twoway kdensity waz if district==3 ||   ///
// 	function normal=normalden(x,0,1), range(-6 6) xla(-6(1)6) lw(thin)  ///
// 	legend(order( 1 "Balrampur" 2 "Normal") ///
// 	col(1) pos(2) ring(0) nobox region(lstyle(none))) ///
// 	title("Distribution of WAZ-scores - Under 5 year olds")
	
*Where has the most distortion been added to WAZ. 


putdocx save test, append
// putdocx save "`FileName'", append
putdocx begin, font("Calibri", 10)


* Tables mean SD, skewness, kurtosis 

* Height for Age (HAZ)
local TableNum = "table14"
local RowVar = "district"
local var = "haz"
* How many rows to use for RowVar / number of districts + 4: title, header, space and overall*
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents)
putdocx table `TableNum'(1,1)=("Table 14: Height for Age (HAZ) Mean, Standard Deviation, Skewness and Kurtosis by district"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("Mean"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Standard Deviation"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Skewness"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Kurtosis"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'

	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	quietly summarize `var' if `RowVar'==`row', detail
    putdocx table `TableNum'(`i',2) = (r(mean)), nformat(%5.2f) halign(center)
    putdocx table `TableNum'(`i',3) = (r(sd)), nformat(%5.2f) halign(center)
    putdocx table `TableNum'(`i',4) = (r(skewness)), nformat(%5.2f) halign(center)
	* adjust kurtosis to zero scale
	local kurt = (r(kurtosis))-3
	putdocx table `TableNum'(`i',5) = (`kurt'), nformat(%5.2f) halign(center)
	putdocx table `TableNum'(`i',6) = (r(N)), nformat(%16.0gc) halign(center)
}
* Add totals
putdocx table `TableNum'(`RowCount',1) = ("Overall")
quietly summarize `var' , detail
putdocx table `TableNum'(`RowCount',2) = (r(mean)), nformat(%5.2f) halign(center)
putdocx table `TableNum'(`RowCount',3) = (r(sd)), nformat(%5.2f) halign(center)
putdocx table `TableNum'(`RowCount',4) = (r(skewness)), nformat(%5.2f) halign(center)
local kurt = (r(kurtosis))-3
putdocx table `TableNum'(`RowCount',5) = (`kurt'), nformat(%5.2f) halign(center)
putdocx table `TableNum'(`RowCount',6) = (r(N)), nformat(%16.0gc) halign(center)

putdocx textblock begin
Standard Dev HAZ
•	<1.5  Acceptable
•	>=1.5 Poor Data Quality
Skewness  
•	<0.6  Acceptable 
•	>=0.6 Poor Data Quality
Kurtosis 
•	<0.6  Acceptable 
•	>=0.6 Poor Data Quality
putdocx textblock end



*Weight for Height (WHZ)
local TableNum = "table15"
local RowVar = "district"
local var = "whz"
* How many rows to use for RowVar / number of districts + 4: title, header, space and overall*
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents)
putdocx table `TableNum'(1,1)=("Table 15: Weight for Height (WHZ) Mean, Standard Deviation, Skewness and Kurtosis by district"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("Mean"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Standard Deviation"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Skewness"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Kurtosis"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'

	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	quietly summarize `var' if `RowVar'==`row', detail
    putdocx table `TableNum'(`i',2) = (r(mean)), nformat(%5.2f) halign(center)
    putdocx table `TableNum'(`i',3) = (r(sd)), nformat(%5.2f) halign(center)
    putdocx table `TableNum'(`i',4) = (r(skewness)), nformat(%5.2f) halign(center)
	* adjust kurtosis to zero scale
	local kurt = (r(kurtosis))-3
	putdocx table `TableNum'(`i',5) = (`kurt'), nformat(%5.2f) halign(center)
	putdocx table `TableNum'(`i',6) = (r(N)), nformat(%16.0gc) halign(center)
}
* Add totals
putdocx table `TableNum'(`RowCount',1) = ("Overall")
quietly summarize `var' , detail
putdocx table `TableNum'(`RowCount',2) = (r(mean)), nformat(%5.2f) halign(center)
putdocx table `TableNum'(`RowCount',3) = (r(sd)), nformat(%5.2f) halign(center)
putdocx table `TableNum'(`RowCount',4) = (r(skewness)), nformat(%5.2f) halign(center)
local kurt = (r(kurtosis))-3
putdocx table `TableNum'(`RowCount',5) = (`kurt'), nformat(%5.2f) halign(center)
putdocx table `TableNum'(`RowCount',6) = (r(N)), nformat(%16.0gc) halign(center)

putdocx textblock begin
Standard Dev WHZ
•	<1.2  Acceptable
•	>=1.2 Poor Data Quality
Skewness  
•	<0.6  Acceptable 
•	>=0.6 Poor Data Quality
Kurtosis 
•	<0.6  Acceptable 
•	>=0.6 Poor Data Quality
putdocx textblock end
	

	
	
	
* Weight for Age (WAZ)	
local TableNum = "table16"
local RowVar = "district"
local var = "waz"
* How many rows to use for RowVar / number of districts + 4: title, header, space and overall*
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents)
putdocx table `TableNum'(1,1)=("Table 16: Weight for Age (WAZ) Mean, Standard Deviation, Skewness and Kurtosis by district"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("Mean"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Standard Deviation"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Skewness"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Kurtosis"), bold halign(center)
putdocx table `TableNum'(2,6) = ("N"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'

	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	quietly summarize `var' if `RowVar'==`row', detail
    putdocx table `TableNum'(`i',2) = (r(mean)), nformat(%5.2f) halign(center)
    putdocx table `TableNum'(`i',3) = (r(sd)), nformat(%5.2f) halign(center)
    putdocx table `TableNum'(`i',4) = (r(skewness)), nformat(%5.2f) halign(center)
	* adjust kurtosis to zero scale
	local kurt = (r(kurtosis))-3
	putdocx table `TableNum'(`i',5) = (`kurt'), nformat(%5.2f) halign(center)
	putdocx table `TableNum'(`i',6) = (r(N)), nformat(%16.0gc) halign(center)
}
* Add totals
putdocx table `TableNum'(`RowCount',1) = ("Overall")
quietly summarize `var' , detail
putdocx table `TableNum'(`RowCount',2) = (r(mean)), nformat(%5.2f) halign(center)
putdocx table `TableNum'(`RowCount',3) = (r(sd)), nformat(%5.2f) halign(center)
putdocx table `TableNum'(`RowCount',4) = (r(skewness)), nformat(%5.2f) halign(center)
local kurt = (r(kurtosis))-3
putdocx table `TableNum'(`RowCount',5) = (`kurt'), nformat(%5.2f) halign(center)
putdocx table `TableNum'(`RowCount',6) = (r(N)), nformat(%16.0gc) halign(center)
	
putdocx textblock begin
Standard Dev WAZ
•	<1.2  Acceptable
•	>=1.2 Poor Data Quality
Skewness  
•	<0.6  Acceptable 
•	>=0.6 Poor Data Quality
Kurtosis 
•	<0.6  Acceptable 
•	>=0.6 Poor Data Quality
putdocx textblock end
	
putdocx save test, append
// putdocx save "`FileName'", append
putdocx begin, font("Calibri", 10)







//
// local RowVar = "district"   
// tabstat haz , by (`RowVar') stats(mean sd sk k N) save
// mat haz_matrix = r(StatTotal)'
// putdocx table haz_table = matrix(haz_matrix) , rownames colnames
//
// tabstat whz , by (`RowVar') stats(mean sd sk k N) save
// mat whz_matrix = r(StatTotal)'
// putdocx table whz_table = matrix(whz_matrix) , rownames colnames
//
// tabstat waz , by (`RowVar') stats(mean sd sk k N) save
// mat waz_matrix = r(StatTotal)'
// putdocx table waz_table = matrix(waz_matrix) , rownames colnames



   
   
* Mason's analysis of errors in measure - Ethiopia analysis
cap drop meanlgt meanhgt
* Recumbent length
egen meanlgt = mean(hgt) if measure==1, by(agemos)
egen countlgt = count(hgt) if measure==1, by(agemos)
replace meanlgt = . if countlgt<30
* Standing height
egen meanhgt = mean(hgt) if measure==2, by(agemos)
egen counthgt = count(hgt) if measure==2, by(agemos)
replace meanhgt = . if counthgt<30

sort agemos
*line meanlgt agemos  || line meanhgt agemos 
*line meanlgt agemos if agemos>11 & agemos<36 || line meanhgt agemos if agemos>11 & agemos<36
graph twoway (lpolyci meanlgt agemos if agemos>11 & agemos<36) (lpolyci meanhgt agemos if agemos>11 & agemos<36)

preserve
collapse (mean) meanlgt meanhgt, by(agemos)
gen meanhgtdiff = meanhgt-meanlgt  if agemos>11 & agemos<36
replace meanhgtdiff=. if meanhgtdiff<0
sum meanhgtdiff
local mean =round(r(mean), .01)
local y = `mean' + 0.05

twoway lpoly meanhgtdiff agemos, ysc(r(0.7)) ylabel(0(.1).7)  ///
	yline(0.7, lpattern("_") lcolor(blue)) text(0.65 20 "Expected difference height/length = 0.7", place(e)) ///
	yline(`mean', lpattern("_") lcolor(red)) text(`y' 20 "Difference height/length = `mean'", place(e)) ///
    ytitle("cm") xtitle("age in months") title("Difference between height and length measures") 

restore

tab correct_measure, m 
recode correct_measure (1=100)(0=0)

* Define variables for table
local TableName = "Correct Measure"
local TableNum = "table13"
local var = "correct_measure"
local RowVar = "district"

* How many rows to use for RowVar / number of districts + 3: one for the header, one for the footer (notes) and the other for the table title *
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

putdocx table `TableNum' = (`RowCount',3), border(all, nil) width(90%) layout(autofitcontents) note(Note: ///
	Correct measure length <24 months & height 24+ months)
putdocx table `TableNum'(1,1)=("`TableName' of height measures by District"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("District"), bold 
putdocx table `TableNum'(2,2) = ("`TableName'"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count `TableName'"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
// 	local RowValueLabelNum = word("`RowLevels'", `row')
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'

	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	quietly summarize `var' if district==`row'
    putdocx table `TableNum'(`i',2) = (r(mean)), nformat(%5.1f) halign(center)
    putdocx table `TableNum'(`i',3) = (r(N)), nformat(%16.0gc) halign(center)

}
 * add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
quietly summarize `var' 
putdocx table `TableNum'(`RowCount',2) = (r(mean)), nformat(%5.1f) halign(center)
putdocx table `TableNum'(`RowCount',3) = (r(N)), nformat(%16.0gc) halign(center)

putdocx save test, append
putdocx begin, font("Calibri", 10)

* Month of Birth
gen mob = month(birthdate)
* Change numbers to month names
label define m12 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "Mar" 6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label val mob m12 
label var mob "Month of Birth"
tab mob, m 
graph bar (mean) haz, over(mob) title("Mean HAZ score by month of birth") 
// graph bar (mean) haz, over(mob) by(dist_id)
*At August months there is a hiccup

* Controlling for the rounded age bias. 
gen months_after_year = mod(agemos,12)
tab months_after_year
label var mob "Month number after complete year"
graph bar (mean) haz, over(months_after_year) title("Mean HAZ score by month after completed year") 
graph bar (mean) haz if agemos>=12, over(months_after_year)
* reset at 6 

putdocx save test, append
// putdocx save "`FileName'", append


End of File

-------------------------



putdocx table data = data(make price mpg rep78) if foreign==1, title(Foreign cars.) obsno varnames



tabstat haz , by (dist_id) stats(mean sd sk k N) save
mat my_matrix = r(StatTotal)'
putdocx table my_table = matrix(my_matrix), rownames colnames



cap drop count_haz
bysort haz: egen count_haz = count(haz) 
twoway line count_haz haz, ytitle("count") title("Heaping in HAZ - Balod District") 
 
 cap drop count_whz
bysort whz: egen count_whz = count(whz) 
twoway line count_whz whz, ytitle("count") title("Heaping in WHZ - Chattisgarrh") 
tab count_whz if count_whz>8000
* heaping at -.99
scatter wgt hgt if count_whz<=12000 || scatter wgt hgt if count_whz>12000 
* no obvious pattern
 
 
 