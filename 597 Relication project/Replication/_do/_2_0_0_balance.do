/*==================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care
** This file creates Table 1 and Appendix Table A.1 and Figure A.4
** This file also creates the following working datasets: bl.dta and blpredict.dta
====================================================================================*/

/*------------------------------
	Preamble
 -------------------------------*/
 
	clear all
	set more off
	set seed 123	// set seed

 /*---------------------------------------------------------------
	Get datasets  
---------------------------------------------------------------*/	

	tempfile hw vol
	
	use "${db_Clean}/facility_bl_hw", clear	// Staffing 
		*Creating numerical temp id for hwid 
		gen temp_hwid = _n if !missing(hwid)
	
	collapse (count) hws=temp_hwid (mean) present, by(hfac)
	save `hw'
	
	use "${db_Clean}/facility_bl_month", clear // Facility Records 
	collapse rec_pats rec_anc rec_del rec_inpats, by(hfac)
	save `vol'	
	
	// Facility characteristics
	use "${db_Clean}/facility_bl", clear
	
	merge 1:1 hfac using `hw', nogen
	merge 1:1 hfac using `vol', nogen
	merge 1:1 hfac using "${db_Clean}/oic", nogen 	
	
	// Save limited dataset 
	preserve
		keep hfac open24 lab rec_*
		save "${data}/bl", replace
	restore

/*---------------------------------------------------------------
	Prepare variables 
---------------------------------------------------------------*/

	loc var degree
	g `var'=0
	label var `var' "Higher degree"
	foreach x in "B.SC" "BACHELOR" "BSC" "DEGREE" "H.ND" "HND" {
		replace `var'=1 if regexm(cadre_oth,"`x'")					
	}
	g tenure=2020-startyear
	label var tenure "Clinic tenure (years)"
	label var clinic_exp_y "Years of experience"
	label var age "Age"


	g beds=bed_tot if bed_tot<100		// code as missing one clinic with 164 beds (implausible)

	replace level=4 if level_oth=="Cottage"
	replace level_oth="" if level_oth=="Cottage"
	replace level=3 if regexm(level_oth,"Model") | level_oth=="Maternity and Health Center" | level_oth=="Maternity And Health Center"
	replace level_oth="" if regexm(level_oth,"Model") | level_oth=="Maternity and Health Center" | level_oth=="Maternity And Health Center"
	
	qui tab level, g(level)

	g backup=backup_works==1
	
	g water=inlist(water_source,1,2,4)
	label var water "Running water"
	
	g wc=toilet_works==1
	label var wc "Working toilet"
	
	foreach v of varlist drugs?_* {
		replace `v'=0 if drugs_store==0		// no drugs
	}
	egen drugs=rowmean(drugs?_*)
	label var drugs "% of drug list in stock"

	g power=power_source>=1
	replace power=1 if backup_works==1
	label var power "Electricity supply"
	
	* Capture only functional pieces of equipment
		foreach v of numlist 1/23 {
			qui replace eq`v'_av=0 if eq`v'_tot==0
			}
	egen equip=rowmean(eq?_av eq??_av)
	
	egen serv=rowmean(serv*)
	
	* Cost of services
	g anc0=charge_anc1==0 & charge_anc2==0
	label var anc0 "Free prenatal services"
	g del0=charge_del==0 
	label var del0 "Free delivery services"
	
	* Internally generated revenue
	
	replace rev_oth=0 if rev_oth_yes==0	
	loc v revenue
	g `v'=(rev_card+rev_inpat+rev_del+rev_lab+rev_drug+rev_cons+rev_oth)/1000
	qui su `v'			// identify outlier values
	loc out=r(sd)*4		// verified visually that these are actual outliers
	replace `v'=. if `v'>`out' & `v'<. 
	
	* External funding
	
	loc funds funds_fgvt funds_sgvt funds_lgvt funds_ins funds_ngo funds_comm funds_phil
	loc v funds
	egen `v'= rowtotal(`funds')
	replace `v'=`v'/1000
	replace `v'=. if `v'_fgvt_yes==. // no data for one clinic

	foreach x in fgvt sgvt lgvt ins ngo comm phil {		// sources of funding
		replace funds_`x'=. if funds_`x'<10				// code single digit values as missing
		egen funds_`x'_mean=rowmean(funds_`x')			// conditional on any
		replace funds_`x'=0 if funds_`x'_yes==0
	}
	
	g nofunds=0 if funds_fgvt_yes<.	
	replace nofunds=1 if funds_fgvt_yes==0 & funds_sgvt_yes==0 & funds_lgvt_yes==0 & funds_ins_yes==0 &funds_ngo_yes==0 &funds_comm_yes==0 &funds_phil_yes==0 
	label values nofunds yn
	
	* Expenditures
	
	replace exp_oth=0 if exp_oth_yes==0	
	loc v expense
	g `v'=(exp_drug+ exp_equip+ exp_med+ exp_power+ exp_water+ exp_waste+ exp_laundry+ exp_stat+ exp_comm+ exp_fuel+ exp_repair+ exp_renov+ exp_oth)/1000
	g _`v'=`v'
	qui su `v'			// identify outlier values
	loc out=r(sd)*4		// verified visually that these are actual outliers
	replace `v'=. if `v'>`out' & `v'<. 
	
	* There is one additional outlier: a clinic with extremely high expenditure that vastly exceeds total income (internal + external) by a magnitude of 20. Code as missing
	
	g x=expense/(revenue+funds)
	gsort -expense
	g i=_n
	replace expense=. if i<5 & x>20
	drop i x


