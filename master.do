* Creates IYCF database from most recent 4 survey India (NFHS3 RSOC NFHS4 CNNS)

version 16

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


// save "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged\iycf_4surveys.dta", replace
save "C:\TEMP\iycf_4surveys.dta", replace



/*
*Following are the IYCF vars in the dataset - 

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
-------------------------------------------------------------------------------------------------------------
                   SOCIO-ECONOMIC VARS
lbw                                           Low birth weight
earlyamc                                      early ANC : ANC check-up in <=3 months or first trimester 
anc4plus                                      ANC 4+ (Pregnent women receiving more than 4 ANC check-ups)                                      
csection                                      child is delivered by caesarean section,
mum_educ                                      Mother's education ()
caste                                         
rururb                                        rural / urban
wi                                            wealth index
state                          
region                                        region based on geographhy (East, west, north, south, central)
sex                                           sex/gender of child 
national_wgt                                  national sample weight
state_wgt                                     state sample weight
round                                         Round indicates the survey Round1 - NFHS3, Round 2 - RSOC, round3 - NFHS 4, Round4 - CNNS
------------------------------------------------------------------------------------------------------------------
*/

* Round
la def round 1 "NFHS-3" 2 "RSOC"  3 "NFHS-4" 4 "CNNS"
la val round round

// // la drop state_name
// la def state_name			   1 "A&N islands"
// la def state_name			   2 "Andhra Pradesh", add
// la def state_name			   3 "Arunachal Pradesh" , add
// la def state_name			   4 Assam , add
// la def state_name			   5 Bihar , add
// la def state_name			   6 Chandigarh, add
// la def state_name			   7 Chattisgarh, add
// la def state_name			   8 "Dadra and Nagar Haveli", add
// la def state_name			   9 "Daman and Diu", add
// la def state_name			  10 Goa, add
// la def state_name			  11 Gujarat, add
// la def state_name			  12 Haryana, add
// la def state_name			  13 "Himachal Pradesh", add
// la def state_name			  14 "Jammu and Kashmir", add
// la def state_name			  15 Jharkhand, add
// la def state_name			  16 Karnataka, add
// la def state_name			  17 Kerala, add
// la def state_name			  18 Lakshadweep, add
// la def state_name			  19 "Madhya Pradesh", add
// la def state_name			  20 Maharashtra, add
// la def state_name			  21 Manipur, add
// la def state_name			  22 Meghalaya, add
// la def state_name			  23 Mizoram, add
// la def state_name			  24 Nagaland, add
// la def state_name			  25 Delhi, add
// la def state_name			  26 Odisha, add
// la def state_name			  27 Puducherry, add
// la def state_name			  28 Punjab, add
// la def state_name			  29 Rajasthan, add
// la def state_name			  30 Sikkim, add
// la def state_name			  31 "Tamil Nadu", add
// la def state_name			  32 Tripura, add
// la def state_name			  33 "Uttar Pradesh", add
// la def state_name			  34 Uttarakhand, add
// la def state_name			  35 "West Bengal", add
// la def state_name			  36 Telangana, add
// la val statecode state_name

*---------------------------------------------------------------------------------------------------------------------


 tab statecode round,m
