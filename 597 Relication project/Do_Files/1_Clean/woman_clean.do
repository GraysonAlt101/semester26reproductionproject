/*==================================================================================
** This file cleans the woman baseline and endline survey files
====================================================================================*/
	
clear

set seed  11111

gl inputs "${raw}/"
gl outputs "${clean}/"


*---------------------------------------*	
* BASELINE DATASETS
*---------------------------------------*
	
*1. Cleaning up main file
****************************
	
	*Opening file
		use "${inputs}/woman_bl", clear				
	

		*1.1 Defining value labels
		
			lab def dec 		1 `"Respondent alone "' 2 `"Husband/partner alone"'  3 `"Jointly"' 88 `"Other "'

			
			lab def direction 	1 `"Decreases"' 2 `"Neither increases nor decreases"' 3 `"Increases"' 99 `"Don't know"'
			
			lab def ethnic 		1 `"Fulani"' 2 `"Hausa"' 3 `"Tangale"' 4 `"Tera"' 5 `"Waja"' 6 `"Igbo"' 7 `"Yoruba"' ///
								8 `"Ibibio"' 9 `"Efik"' 10 `"Oron"' 11 `"Annang"' 88 `"Other"' 
			
			lab def eye			0 `"Normal"' 1 `"Borderline"' 2 `"Pale"' 99 `"Refused"'
			
			lab def h_rating 	1 `"Poor"' 2 `"Fair"' 3 `"Good"' 4 `"Very good"' 5 `"Excellent"' 
			
			lab def likert 		1 `"Strongly disagree"' 2 `"Disagree"' 3 `"Neutral"' 4 `"Agree"' 5 `"Strongly agree"'  
			
			lab def loc 		1 `"Home"' 2 `"Other home"' 3 `"Tertiary/Teaching Hospital"' 4 `"Government general hospital"' ///
								5 `"Study PHC"'6 `"Other PHC"' 7 `"Private hospital/clinic"' 8 `"Maternity home"' ///
								9 `"Church/spiritual house"' 88 `"Other"' 
								
			lab def marital 	1 `"Never married  "' 2 `"Married  "' 3 `"Partner-living together"' 4 `"Divorced  "' ///
								5 `"Separated  "' 6 `"Widowed  "'
			
			lab def occup 		1 `" Agricultural worker, own field "' 2 `"Agricultural wage-labor, cash / in kind "' ///
								3 `"Salaried employee (pvt) "' 4 `"Salaried employee (gvt) "' 5 `"Has a trade"' 6 `"Business/trader "' ///
								7 `"Petty trader/kiosk "' 8 `"Laborer "' 9 `" Homemaker "' 10 `"Retired "' 11 `"Student  "' ///
								12 `"Never worked, seeking work "' 13 `"Never worked, not seeking work "'   

			lab def read 		1 `"Cannot read at all"' 2 `"Able to read only parts of sentence"' 3 `"Able to read whole sentence"' ///
								4 `"Blind/visually impaired"'
								
			lab def religion 	1 `"Catholic"' 2 `"Anglican"' 3 `"Pentecostal"' 4 `"Other Christian"' 5 `"Muslim"' ///
								6 `"Traditionalist"' 7 `"Atheist"' 88 `"Other"'

			lab def school 		0 `"No Schooling "' 1 `"Kindergarten  "' 2 `"Primary 1 "'  3 `"Primary 2 "' ///
								4 `"Primary 3 "' 5 `"Primary 4 "' 6 `"Primary 5 "' 7 `"Primary 6  "' 8 `"JS 1 "' ///
								9 `"JS 2 "' 10 `"JS 3 "' 11 `"SS 1 "' 12 `"SS 2 "' 13 `"SS 3 "' 14 `"College of Education/Polytechnic"' ///
								15 `"University (Bachelors)"' 16 `"University (Masters or higher)"' ///
								17 `"Attended Koranic School"'
								
			lab def sid 		1 `"AKWA IBOM"' 2 `"GOMBE"' 3 `"JIGAWA"' 4 `"KANO"'
			
			lab def yn 			0 `"No"'  1 `"Yes"'
			
			lab def yndk 		0 `"No"' 1 `"Yes"'  99 `"Don't know"'
								
				
		*1.2 Labelling variable values
				
				
			*1.2.1 Labelling yes/no for following variable values 
				foreach var of varlist 	all_comp all_still anc_loc1 anc_loc10 anc_loc2 anc_loc3 anc_loc4 ///
										anc_loc5 anc_loc6 anc_loc7 anc_loc8 anc_loc9 consent del_first ///
										dob_know enrolled ever_diab ever_hyper ext_comp ext_still ///
										here_always imm_comp imm_still int_partn ma_any mr mr_bleeding ///
										mr_convulsions mr_loss_consc mr_obstr mr_prolong mr_tear net ///
										occ_act othocc othwives own_risk p_use plan_del preg still_any ///
										still_noanc_first still_tba_first w_nobl wanted {
					
					lab val `var' yn
				}
							
				
			*1.2.2 Labelling remaining variable values
				lab val afford likert
				lab val anc yndk
				lab val anemia_eff direction
				lab val bleed yndk
				lab val dec_deliv dec
				lab val dec_health dec
				lab val dec_money dec
				lab val doc_notworth likert
				lab val ethnic ethnic
				lab val eye eye
				lab val h_rating h_rating
				lab val hf_notworth likert
				lab val hyper yndk
				lab val intercourse_eff direction
				lab val iron yndk
				lab val malaria yndk
				lab val marital marital
				lab val more5del_eff direction
				lab val noneed likert
				lab val nullip_eff direction
				lab val occ_type occup
				lab val older35_eff direction
				lab val partn_occ occup
				lab val partn_school school
				lab val plan_del_loc loc
				lab val predetermined likert
				lab val read read
				lab val religion religion
				lab val school school
				lab val sid sid
				lab val tba_same likert										
					

		*1.3 Labelling variables
			
			lab var afford `"Agrees: Cannot afford a HF delivery"'
			lab var age_bl `"Demographics: Age at Baseline"'
			lab var age_married `"Demographics: Age at marriage"'
			lab var alcohol `"Preg. behav.: Days drank alcohol, last 30"'
			lab var all_comp `"Awar.: Any delivery complications among acquaintances"'
			lab var all_still `"Awar.: Any stillbirths among acquaintances"'
			lab var anc `"ANC: Any ANC"'
			lab var anc_loc1 `"ANC: Location - Home"'
			lab var anc_loc2 `"ANC: Location - Other home"'
			lab var anc_loc3 `"ANC: Location - Tertiary/Teaching Hospital"'
			lab var anc_loc4 `"ANC: Location - Government general hospital"'
			lab var anc_loc5 `"ANC: Location - Study PHC"'
			lab var anc_loc6 `"ANC: Location - Other PHC"'
			lab var anc_loc7 `"ANC: Location - Private hospital/clinic"'
			lab var anc_loc8 `"ANC: Location - Maternity home"'
			lab var anc_loc9 `"ANC: Location - Church/spiritual house"'
			lab var anc_loc10 `"ANC: Location - Other"'
			lab var anc_loc_oth `"ANC: Location - Other (Specified)"'
			lab var anc_tot `"ANC: Total visits"'
			lab var anemia_eff `"Knowl.: Effect of anemia on risk"'
			lab var bleed `"Complic. - Preg.: Vaginal bleeding"'
			lab var boy_high `"Beliefs - Prob: Having a boy - Upper bound"'
			lab var boy_low `"Beliefs - Prob: Having a boy - Lower bound"'
			lab var chores_days `"Time use: Days carried out household chores (7d)"'
			lab var chores_hrs `"Time use: Hrs carried out household chores per day (7d)"'
			lab var consent `"Interv.: Consent"'
			lab var date `"Interview Date"'
			lab var dec_deliv `"Decision-maker: Delivery location"'
			lab var dec_deliv_oth `"Decision-maker: Delivery location - Other (Specified)"'
			lab var dec_health `"Decision-maker: Woman's health care"'
			lab var dec_health_oth `"Decision-maker: Woman's health care - Other (Specified)"'
			lab var dec_money `"Decision-maker: Woman's money"'
			lab var dec_money_oth `"Decision-maker: Woman's money - Other (Specified)"'
			lab var del_first `"Preg. history: First delivery"'
			lab var dob_know `"Demographics: Knows her date of birth"'
			lab var doc_notworth `"Agrees: HF delivery only in case of problems"'
			lab var drugs_av `"PHC rating: Availability of drugs"'
			lab var due_date `"Preg.: Predicted due date"'
			lab var end `"Interview end time"'
			lab var enrolled `"Enrolled"'
			lab var equip_av `"PHC rating: Availability of equipment"'
			lab var ethnic `"Demographics: Ethnic group or tribe"'
			lab var ethnic_oth `"Demographics: Ethnic group or tribe - Other (Specified)"'
			lab var ever_diab `"Health history: Prior diagnosis of diabetes"'
			lab var ever_hyper `"Health history: Prior diagnosis of high BP / hypertension"'
			lab var ext_comp `"Awar.: Any delivery complications among extd. family"'
			lab var ext_still `"Awar.: Any stillbirths among extd. family"'
			lab var eye `"Health history: Eye assessment"'
			lab var h_rating `"Health rating"'
			lab var here_always `"Demographics: Has always lived in this community"'
			lab var here_year `"Demographics: Year started living in this community"'
			lab var hf_notworth `"Agrees: HF delivery not worth the money"'
			lab var hfac `"Clinic Identifier"'
			lab var hhid `"Household ID"'
			lab var hw_av `"PHC rating: Availability of health workers"'
			lab var hw_comp `"PHC rating: Competence of health workers"'
			lab var hw_treat `"PHC rating: Attitude of health workers"'
			lab var hyper `"Complic. - Preg.: Hypertension"'
			lab var imm_comp `"Awar.: Any delivery complications among immed. family"'
			lab var imm_still `"Awar.: Any stillbirths among immed.family"'
			lab var int_partn `"Husband / partner present during interview"'
			lab var intercourse_eff `"Knowl.: Effect of intercourse on risk"'
			lab var iron `"Preg. behav.: Iron tablets / syrup"'
			lab var l_tot `"Total children lost"'
			lab var l_yes `"Lost any children"'
			lab var ma_any `"Preg. history: Any miscarriages / abortions"'
			lab var ma_tot `"Preg. history: Total miscarriages / abortions"'
			lab var malaria `"Preg. behav.: Anti-malarial drugs"'
			lab var marital `"Demographics: Marital status"'
			lab var more5del_eff `"Knowl.: Effect of 5+ deliveries on risk"'
			lab var mr `"Most recent delivery (3y)"'
			lab var mr_anc_tot `"Last deliv.: Total ANC visits"'
			lab var mr_bleeding `"Last deliv.: Severe bleeding"'
			lab var mr_convulsions `"Last deliv.: Convulsions"'
			lab var mr_loss_consc `"Last deliv.: Loss of consciousness"'
			lab var mr_obstr `"Last deliv.: Obstructed labor"'
			lab var mr_prolong `"Last deliv.: Prolonged labor"'
			lab var mr_tear `"Last deliv.: Vaginal tear"'
			lab var net `"Preg. behav.: Used mosquito bed net (last night)"'
			lab var noneed `"Agrees: Strong women need not deliver in a HF"'
			lab var nullip_eff `"Knowl.: Effect of nulliparity on risk"'
			lab var occ_act `"Time use: Active in main occupation (6mo)"'
			lab var occ_days `"Time use: Days worked in main occupation (7d)"'
			lab var occ_hrs `"Time use: Hrs per day worked in main occupation (7d)"'
			lab var occ_type `"Demographics: Main occupation"'
			lab var older35_eff `"Knowl.: Effect of being 35+ on risk"'
			lab var othocc `"Time use: Has any other jobs"'
			lab var othocc_days `"Time use: Days worked in other jobs (7d)"'
			lab var othocc_hrs `"Time use: Hrs per day worked in other jobs (7d)"'
			lab var othwives `"Demographics: Husband has other wives"'
			lab var othwives_tot `"Demographics: Number of other wives"'
			lab var own_comp_high `"Beliefs - Own risk: Complications - Upper bound"'
			lab var own_comp_low `"Beliefs - Own risk: Complications - Lower bound"'
			lab var own_risk `"Beliefs - Own risk: Thinks she has any risk factors"'
			lab var own_still_high `"Beliefs - Own risk: Stillbirth - Upper bound"'
			lab var own_still_low `"Beliefs - Own risk: Stillbirth - Lower bound"'
			lab var p_use `"PHC utilization: Ever used PHC"'
			lab var partn_occ `"Demographics: Partner's main occupation"'
			lab var partn_school `"Demographics: Partner's schooling"'
			lab var partner_age `"Demographics: Partner's age"'
			lab var plan_del `"Deliv. plans: Has made a decision"'
			lab var plan_del_loc `"Deliv. plans: Planned location"'
			lab var plan_del_loc_oth `"Deliv. plans: Planned location - Other (Specified)"'
			lab var predetermined `"Agrees: Pregnancy outcome is predetermined"'
			lab var preg `"Preg.: Currently pregnant"'
			lab var preg_m `"Preg.: Months pregnant at baseline"'
			lab var preg_w `"Preg.: Weeks pregnant at baseline"'
			lab var read `"Demographics: Reading level"'
			lab var religion `"Demographics: Religion"'
			lab var religion_oth `"Demographics: Religion - Other (Specified)"'
			lab var school `"Demographics: Schooling"'
			lab var serv_av `"PHC rating: Availability of services"'
			lab var serv_cost `"PHC rating: Affordability"'
			lab var sid `"State"'
			lab var start `"Interview start time"'
			lab var still_anc_high `"Beliefs - Prob: Stillbirth if ANC - Upper bound"'
			lab var still_anc_low `"Beliefs - Prob: Stillbirth if ANC - Lower bound"'
			lab var still_any `"Preg. history: Any stillbirths"'
			lab var still_fac_high `"Beliefs - Prob: Stillbirth if facility delivery - Upper bound"'
			lab var still_fac_low `"Beliefs - Prob: Stillbirth if facility delivery - Lower bound"'
			lab var still_high `"Beliefs - Prob: Stillbirth - Upper bound"'
			lab var still_low `"Beliefs - Prob: Stillbirth - Lower bound"'
			lab var still_noanc_first `"Beliefs - Prob: Stillbirth if no ANC asked before  if ANC"'
			lab var still_noanc_high `"Beliefs - Prob: Stillbirth if no ANC - Upper bound"'
			lab var still_noanc_low `"Beliefs - Prob: Stillbirth if no ANC - Lower bound"'
			lab var still_tba_first `"Beliefs - Prob: Stillbirth if TBA asked before if facility"'
			lab var still_tba_high `"Beliefs - Prob: Stillbirth if TBA delivery - Upper bound"'
			lab var still_tba_low `"Beliefs - Prob: Stillbirth if TBA delivery - Lower bound"'
			lab var still_tot `"Preg. history: Total stillbirths"'
			lab var tba_same `"Agrees: TBAs provide same care as HWs"'
			lab var tot_num_children `"Total number of children"'
			lab var vid `"Village ID"'
			lab var w_nobl `"Baseline missing (collected at endline)"'
			lab var w_phone `"Have GSM number"'
			lab var wanted `"Preg.: Wanted to get pregnant"'
			lab var wid `"Woman ID"'

	*1.4 Sort data
			sort hfac vid wid
			
	*1.5 Standardizing variable values
		
		
		*1.5.1 Standardizing decision-maker
			local var dec_money
			replace `var'_oth=lower(`var'_oth)
			replace `var'_oth="mother-in-law" if regexm(`var'_oth,"other in")
			replace `var'_oth="parents-in-law" if regexm(`var'_oth,"arents in")

			local var dec_health
			replace `var'_oth=lower(`var'_oth)
			replace `var'_oth="mother-in-law" if regexm(`var'_oth,"other in")
			replace `var'_oth="father-in-law" if regexm(`var'_oth,"father in- law")
			replace `var'_oth="parents-in-law" if regexm(`var'_oth,"in laws") | regexm(`var'_oth,"inlow")

			local var dec_deliv
			replace `var'_oth=lower(`var'_oth)
			replace `var'_oth=regexr(`var'_oth," and ","/")
			replace `var'_oth=regexr(`var'_oth," /","/")
			
			foreach string in "grand mother" "grandma" {
				replace `var'_oth="grandmother" if regexm(`var'_oth,"`string'")
			}
			
			foreach string in "other in" "other  in" "mother in" "otherin" "partner's mother" {
				replace `var'_oth="mother-in-law" if regexm(`var'_oth,"`string'")
			}
			
			foreach string in "in laws" "inlow" {
				replace `var'_oth="parents-in-law" if `var'_oth=="`string'"
			}
			
			foreach string in "god" "allah" {
				replace `var'_oth="God/Allah" if `var'_oth=="`string'"
			}
			
			foreach string in "respondent" {
				replace `var'=1 if `var'_oth=="respondent" 
				replace `var'_oth="" if `var'_oth=="`string'"
			}
			replace `var'_oth="respondent/household head" if regexm(`var'_oth,"head/respondent")
			replace `var'_oth="household head" if `var'_oth=="house hold head"
			replace `var'_oth="parents" if `var'_oth=="mother/ father" | `var'_oth=="parent"
			replace `var'_oth="father-in-law" if `var'_oth=="father in law"
			replace `var'_oth="father" if `var'_oth=="faher" | `var'_oth=="dad" | `var'_oth=="my father" 
			replace `var'_oth="mother/step mother" if `var'_oth=="mother" |`var'_oth=="step mother" | `var'_oth=="mom" | `var'_oth=="mum" 
			replace `var'_oth="aunty" if `var'_oth=="aunt" 
			replace `var'_oth="respondent/mother" if `var'_oth=="with my mother"
			replace `var'_oth="respondent/parents" if `var'_oth=="with parents" 
			replace `var'_oth="respondent/guardian" if `var'_oth=="guardian/respondent" 
			replace `var'_oth="partner/parents-in-law" if `var'_oth=="partner/inlaws"
			replace `var'_oth="sister-in-law" if `var'_oth=="sister inlaw" 
			replace `var'_oth="other relative" if `var'_oth=="other  relative" 
			replace `var'_oth="respondent/parents" if `var'_oth=="respondent/parent" 
			replace `var'_oth="respondent/parents" if `var'_oth=="respondent/parent" 
			replace `var'_oth="anywhere it happens" if `var'_oth=="anywhere  it happens" 
			replace `var'_oth="i don't know" if `var'_oth=="no idea" 

		*1.5.2 Standardize planned delivery location

			local var plan_del_loc
			
			foreach string in "Traditional" "home town" {
				replace `var'=2 if regexm(`var'_oth,"`string'")
				replace `var'_oth="" if regexm(`var'_oth,"`string'")
			}
			
			foreach string in "Federal medical center" "General Hospital" {
				replace `var'=4 if regexm(`var'_oth,"`string'")
				replace `var'_oth="" if regexm(`var'_oth,"`string'")
			}
			
		*Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }
		
		
	*1.6 Ordering variables
		order 	wid w_nobl enrolled sid hfac vid date hhid start consent ///
				w_phone preg preg_m preg_w due_date dob_know age_bl marital ///
				age_married ethnic ethnic_oth religion religion_oth here_always ///
				here_year school read occ_type occ_act occ_days occ_hrs othocc ///
				othocc_days othocc_hrs chores_days chores_hrs partner_age ///
				othwives othwives_tot partn_school partn_occ dec_money ///
				dec_money_oth dec_health dec_health_oth h_rating ever_hyper ///
				ever_diab alcohol net eye del_first tot_num_children l_yes ///
				l_tot still_any still_tot mr mr_anc_tot mr_convulsions ///
				mr_prolong mr_obstr mr_bleeding mr_loss_consc mr_tear ma_any ///
				ma_tot wanted anc anc_loc1 anc_loc2 anc_loc3 anc_loc4 anc_loc5 ///
				anc_loc6 anc_loc7 anc_loc8 anc_loc9 anc_loc10 anc_loc_oth ///
				anc_tot iron malaria hyper bleed plan_del plan_del_loc ///
				plan_del_loc_oth dec_deliv dec_deliv_oth afford predetermined ///
				noneed tba_same hf_notworth doc_notworth boy_low boy_high ///
				still_low still_high still_noanc_first still_anc_low ///
				still_anc_high still_tba_first still_noanc_low still_noanc_high ///
				still_tba_low still_tba_high still_fac_low still_fac_high ///
				own_still_low own_still_high own_comp_low own_comp_high ///
				imm_still imm_comp ext_still ext_comp all_still all_comp ///
				nullip_eff intercourse_eff older35_eff more5del_eff ///
				anemia_eff own_risk p_use serv_av hw_av hw_comp hw_treat ///
				drugs_av equip_av serv_cost int_partn end
					
	*Saving dataset
		save "${outputs}/woman_bl", replace	
	
	
