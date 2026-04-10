/*==================================================================================
** This file cleans the service delivery survey files
====================================================================================*/

clear

set seed  11111

gl inputs "${raw}"
gl outputs "${clean}"

	
*1. Cleaning up main file
****************************
	
	*Opening file
		use "${inputs}/sds", clear
	
		*1.1 Defining value labels
				
				lab def ap_status 0 `"Already available"'  1 `"Complete"'  2 `"Incomplete"'  3 `"None "'
				
				lab def oic_oth 1 `"OIC"' 88 `"Other staff"'
				
				lab def visit 1 `"Visit 1"' 2 `"Visit 2"' 3 `"Visit 3"' 4 `"Visit 4"'
				
				lab def sid 1 `"AKWA IBOM"' 2 `"GOMBE"' 3 `"JIGAWA"' 4 `"KANO"'
				
				lab def yes_no_seen 1 `"Yes, seen"' 2 `"Yes, not seen"' 3 `"No"'
				
				lab def yn 0 `"No"' 1 `"Yes"'
				
			
		*1.2 Labelling variable values
				
			*1.2.1 Labelling yes/no for following variable values 
			
				foreach var of varlist 	anc_yes ap_add ap_av ap_cont1 ap_cont2 ap_cont3 ///
										ap_cont4 ap_disp ap_disp_pat ap_meet_min ap_meet_yes ///
										ap_today awd_comm_yes awd_cons_yes awd_drugs_yes awd_eq_yes ///
										awd_fcare_yes awd_fdrugs_yes awd_meet_yes awd_oth_yes ///
										awd_outreach_yes awd_pow_yes awd_ren_yes awd_rep_e_yes ///
										awd_staff_yes awd_sup_yes awd_trans_yes awd_wat_yes consent ///
										del_yes home_birth home_pnc imm_yes inp_yes opd_yes open_arr ///
										rev_card_rec rev_cons_rec rev_del_rec rev_drug_rec ///
										rev_inpat_rec rev_lab_rec scheduled signin_yes {
					lab val `var' yn
				}
			
			*1.2.2 Labelling remaining variable values
				lab val ap_status ap_status
				lab val awd_cons_i_yes yes_no_seen
				lab val awd_cons_who oic_oth
				lab val awd_drugs_i_yes yes_no_seen
				lab val awd_drugs_who oic_oth
				lab val sid sid
				lab val visit visit
					 
		*1.3 Labelling variables
				lab var anc_days `"Days per week offered: ANC"'
				lab var anc_yes `"Register av: ANC"'
				lab var ap_add `"Actions from AP added"'
				lab var ap_av `"AP already available"'
				lab var ap_cont1 `"AP contributor - OIC"'
				lab var ap_cont2 `"AP contributor - PHC Workers"'
				lab var ap_cont3 `"AP contributor - Community Members"'
				lab var ap_cont4 `"AP contributor - Other (Specified)"'
				lab var ap_cont_oth `"AP contributor - Other (Specified)"'
				lab var ap_cont_tot `"Total participants in AP development"'
				lab var ap_disp `"AP is displayed visibly"'
				lab var ap_disp_pat `"AP is visible to patients"'
				lab var ap_meet_min `"AP development meeting minutes available "'
				lab var ap_meet_tot `"Total AP development meetings (if any)"'
				lab var ap_meet_yes `"Held any AP development meetings"'
				lab var ap_status `"AP status"'
				lab var ap_today `"Incomplete AP can be finished today"'
				lab var awd_comm_tot `"Communication"'
				lab var awd_comm_yes `"Grant spent on: Communication"'
				lab var awd_cons_i_tot `"Other consumables expenditures: Total on all invoices"'
				lab var awd_cons_i_yes `"Other consumables expenditures: Invoices available"'
				lab var awd_cons_tot `"Purchase of other consumables"'
				lab var awd_cons_who `"Other consumables expenditures: Purchasing staff"'
				lab var awd_cons_yes `"Grant spent on: Purchase of other consumables"'
				lab var awd_drugs_i_tot `"Drugs expenditures: Total on all invoices"'
				lab var awd_drugs_i_yes `"Drugs expenditures: Invoices available"'
				lab var awd_drugs_tot `"Purchase of drugs"'
				lab var awd_drugs_who `"Drugs expenditures: Purchasing staff"'
				lab var awd_drugs_who88 `"Award spent on drugs: Purchasing staff - Other (Specified)"'
				lab var awd_drugs_yes `"Grant spent on: Purchase of drugs"'
				lab var awd_eq_yes `"Grant spent on: Purchase of equipment"'
				lab var awd_fcare_tot `"Reduction or removal of patient fees"'
				lab var awd_fcare_yes `"Grant spent on: Reduction or removal of patient fees"'
				lab var awd_fdrugs_tot `"Free or subsidized drugs for patients"'
				lab var awd_fdrugs_yes `"Grant spent on: Free or subsidized drugs for patients"'
				lab var awd_meet_tot `"Staff meetings including refreshments"'
				lab var awd_meet_yes `"Grant spent on: Staff meetings"'
				lab var awd_oth_yes `"Grant spent on: Other (Specified)"'
				lab var awd_out `"Award: total outstanding balance"'
				lab var awd_outreach_tot `"Community outreach activities"'
				lab var awd_outreach_yes `"Grant spent on: Community outreach activities"'
				lab var awd_pow_tot `"Electricity"'
				lab var awd_pow_yes `"Grant spent on: Electricity"'
				lab var awd_ren_tot `"Building repairs or renovations"'
				lab var awd_ren_yes `"Grant spent on: Building repairs or renovations"'
				lab var awd_rep_e_tot `"Equipment repairs / refurbishment"'
				lab var awd_rep_e_yes `"Grant spent on: Equipment repairs / refurbishment"'
				lab var awd_staff_tot `"Staff compensation or incentives"'
				lab var awd_staff_yes `"Grant spent on: Staff compensation or incentives"'
				lab var awd_sup_tot `"Non-monetary patient and for patients"'
				lab var awd_sup_yes `"Grant spent on: Non-monetary patient incentives"'
				lab var awd_tot `"Award: total received"'
				lab var awd_tot_oth `"Award: total received - Other (Specified)"'
				lab var awd_trans_tot `"Transport subsidies for patients"'
				lab var awd_trans_yes `"Grant spent on: Transport subsidies for patients"'
				lab var awd_wat_tot `"Water"'
				lab var awd_wat_yes `"Grant spent on: Water"'
				lab var consent `"Interv.: Consent"'
				lab var date `"Visit Date"'
				lab var del_days `"Days per week offered: Deliveries"'
				lab var del_yes `"Register av: Delivery"'
				lab var end `"Interview end time"'
				lab var growth_days `"Days per week offered: Child growth monitoring clinics"'
				lab var hfac `"Clinic Identifier"'
				lab var home_birth `"Offered: Assistance for home births"'
				lab var home_pnc `"Offered: PNC for home deliveries"'
				lab var imm_days `"Days per week offered: Immunizations"'
				lab var imm_yes `"Register av: Immunization"'
				lab var inp_yes `"Register av: Inpatient"'
				lab var key `"Facility-Wave Identifier"'
				lab var opd_yes `"Register av: OPD"'
				lab var open_arr `"Open at arrival"'
				lab var pnc_days `"Days per week offered: PNC"'
				lab var rev_card_rec `"Info from records: Registration cards"'
				lab var rev_cons_rec `"Info from records: Other consumables"'
				lab var rev_del_rec `"Info from records: Delivery"'
				lab var rev_drug_rec `"Info from records: Drugs"'
				lab var rev_inpat_rec `"Info from records: Inpatient admission"'
				lab var rev_lab_rec `"Info from records: Lab tests"'
				lab var scheduled `"Visit scheduled with PHC"'
				lab var sick_a_days `"Days per week offered: Adult outpatient clinics"'
				lab var sick_c_days `"Days per week offered: Child outpatient eclinics"'
				lab var sid `"State"'
				lab var signin_yes `"Register av: Staff attendance"'
				lab var start `"Interview start time"'
				lab var visit `"Visit"'

				
		*1.4 Sort data
			sort key hfac 

		*Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }
			 
		*1.5 Ordering variables
			order 	key hfac sid date visit scheduled open_arr consent start opd_yes signin_yes ///
					anc_days del_days pnc_days imm_days sick_a_days sick_c_days growth_days ///
					home_birth home_pnc rev_card_rec rev_inpat_rec rev_del_rec rev_lab_rec ///
					rev_drug_rec rev_cons_rec anc_yes del_yes imm_yes inp_yes ap_av ///
					ap_status ap_today ap_disp ap_disp_pat ap_cont1 ap_cont2 ap_cont3 ///
					ap_cont4 ap_cont_oth ap_meet_yes ap_meet_tot ap_cont_tot ///
					ap_meet_min ap_add awd_tot awd_tot_oth awd_out awd_staff_yes ///
					awd_staff_tot awd_meet_yes awd_meet_tot awd_fdrugs_yes ///
					awd_fdrugs_tot awd_fcare_yes awd_fcare_tot awd_trans_yes ///
					awd_trans_tot awd_sup_yes awd_sup_tot awd_ren_yes ///
					awd_ren_tot awd_rep_e_yes awd_rep_e_tot awd_pow_yes ///
					awd_pow_tot awd_wat_yes awd_wat_tot awd_comm_yes ///
					awd_comm_tot awd_drugs_yes awd_drugs_tot awd_drugs_i_yes ///
					awd_drugs_i_tot awd_drugs_who awd_drugs_who88 awd_cons_yes ///
					awd_cons_tot awd_cons_i_yes awd_cons_i_tot awd_cons_who ///
					awd_eq_yes awd_outreach_yes awd_outreach_tot ///
					awd_oth_yes end
	
	save "${outputs}/sds", replace
	


*2. Cleaning up last seven days module
********************************************
	
	*Opening file
	use "${inputs}/sds_day", clear
	
		*2.1 Defining value labels
			
			 lab def yn 0 `"No"' 1 `"Yes"'
			 
		
		*2.2 Labelling variable values
				 
			 lab val open yn
			 
		
		*2.3 Labelling variables
			 
			lab var close_time `"Facility's Close time"'
			lab var date `"Visit Date"'
			lab var hfac `"Clinic Identifier"'
			lab var hours_open `"Hours facility was open (if open)"'
			lab var key `"Facility-Wave Identifier"'
			lab var opd_tot `"Tot: OPD patients"'
			lab var open `"Facility was Open"'
			lab var open_time  `"Facility's Open time"'
			lab var roster_num `"Number of days prior to visit date"'

		*2.4 Sort data
			sort key hfac date open open_time close_time hours_open
			
		*Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }
			 
		*2.5 Ordering variables
			order 	key hfac date roster_num open open_time close_time ///
					hours_open opd_tot opd_tot
		
	save "${outputs}/sds_day", replace	
	
		
*3. Cleaning up monthly data
*******************************
	
	*Opening file
	use "${inputs}/sds_month", clear
				
	*3.1 Defining value labels
			
			lab def yn 0 `"No"' 1 `"Yes"'
			
	
	*3.2 Labelling variable values
			
			foreach var of varlist 	r_bed_fin r_cards_fin r_comm_ik r_del_fin r_drug_fin ///
									r_fg_ik r_ins_ik r_lab_fin r_lg_ik r_ngo_ik ///
									r_othcons_fin r_phil_ik r_s_oth_ik ///
									r_serv_oth_fin r_sg_ik {
										
				lab val `var' yn
			}
			
	
	*3.3 Labelling variables
		
			lab var anc_new_tot `"Tot: New antenatal clients (first visit)"'
			lab var anc_tot `"Tot: Antenatal care (ANC) visits"'
			lab var cgro_tot `"Tot: Child growth monitoring visits"'
			lab var date `"Visit Date"'
			lab var del_tot `"Tot: Deliveries"'
			lab var e_comm_tot `"Exp: Communications"'
			lab var e_drug_tot `"Exp: Purchase of drugs"'
			lab var e_eq_tot `"Exp: Purchase of equipment"'
			lab var e_eq_type `"Exp: Purchase of equipment (Specified)"'
			lab var e_fuel_tot `"Exp: Fuel for generator / vehicles"'
			lab var e_inc_p_tot `"Exp: Patient incentives"'
			lab var e_inc_p_type `"Exp: Patient incentives (Specified)"'
			lab var e_inc_s_tot `"Exp: Staff incentives"'
			lab var e_inc_s_type `"Exp: Staff incentives (Specified)"'
			lab var e_laundry_tot `"Exp: Laundry"'
			lab var e_med_tot `"Exp: Medical consumables"'
			lab var e_other_tot `"Exp: Other"'
			lab var e_other_type `"Exp: Other operational expenses (Specified)"'
			lab var e_out_tot `"Exp: Community outreach activities"'
			lab var e_power_tot `"Exp: Electricity"'
			lab var e_renov_tot `"Exp: Facility maintenance/renovation"'
			lab var e_renov_type `"Exp: Facility maintenance/renovation (Specified)"'
			lab var e_repair_tot `"Exp: Equipment repairs"'
			lab var e_repair_type `"Exp: Equipment repairs (Specified)"'
			lab var e_stat_tot `"Exp: Stationary/printing"'
			lab var e_waste_tot `"Exp: Waste treatment"'
			lab var e_water_tot `"Exp: Water"'
			lab var hfac `"Clinic Identifier"'
			lab var home_tot `"Tot: Patient home visits"'
			lab var imm_tot `"Tot: Child immunizations"'
			lab var inp_tot `"Tot: Inpatient admissions"'
			lab var key `"Facility-Wave Identifier"'
			lab var mon_tot `"Tot: Postnatal visits"'
			lab var month `"Reference month"'
			lab var opd_tot `"Tot: OPD patients"'
			lab var out_tot `"Tot: Community outreach activities"'
			lab var r_bed_fin `"Rev from records: Inpatient admission"'
			lab var r_bed_tot `"Rev: Inpatient admission"'
			lab var r_cards_fin `"Rev from records: Patient registration cards"'
			lab var r_cards_tot `"Rev: Patient registration cards"'
			lab var r_comm_ik `"Any in-kind donation: Community"'
			lab var r_comm_tot `"Rev: Community"'
			lab var r_del_fin `"Rev from records: Charges for deliveries"'
			lab var r_del_tot `"Rev: Charges for deliveries"'
			lab var r_drug_fin `"Rev from records: Drug sales"'
			lab var r_drug_tot `"Rev: Drug sales"'
			lab var r_fg_ik `"Any in-kind donation: Federal Government"'
			lab var r_fg_tot `"Rev: Federal Government"'
			lab var r_ins_ik `"Any in-kind donation: Insurance schemes"'
			lab var r_ins_tot `"Rev: Insurance schemes"'
			lab var r_lab_fin `"Rev from records: Lab tests"'
			lab var r_lab_tot `"Rev: Lab tests"'
			lab var r_lg_ik `"Any in-kind donation: Local Government"'
			lab var r_lg_tot `"Rev: Local Government"'
			lab var r_ngo_ik `"Any in-kind donation: NGOs or development partners"'
			lab var r_ngo_tot `"Rev: NGOs or development partners"'
			lab var r_othcons_fin `"Rev from records: Sales of other consumables"'
			lab var r_othcons_tot `"Rev: Sales of other consumables"'
			lab var r_phil_ik `"Any in-kind donation: Philanthropic donations"'
			lab var r_phil_tot `"Rev: Philanthropic donations"'
			lab var r_s_oth_ik `"Any in-kind donation: Other sources"'
			lab var r_s_oth_spec `"Rev: Other sources (Specified)"'
			lab var r_s_oth_tot `"Rev: Other sources"'
			lab var r_serv_oth_fin `"Rev from records: Other patient services"'
			lab var r_serv_oth_spec `"Rev: Other patient services (Specified)"'
			lab var r_serv_oth_tot `"Rev: Other patient services"'
			lab var r_sg_ik `"Any in-kind donation: State Government"'
			lab var r_sg_tot `"Rev: State Government"'
			lab var ref_tot `"Tot: Referrals of pregnant women"'
			lab var u5_tot `"Tot: Sick under-five children"'
				
		*3.4 Sort data
				sort key hfac
				
		*Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }
			 
			
		*3.5 Converting month values from string to date format
				gen month_ = date(month, "MY")
					local month_label: variable label month
					drop month
					rename month_ month
					format %td month
				lab var month "`month_label'"
			
			
		*3.6 Ordering variables
			order 	key hfac month date opd_tot r_cards_fin r_cards_tot ///
					r_bed_fin r_bed_tot r_serv_oth_fin r_serv_oth_spec ///
					r_serv_oth_tot r_del_fin r_del_tot r_lab_fin r_lab_tot ///
					r_drug_fin r_drug_tot r_othcons_fin r_othcons_tot ///
					r_s_oth_spec r_s_oth_tot r_fg_tot r_fg_ik r_sg_tot ///
					r_sg_ik r_lg_tot r_lg_ik r_ins_tot r_ins_ik r_ngo_tot ///
					r_ngo_ik r_comm_tot r_comm_ik r_phil_tot r_phil_ik ///
					r_s_oth_ik e_inc_p_tot e_inc_p_type e_inc_s_tot ///
					e_inc_s_type e_drug_tot e_eq_tot e_eq_type e_med_tot ///
					e_power_tot e_water_tot e_waste_tot e_laundry_tot ///
					e_stat_tot e_comm_tot e_fuel_tot e_repair_tot ///
					e_repair_type e_out_tot e_renov_tot e_renov_type ///
					e_other_type e_other_tot opd_tot anc_tot anc_new_tot ///
					del_tot inp_tot u5_tot imm_tot ref_tot home_tot ///
					out_tot cgro_tot mon_tot
		
	save "${outputs}/sds_month", replace	
	
	
*4. Cleaning up action plan module
*****************************************
	
	*Opening file
	use "${inputs}/sds_action", clear
	
		
		*4.1 Defining value labels
				
				lab def drop_mod 1 `"Dropped"' 2 `"Modified"'
				
				lab def progress 1 `"No progress"' 2 `"In progress"' 3 `"Completed"'
				
				lab def old_new_action 0 `"No (it was always in Plan)"' 1 `"Yes (it was added later by the clinic)"'
				
				lab def visit 1 `"Visit 1"' 2 `"Visit 2"' 3 `"Visit 3"' 4 `"Visit 4"'
				
				lab def yn 0 `"No"' 1 `"Yes"'				
				
		
		*4.2 Labelling variable values
				
			*4.2.1 Label yes/no variables
				foreach var of varlist 	action_changed action_corr_yes cost_change ///
										cost_corr_yes cost_yes_new included reason_1 ///
										reason_2 reason_3 reason_4 reason_88  {
											
					lab val `var' yn
				}
				
			*4.2.2 Labelling other variables
				lab val action_progress progress
				lab val drop_mod drop_mod
				lab val is_new old_new_action
				lab val visit visit
	
		*4.3 Labelling variables
			
				lab var action_changed `"Action has changed since last visit"'
				lab var action_corr `"Corrected original action"'
				lab var action_corr_yes `"Preloaded original action is correct"'
				lab var action_id `"Action ID"'
				lab var action_new `"Action"'
				lab var action_pre `"Original action"'
				lab var action_pre_f `"Confirmed original action"'
				lab var action_progress `"Progress"'
				lab var action_upd `"Updated action"'
				lab var added `"Added during Visit"'
				lab var constraint `"Constraint identified"'
				lab var cost_change `"Cost has been updated since last visit"'
				lab var cost_corr `"Corrected original cost"'
				lab var cost_corr_yes `"Preloaded original cost is correct"'
				lab var cost_months_corr `"Corrected original months of action"'
				lab var cost_months_upd `"Updated months of action"'
				lab var cost_new `"Estimated cost"'
				lab var cost_pre `"Original cost"'
				lab var cost_pre_f `"Confirmed original cost"'
				lab var cost_unit_corr `"Corrected original cost frequency"'
				lab var cost_unit_new `"Estimated cost frequency"'
				lab var cost_unit_upd `"Updated cost frequency"'
				lab var cost_upd `"Updated cost"'
				lab var cost_yes_new `"Estimated cost available"'
				lab var drop_mod `"Action has changed since last visit: dropped or modified"'
				lab var included `"Interventions selected for Implementation"'
				lab var is_new `"Added since last visit"'
				lab var key `"Facility-Wave Identifier"'
				lab var modified `"Modified action"'
				lab var reason_1 `"Dropped / modified: too costly"'
				lab var reason_2 `"Dropped / modified: required resource was not available"'
				lab var reason_3 `"Dropped / modified: it did not have the expected impact"'
				lab var reason_4 `"Dropped / modified: they came up with new idea"'
				lab var reason_88 `"Dropped / modified: other reason (Specified)"'
				lab var verified_pre `"Action text and costs have already been verified"'
				lab var visit `"Visit"'
			
		
		*4.4 Sort data
				order key
				sort key 
				
		*4.5 Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }		
		
		
		*4.6 Ordering variables
			order 	key visit action_id action_pre verified_pre cost_pre ///
					action_corr_yes action_corr cost_corr_yes cost_corr ///
					cost_unit_corr cost_months_corr action_pre_f cost_pre_f ///
					action_changed drop_mod modified reason_1 reason_2 reason_3 ///
					reason_4 reason_88 action_upd action_progress cost_change ///
					cost_upd cost_unit_upd cost_months_upd constraint is_new ///
					action_new constraint cost_yes_new cost_new cost_unit_new ///
					included added action_progress
			 
		save "${outputs}/sds_action", replace
		
		
		
*5. Cleaning up equipment spending module
**********************************************
	
	*Opening file
	use "${inputs}/awd_equip", clear
	
		
		*5.1 Defining value labels
				
				lab def oic_oth 1 `"OIC"' 88 `"oic_oth"'
								
				lab def yes_no_seen 1 `"Yes, seen"' 2 `"Yes, not seen"' 3 `"No"'
		
		*5.2 Labelling variable values
				
				lab val awd_eq_who oic_oth
				lab val awd_eq_i_yes yes_no_seen
		
		*5.3 Labelling variables
			
				lab var awd_eq `"Name of the equipment"'
				lab var awd_eq_i_tot `"Invoice amount"'
				lab var awd_eq_i_yes `"Have supporting invoice/receipt"'
				lab var awd_eq_tot `"Total amount spent"'
				lab var awd_eq_who `"Purchased by"'
				lab var key `"Facility-Wave Identifier"'	
		
		*5.4 Sort data
				order key
				sort key 
				
		*5.5 Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }		
		
		*5.6 Ordering variables
			order key awd_eq awd_eq_tot awd_eq_i_yes awd_eq_i_tot awd_eq_who

		
		save "${outputs}/awd_equip", replace
		
		
*6. Cleaning up staff spending module
****************************************
	
	*Opening file
		use "${inputs}/awd_staff", clear	
			
		*6.1 Defining value labels
		
				lab def cadre 	1 "Doctor" 2 "Nurse"  3 "Midwife"  4 "Nurse/Midwife"  5 "CHO" ///
								6 "CHEW"  7 "J-CHEW"  8 "Pharmacist/Pharmacy technician"  ///
								9 "Laboratory technicians/technologist"  10 "Medical Records Officer"  ///
								11 "Environmental Health Officer"  88 "Other (specify)" 
				
				lab def old_new_staff 1	"Old staff" 2 "New staff"
				
		*6.2 Labelling variable values
		
				lab val awd_staff_old_new old_new_staff	
				lab val awd_staff_who_cadre cadre
		
		*6.3 Labelling variables
				
				lab var awd_staff_amt "Amount received since last visit"
				lab var awd_staff_old_new "Staff type"	
				lab var awd_staff_who_cadre "Cadre"
				lab var awd_staff_who_cadre_oth "Other Cadre - specified"
				lab var key "Facility-Wave Identifier"
			
		
		*6.4 Sort data
				order key
				sort key 
				
		*6.5 Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }		
				
		*6.6 Ordering variables
			order key awd_staff_who_cadre awd_staff_who_cadre_oth awd_staff_old_new awd_staff_amt 

	*Saving dataset		 
		save "${outputs}/awd_staff", replace			


*7. Cleaning up other spending module
******************************************
	
	*Opening file
		use "${inputs}/awd_other", clear	
					
		*7.1 Labelling variables
			
				lab var awd_oth `"Other activity name"'
				lab var awd_oth_tot `"Amount spent on activity"'	
				lab var key `"Facility-Wave Identifier"'	
			
					
		*7.2 Sort data
				order key
				sort key 
				
		*7.3 Trimming all string variables
			 foreach var of varlist _all {
                capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
                        replace `var' = trim(itrim(`var'))
						}
             }		
		
		*7.4 Ordering variables
		order key awd_oth awd_oth_tot

		
	*Saving dataset	 
		save "${outputs}/awd_other", replace	

		
