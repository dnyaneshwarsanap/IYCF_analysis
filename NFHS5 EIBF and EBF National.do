*Tables for IYCF Analysis of NFHS 5
*Request from Gayatri Singh 
* May 2022


* Robert 
include "C:\Users\stupi\OneDrive - UNICEF\1 UNICEF Work\1 moved to ECM\IIT-B\IYCF\analysis\robert_paths.do"
// include "dnyaneshwar_paths.do"

use iycf_NFHS5, clear 

* Daman & Diu causing problems
drop if state==9

* path for saving reports / graphs
cd "C:/TEMP/IYCF"
	
local FileName = "IYCF_National.docx"
* undercase variables come from datasets

* Camelcase vars are created in the code - used in code and dropped


// CONTENTS
// Early Initiation of Breastfeeding (last 2 years)
// •	Public / Private / place of birth
// •	Normal / Assisted -  Caesarian birth
// Exclusive Breastfeeding
// •	Antenatal advice on breastfeeding
// •	Postnatal care (Yes/No)
// •	Who provided Postnatal care visits (doctor, nurse, midwife, ASHA)
// Median duration of exclusive breastfeeding
// •	Antenatal advice on breastfeeding
// •	Postnatal care (Yes/No)
// •	Who provided Postnatal care visits (doctor, nurse, midwife, ASHA)
// Results by state.  For Early Initiation of Breastfeeding, to have analysis by district ranked. 


* Validate EIBF
// table one eibf [aw=national_wgt] 
// table state eibf [pw=state_wgt]
// cap drop eibf_x
// gen eibf_x = eibf * 100
// version 16: table state [pw=state_wgt], c(mean eibf_x n eibf_x) format(%8.1f)
// version 16: table one   [pw=national_wgt], c(mean eibf_x n eibf_x) format(%8.1f)

// gen imm = m34==0
// graph bar (mean) imm, over(b19) title ("Immediately put to breast by age in months")
// gen onehour = m34==100
// graph bar (mean) onehour, over(b19) title ("Put to breast in first hour by age in months")


* when using RowVar as list for looping, the values have to fall in order from 1 to x
* when state is correctly labelled in all datasets, this should not be a problem. 

* to set value label of state from 1 to x
cap drop state_old
gen state_old = state
cap drop stateString
decode state, gen(stateString)
tab stateString
cap drop state
// Under certain circumstances, -encode- will number  the numeric version of a string variable starting where it left off at the last encode
// to stop this behavior, drop the labels and start again

cap lab drop state
encode stateString, gen(state)
tab state, m 
la list state


*https://www.statalist.org/forums/forum/general-stata-discussion/general/1538255-creating-descriptive-stats-table-using-putdocx


* TITLE PAGE
putdocx clear
putdocx begin, font("Calibri") 
putdocx paragraph, style(Title) halign(center) spacing(line,16 pt)
putdocx text ("NFHS-5 REPORT - Early Initiation and Exclusive Breastfeeding")
putdocx paragraph, style(Title) halign(center) spacing(line,16 pt)
putdocx text ("Analysis by State and Associated Indicators")
putdocx paragraph, style(Heading2) halign(center)
putdocx text ("NFHS-5 Date of Data Collection Jun 2019 to May 2021")

putdocx pagebreak


// Early Initiation of Breastfeeding (EIBF)

* Define variables for table
local TableName = "Early Initiation of Breastfeeding (EIBF)"
local TableNum = "table1"
local var1 = "eibf" 
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
putdocx table `TableNum'(2,2) = ("Early Initiation"), bold halign(center)
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
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`i',3) = (`weighted_n'), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=national_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`RowCount',3) = (`weighted_n'), nformat(%16.0gc) halign(center)

	
putdocx save `FileName', replace 
putdocx begin, font("Calibri", 9)

* Add EIBF by parity 
*  Early Initiation of Breastfeeding (EIBF) by birth order

local TableName = "Early Initiation of Breastfeeding (EIBF) by birth order"
local TableNum = "table2"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "birth_order"

tab `ColVar'
//    At home  
//   Public HF 
//  Private HF 
//       other 

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 unweighted cases are suppressed as marked by ".")
putdocx table `TableNum'(1,1)=("Table 2: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("1"), bold 
putdocx table `TableNum'(2,3) = ("2"), bold halign(center)
putdocx table `TableNum'(2,4) = ("3"), bold halign(center)
putdocx table `TableNum'(2,5) = ("4"), bold halign(center)
putdocx table `TableNum'(2,6) = ("5+"), bold halign(center)
putdocx table `TableNum'(2,7) =  ("Weighted N"), bold halign(center)

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
			local weighted_n = floor(r(sum_w))
			putdocx table `TableNum'(`RowNum',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=national_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=national_wgt]  //if `col'==4
		local ColNum = `col'+2
		local weighted_n = floor(r(sum_w))
		putdocx table `TableNum'(`RowCount',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
}

