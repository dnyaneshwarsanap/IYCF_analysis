* Creates IYCF database from most recent 4 survey India (NFHS3 RSOC NFHS4 CNNS)
* IYCF Variables for multi-survey analysis

version 16

* To change
ebf3d
colostrum
RSOC state
RSOC region
broth NFHS
bread
water CNNS
juice CNNS
milk CNNS
potato CNNS
leafy_green CNNS
vita_fruit CNNS
fruit_veg CNNS
egg CNNS
semisolid CNNS
carb CNNS
leg_nut CNNS
fever RSOC
LBW
mum_educ
caste
region, national, state weights


// cd "C:\Users\rober\OneDrive - UNICEF\1 UNICEF Work\1 moved to ECM\IIT-B\IYCF\analysis"
// cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"

* NFHS-3
clear 
cd "C:\Users\rober\OneDrive - UNICEF\1 UNICEF Work\1 moved to ECM\IIT-B\IYCF\analysis"
run make_IYCF_vars_NFHS3.do

*NFHS4
clear 
cd "C:\Users\rober\OneDrive - UNICEF\1 UNICEF Work\1 moved to ECM\IIT-B\IYCF\analysis"
run make_IYCF_vars_NFHS4.do

*RSOC
clear 
cd "C:\Users\rober\OneDrive - UNICEF\1 UNICEF Work\1 moved to ECM\IIT-B\IYCF\analysis"
run make_IYCF_vars_RSOC.do

*CNNS
clear 
cd "C:\Users\rober\OneDrive - UNICEF\1 UNICEF Work\1 moved to ECM\IIT-B\IYCF\analysis"
run make_IYCF_vars_CNNS.do


*MERGE ALL DATASETS

cd "C:/Temp"
// cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"

use "iycf_NFHS3", clear
tab round, m 
append using "iycf_NFHS4"
tab round, m 
append using "iycf_rsoc"
tab round, m 
append using "iycf_cnns"
tab round, m 



* Generate 'region' variable
gen region= .
replace region=1 if state==25 |  state==12 | state==13 | state==14 | state==28 | state==29 | state==34
replace region=2 if state==7 |  state==19 | state==33
replace region=3 if state==5 |  state==35 | state==15 | state==26
replace region=4 if state==3 |  state==30 | state==32 | state==22 | state==4 | state==24 | state==21 | state==23
replace region=5 if state==11 |  state==20 | state==10
replace region=6 if state==2 |  state==16 | state==17 | state==31 | state==36

/*
------------------------------------------------------------------------------------------------------------------------------------------------
region       Region Name       states included in the region (state)
-------------------------------------------------------------------------------------------------------------------------------------------------
region 1       North           NCT of Delhi(25), Haryana(12), Himachal Pradesh(13), Jammu and Kashmir(14), Punjab(28), Rajasthan(29), Uttarakhand(34)
				        	   						 							   
region 2	   Central		   Chhattisgarh(7), Madhya Pradesh(19), Uttar Pradesh(33)
									
region 3	   East			   Bihar(5), West Bengal(35), Jharkhand(15), Odisha(26)	 							

region 4       NorthEast       Arunachal Pradesh(3), Sikkim(30), Tripura(32),  Meghalaya(22), Assam(4), Nagaland(24), Manipur(21), Mizoram(23)

region 5       West            Gujarat(11), Maharshtra (20), Goa(10)

region 6       South           Andhra Pradesh(2),  Karnataka(16),  Kerala(17),  Tamil Nadu(31),  Telangana(36) 
--------------------------------------------------------------------------------------------------------------------------------------------------
*/

* In NFHS use national weights for region
lab define region 1 "North" 2 "Central" 3 "East" 4 "Northeast" 5 "West" 6 "South"
lab var region "Region" 
lab val region region


// save "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged\iycf_4surveys.dta", replace
save "C:\TEMP\iycf_4surveys.dta", replace

// use "C:\TEMP\iycf_4surveys.dta", clear

