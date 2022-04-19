* IYCF REPORT 
* NFHS-4
* Dec 2021
* RJ

* Add dependencies
* this code uses IYCF vars from NFHS-4 data which are created in in make vars do file

* undercase variables come from datasets
* Camelcase vars are created in the code - used in code and dropped

* path for saving reports / graphs
*cd "C:/IYCF"
cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"

* data

 use "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged\iycf_NFHS4.dta", clear

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
cap label drop sector                                          
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
putdocx text ("NFHS-4 IYCF REPORT")
putdocx paragraph, style(Title) halign(center) spacing(line,16 pt)
putdocx text ("Analysis by Region and Socio-Demographic Indicators")
putdocx paragraph, style(Heading2) halign(center)
putdocx text ("Date of NFHS-4 Data Collection: Dec 2005 to May 2006 ")

putdocx pagebreak

// 1. Breastfeeding indicators 
// 1.1. Ever breastfed (EvBF) 
// 1.2. Early initiation of breastfeeding (EIBF) 
// 1.3. Exclusively breastfed for the first two days after birth (EBF2D) 
// 1.4. Exclusive breastfeeding under six months (EBF) 
// 1.5. Mixed milk feeding under six months (MixMF) 
// 1.6. Continued breastfeeding 12–23 months (CBF) 



putdocx paragraph, style(Title) halign(left) spacing(line,16 pt)
putdocx text ("1. Breastfeeding Indicators")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("1.1. Ever breastfed (EvBF)")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("1.2. Early initiation of breastfeeding (EIBF)")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("1.3. Exclusively breastfed for the first two days after birth (EBF2D)")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("1.4. Exclusive breastfeeding under six months (EBF)")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("1.5. Mixed milk feeding under six months (MixMF)")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("1.6. Continued breastfeeding 12–23 months (CBF)")
putdocx pagebreak


***********************************
// 1.1. Ever breastfed (EvBF) 
putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("1.1 Ever Breastfed by region level variables")

* Define variables for table
local TableName = "Ever Breastfed (EvBF)"
local TableNum = "table1"
local var1 = "evbf" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.1: Percentage  `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, replace 
*------------------------------------------------------------------------------------*
//1.1.(a) EVBF variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* Variable by Caste 
local TableName = "Ever breastfed by caste"
local TableNum = "table2"
local Var = "evbf"
local RowVar = "region"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (a): Percentage `TableName' in children under two years by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//1.1 (b) Ever breastfed indicator w.r.t mothers education
*-----------------------------------------------------------------------------------
putdocx begin, font("Calibri", 9)

local TableName = "Ever breastfed by mother's schooling"
local TableNum = "table3"
local Var = "evbf" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1(b): Percentage `TableName' in children under two years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append




*------------------------------------------------------------------------------------*
// 1.1 (c) Ever breastfed indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf2d by mumeduc 
local TableName = "ExBF for first two days (EBF2D) by wealth index"
local TableNum = "table4"
local Var = "evbf" 
local RowVar = "region"
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


putdocx save iycf_NFHS-4_region, append









*------------------------------------------------------------------------------------*
// 1.1.(d) Ever breastfed indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* EVBF by mumeduc 
local TableName = "Ever breastfed by sex of child"
local TableNum = "table4"
local Var = "evbf" 
local RowVar = "region"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (d): Percentage `TableName' in children under two years by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 1.1 (e) Ever breastfed indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* EVBF by mumeduc 
local TableName = "Ever breastfed by residence (urban/rural)"
local TableNum = "table4"
local Var = "evbf" 
local RowVar = "region"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (e): Percentage `TableName' in children under two years by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.1 (f) Ever breastfed indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Ever breastfed by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "evbf" 
local RowVar = "region"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (f): Percentage `TableName' in children under two years by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 1.1 (g) Ever breastfed indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* EVBF by ANC4Plus 
local TableName = "Ever breastfed by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "evbf" 
local RowVar = "region"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (g): Percentage `TableName' in children under two years by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 1.1 (h) Ever breastfed indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* EVBF by mumeduc 
local TableName = "Ever breastfed by C-Section"
local TableNum = "table4"
local Var = "evbf" 
local RowVar = "region"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.1 (h): Percentage `TableName' in children under two years by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

****************************************************************************************************************************
****************************************************************************************************************************

*1.2. Early initiation of breastfeeding (EIBF) 				**
**************************************************************
putdocx begin, font("Calibri", 9)

