* NAME OF FILE
* 	make_IYCF_vars_NFHS3.do 
* PURPOSE OF FILE
* 	Make IYCF Variables for NFHS3 data 
* REFERENCE USED
* 	USING Updated WHO IYCF guidelines 2020 and recommended IYCF code from UNICEF NY

clear
version 16

* KEEP COLLEAGUES FOLDER REFERENCES - Comment out when not used. 
// cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"
// use "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged\IAKR52FL.dta", clear

cd "C:/Temp"
//use "C:\Users\Rojohnston\OneDrive - UNICEF\ECM-Nut OP4 Nutrition Governance, Partnerships, resources M&E\IIT-B\IYCF\NFHS3\IAKR52FL.dta", clear
use "C:\TEMP\IAKR52FL.dta", clear

gen one=1

lab define no_yes 0 "No" 1 "Yes"

gen psu = v001
gen hh_num = v002

*tab result
tab b5, m
* Complete N living children 48,679  UPDATED
* remove all children who died (died children = 2876)
drop if b5 !=1

* Change from age in months to age in days for all IYCF categories
* Ages in month by day ranges
* 6 - 23 M  (183 - 730)
* Under 24 M
* 6 - 8 M   (183 - 243)
* 9 -23 M   (243 - 730)
* 6-11 M    (183 - 335)
* 12 - 23 M (335 - 730)
* Underfive (   < 1825)

* Age in days
gen int_date = mdy(v006 , v016 , v007)
format int_date %td

*to check the date month year datas
tab v006   // v006 interview month
tab v016   // v016 interview day
tab v007   // v007 interview year

tab b1, m  //b1 is birth month
tab b2, m  //b2 is birthyear
tab hw16, m //hw16 is Day of birth

// other than 31 dates of birth
// inconsistent |         34        0.07       68.97
//   don't know |     11,036       21.41       90.38
//           99 |      1,489        2.89       93.27
//            . |      3,471        6.73      100.00


* set missing day of birth to 15th of month. 
replace hw16 = 15 if hw16 > 31
tab hw16
* in theory 15th is middle of the month.
* We have created heaping on 15th of month
kdensity hw16 if b5==1

gen birthday =  hw16
gen birthmonth = b1
gen birthyear = b2

cap drop dob_date
gen dob_date = mdy(b1, hw16, b2)
format dob_date %td
gen age_days = int_date - dob_date 
* for some children 15th day of birth is after interview date

list age_days dob_date int_date if age_days<0
replace dob_date = int_date -7 if age_days<0
* 7 days is mid point of 15 days  - subjective decision
replace age_days = int_date - dob_date 

replace age_days =. if age_days>1825
tab age_days,m 
kdensity age_days if b5==1

gen agemos = floor(age_days/30.42) if b5==1
graph bar (count) one, over(agemos)

* Double check agemos 
// tab agemos, m 
// cap drop agemos_x
// gen agemos_x = v008 -  b3 if b5==1
// scatter agemos_x agemos


* Ever breastfed (children born in past 24 months) 
la list m4
tab m4
cap drop evbf
gen evbf = 0
replace evbf=1 if m4 >=0 &  m4 <60  // duration of breastfeeding in months
replace evbf=1 if m4 == 95 // still breastfeeding
replace evbf=. if age_days>=730 
la var evbf "Ever breastfed (children born in past 24 months)"
tab  m4 evbf, m
tab evbf

*Early initiation of Breastfeeding (children born in last 24 months breastfed within 1hr)
la list m34
tab m34, m 

gen eibf = 0
replace eibf = 1 if m34 == 0 | m34==100 | m34 ==101 ///  0 -immediately, 101 - one hour, 100 - within 30min to 1hr 

replace eibf =. if age_days>=730 // age in days
tab eibf,m
tab m34 eibf, m
tab eibf

*Timing of initiation of Breastfeeding 
cap drop eibf_timing
gen eibf_timing =. 
replace eibf_timing = 0 if m34==0
replace eibf_timing = 1 if m34==101 | m34 ==100
replace eibf_timing = mod(m34,100) if m34>=102 & m34<=123
replace eibf_timing = mod(m34,200)*24 if m34>=201 & m34<=223
replace eibf_timing =.  if age_days>=730
la var eibf_timing "Timing of start of breastfeeding (in hours)"
tab eibf_timing, m
scatter m34 eibf_timing
kdensity eibf_timing



* Exclusively breastfed for the first two days after birth
* Percentage of children born in the last 24 months who were fed exclusively with breast milk for the first two days after birth
* m55z Was [NAME] given nothing to drink other than breast milk within the first three days after delivery?
* The NFHS3 did not ask the question in the best method, so we are trying to edit to represent 2 days. 