* Prepare variable labels for LaTeX

	* Remove leading strings
	foreach var of varlist serv? serv?? {
		loc a : variable label `var'
		loc a : subinstr local a "Serv.: " ""
		label var `var' "`a'"
	}
	foreach var of varlist eq*_av {
		loc a : variable label `var'
		loc a : subinstr local a "Equip.: " ""
		label var `var' "`a'"
	}
	
	label var level1 "Level: Health post or dispensary"
	label var level2 "Level: Basic Health Clinic"
	label var level3 "Level: Primary Health Center"
	label var level4 "Level: Comprehensive Health Center"
	label var beds "Number of beds"
	label var open247 "24-hour services"
	label var serv1 "Inpatient services"
	label var serv "Essential services offered"
	label var backup "Backup power generator"
	label var lab "Onsite laboratory" 
	label var drugs "Essential drugs stocked"
	label var equip "Essential equipment"
	label var charge_del "Cost of normal delivery (Naira)"
	label var nofunds "No external funding last 3 mths"
	label var funds "Average external funding last 3 mths (N000's)"
	label var revenue "Total patient revenue last 3 mths (N000's)"
	label var expense "Total spending last 3 mths (N000's)"
	label var hws "Number of health workers"
	label var rec_pats  "Monthly patient count"
	label var rec_anc  "Monthly prenatal visits"
	label var rec_del "Monthly deliveries"
	label var rec_inpats "Monthly admissions"

* Define variable sets

	loc char level1 level2 level3 level4 hws beds backup 
	loc serv open247 serv1 lab drugs equip
	loc rec rec_pats rec_del anc0 del0
	gl fin nofunds funds revenue expense 
	gl vars `char' `serv' `rec' 	


/*------------------------------------------------------------------------------------------------------
	Table 1: Summary Statistics and Tests of Balance
-------------------------------------------------------------------------------------------------------*/

	
	cap file close fh
	cap	macro drop fh 
	cap erase "$out/tab_balance.tex"
	file open fh using "$out/tab_balance.tex", write replace
		file write fh ///
		"\small" ///
		"\begin{tabular}{lccccccc} "_n ///
		"\toprule "_n ///
		" 			&    (1) 	&   (2)		&   (3) 	&  			&  			& 			&  \\"_n ///
		"Variables 	& Control 	& Encourage 	& Grant 	& (1)=(2) 	& (1)=(3) 	& (2)=(3) 	& Joint\\"_n  ///
		"\midrule "_n 

/*---------------------------------------------------------------
	Panel A: Facility characteristics
----------------------------------------------------------------*/
		
