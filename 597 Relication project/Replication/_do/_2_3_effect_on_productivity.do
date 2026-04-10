/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	**This file prepares the following:
		
			
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
			-	Figure A.17: Heterogeneity by financial need
			-	Figure A.18: Heterogeneity by in-charge experience		
			
			
		*** Also calls _2_3_0_hetvars.do that generates the following:
		
			*Datasets:
				- "${data}/hetvars"
				
			*Figures:
			-	Figure A.16: Baseline spending – Top 50% vs. Bottom 50% of clinics 
			-	Figure A.19: Correlation between action share and budget share
			-	Figure A.20: Did grant clinics prioritize incentives or infrastructure?  
			-	Figure A.21: Predicted grant allocation
			-	Figure A.22: Validating the predicted incentive-infrastructure index	
=========================================================================================================*/


/*------------------------------
	Preamble
 -------------------------------*/
 
	clear all
	set more off
	set seed 123	// set seed


/*---------------------------------------------------------------------------------------------
	Prerequisite: Process and analyze heterogeneity variables 
-----------------------------------------------------------------------------------------------

		* Note: This is run on the following do file that generates the following:
					*Datasets:
						- "${data}/hetvars"
						
					*Figures:
					-	Figure A.16: Baseline spending – Top 50% vs. Bottom 50% of clinics 
					-	Figure A.19: Correlation between action share and budget share
					-	Figure A.20: Did grant clinics prioritize incentives or infrastructure?  
					-	Figure A.21: Predicted grant allocation
					-	Figure A.22: Validating the predicted incentive-infrastructure index*/
					
			do "${replication_do}/_2_3_0_hetvars"
		
		
		*Also, calling custom programs required to compute tests
			do "${replication_do}/programs"
*--------------------------------------------------------------------------------------------


/*---------------------------------------------------------------------------------------------
	Read in SDS - monthly data
---------------------------------------------------------------------------------------------*/
			
	use "${db_Clean}/sds_month", clear	
	merge m:1 hfac using "${data}/bl", nogen 			// baseline facility controls
	merge m:1 hfac using "${db_Clean}/treatment", nogen	keep(3)	// treatment indicators
	merge m:1 hfac using "${data}/hetvars", nogen		//  heterogeneity variables (see note above: Prerequisite)

	* Identify outliers

		ren *_tot *

		foreach y of varlist opd-mon {
			
			//Ignoring if string variable (applicable for *_oth_spec variables)
			//Only processing numeric variables
			capture confirm numeric variable `y'
				if _rc == 0 {
						
				label var `y' "`=strltrim(substr("`: var lab `y''"),5,.)'" 	
				tempvar x
				qui bys hfac: egen `x'=std(`y')
				g out_`y'=`x'>4 & `x'<. 
				g _`y'=`y'
				g x1=`y' if out_`y'==0 
				bys hfac: egen x2=pctile(x1), p(99)
				replace `y'=x2 if x1==.		// Top code outliers at 99th percentile value 
				drop x?
			}			
		}


	* Baseline clinic output

	ren (rec_pats rec_inpats) (rec_opd rec_inp)
	g rec_imm=0			// no baseline 
	g rec_mon=rec_del	// no baseline. Use deliveres to proxy 
	order rec_imm rec_mon, after(rec_inp)

	* Impute missing values for clinic without baseline

	foreach v of varlist rec_* {
		bys sid: egen x=mean(`v')		// state mean
		replace `v'=x if missing(`v') 	// replace missing with state mean
		drop x
	}