/*
*The IYCF vars in the dataset - 

*Var_name                                        Description 
------------------------------------------------------------------------------------------
birthday                                         day of birth of child
birthmonth                                       month of birth of child
birthyear                                        year of birth of child
int_y                                            interview year
int_m                                            interview month
int_d                                            interview day
int_date                                         interview date 
age_days                                         age of child in days 
agemos                                           age of child in months
---------------------------------------------------------------------------------------------
evbf                                             children below 24 months ever breastfed
eibf                                             children below 24 months early initiation of breastfeeding
eibf_timing                                      timing from birth of child to start breastfeeding
ebf2d                                            exclusive breastfeeding for first two days
--------------------------------------------------------------------------------------------
          PRELACTEAL FEED (GIVEN SOMETHING TO EAT WITHIN 1st 3 DAYS of BIRTH)
prelacteal_milk                                  given child milk within 3 days after birth
prelacteal_water                                 given child water within 3 days after birth
prelacteal_sugarwater                            given child sugarwater within 3 days after birth
prelacteal_gripewater                            given child gripewater within 3 days after birth
prelacteal_saltwater                             given child saltwater within 3 days after birth
prelacteal_formula                               given child formula within 3 days after birth
prelacteal_honey                                 given child honey within 3 days after birth
prelacteal_janamghuti                            given child janamghuti within 3 days after birth
prelacteal_other                                 given child other than milk drinks (including above) within 3 days after birth

colostrum                                        Weather child Child recieved colostrum (data for NFHS 3 and NFHS 4 is not available) 
bottle                                           Percentage of children 0–23 months of age who were fed from a bottle with a nipple during the previous day
--------------------------------------------------------------------------------------------------
Following are the Food groups, which child has consumed a day before interview
--------------------------------------------------------------------------------------------------
                    LIQUIDS
water                                            
juice 
broth                                         **Not available in NFHS data 
milk 
formula 
other_liq 
                   SOLID / SEMI-SOLIDS
yogurt 
fortified_food 
bread                                         any bread, roti, chapati, rice, noodles, biscuits, idli, porridge
legume 
vita_veg                                      Any pumpkin, carrots, squash or sweet potatoes that are yellow or orange inside
potato                                        any white potato, white yam, cassava or other food made from roots
leafy_green                                   Any dark green, leafy vegetables
vita_fruit                                    Any ripe mango, papaya, cantaloupe or jackfruit
fruit_veg                                     other fruits and vegetables
organ                                         Any liver, kidney, heart or other organ meat
meat                                          Any other meat
egg  
fish 
semisolid                                     Any other solid, semi-solid, or soft food
------------------------------------------------------------------------------------------------------
                  8 Food groups 

carb                                          grains, white/pale starchy roots, tubers and plantains (Bread, potato, gruel, etc)
leg_nut                                       beans, peas, lentils, nuts, legumes
dairy                                         Milk, Formula, Yogurt, curd, etc. dairy products
all_meat                                      flesh foods (meat, fish, poultry, organ meats)
vita_fruit_veg                                vitamin A-rich fruits and vegetables
fruit_veg                                     other fruits and vegetables
cont_bf                                       here for breastmilk we have used a indicator "cont_bf" where response is still breastfeeding
egg                                           
------------------------------------------------------------------------------------------------------
sumfoodgrp                                    Sum of food groups (from 8 food groups) consumed by a child 
------------------------------------------------------------------------------------------------------
cont_bf                                       Continued breastfeeding
cont_bf_12_23                                 percentage of children 12–23 months of age who were fed breast milk during the previous day.
intro_compfood                                percentage of infants 6–8 months of age who consumed solid, semisolid or soft foods during the previous day
mdd                                           percentage of children 6–23 months of age who consumed least five out of eight food groups during the previous day                         
currently_bf                                  
freq_solids                                   Number of times child consumed any solid/semi-solid food on day before interview
mmf_bf                                        Minimum meal frequency for breastfed children
freq_milk                                     Number of times child consumed a milk other than BM on day before interview
freq_formula                                  Number of times child consumed formula on day before interview
freq_yogurt                                   Number of times child consumed yogurt on day before interview
milk_feeds                                    frequency of (milk+formula+yogurt)
feeds                                         Frequency of solid, semi-solid, milk and formula feeds 
mmf_nobf                                      Minimum Meal Frequency (MMF) for NON Breastfeeding
min_milk_freq_nbf                             Minimum milk Frequency (MMF) NON Breastfeeding
mmf_all                                       MMF for all children (BF+NBF) 
mixed_milk                                    Percentage of infants 0–5 months of age who were fed formula and/or animal milk in addition to breast milk during the previous day
mad_all                                       Minimum Adequacy of Diet among all infants 6-23 months of age
egg_meat                                      % of children 6-23months of age who consumed egg and/or flesh food during the previous day
zero_fv                                       % of children 6-23months of age who did not consume any fruits or vegetables during the previous day
sugar_bev                   NA                  **consumption of sugar sweetened beverages by child agemons 6 to 23** (no relevant question in the dataset)
unhealthy_food              NA                  **Need clear definition of unhealthy foods - from WHO guidance

agegroup                                      Age groups in blocks of 6 months   
-------------------------------------------------------------------------------------------------------------
diar                                         % children had diarrhoea in last 2 weeks
fever                                        % children had fever in last 2 weeks
ari                                           Cough with rapid breathing excluding those with only nasal breathing problems

lbw                                           Low birth weight
earlyamc                                      early ANC : ANC check-up in <=3 months or first trimester 
anc4plus                                      ANC 4+ (Pregnent women receiving more than 4 ANC check-ups)                                      
csection                                      child is delivered by caesarean section,
-------------------------------------------------------------------------------------------------------------
                   SOCIO-ECONOMIC VARS
mum_educ                                      Mother's education ()
caste                                         
rururb                                        rural / urban
wi                                            wealth index
state                          
region                                        region based on geography (east, west, north, south, central)
sex                                           sex/gender of child 
national_wgt                                  national sample weight
state_wgt                                     state sample weight
round                                         Round indicates the survey Round1 - NFHS3, Round 2 - RSOC, round3 - NFHS 4, Round4 - CNNS
------------------------------------------------------------------------------------------------------------------
*/


