* make_IYCF_vars_NFHS3.do - NAME OF FILE
* Make IYCF Variables for NFHS3 data - PURPOSE OF FILE
* USING Updated WHO IYCF guidelines 2020 and recommended IYCF code from UNICEF NY

* Code Cotributors - Robert, Shekhar, Dnyaneshwar 


* KEEP COLLEAGUES FOLDER REFERENCES - Comment out when not used. 
cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"
use "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged\IAKR52FL.dta", clear

//cd "C:/Temp"
//use "C:\Users\Rojohnston\OneDrive - UNICEF\ECM-Nut OP4 Nutrition Governance, Partnerships, resources M&E\IIT-B\IYCF\NFHS3\IAKR52FL.dta", clear


*------------------------------

gen one=1
lab define no_yes 0 "No" 1 "Yes"

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

// below vars created to have common name w.r.t other codes
gen int_m = v006
gen int_y= v007
gen int_d = v016

tab v006
tab v016
tab v007

tab b1, m 
tab b2, m 

// below vars created to have common name w.r.t other codes
gen birthmonth=b1
gen birthyear = b2

*Day of birth
tab hw16, m
// inconsistent |         34        0.07       68.97
//   don't know |     11,036       21.41       90.38
//           99 |      1,489        2.89       93.27
//            . |      3,471        6.73      100.00

gen birthday = hw16
* set missing day of birth to 15th of month. 

replace birthday = 15 if hw16 > 31
tab birthday
* in theory 15th is middle of the month.
* We have created heaping on 15th of month
kdensity birthday if b5==1

cap drop dob_date
gen dob_date = mdy(b1, birthday, b2)
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

tab agemos, m 
cap drop agemos_x
gen agemos_x = v008 -  b3 if b5==1
scatter agemos_x agemos


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



*Early initiation of Breastfeeding (children born in last 24 months breastfed within 1hr)
la list m34
tab m34, m 

gen eibf = 0
replace eibf = 1 if m34 == 0 | m34==100 | m34 ==101 ///  0 -immediately, 101 - one hour, 100 - within 30min to 1hr 

replace eibf =. if age_days>=730 // age in days
tab eibf,m
tab m34 eibf, m

*Timing of initiation of Breastfeeding 
cap drop eibf_timing
gen eibf_timing =. 
replace eibf_timing = 0 if m34==0
replace eibf_timing = 1 if m34==101 | m34 ==100
replace eibf_timing = mod(m34,100) if m34>=102 & m34<=123
replace eibf_timing = mod(m34,200)*24 if m34>=201 & m34<=223
replace eibf_timing =.  if age_days>=730
la var eibf_timing "Timing of start of breastfeeding (in hours)"
tab eibf_timing,m
scatter m34 eibf_timing
kdensity eibf_timing
*





*Continued breastfeeding / normally presented from 12-15 months or 18-23 months

la list m4
//  95 still breastfeeding
recode m4 (95=1)(0/94 96/99=0)(missing=.), gen(cont_bf)
tab m4 cont_bf , m 

gen cont_bf_12_23 = cont_bf if age_days>335 &age_days<730 
tab cont_bf_12_23, m





*EXCLUSIVE BREASTFEEDING
*Exclusive breastfeeding is defined as breastfeeding with no other food or drink, not even water.
* using the WHO guideline for defining exbf variable - 
*create a condition variable based on weather the child received any other food items (liquid/solids/semi-solids) on previous day
*Condition = 1 indicates that the child has not received any food items on yesterday

cap drop condition 					   
gen condition = 0	if age_days<183				   
replace condition = 1 if v409==0 & v410==0 & v410a==0 & v411==0 & v411a==0 & v412a==0 & v412b==0 & v413==0 & v414a==0 & v414b==0 & ///
                         v414c==0 & v414d==0 & v414e==0 & v414f==0 & v414g==0 & v414i==0 & v414j==0 & v414k==0 & v414l==0 & v414m==0 & ///
						 v414n==0 & v414o==0 & v414p==0 & v414q==0 & v414s==0
tab condition, m

cap drop exbf
gen exbf = 0 if age_days<183
replace exbf = 1 if condition == 1 & cont_bf==1 & age_days<183 
tab exbf

/*
       exbf |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      3,016       59.03       59.03
          1 |      2,093       40.97      100.00
------------+-----------------------------------
      Total |      5,109      100.00
*/
		

* MEDIAN deuration of exbf for children below six months