putdocx pagebreak
putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("1.2 Early initiation of breastfeeding (EIBF) by region level variables")
* Define variables for table
local TableName = "Early initiation of breastfeeding (EIBF)"
local TableNum = "table1"
local var1 = "eibf" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.2: Percentage  `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append 
*------------------------------------------------------------------------------------*
//1.2(a) Early initiation of breastfeeding variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Early initiation of breastfeeding by caste"
local TableNum = "table2"
local Var = "eibf" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//1.2 (b) Early initiation of breastfeeding indicator w.r.t mothers education
*------------------------------------------------------------------------------------
putdocx begin, font("Calibri", 9)

local TableName = "Early initiation of breastfeeding by mother's education"
local TableNum = "table3"
local Var = "eibf" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.2(b): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------*
// 1.2 (c) Early initiation of breastfeeding indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* eibf by mumeduc 
local TableName = "Early initiation of breastfeeding by wealth index"
local TableNum = "table4"
local Var = "eibf" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.2.(d) Early initiation of breastfeeding indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* eibf by mumeduc 
local TableName = "Early initiation of breastfeeding by sex of child"
local TableNum = "table4"
local Var = "eibf" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 1.2 (e) Early initiation of breastfeeding indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* eibf by mumeduc 
local TableName = "Early initiation of breastfeeding by residence (urban/rural)"
local TableNum = "table4"
local Var = "eibf" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.2 (f) Early initiation of breastfeeding indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Early initiation of breastfeeding by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "eibf" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 1.2 (g) Early initiation of breastfeeding indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* eibf by ANC4Plus 
local TableName = "Early initiation of breastfeeding by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "eibf" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 1.2 (h) Early initiation of breastfeeding indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* eibf by mumeduc 
local TableName = "Early initiation of breastfeeding by C-Section"
local TableNum = "table4"
local Var = "eibf" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append







****************************************************************************************************************************
****************************************************************************************************************************

*1.3. Exclusively breastfed for the first two days after birth (EBF2D) 				**
**************************************************************
putdocx begin, font("Calibri", 9)

putdocx pagebreak
putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("1.3 Exclusively breastfed for the first two days after birth (EBF2D) by region level variables")
* Define variables for table
local TableName = "ExBF for first two days (EBF2D)"
local TableNum = "table1"
local var1 = "ebf2d" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.3: Percentage `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append


*Tables of ebf2d is not significant w.r.t regions 

*------------------------------------------------------------------------------------*
//1.3(a) Exclusively breastfed for the first two days after birth (EBF2D)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "ExBF for first two days (EBF2D) by caste"
local TableNum = "table2"
local Var = "ebf2d" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//1.3 (b) ExBF for first two days (EBF2D) indicator w.r.t mothers education
*------------------------------------------------------------------------------------

putdocx begin, font("Calibri", 9)

local TableName = "ExBF for first two days (EBF2D) indicator by mother's education"
local TableNum = "table3"
local Var = "ebf2d" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.3(b): Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------*
// 1.3 (c) ExBF for first two days (EBF2D) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf2d by mumeduc 
local TableName = "ExBF for first two days (EBF2D) by wealth index"
local TableNum = "table4"
local Var = "ebf2d" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.3(d) ExBF for first two days (EBF2D) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf2d by mumeduc 
local TableName = "ExBF for first two days (EBF2D) by sex of child"
local TableNum = "table4"
local Var = "ebf2d" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 1.3 (e) ExBF for first two days (EBF2D) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf2d by mumeduc 
local TableName = "ExBF for first two days (EBF2D) by residence (urban/rural)"
local TableNum = "table4"
local Var = "ebf2d" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.3 (f) ExBF for first two days (EBF2D) indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "ExBF for first two days (EBF2D) by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "ebf2d" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.3 (g) ExBF for first two days (EBF2D) indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf2d by ANC4Plus 
local TableName = "ExBF for first two days (EBF2D) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "ebf2d" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 1.3 (h) ExBF for first two days (EBF2D) indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf2d by mumeduc 
local TableName = "ExBF for first two days (EBF2D) by C-Section"
local TableNum = "table4"
local Var = "ebf2d" 
local RowVar = "region"
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

putdocx save iycf_NFHS-4_region, append


****************************************************************************************************************************
****************************************************************************************************************************

*1.4. Exclusive breastfeeding under six months (EBF) 		**
**************************************************************
putdocx begin, font("Calibri", 9)
putdocx pagebreak
putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("1.4 Exclusive breastfeeding under six months (EBF) by region level variables")
* Define variables for table
local TableName = "Exclusive breastfeeding under 6 months (EBF)"
local TableNum = "table1"
local var1 = "ebf" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.4: Percentage `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append 
*------------------------------------------------------------------------------------*
//1.4(a) Exclusive breastfeeding under 6 months (EBF) variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Exclusive breastfeeding (EBF) by caste"
local TableNum = "table2"
local Var = "ebf" 
local RowVar = "region"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (a): Percentage `TableName' in children under six months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//1.4 (b) Exclusive breastfeeding under 6 months (EBF) indicator w.r.t mothers education
*------------------------------------------------------------------------------------