tab m55z
cap drop ebf2d
gen ebf2d =0
replace ebf2d=1 if m55z==1 // m55z=1 means no other drink was given to the child in 1st three days
replace ebf2d =. if age_days >2
* Question was not asked correctly so variable will only be valid at national level 
* 38 children in sample <= 2 days
tab ebf2d m55z, m 
clonevar ebf3d = m55z
replace ebf3d = . if m55z==9

* Currently Breastfeeding
// 1. ever breastfed
// 2. still breastfeeding
// 3. breastfed yesterday
// v404 is a currently breastfeeding var in NFHS 3 can we use this var directly

cap drop currently_bf
gen currently_bf = v404
tab v404, m 
tab currently_bf,m

*PRELACTEAL Feeds
/*
-------------------------------------------------
m55a      		      milk other than breastmilk
m55b         		  PLAIN WATER
m55c         		  SUGAR OR GLUCOSE WATER
m55d         		  GRIPE WATER 
m55e          		  SUGAR-SALT-WATER SOLUTION
m55f       		      FRUIT JUICE
m55g				  Infant Formula
m55h        		  TEA
m55i        		  Honey
m55j                  Jannam Githi
m55k,m55l,m55m,m55n    given country na
m55x                   Given Other
m55z                   Given Nothing
-------------------------------------------------
*/

*Prelacteal feeds

* What was [NAME] given to drink? within first three days after delivery
clonevar prelacteal_milk = m55a
replace prelacteal_milk = 1 if m55g==1 // added formula to prelacteal milk
replace prelacteal_milk = . if m55a==9

clonevar prelacteal_water = m55b
replace prelacteal_water = . if m55b==9

clonevar prelacteal_sugarwater = m55c
replace prelacteal_sugarwater = . if m55c==9

clonevar prelacteal_gripewater = m55d
replace prelacteal_gripewater = . if m55d==9

clonevar prelacteal_saltwater = m55e
replace prelacteal_saltwater = . if m55e==9

clonevar prelacteal_juice = m55f
replace prelacteal_juice = . if m55f==9

clonevar prelacteal_formula = m55g
replace prelacteal_formula = . if m55g==9

clonevar prelacteal_tea = m55h
replace prelacteal_tea = . if m55h==9

clonevar prelacteal_honey = m55i
replace prelacteal_honey = . if m55i==9

clonevar prelacteal_janamghuti = m55j
replace prelacteal_janamghuti = . if m55j==9

tab m55k
tab m55l
tab m55m
tab m55n

clonevar prelacteal_other = m55x
replace prelacteal_other = . if m55x == 9

local prelacteal_feeds = "prelacteal_milk prelacteal_water prelacteal_sugarwater prelacteal_gripewater prelacteal_saltwater prelacteal_juice prelacteal_formula prelacteal_tea prelacteal_honey prelacteal_janamghuti prelacteal_other"
foreach var in `prelacteal_feeds' { 
	replace `var' = . if  age_days>=730
}

*Prelacteal other than milk
cap drop prelacteal_otherthanmilk
gen prelacteal_otherthanmilk =0
local prelacteal_feeds = "prelacteal_water prelacteal_sugarwater prelacteal_gripewater prelacteal_saltwater prelacteal_juice prelacteal_tea prelacteal_honey prelacteal_janamghuti prelacteal_other"
foreach var in `prelacteal' { 
	replace prelacteal_otherthanmilk = 1 if  `var'==1
}
tab prelacteal_otherthanmilk,m

*Prelacteal milk formula
gen prelacteal_milk_form=0
replace prelacteal_milk_form =1 if prelacteal_milk==1
replace prelacteal_milk_form =1 if prelacteal_formula==1
tab prelacteal_milk_form,m

tab m55z prelacteal_otherthanmilk
* m55z does faithfully represent children who were given nothing in first 3 days. 
 

* Bottle Feeding
* for variables that are stand alone, code missing as missing. 
tab m38, m 
clonevar bottle = m38
replace bottle = . if m38>2       //m38 - did [Name] drink anything from bottle yesterday or last light
replace bottle = . if age_days>=730
tab m38 bottle, m

tab m38 v415, m  // v415 does not clearly identify as bottle feeding last 24 hours

tab v410a , m  //  gave child tea or coffee 



