/*==================================================================================
** This file cleans the post-intervention evaluation survey files 
====================================================================================*/

clear

set seed  11111

gl inputs "${raw}"
gl outputs "${clean}"


*1. Cleaning up main file
****************************

	*Opening file
		use "${inputs}/feedback", clear
		
		
		*1.1 Defining value labels
		
			lab def change 	0 `"None"'   1 `"Improved infrastucture"'   2 `"Improved availability of equipment"'   ///
							3 `"Improved availability of drugs"'   4 `"Motivated health workers"'   ///
							5 `"Led to more community outreach"'   6 `"Led to changes in PHC opening/closing times"'  ///
							7 `"Led to additional services being offered"'   ///
							8 `"Led to a stronger focus on maternal and child health"'  88 `"Other"'
			
			lab def clinic 	0 `"Control"'  1 `"Encouragement"' 2 `"Grant"' 
			
			lab def likert 	1	`"Strongly disagree"'  2	`"Disagree"' 3	`"Neutral"' 4	`"Agree"' 5	`"Strongly agree"'

			lab def sid 	1 `"AKWA IBOM"'  2 `"GOMBE"' 3 `"JIGAWA"' 4 `"KANO"'

			lab def yn 		0 `"No"'  1 `"Yes"'

			lab def yndk 	0 `"No"'  1 `"Yes"' 99 `"Dont know"'				
				
		*1.2 Labelling variable values
		
				
			*1.2.1 Labelling yes/no variable values
				foreach var of varlist 	consent consult imp_cash know_imp ///
										ment_imp other plan ///
										prog_any rec_cash {
					lab val `var' yn
				}
			
			*1.2.2 Labelling yes/no/don't know variable values
				foreach var of varlist drugs equip inc_pat inc_staff maint {
					lab val `var' yndk
				}
			
			*1.2.3 Labelling likert scale variables
				foreach var of varlist 	acc drugs_av equip_av focus infra knew_funds ///
									know_not motiv outreach proc_fair purch_transp ///
									see_not serv_add service_time {
				lab val `var' likert
				}
			
			*1.2.4 Labelling other variable values
				lab val sid sid
				lab val clinic clinic
				lab val most_imp change		
				
		*1.3 Labelling variables

			lab var acc `"Agrees: There was accountability in spending"'
			lab var change `"One suggested change to the design or implementation"'
			lab var clinic `"Health center treatment"'
			lab var consent `"Interv.: Consent"'
			lab var consult `"HW consulted in AP development"'
			lab var date `"Visit Date"'
			lab var drugs `"Purchase of drugs"'
			lab var drugs_av `"Agrees: Improved drugs availability"'
			lab var end `"Interview end time"'
			lab var equip `"Purchase of equipment"'
			lab var equip_av `"Agrees: Improved equipment availability"'
			lab var focus `"Agrees: Led to a stronger focus on MCH"'
			lab var hfac `"Clinic Identifier"'
			lab var hwid `"Healthworker ID"'
			lab var imp_cash `"Any cash provided to the PHC through IMPACTT"'
			lab var imp_cash_tot `"Total grant received"'
			lab var inc_pat `"Patient incentives"'
			lab var inc_staff `"Staff incentives"'
			lab var infra `"Agrees: Improved infrastucture"'
			lab var key `"Facility-Wave Identifier"'
			lab var knew_funds `"Agrees: Knew whenever the PHC received funds"'
			lab var know_imp `"Mentioned IMPACTT after probing"'
			lab var know_not `"Agrees: Does not know how the money was spent"'
			lab var maint `"Maintenance / renovation"'
			lab var ment_imp `"Mentioned IMPACTT"'
			lab var most_imp `"Most important change"'
			lab var most_imp88 `"Most important change - Other (Specified)"'
			lab var motiv `"Agrees: Motivated health workers"'
			lab var other `"Led to other changes not yet mentioned"'
			lab var other88 `"Other change (Specified)"'
			lab var outreach `" Agrees: Led to more community outreach"'
			lab var outreach `"Agrees: Led to more community outreach"'
			lab var plan `"Written AP developed"'
			lab var proc_fair `"Agrees: Process for determining spending was fair"'
			lab var prog_any `"Knows of any programs the PHC is taking part in"'
			lab var prog_tot `"Number of programs the PHC is taking part in"'
			lab var progress `"Progress in implementation of actions (%)"'
			lab var purch_transp `"Agrees: Process for purchases was transparent"'
			lab var rec_cash `"Personally received money through the program"'
			lab var rec_cash_tot `"Total personally received through the program"'
			lab var see_not `"Agrees: Cannot see where the money went"'
			lab var serv_add `"Agrees: Led to additional services"'
			lab var service_time `"Agrees: Led to changes in service times"'
			lab var sid `"State"'
			lab var start `"Interview start time"'
					
		*1.4 Sort data
			sort hwid key hfac sid
			
		*Trimming all string variables (if any)
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }	
		
		*1.5 Ordering variables
			order 	key hfac clinic sid date hwid consent start prog_any ///
					prog_tot ment_imp know_imp plan consult progress imp_cash ///
					imp_cash_tot inc_pat inc_staff drugs equip maint rec_cash ///
					rec_cash_tot proc_fair knew_funds purch_transp acc know_not ///
					see_not infra equip_av_rating drugs_av_rating motiv ///
					outreach service_time serv_add focus other other88 ///
					most_imp most_imp88 change end
			
	*Saving file
		save "${outputs}/feedback", replace

		
