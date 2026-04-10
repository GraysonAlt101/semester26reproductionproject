/*==================================================================================
** This file cleans rollout meeting and meeting follow-up files
====================================================================================*/
clear

set seed  11111

gl inputs "${raw}"
gl outputs "${clean}"

*1. Cleaning up meeting file
****************************

	*Opening file 
		use "${inputs}/meeting", clear				
	
	*1.1 Defining value labels
			
		lab def sid 1 `"AKWA IBOM"' 2 `"GOMBE"'  3 `"JIGAWA"'  4 `"KANO"'
	
	*1.2 Labelling variable values
		lab val sid sid
	
	*1.3 Labelling variables
	
		lab var date `"Meeting Date"'
		lab var hfac `"Clinic Identifier"'
		lab var meet_end `"Meeting end time"'
		lab var meet_start `"Meeting start time"'
		lab var sid `"State"'
		lab var tot_att `"Number of attendees in meeting"'
		lab var newdate `"Meeting date (days from reference date)"'

	*1.4 Calculating meeting duration
		gen meet_duration = minutes(meet_end - meet_start)
		lab var meet_duration "Meeting duration (in minutes)"
		
	*1.5 Converting date format
			gen date_ = date(date, "MY")
				local date_label: variable label date
				drop date
				rename date_ date
				format %td date
			lab var date "`date_label'"
	
	*1.6 Ordering variables
		order hfac sid date meet_end meet_start meet_duration tot_att newdate

			
	*Saving file
	save "${outputs}/meeting", replace
	

*2.  Cleaning up meeting notes text file  
******************************************

*Opening file
	use "${inputs}/meeting_notes", clear	
	
	*2.1 Defining value labels
	
		lab def coder 	1 `"Coder 1"' 2 `"Coder 2"' 
		
		lab def domain 	1 `"Utilization"' 2 `"Outcomes"' 
		
		lab def outcome 1 `"Infant death"' 2 `"Insufficient ANC"' 3 `"Non-facility birth"' 4 `"Poor delivery outcome"' 5 `"Poor newborn outcome"'			
		
		lab def type 	1 `"Reason"' 2 `"Solution"'					
									
	*2.2 Labelling variable labels
		 
		lab val coder coder
		lab val domain domain
		lab val outcome outcome
		lab val type type		
		 
	*2.3 Labelling variables
			
		lab var code1 `"code1"'
		lab var code2 `"code2"'
		lab var coder `"coder"'
		lab var domain `"doman"'
		lab var excerpt `"excerpt"'
		lab var hfac `"Clinic Identifier"'
		lab var outcome `"outcome"'
		lab var type `"type"'
			
	*2.4 Ordering variables
		order 	hfac coder code1 type code2 domain outcome excerpt 

				
	*Saving the dataset
		save "${outputs}/meeting_notes", replace
	

*3. Cleaning up follow-up dataset
*************************************

	*Opening file 
		use "${inputs}/meeting_followup", clear		
	
	*3.1 Defining value labels
			
		lab def ap_status 	1 `"Complete"'  2 `"Incomplete"'  3 `"None "'
		
		lab def sid 		1 `"AKWA IBOM"' 2 `"GOMBE"'  3 `"JIGAWA"'  4 `"KANO"'
		
		lab def yn 			0 `"No"' 1 `"Yes"'	
										 
	*3.2 Labelling variable values
			 
		*2.2.1 Labelling yes/no for following variable values 
			
			foreach var in 	 ap_cont1 ap_cont2 ap_cont3 ap_cont4 ///
							ap_disp ap_disp_pat ap_meet_yes ///
							ap_today open open_arr power {
								
				lab val `var' yn				
				
			}
		
		*3.2.2 Labelling remaining variable values
			lab val ap_status ap_status
			lab val sid sid

	*3.3 Labelling variables			
			
			lab var ap_cont1 `"AP contributor - OIC"'
			lab var ap_cont2 `"AP contributor - PHC Workers"'
			lab var ap_cont3 `"AP contributor - Community Members"'
			lab var ap_cont4 `"AP contributor - Other (Specified)"'
			lab var ap_cont_oth `"AP contributor - Other (Specified)"'
			lab var ap_cont_tot `"Total participants in AP development"'
			lab var ap_disp `"AP is displayed visibly"'
			lab var ap_disp_pat `"AP is visible to patients"'
			lab var ap_meet_tot `"Total AP development meetings (if any)"'
			lab var ap_meet_yes `"Held any AP development meetings"'
			lab var ap_status `"AP status"'
			lab var ap_today `"Incomplete AP can be finished today"'
			lab var date `"Visit Date"'
			lab var end `"Interview end time"'
			lab var hfac `"Clinic Identifier"'
			lab var key `"Facility-Wave Identifier"'
			lab var open `"Facility was Open"'
			lab var open_arr `"Open at arrival"'
			lab var power `"There is power"'
			lab var sid `"State"'
			lab var start `"Interview start time"'
	
	*3.4 Merging facility-specific information from facility files [from informational datasets in Data_Files/1_clean]
		
			merge m:1 hfac using "${outputs}/facility.dta", keep(3) nogen keepus(clinic sid)
			order sid clinic, after(hfac)
			
	*3.5 Sort data
			sort key hfac sid
		
	
	*Trimming all string variables (if any)
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }
			 
	 *3.6 Ordering variables
		 order 	key hfac clinic sid date start open open_arr ///
				power ap_status ap_today ap_disp ap_disp_pat ap_cont1 ///
				ap_cont2 ap_cont3 ap_cont4 ap_cont_oth ap_meet_yes ///
				ap_meet_tot ap_cont_tot end
			
	*Saving file
		save "${outputs}/meeting_followup", replace