gen agemos_round = round(age_days/30.42, 0.01)   //exact age in months round of to 2 digits after decimal
tab agemos_round, m 

* create a age in months variable for exclusively bf children
cap drop agemos_ebf
gen agemos_ebf = agemos_round if age_days<=183
kdensity agemos_ebf


*set agemos_ebf to missing if exbf=no
replace agemos_ebf=. if exbf==0


*median duration of EXBF is the median of agemos_ebf
univar agemos_ebf

/*
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
agemos_ebf    2121     2.47     1.64     0.00     1.08     2.27*     3.68     6.02
-------------------------------------------------------------------------------
*/



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




*For prelacteal feed variables are
/*
-------------------------------------------------
m55a      		      milk other than BM
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


* Prelacteal feeds
* What was [NAME] given to drink? within first three days after delivery
clonevar prelacteal_milk = m55a
replace prelacteal_milk = 1 if m55g==1 // added formula to prelacteal milk
replace prelacteal_milk = . if m55a==9
tab m55a prelacteal_milk
* Compare to variable - gave nothing
tab m55z prelacteal_milk


clonevar prelacteal_water = m55b
replace prelacteal_water = . if m55b==9
tab m55b prelacteal_water

clonevar prelacteal_sugarwater = m55c
replace prelacteal_sugarwater = . if m55c==9
tab m55c prelacteal_sugarwater

clonevar prelacteal_gripewater = m55d
replace prelacteal_gripewater = . if m55d==9
tab m55d prelacteal_gripewater

clonevar prelacteal_saltwater = m55e
replace prelacteal_saltwater = . if m55e==9
tab m55e prelacteal_saltwater

clonevar prelacteal_formula = m55g
replace prelacteal_formula = . if m55g==9
tab m55g prelacteal_formula

clonevar prelacteal_honey = m55i
replace prelacteal_honey = . if m55i==9
tab m55i prelacteal_honey

clonevar prelacteal_janamghuti = m55j
replace prelacteal_janamghuti = . if m55j==9
tab m55j prelacteal_janamghuti



cap drop prelacteal_other 
gen prelacteal_other =0
local prelacteal = "m55b m55c m55d m55e m55f m55h m55i m55j m55k m55l m55m m55n m55x"
foreach var in `prelacteal' { 
	replace prelacteal_other = 1 if  `var'==1
}
tab  prelacteal_other, m
* Compare to variable - gave nothing
tab m55z prelacteal_other
* m55z does faithfully represent children who were given nothing in first 3 days. 
 

* Bottle Feeding
* for variables that are stand alone, code missing as missing. 
tab m38, m 
clonevar bottle = m38
replace bottle = . if m38>2       //m38 - did [Name] drink anything from bottle yesterday or last light
replace bottle = . if age_days>=730
tab m38 bottle, m



/*
Var Name    Label
---------------------------------------------------------------------------
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
--------------------------------------------------------------------------
*/

* for all dietary diversity variables, recode foods into food groups

* following global guidance on IYCF analysis, this allows for maximium children to be included in indicator 

tab v410a , m
//  gave child |
//      tea or |
//      coffee |      Freq.     Percent        Cum.
// ------------+-----------------------------------
//           0 |     23,937       60.82       60.82
//           1 |     15,259       38.77       99.60
//           8 |         94        0.24       99.83
//           9 |         65        0.17      100.00
// ------------+-----------------------------------
//       Total |     39,355      100.00