putdocx begin, font("Calibri", 9)
local TableName = "Exclusive breastfeeding (EBF) by mother's education"
local TableNum = "table3"
local Var = "ebf" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4(b): Percentage `TableName' in children under six months by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 1.4 (c) Exclusive breastfeeding under 6 months (EBF) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf by mumeduc 
local TableName = "Exclusive breastfeeding (EBF) by wealth index"
local TableNum = "table4"
local Var = "ebf" 
local RowVar = "region"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (c): Percentage `TableName' in children under six months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.4(d) Exclusive breastfeeding under 6 months (EBF) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf by mumeduc 
local TableName = "Exclusive breastfeeding (EBF) by sex of child"
local TableNum = "table4"
local Var = "ebf" 
local RowVar = "region"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (d): Percentage `TableName' in children under six months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 1.4 (e) Exclusive breastfeeding under 6 months (EBF) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf by mumeduc 
local TableName = "Exclusive breastfeeding (EBF) by residence (urban/rural)"
local TableNum = "table4"
local Var = "ebf" 
local RowVar = "region"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (e): Percentage `TableName' in children under six months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.4 (f) Exclusive breastfeeding under 6 months (EBF) indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Exclusive breastfeeding (EBF) by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "ebf" 
local RowVar = "region"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (f): Percentage `TableName' in children under 6 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 1.4 (g) Exclusive breastfeeding under 6 months (EBF) indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Exclusive breastfeeding (EBF) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "ebf" 
local RowVar = "region"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (g): Percentage `TableName' in children under 6 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 1.4 (h) Exclusive breastfeeding under 6 months (EBF) indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* ebf by mumeduc 
local TableName = "Exclusive breastfeeding (EBF) by C-Section"
local TableNum = "table4"
local Var = "ebf" 
local RowVar = "region"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.4 (h): Percentage `TableName' in children under 6 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

****************************************************************************************************************************
* AREA GRAPH
****************************************

preserve   //to preserve and restore the variables
*Variable for breastfeeding area graph
**
cap drop diet
gen diet=9
replace diet=1 if currently_bf==1 
replace diet=2 if currently_bf==1 & water==1 
replace diet=3 if currently_bf==1 & other_liq==1 
replace diet=3 if currently_bf==1 & juice==1 
*replace diet=3 if currently_bf==1 & broth==1 
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
	 
graph export bfgraph.png, replace
 
 
* to put graphs in document
putdocx begin, font("Calibri", 9)
putdocx pagebreak
putdocx paragraph, style(Title)
putdocx text ("Breastfeeding area graph")
putdocx paragraph, halign(center)
putdocx image bfgraph.png, linebreak(1)
putdocx paragraph, style(Heading2)
putdocx text ("Figure 1: Breastfeeding w.r.t age in months area graph (NFHS-4 2016-18)")
putdocx paragraph, halign(center)
*putdocx text ("In the age in months graph, all ages should be evenly distributed. There should not be heaping or excessive counts of children on ages rounded to full years or half years.")
putdocx save iycf_NFHS-4_region, append
* see svedberg2.do for area graph 
**
restore  // restore to prior data
	

****************************************************************************************************************************

*1.5. Mixed milk feeding under six months (MixMF) 		**
**************************************************************
putdocx begin, font("Calibri", 9)
putdocx pagebreak
putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("1.5 Mixed milk feeding under six months (MixMF) by region level variables")

* Define variables for table
local TableName = "Mixed_milk feeding under 6 months (MixMF)"
local TableNum = "table1"
local var1 = "mixed_milk" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.5: Percentage `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append 
*------------------------------------------------------------------------------------*
//1.5(a) Mixed_milk feeding under 6 months (MixMF) variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* Variable by Caste 
local TableName = "Mixed_milk feeding (MixMF) by caste"
local TableNum = "table2"
local Var = "mixed_milk" 
local RowVar = "region"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (a): Percentage `TableName' in children under 6 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------
//1.5 (b) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t mothers education
*------------------------------------------------------------------------------------

putdocx begin, font("Calibri",9)

local TableName = "Mixed_milk feeding (MixMF) by mother's education"
local TableNum = "table3"
local Var = "mixed_milk" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5(b): Percentage `TableName' in children under 6 months by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------*
// 1.5 (c) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* mixed_milk by mumeduc 
local TableName = "Mixed_milk feeding (MixMF)"
local TableNum = "table4"
local Var = "mixed_milk" 
local RowVar = "region"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (c): Percentage `TableName' in children under 6 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.5(d) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* mixed_milk by mumeduc 
local TableName = "Mixed_milk feeding (MixMF) by sex of child"
local TableNum = "table4"
local Var = "mixed_milk" 
local RowVar = "region"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (d): Percentage `TableName' in children under 6 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 1.5 (e) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* mixed_milk by mumeduc 
local TableName = "Mixed_milk feeding (MixMF) by residence (urban/rural)"
local TableNum = "table4"
local Var = "mixed_milk" 
local RowVar = "region"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (e): Percentage `TableName' in children under 6 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.5 (f) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Mixed_milk feeding (MixMF) by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "mixed_milk" 
local RowVar = "region"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (f): Percentage `TableName' in children under 6 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 1.5 (g) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* mixed_milk by ANC4Plus 
local TableName = "Mixed_milk feeding (MixMF) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "mixed_milk" 
local RowVar = "region"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (g): Percentage `TableName' in children under 6 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 1.5 (h) Mixed_milk feeding under 6 months (MixMF) indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* mixed_milk by mumeduc 
local TableName = "Mixed_milk feeding (MixMF) by C-Section"
local TableNum = "table4"
local Var = "mixed_milk" 
local RowVar = "region"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.5 (h): Percentage `TableName' in children under 6 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*********************************************************************************
* Bottle feeding by age in months
*********************************************************************************

graph twoway (lpoly bottle agemos if agemos>0, lcolor(red) degree(1)  ///
	legend(rows(1) order(1 "Bottle Feeding")) ///
	xlabel(0(3)60) xtitle("Age in Months") ytitle("x100 %") title("Bottle feeding by age in months"))
	
graph export malnutrition_agemos.tif, as(tif) replace

**********insert graph in document**********
putdocx begin, font("Calibri",9)

putdocx pagebreak
putdocx paragraph, style(Title)
putdocx text ("Bottle feeding w.r.t age in months (NFHS-4 2005-06)")
putdocx paragraph, halign(center)
putdocx image malnutrition_agemos.tif, linebreak(1)
putdocx paragraph, style(Heading2)
putdocx text ("Figure 2: Bottle Feeding (did child drink anything from bottle) w.r.t age in months (NFHS-4 2005-06)")
putdocx paragraph, halign(center)

putdocx save iycf_NFHS-4_region, append




****************************************************************************************************************************
****************************************************************************************************************************

*1.6. Continued breastfeeding 12–23 months (CBF) 		**
**************************************************************
putdocx begin, font("Calibri", 9)
putdocx pagebreak
putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("1.6. Continued breastfeeding (CBF) in children of 12–23 months by region level variables")