putdocx save `FileName', append
putdocx begin, font("Calibri", 9)

* Add % institutional births 
 
* Define variables for table
local TableName = "Institutional Births"
local TableNum = "table1"
local var1 = "inst_birth" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 3: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Institutional Births"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Weighted N"), bold halign(center)

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
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`i',3) = (`weighted_n'), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=national_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`RowCount',3) = (`weighted_n'), nformat(%16.0gc) halign(center)

	
putdocx save `FileName', append  

putdocx begin, font("Calibri", 9)


* Add % public private births 
 *  Percent of births by (public/private) place of birth 
//  version 16: tabulate state birth_place, row
// Cannot use putdocx with this command above

* version 17
version 17: table state birth_place [aw=state_wgt], statistic(percent, across(birth_place))  nformat(%8.1f percent) statistic(frequency) zero
collect layout
putdocx collect

putdocx save `FileName', replace 

putdocx begin, font("Calibri", 9)


*  Early Initiation of Breastfeeding (EIBF) by place of birth (public/private)
local TableName = "Early Initiation of Breastfeeding (EIBF) by place of birth"
local TableNum = "table2"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "birth_place"

tab `ColVar'
//    At home  
//   Public HF 
//  Private HF 
//       other 

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',6), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 unweighted cases are suppressed as marked by ".")
putdocx table `TableNum'(1,1)=("Table 4: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("At home"), bold 
putdocx table `TableNum'(2,3) = ("Public HF"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Private HF"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Other"), bold halign(center)
putdocx table `TableNum'(2,6) =  ("N"), bold halign(center)

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
			local weighted_n = floor(r(sum_w))
			putdocx table `TableNum'(`RowNum',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=national_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=national_wgt]  //if `col'==4
		local ColNum = `col'+2
		local weighted_n = floor(r(sum_w))
		putdocx table `TableNum'(`RowCount',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
}

putdocx save `FileName', append
putdocx begin, font("Calibri", 9)

* Add % c-section
 
* Define variables for table
local TableName = "C-Sections"
local TableNum = "table1"
local var1 = "csection" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 5: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("C-Section Births"), bold halign(center)
putdocx table `TableNum'(2,3) = ("Weighted N"), bold halign(center)

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
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`i',3) = (`weighted_n'), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=national_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`RowCount',3) = (`weighted_n'), nformat(%16.0gc) halign(center)
	

// Early Initiation of Breastfeeding (last 2 years) by Normal / Assisted - Caesarian birth
local TableName = "Early Initiation of Breastfeeding (EIBF) by type of birth"
local TableNum = "table3"
local Var = "eibf" 
local RowVar = "state"
local ColVar = "csection"

tab `ColVar'
// if the ColVar is a 0/1 var, then further adjustments needed below
// this is possibly due to c-section being a 0/1 variable. 

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 unweighted cases are suppressed as marked by ".")
putdocx table `TableNum'(1,1)=("Table 6: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Normal"), bold 
putdocx table `TableNum'(2,3) = ("C-section"), bold halign(center)
putdocx table `TableNum'(2,4) =  ("N"), bold halign(center)

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
			local ColNum = `col'+2 // normally 1
			// this is possibly due to c-section being a 0/1 variable. 
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3 // normally 2
			local weighted_n = floor(r(sum_w))
			putdocx table `TableNum'(`RowNum',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=national_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=national_wgt]  //if `col'==4
		local ColNum = `col'+3
		local weighted_n = floor(r(sum_w))
		putdocx table `TableNum'(`RowCount',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
}

putdocx save `FileName', append




putdocx begin, font("Calibri", 9)

include "C:\Users\stupi\OneDrive - UNICEF\1 UNICEF Work\1 moved to ECM\IIT-B\IYCF\analysis\robert_paths.do"
use iycf_NFHS5_ebf, clear 


* path for saving reports / graphs
cd "C:/TEMP/IYCF"


// Exclusive Breastfeeding (ExBF)

* Define variables for table
local TableName = "Exclusive Breastfeeding (ExBF)"
local TableNum = "table4"
local var1 = "ebf" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 7: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Exclusive Breastfeeding"), bold halign(center)
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
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`i',3) = (`weighted_n'), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=national_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`RowCount',3) = (`weighted_n'), nformat(%16.0gc) halign(center)

