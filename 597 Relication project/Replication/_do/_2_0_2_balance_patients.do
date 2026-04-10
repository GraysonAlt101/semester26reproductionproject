/*==============================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care
** This file creates Appendix Table A.20
==============================================================================*/

/*------------------------------
	Preamble
 -------------------------------*/
	 
	clear all
	set more off
	set seed 123	// set seed


/*---------------------------------------------------------------------------------------------
	Read in patient data
---------------------------------------------------------------------------------------------*/
	
	use "${db_Clean}/patient.dta", clear

	*Merging in clinic information
		merge m:1 hfac using "${db_Clean}/facility", keepusing(clinic) nogen keep(3)

	g fever=s1==2
	label var fever "Main complaint is fever"

	tempvar x
	egen `x'=rownonmiss(s1-s5)
	g complaint=`x'>1
	label var complaint "More than one complaint"

	egen asset=rowtotal(radio fridge cell gen car)
	label var asset "Number of assets (out of 5)"

	egen duration=rowmean(symptom*_start)
	replace duration=0 if duration==.
	label var duration "Number of days sick"

	loc vars p_male p_age_y asset reason1 fever complaint duration

/*------------------------------------------------------------------------------------------------------
	Table A.20: Changes in composition: general patient population
-------------------------------------------------------------------------------------------------------*/

	cap file close fh
	cap	macro drop fh 
	cap erase "$out/tab_balance_patients.tex"
	file open fh using "$out/tab_balance_patients.tex", write replace
		file write fh ///
		"\small" ///
		"\begin{tabular}{lccccccc} "_n ///
		"\toprule "_n ///
		" 			&    (1) 	&   (2)		&   (3) 	&  			&  			& 			&  \\"_n ///
		"Variables 	& Control 	& Encourage 	& Grant 	& (1)=(2) 	& (1)=(3) 	& (2)=(3) 	& Joint\\"_n  ///
		"\midrule "_n 
	
	quietly {
		foreach var of local vars  {
			foreach i of numlist 0/2 {
				su `var' if clinic == `i'
				local `var'_`i' = string(r(mean), "%10.3g")
			}
			reg `var' i.(clinic),  vce(cl $cl)
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
		
	// Omnibus test	
		
			qui mlogit clinic `vars',  vce(cl $cl)
			qui test `vars' 
			local omni=string(`r(p)', "%10.2f")
			
			file write fh " Omnibus test (p-value) &   &   &  &  &  &  & `omni'  \\"_n ///
			 "\midrule "_n 
			 
	// Sample sizes

			foreach i of numlist 0/2 {
				count if clinic == `i'
				local n`i' = string(r(N), "%10.0f")
			}
			file write fh " Sample size & `n0' & `n1'  & `n2' &  &  &  &  \\"_n ///
			
		
/*---------------------------------------------------------------
	End preamble
----------------------------------------------------------------*/
	
	file write fh " \bottomrule "_n ///
	"\end{tabular} "_n
	
	file close fh
	macro drop fh 