/*
Var Name    Label
v409		gave child plain water        
v409a	    gave child sugar water     -na      
v410		gave child juice 
v410a		gave child tea or coffee 
v411 		gave child tinned/powder or fresh milk
v411a		gave child baby formula 
v412 		gave child fresh milk      -na  // MISSING
v412a 		gave child baby Cerelac          // from q480 Any commercially fortified baby food such as Cerelac or Farex?
v412b 		gave child other porridge/gruel // from q480 Any porridge or gruel?
v413 		gave child other liquid
v413a		gave child cs liquid       -na  // MISSING
v413b 		gave child cs liquid       -na  // MISSING
v413c 		gave child cs liquid       -na  // MISSING
v413d 		gave child cs liquid       -na  // MISSING
v414a 		gave child chicken, duck or other birds
v414b 		gave child any other meat
v414c 		gave child foods made from beans, peas or lentils
v414d 		gave child any nuts
v414e 		gave child bread, noodles, other made from grains
v414f 		gave child potatoes, cassava, or other tubers
v414g 		gave child eggs
v414h 		gave child meat (beef, pork-na  // MISSING
v414i 		gave child pumpkin, carrots, squash (yellow or orange inside
v414j 		gave child any dark green leafy vegetables
v414k 		gave child mangoes, papayas, other vitamin a fruits
v414l 		gave child any other fruits or vegetables
v414m 		gave child liver, heart, other organs
v414n 		gave child fresh or dried fish or shellfish
v414o 		gave child food made from beans, peas, lentils, nuts
v414p 		gave child cheese, yogurt , other milk products
v414q 		gave child oil, fats, butter, products made of them	
v414r 		gave child chocolates, swee-na // MISSING
v414s 		gave child other solid or semi-solid food
v414t 		gave child cs foods        -na  // MISSING
v414u		gave child cs foods        -na  // MISSING
v415		drank from bottle with nipple
*/

********************************************************************************
* Food groups (liquids and solids)
********************************************************************************

* recode foods into food groups
* 	yes = 1, 
* 	no and don't know = 0
* following global guidance on IYCF analysis, this allows for maximium children to be included in indicator 