/*------------------------------------------------------------------------------------------------------
	Table 4: Effect on output
-------------------------------------------------------------------------------------------------------*/

	keep if month>=td(01Jun2019)	// observation period

	loc yvars anc del mon imm opd inp
	loc x lab open24
	loc scalars "scalars("mean Control mean" "test1 p (Grant = Control)" "test2 p (Grant = Encourage)" "test3 p (Grant = Non-Grant)") sfmt(%9.1f %9.3f)"
	loc label " "\shortstack{Antenatal\\visits}" "\shortstack{Baby\\deliveries}"  "\shortstack{Postnatal\\visits}" "\shortstack{Child\\immunizations}" "\shortstack{Outpatient\\visits}" "\shortstack{Inpatient\\admissions}" "
	loc link "link(log) fam(nb) vce(cl $cl)"

	eststo clear
	foreach y of local yvars {
		qui glm `y' rec_`y' i.(`x' $xvars $tvars clinic), `link'
		eststo: margins, dydx(clinic) post 
		count if out_`y'==1 
		scalar n=r(N)
		estadd sca n
		sum `y' if e(sample) & clinic==0
		test_effects
	}
	esttab using "$out/tab_output", $posttext mtitles(`label') scalars("n No. of outliers" "mean Control mean"  "test1 p (Grant = Control)" "test2 p (Grant = Encourage)" "test3 p (Grant = Non-Grant)") sfmt(%9.0f %9.1f %9.3f)


