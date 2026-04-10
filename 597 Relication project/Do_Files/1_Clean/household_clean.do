/*==================================================================================
** This file cleans the baseline household survey file
====================================================================================*/
	
clear

set seed  11111

gl inputs "${raw}/"
gl outputs "${clean}/"
	
	
*1. Cleaning up file
***************************
	
	*Opening file
		use "${inputs}/household", clear				
	

		*1.1 Defining value labels
	
			lab def hh_source 	1 `"Household Screening"' 2 `"Woman's Follow-up"' 
			
			lab def material 	1 `"Natural"' 2 `"Rudimentary"' 3 `"Finished"' 
			
			lab def school 		0 `"No Schooling "' 1 `"Kindergarten  "' 2 `"Primary 1 "' 3 `"Primary 2 "' 4 `"Primary 3 "' ///
								5 `"Primary 4 "' 6 `"Primary 5 "' 7 `"Primary 6  "' 8 `"JS 1 "' 9 `"JS 2 "' 10 `"JS 3 "' ///
								11 `"SS 1 "' 12 `"SS 2 "' 13 `"SS 3 "' 14 `"College of Education/Polytechnic  "' ///
								15 `"University (Bachelors)  "' 16 `"University (Masters or higher)"' 17 `"Attended Koranic School  "'
			
			lab def sid 		1 `"AKWA IBOM"' 2 `"GOMBE"' 3 `"JIGAWA"' 4 `"KANO"'
			
			lab def toilet 		1 `"Flush Toilet"' 2 `"Traditional Pit Latrine"' 3 `"Ventilated Improved Pit Latrine (VIP)"' ///
								4 `"Bucket Latrine"' 5 `"No Facility/Bush/Field"'
			
			lab def water 		1 `"Piped: Into dwelling "' 2 `"Piped: To yard/plot "' 3 `"Piped: To neighbor "' ///
								4 `"Piped: Public tap/standpipe "' 5 `"Piped: Tube well or borehole "' 6 `"Well: Protected"' ///
								7 `"Well: Unprotected"' 8 `"Spring: Protected"' 9 `"Spring: Unprotected"' 10 `"Other: Rainwater"' ///
								11 `"Other: Tanker truck "' 12 `"Other: Cart with small tank "' 13 `"Other: Surface water"' ///
								14 `"Other: Bottled water "' 88 `"Other: Other"'
			
			lab def yn 			0 `"No"' 1 `"Yes"'
				
		*1.2 Labelling variable values
				
				
			*1.2.1 Labelling yes/no for following variable values 
				
				 foreach var in bank bicycle boat car cart consent fridge generator ///
								hh_phone kitchen motor pc phone power radio ///
								toilet_shared tv {
									
					lab val `var' yn
				}													
								
			*1.2.2 Labelling remaining variable values
				lab val floor material
				lab val h_school school
				lab val hh_source hh_source
				lab val roof material
				lab val sid sid
				lab val toilet toilet
				lab val wall material
				lab val water water
										

		*1.3 Labelling variables
			
			lab var bank `"Any member has a bank account"'
			lab var bicycle `"Has a bicycle"'
			lab var boat `"Has a boat with a motor"'
			lab var car `"Has a car/truck"'
			lab var cart `"Has an animal-drawn cart"'
			lab var consent `"Interv.: Consent"'
			lab var date `"Interview Date"'
			lab var dist `"Distance to health center (km)"'
			lab var end `"Interview end time"'
			lab var floor `"Material of the floor"'
			lab var fridge `"Has a refrigerator"'
			lab var generator `"Has a generator"'
			lab var h_school `"HH head: highest level of schooling"'
			lab var hfac `"Clinic Identifier"'
			lab var hh_phone `"Phone number available"'
			lab var hh_source `"Source of HH info"'
			lab var hhid `"Household ID"'
			lab var kitchen `"Separate room used as a kitchen"'
			lab var motor `"Has a motocycle"'
			lab var num_hh_members `"Number of Household Members"'
			lab var pc `"Has a computer"'
			lab var phone `"Has a mobile phone"'
			lab var power `"Connected to electricity"'
			lab var radio `"Has a radio"'
			lab var roof `"Material of the roof"'
			lab var sid `"State"'
			lab var start `"Interview start time"'
			lab var toilet `"Toilet facility"'
			lab var toilet_shared `"Toilet is shared with other households"'
			lab var tv `"Has a television"'
			lab var vid `"Village ID"'
			lab var wall `"Material of the exterior wall"'
			lab var water `"Main source of drinking water"'
			lab var water_oth `"Main source of drinking water - Other (Specified)"'

	*1.4 Sort data
		sort vid hfac
			
	*1.5 Standardizing variable values		
		
		*1.5.1 Standardizing values in water_oth
		
		foreach val in `"Sachet"' `"Sachet Water"' `"Sachet Water j"' `"Sachet water"' `"Satchel water"' `"Satchet water"' `"sachet water"' {
			
			replace water_oth = "Sachet" if water_oth == "`val'"
		}
	
			
	*1.6 Ordering variables
		order 	hhid hh_source num_hh_members sid hfac vid date start ///
				consent h_school water water_oth power toilet toilet_shared ///
				kitchen radio tv bicycle motor generator phone pc cart car ///
				boat fridge bank hh_phone floor wall roof dist end
				
	*Saving dataset
		save "${outputs}/household", replace	