foreach var of varlist v409- v414u {
	recode `var' (1=1) (2 8 9 . =0) , gen(`var'_rec)
	lab val `var'_rec no_yes
}

* LIQUIDS
clonevar water					=v409_rec
clonevar juice			        =v410_rec
clonevar tea			        =v410a_rec 
clonevar other_liq 		        =v413_rec

* Milk represents any milk consumption (animal milk, powder milk/formula and buttermilk/curd)
clonevar milk			        =v411_rec  // tinned/powder or fresh milk
clonevar formula 		        =v411a_rec

* No frequency of milks, formula, other milks questions were asked. 
gen freq_milk = .
gen freq_formula = .
gen freq_other_milk = .

replace  milk = 1 if v412_rec ==1 // Add formula
* no fresh milk var was used. 

lab var water "water"
lab var juice "juice"
lab var tea "tea coffee"
lab var milk "milk"
lab var formula "formula"
lab var other_liq "other_liq"

tab v412a 		 // from q480 Any commercially fortified baby food such as Cerelac or Farex?
tab v412b 		 // from q480 Any porridge or gruel?



* SOLIDS SEMISOLIDS
clonevar fortified_food                         =v412a_rec // from q480 Any commercially fortified baby food such as Cerelac or Farex?
clonevar gruel        							=v412b_rec // other porridge/gruel
// These belong in solid/semi-solid list and will be added to bread, rice other grains
clonevar poultry                               = v414a_rec //chicken_duck_other birds
clonevar meat                                  = v414b_rec // gave child other meat
replace  meat =1 if 							 v414h_rec==1 // (beef, pork-na
clonevar legume                                = v414c_rec //foods_of_beans_peas_lentils
clonevar nuts                                  = v414d_rec
clonevar bread                                 = v414e_rec  //food_of_bread_noodles_other_grains 
clonevar potato                                = v414f_rec  //potatoes_cassava_other tubers 
clonevar egg                                   = v414g_rec
clonevar vita_veg                              = v414i_rec // pumpkin_carrots_squash (yellow or orange inside 
clonevar leafy_green                 	 	   = v414j_rec //any dark green leafy vegetables
clonevar vita_fruit                            = v414k_rec //mangoes, papayas, other vitamin a fruits
clonevar fruit_veg                  		   = v414l_rec //any other fruits or vegetables
clonevar organ              		           = v414m_rec //liver, heart, other organs
clonevar fish                                  = v414n_rec //fresh or dried fish or shellfish
clonevar leg_nut							   = v414o_rec //food made from beans, peas, lentils, nuts		
* Double check leg_nut - here the eating of nuts is asked twice in v414o and v414d both
tab v414d_rec, m
tab v414o_rec, m
tab leg_nut v414o_rec
replace leg_nut = 1 if nuts ==1
clonevar yogurt                                = v414p_rec //cheese, yogurt , other milk products
* yogurt and cheese coded together
clonevar semisolid                             = v414s_rec //other solid or semi-solid food	


* MATCH WITH CNNS VARIABLES

// \* SOLIDS SEMISOLIDS from CNNS
// clonevar yogurt			=q310g1_rec
// clonevar fortified_food  =q310h_rec  // any commercially fortified food
// clonevar bread 			=q310i_rec  // any bread, roti, chapati, rice, noodles, biscuits, idli, porridge 
// clonevar vita_veg		=q310j_rec
// clonevar potato 		    =q310k_rec  // any white potato, white yam, cassava or other food made from roots
// clonevar leafy_green  	=q310l_rec
// clonevar vita_fruit		=q310m_rec
// clonevar fruit_veg		=q310n_rec
// clonevar organ			=q310o_rec
// clonevar poultry		    =q310p_rec
// clonevar meat			=q310q_rec
// clonevar egg			    =q310r_rec
// clonevar fish			=q310s_rec
// clonevar leg_nut		    =q310t_rec  // beans, peas, lentils, nuts
// clonevar cheese			=q310u_rec  // any cheese or other food made from milk?
// clonevar fat			    =q310v_rec  // oil, ghee, butter    -----------------------------------> this is not a food groups
// clonevar semisolid		=q310w_rec  // any other solid, semi-solid or soft food		

lab var bread "bread, noodles, other grains"  // any bread, roti, chapati, rice, noodles, biscuits, idli, porridge 

lab var fortified_food  "fortified food"
lab var gruel gruel
lab var poultry  poultry
lab var meat poultry
lab var legume legume
lab var nuts nuts
lab var bread bread
lab var potato potato
lab var vita_veg "vitamin A rich veg"
lab var leafy_green "leafy greens"
lab var vita_fruit "vitamin A rich fruit"
lab var yogurt yogurt
lab var semisolid semisolids
lab var organ "organ meats"
lab var fish fish 



*Define eight food groups following WHO recommended IYCF indicators
gen carb = 0
replace carb = 1 if bread ==1 | potato==1 | gruel ==1 | fortified_food ==1
* Carb includes gruel and fortified food
lab var carb "1: Bread, rice, grains, roots and tubers"

tab carb, m 

lab var leg_nut "2: Legumes and nuts"

gen dairy = 0
replace dairy = 1 if formula ==1 | yogurt==1 | milk==1
lab var dairy "3: Dairy - milk, formula, yogurt, cheese"
 
gen all_meat = 0
replace all_meat = 1 if meat ==1 | poultry ==1 | organ ==1 | fish ==1  
lab var all_meat "4: Flesh foods (meat, fish, bird and liver/organ meats)"
lab val all_meat all_meat

lab var egg "5: Eggs"

gen vita_fruit_veg = 0
replace vita_fruit_veg = 1 if vita_fruit ==1 | vita_veg==1 | leafy_green==1 
lab var vita_fruit_veg "6: Vitamin A rich fruits and vegetables"

lab var fruit_veg "7: Other fruits and vegetables"
replace fruit_veg = 0 if fruit_veg==0 | fruit_veg ==9
tab fruit_veg, m

foreach var of varlist carb leg_nut dairy all_meat vita_fruit_veg fruit_veg currently_bf {
	lab val `var' no_yes
}