/*
                      |                    round
            statecode |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
----------------------+--------------------------------------------+----------
          A&N islands |         0          0        638          0 |       638 
       Andhra Pradesh |     2,196      1,813      3,017      1,173 |     8,199 
    Arunachal Pradesh |       807          0      4,839      1,268 |     6,914 
                Assam |     1,420          0      9,791      1,452 |    12,663 
                Bihar |     2,169          0     24,115      1,407 |    27,691 
           Chandigarh |         0          0        187          0 |       187 
          Chattisgarh |     1,471      1,282      8,744      1,200 |    12,697 
Dadra and Nagar Havel |         0          0        311          0 |       311 
        Daman and Diu |         0          0        395          0 |       395 
                  Goa |       973      1,053        410      1,036 |     3,472 
              Gujarat |     1,485      1,975      7,436      1,066 |    11,962 
              Haryana |     1,197      1,220      7,590      1,090 |    11,097 
     Himachal Pradesh |       963      1,367      2,826      1,192 |     6,348 
    Jammu and Kashmir |     1,167      1,197      7,950      1,156 |    11,470 
            Jharkhand |     1,539      1,649     11,634      1,226 |    16,048 
            Karnataka |     2,088      1,729      7,543        949 |    12,309 
               Kerala |     1,001      1,058      2,443        898 |     5,400 
          Lakshadweep |         0          0        300          0 |       300 
       Madhya Pradesh |     2,801      2,598     23,250      1,152 |    29,801 
          Maharashtra |     2,917      2,577      9,154      1,921 |    16,569 
              Manipur |     1,847          0      5,498      1,206 |     8,551 
            Meghalaya |     1,037          0      4,253      1,114 |     6,404 
              Mizoram |       813          0      4,674      1,009 |     6,496 
             Nagaland |     2,005          0      4,440      1,199 |     7,644 
                Delhi |     1,191      1,670      1,524      1,735 |     6,120 
               Odisha |     1,661          0     10,595      1,313 |    13,569 
           Puducherry |         0          0      1,061          0 |     1,061 
               Punjab |     1,245      1,374      5,044      1,004 |     8,667 
            Rajasthan |     1,872      1,989     16,074      1,221 |    21,156 
               Sikkim |       631          1        975      1,121 |     2,728 
           Tamil Nadu |     1,679      1,584      7,728      1,906 |    12,897 
              Tripura |       606          0      1,291      1,133 |     3,030 
        Uttar Pradesh |     6,481      7,086     38,921      1,965 |    54,453 
          Uttarakhand |     1,169        995      5,580      1,134 |     8,878 
          West Bengal |     2,248          0      5,163      1,777 |     9,188 
            Telangana |         0          0      2,349      1,037 |     3,386 
----------------------+--------------------------------------------+----------
                Total |    48,679     34,217    247,743     38,060 |   368,699 

. 
*/


*Double check all Vars are working properly or not

tab birthday round,m
tab birthmonth round,m
tab birthyear round,m




*Standalone Vars
tab evbf round,m
/*
      Ever |
 breastfed |
 (children |
   born in |
   past 24 |                    round
   months) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |       275      1,104      6,204        343 |     7,926 
         1 |    19,126     21,327     93,001     14,354 |   147,808 
         . |    29,278     11,786    148,538     23,363 |   212,965 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

tab eibf round,m 
/*
           |                    round
      eibf |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |    11,283     10,586     34,141      5,986 |    61,996 
         1 |     8,118     11,845     65,064      8,711 |    93,738 
         . |    29,278     11,786    148,538     23,363 |   212,965 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab ebf2d round,m
/*
           |                    round
     ebf2d |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |        18          1         46         12 |        77 
         1 |        20         29        119         70 |       238 
         . |    48,641     34,187    247,578     37,978 |   368,384 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 

*/

 *Prelacteal feeds

 tab prelacteal_milk round,m