putdocx save `FileName', append 
putdocx begin, font("Calibri", 9)

 
// putdocx paragraph
// putdocx text ("Percent of births by antenatal counselling on breastfeeding - Add here")
// version 16: tabulate state anc_BFcounsel, row

recode anc_BFcounsel (1 2 =0)(3=1), gen(recd_BF_counselling)

* Define variables for table
local TableName = "Received breastfeeding counselling during ANC"
local TableNum = "table4"
local var1 = "recd_BF_counselling" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 8: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Exclusive Breastfeeding"), bold halign(center)
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
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`i',3) = (`weighted_n'), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=national_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`RowCount',3) = (`weighted_n'), nformat(%16.0gc) halign(center)



// •	Antenatal advice on breastfeeding
// •	Postnatal care (Yes/No)
// •	Who provided Postnatal care visits (doctor, nurse, midwife, ASHA)

*  Exclusive Breastfeeding (ExBF) by antenatal counselling on breastfeeding
local TableName = "Exclusive Breastfeeding (ExBF) by antenatal counselling on breastfeeding"
local TableNum = "table5"
local Var = "ebf" 
local RowVar = "state"
local ColVar = "anc_BFcounsel"

tab `ColVar'
// Didn't meet TripleA 3 months before del 
//         Met TripleA - No BF counselling 
//        Met TripleA - Yes BF counselling 

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',5), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 unweighted cases are suppressed as marked by ".")
putdocx table `TableNum'(1,1)=("Table 9: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Didn't meet TripleA"), bold 
putdocx table `TableNum'(2,3) = ("Met TripleA - No BF counselling"), bold halign(center)
putdocx table `TableNum'(2,4) = ("Met TripleA - Yes BF counselling"), bold halign(center)
putdocx table `TableNum'(2,5) = ("N"), bold halign(center)

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
			local weighted_n = floor(r(sum_w))
			putdocx table `TableNum'(`RowNum',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=national_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=national_wgt]  //if `col'==4
		local ColNum = `col'+2
		local weighted_n = floor(r(sum_w))
		putdocx table `TableNum'(`RowCount',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
}

putdocx save `FileName', append
putdocx begin, font("Calibri", 9)

// putdocx paragraph
// putdocx text ("Percent of births by postnatal care"- Add here")
// version 16: tabulate state pnc_child_visit, row

* Define variables for table
local TableName = "Received a post natal care visit in 2 months post birth"
local TableNum = "table4"
local var1 = "pnc_child_visit" 
local RowVar = "state"

* How many rows to use for RowVar / number of state + 4: one for table title, the header, footer and (notes) 
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+4

* define table with # rows and columns
putdocx table `TableNum' = (`RowCount', 3), border(all, nil) width(90%) layout(autofitwindow) note()
* add title
putdocx table `TableNum'(1,1) = ("Table 10: Percent `TableName' by State"), bold font("Calibri", 11) halign(left) colspan(7) linebreak
* add headers
putdocx table `TableNum'(2,1) = ("State"), bold
putdocx table `TableNum'(2,2) = ("Exclusive Breastfeeding"), bold halign(center)
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
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`i',3) = (`weighted_n'), nformat(%16.0gc) halign(center)
}
* add national / total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	quietly summarize `var1' [aw=national_wgt] 
	local result = r(mean) * 100
	putdocx table `TableNum'(`RowCount',2) = (`result'), nformat(%5.1f) halign(center)
	local weighted_n = floor(r(sum_w))
	putdocx table `TableNum'(`RowCount',3) = (`weighted_n'), nformat(%16.0gc) halign(center)



// Exclusive Breastfeeding (ExBF) by postnatal care

local TableName = "Exclusive Breastfeeding (ExBF) by postnatal care"
local TableNum = "table6"
local Var = "ebf" 
local RowVar = "state"
local ColVar = "pnc_child_visit"

tab `ColVar'
// if the ColVar is a 0/1 var, then further adjustments needed below
// this is possibly due to c-section being a 0/1 variable. 

* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',4), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 unweighted cases are suppressed as marked by ".")
putdocx table `TableNum'(1,1)=("Table 11: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("No PNC visit"), bold 
putdocx table `TableNum'(2,3) = ("Yes PNC visit"), bold halign(center)
putdocx table `TableNum'(2,4) =  ("N"), bold halign(center)

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
			local ColNum = `col'+2 // normally 1
			// this is due to colvar being a 0/1 variable. 
			putdocx table `TableNum'(`RowNum',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
			// add total N to far right column - col_num = last on right
			quietly summarize `Var' [aw=state_wgt] if `RowVar'==`row' //& `col'==4   
			local ColNum = `col'+3 // normally 2
			local weighted_n = floor(r(sum_w))
			putdocx table `TableNum'(`RowNum',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=national_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+2
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=national_wgt]  //if `col'==4
		local ColNum = `col'+3
		local weighted_n = floor(r(sum_w))
		putdocx table `TableNum'(`RowCount',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
}

