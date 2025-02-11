* Make IYCF Variables for RSOC data
* create standardized data following WHO 2020 IYCF indicator definitions
* Robert 

*cd "C:/Temp"

*use "C:\Temp\IYCF\RSOC\EMW_INDIA_RSOC.dta", clear  // complete data at individual level
* EMW - ever married women
*use "C:\Temp\IYCF\RSOC\Household_India_RSOC.dta", clear
* Household data does not include IYCF

cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"
use "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged\EMW_INDIA_RSOC.dta"


* make IYCF vars.do
gen one=1

* identify number of living children under five
* A2.1 number of live births
tab q134, m 
// Live Birth           |     53,987       98.95       98.95
* Complete Underfive N  53,987   ???

* ever breastfed
tab q184
* Children under 3 years of age = 35,035 
 
* Birth date
tab q136a_1, m 
tab q136b_1 
tab q136c_1
* Children with birth dates -   50,102 


gen birthday =  q136a_1
gen birthmonth = q136b_1
gen birthyear = q136c_1
replace birthyear = . if q136c_1<2010 | q136c_1>20114 
gen dob_date = mdy(birthmonth , birthday , birthyear)
format dob_date %td
// kdensity dob_date
 
 

 
* date of interview - Data recorded as string
tab q106_1


* Convert string to number
destring q106_1, gen(temp)

gen int_y = (temp/100) - floor(temp/100) 

gen int_m = (temp/10000) - floor(temp/10000) 
replace int_m = int_m - int_y/100

gen int_d = floor(temp/10000)
replace int_m = int_m*100
replace int_y = 2000 + (int_y*100)

replace int_d=int(int_d)
replace int_m=int(int_m)
replace int_y=int(int_y)

* Corrections to records of interview date
replace int_y = 2013 if int_m ==11 | int_m ==12
replace int_y = 2014 if int_m >=1 & int_m <=6

gen int_date = mdy(int_m , int_d , int_y)
format int_date %td

// order q106_1 int_d int_m int_y , first
list q106_1 int_d int_m int_y int_date in 1/20 

* Change from age in months to age in days
* Ages in month by day ranges
* 6 - 23 M  (183 - 730)
* Under 24 M
* 6 - 8 M   (183 - 243)
* 9 -23 M   (243 - 730)
* 6-11 M    (183 - 335)
* 12 - 23 M (335 - 730)
* Underfive (< 1825)

* Age in days
gen age_days = int_date - dob_date 
tab age_days,m 
list q106_1 int_d int_m int_y int_date dob_date q136a_1 q136b_1 q136c_1 if age_days<0
replace age_days =. if age_days<0 | age_days>1825

gen agemos = floor(age_days/30.42)
tab agemos, m 
graph bar (count) one, over(agemos)

* IYCF data collected only for children under 3 years of age
drop if age_days> 1095  // 3 years = 1096 days 
* 34,216 children under 3 years of age

* Ever breastfed (children born in past 24 months)
tab q184, m 
gen evbf = 0
replace evbf=1 if q184==1
replace evbf=. if age_days>=730 
la var evbf "Ever breastfed (children born in past 24 months)"
tab evbf q184, m

*Early initiation of Breastfeeding (children born in last 24 months breastfed within 1hr)
tab q185a1_1
tab q185a1_2 
tab q185a1_3

gen eibf = 0
replace eibf = 1 if (q185a1_2 <=1 & q185a1_2 == 1) | (q185a1_1==0)   //here response as "immediately"
replace eibf =. if age_days>=730 // age in days
tab  q185a1_1 eibf, m
tab  q185a1_2 eibf, m

*Timing of initiation of Breastfeeding
cap drop eibf_timing
gen eibf_timing =. 
replace eibf_timing = q185a1_3*24 if q185a1_3>=1
replace eibf_timing = q185a1_2 if q185a1_2>=1
replace eibf_timing = 0 if q185a1_1==0

replace eibf_timing = 48 if eibf_timing>48
replace eibf_timing =.  if age_days>=730
la var eibf_timing "Timing of start of breastfeeding (in hours)"
la def eibf_timing 48 "48 hours or more"
la val eibf_timing eibf_timing
tab eibf_timing
tab  q185a1_2 eibf_timing, m
tab  q185a1_3 eibf_timing, m




*Continued breastfeeding
tab q190
gen cont_bf = 0
replace cont_bf = 1 if q190 == 1 
tab cont_bf q190

gen cont_bf_12_23 = cont_bf if age_days>335 &age_days<730 
tab cont_bf_12_23, m