/*
   first 3 |
     days, |
given milk |
other than |
    breast |                    round
      milk |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        no |    26,190     19,434    152,832     13,029 |   211,485 
       yes |     8,785      2,997     23,920      1,668 |    37,370 
         . |    13,704     11,786     70,991     23,363 |   119,844 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab prelacteal_formula round,m
/*
   first 3 |
     days, |
     given |
    infant |                    round
   formula |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        no |    34,566     22,048    174,989     14,016 |   245,619 
       yes |       409        383      1,763        681 |     3,236 
         . |    13,704     11,786     70,991     23,363 |   119,844 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab prelacteal_gripewater round,m
/*
   first 3 |
     days, |
     given |
     gripe |                    round
     water |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        no |    34,679     22,263    175,786     14,573 |   247,301 
       yes |       296        168        966        124 |     1,554 
         . |    13,704     11,786     70,991     23,363 |   119,844 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab prelacteal_sugarwater round,m
/*
   first 3 |
     days, |
     given |
sugar/gluc |                    round
 ose water |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        no |    31,699     22,003    173,742     14,433 |   241,877 
       yes |     3,276        428      3,010        264 |     6,978 
         . |    13,704     11,786     70,991     23,363 |   119,844 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab prelacteal_saltwater round,m
/*
   first 3 |
     days, |
     given |
sugar/salt |                    round
  solution |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        no |    34,415     22,292    176,023     14,670 |   247,400 
       yes |       560        139        729         27 |     1,455 
         . |    13,704     11,786     70,991     23,363 |   119,844 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab prelacteal_water round,m
/*
   first 3 |
     days, |
     given |
     plain |                    round
     water |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        no |    32,027     21,582    171,608     14,353 |   239,570 
       yes |     2,948        849      5,144        344 |     9,285 
         . |    13,704     11,786     70,991     23,363 |   119,844 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab prelacteal_honey round,m
/*
   first 3 |
     days, |
     given |                    round
     honey |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        no |    31,288     21,333    172,123     14,304 |   239,048 
       yes |     3,687      1,098      4,629        393 |     9,807 
         . |    13,704     11,786     70,991     23,363 |   119,844 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab prelacteal_other round,m
/*
prelacteal |                    round
    _other |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |    37,555     22,031    229,428     14,528 |   303,542 
         1 |    11,124        400     18,315        169 |    30,008 
         . |         0     11,786          0     23,363 |    35,149 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab prelacteal_janamghuti round,m
/*
   first 3 |
     days, |
     given |
     janam |                    round
    ghutti |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        no |    33,468     21,661    173,418     14,505 |   243,052 
       yes |     1,507        770      3,334        192 |     5,803 
         . |    13,704     11,786     70,991     23,363 |   119,844 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab colostrum round,m
/*
           |                    round
 colostrum |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |         0      3,146          0      1,835 |     4,981 
         1 |         0     19,285          0     12,862 |    32,147 
         . |    48,679     11,786    247,743     23,363 |   331,571 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab bottle round,m
/*
drank from |
    bottle |
      with |
    nipple |
 yesterday |
   or last |                    round
     night |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        no |    15,804          0     79,818     11,801 |   107,423 
       yes |     3,556          0     19,251      2,896 |    25,703 
         . |    29,319     34,217    148,674     23,363 |   235,573 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/




tab region round,m

/*

           |                    round
    Region |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |         0      4,249      2,892          0 |     7,141 
     North |     8,804      3,095     46,588      8,532 |    67,019 
   Central |    10,753          0     70,915      4,317 |    85,985 
      East |     7,617      6,228     51,507      5,723 |    71,075 
 Northeast |     9,166     10,195     35,761      9,502 |    64,624 
      West |     5,375          1     17,000      4,023 |    26,399 
     South |     6,964     10,449     23,080      5,963 |    46,456 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 


	 
*/




 tab water round,m                                            
/*
 RECODE of |
v409 (gave |
     child |
     plain |                    round
    water) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    16,778     20,051    142,489      3,409 |   182,727 
       Yes |    31,901     14,166    105,254     34,651 |   185,972 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab juice round,m
/*
 RECODE of |
v410 (gave |
     child |                    round
    juice) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    45,301     32,058    225,950     29,258 |   332,567 
       Yes |     3,378      2,159     21,793      8,802 |    36,132 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab broth round,m
/*
           |                    round
     broth |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |         0     24,350          0     29,905 |    54,255 
       Yes |         0      9,867          0      8,155 |    18,022 
         . |    48,679          0    247,743          0 |   296,422 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab milk round,m 
/*
 RECODE of |
v411 (gave |
     child |
tinned/pow |
    der or |
     fresh |                    round
     milk) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    31,871     26,758    201,211     20,127 |   279,967 
       Yes |    16,808      7,459     46,532     17,933 |    88,732 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab formula round,m 
/*
 RECODE of |
     v411a |
     (gave |
child baby |                    round
  formula) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    44,976     31,575    236,670     34,571 |   347,792 
       Yes |     3,703      2,642     11,073      3,489 |    20,907 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab other_liq round,m
/*
 RECODE of |
v413 (gave |
     child |
     other |                    round
   liquid) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    42,478     33,045    223,402     32,067 |   330,992 
       Yes |     6,201      1,172     24,341      5,993 |    37,707 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 

*/


  tab yogurt round,m 
