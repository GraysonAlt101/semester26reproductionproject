/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	**This file prepares the following:
	
		*** Datasets:
			- "${data}/hetvars"
				
		*** Figures:

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

	*Initiating custom defined programs
		do "${replication_do}/programs.do"	

/*---------------------------------------------------------------------------------------------
	Read in baseline files
---------------------------------------------------------------------------------------------*/

	use "${data}/blpredict", clear 	// file with baseline characteristics
	merge m:1 hfac using "${db_Clean}/treatment", nogen	keep(3)	// treatment indicators

	label define clinic 0 "Control" 1 "Encourage" 2 "Grant", modify
	label values clinic clinic


/*---------------------------------------------------------------------------------------------
	Calculate incentive/infrastructure shares from action plan  
---------------------------------------------------------------------------------------------*/

	preserve 
		use "${data}/action_plan", clear
		split a_code1, parse(\) generate(code)	// split into parent and child codes
		foreach v of varlist code? {
			replace `v'=upper(`v')
		}

		g x=code1
		replace x="INFRASTRUCTURE" if code1=="PROCUREMENT"
		encode x, g(newcode) label(intervention) 
		drop x
		keep if included==1		// keep only the interventions selected for implementation
		bys hfac: g n=_N		// total number of actions

	* Clinic allocation to incentives and capital spending 

		foreach i in 2 3 {
			g x=1 if newcode==`i'
			bys hfac: egen x1=total(x)
			g share`i'=x1/n		// share of actions
			drop x x?
			
			g x=cost if newcode==`i'
			bys hfac: egen x2=total(x)
			g budget`i'=x2/totcost 	 // share of budget
			drop x x?
		}
		label var share2 "Share of actions (incentives)"
		label var share3 "Share of actions (infrastructure)"
		label var budget2 "Share of budget (incentives)"
		label var budget3 "Share of budget (infrastructure)"
		label var n "Number of actions"

		keep hfac clinic share? budget?
		
		
		*Dropping duplicates			
			duplicates drop hfac, force
		
		tempfile plan
		save `plan'
	restore

	merge 1:1 hfac using `plan', nogen	


/*---------------------------------------------------------------------------------------------
	Figure A.19: Correlation between action share and budget share  
---------------------------------------------------------------------------------------------*/

	preserve
		keep if clinic==2
		label var share2 Incentives
		label var share3 Infrastructure
		foreach i in 2 3 {
			loc a : variable label share`i'
			#delimit;
				corr share`i' budget`i';
				loc rho : display %4.2f `r(rho)';
				twoway(scatter share`i' budget`i', mcolor(gs13%55) msize(small))
				(lfit share`i' budget`i', lc(red)), ti("`a'") yti("Share of actions") 
				xti("Share of budget") legend(off) text(0 1 "r = `rho'", place(nw)) 
				saving("$out/action_budget`i'", replace) scheme(s1mono);
		#delimit cr
		}
	restore
	cd "$out"
	grc1leg2 action_budget2.gph action_budget3.gph, iscale(*1) pos(6) ring(1) ycomm loff ysize(1.5) xsize(3) 
	gr export action_budget.eps, as(eps) preview(off) replace


	** Create index **

		loc v share
		g index=`v'3-`v'2 if clinic==2
		label var index "Incentive-Infrastructure Index"


/*---------------------------------------------------------------------------------------------
	Figure A.20: Did grant clinics prioritize incentives or infrastructure?  
---------------------------------------------------------------------------------------------*/

		
	#delimit;
		binscatter share? index if clinic==2, n(30) yti("Share of actions")
		xti("Incentive-infrastructure Index", size(medsmall)) xsc(titlegap(3)) yla(,nogrid)
		ysc(range(-.2 1)) yla(0(.2)1) text(1 -.65 "Prioritized incentives", place(c) size(small))
		text(1 .65 "Prioritized infrastructure", place(c) size(small)) 
		text(1 0 "Mixture", place(c) size(small)) saving("$out/indexshare", replace)
		xli(-.25, lp(dash_dot) lw(vthin)) xli(.25, lp(dash_dot) lw(vthin))
		legend(order(1 "Incentive share" 2 "Infrastructure share") 
		rows(2) position(5) ring(0) symxsize(3) size(vsmall) region(lw(none)));
		gr export "$out/indexshare.eps", as(eps) preview(off) replace;
	#delimit cr


	* Categorical index
	cap drop xcat
	recode index (-1/-.25=1 "Grant: Incentives" )(-.249999/.249999=2 "Grant: Mixture")(.25/1=3 "Grant: Infrastructure"), g(xcat)
	replace xcat=0 if clinic<2	// non-grant clinics
	label var xcat "Categorical Index"