*8. Cleaning up 2022 output data
************************************
	
	*Opening file
		use "${inputs}/sds_5", clear
	
	*Labelling variables
		
		lab var anc `"Antenatal visits"'
		lab var anc_new `"New Antenatal visits"'
		lab var del `"Deliveries"'
		lab var hfac `"Clinic Identifier"'
		lab var imm `"Immunizations"'
		lab var month `"Reference month"'
		lab var opd `"Outpatient visits"'
	
	* Ordering variables
		order hfac month anc opd del imm anc_new 
	*Saving dataset		 
		save "${outputs}/sds_5", replace	
			

*9. Cleaning up file with AP meta data
******************************************
	
	*Opening file
		use "${inputs}/AP_wordcount", clear
	
	*9.1 Defining value labels
			
		lab def yn 0 `"No"' 1 `"Yes"'
			

	*9.2 Labelling variable values
	
		lab val photo yn		
			
	*9.3 Labelling variables
			
		lab var count_action `"Word count: Actions/Solutions"'
		lab var count_steps `"Word count: Steps"'
		lab var hfac `"Clinic Identifier"'
		lab var photo `"Photo of plan available"'
		lab var typed `"Is plan typed"'		
	
	*Ordering variables
		order hfac count_steps typed count_action photo 

	*Saving file
		save "${outputs}/AP_wordcount", replace

	

*10. Cleaning up staffing file
*--------------------------------*

	*Open file
		use "${inputs}/staff", clear

	*10.1 Defining value labels
			
		lab def cadre 	1 `"Doctor"' 2 `"Nurse"' 3 `"Midwife"' 4 `"Nurse/Midwife"' ///
						5 `"CHO"' 6 `"CHEW"' 7 `"J-CHEW"' 8 `"Pharmacist/Pharmacy technician"' ///
						9 `"Laboratory technicians/technologist"' 10 `"Medical Records Officer"' ///
						11 `"Environmental Health Officer"' 88 `"Other (specify)"' 
		
		lab def clinic 0 `"Control"'  1 `"Encouragement"' 2 `"Grant"' 
		
		lab def empl_days_pw 	0 `"Less than one day"' 1 `"1 day"' 2 `"2 days"' ///
								3 `"3 days"' 4 `"4 days"' 5 `"5 days"' ///
								6 `"6 days"' 7 `"7 days"' 
		
		lab def empl_type 1 `"Permanent"' 2 `"Temporary"' 3 `"Unpaid volunteer"'
		
		lab def left_why 	1 `"Voluntary transfer"'  2 `"Compulsory transfer"'  3 `"Resigned"'  ///
							4 `"Terminated"'  5 `"Contract ended"'  6 `"Retired"'  ///
							7 `"Died"'  88 `"Other (Specify)"'
		
		lab def sid 1 `"AKWA IBOM"' 2 `"GOMBE"'  3 `"JIGAWA"'  4 `"KANO"'
		
		lab def status 0 `"Left PHC"' 1 `"Active"'
		
		lab def title 1 `"In-charge"' 2 `"Second in-charge"'  88 `"Other (specify)"'
		
		lab def visit 1 `"Visit 1"' 2 `"Visit 2"' 3 `"Visit 3"' 4 `"Visit 4"'
		
		lab def yn 0 `"No"' 1 `"Yes"'
			
			
	*10.2 Labelling variable values
	
		*10.2.1 Label yes/no variables
		
			foreach var in  duty new opd_seven_yes present sex {
					lab val `var' yn
				}
						
		*10.2.2 Labelling other variables
			lab val cadre cadre
			lab val clinic clinic
			lab val empl_days_pw empl_days_pw
			lab val empl_end empl_end
			lab val empl_start empl_start
			lab val empl_type empl_type
			lab val left_why left_why
			lab val sid sid
			lab val status status
			lab val title title
			lab val visit visit	
		
 	 		
	*10.3 Labelling variables			

			lab var cadre `"Highest qualification"'
			lab var cadre_oth `"Highest qualification - Other (Specified)"'
			lab var clinic `"Health center treatment"'
			lab var date `"Visit date"'
			lab var duty `"On duty"'
			lab var empl_days_pw `"Days per week supposed to work"'
			lab var empl_end `"Employment end date (if temporary)"'
			lab var empl_start `"Date started working"'
			lab var empl_type `"Employment type"'
			lab var hfac `"Clinic Identifier"'
			lab var hwid `"Healthworker ID"'
			lab var left_when `"Date left"'
			lab var left_why `"Reason for leaving"'
			lab var left_why_oth `"Other reason left (Specified)"'
			lab var new `"New provider"'
			lab var opd_seven `"OPD patients seen in the last 7 days (if any)"'
			lab var opd_seven_yes `"Saw any patients in the last 7 days"'
			lab var present `"Present on day of visit"'
			lab var sex `"Male"'
			lab var sid `"State"'
			lab var status `"Still working in the PHC"'
			lab var title `"Job title"'
			lab var title_oth `"Other job title (Specified)"'
			lab var visit `"Visit"'

	
		
		*Trimming all string variables
				 foreach var of varlist _all {
					capture confirm string variable `var'
						
					//Trimming if variable type is string
					
					if !_rc {
							replace `var' = trim(itrim(`var'))
							}
				 }
			 
	*10.4  Ordering variables
		
			order hfac 	hwid clinic sid date present left_why duty cadre cadre_oth ///
						visit left_why_oth opd_seven empl_start left_when title ///
						empl_end opd_seven_yes empl_days_pw status empl_type ///
						sex new title_oth  	 

	*Saving file
		save "${outputs}/staff", replace	

	