/*
 RECODE of |
     v414p |
     (gave |
     child |
   cheese, |
  yogurt , |
other milk |                    round
 products) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    44,179     32,438    229,475     33,278 |   339,370 
       Yes |     4,500      1,779     18,268      4,782 |    29,329 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab fortified_food round,m 
/*
 RECODE of |
     v412a |
     (gave |
child baby |                    round
   cereal) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    43,448     29,888    231,914     33,146 |   338,396 
       Yes |     5,231      4,329     15,829      4,914 |    30,303 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab bread round,m 
/*
    bread, |
  noodles, |
     other |                    round
    grains |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    23,236     22,465    175,544      6,653 |   227,898 
       Yes |    25,443     11,752     72,199     31,407 |   140,801 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab vita_veg round,m 
/*
 RECODE of |
     v414i |
     (gave |
     child |
  pumpkin, |
  carrots, |
    squash |
(yellow or |
    orange |                    round
   inside) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    43,865     31,154    224,594     29,708 |   329,321 
       Yes |     4,814      3,063     23,149      8,352 |    39,378 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab potato round,m 
/*
 RECODE of |
     v414f |
     (gave |
     child |
 potatoes, |
  cassava, |
  or other |                    round
   tubers) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    40,859     31,791    222,297     21,685 |   316,632 
       Yes |     7,820      2,426     25,446     16,375 |    52,067 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab leafy_green round,m 
/*
 RECODE of |
     v414j |
     (gave |
 child any |
dark green |
     leafy |
vegetables |                    round
         ) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    39,400     30,901    213,638     24,248 |   308,187 
       Yes |     9,279      3,316     34,105     13,812 |    60,512 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab vita_fruit round,m 
/*
 RECODE of |
     v414k |
     (gave |
     child |
  mangoes, |
  papayas, |
     other |
 vitamin a |                    round
   fruits) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    44,026     32,483    226,851     30,445 |   333,805 
       Yes |     4,653      1,734     20,892      7,615 |    34,894 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab fruit_veg round,m 
/*
  7: Other |
fruits and |                    round
vegetables |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    41,939     31,832    220,670     22,846 |   317,287 
       Yes |     6,740      2,385     27,073     15,214 |    51,412 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab organ round,m 
/*
 RECODE of |
     v414m |
     (gave |
     child |
    liver, |
    heart, |
     other |                    round
   organs) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    47,723     33,666    240,617     35,514 |   357,520 
       Yes |       956        551      7,126      2,546 |    11,179 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab meat round,m 
/*
 RECODE of |
     v414b |
     (gave |
 child any |
     other |                    round
     meat) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    47,421     33,591    241,810     34,551 |   357,373 
       Yes |     1,258        626      5,933      3,509 |    11,326 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab egg round,m 
/*
           |                    round
   5: Eggs |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    45,792     33,294    231,375     30,533 |   340,994 
       Yes |     2,887        923     16,368      7,527 |    27,705 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab fish round,m 
/*
 RECODE of |
     v414n |
     (gave |
     child |
  fresh or |
dried fish |
        or |                    round
shellfish) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    46,283     33,683    241,439     34,124 |   355,529 
       Yes |     2,396        534      6,304      3,936 |    13,170 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab semisolid round,m 
/*
 RECODE of |
     v414s |
     (gave |
     child |
     other |
  solid or |
semi-solid |                    round
     food) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    42,023     32,099    223,568     12,450 |   310,140 
       Yes |     6,656      2,118     24,175     25,610 |    58,559 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/








tab carb round,m 
/*
 1: Bread, |
     rice, |
   grains, |
 roots and |                    round
    tubers |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    22,836     22,265    173,294      6,130 |   224,525 
       Yes |    25,843     11,952     74,449     31,930 |   144,174 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/
	 
tab leg_nut round,m 
/*
2: Legumes |                    round
  and nuts |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    42,964     27,494    231,643     26,691 |   328,792 
       Yes |     5,715      6,723     16,100     11,369 |    39,907 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/
	 
tab dairy round,m 
/*
3: Dairy - |
     milk, |
  formula, |
   yogurt, |                    round
    cheese |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    29,442     24,967    189,615     15,813 |   259,837 
       Yes |    19,237      9,250     58,128     22,247 |   108,862 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/
	 
tab all_meat round,m 
/*
  4: Flesh |
     foods |
    (meat, |
fish, bird |
       and |
liver/orga |                    round
  n meats) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    44,369     33,078    234,312     29,641 |   341,400 
       Yes |     4,310      1,139     13,431      8,419 |    27,299 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/
	 
	 tab egg round,m 
/*
           |                    round
   5: Eggs |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    45,792     33,294    231,375     30,533 |   340,994 
       Yes |     2,887        923     16,368      7,527 |    27,705 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/	
	
	 
tab vita_fruit_veg round,m 
/*
6: Vitamin |
    A rich |
fruits and |                    round
vegetables |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    35,220     29,063    201,488     18,933 |   284,704 
       Yes |    13,459      5,154     46,255     19,127 |    83,995 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/
	 
tab fruit_veg round,m 
/*
  7: Other |
fruits and |                    round
vegetables |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    41,939     31,832    220,670     22,846 |   317,287 
       Yes |     6,740      2,385     27,073     15,214 |    51,412 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/
	 
tab cont_bf round,m 
/*
        8: |                    round
Breastmilk |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
        No |    26,278     15,368    132,821     21,120 |   195,587 
       Yes |    22,401     18,849    114,922     16,940 |   173,112 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/
	 

tab sumfoodgrp round,m
/*
sumfoodgrp |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |    11,931     12,185     91,753        301 |   116,170 
         1 |     9,922      8,058     73,027      4,714 |    95,721 
         2 |     8,010      4,359     26,562      6,407 |    45,338 
         3 |     8,108      3,740     22,118      8,618 |    42,584 
         4 |     5,700      2,815     15,000      7,943 |    31,458 
         5 |     3,122      1,828      8,807      5,471 |    19,228 
         6 |     1,345        780      4,894      2,484 |     9,503 
         7 |       464        291      3,749      1,600 |     6,104 
         8 |        77        161      1,833        522 |     2,593 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

	 	 

tab mdd round,m
/*
   Minimum |
   Dietary |
 Diversity |                    round
    (2020) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |    11,793     13,673     59,821      8,284 |    93,571 
         1 |     2,471      2,946     14,355      2,894 |    22,666 
         . |    34,415     17,598    173,567     26,882 |   252,462 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 

 */
		 
		 
		 
		 