foreach var of varlist v409- v414u {
	recode `var' (1=1) (2 8 9 .=0) , gen(`var'_rec)
	lab val `var'_rec no_yes
}


* LIQUIDS
clonevar water					=v409_rec
clonevar juice			        =v410_rec
clonevar tea_coff			    =v410a_rec 
clonevar milk			        =v411_rec
replace  milk = 1 if v412_rec ==1 // fresh milk 
* fresh milk var was not used. 

clonevar formula 		        =v411a_rec
clonevar other_liq 		        =v413_rec

*-------------------------------------
* LIQUIDS from CNNS
// clonevar water			=q310a_rec
// clonevar juice			=q310b_rec
// clonevar broth			=q310c_rec
// clonevar milk			=q310d1_rec
// clonevar formula 		=q310e1_rec
// clonevar other_liq 		=q310f_rec
*-------------------------------------

* SOLIDS SEMISOLIDS
clonevar fortified_food                         =v412a_rec // from q480 Any commercially fortified baby food such as Cerelac or Farex?
clonevar gruel        							=v412b_rec // other porridge/gruel
// These belong in solid/semi-solid list and will be added to bread, rice other grains


clonevar poultry                               = v414a_rec //chicken_duck_other birds

clonevar meat                                  = v414b_rec // gave child other meat
replace meat =1 if 								 v414h_rec==1 // (beef, pork-na

clonevar legume                                = v414c_rec //foods_of_beans_peas_lentils
clonevar nuts                                  = v414d_rec

clonevar bread                                 = v414e_rec  //food_of_bread_noodles_other_grains 
replace bread =1 if  gruel ==1

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


lab var bread "bread, noodles, other grains"  // includes cereals, gruel, porridge 



*Define eight food groups following WHO recommended IYCF indicators
gen carb = 0
replace carb = 1 if bread ==1 | potato==1 
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

lab var cont_bf "8: Breastmilk"
lab define cont_bf 0 "No" 1 "yes" 
tab cont_bf,m




foreach var of varlist carb leg_nut dairy all_meat vita_fruit_veg fruit_veg cont_bf {
	lab val `var' no_yes
}

