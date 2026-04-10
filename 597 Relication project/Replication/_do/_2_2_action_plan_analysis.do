/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	**This file prepares the following:
	
		*** Excel files for Tables: 
				- 	Table A.7: Patient incentives
				- 	Table A.9: Infrastructure
				- 	Table A.10: Staff investments
				- 	Table A.12: Outreach
				
		*** Figures:
				-	Figure 3: Planned interventions by workers in grant clinics
				-	Figure 4: Grant clinics reduced prices 			
=========================================================================================================*/
 
 
/*------------------------------
	Preamble
 -------------------------------*/
 
	clear all
	set more off
	set seed 123	// set seed


/*-----------------------------------------------------------------------------------------
	TEXTUAL ANALYSIS: ACTION PLAN 
------------------------------------------------------------------------------------------*/

	use "${data}/action_plan", clear // Action plan data`'

		split a_code1, parse(\) generate(code)	// split into parent and child codes
		foreach v of varlist code? {
			replace `v'=upper(`v')
		}

		g x=code1
		replace x="INFRASTRUCTURE" if code1=="PROCUREMENT"
		encode x, g(newcode) label(intervention) 
		drop x
		replace code2="POWER SUPPLY" if code2=="ELECTRICITY" 
		replace code2="FEE DISCOUNTS" if code2=="FREE OR DISCOUNTED CARE"
		replace code2="TRANSPORT SUBSIDY" if code2=="TRANSPORTATION"
		replace code2="FREE DRUGS" if code2=="DRUGS"

		keep if included==1		// keep only the interventions selected for implementation
		keep if clinic==2		// keep grant clinics


/*------------------------------------------------------------------------------------------------------
	Figure 4: Planned interventions by workers in grant clinics
-------------------------------------------------------------------------------------------------------*/

	* As share of all actions

		graph hbar, over(newcode, sort(1) descending) blabel(bar, size(small) format(%4.1f)) yti("Percent")
		gr export "$out/share_act.eps", as(eps) preview(off) replace

	* As share of budget

		preserve
			loc x newcode
			bys `x': g n=_N
			collapse n (sum) cost, by(`x') 
			egen total=total(cost)
			g share=cost*100/total
			
			foreach y of varlist share {
				graph hbar (mean) `y', over(`x', sort(1) desc) blabel(bar, size(small) format(%4.1f)) yti("Percent")
				gr export "$out/share_cost.eps", as(eps) preview(off) replace
			}
		restore

/*------------------------------------------------------------------------------------------------------
	Output for Tables A.7, A.9, A.10 and A.12
-------------------------------------------------------------------------------------------------------*/

	* Results are outputted to an Excel file and manually converted to LaTeX 

		label var newcode "1st-level code"
		label var code2 "2nd-level code"

		set seed 54321
		cap drop id
		g double id=runiform()
		foreach i in 2 5 8 {
			preserve
				keep if newcode==`i'
				bys newcode code2: g n=_N
				keep if n>=5
				sort newcode code2 id 
				by newcode code2: g newid=_n
				keep if newid<=10
				export excel newcode code2 action using "$out/extract", sh("`i'", replace) first(varl)
			restore
		}	
		foreach i in 3 {
			preserve
				keep if newcode==`i'
				bys newcode code2: g n=_N
				keep if n>=5
				sort newcode code2 id 
				by newcode code2: g newid=_n
				keep if newid<=5
				export excel newcode code2 action using "$out/extract", sh("`i'", replace) first(varl)
			restore
		}

/*------------------------------------------------------------------------------------------------------
	Figure 5: Grant clinics reduced prices 
-------------------------------------------------------------------------------------------------------*/

	** Top figures **

		use "${db_Clean}/facility_f1", clear	// Rd 2 facility data
		g rd=2
		tempfile el
		save `el'
			
		use "${db_Clean}/facility_f2", clear	// Rd 3 facility data
		g rd=3

		append using `el'

		label define rd 2 "16 mths" 3 "24 mths"
		label values rd rd

		g anc0=charge_anc1==0 & charge_anc2==0
		label var anc0 "Free prenatal services"

		g del0=charge_del==0 
		label var del0 "Free delivery services"

		foreach y of varlist anc0 del0 {
			#delimit;
				loc a : variable label `y';
				cibar `y' if rd>=2, over(clinic rd) vce(cl hfac)
				level(90) bargap(5) barl(off) blp(nw) barcol(gs13 blue red) ciopt()	
				graphopts(ytitle("Proportion") xlabel(, labgap(3)) xtitle("", margin(b=10) size(medsmall))
				yscale(range(.2 1)) ylabel(.2(.2)1) scale(0.9) ti("`a'") scheme(s1mono)
				saving("$out/`y'", replace) legend(order(1 "Control" 2 "Encourage" 3 "Grant") 
				rows(3) position(10) ring(0) symxsize(3) size(vsmall) region(lw(none))));
				gr export "$out/`y'.eps", as(eps) preview(off) replace;
			#delimit cr
		}

	** Bottom Figure **

		use "${db_Clean}/sds_month", clear

			*Merging in clinic information
			merge m:1 hfac using "${db_Clean}/facility", keepusing(clinic) nogen keep(3)
			


		foreach y in r_del_tot {
			preserve
				loc a : variable label `y'
				loc x month
				loc style lpat(dot) style(unextended)
				collapse (mean) `y', by(clinic `x')
				replace `y'=`y'/1000	// rescale
				#delimit;
					twoway (connected `y' `x' if clinic==2, mc(red) lcolor(red) lp(dash))
					(connected `y' `x' if clinic==1, mc(blue) lcolor(blue))
					(connected `y' `x' if clinic==0, mc(gs10) lcolor(gs10)),
					tline(01Jun2019, `style') tline(01Oct2019, `style')
					tline(01Jan2020, `style') tline(01Jun2020, `style')
					title("Revenue from deliveries", margin(b=3)) ytitle("Revenue (N000's)") xtitle("")
					ysc(range(0 10)) yla(0(2)10) saving("$out/`y'", replace) scheme(s1mono)
					legend(order(1 "Grant" 2 "Encourage" 3 "Control" ) 
					rows(3) position(2) ring(0) symxsize(3) size(small) region(lw(none)));
					gr export "$out/`y'.eps", as(eps) preview(off) replace;
				#delimit cr
			restore
		}	

	** Combine figures **

		cd "$out"
		grc1leg2 anc0.gph del0.gph r_del_tot.gph, iscale(*.7) pos(11) lrows(3) ring(0) lxo(7) lyo(-4) legs(2)
		gr export discount.eps, as(eps) preview(off) replace 