*EXCLUSIVE BREASTFEEDING
*Exclusive breastfeeding is defined as breastfeeding with no other food or drink, not even water.
* using the WHO guideline for defining exbf variable - 
*create a condition variable based on weather the child received any other food items (liquid/solids/semi-solids) on previous day
*Condition = 1 indicates that the child has not received any food items on yesterday

cap drop condition 					   
gen condition = 0	if age_days<183				   
replace condition = 1 if q195a1_1==2 & q195a1_2==2 & q195a1_3==2 & q195a1_4==2 & q195a1_5==2 & q195a1_6==2 & q195a1_7==2 & q197a1_1==2 & q197a1_2==2 & ///
                         q197a1_3==2 & q197a1_4==2 & q197a1_5==2 & q197a1_6==2 & q197a1_7==2 & q197a1_8==2 & q197a1_9==2 & q197a1_10==2 & q197a1_11==2 & ///
						 q197a1_12==2 & q197a1_13==2 & q197a1_14==2 & q197a1_15==2 & q198==2

tab condition, m

cap drop exbf
gen exbf = 0 if age_days<183
replace exbf = 1 if condition == 1 & cont_bf==1 & age_days<183 
tab exbf
/*
      exbf |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      1,832       31.74       31.74
          1 |      3,939       68.26      100.00
------------+-----------------------------------
      Total |      5,771      100.00
*/



* MEDIAN deuration of exbf for children below six months

gen agemos_round = round(age_days/30.42, 0.01)   //exact age in months round of to 2 digits after decimal
tab agemos_round, m 

* create a age in months variable for exclusively bf children
cap drop agemos_ebf
gen agemos_ebf = agemos_round if age_days<183
kdensity agemos_ebf


*set agemos_ebf to missing if exbf=no
replace agemos_ebf=. if exbf==0


*median duration of EXBF is the median of agemos_ebf
univar agemos_ebf

/*
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
agemos_ebf    3980     3.05     1.68     0.00     1.64     3.02     4.47     6.02
-------------------------------------------------------------------------------
*/




* Exclusively breastfed for the first two days after birth
* Percentage of children born in the last 24 months who were fed exclusively with breast milk for the first two days after birth
* q187 Was [NAME] given anything to drink other than breast milk within the first three days after delivery?
* The RSOC did not ask the question in the best method, so we are trying to edit to represent 2 	days. 

tab q187
cap drop ebf2d
gen ebf2d =0
replace ebf2d=1 if q303!=1 // q303!=1 means no other drink was given to the child in 1st three days
replace ebf2d =. if age_days >2
* Question was not asked correctly so variable will only be valid at national level 
* 30 children in sample <= 2 days
tab ebf2d q187, m 



* Prelacteal feeds
* What was [NAME] given to drink? within first three days after delivery
* q188_1 q188_2 q188_3 q188_4 q188_5 q188_6 q188_7 q188_8 q188_9 q188_96

cap drop prelacteal*
gen prelacteal_milk       = cond(q188_1==1, 1, 0)
gen prelacteal_water      = cond(q188_2==1, 1, 0)
gen prelacteal_sugarwater = cond(q188_3==1, 1, 0)
gen prelacteal_gripewater = cond(q188_4==1, 1, 0)
gen prelacteal_saltwater  = cond(q188_5==1, 1, 0)
gen prelacteal_fruitjuice = cond(q188_6==1, 1, 0)
gen prelacteal_formula    = cond(q188_7==1, 1, 0)
gen prelacteal_honey      = cond(q188_8==1, 1, 0)
gen prelacteal_janamghuti = cond(q188_9==1, 1, 0)
gen prelacteal_other      = cond(q188_96==1, 1, 0)

local prelacteal = "prelacteal_milk prelacteal_water prelacteal_sugarwater prelacteal_gripewater prelacteal_saltwater prelacteal_fruitjuice prelacteal_formula prelacteal_honey prelacteal_janamghuti prelacteal_other"
foreach var in `prelacteal' { 
	replace `var' = . if  age_days>=730
}

tab  q187 prelacteal_milk
tab  prelacteal_milk
tab  q187 prelacteal_other

*Colostrum Feeding
tab q186
gen colostrum = 0
replace colostrum=1 if q186==1
replace colostrum=. if age_days>=730
tab colostrum q186, m 

* bottle feeding (did child drink anything from bottle)
gen bottle =. 