* Define variables for table
local TableName = "Continued breastfeeding (CBF) in children of 12–23 months"
local TableNum = "table1"
local var1 = "cont_bf_12_23" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 1.6: Percentage `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append 
*------------------------------------------------------------------------------------*
//1.6(a) Continued_bf 12–23 months (CBF) variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Continued breastfeeding (CBF) in children of 12–23 months by caste"
local TableNum = "table2"
local Var = "cont_bf_12_23" 
local RowVar = "region"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (a): Percentage `TableName' `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//1.6 (b) Continued_bf 12–23 months (CBF) indicator w.r.t mothers education
*------------------------------------------------------------------------------------

putdocx begin, font("Calibri", 9)

local TableName = "Continued breastfeeding (CBF) in children of 12–23 months by mother's education"
local TableNum = "table3"
local Var = "cont_bf_12_23" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6(b): Percentage `TableName' by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------*
// 1.6 (c) Continued_bf 12–23 months (CBF) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* cont_bf_12_23 by mumeduc 
local TableName = "Continued breastfeeding (CBF) in children of 12–23 months by wealth index"
local TableNum = "table4"
local Var = "cont_bf_12_23" 
local RowVar = "region"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (c): Percentage `TableName' by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.6(d) Continued_bf 12–23 months (CBF) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* cont_bf_12_23 by mumeduc 
local TableName = "Continued breastfeeding (CBF) in children of 12–23 months by sex of child"
local TableNum = "table4"
local Var = "cont_bf_12_23" 
local RowVar = "region"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (d): Percentage `TableName' by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 1.6 (e) Continued_bf 12–23 months (CBF) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* cont_bf_12_23 by mumeduc 
local TableName = "Continued breastfeeding (CBF) in children of 12–23 months by residence (urban/rural)"
local TableNum = "table4"
local Var = "cont_bf_12_23" 
local RowVar = "region"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (e): Percentage `TableName' by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 1.6 (f) Continued_bf 12–23 months (CBF) indicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Continued breastfeeding (CBF) in children of 12–23 months by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "cont_bf_12_23" 
local RowVar = "region"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (f): Percentage `TableName' by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 1.6 (g) Continued_bf 12–23 months (CBF) indicator w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* cont_bf_12_23 by ANC4Plus 
local TableName = "Continued breastfeeding (CBF) in children of 12–23 months by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "cont_bf_12_23" 
local RowVar = "region"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (g): Percentage `TableName' by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 1.6 (h) Continued_bf 12–23 months (CBF) indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

* cont_bf_12_23 by mumeduc 
local TableName = "Continued breastfeeding (CBF) in children of 12–23 months by C-Section"
local TableNum = "table4"
local Var = "cont_bf_12_23" 
local RowVar = "region"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 1.6 (h): Percentage `TableName' by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



**********************************************************************************************************
putdocx begin, font("Calibri", 9)
putdocx pagebreak
putdocx paragraph, style(Title) halign(center) spacing(line,16 pt)
putdocx text ("2. Complementary Feeding Indicators")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("2.1 Introduction of solid, semi-solid or soft foods in children under 6–8 months (ISSSF)")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("2.2. Minimum dietary diversity in children under 6–23 months (MDD)")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("2.3. Minimum meal frequency in children under 6–23 months (MMF) ")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("2.4. Minimum milk feeding frequency for non-breastfed children under 6–23 months (MMFF) ")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("2.5. Minimum acceptable diet in children under 6–23 months (MAD)")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text ("2.6. Egg and/or flesh food consumption in children under 6–23 months (EFF)")
putdocx paragraph, style(Heading2) halign(left) spacing(line,16 pt)
putdocx text (" 2.9. Zero vegetable or fruit consumption in children under 6–23 months (ZVF)")
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

putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("2.1 Introduction of solid, semi-solid or soft foods 6–8 months (ISSSF) by region level variables")

local TableName = "Introduction of solid, semi-solid or soft foods (ISSSF)"
local TableNum = "table1"
local var1 = "intro_comp" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.1: Percentage `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append 
*------------------------------------------------------------------------------------*
//2.1.(a) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Introduction of solid/ semi-solid/ soft foods (ISSSF) by caste"
local TableNum = "table2"
local Var = "intro_comp" 
local RowVar = "region"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (a): Percentage `TableName' in children under 6–8 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//2.1 (b) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) indicator w.r.t mothers education
*------------------------------------------------------------------------------------
putdocx begin, font("Calibri", 9)

local TableName = "Introduction of solid/ semi-solid/ soft foods (ISSSF) by mother's schooling"
local TableNum = "table3"
local Var = "intro_comp" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1(b): Percentage `TableName' in children under 6–8 months by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.1 (c) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Introduction of solid/ semi-solid/ soft foods (ISSSF) by wealth index"
local TableNum = "table4"
local Var = "intro_comp" 
local RowVar = "region"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (c): Percentage `TableName' in children under 6–8 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.1.(d) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Introduction of solid/ semi-solid/ soft foods (ISSSF) by sex of child"
local TableNum = "table4"
local Var = "intro_comp" 
local RowVar = "region"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (d): Percentage `TableName' in children under 6–8 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 2.1 (e) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Introduction of solid/ semi-solid/ soft foods (ISSSF) by residence (urban/rural)"
local TableNum = "table4"
local Var = "intro_comp" 
local RowVar = "region"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (e): Percentage `TableName' in children under 6–8 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.1 (f) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)

local TableName = "Introduction of solid/ semi-solid/ soft foods (ISSSF) by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "intro_comp" 
local RowVar = "region"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (f): Percentage `TableName' in children under 6–8 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.1 (g) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Introduction of solid/ semi-solid/ soft foods (ISSSF)by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "intro_comp" 
local RowVar = "region"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (g): Percentage `TableName' in children under 6–8 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.1 (h) Introduction of solid/ semi-solid/ soft foods 6–8 months (ISSSF) indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Introduction of solid/ semi-solid/ soft foods (ISSSF) by C-Section"
local TableNum = "table4"
local Var = "intro_comp" 
local RowVar = "region"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.1 (h): Percentage `TableName' in children under 6–8 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*********************************************************************************
* Graph - Food Group consumps vs age in months
*********************************************************************************


