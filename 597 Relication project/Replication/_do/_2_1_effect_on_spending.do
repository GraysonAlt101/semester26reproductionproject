/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	**This file prepares the following:
	
		*** Tables:
				-	Table 2: Effect on spending
				- 	Table 3: How did health workers allocate the capital?
				-	Table A.2: Effect on spending (simple OLS)
				-	Table A.3: Did the grant crowd out other sources of external funding?
				-	Table A.4: How did health workers allocate the capital (Two-part model)
				-	Table A.5: How did health workers allocate the capital (OLS)
				-	Table A.6: How did health workers allocate the capital (extensive/intensive margins)
				
		*** Figures:
				-	Figure 3: Median monthly facility spending
				-	Figure A.5: Payments received from a non-governmental organization			
=========================================================================================================*/

/*------------------------------
	Preamble
 -------------------------------*/
 
clear all
set more off
set seed 123	// set seed


/*---------------------------------------------------------------------------------------------
	Read in SDS - monthly data
---------------------------------------------------------------------------------------------*/

	use "${db_Clean}/sds_month", clear
	merge m:1 hfac using "${data}/bl", nogen 		// baseline controls
	merge m:1 hfac using "${db_Clean}/treatment", nogen keep(3)	// treatment indicators

	* Assign 'Other' expenses to one of the other categories

	loc exp e_other_tot
	loc type e_other_type

	foreach string in "emergency referral of 3 accident clients to federal medical center gombe,who has no means of transportation." {
		replace e_inc_p_tot=e_inc_p_tot+`exp' if `type'=="`string'"
		replace `exp'=0 if `type'=="`string'"
	}
	foreach string in "(Photocopy of photograph.). (Photo copy of WHO check list.)." {
		replace e_med_tot=e_med_tot+`exp' if `type'=="`string'"
		replace `exp'=0 if `type'=="`string'"
	}
	foreach string in "Purchase of sitting benches, Lanter and broom" "Windows and doors contains" ///
	"Facility windows and doors curtains" "New benches for ANC AND R.I" "Pad lock, book, extension wire" "Termites paste" "Labour paid" "Labour room contains" {
		replace e_renov_tot=e_renov_tot+`exp' if `type'=="`string'"
		replace `exp'=0 if `type'=="`string'"	
	}
	foreach string in "Creation of outreach activities" {
		replace e_out_tot=e_out_tot+`exp' if `type'=="`string'"
		replace `exp'=0 if `type'=="`string'"
	}
	foreach string in "Casual staff House rent payment" "Refreshment during staff meeting" {
		replace e_inc_s_tot=e_inc_s_tot+`exp' if `type'=="`string'"
		replace `exp'=0 if `type'=="`string'"
	}
	foreach string in "1.Payment of casual staff 2.purchase of maternity sterilization cooker gas 3.purchase of notice board" {
		replace e_inc_s_tot=e_inc_s_tot+(`exp'*1/3) if `type'=="`string'"
		replace e_renov_tot=e_renov_tot+(`exp'*2/3) if `type'=="`string'"
		replace `exp'=0 if `type'=="`string'"
	}

	* Create spending categories

	g incent=e_inc_p_tot 
	egen equip=rowtotal(e_eq_tot e_repair_tot)
	egen infra=rowtotal(e_renov_tot)
	egen supp=rowtotal(e_drug_tot e_med_tot)
	egen run=rowtotal(e_power_tot e_water_tot e_fuel_tot e_waste_tot e_laundry_tot e_stat_tot e_comm_tot)
	g staff=e_inc_s_tot
	g outreach=e_out_tot
	egen total=rowtotal(e_*_tot) 	// original total 

	label var total "TOTAL"
	label var incent "Patient incentives"
	label var staff "Staff incentives"
	label var outreach "Outreach"
	label var supp "Supplies"
	label var equip "Equipment"
	label var run "Running costs"
	label var infra "Renovation/repairs"

	* Identify outliers

	foreach y of varlist incent equip infra staff {	// excluded because of the extremely lumpy nature of this spending
		g _`y'=`y'
	}

	foreach y of varlist supp run outreach {
		tempvar x
		qui bys hfac: egen `x'=std(`y') 
		g out_`y'=`x'>4 & `x'<.	// outlier 	
		g _`y'=`y'
		g x1=`y' if out_`y'==0 
		bys hfac: egen x2=pctile(x1), p(99)
		replace _`y'=x2 if x1==.		// Top code outliers at 99th percentile value 
		drop x?
	}
	g _total= _incent+_equip+_infra+_staff+_supp+_run+_outreach		// total after topcoding



/*------------------------------------------------------------------------------------------------------
	Figure 3: Median monthly facility spending
-------------------------------------------------------------------------------------------------------*/

	foreach y in total {
		preserve
			loc a : variable label `y'
			loc x month
			format month %tdMon-YY
			loc style lpat(dot) style(unextended)
			collapse (p50) `y', by(clinic `x')
			replace `y'=`y'/1000	// rescale
			#delimit;
				twoway (connected `y' `x' if clinic==2, mc(red) lcolor(red) lp(dash))
				(connected `y' `x' if clinic==1, mc(blue) lcolor(blue))
				(connected `y' `x' if clinic==0, mc(gs10) lcolor(gs10)),
				tline(01Jun2019, `style') tline(01Oct2019, `style')
				tline(01Jan2020, `style') tline(01Jun2020, `style')
				title("", margin(b=3)) ytitle("Spending (N000's)") xtitle("")
				ysc(range(0 100)) yla(20(20)100)
				saving("$out/`y'", replace) scheme(s1mono)
				legend(order(1 "Grant" 2 "Encourage" 3 "Control" ) 
				rows(3) position(2) ring(0) symxsize(3) size(small) region(lw(none)));
				gr export "$out/`y'.eps", as(eps) preview(off) replace;
			#delimit cr
		restore
	}	

/*------------------------------------------------------------------------------------------------------
	Table 2: Effect on spending
-------------------------------------------------------------------------------------------------------*/

	*Calling custom programs required to compute tests
		do "${replication_do}/programs"  
		
	keep if month>=td(01Jun2019)	// observation period

	eststo clear
	loc x lab
	preserve 
		loc y _total
		replace `y'=`y'/1000	// rescale
		
		qui glm `y' i.($tvars $xvars clinic), link(log) fam(gamma) vce(cl $cl)
		eststo: margins, dydx(clinic) post 
		sum `y' if clinic==0 & e(sample)==1
		test_effects	

		qui glm `y' i.(`x' $tvars $xvars clinic), link(log) fam(gamma) vce(cl $cl)
		eststo: margins, dydx(clinic) post 
		sum `y' if clinic==0 & e(sample)==1
		test_effects
	restore

	* Median regression
		
	preserve
		loc y total
		replace `y'=`y'/1000	// rescale
		qui qreg2 `y' i.(`x' $tvars $xvars clinic), cluster($cl)
		eststo: margins, dydx(clinic) post
		sum `y' if clinic==0 & e(sample)==1
		test_effects
	restore 
			
	* Log model

	preserve
		loc y _total
		replace `y'=ln(`y')
		eststo: reghdfe `y' i.(`x' clinic), cluster($cl) abs($tvars $xvars)
		sum `y' if clinic==0 & e(sample)==1
		test_effects
	restore 

	esttab using "$out/tab_total", $posttext mtitles("Spending (N000's)" "Spending (N000's)" "Spending (N000's)" "Log spending") $scalar 

	
/*------------------------------------------------------------------------------------------------------
	Table 3: How did health workers allocate the capital?
-------------------------------------------------------------------------------------------------------*/

	loc yvars _incent _equip _infra _supp _staff _run _outreach 
	loc label \textsc{Incentives} \textsc{Equipment} \textsc{Renovation} \textsc{Supplies} \textsc{Staff} \textsc{Running} \textsc{Outreach} 
	loc x lab 
	loc it logit

	eststo clear
	foreach y of local yvars {
		preserve
			replace `y'=`y'/1000	// rescale		
			twopm `y' i.(`x' $xvars $tvars clinic), f(`it', asis) s(glm, family(gamma) link(log)) vce(cl $cl)
			eststo: margins, dydx(clinic) post
			count if e(sample)==1
			loc den=r(N) 
			count if `y'==0 & e(sample)==1
			loc num=r(N) 
			scalar n=`num'/`den'
			estadd sca n
			sum `y' if e(sample) & clinic==0
			test_effects
		restore
	}
	esttab using "$out/tab_spend3", $posttext mtitles(`label') scalars("mean Control mean" "n Fraction of zeros" "test1 p (Grant=Control)" "test2 p (Grant=Encourage)" "test3 p (Grant=Non-Grant)")
	

/*------------------------------------------------------------------------------------------------------
	Table A.2: Effect on spending (simple OLS)
-------------------------------------------------------------------------------------------------------*/

	eststo clear
	loc x lab
	preserve 
		loc y _total
		replace `y'=`y'/1000	// rescale
		
		qui eststo: reghdfe `y' `x' i.( clinic), abs($tvars $xvars) vce(cl $cl)
		sum `y' if clinic==0 & e(sample)==1
		test_effects
	restore
	esttab using "$out/tab_total_ols", $posttext nomtitles $scalar 


/*------------------------------------------------------------------------------------------------------
	Table A.4: How did health workers allocate the capital (Two-part model)
-------------------------------------------------------------------------------------------------------*/

	loc yvars _incent _equip _infra _supp _staff _run _outreach 
	loc label \textsc{Incentives} \textsc{Equipment} \textsc{Renovation} \textsc{Supplies} \textsc{Staff} \textsc{Running} \textsc{Outreach} 
	loc x lab 
	loc it logit

	* Extensive margin

	eststo clear
	foreach y of local yvars {
		preserve
			replace `y'=`y'>0	
			qui `it' `y' i.(`x' $xvars $tvars clinic), asis vce(cl $cl)
			eststo: margins, dydx(clinic) post
			sum `y' if e(sample) & clinic==0
			test_effects
		restore
	}
	esttab using "$out/tab_spend1", $posttext mtitles(`label') $scalar

	* Intensive margin

	eststo clear
	foreach y of local yvars {
		preserve
			replace `y'=`y'/1000	// rescale		
			qui glm `y' i.(`x' $xvars $tvars clinic) if `y'>0, family(gamma) link(log) vce(cl $cl)
			eststo: margins, dydx(clinic) post
			sum `y' if e(sample) & clinic==0
			test_effects		
		restore
	}
	esttab using "$out/tab_spend2", $posttext nonum mtitles(`label') $scalar

/*------------------------------------------------------------------------------------------------------
	Table A.5: How did health workers allocate the capital (OLS)
-------------------------------------------------------------------------------------------------------*/

	preserve
		eststo clear
		foreach y of local yvars {
			replace `y'=`y'/1000	// rescale	
			qui reghdfe `y' i.(`x' clinic), vce(cluster $cl) abs($xvars $tvars) 
			eststo: margins, dydx(clinic) post
			sum `y' if e(sample) & clinic==0
			test_effects
		}
		esttab using "$out/tab_spend_ols", $posttext mtitles(`label')  $scalar 
	restore

/*------------------------------------------------------------------------------------------------------
	Table A.6: How did health workers allocate the capital (extensive/intensive margins)
-------------------------------------------------------------------------------------------------------*/

	loc yvars _incent _equip _infra _supp _staff _run _outreach 
	loc label \textsc{Incentives} \textsc{Equipment} \textsc{Renovation} \textsc{Supplies} \textsc{Staff} \textsc{Running} \textsc{Outreach} 
	loc x lab 
	eststo clear
	foreach y of local yvars {
		preserve
			replace `y'=`y'>0	
			eststo: reghdfe `y' i.(`x' clinic), abs($xvars $tvars) vce(cl $cl)
			sum `y' if e(sample) & clinic==0
			test_effects	
		restore
	}
	esttab using "$out/tab_spendlog1", $posttext mtitles(`label') $scalar

	eststo clear
	foreach y of local yvars {
		preserve
			replace `y'=ln(`y')		
			eststo: reghdfe `y' i.(`x' clinic), abs($xvars $tvars) vce(cl $cl)
			sum `y' if e(sample) & clinic==0
			test_effects		
		restore
	}
	esttab using "$out/tab_spendlog2", $posttext nonum mtitles(`label') $scalar



/*------------------------------------------------------------------------------------------------------
	Did the grant crowd out other sources of external funding?
-------------------------------------------------------------------------------------------------------*/

	use "${db_Clean}/sds_month", clear
	merge m:1 hfac using "${data}/bl", nogen
	merge m:1 hfac using "${db_Clean}/treatment", nogen	keep(3)	// treatment indicators

	* One clinic in Kano reported one million in state funding. The next highest amount for Kano is 57,600. Likely one too many zeros. Correcting error.

		replace r_sg_tot=100000 if r_sg_tot==1000000


/*------------------------------------------------------------------------------------------------------
	Figure A.5: Payments received from a non-governmental organization
-------------------------------------------------------------------------------------------------------*/

* Histogram of payments received from an NGO

	label define clinic 0 Control 1 Encourage 2 Grant, modify
	label values clinic clinic
	#delimit;
		hist r_ngo_tot if r_ngo_tot>0, frac width(10000) 
		by(, title("") caption(`""') 
		note(`""')) by(clinic, row(1))  by(, legend(off))
		 by(clinic) xti("") saving("$out/ngofunds", replace)
		 ysc(range(.2 1)) xla(0(50000)400000, angle(90) labsize(small));
		 gr export "$out/ngofunds.eps", as(eps) preview(off) replace;
	#delimit cr


/*------------------------------------------------------------------------------------------------------
	Table A.3: Did the grant crowd out other sources of external funding?
-------------------------------------------------------------------------------------------------------*/

* Exclude grant payments

	loc funds r_fg_tot r_sg_tot r_lg_tot r_ins_tot r_ngo_tot r_comm_tot r_phil_tot r_s_oth_tot

	loc v funds
	replace r_ngo_tot=0 if inlist(r_ngo_tot,50000) & clinic==2
	egen `v'= rowtotal(`funds')
	g any`v'=`v'>0
	g log`v'=ln(`v')

	loc v funds2
	replace r_ngo_tot=0 if inlist(r_ngo_tot,150000) & clinic==2
	egen `v'= rowtotal(`funds')
	g any`v'=`v'>0
	g log`v'=ln(`v')

	loc x lab
			
	eststo clear
	foreach y in anyfunds logfunds anyfunds2 logfunds2 {
		qui eststo:reghdfe `y' i.(`x' clinic), cl($cl) abs($xvars $tvars)
		sum `y' if clinic==0 & e(sample)==1
		test_effects
	}
	#delimit;
		esttab using "$out/tab_crowdout", $posttext $scalar
		mtitle("Any funds" "Log funds" "Any funds" "Log funds")
		mgroups("Excludes any N50,000 payments" "Excludes any N150,000 payments", pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}));
	#delimit cr