tab mmf_bf round,m
/*
                      |                    round
               mmf_bf |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
----------------------+--------------------------------------------+----------
       Inadequate MMF |     6,116     12,218     40,797      8,026 |    67,157 
Adequate freq(2) and  |       761        546      2,946        434 |     4,687 
Adequate freq(3) and  |     4,605      3,855     16,275      2,718 |    27,453 
                    . |    37,197     17,598    187,725     26,882 |   269,402 
----------------------+--------------------------------------------+----------
                Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

tab mmf_nobf round,m
/*
           |                    round
  mmf_nobf |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |         0     14,506      7,443      9,534 |    31,483 
         1 |         0      2,113      6,715      1,644 |    10,472 
         . |    48,679     17,598    233,585     26,882 |   326,744 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

tab mmf_all round,m
/*
   Minimum |
      meal |
 frequency |
   for all |
  children |                    round
     6-23M |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |         0     10,105     48,240      6,382 |    64,727 
         1 |         0      6,514     25,936      4,796 |    37,246 
         . |    48,679     17,598    173,567     26,882 |   266,726 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

tab mixed_milk round,m
/*
           |                    round
mixed_milk |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |         0      5,087     19,888      2,989 |    27,964 
         1 |         0        684      3,672        513 |     4,869 
         . |    48,679     28,446    224,183     34,558 |   335,866 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

tab mad_all round,m
/*
           |                    round
   mad_all |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |         0          0     67,258      9,721 |    76,979 
         1 |         0          0      6,918      1,457 |     8,375 
         . |    48,679     34,217    173,567     26,882 |   283,345 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/


tab egg_meat round,m
/*
           |                    round
  egg_meat |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |    11,876     15,095     60,540      8,428 |    95,939 
         1 |     2,388      1,524     13,636      2,750 |    20,298 
         . |    34,415     17,598    173,567     26,882 |   252,462 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/
	 
tab zero_fv round,m
/*
           |                    round
   zero_fv |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |     6,420      5,545     33,677      6,156 |    51,798 
         1 |     7,844     11,074     40,499      5,022 |    64,439 
         . |    34,415     17,598    173,567     26,882 |   252,462 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 

*/
	 
	 
	 
	 
	 
	 
	 tab agegroup round,m