/*
                     value
variable name        label      variable label
--------------------------------------------------------------------------------------------

q184                           A5.2. Did you ever breastfeed <NAME>
q185a1_1                       A5.3. How long after the birth did first put to the breast - IMMEDIATELY /WITHIN
q185a1_2                       A5.3. How long after the birth did first put to the breast - HOURS
q185a1_3                       A5.3. How long after the birth did first put to the breast - DAYS
q186                           A5.4. Did you feed first yellow thick breast milk (Colostrum)/Khees to the baby?
q187                           A5.5. In the first 3 days after delivery, was (NAME) given anything to drink other than breast milk?             
q188_1                         A5.6. Milk other than breast milk
q188_2                         A5.6. Plain Water
q188_3                         A5.6. Sugar or Glucose water
q188_4                         A5.6. Gripe Water
q188_5                         A5.6. Sugar- Salt-Water Solution
q188_6                         A5.6. Fruit Juice
q188_7                         A5.6. Infant Formula
q188_8                         A5.6. Honey
q188_9                         A5.6. Janamghuti
q188_96                         A5.6. Other
q189                           A5.7. CHECK
q190                           A5.8. Are you still breastfeeding this child?
q191_1                         DAYS (A5.9. How many days/months did you breastfeed the child?)  
q191_2                         MONTHS (A5.9. How many days/months did you breastfeed the child?)  
q192                           A5.10. Was breastfed yesterday during the day or at night?
q193                           A5.11. Was given any vitamin drops or other medicines as drops yesterday during
q194                           A5.12. Was given ORS yesterday during the day or at night?
q195a1_1                       A5.13. a) PLAIN WATER    
q195a1_2                       A5.13. b) WATERY ITEMS  SUCH AS DAL/RICE WATER
q195a1_3                       A5.13. c) POWDER MILK/FORMULA
q195a1_4                       A5.13. d) COWS/BUFFALOS/GOATS/ OTHER ANIMAL MILK
q195a1_5                       A5.13. e) JUICE OR JUICE DRINKS (MANGO, ORANGE, APPLE,  LEMON ETC)
q195a1_6                       A5.13. f) BUTTER MILK/BEATEN CURD
q195a1_7                       A5.13. g) ANY OTHER LIQUIDS
q196a1_3                       A5.14. POWDER MILK/FORMULA (NUMBER OF TIMES)
q196a1_4                       A5.14. COWS/BUFFALOS/GOATS/OTHER ANIMAL MILK (NUMBER OF TIMES)
q196a1_6                       A5.14. BUTTER MILK/BEATEN CURD (NUMBER OF TIMES)
q197a1_1                       A5.15. ANY COMMERCIALLY FORTIFIED BABY FOOD SUCH AS CERELAC ETC.
q197a1_2                       A5.15. BREAD, ROTI, CHAPATI, RICE, KITCHDI, NOODLES, PORRIDGE,  BISCUITS, IDLI, 
q197a1_3                       A5.15. PULSES/LENTILS/BEANS OR FOOD PREPARED WITH MIXING PULSES/LENTILS/LEGUMES
q197a1_4                       A5.15. PUMPKIN, CARROTS, OR SWEET POTATOES THAT ARE YELLOW OR ORANGE INSIDE?
q197a1_5                       A5.15. POTATOES, WHITE YAMS, OR ANY OTHER FOODS MADE FROM ROOTS?
q197a1_6                       A5.15. ANY DARK GREEN, LEAFY VEGETABLES?
q197a1_7                       A5.15. RIPE MANGOES, PAPAYAS, CANTALOUPE, OR JACKFRUIT?
q197a1_8                       A5.15. ANY OTHER FRUITS OR VEGETABLES?
q197a1_9                       A5.15. LIVER, KIDNEY, HEART OR OTHER ORGAN MEATS?
q197a1_10                      A5.15. ANY MEAT SUCH AS CHICKEN, BEEF, PORK, LAMB, GOAT OR DUCK?
q197a1_11                      A5.15. EGGS?
q197a1_12                      A5.15. FRESH OR DRIED FISH OR SHELLFISH?
q197a1_13                      A5.15. ANY FOODS MADE FROM NUTS SUCH AS PEANUTS, CASHEW NUTS, ALMOND ETC.?
q197a1_14                      A5.15. CHEESE, PANEER, DAHI OR OTHER FOOD MADE FROM MILK?
q197a1_15                      A5.15. ANY OTHER SOLID OR SEMI-SOLID FOOD?
q198                           A5.16. Did eat any solid, semi-solid, or soft foods yesterday during the day or
q199_1                         NUMBER OF TIMES (A5.17. How many times did eat solid, semi-solid, or soft foods   
q199dk_98                      A5.17. Do not know     
q200                           A6.1. Do you have a Mother Child Protection (MCP) card for this child  where a


*/

********************************************************************************
* Food groups (liquids and solids)
********************************************************************************

* recode foods into food groups
* 	yes = 1, 
* 	no and don't know = 0
* following global guidance on IYCF analysis, this allows for maximium children to be included in indicator 

