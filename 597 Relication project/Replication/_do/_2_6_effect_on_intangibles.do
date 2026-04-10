/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	**This file prepares the following:
				
		*** Tables:
				- 	Table 9: Effect on intangibles
				
		*** Figures:
				-	Figure 8: Health workers in grant clinics were more invested			
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
	Read in meeting followup data
---------------------------------------------------------------------------------------------*/

	use "${db_Clean}/meeting_followup", clear		// one-month follow-up visit

	g plan=ap_status==1

	* Ever developed a plan 

		preserve
			keep if plan!=1
			keep hfac
			merge 1:m hfac using "${db_Clean}/sds", nogen keep(3)
			g status=1 if ap_status==1
			sort hfac status visit 		// take the first occurence
			duplicates drop hfac, force
			replace status=0 if status==.
			keep hfac visit status ap_cont* ap_meet*
			tempfile x
			save `x'
		restore

	merge 1:1 hfac using `x', nogen update
	replace status=1 if plan==1
	replace status=1 if ap_meet_yes<.
	merge 1:1 hfac using "${data}/bl", nogen keep(3)		//  baseline facility controls 
	merge 1:1 hfac using "${db_Clean}/treatment", nogen	keep(3)	// treatment indicators


/*------------------------------------------------------------------------------------------------------
	Table 9: Effect on intangibles
-------------------------------------------------------------------------------------------------------*/

	eststo clear
	foreach y of varlist plan status {
		eststo: reghdfe `y' i.(sid clinic), cl($cl) abs($xvars)
		sum `y' if e(sample) & clinic==1
		estadd r(mean)
		test 1.clinic=2.clinic 
		estadd scalar test2=r(p)
	}
	foreach y of varlist ap_meet_yes {
		eststo: reghdfe `y' i.(sid clinic), cl($cl) abs($xvars)
		sum `y' if e(sample) & clinic==1
		estadd r(mean)
		test 1.clinic=2.clinic 
		estadd scalar test2=r(p)
	}
	replace ap_meet_tot=0 if ap_meet_yes==0 
	foreach y of varlist ap_meet_tot ap_cont_tot ap_cont3 {
		eststo: reghdfe `y' i.(sid open24 clinic), cl($cl) abs($xvars)
		sum `y' if e(sample) & clinic==1
		estadd r(mean)
		test 1.clinic=2.clinic 
		estadd scalar test2=r(p)
	}
	#delimit;
		esttab using "$out/tab_plan", keep(2.clinic) replace b(a3) se(%9.3f) eqlabels(" " " ") 
		noconstant nolabel nonotes nostar coeflabels(2.clinic "Grant") booktabs width(\hsize) 
		mtitles("1-month" "Ever" "Ever" "Number" "Number" "Any")
		scalars("mean Control mean" "test2 p (Grant = Encourage)") sfmt(%9.3f)
		mgroups("Developed plan" "Held meeting" "Contributors" "Community input", 
		pattern(1 0 1 0 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}));
	#delimit cr


