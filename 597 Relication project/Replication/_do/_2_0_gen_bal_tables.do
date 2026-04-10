/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	**This file prepares the following:
	
		*** Datasets: 
				-	"${data}/bl"
				-	"${data}/blpredict"
				-	"${data}/elwoman" 
				-	"${data}/othchild"
				
		*** Tables:
				- 	Table 1: Summary Statistics and Tests of Balance
				-	Table A.1: Funding from various sources
				-	Table A.20: Changes in composition: general patient population
				-	Table A.21: Tests of Balance: Household Sample
				-	Table A.25: Comparing mean characteristics of mothers who used health services
				
		*** Figures:
				-	Figure A.5: Baseline correlation between clinic income and spending				
=========================================================================================================*/




/* The following prepares:
------------------------------------
		*** Datasets: 
				-	"${data}/bl"
				-	"${data}/blpredict"
								
		*** Tables:
				- 	Table 1: Summary Statistics and Tests of Balance
				-	Table A.1: Funding from various sources
				
		*** Figures:
				-	Figure A.5: Baseline correlation between clinic income and spending		
*/				
	do "${replication_do}/_2_0_0_balance"
*------------------------------------	




/* The following prepares:
------------------------------------
		*** Datasets: 
				-	"${data}/elwoman"
				-	"${data}/othchild"								
*/	

	do "${replication_do}/_2_0_1_household"
*------------------------------------
	

	
	
** Generating other balance tables
*-----------------------------------

/* The following prepares:
------------------------------------
		*** Tables:
			-	Table A.20: Changes in composition: general patient population
*/
	do "${replication_do}/_2_0_2_balance_patients"
*------------------------------------	
	
	
	

/* The following prepares:
------------------------------------
		*** Tables:
			-	Table A.21: Tests of Balance: Household Sample
*/	
	do "${replication_do}/_2_0_3_balance_hh"
*------------------------------------
	

	
	
/* The following prepares:
------------------------------------
		*** Tables:
			-	Table A.25: Comparing mean characteristics of mothers who used health services
*/

	do "${replication_do}/_2_0_4_balance_care"
*------------------------------------