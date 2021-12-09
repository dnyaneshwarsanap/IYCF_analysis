* Create IYCF database from most recent 4 survey India (NFHS3 RSOC NFHS4 CNNS)
* This code is a master do file to make IYCF vars from (NFHS3 RSOC NFHS4 CNNS) datasets

cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"


clear 
* NFHS-3

run make_IYCF_vars_NFHS3.do

/*
*recode state code of nfhs3 
gen state = .
replace state =2  if v101 ==28			 
replace state =3  if v101 ==12			 
replace state =4  if v101 ==18			 
replace state =5  if v101 ==10			 
replace state =7  if v101 ==22			 
replace state =10  if v101 ==30			 
replace state =11  if v101 ==24			 
replace state =12  if v101 ==6			 
replace state =13  if v101 ==2			 
replace state =14  if v101 ==1			 
replace state =15  if v101 ==20			 
replace state =16  if v101 ==29			 
replace state =17  if v101 ==32			 
replace state =19  if v101 ==23			 
replace state =20  if v101 ==27			 
replace state =21  if v101 ==14			 
replace state =22  if v101 ==17			 
replace state =23  if v101 ==15			 
replace state =24  if v101 ==13			 
replace state =25  if v101 ==7			 
replace state =26  if v101 ==21			 
replace state =28  if v101 ==3			 
replace state =29  if v101 ==8			 
replace state =30  if v101 ==11			 
replace state =31  if v101 ==33			 
replace state =32  if v101 ==16			 
replace state =33  if v101 ==9			 
replace state =34  if v101 ==5			 
replace state =35  if v101 ==19			 

* Include state, district and other identification variables

keep one birthday birthmonth birthyear int_y int_m int_d int_date age_days agemos ///
evbf eibf eibf_timing ebf2d prelacteal_milk prelacteal_water prelacteal_sugarwater ///
prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey ///
prelacteal_janamghuti prelacteal_other bottle water juice milk ///
formula other_liq yogurt fortified_food bread legume vita_veg potato leafy_green ///
vita_fruit fruit_veg organ meat egg fish nut breast_milk semisolid carb leg_nut dairy ///
all_meat vita_fruit_veg breast_milk agegroup sumfoodgrp diar fever ari cont_bf cont_bf_12_23 ///
intro_compfood mdd currently_bf freq_solids mmf_bf  ///
mmf_all mad_all egg_meat ///
zero_fv sugar_bev  lbw anc4plus csection ///
mum_educ caste rururb wi state region sex national_wgt state_wgt

gen round=1
*/
save "iycf_nfhs3", replace

*--------------------------------------------------*-------------------------------------------------------

*NFHS4
cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"
run make_IYCF_vars_NFHS4.do
/*
gen state = .
replace state=v101

keep one birthday birthmonth birthyear int_y int_m int_d int_date age_days agemos ///
evbf eibf eibf_timing ebf2d prelacteal_milk prelacteal_water prelacteal_sugarwater ///
prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey ///
prelacteal_janamghuti prelacteal_other bottle water juice milk ///
formula other_liq yogurt fortified_food bread vita_veg potato leafy_green ///
vita_fruit fruit_veg organ meat egg fish breast_milk semisolid carb leg_nut dairy ///
all_meat vita_fruit_veg breast_milk agegroup sumfoodgrp diar fever ari cont_bf cont_bf_12_23 ///
intro_compfood mdd currently_bf freq_solids mmf_bf freq_milk freq_formula freq_yogurt ///
milk_feeds feeds mmf_nobf min_milk_freq_nbf mmf_all mixed_milk mad_all egg_meat ///
zero_fv sugar_bev unhealthy_food lbw anc4plus csection ///
mum_educ caste rururb wi state region sex national_wgt state_wgt 

gen round=3
*/
save "iycf_nfhs4", replace


*------------------------------------------------------*--------------------------------------------------*--------

*RSOC

cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"
run make_IYCF_vars_RSOC.do