/*------------------------------------------------------------------------------------------------------
	Figure 8: Health workers in grant clinics were more invested
-------------------------------------------------------------------------------------------------------*/

	** Word count and plan is printed **
	
		use "${db_Clean}/AP_wordcount", clear		// number of words in plan
		merge 1:1 hfac using "${db_Clean}/treatment", nogen	keep(3)	// treatment indicators
		keep if clinic>0
		g nwords=count_action+count_steps
		label var nwords "Number of words in plan"

		foreach y of varlist nwords typed  {
			#delimit;
				loc a : variable label `y';
				cibar `y', over(clinic) level(90) bargap(5) barcol(blue red) ciopt()	
				graphopts(ytitle("`a'") xlabel(, labgap(3)) 
				saving("$out/`y'", replace)
				legend(order(1 "Encourage" 2 "Grant") 
				rows(1) position(6) ring(1) symxsize(5) region(lw(none))));
				gr export "$out/`y'.eps", as(eps) preview(off) replace;
			#delimit cr
		}

	** Scatter plot **

		preserve
			loc y count_steps
			loc a : variable label `y'
			qui su `y', det
			loc ll=r(p1)
			loc ul=r(p99)
			keep if `y'>`ll' & `y'<`ul' 	// trim the data
			#delimit;
				twoway (scatter `y' count_action if clinic==1, 
				sort mcolor(blue%55) msize(small) mfcolor(none)) 
				(scatter count_steps count_action if clinic==2, 
				mcolor(red) msize(small) mfcolor(none)),
				legend(order(1 "Encourage" 2 "Grant") rows(2) position(2) ring(0) symxsize(5) 
				size(small) region(lw(vthin))) saving("$out/detail", replace);
				gr export "$out/detail.eps", as(eps) preview(off) replace;
			#delimit cr
		restore
	cd "$out"
	grc1leg2 nwords.gph typed.gph detail.gph  
	gr export wordcount.eps, as(eps) preview(off) replace

	** Innovation **

		use "${data}/action_plan", clear		
		split a_code1, parse(\) generate(code)	// split into parent and child codes
		foreach v of varlist code? {
			replace `v'=upper(`v')
		}

		* 1st level codes
		preserve
			duplicates drop hfac code1, force
			bys hfac: g div=_N	// number of unique groups
			duplicates drop hfac, force
			reg div i.(sid clinic), r
			foreach x in div { 
				#delimit;
					twoway (kdensity `x' if clinic==2, lc(red)) (kdensity `x' if clinic==1, lc(blue)),
					xtitle("Number of groups of actions considered") yti("Proportion")
					saving("$out/`x'", replace) legend(off);
				#delimit cr
			}
			gr export "$out/div.eps", as(eps) preview(off) replace
		restore

		* 2nd level codes
			preserve
				sort hfac code1 code2 code3
				duplicates drop hfac code1 code2, force
				by hfac code1: g n=_N	// number of unique groups
				duplicates drop hfac code1, force
				g x=n>=2	// two or more sub-groups
				foreach y in n x {
					reghdfe `y' i.clinic, abs(sid code1) cl($cl)
				}
			restore 

	cd "$out"
	grc1leg2 nwords.gph typed.gph detail.gph div.gph 
	gr export diversity.eps, as(eps) preview(off) replace

	** Plan is displayed ** 

		use "${db_Clean}/sds", clear
			
			*Merging in clinic information
			merge m:1 hfac using "${db_Clean}/facility", keepusing(clinic) nogen keep(3)
			

		label define sds 1 "SDS-1" 2 "SDS-2" 3 "SDS-3" 4 "SDS-4", modify
		label values visit sds
		foreach y of varlist ap_disp {
			preserve
			keep if clinic>0
			#delimit;
				loc a : variable label `y';
				cibar `y', over(clinic) vce(cl $cl) level(90) bargap(5) barcol(blue red) ciopt()	
				graphopts(ytitle("Plan is displayed visibly") 
				xlabel(, labgap(3)) ysc(range(.2 1)) yla(.2(.2)1)
				saving("$out/`y'", replace) legend(order(1 "Encourage" 2 "Grant") 
				rows(1) position(6) ring(1) symxsize(5) region(lw(thin))));
				gr export "$out/`y'.eps", as(eps) preview(off) replace;
			#delimit cr
			restore
		}
		
	** Made any changes to their plan **

		use "${data}/ap_progress", clear

			* Correct coding errors
			foreach string in Awaiting {
				replace action_changed=0 if modified=="`string'"
				replace drop_mod=. if modified=="`string'"
				replace action_progress=2 if modified=="`string'"
				foreach i in 1 2 3 4 88 {
					replace reason_`i'=. if modified=="`string'"
				}
				}
			foreach string in Completed {
				replace action_changed=0 if modified=="`string'"
				replace drop_mod=. if modified=="`string'"
				replace action_progress=3 if modified=="`string'"
				foreach i in 1 2 3 4 88 {
					replace reason_`i'=. if modified=="`string'"
				}
			}

		bys hfac: egen add=total(is_new)
		bys hfac: egen edit=total(action_changed)
		foreach v in add edit {
			replace `v'=1 if `v'>1 & `v'<.
		}
		g mod=(add==1 | edit==1) if  add<.

		tab action_progress, g(progress)
		label define sds 1 "SDS-1" 2 "SDS-2" 3  "SDS-3", modify
		label values visit sds

		foreach y in progress1 {
			#delimit;
				cibar `y', over1(clinic visit) vce(cl $cl)  level(90) bargap(5) barcol(blue red) ciopt()	
				graphopts(ytitle("Probability") xlabel(, labgap(3) valuelabel) 
				yscale(range(0 .8)) ylabel(0(.2).8) scale(0.9) 
				saving(`y', replace) legend(order(1 "Encourage" 2 "Grant") 
				rows(1) position(6) ring(1) symxsize(4) region(lw(none))));
				gr export "$out/`y'.eps", as(eps) preview(off) replace;
			#delimit cr
		}

		foreach y in mod {
			preserve
				collapse `y' clinic, by($cl)
				#delimit;
					cibar `y', over1(clinic) vce(cl $cl) level(90) bargap(5) barcol(blue red) ciopt()	
					graphopts(ytitle("Made any changes to their plans") xlabel(, labgap(3) valuelabel) 
					yscale(range(0 .8)) ylabel(0(.2).8) scale(0.9) 
					saving(`y', replace) legend(order(1 "Encourage" 2 "Grant") 
					rows(1) position(6) ring(1) symxsize(4) region(lw(none))));
					gr export "$out/`y'.eps", as(eps) preview(off) replace;
				#delimit cr
			restore
		}

		cd "$out"
		grc1leg2 nwords.gph detail.gph typed.gph div.gph ap_disp.gph  mod.gph, ///
		 iscale(*.8) pos(11) lrows(2) ring(0) lxo(7) lyo(-2) legs(2)
		gr export engagement.eps, as(eps) preview(off) replace