/*
           |                    round
  agegroup |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
      0-5m |     5,109      5,771     24,883      3,502 |    39,265 
     6-11m |     4,821      5,449     25,231      3,820 |    39,321 
    12=17m |     5,019      6,181     25,266      3,689 |    40,155 
    18-23m |     4,511      5,075     24,103      3,732 |    37,421 
    24-29m |     5,056      6,255     25,015      3,805 |    40,131 
    30-35m |     4,717      5,486     24,246      3,873 |    38,322 
    36-41m |     5,234          0     26,302      4,111 |    35,647 
    42-47m |     4,757          0     25,268      4,146 |    34,171 
    48-53m |     5,141          0     24,822      4,034 |    33,997 
    54-59m |     4,314          0     22,548      3,344 |    30,206 
         . |         0          0         59          4 |        63 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

tab diar round,m
/*
           |                    round
      diar |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |    44,216     31,532    225,243     33,294 |   334,285 
         1 |     4,440      2,456     22,500      4,766 |    34,162 
         . |        23        229          0          0 |       252 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

tab fever round,m        
/*
           |                    round
     fever |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |    41,440     29,409    215,682     28,495 |   315,026 
         1 |     7,205      4,352     32,061      9,565 |    53,183 
        98 |         0        227          0          0 |       227 
         . |        34        229          0          0 |       263 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab ari round,m
/*
 RECODE of |
  h31 (had |
  cough in |
  last two |                    round
    weeks) |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |    46,125     32,456    240,783     35,778 |   355,142 
         1 |     2,554      1,761      6,960      2,282 |    13,557 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

  tab lbw round,m
/*
           |                    round
       lbw |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |    12,791     18,279    155,148     33,146 |   219,364 
         1 |     7,552          0          0      4,914 |    12,466 
         2 |         0      4,266          0          0 |     4,266 
         4 |         0     11,672          0          0 |    11,672 
       100 |         0          0     31,928          0 |    31,928 
         . |    28,336          0     60,667          0 |    89,003 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/


 tab anc4plus round,m
/*
           |                    round
  anc4plus |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |    11,078     11,948     54,274      6,090 |    83,390 
         1 |     8,323     10,483     44,931      8,607 |    72,344 
         . |    29,278     11,786    148,538     23,363 |   212,965 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

tab csection round,m
/*
           |                    round
  csection |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         0 |    43,397     28,621    213,195     29,299 |   314,512 
         1 |     5,282      5,596     34,548      8,761 |    54,187 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

tab mum_educ round,m
/*
                    |                    round
 Maternal Education |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
--------------------+--------------------------------------------+----------
       No Education |    19,449      9,823     76,212      7,361 |   112,845 
  Primary Education |     7,011      1,036     35,917      2,037 |    46,001 
Secondary Education |    18,373     10,101    112,227     12,327 |   153,028 
   Higher Education |     3,846      5,115     23,387      5,377 |    37,725 
                  4 |         0      8,142          0     10,924 |    19,066 
                  . |         0          0          0         34 |        34 
--------------------+--------------------------------------------+----------
              Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

tab caste round,m
/*
                |                    round
          Caste |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
----------------+--------------------------------------------+----------
Scheduled caste |     8,590      6,758     46,486      6,981 |    68,815 
Scheduled tribe |     7,877      3,992     49,804      7,673 |    69,346 
            OBC |    16,001     13,341     97,011     11,677 |   138,030 
         Others |    14,266     10,009     44,916     11,729 |    80,920 
              5 |         0        117          0          0 |       117 
              . |     1,945          0      9,526          0 |    11,471 
----------------+--------------------------------------------+----------
          Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab rururb round,m
/*
           |                    round
 Residence |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
     Urban |    18,623     12,684     59,222     17,421 |   107,950 
     Rural |    30,056     21,533    188,521     20,639 |   260,749 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab wi round,m
/*
           |                    round
        wi |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
   poorest |     8,456      5,500     64,443      3,064 |    81,463 
    poorer |     8,844      5,555     58,294      4,575 |    77,268 
    middle |    10,057      6,396     49,588      7,289 |    73,330 
    richer |    10,810      7,423     41,472      9,812 |    69,517 
   richest |    10,512      9,343     33,946     13,320 |    67,121 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

 tab state round,m
/*
                      |                    round
                state |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
----------------------+--------------------------------------------+----------
          A&N islands |         0      1,197        638          0 |     1,835 
       Andhra Pradesh |     2,196      1,367      3,017          0 |     6,580 
    Arunachal Pradesh |       807      1,374      4,839          0 |     7,020 
                Assam |     1,420          0      9,791      1,452 |    12,663 
                Bihar |     2,169        995     24,115          0 |    27,279 
           Chandigarh |         0      1,220        187          0 |     1,407 
          Chattisgarh |     1,471      1,670      8,744          0 |    11,885 
Dadra and Nagar Havel |         0      1,989        311          0 |     2,300 
        Daman and Diu |         0      7,086        395          0 |     7,481 
                  Goa |       973          0        410      1,036 |     2,419 
              Gujarat |     1,485          1      7,436          0 |     8,922 
              Haryana |     1,197          0      7,590      1,090 |     9,877 
     Himachal Pradesh |       963          0      2,826          0 |     3,789 
    Jammu and Kashmir |     1,167          0      7,950          0 |     9,117 
            Jharkhand |     1,539          0     11,634          0 |    13,173 
            Karnataka |     2,088          0      7,543          0 |     9,631 
               Kerala |     1,001          0      2,443          0 |     3,444 
          Lakshadweep |         0          0        300          0 |       300 
       Madhya Pradesh |     2,801          0     23,250          0 |    26,051 
          Maharashtra |     2,917      1,649      9,154      1,921 |    15,641 
              Manipur |     1,847          0      5,498          0 |     7,345 
            Meghalaya |     1,037      1,282      4,253      2,012 |     8,584 
              Mizoram |       813      2,598      4,674      2,235 |    10,320 
             Nagaland |     2,005      1,975      4,440      3,564 |    11,984 
                Delhi |     1,191          0      1,524      2,935 |     5,650 
               Odisha |     1,661          0     10,595      3,675 |    15,931 
           Puducherry |         0      2,577      1,061          0 |     3,638 
               Punjab |     1,245      1,813      5,044      2,272 |    10,374 
            Rajasthan |     1,872      1,729     16,074      1,221 |    20,896 
               Sikkim |       631      1,053        975      2,187 |     4,846 
           Tamil Nadu |     1,679          0      7,728      1,906 |    11,313 
              Tripura |       606      1,058      1,291      2,082 |     5,037 
        Uttar Pradesh |     6,481      1,584     38,921      1,965 |    48,951 
          Uttarakhand |     1,169          0      5,580      2,541 |     9,290 
          West Bengal |     2,248          0      5,163      2,929 |    10,340 
            Telangana |         0          0      2,349      1,037 |     3,386 
----------------------+--------------------------------------------+----------
                Total |    48,679     34,217    247,743     38,060 |   368,699 
*/


tab sex round,m
/*
           |                    round
       sex |    NFHS-3       RSOC     NFHS-4       CNNS |     Total
-----------+--------------------------------------------+----------
         1 |    25,301     18,261    128,609     19,948 |   192,119 
         2 |    23,378     15,844    119,134     18,112 |   176,468 
         . |         0        112          0          0 |       112 
-----------+--------------------------------------------+----------
     Total |    48,679     34,217    247,743     38,060 |   368,699 
*/

	 
	 
	 
	 
	 
	 
	 