graph twoway (lpoly carb  agemos [aw=nat_wgt], lcolor(olive) degree(1) /// Grains roots tubers
		title("IYCF food groups consumed - NFHS-4 2005-06") ///
		xtitle("Age in months", size(medlarge)) ytitle("x100 %") ///
		legend(size(2) pos(3) col(1) order(1 "Grains roots tubers" 2 "Dairy" 3 "Vita A Fruits/Veg" 4 "Other Fruit/Veg" /// 
		5 "Legumes/Nuts" 6 "Eggs" 7 "Animal source foods") stack) ///
		xlabel(2(2)24)) ///
	(lpoly dairy           agemos [aw=nat_wgt], lcolor(gold) lpattern(dash) degree(1)) /// Dairy
	(lpoly vita_fruit_veg  agemos [aw=nat_wgt], lcolor(orange) lpattern(longdash) degree(1)) /// Vita A Fruits/Veg
	(lpoly fruit_veg       agemos [aw=nat_wgt], lcolor(green) lpattern(solid) degree(1)) /// Other Fruit/Veg
	(lpoly leg_nut         agemos [aw=nat_wgt], lcolor(brown) lpattern(dash) degree(1)) /// Legumes
	(lpoly egg             agemos [aw=nat_wgt], lcolor(ebblue) lpattern(longdash) degree(1)) /// Eggs
	(lpoly all_meat        agemos [aw=nat_wgt], lcolor(red) lpattern(solid) degree(1)) 
	
graph export foodgroups_agemos.tif, as(tif) replace

**********insert graph in document**********
putdocx begin, font("Calibri",9)


putdocx pagebreak
putdocx paragraph, style(Title)
putdocx text ("IYCF consumption of food groups w.r.t age in months (NFHS-4 2005-06)")
putdocx paragraph, halign(center)
putdocx image foodgroups_agemos.tif, linebreak(1)
putdocx paragraph, style(Heading2)
putdocx text ("Figure 3: IYCF consumption of food groups w.r.t age in months (NFHS-4 2005-06)")
putdocx paragraph, halign(center)


putdocx save iycf_NFHS-4_region, append



**************************************************************************
* 2.2 Minimum dietary diversity 6–23 months (MDD)                        * 
**************************************************************************
putdocx begin, font("Calibri", 9)

putdocx pagebreak
putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("2.2 Minimum dietary diversity (MDD) for children under 6–23 months by region level variables")

* Define variables for table
local TableName = "Minimum dietary diversity (MDD) for children under 6–23 months"
local TableNum = "table1"
local var1 = "mdd" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.2: Percentage `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append 
*------------------------------------------------------------------------------------*
//2.2.(a) Minimum dietary diversity 6–23 months (MDD)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Minimum dietary diversity (MDD) by caste"
local TableNum = "table2"
local Var = "mdd" 
local RowVar = "region"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (a): Percentage `TableName' in children under  6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//2.2 (b) Minimum dietary diversity 6–23 months (MDD) indicator w.r.t mothers education
*-----------------------------------------------------------------------------------

putdocx begin, font("Calibri", 9)

local TableName = "Minimum dietary diversity for by mother's schooling"
local TableNum = "table3"
local Var = "mdd" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2(b): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.2 (c) Minimum dietary diversity 6–23 months (MDD) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

local TableName = "Minimum dietary diversity (MDD) by wealth index"
local TableNum = "table4"
local Var = "mdd" 
local RowVar = "region"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (c): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.2.(d) Minimum dietary diversity 6–23 months (MDD) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum dietary diversity (MDD) by sex of child"
local TableNum = "table4"
local Var = "mdd" 
local RowVar = "region"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (d): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 2.2 (e) Minimum dietary diversity 6–23 months (MDD) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Minimum dietary diversity (MDD) by residence (urban/rural)"
local TableNum = "table4"
local Var = "mdd" 
local RowVar = "region"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (e): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.2 (f) Minimum dietary diversity 6–23 months (MDD) n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)



local TableName = "Minimum dietary diversity (MDD) by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "mdd" 
local RowVar = "region"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (f): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.2 (g) Minimum dietary diversity 6–23 months (MDD) w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

local TableName = "Minimum dietary diversity (MDD) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "mdd" 
local RowVar = "region"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (g): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.2 (h) Minimum dietary diversity 6–23 months (MDD) indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Minimum dietary diversity (MDD) by C-Section"
local TableNum = "table4"
local Var = "mdd" 
local RowVar = "region"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (h): Percentage `TableName' in children under five years 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append






**************************************************************************
* 2.3 Minimum meal frequency 6–23 months (mmf_all)                        * 
**************************************************************************
putdocx begin, font("Calibri", 9)
putdocx pagebreak
putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("2.3 Minimum meal frequency (mmf_all) for children under 6–23 months by region level variables")
* Define variables for table
local TableName = "Minimum meal frequency (mmf_all) for children under 6–23 months"
local TableNum = "table1"
local var1 = "mmf_all" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.3: Percentage `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append 
*------------------------------------------------------------------------------------*
//2.3.(a) Minimum meal frequency 6–23 months (mmf_all)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Minimum meal frequency (mmf_all) by caste"
local TableNum = "table2"
local Var = "mmf_all" 
local RowVar = "region"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (a): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//2.3 (b) Minimum meal frequency 6–23 months (mmf_all) indicator w.r.t mothers education
*------------------------------------------------------------------------------------