/*---------------------------------------------------------------------------------------------
	Predicting incentive/infrastructure shares using lasso  
---------------------------------------------------------------------------------------------*/

	* Impute missing values for single clinic with no baseline

		foreach v of varlist rec_* revenue expense {
			tempvar x
			bys sid: egen `x'=mean(`v')
			replace `v'=`x' if missing(`v')
		}
		replace nofund=1 if missing(nofund)

		loc vars i.(sid renov level lab open24 power_source water_source toilet ambulance_av obs_build) eq*_av serv1-serv26 hws backup drugs km degree tenure anc0 del0 expense revenue nofund
		loc v share
		foreach i in 2 3 {
			cap drop `v'hat`i'
			sort key
			lasso poisson `v'`i' `vars', nolog sele(adaptive) rseed(1) 
			predict `v'hat`i'
		}
		label var `v'hat2 "Incentives"
		label var `v'hat3 "Infrastructure"
		cap drop z
		g z=`v'hat3-`v'hat2
		label var z "Predicted Index"

/*---------------------------------------------------------------------------------------------
	Figure A.21: Predicted grant allocation 
---------------------------------------------------------------------------------------------*/

	#delimit;
		loc y .8;
		loc x .3;
		binscatter sharehat? z, n(30) line(qfit) yti("Predicted share of actions")
		xti("Predicted Incentive-infrastructure Index", size(medsmall)) xsc(titlegap(3)) yla(,nogrid)
		ysc(range(0 .9)) yla(0(.2).8) xsc(range(-.6 .6))
		text(`y' -`x' "<-----  Prioritize incentives", place(c) size(small))
		text(`y' `x' " Prioritize infrastructure ----->  ", place(c) size(small))
		legend(order(1 "Incentive share" 2 "Infrastructure share") 
		rows(2) position(5) ring(0) symxsize(3) size(vsmall) region(lw(none)));
		gr export "$out/predindexshare.eps", as(eps) preview(off) replace;
	#delimit cr


** Do these variables predict clinic outcomes at 16 months **

	preserve
		use "${db_Clean}/facility_f1", clear	// get prices from endline clinic survey 
		
		qui tab clinic, g(clinic)
		
		g free=charge_anc1==0 & charge_anc2==0 & charge_del==0
		label var free "Free treatment at 16 months"
		
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

		loc yvars bed_tot power backup water wc serv equip drugs obs_build obs_infra obs_inclean /// 
		obs_outclean obs_waitdel obs_waitfan obs_curt  
		
		swindex `yvars', generate(index) normby(clinic1) replace
		label var index "Standardized quality at 16 months "
		
		loc vars free index
		keep hfac `vars' 
		renvars `vars', prefix(_)
		tempfile el
		save `el'
	restore
	merge 1:1 hfac using `el', nogen	// merge with 16-month follow-up data


/*---------------------------------------------------------------------------------------------
	Figure A.22: Validating the predicted incentive-infrastructure index  
---------------------------------------------------------------------------------------------*/

	foreach d in z {
		foreach y of varlist _free _index  {
			loc a : variable label `y'
			loc e blue%35
			loc g red
			loc min -.4
			loc max .4
			qui reghdfe `y' clinic##c.`d'##c.`d', vce(cl $cl) abs($xvars)
			qui margins, dydx(clinic) at(`d'=(`min'(.2)`max')) 
			#delimit;
				marginsplot, ti("`a'") yti("Treatment Effect") saving("$out/`y'_`d'", replace)
				legend(order(3 "Encourage" 4 "Grant") rows(1)) 
				xti("") level(90) xlab(-.4(.2).4, tlength(*.5) labsize(small))
				xmla(-.3 `"" "<--- Incentives"' .3 `"" "---> Infrastructure"', notick labs(small))
				plot1opt(lc(`e') mc(`e')) ci1opt(lc(`e')) 
				plot2opt(lc(`g') mc(`g')) ci2opt(lc(`g')) scheme(s1mono);
			#delimit cr
		}
	}
	cd "$out"
	grc1leg2 _free_z.gph _index_z.gph, iscale(*.8) ysize(1.5) xsize(3)
	gr export validate.eps, as(eps) preview(off) replace 


/*---------------------------------------------------------------------------------------------
	Figure A.16: Baseline spending – Top 50% vs. Bottom 50% of clinics  
---------------------------------------------------------------------------------------------*/

	xtile spend=expense, nq(2)
	replace spend=(spend-2)*-1
	label define spend 0 "Haves" 1 "Havenots", replace
	label values spend spend
	label var spend "Financial need indicator"

	preserve
		replace expense=expense*4
		#delimit;
			gr bar (p50) expense, over(spend, gap(30)) 
			yti("Spending N'000s") yli(600, lc(red) lp(dash)) bar(1, lc(black) fcolor(none))
			blab(bar, format(%4.0f)) saving("$out/spenddist", replace) ;
			gr export "$out/spenddist.eps", as(eps) preview(off) replace;
		#delimit cr
	restore


** Save working file **
	keep hfac clinic_exp_y spend xcat z 
	save "${data}/hetvars", replace
