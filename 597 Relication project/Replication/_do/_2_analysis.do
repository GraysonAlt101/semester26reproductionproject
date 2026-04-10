/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	** This file 
		- processes analysis files 
		- runs all the analyses 
		- and prepares tables and figures used in the paper
=========================================================================================================*/


/*------------------------------
	Preamble
 -------------------------------*/
 
	clear all
	set more off

/*------------------------------
	Declare globals
-------------------------------*/

	gl xvars sid#cash#risk		// strata indicators
	gl tvars month 				// month indicators
	gl cl hfac					// cluster variable

** For LaTeX tables **

	gl posttext replace keep(1.clinic 2.clinic) b(%9.3f) se(%9.3f) noconstant nonotes label nostar eqlabels(" " " ") coeflabel(1.clinic "Encourage" 2.clinic "Grant") booktabs width(\hsize) 
	gl scalar scalars("mean Control mean" "test1 p (Grant = Control)" "test2 p (Grant = Encourage)" "test3 p (Grant = Non-Grant)")


	
*--------------------------------------------------------------------------------------------*

* Processing files, running analysis and generating tables and figures as detailed hereunder.
* Note: Please run the following in sequence to avoid any data dependency errors
*---------------------------------------------------------------------------------------------*


/*==========================================================================================
	SUMMARY STATISTICS
---------------------------
	*The following do file prepares the following: 
	
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
					-	Figure A.4: Baseline correlation between clinic income and spending*/
					
		do "${replication_do}/_2_0_gen_bal_tables"
*============================================================================================	
	
	
/*==========================================================================================
	EFFECT ON SPENDING
---------------------------
	*The following do file prepares the following: 
					
			*** Tables:
				-	Table 2: Effect on spending
				- 	Table 3: How did health workers allocate the capital?
				- 	Table A.2: Effect on spending (simple OLS)
				-	Table A.3: Did the grant crowd out other sources of external funding?
				-	Table A.4: How did health workers allocate the capital (Two-part model)
				-	Table A.5: How did health workers allocate the capital (OLS)
				-	Table A.6: How did health workers allocate the capital (extensive/intensive margins)
				
		*** Figures:
				-	Figure 3: Median monthly facility spending
				-	Figure A.5: Payments received from a non-governmental organization	*/

		do "${replication_do}/_2_1_effect_on_spending"
*===========================================================================================


/*==========================================================================================
	ACTION PLAN ANALYSIS
---------------------------
	*The following do file prepares the following: 
	
		*** Excel files for Tables: 
				- 	Table A.7: Patient incentives
				- 	Table A.9: Infrastructure
				- 	Table A.10: Staff investments
				- 	Table A.12: Outreach
				
		*** Figures:
				-	Figure 4: Planned interventions by workers in grant clinics
				-	Figure 5: Grant clinics reduced prices						*/
				
		do "${replication_do}/_2_2_action_plan_analysis"
*==========================================================================================

 
	
 /*==========================================================================================
	EFFECT ON PRODUCTIVITY
---------------------------
	*The following do file prepares the following: 
	
		*** Datasets:
				- "${data}/hetvars"			
			
		*** Tables:
			-	Table 4: Effect on output
			-	Table 8: Which investments were most effective?
			-	Table A.13: Effect on output (OLS with log transformations)
			-	Table A.14: Effect on output (scaling by baseline values)
			-	Table A.15: Effect on output (excluding outliers)
			-	Table A.16: Effect on output (excluding Gombe state)
			-	Table A.17: Effect on output (excluding pandemic months)
			-	Table A.18: Effect on output (excluding clinics in areas where demand-side incentives were offered)
			-	Table A.19: Effect on output (all interactions)
				
		*** Figures:
			-	Figure 7: What is responsible for the increase in clinic output?
			-	Figure A.10: Were grant clinics more likely to maintain utilization records?
			-	Figure A.16: Baseline spending – Top 50% vs. Bottom 50% of clinics 
			-	Figure A.17: Heterogeneity by financial need
			-	Figure A.18: Heterogeneity by in-charge experience
			-	Figure A.19: Correlation between action share and budget share
			-	Figure A.20: Did grant clinics prioritize incentives or infrastructure?  
			-	Figure A.21: Predicted grant allocation
			-	Figure A.22: Validating the predicted incentive-infrastructure index	*/
			
		do "${replication_do}/_2_3_effect_on_productivity"
*===========================================================================================
	

	
/*==========================================================================================
	EFFECT ON QUALITY 
---------------------------
	*The following do file prepares the following: 
				
		*** Tables:
				- 	Table 5: Effects on quality 
				
		*** Figures:
				-	Figure 6: Grant clinics invested in improving infrastructure */
				
		do "${replication_do}/_2_4_effect_on_quality"
*==========================================================================================
	
	

/*==========================================================================================
	EFFECT ON HEALTH
---------------------------
	
	*The following do file prepares the following: 
			
		*** Tables:
			-	Table 6: Effect on early-life mortality
			-	Table 7: Effect on childhood mortality
			-	Table A.8: Verifying fee discounts in the household survey data
			-	Table A.22: Increased utilization of grant clinics
			-	Table A.23: Effect on early-life mortality (Intent-to-Treat)
			-	Table A.24: Effect on early-life mortality (IV)

				
		*** Figures:
			-	Figure A.13: Effect of the conditional incentive on health care utilization
			-	Figure A.14: Do incentive compliers in grant areas have more risky characteristics?
			-	Figure A.15: Mortality gains accrue to the least well-off households	*/		

		do "${replication_do}/_2_5_effect_on_health"
*==========================================================================================



/*==========================================================================================
	EFFECT ON INTANGIBLES
---------------------------

	*The following do file prepares the following:
				
		*** Tables:
				- 	Table 9: Effect on intangibles
				
		*** Figures:
				-	Figure 8: Health workers in grant clinics were more invested */	
				

		do "${replication_do}/_2_6_effect_on_intangibles"		
*===========================================================================================\

	

/*==========================================================================================
	STAFFING
---------------------------

	*The following do file prepares the following:	
	
		*** Tables:
			-	Table A.11: Staffing
			-	Table A.26: Health workers in grant clinics were more likely to be on duty
			-	Table A.27: Workers in grant clinics were less likely to leave	*/

		do "${replication_do}/_2_7_staffing"			
*===========================================================================================



/*==========================================================================================
	PROGRAM EVALUATION FINDINGS
-------------------------------

	*The following do file prepares the following:	
	
			*** Figures:
				-	Figure A.23: Transparency and accountability
				-	Figure A.24: Perceived impacts	*/
				
		do "${replication_do}/_2_8_prog_eval"		
*==========================================================================================



/*==========================================================================================
	LONGER-TERM EFFECTS
-------------------------------

	*The following do file prepares the following:	
				
		*** Tables:
			-	Table 10: Grant clinics four years later
			-	Table A.28: Missing data in 2022 is uncorrelated with treatment assignment
				
*/	
			
		do "${replication_do}/_2_9_LR_effects"	
*==========================================================================================

