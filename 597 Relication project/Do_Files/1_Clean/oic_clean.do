/*===================================================================
** This file cleans the clinic in-charge admininistrative file 
====================================================================*/

clear

set seed  11111

gl inputs "${raw}"
gl outputs "${clean}"


*1. Cleaning up file
**********************

	*Opening file
		use "${inputs}/oic.dta",clear
	
	*1.1 Defining labels
		
		lab def cadre  1 `"Doctor"'  2 `"Nurse"'  3 `"Midwife"'  4 `"Nurse/Midwife"' ///
						5 `"CHO"'  6 `"CHEW"'  7 `"J-CHEW"'  8 `"Pharmacist/Pharmacy technician"'  ///
						9 `"Laboratory technicians/technologist"'  10 `"Medical Records Officer"'  ///
						11 `"Environmental Health Officer"'  88 `"Other (specify)"'
	
		lab def clinic 0 `"Control"'  1 `"Encouragement"' 2 `"Grant"' 
		
		lab def sid 1 `"AKWA IBOM"' 2 `"GOMBE"'  3 `"JIGAWA"'  4 `"KANO"'

		lab def yn 0 `"No"'  1 `"Yes"'				
		
	*1.2 Labelling variable values
		
		lab val cadre cadre
		lab val clinic clinic
		lab val paid_lastm yn
		lab val sid sid
	
	*1.3 Labelling variables
		
		lab var age `"Demographics: Age"'
		lab var cadre `"Highest qualification"'
		lab var cadre_oth `"Highest qualification - Other (Specified)"'
		lab var clinic `"Health center treatment"'
		lab var clinic_exp_y `"Total years of clinical work experience"'
		lab var hfac `"Clinic Identifier"'
		lab var paid_lastm `"Paid last month"'
		lab var paid_lastm_tot `"Total paid last month"'
		lab var salary `"Total monthly salary"'
		lab var sid `"State"'
		lab var startyear `"Employment start year"'

	*1.4 Sort data
		sort hfac sid
		
	*Trimming all string variables (if any)
		 foreach var of varlist _all {
			capture confirm string variable `var'
				
			//Trimming if variable type is string
			
			if !_rc {
					replace `var' = trim(itrim(`var'))
					}
		 }
		 
	*1.5 Ordering variables
		order hfac sid clinic cadre cadre_oth startyear age clinic_exp_y salary paid_lastm paid_lastm_tot

		
	*Saving file
		save "${outputs}/oic.dta",replace
		
