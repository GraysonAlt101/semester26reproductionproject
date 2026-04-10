/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	**This file prepares the following:
				
		*** Tables:
				-	Table A.11: Staffing
				-	Table A.26: Health workers in grant clinics were more likely to be on duty
				-	Table A.27: Workers in grant clinics were less likely to leave
			
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
	Read in staff data
---------------------------------------------------------------------------------------------*/

	use "${db_Clean}/staff", clear
	merge m:1 hfac using "${data}/bl", nogen 			// baseline facility controls
	merge m:1 hfac using "${db_Clean}/treatment", nogen	keep(3)	// treatment indicators


/*------------------------------------------------------------------------------------------------------
	Table A.11: Staffing
-------------------------------------------------------------------------------------------------------*/

	loc x open24
	loc vars sid cash clinic risk `x' 
	eststo clear
	preserve
		loc y active
		g `y'=status==1
		collapse `vars' (sum) `y', by(hfac visit)
		replace `y'=ln(`y')
		eststo: reghdfe `y'  i.(`x' clinic), abs($xvars visit) cl($cl)
		sum `y' if clinic==0 & e(sample)==1
		test_effects
	restore

	** Temporary staff **

	preserve
		loc y temp
		g `y'=year(empl_start)==2019 & year(empl_end)==2020
		collapse `vars' (max) `y', by(hfac hwid)
		eststo: reghdfe `y'  i.(`x' clinic), abs($xvars) cl($cl)
		sum `y' if clinic==0 & e(sample)==1
		test_effects
	restore
	esttab using "$out/tab_staff", $posttext $scalar mtitle("Log (staff)" "Temporary staff")


/*------------------------------------------------------------------------------------------------------
	Table A.26: Health workers in grant clinics were more likely to be on duty
-------------------------------------------------------------------------------------------------------*/

	g oic=inlist(title,1,2)	// senior leadership
	loc t starty 	// year started working in the clinic
	g `t'=year(empl_start)
	qui su(`t')
	replace `t'=round(r(mean)) if missing(`t')	// replace missing with mean

	eststo clear
	foreach y of varlist duty present {
		loc tvars date `t'
		eststo: reghdfe `y'  i.(`x' oic clinic), abs($xvars `tvars') cl($cl)
		sum `y' if clinic==0 & e(sample)==1
		test_effects
	}
	esttab using "$out/tab_duty", $posttext $scalar mtitle("Worker is on duty" "Worker is present")


/*------------------------------------------------------------------------------------------------------	
	Table A.27: Workers in grant clinics were less likely to leave
-------------------------------------------------------------------------------------------------------*/

	g left=status==0				// all departures
	g left1=inlist(left_why,1,2,3)	// transfers and resignations
	loc yvars left left1

	preserve
		collapse `vars' `t' (max) `yvars', by(hfac hwid)
		eststo clear
		foreach y of local yvars {
			eststo: reghdfe `y'  i.(`x' clinic), abs($xvars `t') cl($cl)
			sum `y' if clinic==0 & e(sample)==1
			test_effects
		}
		esttab using "$out/tab_left", $posttext $scalar mtitle("All departures" "Quits and Transfers")
	restore