*4. Cleaning up meeting follow-up staff module
*****************************************************
	
	*Opening file
		use "${inputs}/meeting_followup_hw", clear
	
	
	*4.1 Defining value labels
	
		lab def left_why 	1 `"Voluntary transfer"' 2 `"Compulsory transfer"' 3 `"Resigned"' ///
							4 `"Was terminated"' 5 `"Employment contract ended"' 6 `"Retired"' 7 `"Died"' 88 `"Other"'

		lab def yn 			0 `"No"' 1 `"Yes"'
		
									
	*4.2 Labelling variable labels
		 
			
		*4.2.1 Labelling yes/no for following variable values 
		
			foreach var in recog dup active present duty  {
				
				lab val `var' yn
			}
		
		*4.2.2 Labelling remaining variable values
			lab val left_why left_why
		
		 
	*4.3 Labelling variables
			
		lab var active `"Active"'
		lab var dup `"Duplicate"'
		lab var duty `"On duty"'
		lab var hwid `"Healthworker ID"'
		lab var key `"Facility-Wave Identifier"'
		lab var left_why `"Reason for leaving"'
		lab var present `"Present on day of visit"'
		lab var recog `"Name is recognized"'				

	
	*4.4 Merging data from Meeting followup dataset
	
		merge m:1 key using "${outputs}/meeting_followup", keepus(hfac sid clinic date open)
			//Ensuring correct merging 
				*Ensuring that any data that did not match was because the clinic was not open
				assert open==0 if _merge==2 
			//Keeping only the matched data
				drop if inlist(_merge,1,2) 
				drop _merge open
			order hfac sid clinic date, first
	
	*4.5 Sort data
			sort hfac sid
			
	*Trimming all string variables (if any)
		 foreach var of varlist _all {
			capture confirm string variable `var'
				
			//Trimming if variable type is string
			
			if !_rc {
					replace `var' = trim(itrim(`var'))
					}
		 }	
			 
	*4.6 Ordering variables
		order 	key hfac hwid clinic sid date recog dup ///
				active left_why present duty
			
	*Saving the dataset
		save "${outputs}/meeting_followup_hw", replace
	
	
*5. Cleaning up meeting follow-up action plan module 
******************************************************
	
	*Opening file
		use "${inputs}/meeting_followup_action", clear
	
	
	*5.1 Defining value labels
	
		lab def yn 0 `"No"' 1 `"Yes"'			
			
									
	*5.2 Labelling variable labels
		 
			
		*4.2.1 Labelling yes/no for following variable values 
		
			foreach var of varlist cost_yes problem1-problem6 {
				
				lab val `var' yn
			}
			
		 
	*5.3 Labelling variables
		
		lab var action `"Description of action"'
		lab var cost_tot `"Total cost (Naira)"'
		lab var cost_yes `"Cost was estimated"'
		lab var key `"Facility-Wave Identifier"'
		lab var problem1 `"Problem addressed: ANC"'
		lab var problem2 `"Problem addressed: Facility deliveries"'
		lab var problem3 `"Problem addressed: Maternal health"'
		lab var problem4 `"Problem addressed: Newborn health"'
		lab var problem5 `"Problem addressed: Infant death"'
		lab var problem6 `"Problem addressed: Other (Specified)"'
		lab var problem88 `"Problem addressed - Other (Specified)"'
	
	*5.4  Merging data from Meeting followup dataset
	
		merge m:1 key using "${outputs}/meeting_followup", keepus(hfac sid date) keep(3) nogen
			order hfac sid date, first
	
	*5.5 Sort data
		sort hfac sid
			
	*Trimming all string variables (if any)
		 foreach var of varlist _all {
			capture confirm string variable `var'
				
			//Trimming if variable type is string
			
			if !_rc {
					replace `var' = trim(itrim(`var'))
					}
		 }	
		
	*5.6 Ordering variables
		order 	key hfac sid date action problem1 problem2 problem3 ///
				problem4 problem5 problem6 problem88 cost_yes cost_tot
		
	*Saving the dataset
		save "${outputs}/meeting_followup_action", replace
	
	