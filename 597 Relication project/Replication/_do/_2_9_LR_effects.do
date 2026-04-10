/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	**This file prepares the following:
				
		*** Tables:
			-	Table 10: Grant clinics four years later
			-	Table A.28: Missing data in 2022 is uncorrelated with treatment assignment
=========================================================================================================*/



/*------------------------------
	Preamble
 -------------------------------*/
 
	clear all
	set more off
	set seed 123	// set seed

	*Calling custom programs required to compute tests
		do "${replication_do}/programs"
	
/*---------------------------------------------------------------------------------------------
	Read 2022 Data 
---------------------------------------------------------------------------------------------*/
	use "${db_Clean}/SDS_5", clear
	merge m:1 hfac using "${data}/bl", nogen	keep(3)	
	merge m:1 hfac using "${db_Clean}/treatment", nogen	keep(3)	// treatment indicators
	merge m:1 hfac using "${data}/hetvars", nogen	keep(3)	

	* Impute missing baseline output for single clinic with no baseline

	foreach v of varlist rec_* {
		bys sid: egen x=mean(`v')		// state mean
		replace `v'=x if missing(`v') 	// replace missing with state mean
		drop x
	}

	ren rec_pats rec_opd
	g rec_imm=1		// constant

	label var anc "Antenatal visits"
	label var del "Deliveries"
	label var imm "Immunizations"
	label var opd "Outpatient visits"


/*------------------------------------------------------------------------------------------------------
	Table A.28: Missing data in 2022 is uncorrelated with treatment assignment
-------------------------------------------------------------------------------------------------------*/

	eststo clear
	foreach y in anc del imm opd {
		g miss`y'=missing(`y')
		eststo: reghdfe miss`y' i.clinic, abs($xvars $tvars) cl($cl)
		sum miss`y' if e(sample) 
		test_effects
	}	
	#delimit;
		esttab using "$out/tab_missing2022", $posttext 
		mtitles("\shortstack{Antenatal \\visits}" "\shortstack{Baby\\Deliveries}" 
		"\shortstack{Child \\immunizations}" "\shortstack{Outpatient \\visits}")
		scalars("mean Control mean" "test1 p (Grant = Control)" "test2 p (Grant = Encourage)" 
		"test3 p (Grant = Non-Grant)");
	#delimit cr

/*------------------------------------------------------------------------------------------------------
	Table 10: Grant clinics four years later
-------------------------------------------------------------------------------------------------------*/

	** GLM **

	loc x lab open24
	eststo clear
	foreach y in anc del imm opd {
		loc a : variable label `y'
		qui glm `y' rec_`y' i.(`x' $tvars $xvars clinic), link(log) fam(nb) vce(cl $cl)
		eststo: margins, dydx(clinic) post 
		count if `y'==.
		scalar n=r(N)
		estadd sca n
		sum `y' if e(sample) & clinic==0
		test_effects
	}
	#delimit;
		esttab using "$out/tab_longrun", $posttext  
		mtitles("\shortstack{Antenatal \\visits}" "\shortstack{Baby\\Deliveries}" 
		"\shortstack{Child \\immunizations}" "\shortstack{Outpatient \\visits}")
		scalars("n Missing obs" "mean Control mean" "test1 p (Grant = Control)" 
		"test2 p (Grant = Encourage)" "test3 p (Grant = Non-Grant)") sfmt(%9.0f %9.1f %9.3f);
	#delimit cr

	** OLS with log transformation **

	preserve
		eststo clear
		foreach y in anc {
			drop if missing(`y')
			replace `y'=ln(`y')
			eststo: reghdfe `y' rec_`y' i.(`x' clinic), vce(cl $cl) abs($xvars $tvars)
			count 
			loc den=r(N) 
			count if `y'==.
			loc num=r(N) 
			scalar n=`num'/`den'
			estadd sca n
			sum `y' if clinic==0 & e(sample)==1
			test_effects
		}
	restore
	foreach y in del {
		preserve
			drop if missing(`y')
			replace `y'=`y'>0	
			eststo: reghdfe `y' rec_`y' i.(`x' clinic), vce(cl $cl) abs($xvars $tvars)
			count 
			loc den=r(N) 
			count if `y'==0
			loc num=r(N) 
			scalar n=`num'/`den'
			estadd sca n
			sum `y' if e(sample) & clinic==0
			test_effects	
		restore

		preserve
			replace `y'=ln(`y')
			eststo: reghdfe `y' rec_`y' i.(`x' clinic), vce(cl $cl) abs($xvars $tvars)
			sum `y' if e(sample) & clinic==0
			test_effects
		restore
	}
	
	foreach y in imm opd {
		preserve
			drop if missing(`y')
			replace `y'=ln(`y')
			eststo: reghdfe `y' rec_`y' i.(`x' clinic), vce(cl $cl) abs($xvars $tvars)
			count 
			loc den=r(N) 
			count if `y'==.
			loc num=r(N) 
			scalar n=`num'/`den'
			estadd sca n
			sum `y' if clinic==0 & e(sample)==1
			test_effects
		restore
	}
	#delimit;
		esttab using "$out/tab_longrun_log", $posttext 
		mtitles("" "Y>0" "Ln(Y)" "" "")
		scalars("n Fraction of zeros" "mean Control mean"  "test1 p (Grant = Control)" 
		"test2 p (Grant = Encourage)" "test3 p (Grant = Non-Grant)") sfmt(%9.3f) 
		mgroups("\shortstack{Antenatal\\visits}" "\shortstack{Baby\\deliveries}" 
		"\shortstack{Child\\immunizations}" "\shortstack{Outpatient\\visits}",  pattern(1 1 0 1 1) 
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}));
	#delimit cr

