/*==============================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care
	** This file prepares files for analysis and saves them in folder defined by the macro "${data}
	
	** This file generates following datasets:
		- 	"${data}/sds_key"
		- 	"${data}/awd_equip"
		- 	"${data}/awd_staff"
		-	"${data}/awd_other"
		-	"${data}/ap_progress"
		-	"${data}/action_plan"

==============================================================================*/



/*------------------------------
	Preamble
 -------------------------------*/
	clear all
	set more off
	set seed 12345
	
	*Initiating custom defined programs
		do "${replication_do}/programs.do"	
	
/*==========================================================================================
	SDS KEYS
 ==========================================================================================*/

	use "${db_Clean}/sds", clear
		
			
		*Merging in clinic information
		merge m:1 hfac using "${db_Clean}/treatment", keepusing(clinic) nogen keep(3)
		
	keep if clinic==2
	drop if visit==4
	keep hfac visit date key
	
	save "${data}/sds_key", replace

/*==========================================================================================
	TRACKING AWARD SPENDING
 ==========================================================================================*/

	/*----------------------
			Equipment 
	 ----------------------*/

	 use "${db_Clean}/awd_equip", clear
	 
	 *Merging in sds information
		merge m:1 key using "${db_Clean}/sds", keepusing(hfac visit date) nogen keep(3)

	 *Save
		sort hfac visit
		order hfac visit date
		drop key
		
	  save "${data}/awd_equip", replace
	 

	/*----------------------
			Staff 
	 ----------------------*/

	  use "${db_Clean}/awd_staff", clear
	 
	 *Merging in sds information
		merge m:1 key using "${db_Clean}/sds", keepusing(hfac visit date) nogen keep(3)
		
	  *Save
		sort hfac visit
		save "${data}/awd_staff", replace

	  
	 
	/*----------------------
			Other spending 
	 ----------------------*/

	 use "${db_Clean}/awd_other", clear
	 
	 *Merging in sds information
		merge m:1 key using "${db_Clean}/sds", keepusing(hfac visit date) nogen keep(3)
		
	  *Save
		sort hfac visit
		save "${data}/awd_other", replace 
	  
 
 /*==========================================================================================
	Action Plans
 ==========================================================================================*/
	 
	* Opening sds data	
		use "${db_Clean}/sds", clear
		
	*Merging treatment indicators 
		merge m:1 hfac using "${db_Clean}/treatment",nogen keep(3)
		keep sid hfac cash clinic date visit ap_av ap_status key

	* Merging with sds action data
		merge 1:m key using "${db_Clean}/sds_action", nogen keep(3)
		
		
	* Save
		preserve
			keep sid hfac cash clinic visit ap_av action_id action_pre action_changed drop_mod modified action_upd action_progress action_new is_new reason_1-reason_88
			sort hfac action_id visit
			save "${data}/ap_progress",replace
		restore

	* Fixing actions
		g action=action_pre
		replace action=action_new if action=="" & action_new!="" & is_new==.
		drop if action==""

	*  Keep relevant variables for merge
		keep hfac action cost_pre cost_yes_new cost_new cost_unit_new 
	
	* Merge with coded data
		merge m:1 hfac action using "${db_Clean}/Action_Plan_Excerpts", keep(2 3) nogen
		
	* Clean cost data 
		loc cost cost
		replace new`cost'_code=`cost'_code if new`cost'_code=="" & `cost'_code!=""
		g `cost'=new`cost'_code
		qui replace `cost'="" if `cost'=="NA"
		qui replace `cost' = subinstr(`cost',"(total)","",.) 	// remove (total)
		qui replace `cost' = subinstr(`cost',"N ","",.) 		// remove Naira sign
		qui replace `cost' = subinstr(`cost',",","",.) 			// remove comma separator
		qui replace `cost' = strrtrim(`cost')					// trailing blanks
		destring `cost', replace force
		
	* Separate later plan update from original plan - break at "-" or "["
		split action, parse(" - ") generate(stub)
		ren (stub1 stub2)(action_orig action_upd)

	* Replace actions with corrected versions
		foreach x in action {
			replace `x'_orig=new_`x' if new_`x'!="" 
		}
		
	* Do not double-count
		drop if dupl==1
		gsort action_id cost -cost_new -action_upd
		duplicates drop action_id, force
		
	* Aggregate cost at facility level
		loc cost cost
		g x=`cost' if included==1		// include only the interventions selected for implementation
		bys hfac: egen tot`cost'=total(x)
		
	* Get costs for facilities where costs were provided later
		g y=`cost'_new if `cost'_new<. & `cost'==. & totcost==0
		replace `cost'=y if `cost'==. & y<.
		
	* Do total cost again
		cap drop tot`cost'
		replace x=y if included==1 & y<.	
		bys hfac: egen tot`cost'=total(x)
		label var tot`cost' "Total budgeted cost"
		drop x y		
		
	*Merging in clinic information
		merge m:1 hfac using "${db_Clean}/treatment", keepusing(clinic) nogen keep(3)
		
	* Labels
		label var action "Intervention"
		label var action_id "Intervention ID"
		label var action_upd "Later update"
		label var cost "Intervention cost"
		label var totcost "Total cost of all interventions"
		label values sid sid
	
	* Keep relevant variables 
		loc id sid hfac clinic 
		loc cost cost totcost  
		loc _action action_id action_orig a_code? action_upd included
		loc vars `id' `_action' `cost'
		order `vars'
		keep `vars'   															
		
	* Save file	
		ren  action_orig action	
		drop if action=="NIL"		
		save "${data}/action_plan", replace
		
		