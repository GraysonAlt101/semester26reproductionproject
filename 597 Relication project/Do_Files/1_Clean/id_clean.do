/*==================================================================================
** This file cleans files with treatment identifiers 
====================================================================================*/

clear

set seed  11111

gl inputs "${raw}"
gl outputs "${clean}"

	
*1. Cleaning up file with clinic treatment identifiers 
********************************************************
	
	*Opening facility.dta
	use "${inputs}/facility.dta",clear


	*1.1 Defining labels

			lab def clinic 0 `"Control"'  1 `"Encouragement"' 2 `"Grant"' 
			
			lab def sid 1 `"AKWA IBOM"' 2 `"GOMBE"'  3 `"JIGAWA"'  4 `"KANO"'
	
	*1.2 Labelling variable values
			
			lab val clinic clinic
			lab val sid sid							 
	 
	*1.3 Labeling variables
	
		lab var hfac `"Clinic Identifier"'
		lab var clinic `"Health center treatment"'
		lab var sid `"State"'		
		
	*1.4 Sort data
		order hfac clinic sid
		sort hfac sid		
		
	*Saving file
		save "${outputs}/facility.dta", replace

	 		 
*2 Cleaning up file with area treatment identifiers 
***************************************************

	*Opening file
	use "${inputs}/treatment.dta",clear
	
		*2.1 Defining labels

				lab def cash 	0 `"N0"' 1 `"N2500"' 2 `"N4000"' 3 `"N10000"'
				
				lab def clinic 	0 `"Control"'  1 `"Encouragement"' 2 `"Grant"' 
				
				lab def sid 	1 `"AKWA IBOM"' 2 `"GOMBE"' 3 `"JIGAWA"' 4 `"KANO"'

				lab def yn 		0 `"No"' 1 `"Yes"'
				
		*2.2 Labelling variable values
		
				lab val cash cash
				lab val clinic clinic
				lab val risk yn
				lab val sid sid	
		
		*2.3 Labelling variables
		
				lab var cash `"Incentive amount"'
				lab var clinic `"Health center treatment"'
				lab var hfac `"Clinic Identifier"'
				lab var risk `"Educated about health risk"'
				lab var sid `"State"'

		*2.4 Sort data
				sort hfac sid
				
		
		*Trimming all string variables (if any)
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }
			
		
				
	*Saving file
		save "${outputs}/treatment.dta",replace

		
*3 Cleaning up file with woman treatment identifiers
******************************************************			

	*Opening file
		use "${inputs}/women_treatment.dta",clear

	*3.1 Defining labels
		
		lab def cash 	0 `"N0"'  1 `"N2500"' 2 `"N4000"'  3 `"N10000"'

		lab def clinic 	0 `"Control"'  1 `"Encouragement"' 2 `"Grant"' 
		
		lab def sid 	1 `"AKWA IBOM"' 2 `"GOMBE"'  3 `"JIGAWA"'  4 `"KANO"'

		lab def yn 		0 `"No"'  1 `"Yes"'		
		
	*3.2 Labelling variable values
		
		lab val cash cash
		lab val cct yn
		lab val clinic clinic
		lab val risk yn
		lab val sid sid
	
	*3.3 Labelling variables
		
		lab var cash `"Incentive amount"'
		lab var cct `"Offered incentive"'
		lab var clinic `"Health center treatment"'
		lab var hfac `"Clinic Identifier"'
		lab var hhid `"Household ID"'
		lab var risk `"Educated about health risk"'
		lab var sid `"State"'
		lab var vid `"Village ID"'
		lab var wid `"Woman ID"'

	*3.4 Sort data
		sort wid hhid vid hfac sid
		
	*Trimming all string variables (if any)
		 foreach var of varlist _all {
			capture confirm string variable `var'
				
			//Trimming if variable type is string
			
			if !_rc {
					replace `var' = trim(itrim(`var'))
					}
		 }
		 
	*3.5 Ordering variables
		order cash cct risk clinic sid hfac vid hhid wid
		
	*Saving file
		save "${outputs}/women_treatment.dta",replace

		