/*------------------------------------------------------------------------------------------------------
	Table A.13: Effect on output (OLS with log transformations)
-------------------------------------------------------------------------------------------------------*/

	preserve
		eststo clear
		foreach y in anc {
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
	
	foreach y in del mon {
		preserve
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
	
	preserve	
	foreach y in imm opd {
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
	
	foreach y in inp {
		preserve
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
	
	#delimit;
		esttab using "$out/tab_output_log", $posttext mtitles("" "Y>0" "Ln(Y)" "Y>0" "Ln(Y)" "" "" "Y>0" "Ln(Y)")
		scalars("n Fraction of zeros" "mean Control mean"  "test1 p (Grant = Control)" 
		"test2 p (Grant = Encourage)" "test3 p (Grant = Non-Grant)") sfmt(%9.3f) 
		mgroups(`label' ,  pattern(1 1 0 1 0 1 1 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) 
		span erepeat(\cmidrule(lr){@span}));
	#delimit cr


/*------------------------------------------------------------------------------------------------------
	Table A.14: Effect on output (scaling by baseline values)
-------------------------------------------------------------------------------------------------------*/

	foreach v in anc del opd inp {
		cap drop frac_`v'
		bys clinic: egen x=mean(rec_`v')
		g frac_`v'=`v'/x
		drop x
	}
	loc v mon
		bys clinic: egen x=mean(rec_del)	// scale by deliveries for postnatal 
		cap drop frac_`v'
		g frac_`v'=`v'/x
		drop x
	loc v imm
		bys clinic: egen x=mean(rec_anc)	// scale by anc for immunizations
		cap drop frac_`v'
		g frac_`v'=`v'/x
		drop x
		
	eststo clear
	foreach y of local yvars {
		eststo: reghdfe frac_`y' i.(`x' clinic), vce(cl $cl) abs($xvars $tvars)
		sum frac_`y' if e(sample) & clinic==0
		test_effects
	}
	esttab using "$out/tab_output_scale", $posttext mtitles(`label') `scalars'
		

/*------------------------------------------------------------------------------------------------------
	Table A.15: Effect on output (excluding outliers)
-------------------------------------------------------------------------------------------------------*/
		
	eststo clear
	foreach y of local yvars {
		preserve
			drop if out_`y'==1
			qui glm `y' rec_`y' i.(`x' $xvars $tvars clinic), `link'
			eststo: margins, dydx(clinic) post 
			sum `y' if clinic==0 & e(sample)==1
			test_effects
		restore
	}
	esttab using "$out/tab_outlier", $posttext mtitles(`label') `scalars'


/*------------------------------------------------------------------------------------------------------
	Table A.16: Effect on output (excluding Gombe state)
-------------------------------------------------------------------------------------------------------*/

	preserve
		drop if sid==2
		eststo clear
		foreach y of local yvars {
			qui glm `y' rec_`y' i.(`x' $xvars $tvars clinic), `link'
			eststo: margins, dydx(clinic) post 
			sum `y' if clinic==0 & e(sample)==1
			test_effects
		}
	restore
	esttab using "$out/tab_nogom", $posttext mtitles(`label') `scalars'


/*------------------------------------------------------------------------------------------------------
	Table A.17: Effect on output (excluding pandemic months)
-------------------------------------------------------------------------------------------------------*/

	preserve
		drop if month>=td(01Mar2020)
		eststo clear
		foreach y of local yvars {
			qui glm `y' rec_`y' i.(`x' $xvars $tvars clinic), `link'
			eststo: margins, dydx(clinic) post 
			sum `y' if clinic==0 & e(sample)==1
			test_effects
		}
	restore
	esttab using "$out/tab_covid", $posttext mtitles(`label') `scalars'


/*------------------------------------------------------------------------------------------------------
	Table A.18: Effect on output (excluding clinics in areas where demand-side incentives were offered)
-------------------------------------------------------------------------------------------------------*/

	preserve
		drop if cash>0
		eststo clear
		foreach y of local yvars {
			qui glm `y' rec_`y' i.(`x' $xvars $tvars clinic), `link'
			eststo: margins, dydx(clinic) post 
			sum `y' if clinic==0 & e(sample)==1
			test_effects
		}
	restore
	esttab using "$out/tab_nocct", $posttext mtitles(`label') `scalars'


/*------------------------------------------------------------------------------------------------------
	Table A.19: Effect on output (all interactions)
-------------------------------------------------------------------------------------------------------*/

	g cash1=cash>0		// binary incentive treatment
	foreach y in inp {
		g new`y'=`y'>0
	}

	loc x lab open24
	loc scalars "scalars("mean Control mean" "test1 p (Grant = Control)" "test2 p (Grant = Encourage)" "test3 p (Grant = Non-Grant)") sfmt(%9.0f %9.2f)"
	loc link "link(log) fam(nb) vce(cl $cl)"
	loc label " "0 0" "0 1" "1 0" "1 1" "
	loc posttext "replace keep(1.clinic 2.clinic) b(%9.1f) se(%9.1f) nonum noconstant nonotes label nostar eqlabels(" " " ") coeflabel(1.clinic "Encourage" 2.clinic "Grant") booktabs width(\hsize)"

	eststo clear
	foreach y in anc del mon {
		foreach cash in 0 1 {
			foreach risk in 0 1 {
				qui glm `y' rec_`y' i.(`x' sid $tvars clinic) if cash1==`cash' & risk==`risk', `link' 
				eststo: margins, dydx(clinic) post 
				sum `y' if e(sample) & clinic==0
				test_effects
			}
		}
	}
	esttab using "$out/tab_interactA", `posttext' mtitles(`label' `label' `label') `scalars' mgroups("Antenatal visits" "Baby deliveries" "Postnatal visits", pattern(1 0 0 0 1 0 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

	eststo clear
	foreach y in imm opd {
		foreach cash in 0 1 {
			foreach risk in 0 1 {
				qui glm `y' rec_`y' i.(`x' sid $tvars clinic) if cash1==`cash' & risk==`risk', `link' 
				eststo: margins, dydx(clinic) post 
				sum `y' if e(sample) & clinic==0
				test_effects
			}
		}
	}
	loc scalars "scalars("mean Control mean" "test1 p (Grant = Control)" "test2 p (Grant = Encourage)" "test3 p (Grant = Non-Grant)") sfmt(%9.2g %9.2f)"
	loc posttext "replace keep(1.clinic 2.clinic) b(%9.2f) se(%9.2f) nonum noconstant nonotes label nostar eqlabels(" " " ") coeflabel(1.clinic "Encourage" 2.clinic "Grant") booktabs width(\hsize)"
	foreach y in newinp {
		foreach cash in 0 1 {
			foreach risk in 0 1 {
				reghdfe `y' rec_inp i.(`x' sid $tvars clinic) if cash1==`cash' & risk==`risk', vce(cl $cl)
				eststo: margins, dydx(clinic) post 
				sum `y' if e(sample) & clinic==0
				test_effects
			}
		}
	}
	esttab using "$out/tab_interactB", `posttext' mtitles(`label' `label' `label') `scalars' mgroups("Child immunizations" "Outpatient visits" "Any inpatient admissions", pattern(1 0 0 0 1 0 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
		
		
/*------------------------------------------------------------------------------------------------------
	Figure A.17: Heterogeneity by financial need
-------------------------------------------------------------------------------------------------------*/

	foreach y of local yvars {
		loc a : variable label `y'
		loc e blue%35
		loc g red
		loc d spend
		loc t clinic
		loc x lab open24
		qui glm `y' rec_`y' i.(`x' $tvars $xvars) `t'##`d', link(log) fam(nb) vce(cl $cl)
		qui margins `d', dydx(`t') post 
		#delimit;
			mplotoffset, recast(scatter) ti("`a'") yti("") saving("$out/`y'_`d'", replace)
			legend(order(3 "Encourage" 4 "Grant") rows(1))
			xti("", margin(b=2) size(medium)) level(90) yli(0, lp(dash))
			xla(-.5 " " 0 "Haves" 1 "Havenots" 1.5 " ", notick labgap(3) valuelab) scheme(s1mono)
			plot1opt(lc(`e') mc(`e')) ci1opt(lc(`e')) plot2opt(lc(`g') mc(`g')) ci2opt(lc(`g'));
		#delimit cr
	}
	cd "$out"
	grc1leg2 anc_`d'.gph del_`d'.gph mon_`d'.gph imm_`d'.gph opd_`d'.gph inp_`d'.gph, iscale(*.8) loff
	gr export het`d'.eps, as(eps) preview(off) replace 


/*------------------------------------------------------------------------------------------------------
	Figure A.18: Heterogeneity by in-charge experience
-------------------------------------------------------------------------------------------------------*/

	xtile exp=clinic_exp_y, nq(2) 
	replace exp=exp-1

	eststo clear
	foreach y of local yvars {
		loc a : variable label `y'
		loc e blue%35
		loc g red
		loc d exp
		qui glm `y' i.($xvars $tvars) clinic##`d', link(log) fam(nb) vce(cl $cl)
		qui margins `d', dydx(clinic) post
		#delimit;
			mplotoffset, recast(scatter) ti("`a'") yti("") saving("$out/`y'_`d'", replace)
			legend(order(3 "Encourage" 4 "Grant") rows(1)) level(90) xti("") scheme(s1mono) yli(0, lp(dash)) 
			xla(-.5 " " 0  `" "Less" "experience" "' 1 `" "More" "experience" "' 1.5 " ", notick labgap(3) valuelab) 
			plot1opt(lc(`e') mc(`e')) ci1opt(lc(`e')) plot2opt(lc(`g') mc(`g')) ci2opt(lc(`g')) ;
		#delimit cr
	}
	cd "$out"
	grc1leg2 anc_`d'.gph del_`d'.gph mon_`d'.gph imm_`d'.gph opd_`d'.gph inp_`d'.gph, iscale(*.8) 
	gr export oic`d'.eps, as(eps) preview(off) replace 


/*------------------------------------------------------------------------------------------------------
	Table 8: Which investments were most effective?
-------------------------------------------------------------------------------------------------------*/

	eststo clear
	foreach y of varlist anc del mon opd inp {
		loc v xcat
		cap drop frac_`y'
		bys `v': egen x=mean(rec_`y')
		g frac_`y'=`y'/x
		drop x
		eststo: reghdfe frac_`y' i.`v', vce(cl $cl) abs($xvars $tvars) 
		su frac_`y' if e(sample) & clinic<2
		estadd r(mean)
	}
	#delimit;
		esttab using "$out/tab_output_index", replace b(%9.3f) se(%9.3f) noconstant nonotes label 
		nobase nostar eqlabels(" " " ") booktabs width(\hsize) 
		mtitles("\shortstack{Antenatal\\visits}" "\shortstack{Baby\\deliveries}" 
		"\shortstack{Postnatal\\visits}"  "\shortstack{Outpatient\\visits}" 
		"\shortstack{Inpatient\\admissions}") scalars("mean Control mean");
	#delimit cr


/*------------------------------------------------------------------------------------------------------
	Figure 7: What is responsible for the increase in clinic output?
-------------------------------------------------------------------------------------------------------*/

	foreach y of local yvars {
		loc a : variable label `y'
		loc e blue%35
		loc g red
		loc d z
		loc t clinic
		qui glm `y' rec_`y' i.($tvars $xvars) `t'##c.`d'##c.`d', link(log) fam(gamma) vce(cl $cl)
		margins, dydx(`t') at(`d'=(-0.4(.2).4)) 
		#delimit;
			marginsplot, ti("`a'") yti("") saving("$out/`y'_`d'", replace)
			legend(order(3 "Encourage" 4 "Grant") rows(1)) scheme(s1mono)
			xti("") level(90) xlab(-.4(.2).4, tlength(*.5) labsize(small))
			xmla(-.3 `"" "<--- Prioritize Incentives"' .3 `"" "---> Prioritize Infrastructure"', 
			notick labs(small))
			plot1opt(lc(`e') mc(`e')) ci1opt(lc(`e')) plot2opt(lc(`g') mc(`g')) ci2opt(lc(`g'));
		#delimit cr
	}
	cd "$out"
	#delimit;
		grc1leg2 anc_`d'.gph del_`d'.gph mon_`d'.gph imm_`d'.gph opd_`d'.gph inp_`d'.gph, iscale(*.8);
		gr export hetpred.eps, as(eps) preview(off) replace;
	#delimit cr
	
	
/*------------------------------------------------------------------------------------------------------
	Figure A.10: Were grant clinics more likely to maintain utilization records?
-------------------------------------------------------------------------------------------------------*/

	*Reading in SDS data
	use "${db_Clean}/sds", clear
		
		merge m:1 hfac using "${db_Clean}/treatment", nogen	keep(3)	// treatment indicators

		label var anc_yes "Antenatal records"   
		label var del_yes "Delivery records"
		label var imm_yes "Immunization records"
		label var opd_yes "Outpatient records"
		label var inp_yes "Inpatient records"

		loc d visit
		loc e blue%35
		loc g red

		foreach y in anc_yes del_yes imm_yes opd_yes inp_yes {
			loc a : variable label `y'
			reghdfe `y' clinic##`d', abs($xvars) cl($cl)
			margins `d', dydx(clinic) post 
			#delimit;
				mplotoffset, recast(scatter) saving("$out/`y'", replace) ti("") subti("`a'") xt("")
				yti("Treatment effect") level(90)
				legend(order(3 "Encourage" 4 "Grant") ring(0) pos(10) rows(1) size(small) region(lw(none))) 
				xla(1 "SDS-1" 2 "SDS-2" 3 "SDS-3" 4 "SDS-4", notick labgap(2) labs(small)) 
				scheme(s1mono) yli(0, lp(dash))  yla(-.2(.1).2) plot1opt(lc(`e') mc(`e') lp(`p')) 
				ci1opt(lc(`e') lp(`p')) plot2opt(lc(`g') mc(`g')) ci2opt(lc(`g'));
			#delimit cr
		}
		cd "$out"
		grc1leg2 anc_yes.gph del_yes.gph imm_yes.gph opd_yes.gph inp_yes.gph, iscale(*.8) ///
		col(2) xsize(2) ysize(2) scheme(s1mono)  lxo(25) lyo(20)
		gr export records.eps, as(eps) preview(on) replace 
