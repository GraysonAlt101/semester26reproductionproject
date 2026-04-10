/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	**This file prepares the following:
			
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
			-	Figure A.15: Mortality gains accrue to the least well-off households		
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
	Read in woman endline data
---------------------------------------------------------------------------------------------*/

	use "${data}/elwoman", clear			
	
	merge m:1 hfac using "${data}/blpredict", nogen 	// extensive baseline controls


/*------------------------------------------------------------------------------------------------------
	Table A.8: Verifying fee discounts in the household survey data
-------------------------------------------------------------------------------------------------------*/

	eststo clear
	foreach y in freeanc freedel {
		loc x lab 
		eststo: reghdfe `y' `x' i.clinic, cluster($cl) abs($xvars $tvars)
		sum `y' if clinic==0 & e(sample)==1
		test_effects
	}
	foreach y in lab_cost drugs_cost  {
		qui glm `y' i.(`x' $xvars $tvars clinic), link(log) fam(gamma) vce(cl $cl)
		eststo: margins, dydx(clinic) post 
		sum `y' if e(sample) & clinic==0
		test_effects
	}
	#delimit;
	esttab using "$out/tab_freecare", $posttext $scalar 
	mtitle("\shortstack{Paid nothing \\for antenatal}" "\shortstack{Paid nothing \\for delivery}" 
	"\shortstack{Cost of \\lab tests}" "\shortstack{Cost of \\drugs}");
	#delimit cr


/*------------------------------------------------------------------------------------------------------
	Table A.22: Increased utilization of grant clinics
-------------------------------------------------------------------------------------------------------*/

	recode bl_mschool (0=0 "None")(1=1 "Pry. school")(2=2 "Sec. school")(3=3 "Tert. school"), g(school)
	recode bl_wealth (1=1 "Wealth quartile 1")(2=2 "Wealth quartile 2")(3=3 "Wealth quartile 3")(4=4 "Wealth quartile 4"), g(wealth)
		
	loc controls "controls(($xvars i.$tvars) i.(renov open24 serv1 lab backup_av ambulance_av eq?_av eq??_av bl_mschool bl_wealth bl_age health)) sel(adaptive) nolog rseed(1)"

	foreach y in delphc {
		eststo clear
		eststo: dsregress `y' i.clinic, vce(cl $cl) `controls'  
		sum `y' if clinic==0 & e(sample)==1
		estadd r(mean)
		
		foreach d in school wealth {
			loc a : variable label `d'
			eststo: eststo: dsregress `y' i.clinic##`d', vce(cl $cl) `controls'
			sum `y' if clinic==0 & e(sample)==1
			estadd r(mean)
		}
		#delimit;
			esttab using "$out/tab_`y'", replace b(%9.3g) se(%9.3g) keep(?.clinic*) 
			noconstant label nonotes booktabs width(\hsize) nobase nostar eqlabels(" " " ") 
			nomtitle scalars("mean Control mean");
		#delimit cr
	}


