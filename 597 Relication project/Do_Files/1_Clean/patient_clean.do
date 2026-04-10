/*==================================================================================
** This file cleans the patient survey file
====================================================================================*/

clear

set seed  11111

gl inputs "${raw}"
gl outputs "${clean}"

	
*1. Cleaning up file
***************************
	
	*Opening file
	use "${inputs}/patient", clear
	
		
		*1.1 Defining value labels
	
			lab def likert 		1 `"Strongly disagree"' 2 `"Disagree"' 3 `"Neutral"' 4 `"Agree"' 5 `"Strongly agree"' 
			
			lab def likert_na 	1 `"Strongly disagree"'  2 `"Disagree"'  3 `"Neutral"'  4 `"Agree"'  5 `"Strongly agree"'  99 `"Not applicable"' 
			
			lab def rating1 	0 `"0 – Worst"' 1 `"1"'   2 `"2"'  3 `"3"'  4 `"4"'  5 `"5"'  6 `"6"'  7 `"7"'  8 `"8"'  9 `"9"'  10 `"10 – Best"' 

			lab def rating2 	0 `"0 - Extremely cheap"' 1 `"1"' 2 `"2"'  3 `"3"'  4 `"4"'  5 `"5"'  6 `"6"'  7 `"7"'  ///
								8 `"8"'  9 `"9"'  10 `"10 – Extremely expensive"'
 
			
			lab def recommend 	1 `"Very Unlikely "' 2 `"Somewhat Unlikely "' 3 `"Neutral"' 4 `"Somewhat Likely "' 5 `"Very Likely "' 
			
			lab def sid 		1 `"AKWA IBOM"' 2 `"GOMBE"' 3 `"JIGAWA"' 4 `"KANO"'

			lab def symptom 	1 `"Headache "' 2 `"Fever  "' 3 `"Cough "' 4 `"Chills "' 5 `"Catarrh "' 6 `"Loss of appetite "' ///
								7 `"Vomiting "' 8 `"Diarrhoea "' 9 `"Weakness "' 10 `"Chest pain "' 11 `"Abdominal pain "' ///
								12 `"Ear pain/earache "' 88 `"Other (specify) "' 

			lab def unit 		1 `"Days"' 2 `"Weeks"' 3 `"Months"'
			
			lab def visit 		0 `"Baseline"' 1 `"Visit 1"' 2 `"Visit 2"' 3 `"Visit 3"'  4 `"Visit 4"'

			lab def yn 			0 `"No"' 1 `"Yes"'
			
			lab def yndk 		0 `"No"'  1 `"Yes"' 99 `"Don't know"'

			
		*1.2 Labelling variable values
				
			*1.2.1 Labelling yes/no for following variable values 
			
				foreach var of varlist 	a_bp a_leg a_meas a_prob a_supp a_tum a_weigh car ///
										cell ch_weigh e_mask e_stet e_wash fridge gen i1 ///
										i10 i11 i12 i13 i14 i15 i2 i3 i4 i5 i6 i7 i8 i9 ///
										p_breast p_ch_exam p_ch_weigh p_ch_yes p_danger ///
										p_exam p_heavy p_male radio reason1 reason10 ///
										reason11 reason12 reason13 reason2 reason3 ///
										reason4 reason5 reason6 reason7 reason8 reason9 ///
										seen symptom1 symptom10 symptom11 symptom12 symptom2 ///
										symptom3 symptom4 symptom5 symptom6 symptom7 symptom8 ///
										symptom88 symptom9 t_diagnosis t_educ t_meds t_return ///
										t_tests u_drink u_ear u_vacc {
					lab val `var' yn
				}
				
			*1.2.2 Labelling yesnodontknow for the following variable values
			
				foreach var of varlist 	c_blood c_color c_contact c_exp c_trig ch_growth d_blood ///
										d_cons d_contact d_howoften d_mucus d_pain e_bp e_temp ///
										e_touch f_chills f_conv f_maltest f_pattern f_runny ///
										f_vomit o_meds o_when p_ch_growth {
					
					lab val `var' yndk
				}
				
			*1.2.3 Labelling remaining variable values
				 
				lab val amenities rating1
				lab val building rating1
				lab val cleanliness rating1
				lab val drugs_av rating1
				lab val equip_av rating1
				lab val i_time_unit unit
				lab val ins_info likert_na
				lab val ins_time likert
				lab val listened likert
				lab val not_thorough likert_na
				lab val recommend recommend
				lab val s1 symptom
				lab val s2 symptom
				lab val s3 symptom
				lab val s4 symptom
				lab val s5 symptom
				lab val serv_cost rating2
				lab val sid sid
				lab val visit visit

		*1.3 Labelling variables
			
				lab var a_bp `"ANC: measured BP"'
				lab var a_leg `"ANC: pressed on legs"'
				lab var a_meas `"ANC: measured abdomen with measuring tape"'
				lab var a_prob `"ANC: asked about pregnancy problems"'
				lab var a_supp `"ANC: prescribed iron or folic acid"'
				lab var a_tum `"ANC: pressed on abdomen"'
				lab var a_weigh `"ANC: weighed"'
				lab var amenities `"Rating: Quality of patient amenities"'
				lab var building `"Rating: State of the facility building"'
				lab var c_blood `"Cough: asked whether blood in what is coughed out"'
				lab var c_color `"Cough: asked about color of what is coughed out"'
				lab var c_contact `"Cough: asked whether any contact with someone with a chronic cough"'
				lab var c_exp `"Cough: asked whether anything coughed out"'
				lab var c_trig `"Cough: asked what aggravates it"'
				lab var car `"Has a car/truck"'
				lab var cell `"Has mobile telephone"'
				lab var ch_growth `"Process: Child's weight checked against growth chart"'
				lab var ch_weigh `"Process: Child weighed"'
				lab var cleanliness `"Rating: Cleanliness"'
				lab var d_blood `"Diarrhoea: asked whether blood"'
				lab var d_cons `"Diarrhoea: asked about consistency"'
				lab var d_contact `"Diarrhoea: asked whether others also have it"'
				lab var d_howoften `"Diarrhoea: asked about frequency"'
				lab var d_mucus `"Diarrhoea: asked whether mucus"'
				lab var d_pain `"Diarrhoea: asked whether abdominal pain"'
				lab var date `"Visit Date"'
				lab var drugs_av `"Agrees: Improved drugs availability"'
				lab var e_bp `"Process: BP measured"'
				lab var e_mask `"Process: Provider was wearing face covering"'
				lab var e_stet `"Process: Examined with a stethoscope"'
				lab var e_temp `"Process: Temperature taken"'
				lab var e_touch `"Process: Examined"'
				lab var e_wash `"Process: Provider washed hands after exam"'
				lab var end `"Interview end time"'
				lab var equip_av `"Agrees: Improved equipment availability"'
				lab var f_chills `"Fever: asked whether chills/sweats"'
				lab var f_conv `"Fever: asked about convulsions"'
				lab var f_maltest `"Fever: asked to do a malaria test"'
				lab var f_pattern `"Fever: asked about pattern"'
				lab var f_runny `"Fever: asked whether catarrh/runny nose"'
				lab var f_vomit `"Fever: asked whether vomit"'
				lab var fridge `"Has a refrigerator"'
				lab var gen `"Has a generator"'
				lab var hfac `"Clinic Identifier"'
				lab var i1 `"Injury: type - Animal/human bite "'
				lab var i2 `"Injury: type - Burn/scald "'
				lab var i3 `"Injury: type - Foreign body in skin  "'
				lab var i4 `"Injury: type - Bruise/contusion "'
				lab var i5 `"Injury: type - Abrasion/scratch/blister "'
				lab var i6 `"Injury: type - Laceration/cut "'
				lab var i7 `"Injury: type - Trauma/injury  "'
				lab var i8 `"Injury: type - Multiple trauma/injuries "'
				lab var i9 `"Injury: type - Contusion/haemorrhage eye "'
				lab var i10 `"Injury: type - Foreign body in eye "'
				lab var i11 `"Injury: type - Foreign body in ear  "'
				lab var i12 `"Injury: type - Fracture (broken bone) "'
				lab var i13 `"Injury: type - Sprain/strain "'
				lab var i14 `"Injury: type - Poisoning  "'
				lab var i15 `"Injury: type - Other (Specified) "'
				lab var i_oth `"Injury: type - Other (Specified)"'
				lab var i_time `"Injury: time"'
				lab var i_time_unit `"Injury: time unit"'
				lab var ins_info `"Agrees: The provider did NOT give me enough information about treatment"'
				lab var ins_time `"Agrees: The provider did NOT spend enough time with me"'
				lab var key `"Facility-Wave Identifier"'
				lab var listened `"Agrees: The provider listened carefully to what I had to say"'
				lab var not_thorough `"Agrees: The provider was NOT very thorough during exam"'
				lab var o_meds `"Asked about medications taken"'
				lab var o_when `"Asked when problems started"'
				lab var p_age_m `"Patient: Age (months)"'
				lab var p_age_y `"Patient: Age (years)"'
				lab var p_breast `"PNC: counselled on breastfeeding"'
				lab var p_ch_exam `"PNC: child examined"'
				lab var p_ch_growth `"PNC: child's weight checked against a growth chart"'
				lab var p_ch_weigh `"PNC: child weighed"'
				lab var p_ch_yes `"PNC: came with newborn today"'
				lab var p_danger `"PNC: counselled on danger signs for the newborn"'
				lab var p_exam `"PNC: examined"'
				lab var p_heavy `"PNC: checked for heavy bleeding"'
				lab var p_male `"Patient: Male"'
				lab var pid `"Patient ID"'
				lab var prov_min `"Visit: Time with provider (minutes)"'
				lab var radio `"Has a radio"'
				lab var reason1 `"Visit: Reason - Illness "'
				lab var reason2 `"Visit: Reason - Injury  "'
				lab var reason3 `"Visit: Reason - Physical check-up  "'
				lab var reason4 `"Visit: Reason - Immunizations "'
				lab var reason5 `"Visit: Reason - Family planning  "'
				lab var reason6 `"Visit: Reason - Routine antenatal "'
				lab var reason7 `"Visit: Reason - Routine postnatal "'
				lab var reason8 `"Visit: Reason - Dental care "'
				lab var reason9 `"Visit: Reason - Circumcision "'
				lab var reason10 `"Visit: Reason - HIV counseling and testing (VCT) "'
				lab var reason11 `"Visit: Reason - Other forms of Counseling "'
				lab var reason12 `"Visit: Reason - Physiotherapy "'
				lab var reason13 `"Visit: Reason - Other (Specified) "'
				lab var reason_oth `"Visit: Reason - Other (Specified)"'
				lab var recommend `"Rating: How likely to recommend this clinic"'
				lab var s1 `"Symptoms: Main symptom"'
				lab var s2 `"Symptoms: Symptom 2"'
				lab var s3 `"Symptoms: Symptom 3"'
				lab var s4 `"Symptoms: Symptom 4"'
				lab var s5 `"Symptoms: Symptom 5"'
				lab var seen `"Seen by health provider"'
				lab var serv_cost `"Rating: Cost of services"'
				lab var sid `"State"'
				lab var start `"Interview start time"'
				lab var symptom1 `"Symptom: Headache"'
				lab var symptom1_start `"Symptom: Headache - Duration (days)"'
				lab var symptom2 `"Symptom: Fever"'
				lab var symptom2_start `"Symptom: Fever - Duration (days)"'
				lab var symptom3 `"Symptom: Cough"'
				lab var symptom3_start `"Symptom: Cough - Duration (days)"'
				lab var symptom4 `"Symptom: Chills"'
				lab var symptom4_start `"Symptom: Chills - Duration (days)"'
				lab var symptom5 `"Symptom: Catarrh"'
				lab var symptom5_start `"Symptom: Catarrh - Duration (days)"'
				lab var symptom6 `"Symptom: Loss of appetite"'
				lab var symptom6_start `"Symptom: Loss of appetite - Duration (days)"'
				lab var symptom7 `"Symptom: Vomiting"'
				lab var symptom7_start `"Symptom: Vomiting - Duration (days)"'
				lab var symptom8 `"Symptom: Diarrhoea"'
				lab var symptom10 `"Symptom: Chest pain"'
				lab var symptom10_start `"Symptom: Chest pain - Duration (days)"'
				lab var symptom11 `"Symptom: Abdominal pain"'
				lab var symptom11_start `"Symptom: Abdominal pain - Duration (days)"'
				lab var symptom12 `"Symptom: Ear pain/earache"'
				lab var symptom12_start `"Symptom: Ear pain/earache - Duration (days)"'
				lab var symptom88 `"Symptom: Other (specify)"'
				lab var symptom88_start `"Symptom: Other (specify) - Duration (days)"'
				lab var symptom8_start `"Symptom: Diarrhoea - Duration (days)"'
				lab var symptom9 `"Symptom: Weakness"'
				lab var symptom9_start `"Symptom: Weakness - Duration (days)"'
				lab var symptom_oth `"Symptom: Other - Specified"'
				lab var t_diagnosis `"Process: Told diagnosis"'
				lab var t_educ `"Process: Received health education related to the diagnosis"'
				lab var t_meds `"Process: Prescribed medicines"'
				lab var t_return `"Process: Provider explained whether to return"'
				lab var t_tests `"Process: Asked to do any lab tests"'
				lab var u_drink `"Under 5: asked whether drinking/breastfeeding well"'
				lab var u_ear `"Under 5: asked whether ear pain / discharge"'
				lab var u_vacc `"Under 5: asked about vaccination history"'
				lab var visit `"Visit"'
				lab var wait_min `"Visit: Wait time (minutes)"'

 
		*1.4 Sort data
			order key hfac sid date
			sort key hfac sid date
			
		*Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }
			 
		*1.5 Ordering variables
			order 	key hfac pid visit sid date start seen wait_min prov_min p_male ///
					p_age_y p_age_m reason1 reason2 reason3 reason4 reason5 reason6 ///
					reason7 reason8 reason9 reason10 reason11 reason12 reason13 ///
					reason_oth s1 s2 s3 s4 s5 symptom1 symptom2 symptom3 ///
					symptom4 symptom5 symptom6 symptom7 symptom8 symptom9 ///
					symptom10 symptom11 symptom12 symptom88 symptom_oth ///
					symptom1_start symptom2_start symptom3_start ///
					symptom4_start symptom5_start symptom6_start symptom7_start ///
					symptom8_start symptom9_start symptom10_start ///
					symptom11_start symptom12_start symptom88_start ///
					f_pattern f_vomit f_chills f_runny f_conv f_maltest ///
					c_trig c_exp c_color c_blood c_contact d_howoften ///
					d_cons d_blood d_mucus d_pain d_contact o_when o_meds ///
					i1 i2 i3 i4 i5 i6 i7 i8 i9 i10 i11 i12 i13 i14 i15 i_oth ///
					i_time i_time_unit a_prob a_tum a_meas a_bp a_leg a_weigh ///
					a_supp p_exam p_heavy p_danger p_breast p_ch_yes ///
					p_ch_exam p_ch_weigh p_ch_growth u_drink u_ear u_vacc ///
					e_bp e_temp e_touch e_wash e_stet e_mask ch_weigh ///
					ch_growth t_diagnosis t_educ t_return t_tests t_meds ins_time ///
					listened not_thorough ins_info recommend drugs_av equip_av ///
					serv_cost cleanliness building amenities radio fridge ///
					cell gen car end
										 

	*Saving dataset
	save "${outputs}/patient", replace	
