/*==================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care
** This file creates the following working datasets: elwoman.dta and othchild.dta
====================================================================================*/

/*------------------------------
	Preamble
 -------------------------------*/
 
	clear all
	set more off
	set seed 123	// set seed

	*Initiating custom defined programs
		do "${replication_do}/programs.do"	
		
/*---------------------------------------------------------------------------------------------
	BASELINE FILE: MOTHER
---------------------------------------------------------------------------------------------*/

	use "${db_Clean}/woman_bl", clear

	*Merging treatment information
	merge 1:1 wid using "${db_Clean}/women_treatment", keep(3) nogen
	order cash risk clinic, after(wid)
		
	* Get household characteristics from household baseline survey
	merge m:1 hhid using "${db_Clean}/household", nogen keep(3)

		drop if w_nobl==1		// drop 21 women who were not present in the baseline survey
		drop w_nobl
		
	* Create variables

	recode age_bl (min/17=1 "<18 years")(18/24=2 "18-24 years")(25/34=3 "25-34 years")(35/50=4 "35 and older"), g(agegroup)
	label var agegroup "Mother's age"

	ren school m_school
	foreach v in m {
		tempvar x
		bys hfac: egen `x'=mean(`v'_school)
		replace `v'_school=round(`x') if missing(`v'_school)
		recode `v'_school (0 1 17=0 "No school") (2/7=1 "Primary")(8/13=2 "Secondary") (14/16=3 "Tertiary"), g(`v'school)
	}
	label var mschool "Mother's educational attainment"

	egen asset=rowtotal(radio-fridge) 
	order asset, after(bank)
	label var asset "Household assets (out of 11)"

	g priormisc=ma_any==1
	replace priormisc=0 if ma_tot==0
	label var priormisc "Previous miscarriage/abortion"
	order prior*, after(ma_tot)

	g priorstill=still_any==1
	replace priorstill=0 if still_tot==0
	label var priorstill "Previous stillbirth"
	order prior*, after(still_tot)

	* Wealth Index 

	loc vars water power toilet kitchen radio tv bicycle motor generator phone pc cart car boat fridge bank floor wall roof

	foreach v of local vars  {
		tempvar x
		bys hfac: egen `x'=mean(`v')
		replace `v'=round(`x') if missing(`v')
		qui tab `v', g (_`v')
	}

	pca _*, comp(1)
	predict _index
	xtile wealth=_index,nq(4)
	label var wealth "Wealth quartiles"
	drop _*
	order wealth, after(asset)

	loc gen 	sid wid date due_date 
	loc treat 	cash risk clinic
	loc dem 	agegroup mschool asset wealth dist
	loc preg 	preg_w del_first prior* h_rating bleed

	keep wid `gen' `treat' `dem' `preg'
	tempfile bl
	renvars date-mschool, prefix(bl_)
	save `bl', replace


/*---------------------------------------------------------------------------------------------
	ENDLINE FILE: MOTHER
---------------------------------------------------------------------------------------------*/

	use "${db_Clean}/woman_el", clear
		
	* Merge in baseline characteristics

		merge 1:1 wid using `bl', nogen keep(3)
		drop w_nobl

		* Fetal loss
		loc v lossmort
		g `v'=(misc==1) if int_y==1	// lost pregnancy
		replace `v'=1 if  wdeath==1 & preg_end_w<28  // pregnant mothers who died before 28 weeks
		label var `v' "Fetal loss"
		label values `v' yn
		order `v', after(wdeath)

	** Get mortality info from child data  
		preserve
			*Opening child data
				use "${db_Clean}/woman_el_child", clear				
				
			*Cleaning up 		
				loc v alive
				g `v'=del_alive	
				replace `v'=0 if cry==0 & move==0 & breathe==0	// no signs of life
				replace `v'=1 if cry==1 
				replace `v'=1 if move==1 
				replace `v'=1 if breathe==1 
				cap drop still
				g still=alive!=1	// stillborn infant
				
				loc v neo
				g `v'=0 if alive==1
				replace `v'=1 if death_1mth==1	// died in first month
				replace `v'=1 if alive==1 & c_alive==0 & death_1mth==.	// reported as live birth, died early
				
				foreach v in still neo {
					cap drop x
					g x=1 if `v'==1
					bys wid: egen `v'mort=min(x)	// mother experienced outcome
				}
			
							
			*Keeping one observation per woman					
				duplicates drop wid, force
								
				keep wid stillmort neomort 
				label var stillmort "Stillbirth"
				label var neomort "Newborn death"
				tempfile x
				save `x', replace
		restore

	merge 1:1 wid using `x', keep(1 3) nogen

	foreach v in stillmort neomort {
		replace `v'=0 if `v'==. 
		label values `v' yn
	}
	replace stillmort=1 if wdeath==1 & preg_end_w>=28 & preg_end_w<.  // mothers who died in late pregnancy 
	order stillmort neomort, after(lossmort)

	* Other variables

		g month=mofd(date)	
		format month %tmMon_CCYY
		label var month "Month of follow-up interview"
		
		g usedcare=(anc_tot_ver>3 & anc_tot_ver<.) | del_fac==1
		label var usedcare "Used health care services"

		g delphc=del_loc==5 
		label var delphc "Delivered in clinic"
		
		g freedel= del_cost_tot==0
		label var freedel "Paid nothing for delivery"
		
		egen anccost=rowtotal(card_cost visit_cost lab_cost drugs_cost)
		g freeanc= anccost ==0 
		label var freeanc "Paid nothing for antenatal"
		drop anccost

		foreach v in lab drugs {
			replace `v'_cost=0 if missing(`v'_cost) & anc==1
		}

		label define clinic 0 "Control" 1 "Encourage" 2 "Grant", modify
		label values clinic clinic

		g cash1=cash>0
		label define cash1 1 "Incentive"
		label values cash1 cash1
		label var cash1 "Offered incentive"

		recode bl_h_rating (1/2=1 "Fair")(3=2 "Good")(4=3 "V. Good")(5=4 "Excellent"), g(health)
		label var health "Health rating"
		
	* Save 
		keep if int_y==1	// keep endline sample
		loc vars sid hfac wid cash-health *_cost *mort
		keep `vars'
		order `vars'
		save "${data}/elwoman", replace


/*---------------------------------------------------------------------------------------------
	ENDLINE FILE: OTHER CHILD
---------------------------------------------------------------------------------------------*/

	use "${db_Clean}/woman_el_othchild", clear
	
	* Merge in baseline characteristics
		merge m:1 wid using `bl', nogen keep(3)

	* Other variables
	
		g month=mofd(date)	
		format month %tmMon_CCYY
		label var month "Month of follow-up interview"
		
		g male=c_male==1
		g mort=1-c_alive
		label var male "Male child"
		label var mort "Child is dead"

	* Save 
		loc vars sid hfac wid cash-mort
		keep `vars'
		order `vars'
		save "${data}/othchild", replace