putdocx begin, font("Calibri", 9)

local TableName = "Minimum meal frequency (mmf_all) by mother's schooling"
local TableNum = "table3"
local Var = "mmf_all" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (b): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.2 (c) Minimum meal frequency 6–23 months (mmf_all) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

local TableName = "Minimum dietary diversity (MDD) by wealth index"
local TableNum = "table4"
local Var = "mmf_all" 
local RowVar = "region"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.2 (c): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append





*------------------------------------------------------------------------------------*
// 2.3.(d) Minimum meal frequency 6–23 months (mmf_all) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum meal frequency (mmf_all) by sex of child"
local TableNum = "table4"
local Var = "mmf_all" 
local RowVar = "region"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (d): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 2.3 (e) Minimum meal frequency 6–23 months (mmf_all) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Minimum meal frequency (mmf_all) by residence (urban/rural)"
local TableNum = "table4"
local Var = "mmf_all" 
local RowVar = "region"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (e): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.3 (f) Minimum meal frequency 6–23 months (mmf_all) n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)



local TableName = "Minimum meal frequency (mmf_all) by early ANCvisit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "mmf_all" 
local RowVar = "region"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (f): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.3 (g) Minimum meal frequency 6–23 months (mmf_all) w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum meal frequency (mmf_all)by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "mmf_all" 
local RowVar = "region"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (g): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.3 (h) Minimum meal frequency 6–23 months (mmf_all) indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Minimum meal frequency (mmf_all) by C-Section"
local TableNum = "table4"
local Var = "mmf_all" 
local RowVar = "region"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.3 (h): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



/*
************************************************************************************
* 2.4 Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF)  * 
************************************************************************************
putdocx begin, font("Calibri", 9)
putdocx pagebreak
putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("2.4 Minimum milk feeding frequency (MMFF) for non-breastfed children under 6–23 months by region level variables")
* Define variables for table
local TableName = "Minimum milk feeding frequency (MMFF) for non-breastfed children under 6–23 months"
local TableNum = "table1"
local var1 = "min_milk_freq_nbf" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.4: Percentage `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append 
*------------------------------------------------------------------------------------*
//2.4.(a) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Minimum milk feeding frequency (MMFF) for non-breastfed children under 6–23 months by caste"
local TableNum = "table2"
local Var = "min_milk_freq_nbf" 
local RowVar = "region"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (a): Percentage `TableName' & by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//2.4(b) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) indicator w.r.t mothers education
*-----------------------------------------------------------------------------------


putdocx begin, font("Calibri", 9)

local TableName = "Minimum milk feeding frequency (MMFF) for non-breastfed children under 6–23 months by mother's schooling"
local TableNum = "table3"
local Var = "mmf_all" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (b): Percentage `TableName' & by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append





*------------------------------------------------------------------------------------*
// 2.4 (c) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum milk feeding frequency (MMFF) for non-breastfed children under 6–23 months by wealth index"
local TableNum = "table4"
local Var = "min_milk_freq_nbf" 
local RowVar = "region"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (c): Percentage `TableName' & by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.4 (d) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum milk feeding frequency (MMFF) for non-breastfed children under 6–23 months by sex of child"
local TableNum = "table4"
local Var = "min_milk_freq_nbf" 
local RowVar = "region"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (d): Percentage `TableName' & by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 2.4 (e) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Minimum milk feeding frequency (MMFF) for non-breastfed children under 6–23 months by residence (urban/rural)"
local TableNum = "table4"
local Var = "min_milk_freq_nbf" 
local RowVar = "region"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (e): Percentage `TableName' & by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.4 (f) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)

local TableName = "Minimum milk feeding frequency (MMFF) for non-breastfed children under 6–23 months by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "min_milk_freq_nbf" 
local RowVar = "region"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (f): Percentage `TableName' & by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.4 (g) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum milk feeding frequency (MMFF) for non-breastfed children under 6–23 months by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "min_milk_freq_nbf" 
local RowVar = "region"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (g): Percentage `TableName' & by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.4 (h) Minimum milk feeding frequency for non-breastfed children 6–23 months(MMFF) indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Minimum milk feeding frequency (MMFF) for non-breastfed children under 6–23 months by C-Section"
local TableNum = "table4"
local Var = "min_milk_freq_nbf" 
local RowVar = "region"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.4 (h): Percentage `TableName' & by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append
*/






