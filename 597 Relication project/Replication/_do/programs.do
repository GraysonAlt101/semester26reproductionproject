/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

* This file creates custom program used in the analysis
=========================================================================================================*/

/*-------------------------------------------

	Defining custom program to compute tests
--------------------------------------------*/
	cap prog drop test_effects
	program test_effects
		estadd scalar mean = r(mean)
		qui test 2.clinic
		estadd scalar test1 = r(p)
		qui test 1.clinic = 2.clinic
		estadd scalar test2 = r(p)
		qui test 2.clinic = 0.5 * (1.clinic + 0.clinic)
		estadd scalar test3 = r(p)
	end	