lab define no_yes 0 "No" 1 "Yes"



* Liquids in past 24 hours
foreach var of varlist q195a1_1 - q195a1_7 {
	recode `var' (1=1) (2 8 98 .=0) , gen(`var'_rec)
	lab val `var' no_yes
}
* q196 - number of times consumed dairy

* Solids in past 24 hours
foreach var of varlist q197a1_1 -  q197a1_15 {
	recode `var' (1=1) (2 8 98 . =0) , gen(`var'_rec)
	lab val `var' no_yes
}

* LIQUIDS
clonevar water			=q195a1_1_rec
clonevar juice			=q195a1_5_rec
clonevar broth			=q195a1_2_rec
clonevar milk			=q195a1_4_rec
replace milk = 1 if q195a1_6_rec ==1 // buttermilk or beaten curd
clonevar formula 		=q195a1_3_rec
clonevar other_liq 		=q195a1_6_rec
* SOLIDS SEMISOLIDS
clonevar yogurt			=q197a1_14_rec // any cheese, yogurt or other food made from milk?
clonevar fortified_food =q197a1_1_rec  // any commercially fortified food
clonevar bread 			=q197a1_2_rec  // any bread, roti, chapati, rice, noodles, biscuits, idli, porridge 
clonevar legume			=q197a1_3_rec  // pulses, lentils beans legumes or foods containing legumes
clonevar vita_veg		=q197a1_4_rec  // oranged fleshed vegetables
clonevar potato 		=q197a1_5_rec  // any white potato, white yam, cassava or other food made from roots
clonevar leafy_green	=q197a1_6_rec
clonevar vita_fruit		=q197a1_7_rec
clonevar fruit_veg		=q197a1_8_rec
clonevar organ			=q197a1_9_rec
* clonevar poultry		=
clonevar meat			=q197a1_10_rec  // includes poultry
clonevar egg			=q197a1_11_rec
clonevar fish			=q197a1_12_rec
clonevar nut			=q197a1_13_rec  // beans, peas, lentils, nuts
*clonevar cheese		=q197a1_14_rec  included as yogurt above
*gen fat			= 0              // no data collcted on oil, ghee, butter consumption in RSOC
clonevar semisolid		=q197a1_15_rec  // any other solid, semi-solid or soft food

lab var water "water"
lab var juice "juice"
lab var broth "broth"
lab var milk "milk"
lab var formula "formula"
lab var other_liq "other_liq"

lab var bread "Bread, rice, biscuits, idli, porridge"
lab val bread bread

* Define eight food groups following WHO recommended IYCF indicators
gen carb = 0
replace carb = 1 if bread ==1 | potato==1 
lab var carb "1: Bread, rice, grains, roots and tubers"

gen leg_nut = 0
replace leg_nut = 1 if legume ==1 | nut ==1 
lab var leg_nut "2: Legumes and nuts"

gen dairy = 0
replace dairy = 1 if formula ==1 | yogurt==1 | milk==1
lab var dairy "3: Dairy - milk, formula, yogurt, cheese"
 
gen all_meat = 0
replace all_meat = 1 if organ ==1 | meat ==1 | fish ==1  
lab var all_meat "4: Flesh foods(meat, fish, poultry and liver/organ meats)"
// lab val all_meat all_meat

lab var egg "5: Eggs"

gen vita_fruit_veg = 0
replace vita_fruit_veg = 1 if vita_fruit ==1 | vita_veg==1 | leafy_green==1
lab var vita_fruit_veg "6: Vitamin A rich fruits and vegetables"

lab var fruit_veg "7: Other fruits and vegetables"


lab var cont_bf "8: Breastmilk"
lab define cont_bf 0 "No" 1 "yes" 
tab cont_bf,m



foreach var of varlist water juice  broth milk  formula other_liq carb dairy all_meat egg vita_fruit_veg fruit_veg cont_bf semisolid {
	lab val `var' no_yes
}
* Test all liquids
foreach var of varlist water juice  broth milk  formula other_liq {
	tab `var' , m
}
* Test all 8 food groups 
foreach var of varlist carb dairy all_meat egg vita_fruit_veg fruit_veg cont_bf semisolid {
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
rename (fg1 fg2 fg3 fg4 fg5 fg6 fg7 fg8 ) ///
	   (fg0 fg1 fg2 fg3 fg4 fg5 fg6 fg7 )		
* No data collcted on oil, ghee, butter consumption in RSOC
* Not included in RSOC
	
* Child Illness
* Diarrhea
tab q257
recode q257 (1=1)(2 8=0), gen(diar)
tab diar q257
* Fever
 tab q263
recode q263 (1=1)(2 8=0), gen(fever)
tab fever q263	
* Cough with rapid breathing excluding those with only nasal breathing problems
* q266 q267 q268
recode q266 (1=1)(2 8=0), gen(ari)
lab val diar fever ari no_yes
tab q267 ari
replace ari=0 if q267!=1
replace ari=0 if q268==2 | q268==96 | q268==98
tab ari q267
tab ari q268
tab ari, m 




*Introduction to the semi_solid, solid, soft_food in children from 6-8 months of age
* based on 
* q198: did [name] eat any solid, semisolid, or soft foods yesterday during the day
* q199_1: number of |times index child ate solid, semi solid, soft foods yesterday 
* sumfoodgrp - number of food groups eaten yesterday
tab q198
* q198 is obviously wrong. it was interpreted as any other feeds not specified above. 

tab q199_1 
tab q199_1 q198
* inconsistency between q198 and q199_1
tab sumfoodgrp q198, m 
* inconsistency between q311 and sumfoodgrp

gen intro_compfood = 0
replace intro_compfood = 1 if q199_1 >= 1 | sumfoodgrp>=1 
replace intro_compfood =. if age_days<=183 | age_days>=243
la var intro_compfood "Intro to complementary food 6-8 months of age"
tab intro_compfood
// this indicator is always 6-8 m 

*Minimum Dietary Diversity- code for new indicator definition 
* currently_bf - identifies children still breastfeeding
* Following new definition MDD is met if child fed 5 out 8 food groups regardless of breastfeeding status *

gen mdd=0
replace mdd=1 if sumfoodgrp >=5 
replace mdd=. if age_days<=183 | age_days>=730
la var mdd "Minimum Dietary Diversity (2020)"
tab mdd, m 


* Currently Breastfeeding
tab q192
recode q192 (1=1)(2 8 98=0)(missing=.), gen(currently_bf)
tab currently_bf q192, m 

*Minimum Meal Frequency (MMF) 
*For currently breastfeeding children: MMF is met if child 6-8 months of age receives solid, semi-solid or soft foods at least 2 times and a child 9-23 months of age receives solid, semi-solid or soft foods at least 3 times*******
* Variable fed_solids identifies the number of times a child was fed solid, semi-solid or soft foods*

* For this variable please remember to set response "don't knows" to zero


tab q199_1 
cap drop freq_solids
gen freq_solids=0 
replace freq_solids = q199_1 if q199_1 >0 & q199_1 <22 
tab freq_solids q199_1, m 

* RSOC is different from NFHS - It records # of feeds per day instead of 1-7. 
replace freq_solids =7 if q312 >=7 & q312 <50

* In RSOC there are ~1000 cases of children who consumed foods yesterday but we don't know frequency - recode as 1 feed
replace freq_solids=1 if freq_solids==. & sumfoodgrp >=1 & sumfoodgrp <=8
tab sumfoodgrp freq_solids, m 

* In RSOC there 372 cases of eating 0 food groups but consumed semi-solid 1+ times yesterday, - recode as 1 food group. 
replace sumfoodgrp=1 if sumfoodgrp==0 & freq_solids>=1 & freq_solids<=7
tab sumfoodgrp freq_solids, m 

*Minimum Meal Frequency (MMF) Breastfeeding
gen mmf_bf=0
replace mmf_bf=1 if freq_solids>=2 & currently_bf==1 & age_days>183 & age_days<243 
replace mmf_bf=2 if freq_solids>=3 & currently_bf==1 & age_days>=243 & age_days<730 
replace mmf =. if age_days<=183 | age_days>=730
la def mmf  0 "Inadequate MMF" 1 "Adequate freq(2) and BF 6-8M" 2 "Adequate freq(3) and BF 9-23M"
la val mmf mmf
tab mmf, m 

*For currently non-breastfed children: MMF is met if children 6-23 months of age receive solid, semi-solid or soft foods or milk feeds at least 4 times during the previous day and at least one of the feeds is a solid, semi-solid or soft feed*******
* Variable fed_milk refers to number of times a child received milk other than breastmilk i.e. other animal milk*
* Variable fed_formula refers to number of times a child received infant formula*

* Generates the total number of times a non-breastfed child received solid, semi-solid or soft foods or milk feeds*
tab milk, m
tab q196a1_4, m 

// q196a1_3 q196a1_4 q196a1_6

gen freq_milk = q196a1_4
replace freq_milk = 7 if q196a1_4 >=7 & q196a1_4 <50
replace freq_milk = 0 if milk ==0  | q196a1_4 >98 // includes missing
tab q196a1_4 freq_milk , m 

tab formula, m
tab q196a1_3, m 
gen freq_formula=q196a1_3
replace freq_formula = 7 if q196a1_3 >=7 & q196a1_3 <98
replace freq_formula = 0 if formula ==0  | q196a1_3 >98 // includes missing
tab q196a1_3 freq_formula , m 

tab yogurt, m 
tab q196a1_6, m
gen freq_yogurt = q196a1_6
replace freq_yogurt = 7 if q196a1_6 >=7 & q196a1_6 <98
replace freq_yogurt = 0 if yogurt ==0  | q196a1_6 >98 // includes missing
tab q196a1_6 freq_yogurt , m 

* Frequency of Milk and non solid semi-solid dairy feeds in children 0-23 months
gen milk_feeds= freq_milk + freq_formula + freq_yogurt	
replace milk_feeds = 7 if milk_feeds>=7 & milk_feeds !=.
la val milk_feeds feeds
replace milk_feeds =. if age_days<0 | age_days>=730
tab milk_feeds, m 
* combines number of times fed milk, buttermilk, infant formula and yogurt. Please ensure there are no missings(.) 
* all missings have been set to 0 to allow summation across row. 

* OVERALL FREQUENCY FEEDS
gen feeds= freq_milk + freq_formula + freq_solids	
replace feeds = 7 if feeds>=7 & feeds !=.
la def feeds 7 "7+ feeds"
la val feeds feeds
la var feeds  "Frequency of solid, semi-solid, milk and formula feeds"
tab feeds, m 	
* please ensure there are no missings(.) and all missings have been set to 0 in the age group to allow summation across row. 
* STATA will mark feeds as missings if any of them are missing.

*Minimum Meal Frequency (MMF) NON Breastfeeding
*  For currently non-breastfed children: Children 6-23 months of age who received solid, semi-solid or soft foods or milk feeds at least 4 times 
* during the previous day and at least one of the feeds was a solid, semi-solid or soft feed.
gen mmf_nobf=0
replace mmf_nobf=1 if feeds>=4 & freq_solids>=1 & currently_bf!=1
replace mmf_nobf =. if age_days<=183 | age_days>=730 
tab mmf_nobf, m 


* Minimum Milk / Dairy frequency for Non-Breastfed Child
* include milk, formula and yogurt
gen min_milk_freq_nbf =0
replace min_milk_freq_nbf =1 if milk_feeds >=2 & currently_bf!=1 
replace min_milk_freq_nbf =. if age_days<=183 | age_days>=730
la var min_milk_freq_nbf "Minimum Milk Frequency for Non-Breastfed Child"
tab min_milk_freq_nbf, m 
* graph bar (mean) min_milk_freq_nbf currently_bf if agemons < 24, over(agemons) 


*MMF among all children 6-23 months
gen mmf_all=0
replace mmf_all=1 if mmf_bf==1 | mmf_bf==2 | mmf_nobf==1
replace mmf_all =. if age_days<=183 | age_days>=730
la var mmf_all "Minimum meal frequency for all children 6-23M"
tab mmf_all, m 

**Minimum Acceptable Diet (MAD) 
*** Generates milk feeds for non-breastfed infants ***
*** Milk feeds include milk other than breastmilk, infant formula and yogurt*
* Variable fed_yogurt refers to number of times a child received yogurt*

* For each one please remember to set don't know to zero
* for NFHS (DHS) replace fed_yogurt=0 if fed_yogurt>7  - In this case don't knows has been assigned the value 8

* Mixed milk feeding 0-5M
* Mixed milk feeding (<6 months): Percentage of infants 0–5 months of age who 
* were fed formula and/or animal milk in addition to breast milk during the previous day
gen mixed_milk = 0 
replace mixed_milk=1 if (currently_bf==1 & formula==1) | (currently_bf==1 & milk==1) 
replace mixed_milk =. if age_days<0 | age_days>=183 
tab mixed_milk, m 


**** MAD among all infants 6-23 months of age ****	
gen mad_all=.
replace mad_all=1 if (mdd==1 & mmf_all==1) & (currently_bf==1 | min_milk_freq_nbf==1) 
replace mad_all=. if age_days<=183 | age_days>=730 
tab mad_all, m 

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


*********************************************************************
*SOCIO-ECONOMIC-DEMOGRAPHIC VARS


* LBW              (low birth weight)

gen birth_weight = (q181_1*1000) + q181_2 
replace birth_weight = 9999 if birth_weight == .
label def bw 9999 "Missing", replace
label val birth_weight bw
label var birth_weight "Birth weight"
replace birth_weight = birth_weight/1000 if birth_weight != 9999


egen c_birth_wt = cut(birth_weight), at(0.25,1,2.5,9001,9997,9999,10000) icodes
label def c_birth_wt 0 "Very low" 1 "Low" 2 "Average or more" 3 "Not weighed" 4 "Don't know" 5 "Missing"
label val c_birth_wt c_birth_wt
label var c_birth_wt "Birth weight category"

gen lbw=. 
replace lbw = 1 if birth_weight<2.5
replace lbw=0 if birth_weight>=2.5 & birth_weight<9
tab lbw,m


/*
recode c_birth_wt 2 = 0 0 1 = 2 3=1 4 = 3 5=4, gen(lbw)
label def lbw 0 "0. Average or more" 1 "1. Not weighed at birth" 2 "2. Low" 3 "3. Don't know" 4 "4. Missing", replace
label val lbw lbw
label var lbw "Low birth weight"
*/


* early ANC  <=3 months first trimester
tab q144
tab q145_1
gen earlyanc = 0
replace earlyanc =1 if q145_1 <=3
replace earlyanc =. if age_days>=730
tab q145_1 earlyanc

* ANC 4+ 
tab q146_1
gen anc4plus = 0
replace anc4plus = 1 if q146_1 >=4 & q146_1 <=9
replace anc4plus =. if age_days>=730
tab q146_1 anc4plus

* C-section
tab q163
gen csection = 0
replace csection = 1 if q163==2
tab q163 csection, m 

* mothers education
tab q113_1, m 
recode q113_1 (0=1)(1/4=2)(5/9=3)(10/11=4)(12/25=5)(26/max=99), gen(mum_educ)
la def mum_educ 1 "No Education" 2 "<5 years completed" 3 "5-9 years completed" ///
	4 "10-11 years completed" 5 "12+ years completed" 99 "Missing"
label val mum_educ mum_educ
label var mum_educ "Mother's education"
tab  mum_educ q113_1



* caste
gen caste = q45
replace caste = 5 if q45 ==98
replace caste = 6 if q45 ==.
lab define caste 1 "Scheduled caste" 2"Scheduled tribe" 3"OBC"  4"Others" 5 "Missing/don't know" 
label val caste caste
label var caste "Caste"
tab q45 caste

* Residence Rural Urban
*Residence
tab q4, m 
recode q4 (2=1) (1=2), gen(rururb)
lab define rururb 1 "Urban" 2"Rural"
lab val rururb rururb   
lab var rururb "Residence"
tab rururb q4, m 




* socio-economic status
clonevar wi = wealth_index
// wealth_index:
//            1 Lowest
//            2 Second
//            3 Middle
//            4 Fourth
//            5 Highest
//also available, wealth index factor score
tab wi

* Include state, district and other identification variables
clonevar state = q1a 

gen statecode = .
replace statecode =2  if state ==28
replace statecode =3  if state ==12
replace statecode =4  if state ==18
replace statecode =5  if state ==10
replace statecode =7  if state ==22
replace statecode =10  if state ==30
replace statecode =11  if state ==24
replace statecode =12  if state ==6
replace statecode =13  if state ==2
replace statecode =14  if state ==1
replace statecode =15  if state ==20
replace statecode =16  if state ==29
replace statecode =17  if state ==32
replace statecode =19  if state ==23
replace statecode =20  if state ==27
replace statecode =21  if state ==14
replace statecode =22  if state ==17
replace statecode =23  if state ==15
replace statecode =24  if state ==13
replace statecode =25  if state ==7
replace statecode =26  if state ==21
replace statecode =28  if state ==3
replace statecode =29  if state ==8
replace statecode =30  if state ==11
replace statecode =31  if state ==33
replace statecode =32  if state ==16
replace statecode =33  if state ==9
replace statecode =34  if state ==5
replace statecode =35  if state ==19


* Generate 'region' variable
gen double region:region=0
replace region=1 if statecode==25 |  statecode==12 | statecode==13 | statecode==14 | statecode==28 | statecode==29 | statecode==34
replace region=2 if statecode==7 |  statecode==19 | statecode==33
replace region=3 if statecode==5 |  statecode==35 | statecode==15 | statecode==26
replace region=4 if statecode==3 |  statecode==30 | statecode==32 | statecode==22 | statecode==4 | statecode==24 | statecode==21 | statecode==23
replace region=5 if statecode==11 |  statecode==20 | statecode==10
replace region=6 if statecode==2 |  statecode==16 | statecode==17 | statecode==31 | statecode==36

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


* Sex of child 
* 1 = male / 2 = female
tab q135_1 // pregnancy number
gen sex=.
replace sex = q129_1 if q135_1==1
replace sex = q129_2 if q135_1==2
replace sex = q129_3 if q135_1==3
replace sex = q129_4 if q135_1==4
replace sex = q129_5 if q135_1==5
replace sex = q129_6 if q135_1==6
// q129_1 q129_2 q129_3 q129_4 q129_5 q129_6
la val sex q280
tab sex, m 
tab sex q280, m  // q280 is only for section B2.0 vaccination /child ilness

* Survey Weights
gen national_wgt = N_WT 
gen state_wgt =S_WT

gen round =2

keep one birthday birthmonth birthyear int_y int_m int_d int_date age_days agemos ///
evbf eibf eibf_timing agemos_ebf agemos_round exbf ebf2d prelacteal_milk prelacteal_water prelacteal_sugarwater ///
prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey ///
prelacteal_janamghuti prelacteal_other colostrum bottle water juice broth milk ///
formula other_liq yogurt fortified_food bread legume vita_veg potato leafy_green ///
vita_fruit fruit_veg organ meat egg fish cont_bf semisolid carb leg_nut dairy ///
all_meat vita_fruit_veg cont_bf agegroup sumfoodgrp diar fever ari cont_bf cont_bf_12_23 ///
intro_compfood mdd currently_bf freq_solids mmf_bf freq_milk freq_formula freq_yogurt ///
milk_feeds feeds mmf_nobf min_milk_freq_nbf mmf_all mixed_milk mad_all egg_meat ///
zero_fv sugar_bev unhealthy_food birth_weight c_birth_wt lbw anc4plus csection earlyanc ///
mum_educ caste rururb wi state statecode region sex national_wgt state_wgt round

* Save data with name of survey
save iycf_rsoc, replace 

*END
***********************************************************************************************************
















/*

*RSOC

*Seasonality
*Children under the age of 5 with valid WHZ
keep if WHZ<9997 & q408_month>=0 & q408_month<60
*83,504 observations

gen mon = substr(intervwrdetails_startdate, 1, 2)
destring mon, replace
gen month12  = mon
label define m12 1 "J" 2 "F" 3 "M" 4 "A" 5 "M" 6 "J" 7 "J" 8 "A" 9 "S" 10 "O" 11 "N" 12 "D"
label val month12 m12 
label var month12 "Month"



gen zwfh = WHZ if WHZ>= -5 & WHZ <= 5
gen wasted = 1 if zwfh < -2 & zwfh !=.
replace wasted = 0 if zwfh >= -2 & zwfh !=.

gen sev_wasted = 1 if zwfh < -3 & zwfh !=.
replace sev_wasted = 0 if zwfh >= -3 & zwfh !=.

tab wasted [iw=N_Wt_Cata]
tab sev_wasted [iw=N_Wt_Cata]
keep if wasted !=. 
gen male = 1 if q407 ==1
replace male = 0 if q407 ==2

gen agemons = q408_month if q408_month>=0 & q408_month<=59
*Age by six month blocks
cap drop agecat
gen agecat = floor(agemons/6)+1
tab agemons agecat, m 
gen agecat_m = agecat
replace agecat_m = 11 if agecat ==.
label def agemo 1 "0-5" 2 "6-11" 3 "12-17" 4 "18-23" 5 "24-29" 6 "30-35" 7 "36-41" 8 "42-47" 9 "48-53" 10 "54-59" 11 "Missing" , replace
label val agecat_m agemos
label var agecat_m "Age (in months)"

*religion of the head of the HH
gen reli = q44 if q44>= 1 & q44<= 4
replace reli = 5 if q44 == 6
replace reli = 0 if q44 == 5 | q44 == 7 | q44 == 96
label define reli  1"1. Hindu" 2"2. Muslim" 3"3. Christian" 4"4. Sikh" 5"5. Buddhist" 0 "0. Other", replace
label val reli reli
lab var 	reli "Religion"







gen hhmem = q14_1 
label var hhmem "Household Size"



gen mother_working = q114 ==1
replace mother_working = 2 if q114 ==.
label define working 0 "not in work force" 1 "in work force" 2 "NA/ Not alive" , replace
label val mother_working working
label var mother_working "Working Status"

gen round =2

keep   WHZ 	zwfh round agecat_m reli rural birth_weight c_birth_wt month12 caste wealth mother_working c_m_school  hhmem S_WT N_WT male state N_Wt_Cata S_WT_CATA q408_month wasted sev_wasted LBW mother_school int_y
*drop if  month12 ==.
*83,198 Observations
ren c_m_school education_years
gen sam_weight_s = S_WT_CATA
gen sam_weight_n = N_Wt_Cata


/*