file write fh "\multicolumn{8}{p{0.99\textwidth}}{\textbf{Facility characteristics}} \\" 
	
	quietly {
		foreach var of varlist $vars  {
			foreach i of numlist 0/2 {
				su `var' if clinic == `i'
				local `var'_`i' = string(r(mean), "%10.3f")
			}
			reg `var' i.(clinic), r
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
	
		qui mlogit clinic $vars 
		qui test $vars 
		local omni=string(`r(p)', "%10.2f")
		
		file write fh " Omnibus test (p-value) &   &   &  &  &  &  & `omni'  \\"_n ///
		 "\midrule "_n 

/*---------------------------------------------------------------
	Panel B: Financial characteristics
----------------------------------------------------------------*/
	
file write fh "\multicolumn{8}{p{0.99\textwidth}}{\textbf{Financial characteristics}} \\" 
	
	quietly {
		foreach var of varlist $fin  {
			foreach i of numlist 0/2 {
				su `var' if clinic == `i'
				local `var'_`i' = string(r(mean), "%10.3f")
			}
			reg `var' i.(clinic), r
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
	
		qui mlogit clinic $fin 
		qui test $fin 
		local omni=string(`r(p)', "%10.2f")
		
		file write fh " Omnibus test (p-value) &   &   &  &  &  &  & `omni'  \\"_n ///
		 "\midrule "_n 
		 

/*---------------------------------------------------------------
	Panel C: In-charge characteristics
----------------------------------------------------------------*/

file write fh "\multicolumn{8}{p{0.99\textwidth}}{\textbf{In-charge characteristics}} \\" 
	
	quietly {
		loc oic age clinic_exp_y degree tenure
		foreach var of local oic  {
			foreach i of numlist 0/2 {
				su `var' if clinic == `i'
				local `var'_`i' = string(r(mean), "%10.3f")
			}
			reg `var' i.(clinic), r
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
	
		qui mlogit clinic `oic' 
		qui test `oic'
		local omni=string(`r(p)', "%10.2f")
		
		file write fh " Omnibus test (p-value) &   &   &  &  &  &  & `omni'  \\"_n ///
		 "\midrule "_n 
		 

/*---------------------------------------------------------------
	Panel D: Implementation variables
----------------------------------------------------------------*/

file write fh "\multicolumn{8}{p{0.99\textwidth}}{\textbf{Meeting variables}} \\" 

	preserve
		use "${db_Clean}/meeting", clear
			
			*Merging in clinic information
			merge 1:1 hfac using "${db_Clean}/facility.dta", keepusing(clinic) nogen keep(3) 
		
		*Computing meeting duration
		gen duration = clockdiff_frac(meet_start, meet_end, "hour")
		replace duration = duration*60  //converting to minutes
		lab var duration "Meeting duration"	
		loc var1 newdate tot_att 
		loc var2 `var1' duration

	quietly {
			foreach var of local var2 {
				foreach i of numlist 1/2 {
					su `var' if clinic == `i'
					local `var'_`i' = string(r(mean), "%10.3f")
					}
				reg `var' i.(clinic), r
				test (1.clinic=2.clinic) 					// encourage = grant
				local p3=string(`r(p)', "%10.2f")	
			
				file write fh "`: variable label `var'' &  & ``var'_1'  & ``var'_2' &  &  & `p3' & \\"_n
			}
		}

		// Omnibus test	
		
			qui mlogit clinic `var1' 
			qui test `var1'
			local omni=string(`r(p)', "%10.2f")
	restore		
		
		file write fh " Omnibus test (p-value) &   &   &  &  &  &  & `omni'  \\"_n ///
		 "\midrule "_n 

		 
// Sample sizes

		file write fh " Sample size & `n0' & `n1'  & `n2' &  &  &  &  \\"_n ///
		
		
/*---------------------------------------------------------------
	End preamble
----------------------------------------------------------------*/
	
	file write fh " \bottomrule "_n ///
	"\end{tabular} "_n
	
	file close fh
	macro drop fh 


/*------------------------------------------------------------------------------------------------------
	Save dataset to use for prediction model
-------------------------------------------------------------------------------------------------------*/
	
	preserve 
		keep sid hfac level renov open24 power_source water_source toilet backup_av ambulance_av lab serv1-serv26 ///
		eq*_av obs_build rec_*  hws backup drugs km degree tenure clinic_exp_y anc0 del0 expense revenue nofunds key
		save "${data}/blpredict", replace
	restore


/*------------------------------------------------------------------------------------------------------
	Table A.1: Funding from various sources
-------------------------------------------------------------------------------------------------------*/

	preserve
		collapse funds_* ik_* 
		ren (funds_fgvt_yes funds_fgvt funds_fgvt_mean ik_fgvt_yes)(yes1 uncond1 cond1 inkind1)
		ren (funds_sgvt_yes funds_sgvt funds_sgvt_mean ik_sgvt_yes)(yes2 uncond2 cond2 inkind2)
		ren (funds_lgvt_yes funds_lgvt funds_lgvt_mean ik_lgvt_yes)(yes3 uncond3 cond3 inkind3)
		ren (funds_ins_yes funds_ins funds_ins_mean ik_ins_yes)(yes4 uncond4 cond4 inkind4)
		ren (funds_ngo_yes funds_ngo funds_ngo_mean ik_ngo_yes)(yes5 uncond5 cond5 inkind5)
		ren (funds_comm_yes funds_comm funds_comm_mean ik_comm_yes)(yes6 uncond6 cond6 inkind6)
		ren (funds_phil_yes funds_phil funds_phil_mean ik_phil_yes)(yes7 uncond7 cond7 inkind7)
		g id=1
		reshape long yes uncond cond inkind, i(id) j(j)
		label define j 1 "Federal government" 2 "State government" 3 "Local government" 4 "Health insurance" 5 "NGO" 6 "Community" 7 "Philanthropy", modify
		label values j j
		label var j "Source"
		label var yes "Any funds (\%)"
		label var cond "Average if yes"
		label var uncond "Average"
		label var inkind "In-kind contribution (\%)"
		foreach v in yes inkind {
			replace `v'=`v'*100
		}
		estpost tabstat yes cond uncond inkind, by(j) columns(variables) statistics(mean) notot
		esttab using "$out/tab_funding.tex", cells("yes(fmt(a1)) cond(fmt(%11.0fc)) uncond(fmt(%11.0fc)) inkind(fmt(a1))") label nomtitle nonumber replace noobs booktabs collab("`:var lab yes'" "`:var lab cond'" "`:var lab uncond'" "`:var lab inkind'")
	restore

/*------------------------------------------------------------------------------------------------------
	Figure A.4: Baseline correlation between clinic income and spending
-------------------------------------------------------------------------------------------------------*/

	preserve
		g logexp=ln(expense)
		g logrev=ln(revenue)
		loc y logexp logrev
		qui corr `y'
		loc rho : display %4.2f `r(rho)'
		#delimit;
			twoway(scatter `y', mcolor(gs13%55) msize(small)) (lfit `y', lc(red)),
			title("") yti("Log spending") xti("Log revenue") legend(off) scheme(s1mono) 
			text(-5 0 "r = `rho'", place(n)) saving("$out/`y'", replace);
			gr export "$out/logexp_logrev.eps", as(eps) preview(off) replace;
		#delimit cr
	restore

	preserve
		replace nofunds=1-nofunds
		#delimit;
			foreach y in expense { ;
				loc a : variable label `y';
				cibar `y', over(nofunds nofunds) level(95) bargap(-120) barl(on) blp(nw) bls(small)
				baropts(lc(black) lc(black)) barcol(none none)
				ciopt() graphopts(ytitle("") xla(, labgap(3) labsize(medsmall)) 
				yti("`a'", size(medsmall)) scale(0.9) 
				xti("Received funds last 3 months", size(medsmall)) 
				legend(off) saving("$out/`y'", replace) scheme(s1mono));
				gr export "$out/`y'.eps", as(eps) preview(off) replace;
			};
		#delimit cr
	restore