currently_bf any_solid_semi_food intro_compfood ebf age_ebf age_cbf cont_bf cont_bf_12_23 freq_solids freq_milk freq_milk freq_formula freq_yogurt milk_feeds feeds colostrum


* Round
la def round 1 "NFHS-3" 2 "RSOC"  3 "NFHS-4" 4 "CNNS"
la val round round
tab round, m 

*Double check all vars 

tab sex round,m
tab sex round, col  

tab state, m 
tab state round,m

tab region round,m

tab birthday round,m
tab birthmonth round,m
tab birthyear round,m

tab agegroup round,m


* Liquid variables
tab evbf round,m

tab eibf round,m 

tab eibf_timing round


* recommended ebf in 1st two days
tab ebf2d round,m
* original ebg in 1st 3 days
tab ebf3d round,m

tab ebf round,m 
tab ebf round, col   

tab cont_bf round,m 
tab cont_bf round, col 


 *Prelacteal feeds
tab prelacteal_milk round,m

tab prelacteal_formula round,m

tab prelacteal_gripewater round,m

tab prelacteal_sugarwater round,m

tab prelacteal_saltwater round,m

tab prelacteal_water round,m

tab prelacteal_honey round,m

tab prelacteal_other round,m

tab prelacteal_janamghuti round,m
* Ayurvedic medicine which cures stomach ailments/constipation in babies 

tab colostrum round,m
* missing NFHS3, 4 and CNNS

tab bottle round,m
* missing bottle with nipple RSOC

tab water round,m       
tab water round, col                                         

tab juice round,m
tab juice round, col

tab broth round,m

tab milk round,m 
tab milk round, col

tab formula round,m 
tab formula round, col

tab other_liq round,m

* Food variables

tab yogurt round,m 
tab yogurt round, col 

tab fortified_food round,m 
tab fortified_food round, col 
 
tab bread round,m 
tab bread round, col

tab vita_veg round,m 
tab vita_veg round, col

tab potato round,m 
tab potato round, col 

tab leafy_green round,m 
tab leafy_green round, col

tab vita_fruit round,m 
tab vita_fruit round, col

tab fruit_veg round,m 
tab fruit_veg round, col

tab organ round,m 
tab organ round, col

tab meat round,m 
tab meat round, col 

tab egg round,m 
tab egg round, col

tab fish round,m 
tab fish round, col 

tab semisolid round,m 
tab semisolid round, col

tab carb round,m 
tab carb round, col
	 
tab leg_nut round,m 
tab leg_nut round, col 
	 
tab dairy round,m 
tab dairy round, col 

tab all_meat round,m 
tab all_meat round, col 

tab egg round,m 
tab egg round, col  

tab vita_fruit_veg round, m 
tab vita_fruit_veg round, col 
	 
tab fruit_veg round,m 
tab fruit_veg round, col 

* Composite diet variables
tab sumfoodgrp round,m

tab mdd round,m
	 
tab mmf_bf round,m

tab mmf_nobf round,m

tab mmf_all round,m

tab mixed_milk round,m
 
tab mad_all round,m

tab egg_meat round,m
	 
tab zero_fv round,m

* Health and Illness variables
tab diar round,m

tab fever round,m        

tab ari round,m

tab lbw round,m

tab anc4plus round,m
tab anc4plus round, col

tab csection round,m
tab csection round, col 

* Socio-economic variables

tab mum_educ round,m
tab mum_educ round, col 

tab caste round,m

tab rururb round,m

tab wi round,m






	 
	 
	 
	 
	 