putdocx save `FileName', append
putdocx begin, font("Calibri", 9)


*  Exclusive Breastfeeding (ExBF) by postnatal assistance
local TableName = "Exclusive Breastfeeding (ExBF) by antenatal counselling on breastfeeding"
local TableNum = "table7"
local Var = "ebf" 
local RowVar = "state"
local ColVar = "pnc_assistance"

tab `ColVar'
//               Doctor |     25,446       35.36       35.36
// ANM/ Nurse /Mid-wife |     21,033       29.23       64.59
//                 ASHA |     23,841       33.13       97.73
//             Dai/ TBA |      1,073        1.49       99.22
//                Other |        562        0.78      100.00


* How many rows to use for RowVar / number of rows of RowVar + 5: title, header, empty row, overall, note
tabulate `RowVar', matcell(coltotals)
local RowCount = r(r)+5

putdocx pagebreak
* define columns
putdocx table `TableNum' = (`RowCount',7), border(all, nil) width(100%) layout(autofitcontents) ///
	note(Note: Estimates with sample of less than 50 unweighted cases are suppressed as marked by ".")
putdocx table `TableNum'(1,1)=("Table 12: Percentage `TableName' in children under five years by `RowVar'"), ///
	bold font("Calibri", 11) halign(left) colspan(7) linebreak
putdocx table `TableNum'(2,1) = ("`RowVar'"), bold 	
putdocx table `TableNum'(2,2) = ("Doctor"), bold 
putdocx table `TableNum'(2,3) = ("ANM/ Nurse /Mid-wife"), bold halign(center)
putdocx table `TableNum'(2,4) = ("ASHA"), bold halign(center)
putdocx table `TableNum'(2,5) = ("Dai/ TBA"), bold halign(center)
putdocx table `TableNum'(2,6) = ("Other"), bold halign(center)
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
			local weighted_n = floor(r(sum_w))
			putdocx table `TableNum'(`RowNum',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
	}
}
* add total to foot of table
putdocx table `TableNum'(`RowCount',1) = ("Overall")
	foreach col in `columns' {
		quietly summarize `Var' [aw=national_wgt]  if `ColVar'==`col'
		local Result =cond(r(N)>=50,r(mean)*100,.)
		local ColNum = `col'+1
		putdocx table `TableNum'(`RowCount',`ColNum') = (`Result'), nformat(%5.1f) halign(center)
		// add total N to far right column
		quietly summarize `Var' [aw=national_wgt]  //if `col'==4
		local ColNum = `col'+2
		local weighted_n = floor(r(sum_w))
		putdocx table `TableNum'(`RowCount',`ColNum') = (`weighted_n'), nformat(%16.0gc) halign(center)
}

putdocx save `FileName', append


*Variable for breastfeeding area graph

tab diet, m 

* No cases of bf and form? 
tab diet formula, m 


cap drop d1 d2 d3 d4 d5 d6
// tabulate diet, generate(d) - cannot use this line because sometimes there are missing categories
gen d1 = cond(diet==1, 100, 0)  // 1 "Exclusive BF"
gen d2 = cond(diet==2, 100, 0)  // 2 "H2O & BF" 
gen d3 = cond(diet==3, 100, 0)  // 3 "Non-milk liq & BF" 
gen d4 = cond(diet==4, 100, 0)  // 4 "Milk/Form & BF" 
gen d5 = cond(diet==5, 100, 0)  // 5 "CF & BF" 
gen d6 = cond(diet==0, 100, 0)  // 6 Not BF" 





// https://dhsprogram.com/data/Guide-to-DHS-Statistics/Breastfeeding_and_Complementary_Feeding.htm
// Handling of Missing Values
// Missing data on breastfeeding is treated as not currently breastfeeding in numerator and included in the denominator. Missing and "don't know" 
// data on foods and liquids given is treated as not given in numerator and included in denominator.


* Create weighted results for graph

preserve // to return data to prior format after commands below

collapse d1 d2 d3 d4 d5 d6 [aw=national_wgt], by(agemos)
gen total = d1 + d2 + d3 + d4 + d5 + d6

drop if agemos >23

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
    ||, legend(ring(0) position(3) col(1) size(tiny) ///
		order(6 "Not BF" 5 "CF & BF" 4 "Milk/Form & BF" 3 "Non-milk liq & BF" 2 "H2O & BF" 1 "Exclusive BF")) /// 
     xla(0(1)24) ytitle(Percent) xtitle(Age in Months) title(Breastfeeding Area Graph)

* see svedberg2.do for area graph

graph export bf_area_graph.tif, as(tif) replace
putdocx begin, font("Calibri", 9)
putdocx paragraph, halign(center)
putdocx image bf_area_graph.tif
putdocx save `FileName', append

restore  // restore to prior data
	 
end

	 
	 