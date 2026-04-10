/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	**This file prepares the following:		
				
		*** Tables:
				- 	Table 5: Effects on quality 
				
		*** Figures:
				-	Figure 6: Grant clinics invested in improving infrastructure				
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
	Read in facility data
---------------------------------------------------------------------------------------------*/

	use "${db_Clean}/facility_bl", clear	// Rd 1 facility data
	g rd=1
	tempfile bl
	save `bl'

	use "${db_Clean}/facility_f1", clear	// Rd 2 facility data
	g rd=2
	tempfile el
	save `el'
		
	use "${db_Clean}/facility_f2", clear	// Rd 3 facility data
	g rd=3

	append using `el'
	append using `bl'
	
	merge m:1 hfac using "${data}/bl", nogen 			// baseline facility controls
	merge m:1 hfac using "${db_Clean}/treatment", nogen	keep(3)	// treatment indicators

	label define rd 1 "Baseline" 2 "16 mths" 3 "24 mths"
	label values rd rd

	foreach i of numlist 1/23 {
		replace eq`i'_av=0 if eq`i'_tot==0		// code as not having the equipment if number owned is zero
	}
	egen equip=rowmean(eq*_av)
	label var equip "Equipment available"

	egen serv=rowmean(serv*)
	label var serv "Services offered"

	foreach v of varlist drugs?_* {
		replace `v'=0 if drugs_store==0		// no drugs
	}
	egen drugs=rowmean(drugs?_*)
	label var drugs "% of drug list in stock"

	g power=power_source>=1
	replace power=1 if backup_works==1
	label var power "Electricity supply"

	g backup=backup_works==1 if backup_av<.
	label var backup "Backup generator"

	g wc=toilet_works==1
	label var wc "Working toilet"

	cap drop water
	g water=inlist(water_source,1,2,4)
	label var water "Running water"

	egen obs=rowmean(obs_build obs_infra obs_inclean obs_outclean)
	label var obs "Observer rating"

	label var obs_waitdel "Fan/AC in patient waiting area"


/*------------------------------------------------------------------------------------------------------
	Figure 6: Grant clinics invested in improving infrastructure
-------------------------------------------------------------------------------------------------------*/

	foreach y of varlist power {
		#delimit;
			loc a : variable label `y';
			cibar `y' if rd>=2, over(clinic rd) vce(cl hfac)
			level(90) bargap(5) barcol(gs13 blue red) ciopt()	
			graphopts(ytitle("Proportion") xlabel(, labgap(3)) xtitle("", margin(b=10) size(medsmall))
			scale(0.9) subti("`a'")
			saving("$out/`y'", replace) legend(order(1 "Control" 2 "Encourage" 3 "Grant") 
			rows(1) position(12) ring(1) symxsize(6) region(lw(thin))));
		#delimit cr
	}
	foreach y of varlist water wc obs_waitdel obs {
		#delimit;
			loc a : variable label `y';
			cibar `y' if rd>=2, over(clinic rd) vce(cl hfac)
			level(90) bargap(5) barcol(gs13 blue red) ciopt()	
			graphopts(ytitle("") xlabel(, labgap(3)) xtitle("", margin(b=10) size(medsmall))
			scale(0.9) subti("`a'")
			saving("$out/`y'", replace) legend(off));
		#delimit cr
	}

	cd "$out"
	grc1leg2 power.gph water.gph wc.gph obs_waitdel.gph obs.gph, pos(4) lrow(3) ring(0) lxo(-7) lyo(7) 
	gr export infrastructure.eps, as(eps) preview(off) replace


/*------------------------------------------------------------------------------------------------------
	Table 5: Effects on quality 
-------------------------------------------------------------------------------------------------------*/