************************************************************************************
* 2.5 Minimum acceptable diet 6–23 months (MAD)  * 
************************************************************************************
putdocx begin, font("Calibri", 9)
putdocx pagebreak
putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("2.5 Minimum acceptable diet (MAD) in children under 6-23 months by region level variables")
* Define variables for table
local TableName = "Minimum acceptable diet (MAD) in children under 6-23 months"
local TableNum = "table1"
local var1 = "mad_all" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.5: Percentage `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append 
*------------------------------------------------------------------------------------*
//2.5.(a) Minimum acceptable diet 6–23 months (MAD)  variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Minimum acceptable diet (MAD) by caste"
local TableNum = "table2"
local Var = "mad_all" 
local RowVar = "region"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (a): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//2.5 (b) Minimum acceptable diet 6–23 months (MAD) indicator w.r.t mothers education
*------------------------------------------------------------------------------------


putdocx begin, font("Calibri", 9)

local TableName = "inimum acceptable diet for age group by mother's schooling"
local TableNum = "table3"
local Var = "mad_all" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (b): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append




*------------------------------------------------------------------------------------*
// 2.5 (c) Minimum acceptable diet 6–23 months (MAD) indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum acceptable diet (MAD) by wealth index"
local TableNum = "table4"
local Var = "mad_all" 
local RowVar = "region"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (c): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.5 (d) Minimum acceptable diet 6–23 months (MAD) indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum acceptable diet (MAD) by sex of child"
local TableNum = "table4"
local Var = "mad_all" 
local RowVar = "region"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (d): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 2.5 (e) Minimum acceptable diet 6–23 months (MAD) indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Minimum acceptable diet (MAD) by residence (urban/rural)"
local TableNum = "table4"
local Var = "mad_all" 
local RowVar = "region"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (e): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.5 (f) Minimum acceptable diet 6–23 months (MAD) n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)



local TableName = "Minimum acceptable diet (MAD) by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "mad_all" 
local RowVar = "region"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (f): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.5 (g) Minimum acceptable diet 6–23 months (MAD) w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Minimum acceptable diet (MAD)by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "mad_all" 
local RowVar = "region"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (g): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.5 (h) Minimum acceptable diet 6–23 months (MAD) indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Minimum acceptable diet 6(MAD) by C-Section"
local TableNum = "table4"
local Var = "mad_all" 
local RowVar = "region"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.5 (h): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append







************************************************************************************
* 2.6 Egg and/or flesh food consumption 6–23 months (EFF)                          * 
************************************************************************************
putdocx begin, font("Calibri", 9)
putdocx pagebreak
putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("2.6 Egg and/or flesh food consumption (EFF) in children under 6-23 months by region level variables")
* Define variables for table
local TableName = "Egg and/or flesh food consumption (EFF) in children under 6-23 months"
local TableNum = "table1"
local var1 = "egg_meat" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.6: Percentage `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append 
*------------------------------------------------------------------------------------*
//2.6.(a) Egg and/or flesh food consumption 6–23 months (EFF)   variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Egg and/or flesh food consumption (EFF)  by caste"
local TableNum = "table2"
local Var = "egg_meat" 
local RowVar = "region"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (a): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//2.6 (b) Egg and/or flesh food consumption 6–23 months (EFF)  indicator w.r.t mothers education
*------------------------------------------------------------------------------------


putdocx begin, font("Calibri", 9)

local TableName = "Egg and/or flesh food consumption (EFF) by mother's schooling"
local TableNum = "table3"
local Var = "egg_meat" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (b): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append




*------------------------------------------------------------------------------------*
// 2.6 (c) Egg and/or flesh food consumption 6–23 months (EFF)  indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Egg and/or flesh food consumption (EFF)  by wealth index"
local TableNum = "table4"
local Var = "egg_meat" 
local RowVar = "region"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (c): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.6 (d) Egg and/or flesh food consumption 6–23 months (EFF)  indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

local TableName = "Egg and/or flesh food consumption (EFF)  by sex of child"
local TableNum = "table4"
local Var = "egg_meat" 
local RowVar = "region"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (d): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 2.6 (e) Egg and/or flesh food consumption 6–23 months (EFF)  indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Egg and/or flesh food consumption (EFF)  by residence (urban/rural)"
local TableNum = "table4"
local Var = "egg_meat" 
local RowVar = "region"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (e): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.6 (f) Egg and/or flesh food consumption 6–23 months (EFF)  n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)



local TableName = "Egg and/or flesh food consumption (EFF)  by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "egg_meat" 
local RowVar = "region"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (f): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.6 (g) Egg and/or flesh food consumption 6–23 months (EFF)  w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Egg and/or flesh food consumption (EFF) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "egg_meat" 
local RowVar = "region"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (g): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.6 (h) Egg and/or flesh food consumption 6–23 months (EFF)  indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Egg and/or flesh food consumption (EFF)  by C-Section"
local TableNum = "table4"
local Var = "egg_meat" 
local RowVar = "region"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.6 (h): Percentage `TableName' in children under 6-23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append




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
putdocx text ("2.7 Sweet beverage consumption 6–23 months (SwB): Variable is not available for this indicator (Survey Data is insufficient)")
putdocx text (" 2.8 Unhealthy food consumption 6–23 months (UFC): Variable is not available for this indicator (Survey Data is insufficient)")
putdocx pagebreak



************************************************************************************
* 2.9 Zero vegetable or fruit consumption 6–23 months (ZVF)                      * 
************************************************************************************

putdocx paragraph, style(Title) halign(left) spacing(line,13 pt)
putdocx text ("2.9 Zero vegetable or fruit consumption (ZVF) in children under 6–23 months by region level variables")

* Define variables for table
local TableName = "Zero vegetable or fruit consumption (ZVF) in children under 6–23 months"
local TableNum = "table1"
local var1 = "zero_fv" 
local RowVar = "region"

* How many rows to use for RowVar / number of region + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 2.9: Percentage `TableName' by region"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("region"), bold
putdocx table `TableNum'(2,2) = ("Ever Breastfed"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Count"), bold halign(center)

levelsof `RowVar', local(RowLevels)
foreach row in `RowLevels' {
	local i = `row'+2
	* add region name
	local RowValueLabel : value label `RowVar'
	local RowLabel: label `RowValueLabel' `row'
	putdocx table `TableNum'(`i',1) = ("`RowLabel'")
	* add results
	quietly summarize `var1' [aw=state_wgt] if region==`row' 
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