* Test all 8 food groups
* Check N, yes/no output, no missing	
foreach var of varlist carb dairy all_meat egg vita_fruit_veg fruit_veg cont_bf {
	tab `var' , m
}
		
		
* Age groups in blocks of 6 months
gen agegroup = floor(age_days/183 +1)   //agemons/6 +1
lab def agegroup 1 "0-5m" 2 "6-11m" 3 "12=17m" 4 "18-23m" 5 "24-29m" 6 "30-35m" 7 "36-41m" 8 "42-47m" 9 "48-53m" 10 "54-59m"
lab val agegroup agegroup


* Number of food groups out of eight
cap drop sumfoodgrp
egen sumfoodgrp = rowtotal (carb leg_nut dairy all_meat egg vita_fruit_veg fruit_veg cont_bf)
tabulate sumfoodgrp, generate(fg)
rename (fg1 fg2 fg3 fg4 fg5 fg6 fg7 fg8 fg9) ///
	   (fg0 fg1 fg2 fg3 fg4 fg5 fg6 fg7 fg8)		

	   	   
	   
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


	
*recode state code of nfhs3 
gen statecode = .
replace statecode =2  if v101 ==28			 
replace statecode =3  if v101 ==12			 
replace statecode =4  if v101 ==18			 
replace statecode =5  if v101 ==10			 
replace statecode =7  if v101 ==22			 
replace statecode =10  if v101 ==30			 
replace statecode =11  if v101 ==24			 
replace statecode =12  if v101 ==6			 
replace statecode =13  if v101 ==2			 
replace statecode =14  if v101 ==1			 
replace statecode =15  if v101 ==20			 
replace statecode =16  if v101 ==29			 
replace statecode =17  if v101 ==32			 
replace statecode =19  if v101 ==23			 
replace statecode =20  if v101 ==27			 
replace statecode =21  if v101 ==14			 
replace statecode =22  if v101 ==17			 
replace statecode =23  if v101 ==15			 
replace statecode =24  if v101 ==13			 
replace statecode =25  if v101 ==7			 
replace statecode =26  if v101 ==21			 
replace statecode =28  if v101 ==3			 
replace statecode =29  if v101 ==8			 
replace statecode =30  if v101 ==11			 
replace statecode =31  if v101 ==33			 
replace statecode =32  if v101 ==16			 
replace statecode =33  if v101 ==9			 
replace statecode =34  if v101 ==5			 
replace statecode =35  if v101 ==19			 



* Generate 'region' variable
gen double region:region=0
replace region=1 if statecode==25 |  statecode==12 | statecode==13 | statecode==14 | statecode==28 | statecode==29 | statecode==34
replace region=2 if statecode==7 |  statecode==19 | statecode==33
replace region=3 if statecode==5 |  statecode==35 | statecode==15 | statecode==26
replace region=4 if statecode==3 |  statecode==30 | statecode==32 | statecode==22 | statecode==4 | statecode==24 | statecode==21 | statecode==23
replace region=5 if statecode==11 |  statecode==20 | statecode==10
replace region=6 if statecode==2 |  statecode==16 | statecode==17 | statecode==31 | statecode==36


* In NFHS use national weights for region
lab define region 1 "North" 2 "Central" 3 "East" 4 "Northeast" 5 "West" 6 "South"
lab var region "Region" 
lab val region region


/*
------------------------------------------------------------------------------------------------------------------------------------------------
region       Region Name       states included in the region (statecode)
-------------------------------------------------------------------------------------------------------------------------------------------------
region 1       North           NCT of Delhi(25), Haryana(12), Himachal Pradesh(13), Jammu and Kashmir(14), Punjab(28), Rajasthan(29), Uttarakhand(34)
				        	   						 							   
region 2	   Central		   Chhattisgarh(7), Madhya Pradesh(19), Uttar Pradesh(33)
									
region 3	   East			   Bihar(5), West Bengal(35), Jharkhand(15), Odisha(26)	 							

region 4       NorthEast       Arunachal Pradesh(3), Sikkim(30), Tripura(32),  Meghalaya(22), Assam(4), Nagaland(24), Manipur(21), Mizoram(23)

region 5       West            Gujarat(11), Maharshtra (20), Goa(10)

region 6       South           Andhra Pradesh(2),  Karnataka(16),  Kerala(17),  Tamil Nadu(31),  Telangana(36) 
--------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------
*/



*Introduction to the semi_solid, solid, soft_food in children from 6-8 months of age
* based on v414s: gave child solid, semi solid, soft foods yesterday 
* sumfoodgrp - number of food groups eaten yesterday
tab sumfoodgrp v414s, m 
gen intro_compfood = 0
replace intro_compfood =. if v414s == 9
replace intro_compfood = 1 if v414s == 1 | sumfoodgrp>=1 
replace intro_compfood =. if age_days<=183 | age_days>=243
la var intro_compfood "Intro to complementary food 6-8 months of age"
tab intro_compfood

*Minimum Dietary Diversity- code for new indicator definition 
* currently_bf - identifies children still breastfeeding
* Following new definition MDD is met if child fed 5 out 8 food groups regardless of breastfeeding status *
gen mdd=0
replace mdd=1 if sumfoodgrp >=5 
replace mdd=. if age_days<=183 | age_days>=730
la var mdd "Minimum Dietary Diversity (2020)"
tab mdd


* Currently Breastfeeding
cap drop currently_bf
recode m4 (95=1)(0/94 96/99=0)(missing=.), gen(currently_bf)
tab m4 currently_bf, m 
tab currently_bf,m


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

*--------------------------------------------------------------------


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

// CORRECT THESE VARIABLES BELOW
		
* LBW  //low birth weight
gen lbw = . 
replace lbw = 1 if m19 <=2500
replace lbw = 0 if m19 >2500 & m19<8000
tab lbw,m


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
gen caste = 0 if v130!=.                             //caste =0 if religion is missing
replace caste = 1 if s46 ==1 
replace caste = 2 if s46 ==2 
replace caste = 3 if s46 ==3
replace caste = 4 if s46 ==4
replace caste = 5 if s46 ==. | s46==9 | s46 ==8      // missing values are not assigned to any caste
lab define caste 1 "Scheduled caste" 2"Scheduled tribe" 3"OBC"  4"Others" 5 "Missing/don't know" 
lab val caste caste
lab var caste "Caste"
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
	
* Survey Weights
gen national_wgt = v005     //national women's weight (6 decimals)
gen state_wgt =v005s    // 	state women's weight (6 decimals)
	
*sex of child
gen sex=b4
tab sex b4
	
	
	
	
	
gen round=1


keep one birthday birthmonth birthyear int_y int_m int_d int_date age_days agemos ///
evbf eibf eibf_timing exbf agemos_ebf agemos_round ebf2d prelacteal_milk prelacteal_water prelacteal_sugarwater ///
prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey ///
prelacteal_janamghuti prelacteal_other bottle water juice milk ///
formula other_liq yogurt fortified_food bread legume vita_veg potato leafy_green ///
vita_fruit fruit_veg organ meat egg fish nut cont_bf semisolid carb leg_nut dairy ///
all_meat vita_fruit_veg agegroup sumfoodgrp diar fever ari cont_bf_12_23 ///
intro_compfood mdd currently_bf freq_solids mmf_bf  ///
mmf_all mad_all egg_meat ///
zero_fv sugar_bev  lbw anc4plus csection earlyanc ///
mum_educ caste rururb wi statecode region sex national_wgt state_wgt round



	
	
* Save data with name of survey
save iycf_NFHS3, replace 