* Clinic quality

	tab clinic, g(clinic)
	eststo clear
	loc yvars bed_tot power backup water wc serv equip drugs obs_build obs_infra obs_inclean obs_outclean obs_waitdel obs_waitfan obs_curt  
	loc x lab
	foreach y in index {
		foreach i in 1 2 3 {
			swindex `yvars' if rd==`i', generate(`y') normby(clinic1) replace
			eststo: reghdfe `y' i.(`x' clinic) if rd==`i', cl($cl) abs($xvars)
			sum `y' if clinic==0 & e(sample)==1
			test_effects
		}
	}

* Treatment quality

	use "${db_Clean}/patient.dta", clear	// read in patient data
	merge m:1 hfac using "${data}/bl", nogen		//  baseline facility controls 
	merge m:1 hfac using "${db_Clean}/treatment", nogen	keep(3)	// treatment indicators

	foreach string in "Ferver" "Fever" "Fever and internal heat" "Fever c" "Fever die" "Fever vomiting" "Fiver" {
		replace reason1=1 if reason_oth=="`string'"
		replace s1=2 if reason_oth=="`string'" & s1==.
		replace reason13=0 if reason_oth=="`string'"
		replace reason_oth="" if reason_oth=="`string'"
	}
	foreach string in "Catter" {
		replace reason1=1 if reason_oth=="`string'"
		replace s1=5 if reason_oth=="`string'" & s1==.
		replace reason13=0 if reason_oth=="`string'"
		replace reason_oth="" if reason_oth=="`string'"
	}
	foreach string in "Abdominal pain" "Epigastric pain" "Ciwon ciki da tari" {
		replace reason1=1 if reason_oth=="`string'"
		replace s1=11 if reason_oth=="`string'" & s1==.
		replace reason13=0 if reason_oth=="`string'"
		replace reason_oth="" if reason_oth=="`string'"
	}
	foreach string in "Chest pain" {
		replace reason1=1 if reason_oth=="`string'"
		replace s1=10 if reason_oth=="`string'" & s1==.
		replace reason13=0 if reason_oth=="`string'"
		replace reason_oth="" if reason_oth=="`string'"
	}
	foreach string in "Diaria vomiting" "Diarrhea"  {
		replace reason1=1 if reason_oth=="`string'"
		replace s1=8 if reason_oth=="`string'" & s1==.
		replace reason13=0 if reason_oth=="`string'"
		replace reason_oth="" if reason_oth=="`string'"
	}
	foreach string in "Headed" {
		replace reason1=1 if reason_oth=="`string'"
		replace s1=1 if reason_oth=="`string'" & s1==.
		replace reason13=0 if reason_oth=="`string'"
		replace reason_oth="" if reason_oth=="`string'"
	}
	foreach string in "Covid 19 Vaccination" "Routine immunazation" "Measles"  {
		replace reason4=1 if reason_oth=="`string'"
		replace reason13=0 if reason_oth=="`string'"
		replace reason_oth="" if reason_oth=="`string'"
	}
	foreach string in "Implant" "Family planning"  {
		replace reason5=1 if reason_oth=="`string'"
		replace reason13=0 if reason_oth=="`string'"
		replace reason_oth="" if reason_oth=="`string'"
	}
	foreach string in "ANC" "Antenatal Registration" "Routine Drugs" {
		replace reason6=1 if reason_oth=="`string'"
		replace reason13=0 if reason_oth=="`string'"
		replace reason_oth="" if reason_oth=="`string'"
	}

	foreach x of varlist f_* c_* d_* o_* u_*  {
		g  new_`x'=`x' if `x'<99
		}
	egen count=rownonmiss(f_* c_* d_* o_* u_*)	// number of applicable questions
	egen asked=rowtotal(new_*)					// number of questions asked
	g hist=asked/count							// History-taking index
	drop new_*

	tempvar x
	egen `x'=rownonmiss(s1-s5)
	g complaint=`x'>1
	label var complaint "More than one complaint"

	g control=clinic==0

	preserve
		keep if reason1==1 		// sick patients only 
		loc yvars hist e_bp e_temp e_touch e_stet 
		loc xvars lab p_age_y p_male i.s1 complaint count start car cell gen fridge radio 
		foreach y in index {
			swindex `yvars', generate(`y') normby(control) replace
			eststo: reghdfe `y' `xvars' i.(clinic), cl($cl) abs(visit $xvars)
			sum `y' if clinic==0 & e(sample)==1
			test_effects
		}
	restore
	#delimit;
		esttab using "$out/tab_quality", $posttext mtitle("Baseline" "at 16 months" "at 24 months" "overall") 
		scalars("mean Control mean" "test1 p (Grant = Control)" "test2 p (Grant = Encourage)" 
		"test3 p (Grant = Non-Grant)") sfmt(%9.3f) mgroups("Clinic quality" "Treatment quality", 
		pattern(1 0 0 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}));
	#delimit cr