*11. Cleaning up text file with Action Plan details
*-----------------------------------------------------*

	*Open file
	use "${inputs}/Action_Plan_Excerpts", clear					
	
	*11.1 Defining value labels
		
		lab def sid 1 `"AKWA IBOM"' 2 `"GOMBE"'  3 `"JIGAWA"'  4 `"KANO"'
		
		lab def yn 0 `"No"' 1 `"Yes"'
	
	*11.2 Labelling value labels
		
		lab val sid sid
		lab val included yn
		
	*11.3 Labelling variables		
	
		lab var a_code1 `"Action Code 1"'
		lab var a_code2 `"Action Code 2"'
		lab var a_code3 `"Action Code 3"'
		lab var action `"Description of action"'
		lab var action_id `"Action ID"'				
		lab var c_code1 `"c_code1"'
		lab var c_code2 `"c_code2"'
		lab var c_code3 `"c_code3"'		
		lab var constraint `"Constraint identified"'
		lab var cost_code `"Original cost"'		
		lab var dupl `"dupl"'
		lab var hfac `"Clinic Identifier"'
		lab var included `"Interventions selected for Implementation"'						
		lab var new_action `"new_action"'
		lab var new_constraint `"new_constraint"'
		lab var newcost_code `"new_cost"'				
		lab var sid `"State"'
		
		*Trimming all string variables (where applicable)
			 foreach var of varlist _all {
				capture confirm string variable `var'
					
				//Trimming if variable type is string
				
				if !_rc {
						replace `var' = trim(itrim(`var'))
						}
			 }
			 
	*11.4  Ordering variables
	
		order  		sid hfac action_id constraint new_constraint c_code1 ///
					c_code2 c_code3 action new_action ///
					a_code1 a_code2 a_code3 included ///
					cost_code newcost_code dupl
	
	*Saving file
		save "${outputs}/Action_Plan_Excerpts", replace
