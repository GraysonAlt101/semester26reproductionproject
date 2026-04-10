/*==============================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care
** This file creates Appendix Table A.25
==============================================================================*/

/*------------------------------
	Preamble
 -------------------------------*/
 
	clear all
	set more off
	set seed 123	// set seed


/*---------------------------------------------------------------------------------------------
	Read in woman endline files
---------------------------------------------------------------------------------------------*/

	use "${data}/elwoman", clear

	keep if usedcare==1	

	foreach v in agegroup mschool wealth {
		qui tab bl_`v', g(`v')
	}
	foreach i of numlist 1/4 {
		label var wealth`i' "Wealth quintile `i'" 
	}

	loc dem agegroup1 agegroup2 agegroup3 agegroup4 mschool1 mschool2 mschool3 mschool4 bl_asset bl_dist
	loc preg bl_preg_w bl_del_first bl_priormisc bl_priorstill  
	gl vars `dem' `preg' 

	label var agegroup1 "Mother's age: <18"
	label var agegroup2 "Mother's age: 18-24"
	label var agegroup3 "Mother's age: 25-34"
	label var agegroup4 "Mother's age: >35"
	label var mschool1 "Mother's schooling: None" 
	label var mschool2 "Mother's schooling: Primary"
	label var mschool3 "Mother's schooling: Secondary"
	label var mschool4 "Mother's schooling: Tertiary"
	label var bl_preg_w "Weeks pregnant at enrollment"
	label var bl_del_first "First child"


/*------------------------------------------------------------------------------------------------
	Table A.25: Comparing mean characteristics of mothers who used health services
------------------------------------------------------------------------------------------------*/
	
	cap file close fh
	cap	macro drop fh 
	cap erase "$out/tab_balance_care.tex"
	file open fh using "$out/tab_balance_care.tex", write replace
		file write fh ///
		"\small" ///
		"\begin{tabular}{lccccccc} "_n ///
		"\toprule "_n ///
		" 			&    (1) 	&   (2)		&   (3) 	&  			&  			& 			&  \\"_n ///
		"Variables 	& Control 	& Encourage 	& Grant 	& (1)=(2) 	& (1)=(3) 	& (2)=(3) 	& Joint\\"_n  ///
		"\midrule "_n 
		
	
* Summary Statistics and p-values
	
	quietly {
		foreach var of varlist $vars  {
			foreach i of numlist 0/2 {
				su `var' if clinic == `i'
				local `var'_`i' = string(r(mean), "%10.3f")
				}
			reg `var' i.(clinic), cl($cl)
			test (1.clinic=0)							// encourage = control
			local p1=string(`r(p)', "%10.2f")
			test (2.clinic=0) 							// grant = control
			local p2=string(`r(p)', "%10.2f")
			test (1.clinic=2.clinic) 					// encourage = grant
			local p3=string(`r(p)', "%10.2f")	
			test (1.clinic=0) (2.clinic=0) 				// joint test
			local p_all=string(`r(p)', "%10.2f")
		
			file write fh "`: variable label `var'' & ``var'_0' & ``var'_1'  & ``var'_2' & `p1' & `p2' & `p3' & `p_all'\\"_n
			}
	}

	// Sample sizes

		foreach i of numlist 0/2 {
			count if clinic == `i'
			local n`i' = string(r(N), "%10.0f")
			}

	// Omnibus test	
	
		qui mlogit clinic $vars, vce(cl $cl)
		qui test $vars 
		local omni=string(`r(p)', "%10.2f")
		
		file write fh " Omnibus test (p-value) &   &   &  &  &  &  & `omni'  \\"_n ///
		 "\midrule "_n 
		
		file write fh " Sample size & `n0' & `n1'  & `n2'  &  &  &  &  \\"_n 

	
	file write fh " \bottomrule "_n ///
	"\end{tabular} "_n
	
	file close fh
	macro drop fh 
