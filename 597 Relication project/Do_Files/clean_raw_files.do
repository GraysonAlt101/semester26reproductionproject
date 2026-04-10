/*==================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care
** This file cleans all raw files
====================================================================================*/
		
	
*------------------ CHOOSE WHETHER YOU WANT TO RUN THIS FILE AS A STANDALONE FILE ---------*
	
*Default: This file is run from "Replication_Files/Master.do"

		*Default: run_standalone = 0; 
		
		local run_standalone = 0  // Switch to 1 to run this do file as a standalone file
				
			if `run_standalone' == 1 {
				gl db "C:/Users/.."  //UPDATE PATH FOR FOLDER
					gl db_do "${db}/Do_Files"
					gl db_Raw "${db}/Data_Files/0_Raw"
					gl db_Clean "${db}/Data_Files/1_Clean"
			}
*-------------------------------------------------------------------------------------------*
			
		
		*PATH Directory
			*Do Files
				gl do "${db_do}"

			*Data files
				gl raw  "${db_Raw}"
				gl clean "${db_Clean}"
			

* --------------------*
* Facility Files
*---------------------*
	
	*Task: Clean Data
	*---------------------*
		
		*Treatment identifiers
			do "${do}/1_Clean/id_clean.do"		
			
		*In-charge admin data
			do "${do}/1_Clean/oic_clean.do"	
			
		*Rollout meeting and follow-up data
			do "${do}/1_Clean/meeting_clean.do"
	
		*Facility surveys 
			do "${do}/1_Clean/facility_clean.do"
			
		*Service delivery surveys
			do "${do}/1_Clean/sds_clean.do"
			
		*Post-intervention evaluation survey
			do "${do}/1_Clean/feedback_clean.do"
	
		*Patient data
			do "${do}/1_Clean/patient_clean.do"
						
				
			
* --------------------*
* Household Files
*---------------------*
*-------------------------------------------------------------------------------*
	
	*Task: Clean Data
	*---------------------*
			
			*Baseline household survey
				do "${do}/1_Clean/household_clean.do"
				
			*Woman baseline and endline surveys 
				do "${do}/1_Clean/woman_clean.do"
				
			
*-------------------------------------------------------------------------------*	

