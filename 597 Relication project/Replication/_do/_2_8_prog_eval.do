/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care

	**This file prepares the following:
				
		*** Figures:
				-	Figure A.23: Transparency and accountability
				-	Figure A.24: Perceived impacts		
=========================================================================================================*/

	
/*---------------------------------------------------------------------------------------------
	Read in feedback data
---------------------------------------------------------------------------------------------*/

	use "${db_Clean}/feedback", clear
	keep if consent==1

/*------------------------------------------------------------------------------------------------------
	Figure A.23: Transparency and accountability
-------------------------------------------------------------------------------------------------------*/

	* Binary outcomes
	*-----------------*

	//Renaming following variables in the form agree_i to facilitate processing
		local i = 0
		foreach var in knew_funds proc_fair purch_transp acc know_not see_not {
			local i = `i' + 1
			g agree`i' = `var'
		}


		foreach v of varlist agree1-agree4 imp* {
			loc a : variable label `v'
			loc a: subinstr local a "Agrees: " "", all
			cap drop _`v'
			g _`v'=inlist(`v',4,5) if `v'<.
			label var _`v' "`a'"
		}
		foreach v of varlist agree5-agree6 {
			loc a : variable label `v'
			loc a: subinstr local a "Agrees: " "", all
			cap drop _`v'
			g _`v'=inlist(`v',1,2) if `v'<.
			label var _`v' "`a'"
		}


	preserve
		keep hfac _agree*
		gen n= _n
		reshape long _agree, i(n)
		label values _j _j
		#delimit;
			graph hbar (mean) _agree, over(_j, relabel(1 "Knew whenever the clinic received funds" 
			2 "Process for determining spending was fair" 3 "Process for purchases was transparent" 
			4 "There was accountability in spending" 5 "I know how the money was spent"  
			6 "I can see where the money went") label(labsize(small))) 
			blabel(total, size(small) format(%4.2f)) scale(0.9) yti("Proportion agree");
		#delimit cr
		gr export "$out/capture.eps", as(eps) preview(off) replace
	restore


/*------------------------------------------------------------------------------------------------------
	Figure A.24: Perceived impacts
-------------------------------------------------------------------------------------------------------*/
			
	preserve
		#delimit;
			keep if clinic>0;
			keep hfac clinic infra equip_av_rating drugs_av_rating service_time serv_add
			outreach focus motiv;
			ren (infra equip_av_rating drugs_av_rating service_time serv_add
			outreach focus motiv)(imp1 imp2 imp3 imp4 imp5 imp6 imp7 imp8);
			label define _j 1 "Improved infrastucture" 2 "Equipment availability" 
			3 "Improved drug availability" 4 "Changes in service times"  5 "Additional services" 
			6 "More community outreach" 7 "Stronger focus on MCH" 
			8 "Motivated health workers", modify;
			order imp*;
			gen n= _n;
			reshape long imp, i(n);
			label values _j _j;
			cibar imp, over(clinic _j) vce(cl $cl) level(90) bargap(5) barcol(blue red) ciopt() 
			graphopts(ytitle("Proportion agree") xlabel(, labgap(3)  angle(45) labsize(medsmall)) 
			xtitle("") scale(0.9) legend(order(1 "Encourage" 2 "Grant") 
			rows(1) position(12) ring(1) symxsize(3) region(lw(none))));
			gr export "$out/impact.eps", as(eps) preview(off) replace;
		#delimit cr
	restore
	

	** Future changes to the program **
	*-----------------------------------*
	
		cap drop exclude
		g  exclude=0 if change!=""
		foreach text in "No" "no" "nil" "Nil" "Nill" "None" "none" "Non" "NON" "0" "Nothing" "nothing" "No changes" "I dont have" "77" "100" "I have no changes" "No change" "I will not change anything"  {
			replace exclude=1 if change=="`text'"
		}
		replace exclude=1 if regexm(change,"s ok")
		*br change if exclude==0 & clinic==2

		g money=0 if change!=""
		foreach text in "inancial" "funds" "money" "inance" "grant"  {
			replace money=1 if regexm(change, "`text'")
		}

		g extend=0 if change!=""
		foreach text in "Continu" "continu"  {
			replace extend=1 if regexm(change, "`text'")
		}
		foreach v in money extend {
			tab clinic `v' if !missing(change) & exclude==0 , row 
		}