*2. Cleaning up program details module
****************************************

	*Opening file
		use "${inputs}/feedback_program", clear
		
		*2.1 Defining value labels
				
				lab def clinic 0 `"Control"'  1 `"Encouragement"' 2 `"Grant"' 
				
				lab def sid 1 `"AKWA IBOM"'  2 `"GOMBE"' 3 `"JIGAWA"'  4 `"KANO"'
				
				lab def yn 0 `"No"' 1 `"Yes"'
				
				
		*2.2 Labelling variable values
				
				*2.2.1 Labelling yes/no for following variable values 
					
					foreach var of varlist 	prog_end_yes prog_rec prog_rec1 ///
											prog_rec2 prog_rec3 prog_rec4 ///
											prog_rec5 prog_rec6 prog_rec88 {
						lab val `var' yn
					}
					
				*2.2.2 Labelling remaining variable values
				
					lab val clinic clinic
					lab val sid sid		
 
		*2.3 Labelling variables
				lab var clinic `"Health center treatment"'
				lab var hfac `"Clinic Identifier"'
				lab var key `"Facility-Wave Identifier"'
				lab var prog_end `"Program end date: year"'
				lab var prog_end_yes `"Program has an end date"'
				lab var prog_name `"Program name"'
				lab var prog_rec `"PHC received any resources through the program"'
				lab var prog_rec1 `"Program provided: money"'
				lab var prog_rec2 `"Program provided: equipment"'
				lab var prog_rec3 `"Program provided: drugs"'
				lab var prog_rec4 `"Program provided: staff"'
				lab var prog_rec5 `"Program provided: consumables"'
				lab var prog_rec6 `"Program provided: building renovation"'
				lab var prog_rec88 `"Program provided: other (Specified)"'
				lab var prog_rec_oth `"Other resources provided by the program (Specified)"'
				lab var prog_sponsor `"Program sponsor"'
				lab var prog_start `"Program start date: year"'
				lab var sid `"State"'

		*2.4 Sort data
			sort key hfac sid
			
		*Trimming all string variables (if any)
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }	
			 
		*2.5 Ordering variables
		order 	key hfac clinic sid prog_name prog_sponsor prog_start ///
				prog_end_yes prog_end prog_rec prog_rec1 prog_rec2 prog_rec3 ///
				prog_rec4 prog_rec5 prog_rec6 prog_rec88 prog_rec_oth 
	
	*Saving file
		save "${outputs}/feedback_program", replace