*---------------------------------------*	
* FOLLOW-UP DATASETS
*---------------------------------------*

	*2. Cleaning up main file
	*****************************
	
	*Opening file
		use "${inputs}/woman_el", clear
	
		
		*2.1 Defining value labels
					
			lab def anc_doc 		1 `"ANC card"' 88 `"Other"'
			
			lab def anxious 		0 `"No, not at all"'  1 `"Hardly ever"' 2 `"Yes, sometimes"' 3 `"Yes, very often"'
			
			lab def blame 			0 `"No, never"'  1 `"Not very often"' 2 `"Yes, some of the time"' 3 `"Yes, most of the time"'
			
			lab def caes_why 		1 `"Doctor/nurse told me I had to"'  2 `"I was bleeding"' 3 `"The baby was stuck"' ///
									4 `"I was in labor pain for a long time"' 5 `"The baby was not in the right position"' ///
									6 `"I had a disease"' 7 `"My womb was broken/ruptured"' 8 `"Other problems with the baby"' ///
									9 `"No medical reason"' 10 `"I asked for it"' 88 `"Other"' 99 `"Don't know / remember"'

			lab def cash_oth 		88 `"Other"'  2500 `"N2,500"' 4000 `"N4,000"' 10000 `"N10,000"'
			
			lab def cond_anc 		1 `"1"'  2 `"2"' 3 `"3"' 4 `"4"' 5 `"5"' 88 `"Other"'
			
			lab def del_doc 		1 `"Facility card"'  2 `"Birth certificate"' 3 `"Hospital receipt"' 4 `"Birth notice"' 88 `"Other"'

			lab def del_how 		1 `"Unassisted"'  2 `"Forceps"'  3 `"Suction"'  4 `"C/S"' 99 `"Don't know"'
			
			lab def del_time 		1 `"Early"' 2 `"At expected time"' 3 `"Late"' 99 `"Don't know"'
			
			lab def died_cause 		1 `"Road traffic accident"'  2 `"Other accident or injury"' 3 `"Longstanding health problem"' ///
									4 `"Acute sickness"' 5 `"Pregnancy complication"' 6 `"Delivery complication"' ///
									88 `"Other"' 99 `"Don't know / remember"'  
			
			lab def died_time 		1 `"While still pregnant"'  2 `"During childbirth"' 3 `"Within 2 months of giving birth"' ///
									4 `"2 or more months after giving birth"'

			lab def direction 		1 `"Decreases"'  2 `"Neither increases nor decreases"' 3 `"Increases"' 99 `"Don't know"'
			
			lab def enjoy 			0 `"As much as I ever did"'  1 `"Rather less than I used to"'  ///
									2 `"Definitely less than I used to"'  3 `"Hardly at all"'

			lab def h_rating 		1 `"Poor"'  2 `"Fair"' 3 `"Good"' 4 `"Very good"' 5 `"Excellent"'

			lab def harm 			0 `"Never"'  1 `"Hardly ever"' 2 `"Sometimes"' 3 `"Yes, quite often"'
			
			lab def howoften 		1 `"Rarely (once or twice in the past 4 weeks)"'  ///
									2 `"Sometimes (3-10 times in the past 4 weeks)"'  ///
									3 `"Often (more than 10 times in the past 4 weeks)"'
									
			lab def ind_how 		1 `"Received injection during labor"' 2 `"Given medication in drip (IV line)"' 88 `"Other"'
			
			lab def int_whynot 		0 `"Pending"' 1 `"No consent"' 2 `"Never pregnant"' 3 `"Relocated"' ///
									4 `"Still pregnant, not randomized"' 5 `"Already interviewed"'
									
			lab def labor 			1 `"Started by itself "'  2 `"Someone did something"'  3 `"Never went into labor"'  99 `"Don't know"'
			
			lab def laugh 			0 `"As much as I always could"'  1 `"Not quite so much now"'  2 `"Definitely not so much now"'  3 `"Not at all"'
			
			lab def likert 			1 `"Strongly disagree"'  2 `"Disagree"'  3 `"Neutral"' 4 `"Agree"' 5 `"Strongly agree"'
			
			lab def loc 			1 `"Home"'  2 `"Other home"' 3 `"Tertiary/Teaching Hospital"' 4 `"Government general hospital"' ///
									5 `"Study PHC"' 6 `"Other PHC"' 7 `"Private hospital/clinic"' 8 `"Maternity home"' ///
									9 `"Church/spiritual house"' 88 `"Other"'
									
			lab def mis_phys 		0 `"No physical mistreatment"'  1 `"Yes, physically threatened"' 2 `"Yes, hit or slapped"' ///
									88 `"Yes, Other"' 99 `"Don't know"'
									
			lab def mis_verb 		0 `"No verbal mistreatment"'  1 `"Yes, verbally threatened"'  2 `"Yes, shouted at"' ///
									88 `"Yes, Other"' 99 `"Don't know"'

			lab def oth_resp_rel 	1 `"Husband/Partner"' 2 `"Son/Daughter"'  3 `"Grandchild"' 4 `"Father or Mother"' ///
									5 `"Sister or Brother"' 6 `"Niece or Nephew"' 7 `"Son/Daughter-in-law"' ///
									8 `"Brother/Sister-in-law"' 9 `"Father/Mother-in-law"' 10 `"Other relative"' ///
									11 `"Servant"' 12 `"Tenant/Boarder"' 13 `"Neighbor"' 88 `"Other unrelated person"'

			lab def plac 			0 `"Yes"'  1 `"No"'  2 `"Delivered immediately w/o assistance"'  99 `"Don't know"'
			
			lab def preg_end 		1 `"Delivered"'  2 `"Miscarried"'  3 `"Aborted"' 4 `"Died while pregnant"' 5 `"Never pregnant"'

			lab def often 			0 `"No, not at all"'  1 `"Not very often"'  2 `"Yes, sometimes"' 3 `"Yes, most of the time"'
			
			lab def ontop 			0 `"No, not at all"'  1 `"No, not much"'  2 `"Yes, sometimes"' 3 `"Yes, quite a lot"'
			
			lab def satisf 			1 `"Very unsatisfied"'  2 `"Somewhat unsatisfied"'  3 `"Neither satisfied or unsatisfied"' ///
									4 `"Somewhat satisfied"' 5 `"Very satisfied"'
									
			lab def scared 			0 `"No, not at all"'  1 `"No, not much"' 2 `"Yes, sometimes"' 3 `"Yes, quite a lot"'
			
			lab def tbv 			0 `"No"'  1 `"Yes, FS will verify from register"' 2 `"Yes, woman will provide doc"'
			
			lab def timechange 		1 `"Decreased"' 2 `"Stayed the same"' 3 `"Increased"'
			
			lab def treat_loc 		3 `"Tertiary/Teaching Hospital"'  4 `"Government general hospital"'  5 `"Study PHC"' ///
									6 `"Other PHC"' 7 `"Private hospital/clinic"' 8 `"Maternity home"' ///
									10 `"Traditional birth attendant"' 11 `"Chemist/Drug store"' 88 `"Other"'

			lab def unhappy 		0 `"No, never"'  1 `"Only occasionally"' 2 `"Yes, quite often"' 3 `"Yes, most of the time"'
			
			lab def v_met 			0 `"No"'  1 `"Yes"'  2 `"TBV later"'
			
			lab def w_or_m 			1 `"Weeks"' 2 `"Months"'
			
			lab def yn 				0 `"No"' 1 `"Yes"'

			lab def yndk 			0 `"No"' 1 `"Yes"' 99 `"Don't know"'
				 
				
				
		*2.2 Labelling variable values
				
			*2.2.1 Labelling yes/no for following variable values 
			
				foreach var of varlist 	anc_doc anc_doc_conf anc_loc1 anc_loc10 anc_loc2 anc_loc3 anc_loc4 anc_loc5 anc_loc6 anc_loc7 ///
										anc_loc8 anc_loc9 anc_prov1 anc_prov2 anc_prov3 anc_prov4 anc_prov5 anc_prov6 anc_prov7 aware ///
										cond1 cond2 cond3 cond4 cond5 cond_doc consent cord_app_what1 cord_app_what10 cord_app_what11 ///
										cord_app_what12 cord_app_what13 cord_app_what2 cord_app_what3 cord_app_what4 cord_app_what5 ///
										cord_app_what6 cord_app_what7 cord_app_what8 cord_app_what9 del_cost_how1 del_cost_how2 ///
										del_cost_how3 del_cost_how4 del_cost_how5 del_cost_how6 del_cost_how7 del_doc del_fac ///
										del_inc_gifts_which1 del_inc_gifts_which2 del_inc_gifts_which3 del_inc_gifts_which4 ///
										del_inc_gifts_which5 del_inc_gifts_which6 del_nofac_why1 del_nofac_why10 ///
										del_nofac_why11 del_nofac_why2 del_nofac_why3 del_nofac_why4 del_nofac_why5 ///
										del_nofac_why6 del_nofac_why7 del_nofac_why8 del_nofac_why9 del_prov1 del_prov2 ///
										del_prov3 del_prov4 del_prov5 del_prov6 del_prov7 del_prov8 del_prov9 del_start_same ///
										died died_cert died_cert_cause died_prob1 died_prob10 died_prob2 died_prob3 ///
										died_prob4 died_prob5 died_prob6 died_prob7 died_prob8 died_prob9 died_resp_live ///
										home_child home_preg inc_gifts_which1 inc_gifts_which2 inc_gifts_which3 ///
										inc_gifts_which4 inc_gifts_which5 inc_gifts_which6 int_yes knows_amount ///
										misc outreach_child outreach_mat own_risk pnc_prov1 pnc_prov2 pnc_prov3 ///
										pnc_prov4 pnc_prov5 pnc_prov6 pnc_prov7 preg source1 source2 source3 ///
										source4 source5 source6 source7 source8 v_anc_doc v_del_doc visited w_nobl wdeath {
											
					lab val `var' yn
				}
				
			*2.2.2 Labelling yes_no_don't_know labels for following variable values
				
				foreach var of varlist 	abdomen anc arr_prov ask_bleed ask_comp ask_walk bf_pnc bleed bleed_pnc blood bp ///
										bp_pnc breastfeed breasts card_pay care conv cord_app cut del_inc_gifts ///
										del_inc_transp del_inj del_intrav del_tab discharge dried drugs_yes fever_6w ///
										fever_birth fit_6w fit_bef fit_lab fit_preg foods fp heart hemorrhage hiv ///
										hyper inc_food inc_gifts inc_transp infant inj iron lab_yes labor_ind malaria ///
										nutri othcomp pain pnc pnc_mult pp_oth pp_treat pressure prolonged ///
										ref rub signs signs_pnc skin swell transfusion urine vacc visit_pay womb {
					
					lab val `var' yndk
				}
				
			*2.2.3 Labelling likert labels for following variable values
				
				foreach var of varlist 	noneed tba_same hf_notworth {
					lab val `var' likert
				}
				
			*2.2.4 Labelling remaining variable values
					lab val amount cash_oth
					lab val anc_doc_type anc_doc
					lab val caes_why caes_why
					lab val cond_anc cond_anc
					lab val del_doc_type del_doc
					lab val del_how del_how
					lab val del_loc loc
					lab val del_loc_start loc
					lab val del_sat satisf
					lab val del_time del_time
					lab val died_cause died_cause
					lab val died_resp_rel oth_resp_rel
					lab val died_time died_time
					lab val died_time died_time
					lab val h_epds1 laugh
					lab val h_epds10 harm
					lab val h_epds2 enjoy
					lab val h_epds3 blame
					lab val h_epds4 anxious
					lab val h_epds5 scared
					lab val h_epds6 ontop
					lab val h_epds7 often
					lab val h_epds8 often
					lab val h_epds9 unhappy
					lab val h_rating h_rating
					lab val int_whynot int_whynot
					lab val labor labor
					lab val labor_ind_how ind_how
					lab val mis_phys mis_phys
					lab val mis_verb mis_verb
					lab val placenta plac
					lab val pnc_loc loc
					lab val preg_end preg_end
					lab val preg_end_unit w_or_m
					lab val ref_where treat_loc
					lab val v_anc_doc_type anc_doc
					lab val v_anc_tbv tbv
					lab val v_del_doc_type del_doc
					lab val v_del_tbv tbv
					lab val v_met v_met
					lab val v_met_anc v_met
					lab val v_met_del v_met


		*2.3 Labelling variables
		
			lab var abdomen `"PNC POC: Abdomen examined"'
			lab var amenities `"PHC rating: Amenities"'
			lab var amount `"CCT awareness: Amount known"'
			lab var amount_oth `"CCT awareness: Amount known - Other (Specified)"'
			lab var anc `"ANC: Any ANC"'
			lab var anc_date `"ANC: Date of registration"'
			lab var anc_doc `"ANC: Doc available"'
			lab var anc_doc_conf `"ANC: Doc confirms total visits"'
			lab var anc_doc_tot `"ANC: Total visits verified from doc"'
			lab var anc_doc_type `"ANC: Doc type"'
			lab var anc_doc_type_oth `"ANC: Doc type - Other (Specified)"'
			lab var anc_loc1 `"ANC: Location - Home"'
			lab var anc_loc2 `"ANC: Location - Other home"'
			lab var anc_loc3 `"ANC: Location - Tertiary/Teaching Hospital"'
			lab var anc_loc4 `"ANC: Location - Government general hospital"'
			lab var anc_loc5 `"ANC: Location - Study PHC"'
			lab var anc_loc6 `"ANC: Location - Other PHC"'
			lab var anc_loc7 `"ANC: Location - Private hospital/clinic"'
			lab var anc_loc8 `"ANC: Location - Maternity home"'
			lab var anc_loc9 `"ANC: Location - Church/spiritual house"'
			lab var anc_loc10 `"ANC: Location - Other"'
			lab var anc_loc_op `"ANC: Location - Other study PHC"'
			lab var anc_loc_oth `"ANC: Location - Other (Specified)"'
			lab var anc_preg_m `"ANC: Months pregnant at first visit"'
			lab var anc_prov1 `"ANC: Provider - Doctor"'
			lab var anc_prov2 `"ANC: Provider - Nurse/midwife"'
			lab var anc_prov3 `"ANC: Provider - CHO/CHEW"'
			lab var anc_prov4 `"ANC: Provider - Village health worker"'
			lab var anc_prov5 `"ANC: Provider - TBA"'
			lab var anc_prov6 `"ANC: Provider - Other"'
			lab var anc_prov7 `"ANC: Provider - Dont know"'
			lab var anc_prov_oth `"ANC: Provider - Other (Specified)"'
			lab var anc_tot `"ANC: Total visits"'
			lab var anc_tot_ver `"ANC: Total visits verified"'
			lab var arr_prov `"Deliv.: Provider there upon arrival"'
			lab var ask_bleed `"ANC POC: Asked about vaginal bleeding"'
			lab var ask_comp `"Deliv. POC: Offered to have a companion"'
			lab var ask_walk `"Deliv. POC: Offered to walk around"'
			lab var aware `"CCT awareness: Knows of intervention"'
			lab var bath `"Deliv. POC: Hours before first bath"'
			lab var bf_pnc `"PNC POC: Counseled on breastfeeding"'
			lab var bleed `"Complic. - Preg.: Vaginal bleeding"'
			lab var bleed_pnc `"PNC POC: Asked about vaginal bleeding"'
			lab var blood `"ANC POC: Gave blood sample"'
			lab var bp `"ANC POC: BP measured"'
			lab var bp_pnc `"PNC POC: BP measured"'
			lab var breastfeed `"ANC POC: Counseled on breastfeeding"'
			lab var breasts `"PNC POC: Breasts checked"'
			lab var building `"PHC rating: Building"'
			lab var caes_why `"Deliv. POC: Reason for C/S"'
			lab var caes_why_oth `"Deliv. POC: Reason for C/S - Other (Specified)"'
			lab var card_cost `"ANC costs: Total registration cost"'
			lab var card_pay `"ANC costs: Paid for registration"'
			lab var care `"PNC POC: Counseled on infant care"'
			lab var child_tot `"Deliv.: Total babies delivered"'
			lab var cleanliness `"PHC rating: Cleanliness"'
			lab var cond1 `"CCT awareness: Condition known - Attend ANC"'
			lab var cond2 `"CCT awareness: Condition known - Deliver in a health facility"'
			lab var cond3 `"CCT awareness: Condition known - Attend postnatal care"'
			lab var cond4 `"CCT awareness: Condition known - Other"'
			lab var cond5 `"CCT awareness: Condition known - Dont know"'
			lab var cond_anc `"CCT awareness: Known ANC visits req."'
			lab var cond_doc `"CCT awareness: Knows of doc req."'
			lab var cond_oth `"CCT awareness: Condition known - Other (Specified)"'
			lab var consent `"Interv.: Consent"'
			lab var conv `"Complic. - Preg.: Convulsions"'
			lab var cord_app `"Deliv. POC: Any substance applied to cord"'
			lab var cord_app_oth `"Deliv. POC: Any substance applied to cord - Other (Specified)"'
			lab var cord_app_what1 `"Deliv. POC: Substance applied to cord - Chlorhexidine gel"'
			lab var cord_app_what2 `"Deliv. POC: Substance applied to cord - Methylated spirit/alcohol"'
			lab var cord_app_what3 `"Deliv. POC: Substance applied to cord - Dettol"'
			lab var cord_app_what4 `"Deliv. POC: Substance applied to cord - Ash/Native chalk"'
			lab var cord_app_what5 `"Deliv. POC: Substance applied to cord - Cow dung"'
			lab var cord_app_what6 `"Deliv. POC: Substance applied to cord - Herbal preparation"'
			lab var cord_app_what7 `"Deliv. POC: Substance applied to cord - Breast milk"'
			lab var cord_app_what8 `"Deliv. POC: Substance applied to cord - Palm oil"'
			lab var cord_app_what9 `"Deliv. POC: Substance applied to cord - Salt"'
			lab var cord_app_what10 `"Deliv. POC: Substance applied to cord - Vaseline"'
			lab var cord_app_what11 `"Deliv. POC: Substance applied to cord - Toothpaste"'
			lab var cord_app_what12 `"Deliv. POC: Substance applied to cord - Other"'
			lab var cord_app_what13 `"Deliv. POC: Substance applied to cord - Dont know"'
			lab var cut `"Deliv. POC: Episiotomy"'
			lab var date `"Interview Date"'
			lab var del_cost_how1 `"Deliv. costs: Coverage method - Woman's earnings"'
			lab var del_cost_how2 `"Deliv. costs: Coverage method - Husbands earnings"'
			lab var del_cost_how3 `"Deliv. costs: Coverage method - Other HH members earnings"'
			lab var del_cost_how4 `"Deliv. costs: Coverage method - Woman / husbands employer"'
			lab var del_cost_how5 `"Deliv. costs: Coverage method - Sold assets"'
			lab var del_cost_how6 `"Deliv. costs: Coverage method - Loan"'
			lab var del_cost_how7 `"Deliv. costs: Coverage method - Other"'
			lab var del_cost_how_oth `"Deliv. costs: Coverage method - Other (Specified)"'
			lab var del_cost_tot `"Deliv. costs: Total cost"'
			lab var del_cost_transp `"Deliv. costs: Cost of transportation"'
			lab var del_doc `"Deliv.: Doc available"'
			lab var del_doc_type `"Deliv.: Doc type"'
			lab var del_doc_type_oth `"Deliv.: Doc type - Other (Specified)"'
			lab var del_fac `"Deliv.: Location - Facility"'
			lab var del_how `"Deliv. POC: Delivery modality"'
			lab var del_inc_gifts `"Deliv. incent.: Any gift"'
			lab var del_inc_gifts_which1 `"Deliv. incent.: Gift - Baby clothes"'
			lab var del_inc_gifts_which2 `"Deliv. incent.: Gift - Omo/soap/detergent"'
			lab var del_inc_gifts_which3 `"Deliv. incent.: Gift - Food"'
			lab var del_inc_gifts_which4 `"Deliv. incent.: Gift - Mama kit"'
			lab var del_inc_gifts_which5 `"Deliv. incent.: Gift - Mosquito net "'
			lab var del_inc_gifts_which6 `"Deliv. incent.: Gift - Other "'
			lab var del_inc_gifts_which_oth `"Deliv. incent.: Gift - Other (Specified)"'
			lab var del_inc_transp `"Deliv. incent.: Any transportation subsidy"'
			lab var del_inc_transp_tot `"Deliv. incent.: Total transportation subsidy"'
			lab var del_inj `"Deliv. POC: Injection afterwards"'
			lab var del_intrav `"Deliv. POC: IV medication afterwards"'
			lab var del_loc `"Deliv.: Location"'
			lab var del_loc_op `"Deliv.: Location - Other study PHC"'
			lab var del_loc_oth `"Deliv.: Location - Other (Specified)"'
			lab var del_loc_start `"Deliv.: Start location"'
			lab var del_loc_start_op `"Deliv.: Started in other study PHC"'
			lab var del_loc_start_oth `"Deliv.: Start location - Other (Specified)"'
			lab var del_nofac_why1 `"Deliv.: Reason not in a facility - Too expensive"'
			lab var del_nofac_why2 `"Deliv.: Reason not in a facility - Not open "'
			lab var del_nofac_why3 `"Deliv.: Reason not in a facility - Too far/No transportation "'
			lab var del_nofac_why4 `"Deliv.: Reason not in a facility - Dont trust it/Poor quality"'
			lab var del_nofac_why5 `"Deliv.: Reason not in a facility - No female provider"'
			lab var del_nofac_why6 `"Deliv.: Reason not in a facility - Others did not allow "'
			lab var del_nofac_why7 `"Deliv.: Reason not in a facility - Not necessary "'
			lab var del_nofac_why8 `"Deliv.: Reason not in a facility - Not customary "'
			lab var del_nofac_why9 `"Deliv.: Reason not in a facility - No time/Baby came suddenly"'
			lab var del_nofac_why10 `"Deliv.: Reason not in a facility - Because of COVID"'
			lab var del_nofac_why11 `"Deliv.: Reason not in a facility - Other"'
			lab var del_prov1 `"Deliv.: Provider - Doctor"'
			lab var del_prov2 `"Deliv.: Provider - Nurse/midwife"'
			lab var del_prov3 `"Deliv.: Provider - CHO/CHEW"'
			lab var del_prov4 `"Deliv.: Provider - Village health worker"'
			lab var del_prov5 `"Deliv.: Provider - TBA"'
			lab var del_prov6 `"Deliv.: Provider - Relative/friend"'
			lab var del_prov7 `"Deliv.: Provider - No one"'
			lab var del_prov8 `"Deliv.: Provider - Other"'
			lab var del_prov9 `"Deliv.: Provider - Dont know"'
			lab var del_prov_oth `"Deliv.: Provider - Other (Specified)"'
			lab var del_sat `"Deliv. POC: Satisfaction"'
			lab var del_start_same `"Deliv.: Started and ended in same location"'
			lab var del_tab `"Deliv. POC: Tablets afterwards"'
			lab var del_time `"Deliv.: Timing"'
			lab var died `"Deceased: Woman has deceased"'
			lab var died_cause `"Deceased: Primary cause of death"'
			lab var died_cause_oth `"Deceased: Primary cause of death - Other (Specified)"'
			lab var died_cert `"Deceased: Death certificate available"'
			lab var died_cert_cause `"Deceased: Cause is listed on death certificate"'
			lab var died_prob1 `"Deceased: Problems - Severe headache"'
			lab var died_prob2 `"Deceased: Problems - High fever"'
			lab var died_prob3 `"Deceased: Problems - Convulsions (not from fever)"'
			lab var died_prob4 `"Deceased: Problems - Severe vaginal bleeding"'
			lab var died_prob5 `"Deceased: Problems - Hypertension/high blood pressure"'
			lab var died_prob6 `"Deceased: Problems - Lower abdominal pain"'
			lab var died_prob7 `"Deceased: Problems - Foul-smelling vaginal discharge"'
			lab var died_prob8 `"Deceased: Problems - Obstructed labor"'
			lab var died_prob9 `"Deceased: Problems - Other"'
			lab var died_prob10 `"Deceased: Problems - Dont know / remember"'
			lab var died_resp_live `"Deceased: Respondent lived with woman"'
			lab var died_resp_rel `"Deceased: Respondents relationship to woman"'
			lab var died_time `"Deceased: Timing of death"'
			lab var died_time `"Deceased: Timing of death"'
			lab var discharge `"Complic. - Sepsis: Vaginal infection within 6w"'
			lab var dried `"Deliv. POC: Baby dried off"'
			lab var drugs_av `"PHC rating: Availability of drugs"'
			lab var drugs_cost `"ANC costs: Total cost of drugs"'
			lab var drugs_yes `"ANC costs: Given any drugs"'
			lab var end `"Interview end time"'
			lab var equip_av `"PHC rating: Availability of equipment"'
			lab var fever_6w `"Complic. - Sepsis: High fever within 6w"'
			lab var fever_birth `"Complic. - Sepsis: High fever during delivery"'
			lab var fit_6w `"Complic. - Eclampsia: Fit within 6w"'
			lab var fit_bef `"Complic. - Eclampsia: Fit prior to pregnancy"'
			lab var fit_lab `"Complic. - Eclampsia: Fit around delivery"'
			lab var fit_preg `"Complic. - Eclampsia: Fit during pregnancy"'
			lab var foods `"ANC POC: Counseled on nutrition"'
			lab var fp `"PNC POC: Counseled on FP"'
			lab var h_epds1 `"EPDS: I have been able to laugh"'
			lab var h_epds2 `"EPDS: I have looked forward to things"'
			lab var h_epds3 `"EPDS: I have blamed myself unnecessarily"'
			lab var h_epds4 `"EPDS: I have felt anxious or worried"'
			lab var h_epds5 `"EPDS: I have felt scared or panicky"'
			lab var h_epds6 `"EPDS: Things have been getting on top of me"'
			lab var h_epds7 `"EPDS: Unhappines has disrupted my sleep"'
			lab var h_epds8 `"EPDS: I have felt sad or miserable"'
			lab var h_epds9 `"EPDS: I have been crying"'
			lab var h_epds10 `"EPDS: I have thought of self-harm"'
			lab var h_rating `"Health rating"'
			lab var heart `"ANC POC: Fetal heartbeat auscultated"'
			lab var hemorrhage `"Complic. - Hemorrhage"'
			lab var hf_notworth `"Agrees: HF delivery not worth the money"'
			lab var hfac `"Clinic Identifier"'
			lab var hiv `"ANC POC: HIV counseling & testing"'
			lab var home_child `"PHC outreach: Home visits for child health"'
			lab var home_preg `"PHC outreach: Home visits for pregnancy/delivery"'
			lab var hw_av `"PHC rating: Availability of health workers"'
			lab var hw_comp `"PHC rating: Competence of health workers"'
			lab var hw_treat `"PHC rating: Attitude of health workers"'
			lab var hyper `"Complic. - Preg.: Hypertension"'
			lab var inc_food `"ANC incent.: Received free food"'
			lab var inc_gifts `"ANC incent.: Received any gifts"'
			lab var inc_gifts_which1 `"ANC incent.: Gift received - Baby clothes"'
			lab var inc_gifts_which2 `"ANC incent.: Gift received - Omo/soap/detergent"'
			lab var inc_gifts_which3 `"ANC incent.: Gift received - Food"'
			lab var inc_gifts_which4 `"ANC incent.: Gift received - Mama kit"'
			lab var inc_gifts_which5 `"ANC incent.: Gift received - Mosquito net "'
			lab var inc_gifts_which6 `"ANC incent.: Gift received - Other "'
			lab var inc_gifts_which_oth `"ANC incent.: Gift received - Other (Specified)"'
			lab var inc_transp `"ANC incent.: Any transportation subsidy"'
			lab var inc_transp_tot `"ANC incent.: Total transporation subsidy"'
			lab var infant `"PNC POC: Infant physical exam"'
			lab var inj `"Preg. behav.: Tetanus injection"'
			lab var int_whynot `"Follow-up: Reason for no data collection"'
			lab var int_yes `"Follow-up: Data collected"'
			lab var iron `"Preg. behav.: Iron tablets / syrup"'
			lab var knows_amount `"CCT awareness: Knows amount"'
			lab var lab_cost `"ANC costs: Total cost of lab tests"'
			lab var lab_yes `"ANC costs: Took any lab tests"'
			lab var labor `"Deliv. POC: Type of labor"'
			lab var labor_ind `"Deliv. POC: Labor was induced"'
			lab var labor_ind_how `"Deliv. POC: Method for inducing labor"'
			lab var labor_ind_how_oth `"Deliv. POC: Method for inducing labor - Other (Specified)"'
			lab var malaria `"Preg. behav.: Anti-malarial drugs"'
			lab var mis_phys `"Deliv. POC: Physically mistreated"'
			lab var mis_verb `"Deliv. POC: Verbally mistreated"'
			lab var misc `"Miscarried"'
			lab var nights `"Deliv.: Total nights spent at location"'
			lab var noneed `"Agrees: Strong women need not deliver in a HF"'
			lab var nutri `"PNC POC: Counseled on nutrition"'
			lab var othcomp `"Complic. - Delivery: Any other"'
			lab var outreach_child `"PHC outreach: Community visits for child health"'
			lab var outreach_mat `"PHC outreach: Community visits for pregnancy/delivery"'
			lab var own_comp_high `"Beliefs - Own risk: Complications - Upper bound"'
			lab var own_comp_low `"Beliefs - Own risk: Complications - Lower bound"'
			lab var own_risk `"Beliefs - Own risk: Thinks she has any risk factors"'
			lab var own_still_high `"Beliefs - Own risk: Stillbirth - Upper bound"'
			lab var own_still_low `"Beliefs - Own risk: Stillbirth - Lower bound"'
			lab var pain `"Deliv. POC: Given pain meds"'
			lab var placenta `"Deliv. POC: Attendant helped deliver the placenta"'
			lab var pnc `"PNC: Any PNC"'
			lab var pnc_days1 `"PNC: Days since delivery at first visit"'
			lab var pnc_days2 `"PNC: Days since delivery at second visit"'
			lab var pnc_loc `"PNC: Location"'
			lab var pnc_loc_op `"PNC: Location - Other study PHC"'
			lab var pnc_loc_oth `"PNC: Location - Other (Specified)"'
			lab var pnc_mult `"PNC: Additional visits after first"'
			lab var pnc_prov1 `"PNC: Provider - Doctor"'
			lab var pnc_prov2 `"PNC: Provider - Nurse/midwife"'
			lab var pnc_prov3 `"PNC: Provider - CHO/CHEW"'
			lab var pnc_prov4 `"PNC: Provider - Village health worker"'
			lab var pnc_prov5 `"PNC: Provider - TBA"'
			lab var pnc_prov6 `"PNC: Provider - Other"'
			lab var pnc_prov7 `"PNC: Provider - Dont know"'
			lab var pnc_prov_oth `"PNC: Provider - Other (Specified)"'
			lab var pnc_tot `"PNC: Total visits"'
			lab var pp_oth `"Complic. - Preg.: Any other"'
			lab var pp_treat `"Complic. - Preg.: Sought care"'
			lab var preg `"Preg.: Currently pregnant"'
			lab var preg_end `"Preg.: Outcome"'
			lab var preg_end_date `"Preg. end: Date"'
			lab var preg_end_m `"Preg. end: Gestational age - Months"'
			lab var preg_end_unit `"Preg. end: Gestational age - Unit"'
			lab var preg_end_w `"Preg. end: Gestational age - Weeks"'
			lab var pressure `"Deliv. POC: Fundal pressure"'
			lab var prolonged `"Complic. - Prolonged labor"'
			lab var ref `"Complic. - Delivery: Treatment referral"'
			lab var ref_where `"Complic. - Delivery: Place of referral"'
			lab var ref_where_op `"Complic. - Delivery: Referral to other study PHC"'
			lab var ref_where_oth `"Complic. - Delivery: Place of referral - Other (Specified)"'
			lab var rub `"Deliv. POC: Attendant massaged abdomen"'
			lab var serv_av `"PHC rating: Availability of services"'
			lab var serv_cost `"PHC rating: Affordability"'
			lab var signs `"ANC POC: Counseled on pregnancy danger signs"'
			lab var signs_pnc `"PNC POC: Counseling on newborn danger"'
			lab var skin `"Deliv. POC: Skin-to-skin"'
			lab var source1 `"CCT awareness: Source of info - HPRG staff"'
			lab var source2 `"CCT awareness: Source of info - Village announcer/Town crier"'
			lab var source3 `"CCT awareness: Source of info - Husband"'
			lab var source4 `"CCT awareness: Source of info - Other household member"'
			lab var source5 `"CCT awareness: Source of info - Friend/neighbour"'
			lab var source6 `"CCT awareness: Source of info - Community gathering"'
			lab var source7 `"CCT awareness: Source of info - Health worker"'
			lab var source8 `"CCT awareness: Source of info - Other"'
			lab var source_oth `"CCT awareness: Source of info - Other (Specified)"'
			lab var start `"Interview start time"'
			lab var swell `"Complic. - Preg.: Swelling"'
			lab var tba_same `"Agrees: TBAs provide same care as HWs"'
			lab var transfusion `"Complic. - Hemorrhage: Required transfusion"'
			lab var transp_cost `"ANC costs: Cost of transportaton per visit"'
			lab var urine `"ANC POC: Gave urine sample"'
			lab var v_anc_doc `"CCT verification: ANC doc available"'
			lab var v_anc_doc_tot `"CCT verification: ANC visits from doc"'
			lab var v_anc_doc_type `"CCT verification: ANC doc type"'
			lab var v_anc_doc_type_oth `"CCT verification: ANC doc type - Other (Specified)"'
			lab var v_anc_req `"CCT verification: Minimum ANC visits required"'
			lab var v_anc_tbv `"CCT verification: ANC requirement TBV later"'
			lab var v_del_doc `"CCT verification: Delivery doc available"'
			lab var v_del_doc_type `"CCT verification: Delivery doc type"'
			lab var v_del_doc_type_oth `"CCT verification: Delivery doc type - Other (Specified)"'
			lab var v_del_tbv `"CCT verification: Delivery requirement TBV later"'
			lab var v_met `"CCT verification: Eligible"'
			lab var v_met_anc `"CCT verification: Complied with ANC requirement"'
			lab var v_met_del `"CCT verification: Complied with delivery requirement"'
			lab var vacc `"PNC POC: Counseled on vaccinations"'
			lab var visit_cost `"ANC costs: Cost per visit"'
			lab var visit_pay `"ANC costs: Paid for visits"'
			lab var visited `"PHC utilization: Used PHC since last visit"'
			lab var w_nobl `"Baseline missing (collected at endline)"'
			lab var wdeath `"Died during pregnancy"'
			lab var wid `"Woman ID"'
			lab var womb `"Complic. - Hemorrhage: Placenta manually removed"'

		*2.4 Sort data
		
			sort wid hfac
			
			
		*2.5 Standardizing Variables
			
			*2.5.1 Standardizing ANC provider 
				
				local var anc_prov
				
				foreach string in "TBA" "Tradtional birth attendant" {
					replace `var'5=1 if `var'_oth=="`string'"
					replace `var'6=0 if `var'_oth=="`string'"
					replace `var'_oth="" if `var'_oth=="`string'"
				}

			*2.5.2 Standardizing place of ANC service
				
				local var anc_loc
				
				foreach string in "Church" "Pastor's wife" "Pastors wife" {
					replace `var'9=1 if `var'_oth=="`string'"
					replace `var'10=0 if `var'_oth=="`string'"
					replace `var'_oth="" if `var'_oth=="`string'"
				}
				
				foreach string in "Traditional" "TBA" {
					replace `var'2=1 if regexm(`var'_oth,"`string'")
					replace `var'10=0 if regexm(`var'_oth,"`string'")
					replace `var'_oth="" if regexm(`var'_oth,"`string'")
				}


			*2.5.3 Standardizing place of delivery

				local var del_loc

				foreach string in "Traditional" "TBA" "Parent's house" {
					replace `var'=2 if regexm(`var'_oth,"`string'")
					replace del_fac=0 if regexm(`var'_oth,"`string'")
					replace `var'_oth="" if regexm(`var'_oth,"`string'")
				}

				foreach string in "Maternity" "Medical Center" {
					replace `var'=6 if regexm(`var'_oth,"`string'")
					replace del_fac=1 if regexm(`var'_oth,"`string'")
					replace `var'_oth="" if regexm(`var'_oth,"`string'")
				}


			*2.5.4 Standardizing delivery attendant

				local var del_prov

				foreach string in "Nurse" {
					replace `var'2=1 if `var'_oth=="`string'"
					replace `var'8=0 if `var'_oth=="`string'"
					replace `var'_oth="" if `var'_oth=="`string'"
				}

				foreach string in "TBA" {
					replace `var'5=1 if `var'_oth=="`string'"
					replace `var'8=0 if `var'_oth=="`string'"
					replace `var'_oth="" if `var'_oth=="`string'"
				}

				foreach string in "Nobody" {
					replace `var'7=1 if `var'_oth=="`string'"
					replace `var'8=0 if `var'_oth=="`string'"
					replace `var'_oth="" if `var'_oth=="`string'"
				}

			*2.5.5 Standardizing PNC provider 

				local var pnc_prov

				foreach string in "Traditional" {
					replace `var'5=1 if regexm(`var'_oth,"`string'")
					replace `var'6=0 if regexm(`var'_oth,"`string'")
					replace `var'_oth="" if regexm(`var'_oth,"`string'")
				}


			*2.5.6 Standardizing place of referral

				local var ref_where

				foreach string in "Traditional" "Harbel" "Herbal" {
					replace `var'_oth="Traditional healer" if regexm(`var'_oth,"`string'")
				}

			*2.5.7 Standardizing ANC documentation

				local var anc_doc_type_oth

				foreach string in "ANC Notebook" "Anc Booklet" "Anc Notebook" "Anc notebook" "Ancient notebook" "Book" "Booklet" "Excercise book" "Exercisa book" "Exercise" "Exercise  book" "Exercise  book  used for  Anc" "Exercise book" "Exercise book used for Anc" {
					replace `var'="ANC notebook" if `var'=="`string'"
				}

				replace `var'="Facility book" if regexm(`var',"Facility")
				replace `var'="Hand card" if regexm(`var',"Hand")
				replace `var'="Hospital card" if regexm(`var',"Hospital")
				replace `var'="Maternity book" if regexm(`var',"Maternity")
				replace `var'="PNC card" if regexm(`var',"Post natal Card")
				replace `var'="NPHCDA card" if regexm(`var',"National Primary")

				foreach string in "Tetanus" "TT" {
					replace `var'="TT card" if regexm(`var',"`string'")
				}

			*2.5.8 Standardizing delivery documentation

				local var del_doc_type_oth

				replace `var'="ANC/delivery notebook" if regexm(`var',"ANC") | regexm(`var',"Anc")
				replace `var'="ANC/delivery notebook" if regexm(`var',"Exercise") | regexm(`var',"Excercise")
				replace `var'="Facility notebook" if regexm(`var',"Facility") 
				replace `var'="Hand card" if regexm(`var',"Hand") | regexm(`var',"HAND")
				replace `var'="Maternity book" if regexm(`var',"Maternity") 
				replace `var'="Partograph form" if regexm(`var',"Photog") 
				replace `var'="Temporary card" if regexm(`var',"Temporary") 
				replace `var'="Caesarean section" if regexm(`var',"Caesaren section") 
				replace `var'="Hospital card" if regexm(`var',"Hospital") | regexm(`var',"HOSPITAL")
				replace `var'="Clinic receipt" if regexm(`var',"Receipt clinic") 

				foreach string in "Book" "Booklet" "Notebook" "Record  Booklet" "Exercise" {
					replace `var'="Facility notebook" if `var'=="`string'"
				}

			*2.5.9 Standardizing ANC incentives

				local var inc_gifts_which_oth

				replace `var'="Pad" if `var'=="Pads"
				replace `var'="Diapers" if `var'=="Baby pampers"
				replace `var'="Diapers" if `var'=="Pampas"
				replace `var'="Bag and cloth" if `var'=="Bag an cloth"
				replace `var'="Bag and pad" if `var'=="Bag and pat"
				replace `var'="Diapers and pad" if `var'=="Diapers,Pad"
				replace `var'="Cord clamp" if `var'=="Cord clap"
				replace `var'="Maggi cube" if regexm(`var',"Maggi") 
				replace `var'="Soft drink" if regexm(`var',"Carbonated soft drink") 
				replace `var'="Drugs" if `var'=="Medicine" | `var'=="Iron tablets"
				replace `var'=regexr(`var',"Pamper","Diaper")
				replace `var'=regexr(`var',"pamper","diaper")
				replace `var'=regexr(`var'," ,",",")

				foreach string in "Biscuit" "Biscuits" "Biscuits  and drink" "Biscuits  and drinks" "Biscuits and drinks" "Biscuits,  drinks" "Biscuits, drink," "Biscuits, drinks" "Boil egg" "Drinks,  Biscuits" {
					replace inc_gifts_which3=1 if `var'=="`string'"
					replace inc_gifts_which6=0 if `var'=="`string'"
					replace `var'="" if `var'=="`string'"
				}

				foreach string in "Shirt ,cap,shocks" {
					replace inc_gifts_which1=1 if `var'=="`string'"
					replace inc_gifts_which6=0 if `var'=="`string'"
					replace `var'="" if `var'=="`string'"
				}

			*2.5.10 Standardizing delivery incentives

				local var del_inc_gifts_which_oth

				foreach string in "Baby pampers" "Pampas" "Baby Diapers" "Baby's pampers" "Diaper" "One pack of Diapers" {
					replace `var'="Diapers" if `var'=="`string'"
				}

				foreach string in "Bathing robber" "Bathing Basin" "Bathing Bath" "Bathing Rubber" "Bathing Ruber" "Bathing bath" "Bathing bowl" "Bathing robber" "Bathing rubber" "washing basine" {
					replace `var'=regexr(`var',"`string'","Baby bath")
				}

				foreach string in "Babybath" "Baby Bath" "Bath" "Bathing washing besin" "A set of babybath" "Bathing basin" {
					replace `var'="Baby bath" if `var'=="`string'"
				}
				foreach string in "Rapa" "Rapper" "one yard of wrapper" {
					replace `var'=regexr(`var',"`string'","Wrapper")
				}

				foreach string in "2 yard of wrapper" "Wrapper 2 yard" "rapa" "Wrap" "Wrapper 6Yard" "Wrappers" {
					replace `var'="Wrapper" if `var'=="`string'"
				}
				foreach string in "Cap,shirt,shocks" "Shirt and socks" {
					replace del_inc_gifts_which1=1 if `var'=="`string'"
					replace del_inc_gifts_which6=0 if `var'=="`string'"
					replace `var'="" if `var'=="`string'"
				}

				foreach string in "Soap" {
					replace del_inc_gifts_which2=1 if `var'=="`string'"
					replace del_inc_gifts_which6=0 if `var'=="`string'"
					replace `var'="" if `var'=="`string'"
				}

				replace `var'="Pad" if `var'=="Pads"
				replace `var'="Maggi cube" if regexm(`var',"Maggi") 
				replace `var'="Baby carrier" if `var'=="Baby Carria" | `var'=="Baby Carrier"
				replace `var'="Drugs" if `var'=="Medicine" 
				replace `var'="Cotton wool" if `var'=="Cotton wood"
				replace `var'="Money" if `var'=="2000" | `var'=="Cash"
				replace `var'="Tissue" if `var'=="Tissues"
				replace `var'="Pad" if `var'=="Sanitary pad" | `var'=="Sanitary part"

				replace `var'=regexr(`var',"Pamper","Diaper")
				replace `var'=regexr(`var',"pamper","diaper")
				replace `var'=regexr(`var',"pampa","diaper")
				replace `var'=regexr(`var',"  and"," and")
				replace `var'=regexr(`var'," ,",",")
				replace `var'=regexr(`var'," , ",", ")

			*2.5.11 Standardizing reason for caesarean

				local var caes_why_oth

				foreach string in "BP was" "blood pressure was" {
					replace `var'="High blood pressure" if regexm(`var',"`string'")
				}

				foreach string in "all my children are CS" "caesarean" {
					replace `var'="Previous caesarean" if regexm(`var',"`string'")
				}

				foreach string in "The Baby was too fat" "The baby was very big" "Baby was too large" {
					replace `var'="The baby was too big" if regexm(`var',"`string'")
				}

				replace `var'="Pre-eclampsia" if regexm(`var',"Pre eclampsia") 
				replace `var'="No heartbeat" if regexm(`var',"Baby 's Heartbeat was not heard") 

			*2.5.12 Standardizing method for inducing labor

				local var labor_ind_how_oth

				replace `var'=lower(`var')

				foreach string in "given herbs" "harbal" "given  herbs" "herbal" "local" "native" "traditional" "insertion of herbs" {
					replace `var'="Herbal remedy" if regexm(`var',"`string'")
				}

				foreach string in "herbs was given" "here's" "here's" "herps" "herps given" "herbs" "herb" "i was given herbs" {
					replace `var'="Herbal remedy" if `var'=="`string'"
				}

				replace `var'="herbs and prayers" if `var'=="herbs  and prayers"
				replace `var'="lipton tea" if `var'=="lipton"
				replace `var'="prayers" if `var'=="prayer"
				replace `var'="holy water" if `var'=="holy watrr" | `var'=="only water"
				replace `var'="tablet" if `var'=="tab"
				replace `var'="castor oil" if `var'=="warm castor oil"

			*2.5.13 Standardizing cord application

				local var cord_app

				replace `var'_oth=lower(`var'_oth)
				foreach string in "toothpaste" "toothspaste" "close up" "closeup" "close up tooth past" "closeup and vaseline" "maclean" {
					replace `var'_what11=1 if `var'_oth=="`string'"
					replace `var'_what12=0 if `var'_oth=="`string'"
					replace `var'_oth="" if `var'_oth=="`string'"
				}

				foreach string in "vaseline" {
					replace `var'_what10=1 if `var'_oth=="`string'"
					replace `var'_what12=0 if `var'_oth=="`string'"
					replace `var'_oth="" if `var'_oth=="`string'"
				}

				foreach string in "traditional leaf" "traditional medicine" "herbal preparation" "herbs" {
					replace `var'_what6=1 if `var'_oth=="`string'"
					replace `var'_what12=0 if `var'_oth=="`string'"
					replace `var'_oth="" if `var'_oth=="`string'"
				}

				foreach string in "spirit" {
					replace `var'_what2=1 if `var'_oth=="`string'"
					replace `var'_what12=0 if `var'_oth=="`string'"
					replace `var'_oth="" if `var'_oth=="`string'"
				}

				foreach string in "palm kernel oil" {
					replace `var'_what8=1 if `var'_oth=="`string'"
					replace `var'_what12=0 if `var'_oth=="`string'"
					replace `var'_oth="" if `var'_oth=="`string'"
				}

				foreach string in "engin oil" "ingine oil" {
					replace `var'_oth="engine oil" if `var'_oth=="`string'"
				}

				foreach string in "oilve oil" "olive  oil" {
					replace `var'_oth="olive oil" if `var'_oth=="`string'"
				}

				foreach string in "rob" "robb" "rub" "rubb" {
					replace `var'_oth="Robb ointment" if `var'_oth=="`string'"
				}

				foreach string in "dusting  powder" "dustin powder" "dusting power" "dustingpowder" {
					replace `var'_oth=regexr(`var'_oth,"`string'","dusting powder")
				}

				replace `var'_oth="apply heat" if `var'_oth=="apply hit"
				replace `var'_oth="hot metal" if `var'_oth=="hot metal procedure"
				replace `var'_oth="saliva" if `var'_oth=="spit" | `var'_oth=="saliver" | `var'_oth=="morning saliva"
				replace `var'_oth="shea butter" if `var'_oth=="shearbutter"
				replace `var'_oth="saliva and sand" if `var'_oth=="sand and saliva"

			*2.5.14 Standardizing payer of delivery cost

				local var del_cost_how_oth

				foreach string in "No payment" "No payment" "Nothing" "Not paid" "No paid" "No one" "No cost" "not pay" "didn't pay" "0" {
					replace `var'="No payment" if  regexm(`var',"`string'")
				}

				foreach string in "MY MOTHER" "Her mother" "My mother" "mother paid" {
					replace `var'="Mother" if regexm(`var',"`string'")
				}

				foreach string in "her father" "Her mother" "My mother" "mother paid" {
					replace `var'="Father" if regexm(`var',"`string'")
				}

				replace `var'="Church member" if regexm(`var',"Church member")
				replace `var'="Sisters" if regexm(`var',"sisters")
				replace `var'="Both families" if regexm(`var',"Both family")
				replace `var'="Still paying" if regexm(`var',"haven't finish")
				replace `var'="Brother" if regexm(`var',"brother")
				replace `var'="Relative" if regexm(`var',"Reletive")
				replace `var'="Aunty" if  regexm(`var',"Aunty")
				replace `var'="Husband's family" if  regexm(`var',"Contribution from Husband")
				replace `var'="Parents" if  regexm(`var',"Parent")
				replace `var'="Father-in-law" if regexm(`var',"Father inlaw")
				replace `var'="Mother-in-law" if regexm(`var',"Mother inlaw")

			*2.5.15 Standardizing source of info about CCT

				local var source_oth

				replace `var'="Neighbouring community" if regexm(`var',"Nourboring community")
				
							
			*2.5.16 Standardizing method for inducing labor
			
				local var labor_ind_how_oth
				replace `var'=lower(`var')
				foreach string in "given herbs" "harbal" "given  herbs" "herbal" "local" "native" "traditional" "insertion of herbs" {
					replace `var'="Herbal remedy" if regexm(`var',"`string'")
				}
			
			*Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }
			
		*2.6 Ordering variables
			order 	w_nobl hfac date wid start int_yes int_whynot died ///
					died_resp_rel died_resp_live died_time died_cert died_cert_cause ///
					died_cause died_cause_oth died_prob1 died_prob2 died_prob3 ///
					died_prob4 died_prob5 died_prob6 died_prob7 died_prob8 ///
					died_prob9 died_prob10 consent preg preg_end misc wdeath ///
					preg_end_unit preg_end_w preg_end_m preg_end_date anc ///
					anc_prov1 anc_prov2 anc_prov3 anc_prov4 anc_prov5 ///
					anc_prov6 anc_prov_oth anc_prov7 anc_loc1 anc_loc2 anc_loc3 ///
					anc_loc4 anc_loc5 anc_loc6 anc_loc_op anc_loc7 anc_loc8 ///
					anc_loc9 anc_loc10 anc_loc_oth anc_preg_m anc_tot anc_tot_ver ///
					anc_doc anc_doc_type anc_doc_type_oth anc_doc_conf anc_doc_tot ///
					anc_date card_pay card_cost visit_pay visit_cost lab_yes ///
					lab_cost drugs_yes drugs_cost transp_cost inc_transp ///
					inc_transp_tot inc_gifts inc_gifts_which1 inc_gifts_which2 ///
					inc_gifts_which3 inc_gifts_which4 inc_gifts_which5 inc_gifts_which6 ///
					inc_gifts_which_oth inc_food bp urine blood ask_bleed heart ///
					foods breastfeed signs hiv inj iron malaria swell conv hyper ///
					bleed pp_oth pp_treat del_time del_loc del_loc_op del_loc_oth ///
					del_doc del_doc_type del_doc_type_oth del_fac del_nofac_why1 ///
					del_nofac_why10 del_nofac_why11 del_nofac_why2 del_nofac_why3 ///
					del_nofac_why4 del_nofac_why5 del_nofac_why6 del_nofac_why7 ///
					del_nofac_why8 del_nofac_why9 del_start_same del_loc_start ///
					del_loc_start_op del_loc_start_oth arr_prov del_prov1 ///
					del_prov2 del_prov3 del_prov4 del_prov5 del_prov6 del_prov7 ///
					del_prov9 del_prov8 del_prov_oth del_how caes_why caes_why_oth ///
					labor labor_ind labor_ind_how labor_ind_how_oth pain ask_comp ///
					ask_walk cut pressure del_inj del_tab del_intrav placenta rub ///
					dried skin bath cord_app cord_app_what1 cord_app_what10 cord_app_what11 ///
					cord_app_what2 cord_app_what3 cord_app_what4 cord_app_what5 cord_app_what6 ///
					cord_app_what7 cord_app_what8 cord_app_what9 cord_app_what12 cord_app_oth ///
					cord_app_what13 mis_phys mis_verb del_sat nights prolonged hemorrhage ///
					transfusion womb fever_birth discharge fever_6w fit_preg fit_bef fit_lab ///
					fit_6w othcomp ref ref_where ref_where_op ref_where_oth del_cost_tot ///
					del_cost_transp del_cost_how1 del_cost_how2 del_cost_how3 del_cost_how4 ///
					del_cost_how5 del_cost_how6 del_cost_how7 del_cost_how_oth del_inc_transp ///
					del_inc_transp_tot del_inc_gifts del_inc_gifts_which1 del_inc_gifts_which2 ///
					del_inc_gifts_which3 del_inc_gifts_which4 del_inc_gifts_which5 ///
					del_inc_gifts_which6 del_inc_gifts_which_oth child_tot pnc pnc_days1 ///
					pnc_loc pnc_loc_op pnc_loc_oth pnc_prov1 pnc_prov2 pnc_prov3 pnc_prov4 ///
					pnc_prov5 pnc_prov6 pnc_prov7 pnc_prov_oth abdomen breasts bleed_pnc ///
					bp_pnc infant signs_pnc bf_pnc fp nutri care vacc pnc_mult pnc_days2 ///
					pnc_tot h_rating h_epds1 h_epds2 h_epds3 h_epds4 h_epds5 h_epds6 h_epds7 ///
					h_epds8 h_epds9 h_epds10 own_risk own_still_low own_still_high ///
					own_comp_low own_comp_high noneed tba_same hf_notworth aware ///
					source1 source2 source3 source4 source5 source6 source7 source8 ///
					source_oth knows_amount amount_oth amount cond1 cond2 cond3 ///
					cond5 cond4 cond_oth cond_anc cond_doc visited serv_av hw_av ///
					hw_comp hw_treat drugs_av equip_av serv_cost cleanliness ///
					building amenities home_preg home_child outreach_mat ///
					outreach_child v_anc_doc v_anc_doc_type v_anc_doc_tot ///
					v_anc_tbv v_anc_req v_del_doc v_del_doc_type v_del_tbv ///
					v_met_anc v_met_del v_met v_anc_doc_type_oth ///
					v_del_doc_type_oth end
			
	*Saving dataset
		save "${outputs}/woman_el", replace
	
	
	
	*3. Cleaning up child module
	**********************************
	
	*Opening file
		use "${inputs}/woman_el_child", clear
	
		*3.1 Defining value labels
			
			lab def baby_look 		1 `"Looked like a normal baby"'  2 `"Skin/body had changed"' 99 `"Don't know / remember"'
			
			lab def bf_first 		0 `"Never breastfed"'  1 `"Within 1 hr of birth"' 2 `"1-5 hr"' 3 `"6-24 hr"' 4 `">24 hr"' 99 `"Don't know"'
			
			lab def body_part 		1 `"Head"'  2 `"Buttock"' 3 `"Hand/foot"' 4 `"Cord"' 99 `"Don't know / remember"'
			
			lab def cough_source 	1 `"Chest"'  2 `"Nose"' 99 `"Don't know / remember"'
			
			lab def meas 			0 `"No, refused"' 1 `"Yes"'
			
			lab def size 			1 `"Very large"'  2 `"Larger than average"' 3 `"Average"' 4 `"Smaller than average"' 5 `"Very small"' 99 `"Don't know"'
			
			lab def visit_reason 	1 `"Illness"'  2 `"Injury"' 3 `"Routine preventive visit"' 4 `"Immunization"' ///
									5 `"Circumcision"' 6 `"Dental care"' 88 `"Other"'
									
			lab def yesnoav 		0 `"No"'  1 `"Yes (available)"'  2 `"Yes (but not available)"'
			
			lab def yn 				0 `"No"' 1 `"Yes"' 
			
			lab def yndk 			0 `"No"' 1 `"Yes"' 99 `"Don't know"'

				
				
		*3.2 Labelling variable values
				
			*3.2.1 Labelling yes/no for following variable values 
			
				foreach var of varlist 	c_alive cert_dob cert_weight cough cough_breathe cough_care cough_care_loc1 ///
										cough_care_loc2 cough_care_loc3 cough_care_loc4 cough_care_loc5 ///
										cough_care_loc6 cough_care_loc7 cough_care_loc8 cough_care_loc9 ///
										death_1mth death_eneo diar diar_blood diar_care diar_care_loc1 ///
										diar_care_loc2 diar_care_loc3 diar_care_loc4 diar_care_loc5 ///
										diar_care_loc6 diar_care_loc7 diar_care_loc8 diar_care_loc9 ///
										diar_homedrink diar_ors fac_oth fac_oth_loc1 fac_oth_loc2 ///
										fac_oth_loc3 fac_oth_loc4 fac_oth_loc5 fac_oth_loc6 fac_oth_loc7 ///
										fac_oth_loc8 fac_oth_loc9 fev fev_care fev_care_loc1 ///
										fev_care_loc2 fev_care_loc3 fev_care_loc4 fev_care_loc5 ///
										fev_care_loc6 fev_care_loc7 fev_care_loc8 fev_care_loc9 ///
										nutri_bf_now nutri_oth_type1 nutri_oth_type10 nutri_oth_type11 ///
										nutri_oth_type2 nutri_oth_type3 nutri_oth_type4 nutri_oth_type5 ///
										nutri_oth_type6 nutri_oth_type7 nutri_oth_type8 nutri_oth_type9 ///
										vacc_bcg vacc_card vacc_hepb vacc_ipv vacc_measles vacc_opv ///
										vacc_pcv vacc_penta vacc_rota vacc_vita vaccfever weighed		 {
					
					lab val `var' yn
				}
				
				
			*3.2.2 Labelling remaining variable values
				 
				lab val breathe yndk
				lab val c_male yndk
				lab val cert yesnoav
				lab val cough_source cough_source
				lab val cry yndk
				lab val del_alive yndk
				lab val del_part body_part
				lab val del_size size
				lab val diff_breath yndk
				lab val fac_oth_why visit_reason
				lab val meas meas
				lab val move yndk
				lab val nutri_bf_first bf_first
				lab val nutri_oth yndk
				lab val still_bruise yndk
				lab val still_look baby_look
				lab val still_move yndk


		*3.3 Labelling variables
				 		
				lab var breathe `"Deliv.: Ever breathed"'
				lab var bw `"Live birth: Weight at birth (kg)"'
				lab var c_alive `"Child: Currently alive"'
				lab var c_male `"Male"'
				lab var cert `"Live birth: Certificate is available"'
				lab var cert_dob `"Live birth: Certificate lists DOB"'
				lab var cert_weight `"Live birth: Certificate lists weight"'
				lab var cough `"Cough: Any (2 weeks)"'
				lab var cough_breathe `"Cough: Fast or difficult breathing"'
				lab var cough_care `"Cough: Sought care"'
				lab var cough_care_loc1 `"Cough: Care location - Tertiary/Teaching Hospital"'
				lab var cough_care_loc2 `"Cough: Care location - Government general hospital"'
				lab var cough_care_loc3 `"Cough: Care location - Study PHC"'
				lab var cough_care_loc4 `"Cough: Care location - Other PHC"'
				lab var cough_care_loc5 `"Cough: Care location - Private hospital/clinic"'
				lab var cough_care_loc6 `"Cough: Care location - Maternity home"'
				lab var cough_care_loc7 `"Cough: Care location - Traditional birth attendant"'
				lab var cough_care_loc8 `"Cough: Care location - Chemist/Drug store"'
				lab var cough_care_loc9 `"Cough: Care location - Other"'
				lab var cough_care_loc_op `"Cough: Care location - Nearby study PHC"'
				lab var cough_care_loc_oth `"Cough: Care location - Other (Specified)"'
				lab var cough_source `"Cough: Source of fast or difficult breathing"'
				lab var cry `"Deliv.: Ever cried"'
				lab var date `"Interview Date"'
				lab var death_1mth `"Death: Before turning 1 mth"'
				lab var death_age_d `"Death: Age at death (days)"'
				lab var del_alive `"Deliv.: Born alive (reported)"'
				lab var del_part `"Deliv.: Part that came first"'
				lab var del_size `"Deliv.: Size at birth"'
				lab var del_tod `"Deliv.: Time of delivery"'
				lab var diar `"Diarrhoea: Any (2 weeks)"'
				lab var diar_blood `"Diarrhoea: Blood in stool"'
				lab var diar_care `"Diarrhoea: Sought care"'
				lab var diar_care_loc1 `"Diarrhoea: Care location - Tertiary/Teaching Hospital"'
				lab var diar_care_loc2 `"Diarrhoea: Care location - Government general hospital"'
				lab var diar_care_loc3 `"Diarrhoea: Care location - Study PHC"'
				lab var diar_care_loc4 `"Diarrhoea: Care location - Other PHC"'
				lab var diar_care_loc5 `"Diarrhoea: Care location - Private hospital/clinic"'
				lab var diar_care_loc6 `"Diarrhoea: Care location - Maternity home"'
				lab var diar_care_loc7 `"Diarrhoea: Care location - Traditional birth attendant"'
				lab var diar_care_loc8 `"Diarrhoea: Care location - Chemist/Drug store"'
				lab var diar_care_loc9 `"Diarrhoea: Care location - Other"'
				lab var diar_care_loc_op `"Diarrhoea: Care location - Nearby study PHC"'
				lab var diar_care_loc_oth `"Diarrhoea: Care location - Other (Specified)"'
				lab var diar_homedrink `"Diarrhoea: Given home-made drink"'
				lab var diar_ors `"Diarrhoea: Given ORS"'
				lab var diff_breath `"Live birth: Difficulty breathing"'
				lab var fac_oth `"Other visits: Any other facility visits (1mth)"'
				lab var fac_oth_loc1 `"Other visits: Care location - Tertiary/Teaching Hospital"'
				lab var fac_oth_loc2 `"Other visits: Care location - Government general hospital"'
				lab var fac_oth_loc3 `"Other visits: Care location - Study PHC"'
				lab var fac_oth_loc4 `"Other visits: Care location - Other PHC"'
				lab var fac_oth_loc5 `"Other visits: Care location - Private hospital/clinic"'
				lab var fac_oth_loc6 `"Other visits: Care location - Maternity home"'
				lab var fac_oth_loc7 `"Other visits: Care location - Traditional birth attendant"'
				lab var fac_oth_loc8 `"Other visits: Care location - Chemist/Drug store"'
				lab var fac_oth_loc9 `"Other visits: Care location - Other"'
				lab var fac_oth_loc_op `"Other visits: Care location - Nearby study PHC"'
				lab var fac_oth_loc_oth `"Other visits: Care location - Other (Specified)"'
				lab var fac_oth_why `"Other visits: Reason for facility visit"'
				lab var fac_oth_why_oth `"Other visits: Reason for facility visit - Other (Specified)"'
				lab var fev `"Fever: Any (2 weeks)"'
				lab var fev_care `"Fever: Sought care"'
				lab var fev_care_loc1 `"Fever: Care location - Tertiary/Teaching Hospital"'
				lab var fev_care_loc2 `"Fever: Care location - Government general hospital"'
				lab var fev_care_loc3 `"Fever: Care location - Study PHC"'
				lab var fev_care_loc4 `"Fever: Care location - Other PHC"'
				lab var fev_care_loc5 `"Fever: Care location - Private hospital/clinic"'
				lab var fev_care_loc6 `"Fever: Care location - Maternity home"'
				lab var fev_care_loc7 `"Fever: Care location - Traditional birth attendant"'
				lab var fev_care_loc8 `"Fever: Care location - Chemist/Drug store"'
				lab var fev_care_loc9 `"Fever: Care location - Other"'
				lab var fev_care_loc_op `"Fever: Care location - Nearby study PHC"'
				lab var fev_care_loc_oth `"Fever: Care location - Other (Specified)"'
				lab var hfac `"Clinic Identifier"'
				lab var death_eneo `"Death: Early neonatal (<= 6 days)"'
				lab var meas `"Meas.: Collected"'
				lab var meas_length `"Meas.: Length (cm)"'
				lab var meas_weight `"Meas.: Weight (kg)"'
				lab var move `"Deliv.: Ever moved"'
				lab var nutri_bf_first `"Nutrition: Timing of first breastfeeding"'
				lab var nutri_bf_now `"Nutrition: Still being breastfed"'
				lab var nutri_oth `"Nutrition: Any other drinks (3 days of birth)"'
				lab var nutri_oth_type1 `"Nutrition: Other drink - Milk (other than breastmilk)"'
				lab var nutri_oth_type2 `"Nutrition: Other drink - Infant formula"'
				lab var nutri_oth_type3 `"Nutrition: Other drink - Plain water"'
				lab var nutri_oth_type4 `"Nutrition: Other drink - Sugar or glucose water"'
				lab var nutri_oth_type5 `"Nutrition: Other drink - Sugar-salt-water solution"'
				lab var nutri_oth_type6 `"Nutrition: Other drink - Fruit juice"'
				lab var nutri_oth_type7 `"Nutrition: Other drink - Tea/coffee"'
				lab var nutri_oth_type8 `"Nutrition: Other drink - Honey"'
				lab var nutri_oth_type9 `"Nutrition: Other drink - Herbal preparation"'
				lab var nutri_oth_type10 `"Nutrition: Other drink - Other"'
				lab var nutri_oth_type11 `"Nutrition: Other drink - Dont know"'
				lab var preg_end_date `"Preg. end: Date"'
				lab var still_bruise `"Stillbirth: Bruises or signs of injury"'
				lab var still_look `"Stillbirth: Look at birth"'
				lab var still_move `"Stillbirth: Moving at start of labor"'
				lab var vacc_bcg `"Vacc.: BCG"'
				lab var vacc_card `"Vacc.: Card available"'
				lab var vacc_hepb `"Vacc.: Hepatitis B"'
				lab var vacc_ipv `"Vacc.: IPV"'
				lab var vacc_measles `"Vacc.: Measles"'
				lab var vacc_opv `"Vacc.: OPV"'
				lab var vacc_opv_tot `"Vacc.: OPV - Total doses"'
				lab var vacc_pcv `"Vacc.: PCV"'
				lab var vacc_pcv_tot `"Vacc.: PCV - Total doses"'
				lab var vacc_penta `"Vacc.: Penta"'
				lab var vacc_penta_tot `"Vacc.: Penta - Total doses"'
				lab var vacc_rota `"Vacc.: Rota"'
				lab var vacc_rota_tot `"Vacc.: Rota - Total doses"'
				lab var vacc_vita `"Vacc.: Vitamin A"'
				lab var vaccfever `"Vacc.: Yellow fever"'
				lab var weighed `"Live birth: Weighed at birth"'
				lab var wid `"Woman ID"'
				
	
		*3.4 Sort data
			sort wid hfac
			
		*3.5 Standardizing Variables
			
			*3.5.1 Standardizing visit reason
			
				local var fac_oth_why
				
				foreach string in "Ear problem" "Ear" "Eye problem" "Rashes" "Stomach egg" {
					replace `var'=1 if `var'_oth=="`string'"
					replace `var'_oth="" if `var'_oth=="`string'"
				}
				
			
			*Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }
			 
	*Ordering variables
		order 	hfac date wid preg_end_date del_tod del_alive cry move ///
				breathe still_move still_bruise still_look diff_breath del_part ///
				del_size c_male cert cert_dob cert_weight weighed bw c_alive ///
				death_1mth death_eneo death_age_d nutri_bf_first nutri_oth ///
				nutri_oth_type1 nutri_oth_type2 nutri_oth_type3 nutri_oth_type4 ///
				nutri_oth_type5 nutri_oth_type6 nutri_oth_type7 nutri_oth_type8 ///
				nutri_oth_type9 nutri_oth_type10 nutri_oth_type11 nutri_bf_now ///
				diar diar_blood diar_care diar_care_loc1 diar_care_loc2 ///
				diar_care_loc3 diar_care_loc4 diar_care_loc_op diar_care_loc5 ///
				diar_care_loc6 diar_care_loc7 diar_care_loc8 diar_care_loc9 ///
				diar_care_loc_oth diar_ors diar_homedrink fev fev_care ///
				fev_care_loc1 fev_care_loc2 fev_care_loc3 fev_care_loc4 ///
				fev_care_loc_op fev_care_loc5 fev_care_loc6 fev_care_loc7 ///
				fev_care_loc8 fev_care_loc9 fev_care_loc_oth cough cough_breathe ///
				cough_source cough_care cough_care_loc1 cough_care_loc2 ///
				cough_care_loc3 cough_care_loc4 cough_care_loc_op ///
				cough_care_loc5 cough_care_loc6 cough_care_loc7 cough_care_loc8 ///
				cough_care_loc9 cough_care_loc_oth fac_oth fac_oth_loc1 ///
				fac_oth_loc2 fac_oth_loc3 fac_oth_loc4 fac_oth_loc_op ///
				fac_oth_loc5 fac_oth_loc6 fac_oth_loc7 fac_oth_loc8 fac_oth_loc9 ///
				fac_oth_loc_oth fac_oth_why fac_oth_why_oth vacc_card vacc_bcg ///
				vacc_opv vacc_opv_tot vacc_penta vacc_penta_tot vacc_pcv ///
				vacc_pcv_tot vacc_ipv vacc_hepb vacc_measles vaccfever ///
				vacc_vita vacc_rota vacc_rota_tot meas ///
				meas_weight meas_length

			
	*Saving dataset
		save "${outputs}/woman_el_child", replace	

	
	*4. Cleaning up other child module
	*************************************
	
	*Opening file
		use "${inputs}/woman_el_othchild", clear
	
		
		*4.1 Defining value labels
	
			lab def cough_source 	1 `"Chest"'  2 `"Nose"'  99 `"Don't know / remember"'
			
			lab def meas 0 `"No, refused"' 1 `"Yes"'
			
			lab def othch_resp 		0 "Mother/stepmother" 1 `"Father"'  2 `"Brother"' 3 `"Sister"' 4 `"Auntie"' 5 `"Uncle"' 6 `"Grandfather"' 7 `"Grandmother"' 88 `"Other"'
			
			lab def sid 			1 `"AKWA IBOM"' 2 `"GOMBE"' 3 `"JIGAWA"' 4 `"KANO"'
			
			lab def visit_reason 	1 `"Illness"'  2 `"Injury"' 3 `"Routine preventive visit"' 4 `"Immunization"' ///
									5 `"Circumcision"' 6 `"Dental care"' 88 `"Other"'

			lab def yn 				0 `"No"' 1 `"Yes"'

			lab def yndk 			0 `"No"'  1 `"Yes"'  99 `"Don't know"'

			
			
				
		*4.2 Labelling variable values
				
			*4.2.1 Labelling yes/no for following variable values 
			
				foreach var of varlist 	c_alive cough cough_breathe cough_care cough_care_loc1 cough_care_loc2 ///
										cough_care_loc3 cough_care_loc4 cough_care_loc5 cough_care_loc6 ///
										cough_care_loc7 cough_care_loc8 cough_care_loc9 death_1mth death_2yr ///
										diar diar_blood diar_care diar_care_loc1 diar_care_loc2 diar_care_loc3 ///
										diar_care_loc4 diar_care_loc5 diar_care_loc6 diar_care_loc7 diar_care_loc8 ///
										diar_care_loc9 fac_oth fac_oth_loc1 fac_oth_loc2 fac_oth_loc3 fac_oth_loc4 ///
										fac_oth_loc5 fac_oth_loc6 fac_oth_loc7 fac_oth_loc8 fac_oth_loc9 fev ///
										fev_care fev_care_loc1 fev_care_loc2 fev_care_loc3 fev_care_loc4 ///
										fev_care_loc5 fev_care_loc6 fev_care_loc7 fev_care_loc8 fev_care_loc9 ///
										mother_imp resp_mother vacc_bcg vacc_card vacc_hepb vacc_ipv ///
										vacc_measles vacc_opv vacc_pcv vacc_penta vacc_rota vacc_vita vaccfever {
					
					lab val `var' yn
				}

				
				
			*4.2.2 Labelling remaining variable values
				lab val c_male yndk
				lab val cough_source cough_source
				lab val fac_oth_why visit_reason
				lab val meas meas
				lab val resp_rel othch_resp
				lab val sid sid
					

		*4.3 Labelling variables
		
				lab var c_alive `"Child: Currently alive"'
				lab var c_dob `"Date of birth"'
				lab var c_male `"Male"'
				lab var cough `"Cough: Any (2 weeks)"'
				lab var cough_breathe `"Cough: Fast or difficult breathing"'
				lab var cough_care `"Cough: Sought care"'
				lab var cough_care_loc1 `"Cough: Care location - Tertiary/Teaching Hospital"'
				lab var cough_care_loc2 `"Cough: Care location - Government general hospital"'
				lab var cough_care_loc3 `"Cough: Care location - Study PHC"'
				lab var cough_care_loc4 `"Cough: Care location - Other PHC"'
				lab var cough_care_loc5 `"Cough: Care location - Private hospital/clinic"'
				lab var cough_care_loc6 `"Cough: Care location - Maternity home"'
				lab var cough_care_loc7 `"Cough: Care location - Traditional birth attendant"'
				lab var cough_care_loc8 `"Cough: Care location - Chemist/Drug store"'
				lab var cough_care_loc9 `"Cough: Care location - Other"'
				lab var cough_care_loc_op `"Cough: Care location - Nearby study PHC"'
				lab var cough_care_loc_oth `"Cough: Care location - Other (Specified)"'
				lab var cough_source `"Cough: Source of fast or difficult breathing"'
				lab var date `"Interv.: Date"'
				lab var death_1mth `"Death: Before turning 1 mth"'
				lab var death_2yr `"Death: Before turning 2 yrs"'
				lab var death_age_day `"Death: Age at death (days)"'
				lab var death_age_month `"Death: Age at death (months)"'
				lab var death_age_year `"Death: Age at death (years)"'
				lab var diar `"Diarrhoea: Any (2 weeks)"'
				lab var diar_blood `"Diarrhoea: Blood in stool"'
				lab var diar_care `"Diarrhoea: Sought care"'
				lab var diar_care_loc1 `"Diarrhoea: Care location - Tertiary/Teaching Hospital"'
				lab var diar_care_loc2 `"Diarrhoea: Care location - Government general hospital"'
				lab var diar_care_loc3 `"Diarrhoea: Care location - Study PHC"'
				lab var diar_care_loc4 `"Diarrhoea: Care location - Other PHC"'
				lab var diar_care_loc5 `"Diarrhoea: Care location - Private hospital/clinic"'
				lab var diar_care_loc6 `"Diarrhoea: Care location - Maternity home"'
				lab var diar_care_loc7 `"Diarrhoea: Care location - Traditional birth attendant"'
				lab var diar_care_loc8 `"Diarrhoea: Care location - Chemist/Drug store"'
				lab var diar_care_loc9 `"Diarrhoea: Care location - Other"'
				lab var diar_care_loc_op `"Diarrhoea: Care location - Nearby study PHC"'
				lab var diar_care_loc_oth `"Diarrhoea: Care location - Other (Specified)"'
				lab var fac_oth `"Other visits: Any other facility visits (1mth)"'
				lab var fac_oth_loc1 `"Other visits: Care location - Tertiary/Teaching Hospital"'
				lab var fac_oth_loc2 `"Other visits: Care location - Government general hospital"'
				lab var fac_oth_loc3 `"Other visits: Care location - Study PHC"'
				lab var fac_oth_loc4 `"Other visits: Care location - Other PHC"'
				lab var fac_oth_loc5 `"Other visits: Care location - Private hospital/clinic"'
				lab var fac_oth_loc6 `"Other visits: Care location - Maternity home"'
				lab var fac_oth_loc7 `"Other visits: Care location - Traditional birth attendant"'
				lab var fac_oth_loc8 `"Other visits: Care location - Chemist/Drug store"'
				lab var fac_oth_loc9 `"Other visits: Care location - Other"'
				lab var fac_oth_loc_op `"Other visits: Care location - Nearby study PHC"'
				lab var fac_oth_loc_oth `"Other visits: Care location - Other (Specified)"'
				lab var fac_oth_why `"Other visits: Reason for facility visit"'
				lab var fac_oth_why_oth `"Other visits: Reason for facility visit - Other (Specified)"'
				lab var fev `"Fever: Any (2 weeks)"'
				lab var fev_care `"Fever: Sought care"'
				lab var fev_care_loc1 `"Fever: Care location - Tertiary/Teaching Hospital"'
				lab var fev_care_loc2 `"Fever: Care location - Government general hospital"'
				lab var fev_care_loc3 `"Fever: Care location - Study PHC"'
				lab var fev_care_loc4 `"Fever: Care location - Other PHC"'
				lab var fev_care_loc5 `"Fever: Care location - Private hospital/clinic"'
				lab var fev_care_loc6 `"Fever: Care location - Maternity home"'
				lab var fev_care_loc7 `"Fever: Care location - Traditional birth attendant"'
				lab var fev_care_loc8 `"Fever: Care location - Chemist/Drug store"'
				lab var fev_care_loc9 `"Fever: Care location - Other"'
				lab var fev_care_loc_op `"Fever: Care location - Nearby study PHC"'
				lab var fev_care_loc_oth `"Fever: Care location - Other (Specified)"'
				lab var hfac `"Clinic Identifier"'
				lab var meas `"Meas.: Collected"'
				lab var meas_length `"Meas.: Length (cm)"'
				lab var meas_weight `"Meas.: Weight (kg)"'
				lab var mother_imp `"Mother is study participant"'
				lab var resp_mother `"Respond.: Mother of child"'
				lab var resp_rel `"Relationship to the child"'
				lab var resp_rel_oth `"Other relationship (specified)"'
				lab var sid `"State"'
				lab var vacc_bcg `"Vacc.: BCG"'
				lab var vacc_card `"Vacc.: Card available"'
				lab var vacc_hepb `"Vacc.: Hepatitis B"'
				lab var vacc_ipv `"Vacc.: IPV"'
				lab var vacc_measles `"Vacc.: Measles"'
				lab var vacc_opv `"Vacc.: OPV"'
				lab var vacc_opv_tot `"Vacc.: OPV - Total doses"'
				lab var vacc_pcv `"Vacc.: PCV"'
				lab var vacc_pcv_tot `"Vacc.: PCV - Total doses"'
				lab var vacc_penta `"Vacc.: Penta"'
				lab var vacc_penta_tot `"Vacc.: Penta - Total doses"'
				lab var vacc_rota `"Vacc.: Rota"'
				lab var vacc_rota_tot `"Vacc.: Rota - Total doses"'
				lab var vacc_vita `"Vacc.: Vitamin A"'
				lab var vaccfever `"Vacc.: Yellow fever"'
				lab var wid `"Woman ID"'
				

		*4.4 Sort data
			sort wid hfac sid
		
		*4.5 Standardizing Variables
												

			*4.5.1 Recoding/correcting variable values
					
					local var resp_rel_oth

					foreach string in "Mother" "mother" "MOTHER" "monther" "Stepmothet" "mum" {
							replace resp_rel=0 if regexm(`var',"`string'")
							replace `var'="" if regexm(`var',"`string'")
					}

					replace resp_rel=. if mother_imp==1	// we already know mother is the respondent
					replace resp_rel=0 if resp_mother==1

			*4.5.2 Standardizing care location

					local var diar_care_loc

					foreach string in "TRADITIONAL" "Traditional" "Herb" {
						replace `var'_oth="Herbal remedy" if regexm(`var'_oth,"`string'")
					}

					local var fev_care_loc

					foreach string in "TRADITIONAL" "Traditional" "Herb" "herb" {
						replace `var'_oth="Herbal remedy" if regexm(`var'_oth,"`string'")

						}

					local var cough_care_loc
					foreach string in "TRADITIONAL" "Traditional" "Herb" "herb" {
						replace `var'_oth="Herbal remedy" if regexm(`var'_oth,"`string'")
					}

			*4.5.3 Standardizing visit reason

					local var fac_oth_why

					foreach string in "Boils all over the body" "EYE  PROBLEM" "Cough" "Stomach egg" {
						replace `var'=1 if `var'_oth=="`string'"
						replace `var'_oth="" if `var'_oth=="`string'"
					}

					foreach string in "Burning" {
						replace `var'=2 if `var'_oth=="`string'"
						replace `var'_oth="" if `var'_oth=="`string'"
					}
					
		*5. Converting date values from string to date format
		
				gen c_dob_ = date(c_dob, "MY")
					local c_dob_label: variable label c_dob
					drop c_dob
					rename c_dob_ c_dob
					format %td c_dob
				lab var c_dob "`c_dob_label'"
					
			*Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }
			 
	*Ordering variables
		order 	sid hfac wid date mother_imp resp_mother resp_rel resp_rel_oth ///
		c_alive death_1mth death_age_day death_2yr death_age_month ///
		death_age_year c_dob c_male diar diar_care diar_blood ///
		diar_care_loc1 diar_care_loc2 diar_care_loc3 diar_care_loc4 ///
		diar_care_loc_op diar_care_loc5 diar_care_loc6 diar_care_loc7 ///
		diar_care_loc8 diar_care_loc9 diar_care_loc_oth fev fev_care ///
		fev_care_loc1 fev_care_loc2 fev_care_loc3 fev_care_loc4 fev_care_loc_op ///
		fev_care_loc5 fev_care_loc6 fev_care_loc7 fev_care_loc8 fev_care_loc9 ///
		fev_care_loc_oth cough cough_breathe cough_source cough_care ///
		cough_care_loc1 cough_care_loc2 cough_care_loc3 cough_care_loc4 ///
		cough_care_loc_op cough_care_loc5 cough_care_loc6 cough_care_loc7 ///
		cough_care_loc8 cough_care_loc9 cough_care_loc_oth fac_oth fac_oth_loc1 ///
		fac_oth_loc2 fac_oth_loc3 fac_oth_loc4 fac_oth_loc_op fac_oth_loc5 ///
		fac_oth_loc6 fac_oth_loc7 fac_oth_loc8 fac_oth_loc9 fac_oth_loc_oth ///
		fac_oth_why fac_oth_why_oth vacc_card vacc_bcg vacc_opv vacc_opv_tot ///
		vacc_penta vacc_penta_tot vacc_pcv vacc_pcv_tot vacc_ipv vacc_hepb ///
		vacc_measles vaccfever vacc_vita vacc_rota vacc_rota_tot meas ///
		meas_weight meas_length
								
	*Saving dataset
	save "${outputs}/woman_el_othchild", replace