/*------------------------------------------------------------------------------------------------------
	Table A.23: Effect on early-life mortality (Intent-to-Treat)
-------------------------------------------------------------------------------------------------------*/

	eststo clear
	foreach y in lossmort stillmort neomort {	
		eststo: dsregress `y' i.clinic, vce(cl $cl) `controls'  
		sum `y' if clinic==0 & e(sample)==1
		test_effects
	}
	#delimit;
		esttab using "$out/tab_mortitt", replace b(%9.3g) se(%9.3g) keep(?.clinic) 
		noconstant label nonotes booktabs width(\hsize) nobase nostar eqlabels(" " " ")  
		$scalar mtitle("Fetal loss" "Fetal death" "Newborn death");
	#delimit cr


/*------------------------------------------------------------------------------------------------------
	Table 6: Effect on early-life mortality
-------------------------------------------------------------------------------------------------------*/

	* Endogenous variables and instruments

		tempvar cashxenc cashxgrant carexenc carexgrant
		loc v usedcare
		loc d cash1
		g `cashxenc'=`d'==1 & clinic==1
		g `cashxgrant'=`d'==1 & clinic==2
		g `carexenc'=`v'==1 & clinic==1
		g `carexgrant'=`v'==1 & clinic==2

		* Macros

		loc ind bl_priormisc bl_priorst bl_wealth bl_age bl_msc health
		loc controls sid##risk month `ind' 
		loc mort lossmort stillmort neomort
		loc endog `v' `carexenc' `carexgrant'
		loc instr `d' `cashxenc' `cashxgrant'
		loc title " "Fetal loss" "Fetal death" "Newborn death" "
			
		eststo clear 
		foreach y of local mort {
				eststo: ivreg2 `y' i.(`controls' clinic) (`endog' =`instr'), cl($cl)
			}
		#delimit;
			esttab using "$out/tab_mortiv", replace keep(`endog') b(%9.3f) se(%9.3f)
			noconstant label nonotes nostar mtitle(`title') booktabs width(\hsize) eqlabels(" " " ") 
			coeflabels(`v' "Mother used health care" `carexenc' "Health care x Encourage" `carexgrant' "Health care x Grant") 
			scalars("rkf First-stage F-statistic") sfmt(%9.1f);
		#delimit cr	


/*------------------------------------------------------------------------------------------------------
	Table A.24: Effect on early-life mortality (IV)
-------------------------------------------------------------------------------------------------------*/

	tempvar covid
	g `covid'=bl_due_date>=td(01feb2020) 	// pandemic start date

	eststo clear 
	foreach i in 0 1 {
		foreach y of local mort {
			eststo: ivreg2 `y' i.(`controls' clinic) (`endog' =`instr') if `covid'==`i', cl($cl)
		}
	}
	#delimit;
		esttab using "$out/tab_mort_covid", replace keep(`endog') b(%9.3f) se(%9.3f)
		noconstant label nonotes nostar mtitle(`title' `title') booktabs width(\hsize) eqlabels(" " " ") 
		coeflabels(`v' "Mother used health care" `carexenc' "Health care x Encourage" `carexgrant' "Health care x Grant") 
		scalars("rkf First-stage F-statistic") sfmt(%9.1f) 
		mgroups("Unexposed sample" "Exposed sample", pattern(1 0 0 1 0 0) 
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}));
	#delimit cr	



/*------------------------------------------------------------------------------------------------------
	Figure A.13: Effect of the conditional incentive on health care utilization
-------------------------------------------------------------------------------------------------------*/

	loc y delphc
	qui reghdfe `y' clinic##cash1, cl($cl) abs(sid#risk $tvars)
	margins clinic, dydx(cash) 
	#delimit;
		loc e red;
		marginsplot, title("", margin(b=3)) yti("Proportion") xti("") scheme(s1mono)
		 xla(0 "Control" 1 "Encourage" 2 "Grant", notick labgap(3)) 
		 ysc(range(0 .5)) yla(0(.1).5) level(90)
		plotopt(lc(`e') mc(`e')) ciopt(lc(`e'));
		gr export "$out/cash_`y'.eps", as(eps) preview(off) replace;
	#delimit cr


/*------------------------------------------------------------------------------------------------------
	Figure A.14: Do incentive compliers in grant areas have more risky characteristics?
-------------------------------------------------------------------------------------------------------*/

	foreach v in bl_priormisc bl_priorstill {
		label values `v' yn
	}
	label define a 0 "None" 1 "Pry." 2 "Sec." 3 "Tert.", replace
	label values bl_?school a
	label define b 1 "<18" 2 "18-24." 3 "25-34" 4 "35+", replace
	label values bl_agegroup b

	loc y usedcare
	loc t cash1
	loc c gs10
	loc e blue
	loc g red
	foreach d in bl_priormisc bl_priorstill bl_del_first {
		loc a : variable label `d'
		reghdfe `y' clinic##`t'##`d', abs(sid#risk $tvars) cl($cl)
		margins `d', dydx(`t') over(clinic)
		#delimit;
			mplotoffset, recast(scatter) saving("$out/`t'_`d'", replace) ti("") subti("`a'") xt("")
			yti("Treatment effect") legend(rows(1))  level(90)
			ysc(range(0 .4)) yla(0(.1).4) xla(, labgap(2) labs(small)) scheme(s1mono) 
			plot1opt(lc(`c') mc(`c')) ci1opt(lc(`c')) plot2opt(lc(`e') mc(`e')) ci2opt(lc(`e')) 
			plot3opt(lc(`g') mc(`g')) ci3opt(lc(`g'));
		#delimit cr
	}
	foreach d in bl_agegroup bl_mschool bl_wealth {
		loc a : variable label `d'
		reghdfe `y' clinic##`t'##`d', abs(sid#risk $tvars) cl($cl)
		margins `d', dydx(`t') over(clinic)
		#delimit;
			mplotoffset, recast(scatter) saving("$out/`t'_`d'", replace) ti("") subti("`a'") xt("")
			yti("Treatment effect") legend(rows(1))  level(90)
			ysc(range(0 .4)) yla(0(.1).4) xla(, labgap(2) labs(small)) scheme(s1mono) 
			plot1opt(lc(`c') mc(`c')) ci1opt(lc(`c')) plot2opt(lc(`e') mc(`e')) ci2opt(lc(`e')) 
			plot3opt(lc(`g') mc(`g')) ci3opt(lc(`g'));
		#delimit cr
	}
	cd "$out"
	loc t cash1
	grc1leg2 `t'_bl_priormisc.gph `t'_bl_priorstill.gph `t'_bl_del_first.gph `t'_bl_agegroup.gph `t'_bl_mschool.gph `t'_bl_wealth.gph, iscale(*.8) col(3) xsize(2) ysize(1.5) 
	gr export cash_selection.eps, as(eps) preview(off) replace 

	
/*------------------------------------------------------------------------------------------------------
	Table 7: Effect on childhood mortality
-------------------------------------------------------------------------------------------------------*/
	
	use "${data}/othchild", clear
	
	merge m:1 hfac using "${data}/blpredict", nogen 	 // extensive baseline controls

	loc vars "renov open24 serv1 lab backup_av ambulance_av eq?_av eq??_av bl_mschool bl_wealth bl_age male"
	loc options "sel(adaptive) nolog rseed(1)"
	eststo clear
	foreach y in mort {	
		eststo: dsregress `y' i.clinic, vce(cl $cl) controls(($xvars i.$tvars) i.(`vars')) `options'
		sum `y' if clinic==0 & e(sample)==1
		test_effects
		
		* Exclude areas with cash incentives 
		eststo: dsregress `y' i.clinic if cash==0, vce(cl $cl) controls(($xvars i.$tvars) i.(`vars')) `options'
		sum `y' if clinic==0 & e(sample)==1
		test_effects
		
		* Further exclude areas where information was provided 
		eststo: dsregress `y' i.clinic if cash==0 & risk==0, vce(cl $cl) controls(($xvars i.$tvars) i.(`vars')) `options'
		sum `y' if clinic==0 & e(sample)==1
		test_effects
	}
	esttab using "$out/tab_mort", replace b(%9.4f) se(%9.4f) keep(?.clinic) noconstant label nonotes booktabs width(\hsize) nobase nostar nomtitle eqlabels(" " " ") coeflabel(1.clinic "Encourage" 2.clinic "Grant") $scalar sfmt(%9.3f) 


/*------------------------------------------------------------------------------------------------------
	Figure A.15: Mortality gains accrue to the least well-off households
-------------------------------------------------------------------------------------------------------*/

	g grant=clinic==2	

	foreach d in bl_wealth bl_mschool {
		loc a : variable label `d'
		loc g red
		loc t grant
		loc y mort 
		qui reghdfe `y' `t'##`d', abs($xvars month) vce(cl $cl)
		eststo: margins `d', dydx(`t')
		#delimit;
			marginsplot, recast(scatter) ti("`a'") yti("Mortality") saving("$out/mort_`d'", replace)
			xti("") level(90) scheme(s1mono) xla(, notick labgap(3)) yli(0, lc(gs10) lp(dash))
			plotopt(lc(`g') mc(`g')) ciopt(lc(`g'));
		#delimit cr
	}
	cd "$out"
	#delimit;
		grc1leg2 mort_bl_wealth.gph mort_bl_mschool.gph, iscale(*.9) loff ycomm ysize(1.5) xsize(3);
		gr export hetmort.eps, as(eps) preview(off) replace;
	#delimit cr