* Test all 8 food groups
* Check N, yes/no output, no missing	
foreach var of varlist carb dairy all_meat egg vita_fruit_veg fruit_veg currently_bf {
	tab `var' , m
}
		
		
* Age groups in blocks of 6 months
gen agegroup = floor(age_days/183 +1)   //agemons/6 +1
lab def agegroup 1 "0-5m" 2 "6-11m" 3 "12=17m" 4 "18-23m" 5 "24-29m" 6 "30-35m" 7 "36-41m" 8 "42-47m" 9 "48-53m" 10 "54-59m"
lab val agegroup agegroup


* Number of food groups out of eight
cap drop sumfoodgrp
egen sumfoodgrp = rowtotal (carb leg_nut dairy all_meat egg vita_fruit_veg fruit_veg currently_bf)
tabulate sumfoodgrp, generate(fg)
rename (fg1 fg2 fg3 fg4 fg5 fg6 fg7 fg8 fg9) ///
	   (fg0 fg1 fg2 fg3 fg4 fg5 fg6 fg7 fg8)		

* Any solid/semi-solid food consumption -  Does NOT include currently breastfeeding
cap drop any_solid_semi_food
egen any_solid_semi_food = rowtotal (carb leg_nut dairy all_meat egg vita_fruit_veg fruit_veg semisolid)
replace any_solid_semi_food = 1 if any_solid_semi_food >1
tab m39, m
replace any_solid_semi_food = 1 if m39 >0 & m39 <=7 // frequency of feeding
tab any_solid_semi_food, m 	   
cap drop any_solid_semi_food_x
gen any_solid_semi_food_x = any_solid_semi_food*100
graph bar (mean) any_solid_semi_food_x if agemos<24, over(agemos)
cap drop any_solid_semi_food_x

*Introduction to the semi_solid, solid, soft_food in children from 6-8 months of age
* based on v414s: gave child solid, semi solid, soft foods yesterday 

cap drop intro_compfood
gen intro_compfood = 0
replace intro_compfood = . if v414s == 9
replace intro_compfood = 1 if v414s == 1    | any_solid_semi_food==1 
replace intro_compfood = . if age_days<=183 | age_days>=243
la var intro_compfood "Intro to complementary food 6-8 months of age"
tab intro_compfood

*EXCLUSIVE BREASTFEEDING
*Exclusive breastfeeding is defined as breastfeeding with no other food or drink, not even water.
*Using the WHO guideline for defining ebf variable - create a condition variable based on 
*if the child received any other food items (liquid/solids/semi-solids) on previous day

cap drop ebf
* Create ebf variable - 1 yes 0 no
// no liquids besides breastmilk
// no food groups consumed - any_solid_semi_food==0 
gen ebf=0 
replace ebf =1 if currently_bf ==1
replace ebf =0 if water      ==1 | ///
                  juice      ==1 | ///		
                  milk       ==1 | ///
				  tea        ==1 | ///
                  formula    ==1 | ///
                  other_liq  ==1 | ///
                  any_solid_semi_food ==1
				  
replace ebf =. if age_days >182
la var ebf "Exclusive breasfeeding"
tab ebf
tab ebf agemos



* MEDIAN duration of exclusive breastfeeding
cap drop age_ebf
gen age_ebf = round(age_days/30.4375, 0.01)   //exact age in months round of to 2 digits after decimal
replace age_ebf = . if age_days >183
*set agemos_ebf to missing if exbf=no
replace age_ebf=. if ebf==0
la var age_ebf "Median age of exclusive breasfeeding in months"
sum age_ebf [aw=v005], d

* MEDIAN duration of continued breastfeeding
gen age_cbf = round(age_days/30.4375, 0.01)   //exact age in months round of to 2 digits after decimal
replace age_cbf=. if currently_bf !=1
la var age_cbf "Median age of continued breasfeeding in months"
sum age_cbf [aw=v005], d

*Continued breastfeeding / normally presented from 12-15 months or 18-23 months
la list m4
//  95 still breastfeeding
recode m4 (95=1)(0/94 96/99=0)(missing=.), gen(cont_bf)
tab m4 cont_bf , m 

gen cont_bf_12_23 = cont_bf if age_days>335 &age_days<730 
tab cont_bf_12_23, m


*Minimum Dietary Diversity- code for new indicator definition 
*currently_bf - identifies children still breastfeeding
*Following new definition MDD is met if child fed 5 out 8 food groups regardless of breastfeeding status*
gen mdd=0
replace mdd=1 if sumfoodgrp >=5 
replace mdd=. if age_days<=183 | age_days>=730
la var mdd "Minimum Dietary Diversity (2020)"
tab mdd

*Minimum Meal Frequency (MMF) 
*For currently breastfeeding children: MMF is yes if:
*			child 6-8 months of age receives:
*   				solid, semi-solid or soft foods at least 2 times
*			child 9-23 months of age receives:
*					solid, semi-solid or soft foods at least 3 times
* Variable fed_solids identifies the number of times a child was fed solid, semi-solid or soft foods*

* For this variable please remember to set response "don't knows" to zero
* IN NFHS (DHS) replace fed_solids=0 if fed_solids is don't know  - don't know = 8

* Q482 How many times did (NAME) eat solid, semisolid, or soft foods other than liquids yesterday during the day or at night? 

tab m39, m
gen freq_solids=m39
replace freq_solids =0 if m39==8 & sumfoodgrp==0 // Don't know = Child did not consume any solid semi-solid foods yesterday
replace freq_solids =0 if m39==0 & sumfoodgrp==0 // 0 frequency and 0 food groups 
replace freq_solids =1 if m39==. & sumfoodgrp>=1 // missing frequency and 1+ food groups
replace freq_solids =1 if m39==8 & sumfoodgrp>=1 // don't know frequency and 1+ food groups  
replace freq_solids =0 if m39==. & sumfoodgrp==0 // missing frequency and 0 
replace freq_solids =0 if m39==9

tab m39 freq_solids,m
tab m39 sumfoodgrp,m
tab sumfoodgrp freq_solids, m 

*Replacing freq_solids =1 if freq_solids is missing and sumfoodgrp is more than one
replace freq_solids=1 if freq_solids==. & sumfoodgrp >=1 & sumfoodgrp <=8
tab sumfoodgrp freq_solids, m 

*changing sumfoodgrp to 1 if freq_feeds is more than once 
replace sumfoodgrp=1 if sumfoodgrp==0 & freq_solids>=1 & freq_solids<=7
tab sumfoodgrp freq_solids, m 


*Minimum Meal Frequency (MMF) Breastfeeding
gen mmf_bf=0
replace mmf_bf=1 if freq_solids>=2 & currently_bf==1 & age_days>183 & age_days<243 
replace mmf_bf=2 if freq_solids>=3 & currently_bf==1 & age_days>=243 & age_days<730 
replace mmf_bf=. if currently_bf!=1
replace mmf_bf =. if age_days<=183 | age_days>=730
tab mmf_bf, m


la def mmf_bf  0 "Inadequate MMF" 1 "Adequate freq(2) and BF 6-8M" 2 "Adequate freq(3) and BF 9-23M"
la val mmf_bf mmf_bf
tab mmf_bf,m


*AS Frequency of Milk feeds is not in NFHS 3 DATA, WE ARE UNABLE TO CREATE THE MMF for Non_BF CHILDREN  VARIABLE


*MMF among all children 6-23 months    //for NFHS 3 we can only consider MMF for BF children, so this var is only for BF children
gen mmf_all_bf=0
replace mmf_all_bf=1 if mmf_bf==1 | mmf_bf==2  
replace mmf_all_bf =. if currently_bf!=1                    
replace mmf_all_bf =. if age_days<=183 | age_days>=730
la var mmf_all_bf "Minimum meal frequency for all children 6-23M"
tab mmf_all_bf, m 


**Minimum Acceptable Diet (MAD) for BF children
**** MAD among all BF infants 6-23 months of age ****	
gen mad_all_bf=0
replace mad_all_bf=1 if (mdd==1 & mmf_all_bf==1) & currently_bf==1 
replace mmf_all_bf =. if currently_bf!=1  
replace mad_all_bf=. if age_days<=183 | age_days>=730 
tab mad_all_bf, m 


*Egg and/or Flesh food consumption - % of children 6-23months of age who consumed egg and/or flesh food during the previous day*
gen egg_meat=0
replace egg_meat=1 if all_meat ==1 | egg==1            //& agemons>=6 & agemons<=23
replace egg_meat =. if age_days<=183 | age_days>=730
tab egg_meat, m 


*Zero fruit or veg consumption - % of children 6-23months of age who did not consume any fruits or vegetables during the previous day**
gen zero_fv=0
replace zero_fv =1 if vita_fruit_veg==0  & fruit_veg ==0
replace zero_fv =. if age_days<=183 | age_days>=730
tab zero_fv, m 


*Unhealthy food consumption
*consumption of sugar sweetened beverages by child agemons 6 to 23

gen sugar_bev = .
gen unhealthy_food = .
* Need clear definition of unhealthy foods - from WHO guidance. 
* Low nutrient density liquids
* juice broth other_liq
*ABOVE VARIABLES ARE NOT POSSIBLE TO MAKE BASED ON THE AVAILABLE NFHS 3 DATA

* INCLUDE ALL SOCIO-DEMOGRAPHIC data		

* Birth weight
tab m19, m 
//         9996 not weighed at birth
//         9998 don't know
gen birth_weight = m19
replace birth_weight = 9999 if birth_weight >9995
label def bw 9999 "Missing", replace
label val birth_weight bw
label var birth_weight "Birth weight"
replace birth_weight = birth_weight/1000 if birth_weight != 9999
kdensity birth_weight

recode birth_weight (0/0.249=6)(0.25/1.499=1)(1.5/2.499=2)(2.5/3.999=3)(4/10.999=4)(11/10000=7), gen(cat_birth_wt)
replace cat_birth_wt = 5 if m19==9996
replace cat_birth_wt = 6 if m19==9998
// egen c_birth_wt = cut(birth_weight), at(0.25,1.5,2.5,4,9001,9997,9999,10000) icodes
label def cat_birth_wt 1 "Very low <1.5kg" 2 "Low <2.5kg" 3 "Average" 4 "High >4kg" 5 "Not weighed" 6 "Don't know" 7 "Missing"
label val cat_birth_wt cat_birth_wt
label var cat_birth_wt "Birth weight category"
tab cat_birth_wt, m 

* LBW  //low birth weight
cap drop lbw
gen lbw = . 
replace lbw = 1 if m19 <=2500
replace lbw = 0 if m19 >2500 & m19 <8001
tab m19 lbw, m


* early ANC  <=3 months first trimester (ANC checkup within first 3 months of pregnancy)
gen earlyanc = 0
replace earlyanc = 1 if m13<=3
replace earlyanc =. if age_days>=730
tab m13 earlyanc
tab m13,m

 
* ANC 4+ (Pregnent women receiving more than 4 ANC check-ups)
gen anc4plus = 0
replace anc4plus = 1 if m14 >=4 & m14 <=30
replace anc4plus =. if age_days>=730
tab m14 anc4plus

* C-section (pregnancy - weather cesarion cesarean section or not)
gen csection = 0
replace csection = 1 if m17 == 1
tab m17 csection, m 



* Mothers education
tab v106, m 
tab v107, m
tab v107 v106, m

* code NFHS data into number of school years completed
gen mum_educ_years=.
replace mum_educ_years = 0 if v106==0
replace mum_educ_years = v107 if v106==1
replace mum_educ_years = 5 + v107 if v106==2
replace mum_educ_years = 12 + v107 if v106==3
tab mum_educ_years
scatter   mum_educ_years v106

recode mum_educ_years (0=1)(1/4=2)(5/9=3)(10/11=4)(12/25=5)(26/max=99), gen(mum_educ)
lab var mum_educ "Maternal Education"
la def mum_educ 1 "No Education" 2 "<5 years completed" 3 "5-9 years completed" ///
	4 "10-11 years completed" 5  "12+ years completed" 99 "Missing"
la val mum_educ mum_educ
tab mum_educ_years mum_educ, m

tab v190 mum_educ, m 
tab v190 mum_educ, row nofreq
tab v190 mum_educ, col nofreq
tab v155 mum_educ, col nofreq



* caste
tab v130 s46, m  // caste and religion
cap drop caste
gen caste=0 
replace caste = 1 if s46 ==1 
replace caste = 2 if s46 ==2 
replace caste = 3 if s46 ==3
replace caste = 4 if s46 ==4
replace caste = 5 if s46 ==. | s46==9 | s46 ==8      // missing values are not assigned to any caste
lab define caste 1 "Scheduled caste" 2"Scheduled tribe" 3"OBC"  4"Others" 5 "Missing/don't know" 
lab val caste caste
lab var caste "Caste"
tab caste s46, m 
tab caste, m 


* Residence Rural Urban

gen rururb=v102

lab define rururb 1 "Urban" 2"Rural"
lab val rururb rururb   
lab var rururb "Residence"
tab rururb, m 


* Wealth index
gen wi = v190
lab define wi 1"poorest" 2"poorer"	3 "middle" 4 "richer" 5 "richest"
lab val wi wi
tab wi,m	
gen wi_s=.
	
* Survey Weights
gen national_wgt = v005    //   national women's weight (6 decimals)
gen regional_wgt =v005s    // 	state women's weight (6 decimals)
gen state_wgt =v005s       // 	state women's weight (6 decimals)
	
*sex of child
gen sex=b4
tab sex b4


   	   
	   
* Child Illness
* Diarrhea
cap drop diar
gen diar = .
replace diar =1 if h11==2
replace diar =0 if h11==0 | h11==8
tab diar h11,m


* Fever
gen fever =.
replace fever =1 if h22==1
replace fever =0 if h22==0 | h22==8
ta fever h22,m

		
* Cough with rapid breathing excluding those with only nasal breathing problems
tab h31
tab h31b 
tab h31c
cap drop ari
recode h31 (2=1)(0 8=0), gen(ari)            //.......................... previously it was (1=1) (0 2 8 =0)
replace ari=0 if h31b!=1
replace ari=0 if h31c==2 | h31c==6 | h31c==8
tab ari h31
tab ari h31b
tab ari h31c
tab ari, m 


	
*recode state codes of nfhs3
*NFHS 3 state variable has to be harmonized with all survey state identification variables 

gen state = .

// 1 "A&N islands"
replace state =2  if v101 ==28			 
replace state =3  if v101 ==12			 
replace state =4  if v101 ==18			 
replace state =5  if v101 ==10		
// 6 Chandigarh	 
replace state =7  if v101 ==22		
// 8 "Dadra and Nagar Haveli"
// 9 "Daman and Diu"	 
replace state =10  if v101 ==30			 
replace state =11  if v101 ==24			 
replace state =12  if v101 ==6			 
replace state =13  if v101 ==2			 
replace state =14  if v101 ==1			 
replace state =15  if v101 ==20			 
replace state =16  if v101 ==29			 
replace state =17  if v101 ==32		
// 18 Lakshadweep	 
replace state =19  if v101 ==23			 
replace state =20  if v101 ==27			 
replace state =21  if v101 ==14			 
replace state =22  if v101 ==17			 
replace state =23  if v101 ==15			 
replace state =24  if v101 ==13			 
replace state =25  if v101 ==7			 
replace state =26  if v101 ==21			
// 27 Puducherry 
replace state =28  if v101 ==3			 
replace state =29  if v101 ==8			 
replace state =30  if v101 ==11			 
replace state =31  if v101 ==33			 
replace state =32  if v101 ==16			 
replace state =33  if v101 ==9			 
replace state =34  if v101 ==5			 
replace state =35  if v101 ==19			 


cap la drop state_name
la def state_name			   1 "A&N islands"
la def state_name			   2 "Andhra Pradesh", add
la def state_name			   3 "Arunachal Pradesh" , add
la def state_name			   4 Assam , add
la def state_name			   5 Bihar , add
la def state_name			   6 Chandigarh, add
la def state_name			   7 Chattisgarh, add
la def state_name			   8 "Dadra and Nagar Haveli", add
la def state_name			   9 "Daman and Diu", add
la def state_name			  10 Goa, add
la def state_name			  11 Gujarat, add
la def state_name			  12 Haryana, add
la def state_name			  13 "Himachal Pradesh", add
la def state_name			  14 "Jammu and Kashmir", add
la def state_name			  15 Jharkhand, add
la def state_name			  16 Karnataka, add
la def state_name			  17 Kerala, add
la def state_name			  18 Lakshadweep, add
la def state_name			  19 "Madhya Pradesh", add
la def state_name			  20 Maharashtra, add
la def state_name			  21 Manipur, add
la def state_name			  22 Meghalaya, add
la def state_name			  23 Mizoram, add
la def state_name			  24 Nagaland, add
la def state_name			  25 Delhi, add
la def state_name			  26 Odisha, add
la def state_name			  27 Puducherry, add
la def state_name			  28 Punjab, add
la def state_name			  29 Rajasthan, add
la def state_name			  30 Sikkim, add
la def state_name			  31 "Tamil Nadu", add
la def state_name			  32 Tripura, add
la def state_name			  33 "Uttar Pradesh", add
la def state_name			  34 Uttarakhand, add
la def state_name			  35 "West Bengal", add
la def state_name			  36 Telangana, add
la val state state_name

tab state, m 

gen round=1

// keep one int_date age_days agemos ///
// 	evbf eibf eibf_timing ebf2d ebf3d ebf age_cbf age_ebf prelacteal_milk ///
// 	prelacteal_water prelacteal_sugarwater prelacteal_gripewater /// 
// 	prelacteal_saltwater prelacteal_formula prelacteal_honey ///
// 	prelacteal_janamghuti prelacteal_other bottle water juice milk ///
// 	formula other_liq juice broth yogurt fortified_food bread vita_veg ///
// 	potato leafy_green any_solid_semi_food vita_fruit fruit_veg organ meat ///
// 	egg fish cont_bf semisolid carb leg_nut dairy all_meat vita_fruit_veg ///
// 	agegroup sumfoodgrp diar fever ari cont_bf cont_bf_12_23 ///
// 	intro_compfood mdd currently_bf freq_solids mmf_bf freq_milk ///
// 	freq_formula freq_yogurt milk_feeds feeds mmf_nobf min_milk_freq_nbf ///
// 	mmf_all mixed_milk mad_all egg_meat zero_fv sugar_bev unhealthy_food ///
// 	lbw anc4plus csection earlyanc mum_educ caste rururb wi wi_s state ///
// 	sex nat_wgt state_wgt round  

keep psu hh_num one int_date birthday birthmonth birthyear dob_date age_days agemos evbf eibf ///
	eibf_timing ebf2d ebf3d currently_bf prelacteal_milk prelacteal_water prelacteal_sugarwater ///
	prelacteal_gripewater prelacteal_saltwater prelacteal_juice prelacteal_formula ///
	prelacteal_tea prelacteal_honey prelacteal_janamghuti prelacteal_other /// 
	prelacteal_otherthanmilk prelacteal_milk_form bottle water juice tea other_liq milk ///
	formula freq_milk freq_formula freq_other_milk fortified_food gruel poultry meat legume ///
	nuts bread potato vita_veg leafy_green vita_fruit fruit_veg organ fish leg_nut yogurt ///
	semisolid carb dairy all_meat vita_fruit_veg agegroup sumfoodgrp ///
	fg0 fg1 fg2 fg3 fg4 fg5 fg6 fg7 fg8 any_solid_semi_food intro_compfood ebf age_ebf ///
	age_cbf cont_bf cont_bf_12_23 mdd freq_solids mmf_bf mmf_all_bf mad_all_bf ///
	egg_meat zero_fv sugar_bev unhealthy_food birth_weight cat_birth_wt lbw earlyanc anc4plus ///
	csection mum_educ_years mum_educ caste rururb wi wi_s national_wgt regional_wgt state_wgt ///
	sex diar fever ari state round

	
* Save data with name of survey
save iycf_NFHS3, replace 