/*
keep one birthday birthmonth birthyear int_y int_m int_d int_date age_days agemos ///
evbf eibf eibf_timing ebf2d prelacteal_milk prelacteal_water prelacteal_sugarwater ///
prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey ///
prelacteal_janamghuti prelacteal_other colostrum bottle water juice broth milk ///
formula other_liq yogurt fortified_food bread legume vita_veg potato leafy_green ///
vita_fruit fruit_veg organ meat egg fish breast_milk semisolid carb leg_nut dairy ///
all_meat vita_fruit_veg breast_milk agegroup sumfoodgrp diar fever ari cont_bf cont_bf_12_23 ///
intro_compfood mdd currently_bf freq_solids mmf_bf freq_milk freq_formula freq_yogurt ///
milk_feeds feeds mmf_nobf min_milk_freq_nbf mmf_all mixed_milk mad_all egg_meat ///
zero_fv sugar_bev unhealthy_food birth_weight c_birth_wt lbw anc4plus csection ///
mum_educ caste rururb wi state statecode region sex national_wgt state_wgt 


gen round =2
*/
save "iycf_rsoc", replace

*-------------------------------------------------------*-----------------------------------------------------*---------------


*CNNS
cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"
run make_IYCF_vars_CNNS.do


/*

* the recode of state belongs in CNNS mk do file

replace state =2  if  state ==28
replace state =3  if  state ==12
replace state =4  if  state ==18
replace state =5  if  state ==10
replace state =7  if  state ==22
replace state =10  if  state ==30
replace state =11  if  state ==24
replace state =12  if  state ==6
replace state =13  if  state ==2
replace state =14  if  state ==1
replace state =15  if  state ==20
replace state =16  if  state ==29
replace state =17  if  state ==32
replace state =19  if  state ==23
replace state =20  if  state ==27
replace state =21  if  state ==14
replace state =22  if  state ==17
replace state =23  if  state ==15
replace state =24  if  state ==13
replace state =25  if  state ==7
replace state =26  if  state ==21
replace state =28  if  state ==3
replace state =29  if  state ==8
replace state =30  if  state ==11
replace state =31  if  state ==33
replace state =32  if  state ==16
replace state =33  if  state ==9
replace state =34  if  state ==5
replace state =35  if  state ==19
replace state =36  if  state ==99

keep one birthday birthmonth birthyear int_y int_m int_d int_date age_days agemos ///
evbf eibf eibf_timing ebf2d prelacteal_milk prelacteal_water prelacteal_sugarwater ///
prelacteal_gripewater prelacteal_saltwater prelacteal_formula prelacteal_honey ///
prelacteal_janamghuti prelacteal_other colostrum bottle water juice broth milk ///
formula other_liq yogurt fortified_food bread vita_veg potato leafy_green ///
vita_fruit fruit_veg organ meat egg fish breast_milk semisolid carb leg_nut dairy ///
all_meat vita_fruit_veg breast_milk agegroup sumfoodgrp diar fever ari cont_bf cont_bf_12_23 ///
intro_compfood mdd currently_bf freq_solids mmf_bf freq_milk freq_formula freq_yogurt ///
milk_feeds feeds mmf_nobf min_milk_freq_nbf mmf_all mixed_milk mad_all egg_meat ///
zero_fv sugar_bev unhealthy_food lbw anc4plus csection ///
mum_educ caste rururb wi state region sex national_wgt state_wgt 

gen round=4
*/
save "iycf_cnns", replace


*--------------------------------------------------------------*------------------------------------------------*--------------------
*MERGE ALL DATASETS
*-----------------------------------------------------------*----------------------------------------------------*-------------------

cd "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged"

use "iycf_nfhs3", clear
tab mdd,m
tab round, m 
append using "iycf_nfhs4"
tab round, m 
append using "iycf_rsoc"
tab round, m 
append using "iycf_cnns"
tab round, m 


save "C:\Users\dnyan\OneDrive\Documents\UNICEF FELLOWSHIP\CNNS\Merged\iycf_4surveys.dta", replace


* Round
la def round 1 "NFHS-3" 2 "RSOC"  3 "NFHS-4" 4 "CNNS"
la val round round

// la drop state_name
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