putdocx save iycf_NFHS-4_region, append 
*------------------------------------------------------------------------------------*
//2.9.(a) Zero vegetable or fruit consumption 6–23 months (ZVF)    variable w.r.t. caste
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


* Variable by Caste 
local TableName = "Zero vegetable or fruit consumption (ZVF)   by caste"
local TableNum = "table2"
local Var = "zero_fv" 
local RowVar = "region"
local ColVar = "caste"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (a): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append
*------------------------------------------------------------------------------------
//2.9 (b) Zero vegetable or fruit consumption 6–23 months (ZVF)   indicator w.r.t mothers education
*------------------------------------------------------------------------------------

putdocx begin, font("Calibri", 9)

local TableName = "Zero vegetable or fruit consumption (ZVF) by mother's schooling"
local TableNum = "table3"
local Var = "zero_fv" 
local RowVar = "region"
local ColVar = "mum_educ"

tab mum_educ,m

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (b): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 
putdocx table `TableNum'(2,2) = ("No Schooling"), bold halign(center)
putdocx table `TableNum'(2,3) = ("5 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("5-9 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("10-11 years Schooling"), bold halign(center)
putdocx table `TableNum'(2,6) = ("12+ years Schooling"), bold halign(center)
putdocx table `TableNum'(2,7) = ("N (Total)"), bold halign(center)

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
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row'       //deleted - & `col'==4 
			local ColNum = `col'+2
			putdocx table `TableNum'(`RowNum',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=nat_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%4.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=nat_wgt]           //`col'==4
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (r(N)), nformat(%7.0gc) halign(center)
}

putdocx save iycf_NFHS-4_region, append





*------------------------------------------------------------------------------------*
// 2.9 (c) Zero vegetable or fruit consumption 6–23 months (ZVF)   indicator w.r.t Wealth Index
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Zero vegetable or fruit consumption (ZVF) by wealth index"
local TableNum = "table4"
local Var = "zero_fv" 
local RowVar = "region"
local ColVar = "wi"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (c): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.9 (d) Zero vegetable or fruit consumption 6–23 months (ZVF)   indicator w.r.t sex of a child
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Zero vegetable or fruit consumption (ZVF) by sex of child"
local TableNum = "table4"
local Var = "zero_fv" 
local RowVar = "region"
local ColVar = "sex"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (d): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append

*------------------------------------------------------------------------------------*
// 2.9 (e) Zero vegetable or fruit consumption 6–23 months (ZVF)   indicator w.r.t residence (rural/uraban)
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

*
local TableName = "Zero vegetable or fruit consumption (ZVF) by residence (urban/rural)"
local TableNum = "table4"
local Var = "zero_fv" 
local RowVar = "region"
local ColVar = "rururb"

tab wi

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (e): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append


*------------------------------------------------------------------------------------*
// 2.9 (f) Zero vegetable or fruit consumption 6–23 months (ZVF)   n\dicator w.r.t earlyanc 
*------------------------------------------------------------------------------------*

putdocx begin, font("Calibri", 9)

local TableName = "Zero vegetable or fruit consumption (ZVF) by early ANC visit (ANC visit in 1st trimester)"
local TableNum = "table2"
local Var = "zero_fv" 
local RowVar = "region"
local ColVar = "earlyanc"

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (f): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.9 (g) Zero vegetable or fruit consumption 6–23 months (ZVF)   w.r.t ANC4PLUS
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)


local TableName = "Zero vegetable or fruit consumption (ZVF) by 4+ ANC check-ups of the mother"
local TableNum = "table4"
local Var = "zero_fv" 
local RowVar = "region"
local ColVar = "anc4plus"

tab anc4plus

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (g): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



*------------------------------------------------------------------------------------*
// 2.9 (h) Zero vegetable or fruit consumption 6–23 months (ZVF)   indicator w.r.t C-Section birth 
*------------------------------------------------------------------------------------*
putdocx begin, font("Calibri", 9)

 
local TableName = "Zero vegetable or fruit consumption (ZVF) by C-Section"
local TableNum = "table4"
local Var = "zero_fv" 
local RowVar = "region"
local ColVar = "csection"

tab csection

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 cases are suppressed ".")
putdocx table `TableNum'(1,1)=("Table 2.9 (h): Percentage `TableName' in children under 6–23 months by `RowVar'"), ///
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

putdocx save iycf_NFHS-4_region, append



**********************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************




/*
graph twoway (lpoly carb  agemos [aw=nat_wgt], degree(1) /// Grains roots tubers
         title("IYCF food groups consumed - NFHS-4 2005-06") ///
		xtitle("Age in months", size(medlarge)) ytitle("%") ///
		legend(size(0.9) pos(3) col(1) order(1 "carb" 2 "Dairy" 3 "Vita A Fruits/Veg" 4 "Other Fruit/Veg" /// 
		5 "Legumes/Nuts" 6 "Eggs" 7 "Animal source foods") stack) ///
		xlabel(2(2)24)) ///
	(lpoly dairy  agemos [aw=nat_wgt], degree(1)) /// Dairy
	(lpoly vita_fruit_veg  agemos [aw=nat_wgt], degree(1)) /// Vita A Fruits/Veg
	(lpoly fruit_veg  agemos [aw=nat_wgt], degree(1)) /// Other Fruit/Veg
	(lpoly leg_nut  agemos [aw=nat_wgt], degree(1)) /// Legumes
	(lpoly egg  agemos [aw=nat_wgt], degree(1)) /// Eggs
	(lpoly all_meat  agemos [aw=nat_wgt], degree(1))
	*/









