/*==================================================================================
** This file cleans baseline and follow-up facility survey files 
====================================================================================*/

clear

set seed  11111

gl inputs "${raw}"
gl outputs "${clean}"


*---------------------------------*	
*CLEANING UP BASELINE DATASETS
*---------------------------------*

*1. Clean up main file
****************************

	*Opening file
		use "${inputs}/facility_bl", clear


	*1.1 Defining Value Labels

		lab def ambulance 	1 `"Bicycle"'  2 `"Motorcycle "'  3 `"Motor vehicle "'  88 `"Other (Specify)"'
		
		lab def clean 		1 `"Very dirty"' 2 `"Somewhat dirty"' 3 `"Clean"' 4 `"Very clean"'
		
		lab def clinic 		0 `"Control"'  1 `"Encouragement"' 2 `"Grant"' 
		
		lab def condition 	1 `"Poor (requires major rehabilitation)"'  2 `"Fair (requires some rehabilitation)"' ///
							3 `"Good (requires no rehabilitation)"' 4 `"Excellent (like new or almost new)"'
		
		lab def ipc_infec 	1 `"Incinerator"' 2 `"Open burning"'  3 `"Dump without burning"' 4 `"Remove offsite"'  88 `"Other (Specify)"'
		
		lab def ipc_sharps 	1 `"Sharps bin"' 2 `"Safety box"'  3 `"Burn and bury site"'  4 `"Incinerator"'  ///
							5 `"Dustbin"'  6 `"Needle cutter"'  88 `"Other (Specify)"'
		
		lab def ipc_steril 	1 `"Autoclave "' 2 `"Dry heat sterilizer "'  3 `"Boiling "'  4 `"Bleach/Jik"' ///
							5 `"Process outside the facility "' 88 `"Other (Specify)"'
		
		lab def level 		1 `"Health post or dispensary"'  2 `"Basic Health Clinic"'  ///
							3 `"Primary Health Center"'  4 `"Comprehensive Health Center"'  88 `"Other (Specify)"'
		
		lab def power_source 0 `"No electricity "' 1 `"PHCN"' 2 `"Solar"'  88 `"Other (Specify)"'
		
		lab def renov 		0 `"None "'  1 `"Minor "' 2 `"Major "'
		
		
		lab def sid 		1 `"AKWA IBOM"'  2 `"GOMBE"'  3 `"JIGAWA"'  4 `"KANO"'
		
		lab def toilet 		0 `"No toilet "'  1 `"Pit Latrine"'  2 `"VIP"' 3 `"Water Closet (flush toilet)"' 88 `"Other (Specify)"'
		
		lab def water_source 	1 `"Piped into facility"'  2 `"Piped onto facility grounds"'  3 `"Public tap "' ///
								4 `"Borehole "' 5 `"Well"' 6 `"Spring"' 7 `"Rainwater "' 8 `"Tanker truck"' ///
								9 `"Cart with small tank/drum "' 10 `"Surface water (river/lake/pond)"'  88 `"Other (Specify)"'
		
		lab def yn			0 `"No"' 1 `"Yes"'
		
		lab def yndk 		0 `"No"' 1 `"Yes"' 99 `"Don't Know"'			
		
			
	*1.2 Labelling variable values
		 
			*1.2.1 Value labelling yes/no for following variables
											
				foreach var of varlist 	ambulance_av backup_av backup_fuel backup_works ///
										charge_emerg_yes consent drugs1_antib* drugs2_antimal* ///
										drugs3_anticonv1 drugs3_anticonv2 drugs3_anticonv3 ///
										drugs4_resp1 drugs4_resp2 drugs4_resp3 drugs5_oxyt1 ///
										drugs5_oxyt2 drugs6_emerg1 drugs6_emerg2 drugs6_emerg3 ///
										drugs_store exp_equip_yes exp_oth_yes funds_comm_yes ///
										funds_fgvt_yes funds_ins_yes funds_lgvt_yes funds_ngo_yes ///
										funds_phil_yes funds_sgvt_yes ik_comm_yes ik_fgvt_yes ///
										ik_ins_yes ik_lgvt_yes ik_ngo_yes ik_phil_yes ik_sgvt_yes ///
										is_OIC oic_phone_yes open247 rec_av rev_card_rec rev_cons_rec ///
										rev_del_rec rev_drug_rec rev_inpat_rec rev_lab_rec ///
										rev_oth_yes sat_open_yes serv* sun_open_yes {
												
						lab val `var' yn 						
					}		
						
			*1.2.2 Labelling yndk for following variables
					 
				 foreach var of varlist drugs7_oth* duty_ros eq*_av ipc_disinf_av ipc_reuse ///
										ipc_sharps_av ipc_soap_av lab live_prem obs_curt ///
										obs_curtclean obs_extable obs_infout obs_sharps ///
										obs_soap obs_waitdel obs_waitfan oncall oncall_prem ///
										power_works toilet_works {
					lab val `var' yndk
				 }
						
						
			*1.2.3 Labelling remaining value labels
				lab val ambulance ambulance
				lab val clinic clinic
				lab val ipc_infec ipc_infec
				lab val ipc_sharps ipc_sharps
				lab val ipc_steril ipc_steril
				lab val level level
				lab val obs_build condition
				lab val obs_inclean clean
				lab val obs_infra condition
				lab val obs_outclean clean
				lab val power_source power_source
				lab val renov renov
				lab val sid sid
				lab val toilet toilet
				lab val water_source water_source
					 
					 
	*1.3 Labelling variables

			lab var ambulance `"Ambulance type"'
			lab var ambulance_av `"Ambulance is available"'
			lab var ambulance_oth `"Ambulance type - Other (Specified)"'
			lab var backup_av `"Back-up generator available"'
			lab var backup_fuel `"Generator fuel currently available"'
			lab var backup_works `"Generator currently functioning"'
			lab var bed_tot `"Total beds (inpatient / maternity)"'
			lab var charge_anc1 `"Charges: ANC registration (Naira)"'
			lab var charge_anc2 `"Charges: Follow-up ANC visit (Naira)"'
			lab var charge_del `"Charges: Normal delivery (Naira)"'
			lab var charge_emerg_yes `"Charges:  (Naira)"'
			lab var charge_pnc `"Charges: Postnatal checkup (Naira)"'
			lab var clinic `"Health center treatment"'
			lab var consent `"Interv.: Consent"'
			lab var date `"Visit Date"'
			lab var drugs1_antib1 `"Antibiotics: Amoxicillin injection"'
			lab var drugs1_antib2 `"Antibiotics: Benzyl Penicillin injection"'
			lab var drugs1_antib3 `"Antibiotics: Cotrimoxazole"'
			lab var drugs1_antib4 `"Antibiotics: Erythromycin"'
			lab var drugs1_antib5 `"Antibiotics: Gentamicin injection"'
			lab var drugs1_antib6 `"Antibiotics: Metronidazole infusion"'
			lab var drugs2_antimal1 `"Antimalarials: Artemether + lumefantrine"'
			lab var drugs2_antimal2 `"Antimalarials: Artesunate"'
			lab var drugs2_antimal3 `"Antimalarials: Artesunate + Amodiaquine"'
			lab var drugs2_antimal4 `"Antimalarials: Quinine injection"'
			lab var drugs2_antimal5 `"Antimalarials: Sulphadoxine/pyrimethamine (SP)"'
			lab var drugs3_anticonv1 `"Anticonvulsants: Phenobarbital"'
			lab var drugs3_anticonv2 `"Anticonvulsants: Diazepam injection"'
			lab var drugs3_anticonv3 `"Anticonvulsants: Magnesium sulphate injection"'
			lab var drugs4_resp1 `"Resp. drugs: Beclomethasone"'
			lab var drugs4_resp2 `"Resp. drugs: Aminophylline"'
			lab var drugs4_resp3 `"Resp. drugs: Salbutamol"'
			lab var drugs5_oxyt1 `"Oxytocics: Ergometrine injection"'
			lab var drugs5_oxyt2 `"Oxytocics: Oxytocin injection"'
			lab var drugs6_emerg1 `"Emerg. drugs: Adrenaline (epinephrine)"'
			lab var drugs6_emerg2 `"Emerg. drugs: Hydrocortisone"'
			lab var drugs6_emerg3 `"Emerg. drugs: Promethazine"'
			lab var drugs7_oth1 `"Other drugs: Misoprostol"'
			lab var drugs7_oth2 `"Other drugs: IV fluids"'
			lab var drugs7_oth3 `"Other drugs: Tetanus toxoid vaccine"'
			lab var drugs7_oth4 `"Other drugs: Polio vaccine"'
			lab var drugs7_oth5 `"Other drugs: ORS sachets"'
			lab var drugs7_oth6 `"Other drugs: Ferrous sulfate or fumarate tablets"'
			lab var drugs7_oth7 `"Other drugs: Folic acid tablets"'
			lab var drugs_store `"Facility has a pharmacy / drug store"'
			lab var duty_ros `"Call duty roster available"'
			lab var end `"Interview end time"'
			lab var eq10_av `"Equip.: Oxygen/resuscitation set"'
			lab var eq10_tot `"Total: Oxygen/resuscitation set"'
			lab var eq11_av `"Equip.: Clinical oral thermometer"'
			lab var eq11_tot `"Total: Clinical oral thermometer"'
			lab var eq12_av `"Equip.: Rectal thermometer for newborn"'
			lab var eq12_tot `"Total: Rectal thermometer for newborn"'
			lab var eq13_av `"Equip.: IV Infusion stands"'
			lab var eq13_tot `"Total: IV Infusion stands"'
			lab var eq14_av `"Equip.: Newborn resuscitation table"'
			lab var eq14_tot `"Total: Newborn resuscitation table"'
			lab var eq15_av `"Equip.: Incubator"'
			lab var eq15_tot `"Total: Incubator"'
			lab var eq16_av `"Equip.: Radiant warmer"'
			lab var eq16_tot `"Total: Radiant warmer"'
			lab var eq17_av `"Equip.: Delivery set/pack"'
			lab var eq17_tot `"Total: Delivery set/pack"'
			lab var eq18_av `"Equip.: Vacuum extractor"'
			lab var eq18_tot `"Total: Vacuum extractor"'
			lab var eq19_av `"Equip.: Neonatal mucus extractor"'
			lab var eq19_tot `"Total: Neonatal mucus extractor"'
			lab var eq1_av `"Equip.: Sphygmomanometer"'
			lab var eq1_tot `"Total: Sphygmomanometer"'
			lab var eq20_av `"Equip.: Ambu bag"'
			lab var eq20_tot `"Total: Ambu bag"'
			lab var eq21_av `"Equip.: Suction aspirator"'
			lab var eq21_tot `"Total: Suction aspirator"'
			lab var eq22_av `"Equip.: Anti-shock garment"'
			lab var eq22_tot `"Total: Anti-shock garment"'
			lab var eq23_av `"Equip.: Refrigerator"'
			lab var eq23_tot `"Total: Refrigerator"'
			lab var eq24_av `"Equip.: Partograph forms"'
			lab var eq2_av `"Equip.: Adult stethoscope"'
			lab var eq2_tot `"Total: Adult stethoscope"'
			lab var eq3_av `"Equip.: Fetal stethoscope"'
			lab var eq3_tot `"Total: Fetal stethoscope"'
			lab var eq4_av `"Equip.: Adult weighing scale"'
			lab var eq4_tot `"Total: Adult weighing scale"'
			lab var eq5_av `"Equip.: Baby weighing scale"'
			lab var eq5_tot `"Total: Baby weighing scale"'
			lab var eq6_av `"Equip.: Examination couch"'
			lab var eq6_tot `"Total: Examination couch"'
			lab var eq7_av `"Equip.: Labor/delivery table"'
			lab var eq7_tot `"Total: Labor/delivery table"'
			lab var eq8_av `"Equip.: Sterilizer or autoclave"'
			lab var eq8_tot `"Total: Sterilizer or autoclave"'
			lab var eq9_av `"Equip.: Mama kits"'
			lab var eq9_tot `"Total: Mama kits"'
			lab var exp_comm `"Exp: Communications"'
			lab var exp_drug `"Exp: Drugs"'
			lab var exp_equip `"Exp: Equipment"'
			lab var exp_equip_yes `"Any new equipment purchased (last 12 months)"'
			lab var exp_fuel `"Exp: Fuel for generator / vehicles"'
			lab var exp_laundry `"Exp: Laundry"'
			lab var exp_med `"Exp: Medical consumables"'
			lab var exp_oth `"Exp: Other"'
			lab var exp_oth_sp `"Exp: Other operational expenses (Specified)"'
			lab var exp_oth_yes `"Exp: Any other operational expenses"'
			lab var exp_power `"Exp: Electricity"'
			lab var exp_renov `"Exp: Maintenance/renovations"'
			lab var exp_repair `"Exp: Equipment repairs"'
			lab var exp_stat `"Exp: Stationary/printing"'
			lab var exp_waste `"Exp: Waste treatment"'
			lab var exp_water `"Exp: Water"'
			lab var funds_comm `"Total funds: Community"'
			lab var funds_comm_yes `"Any funds: Community"'
			lab var funds_fgvt `"Total funds: Federal Government"'
			lab var funds_fgvt_yes `"Any funds: Federal Government"'
			lab var funds_ins `"Total funds: Insurance schemes"'
			lab var funds_ins_yes `"Any funds: Insurance schemes"'
			lab var funds_lgvt `"Total funds: Local Government"'
			lab var funds_lgvt_yes `"Any funds: Local Government"'
			lab var funds_ngo `"Total funds: NGOs or development partners"'
			lab var funds_ngo_yes `"Any funds: NGOs or development partners"'
			lab var funds_phil `"Total funds: Philanthropic donations"'
			lab var funds_phil_yes `"Any funds: Philanthropic donations"'
			lab var funds_sgvt `"Total funds: State Government"'
			lab var funds_sgvt_yes `"Any funds: State Government"'
			lab var hfac `"Clinic Identifier"'
			lab var ik_comm_yes `"Any in-kind transfers: Community"'
			lab var ik_fgvt_yes `"Any in-kind transfers: Federal Government"'
			lab var ik_ins_yes `"Any in-kind transfers: Insurance schemes"'
			lab var ik_lgvt_yes `"Any in-kind transfers: Local Government"'
			lab var ik_ngo_yes `"Any in-kind transfers: NGOs or development partners"'
			lab var ik_phil_yes `"Any in-kind transfers: Philanthropic donations"'
			lab var ik_sgvt_yes `"Any in-kind transfers: State Government"'
			lab var ipc_disinf_av `"IPC: Environmental disinfectant in stock"'
			lab var ipc_infec `"IPC: Infectious waste disposal method"'
			lab var ipc_infec_oth `"IPC: Infectious waste disposal method - Other (Specified)"'
			lab var ipc_reuse `"IPC: Needles / syringes ever reused"'
			lab var ipc_sharps `"IPC: Sharps disposal system"'
			lab var ipc_sharps_av `"IPC: Sharps disposal system available"'
			lab var ipc_sharps_oth `"IPC: Sharps disposal system - Other (Specified)"'
			lab var ipc_soap_av `"IPC: Soap in stock"'
			lab var ipc_steril `"IPC: Medical equipment sterilization method"'
			lab var ipc_steril_oth `"IPC: Medical equipment sterilization method - Other (Specified)"'
			lab var is_OIC `"Respondent is OIC"'
			lab var key `"Facility-Wave Identifier"'
			lab var km_nearest `"Distance to the nearest referral hospital (km)"'
			lab var lab `"Facility has a laboratory"'
			lab var level `"Level"'
			lab var level_oth `"Level - Other (Specified)"'
			lab var live_prem `"A provider lives on the premises"'
			lab var obs_build `"Obs: General conditions of building"'
			lab var obs_curt `"Obs: Curtains close off the consultation room"'
			lab var obs_curtclean `"Obs: Curtains in the consultation room are clean"'
			lab var obs_extable `"Obs: Examination table in consultation room"'
			lab var obs_inclean `"Obs: Cleanliness of interiors"'
			lab var obs_infout `"Obs: Infectious waste outside of covered trash containe in consultation room"'
			lab var obs_infra `"Obs: General conditions of infrastructure"'
			lab var obs_outclean `"Obs: Cleanliness of surroundings"'
			lab var obs_sharps `"Obs: Sharps container in consultation room"'
			lab var obs_soap `"Obs: Soap to wash hands"'
			lab var obs_waitdel `"Obs: Functional fan/AC in waiting area"'
			lab var obs_waitfan `"Obs: Functional fan/AC in delivery room"'
			lab var oic_phone_yes `"OIC has a phone number?"'
			lab var oncall `"A provider is on call after closing hours"'
			lab var oncall_prem `"Provider on call stays on the premises"'
			lab var open247 `"Open 24 hours a day, 7 days a week"'
			lab var power_source `"Source of electricity"'
			lab var power_source_oth `"Source of electricity - Other (Specified)"'
			lab var power_works `"Electricity currently functioning"'
			lab var rec_av `"Records: Registers available"'
			lab var renov `"Underwent renovations / upgrading (last year)"'
			lab var resp_title `"Respondent title"'
			lab var resp_title_oth `"Respondent title - Other (Specified)"'
			lab var rev_card `"Rev: Registration cards"'
			lab var rev_card_rec `"Info from records: Registration cards"'
			lab var rev_cons `"Rev: Other consumables"'
			lab var rev_cons_rec `"Info from records: Other consumables"'
			lab var rev_del `"Rev: Delivery"'
			lab var rev_del_rec `"Info from records: Delivery"'
			lab var rev_drug `"Rev: Drugs"'
			lab var rev_drug_rec `"Info from records: Drugs"'
			lab var rev_inpat `"Rev: Inpatient admission"'
			lab var rev_inpat_rec `"Info from records: Inpatient admission"'
			lab var rev_lab `"Rev: Lab tests"'
			lab var rev_lab_rec `"Info from records: Lab tests"'
			lab var rev_oth `"Rev: Other"'
			lab var rev_oth_sp `"Rev: Other, specified"'
			lab var rev_oth_yes `"Rev: Any other revenues"'
			lab var sat_close `"Sat: closing time"'
			lab var sat_open `"Sat: opening time"'
			lab var sat_open_yes `"Open on Saturday"'
			lab var serv1 `"Serv.: Inpatient admission"'
			lab var serv2 `"Serv.: Malaria test"'
			lab var serv3 `"Serv.: Hemoglobin test"'
			lab var serv4 `"Serv.: Urine test"'
			lab var serv5 `"Serv.: Blood transfusion"'
			lab var serv6 `"Serv.: HIV testing and counselling"'
			lab var serv7 `"Serv.: PMTCT of HIV"'
			lab var serv8 `"Serv.: Family planning counselling"'
			lab var serv9 `"Serv.: Child growth monitoring"'
			lab var serv10 `"Serv.: Routine immunization"'
			lab var serv11 `"Serv.: Child nutrition assessment"'
			lab var serv12 `"Serv.: Dispensing of ITN"'
			lab var serv13 `"Serv.: ACT for malaria management"'
			lab var serv14 `"Serv.: IPT for prophylaxis / treatment of malaria in pregnancy"'
			lab var serv15 `"Serv.: Integrated Management of Childhood Illnesses"'
			lab var serv16 `"Serv.: Caesarean Section"'
			lab var serv17 `"Serv.: Manual Vacuum Aspiration"'
			lab var serv18 `"Serv.: Dilation and curettage"'
			lab var serv19 `"Serv.: Assisted delivery - Vacuum extraction "'
			lab var serv20 `"Serv.: Assisted delivery - Forceps delivery"'
			lab var serv21 `"Serv.: Manual removal of placenta"'
			lab var serv22 `"Serv.: IV administration of antibiotics for sepsis"'
			lab var serv23 `"Serv.: IV administration of magnesium sulfate for pre-eclampsia/eclampsia"'
			lab var serv24 `"Serv.: IV administration of oxytocic drugs for hemorrhage"'
			lab var serv25 `"Serv.: Resuscitation of newborn with bag and mask"'
			lab var serv26 `"Serv.: Monitoring and mgmt of labor using partograph"'
			lab var sid `"State"'
			lab var start `"Interview start time"'
			lab var sun_close `"Sun: closing time"'
			lab var sun_open `"Sun: opening time"'
			lab var sun_open_yes `"Open on Sunday"'
			lab var toilet `"Availability of toilet for patients"'
			lab var toilet_oth `"Availability of toilet for patients - Other (Specified)"'
			lab var toilet_works `"Toilet currently functioning"'
			lab var water_source `"Primary source of water"'
			lab var water_source_oth `"Primary source of water - Other (Specified)"'
			lab var wkday_close `"M-F: closing time"'
			lab var wkday_open `"M-F: opening time"'
			

	*1.4 Sort data
			sort key hfac sid

	*Trimming all string variables
		 foreach var of varlist _all {
			capture confirm string variable `var'
				
			//Trimming if variable type is string
			
			if !_rc {
					replace `var' = trim(itrim(`var'))
					}
		 }
		 
	*1.5 Ordering variables
		order 	key hfac clinic sid date consent start is_OIC resp_title ///
				resp_title_oth oic_phone_yes level level_oth bed_tot renov ///
				open247 wkday_open wkday_close sat_open_yes sat_open sat_close ///
				sun_open_yes sun_open sun_close live_prem oncall duty_ros ///
				oncall_prem power_source power_source_oth power_works ///
				backup_av backup_works backup_fuel water_source water_source_oth ///
				toilet toilet_oth toilet_works ambulance_av ambulance ///
				ambulance_oth lab km_nearest serv1 serv2 serv3 serv4 serv5 ///
				serv6 serv7 serv8 serv9 serv10 serv11 serv12 serv13 serv14 ///
				serv15 serv16 serv17 serv18 serv19 serv20 serv21 serv22 serv23 ///
				serv24 serv25 serv26 drugs_store drugs1_antib1 drugs1_antib2 ///
				drugs1_antib3 drugs1_antib4 drugs1_antib5 drugs1_antib6 ///
				drugs2_antimal1 drugs2_antimal2 drugs2_antimal3 drugs2_antimal4 ///
				drugs2_antimal5 drugs3_anticonv1 drugs3_anticonv2 drugs3_anticonv3 ///
				drugs4_resp1 drugs4_resp2 drugs4_resp3 drugs5_oxyt1 ///
				drugs5_oxyt2 drugs6_emerg1 drugs6_emerg2 drugs6_emerg3 ///
				drugs7_oth1 drugs7_oth2 drugs7_oth3 drugs7_oth4 drugs7_oth5 ///
				drugs7_oth6 drugs7_oth7 eq1_av eq1_tot eq2_av eq2_tot eq3_av ///
				eq3_tot eq4_av eq4_tot eq5_av eq5_tot eq6_av eq6_tot eq7_av ///
				eq7_tot eq8_av eq8_tot eq9_av eq9_tot eq10_av eq10_tot eq11_av ///
				eq11_tot eq12_av eq12_tot eq13_av eq13_tot eq14_av eq14_tot ///
				eq15_av eq15_tot eq16_av eq16_tot eq17_av eq17_tot eq18_av ///
				eq18_tot eq19_av eq19_tot eq20_av eq20_tot eq21_av eq21_tot ///
				eq22_av eq22_tot eq23_av eq23_tot eq24_av ipc_reuse ipc_steril ///
				ipc_steril_oth ipc_sharps_av ipc_sharps ipc_sharps_oth ///
				ipc_infec ipc_infec_oth ipc_disinf_av ipc_soap_av rec_av ///
				charge_emerg_yes charge_anc1 charge_anc2 charge_del charge_pnc ///
				rev_card_rec rev_card rev_inpat_rec rev_inpat rev_del_rec ///
				rev_del rev_lab_rec rev_lab rev_drug_rec rev_drug rev_cons_rec ///
				rev_cons rev_oth_yes rev_oth rev_oth_sp funds_fgvt_yes funds_fgvt ///
				ik_fgvt_yes funds_sgvt_yes funds_sgvt ik_sgvt_yes funds_lgvt_yes ///
				funds_lgvt ik_lgvt_yes funds_ins_yes funds_ins ik_ins_yes ///
				funds_ngo_yes funds_ngo ik_ngo_yes funds_comm_yes funds_comm ///
				ik_comm_yes funds_phil_yes funds_phil ik_phil_yes exp_drug ///
				exp_equip exp_med exp_power exp_water exp_waste exp_laundry ///
				exp_stat exp_comm exp_fuel exp_repair exp_renov exp_oth_yes ///
				exp_oth exp_oth_sp exp_equip_yes obs_build obs_infra ///
				obs_inclean obs_outclean obs_waitfan obs_waitdel obs_curt ///
				obs_curtclean obs_extable obs_sharps ///
				obs_infout obs_soap end 

	* Saving the dataset
		save "${outputs}/facility_bl", replace


*2. Cleaning up equipment module
*********************************

	*Opening file
		use "${inputs}/facility_bl_equip", clear


	*2.1 Merging data from facility_bl dataset (saved earlier)
		
		*Merging key from facility_bl
			merge m:1 key using "${outputs}/facility_bl",  keepus(hfac sid clinic) 
			keep if _merge == 3
					
		*Clean up
			drop _merge
			
		 
	*2.2 Labelling variables
		  
			lab var equip_costpu `"Cost per item"'
			lab var equip_count `"Number of items purchased"'
			lab var equip_name `"Description"'
			lab var key `"Facility-Wave Identifier"'
			lab var obs_equip `"Seen by interviewer"'
			
			 
	*2.3 Standardizing text values
		
		*Equipment name
			
			replace equip_name = trim(itrim(equip_name))				
			

	*2.4 Sort data
		sort hfac sid
		
	*Trimming all string variables
		 foreach var of varlist _all {
			capture confirm string variable `var'
				
			//Trimming if variable type is string
			
			if !_rc {
					replace `var' = trim(itrim(`var'))
					}
		 }
		 
	*2.5 Ordering variables
		order 	key hfac clinic sid equip_name ///
				equip_count equip_costpu obs_equip
				
	*Saving dataset
	save "${outputs}/facility_bl_equip", replace

	

*3. Cleaning up staffing module
**********************************

	*Opening file
		use "${inputs}/facility_bl_hw", clear


	*3.1 Defining Value Labels
		
			lab def cadre 	1 `"Doctor"'   2 `"Nurse"' 3 `"Midwife"'   4 `"Nurse/Midwife"'    5 `"CHO"'  ///
							6 `"CHEW"'   7 `"J-CHEW"'   8 `"Pharmacist/Pharmacy technician"'   ///
							9 `"Laboratory technicians/technologist"'   10 `"Medical Records Officer"'   ///
							11 `"Environmental Health Officer"'   12 `"Other"'  

			lab def clinic 	0 `"Control"'  1 `"Encouragement"' 2 `"Grant"' 
			
			lab def sid 	1 `"AKWA IBOM"' 2 `"GOMBE"' 3 `"JIGAWA"' 4 `"KANO"'

			lab def yn 		0 `"No"' 1 `"Yes"'

	*3.2 Labelling variable values
							
			lab val cadre cadre
			lab val clinic clinic
			lab val info_rec yn
			lab val present yn
			lab val sid sid

				 
	*3.3 Labelling variables

			lab var cadre `"Highest qualification"'
			lab var clinic `"Health center treatment"'
			lab var days_tot `"Days worked, last week"'
			lab var hfac `"Clinic Identifier"'
			lab var hours_tot `"Hours worked, last week"'
			lab var hwid `"Healthworker ID"'
			lab var info_rec `"Info collected from records"'
			lab var key `"Facility-Wave Identifier"'
			lab var present `"Present on day of visit"'
			lab var sid `"State"'

	 *3.4 Sort data
		sort hwid key hfac sid

	*Trimming all string variables
		 foreach var of varlist _all {
			capture confirm string variable `var'
				
			//Trimming if variable type is string
			
			if !_rc {
					replace `var' = trim(itrim(`var'))
					}
		 }
		 
		*3.5 Ordering variables
		order 	key hfac hwid clinic sid cadre ///
				present days_tot hours_tot info_rec

	*Saving dataset
	save "${outputs}/facility_bl_hw", replace


*4. Cleaning up monthly data
********************************

	*Opening file
		use "${inputs}/facility_bl_month", clear

	*4.1 Defining Value Labels
		
			lab def clinic 0 `"Control"'  1 `"Encouragement"' 2 `"Grant"' 
			
			lab def sid 1 `"AKWA IBOM"' 2 `"GOMBE"' 3 `"JIGAWA"'  4 `"KANO"'			

	*4.2 Labelling variable values
		
			lab val clinic clinic
			lab val sid sid  			
				 
	*4.3 Labelling variables
			
			lab var clinic `"Health center treatment"'
			lab var hfac `"Clinic Identifier"'
			lab var key `"Facility-Wave Identifier"'
			lab var month `"Reference month"'
			lab var rec_anc `"Records: ANC visits"'
			lab var rec_anc1 `"Records: New ANC patients"'
			lab var rec_del `"Records: Deliveries"'
			lab var rec_emerg `"Records: Obstetric emergencies"'
			lab var rec_inpats `"Records: Inpatient admissions"'
			lab var rec_mdeath `"Records: Maternal deaths"'
			lab var rec_neodeath `"Records: Early neonatal deaths"'
			lab var rec_newdeath `"Records: Neonatal deaths"'
			lab var rec_pats `"Records: Patients"'
			lab var rec_still `"Records: Stillbirths"'
			lab var rec_under5 `"Records: Sick under-five children"'
			lab var sid `"State"'

	*4.4 Sort data
		sort key hfac sid
		
	*Trimming all string variables
		 foreach var of varlist _all {
			capture confirm string variable `var'
				
			//Trimming if variable type is string
			
			if !_rc {
					replace `var' = trim(itrim(`var'))
					}
		 }
		 
	*4.5 Ordering variables
		order 	key hfac clinic sid month rec_pats rec_anc rec_anc1 ///
				rec_del rec_inpats rec_under5 rec_emerg rec_mdeath ///
				rec_still rec_neodeath rec_newdeath
		
	*Saving dataset
	save "${outputs}/facility_bl_month", replace


*---------------------------------*	
*CLEANING UP FOLLOW-UP DATASETS
*---------------------------------*


*5. Cleaning up 16-month follow-up data file
**********************************************

	*Opening file
		use "${inputs}/facility_f1", clear

	*5.1 Defining value labels
		
		lab def ambulance 	1 `"Bicycle"'  2 `"Motorcycle "' 3 `"Motor vehicle "'  88 `"Other (Specify)"'
		
		lab def clean 		1 `"Very dirty"'  2 `"Somewhat dirty"' 3 `"Clean"'  4 `"Very clean"'
		
		lab def condition 	1 `"Poor (requires major rehabilitation)"' 2 `"Fair (requires some rehabilitation)"' ///
							3 `"Good (requires no rehabilitation)"'  4 `"Excellent (like new or almost new)"'
		
		lab def ipc_infec 	1 `"Incinerator"'  2 `"Open burning"' 3 `"Dump without burning"' 4 `"Remove offsite"'  88 `"Other (Specify)"'
		
		lab def ipc_sharps 	1 `"Sharps bin"'  2 `"Safety box"'  3 `"Burn and bury site"'  4 `"Incinerator"'  ///
							5 `"Dustbin"'  6 `"Needle cutter"'  88 `"Other (Specify)"'

		lab def ipc_steril 	1 `"Autoclave "'2 `"Dry heat sterilizer "' 3 `"Boiling "' 4 `"Bleach/Jik"' ///
							5 `"Process outside the facility "' 88 `"Other (Specify)"'
							
		lab def power_source 0 `"No electricity "'  1 `"PHCN"' 2 `"Solar"' 88 `"Other (Specify)"'
		
		lab def water_source 	1 `"Piped into facility"' 2 `"Piped onto facility grounds"' 3 `"Public tap "' ///
								4 `"Borehole "' 5 `"Well"' 6 `"Spring"' 7 `"Rainwater "' 8 `"Tanker truck"'  ///
								9 `"Cart with small tank/drum "' 10 `"Surface water (river/lake/pond)"' 88 `"Other (Specify)"'
								
		lab def toilet 		0 `"No toilet "' 1 `"Pit Latrine"'  2 `"VIP"'  3 `"Water Closet (flush toilet)"'  88 `"Other (Specify)"'
					
		lab def yn 			0 `"No"' 1 `"Yes"'
		
		lab def yndk 		0 `"No"' 1 `"Yes"' 99 `"Don't Know"'
									

	*5.2 Labelling variable values

		*5.2.1 Applying yes/no value labels to the following variables										
			 
				foreach var of varlist 	ambulance_av backup_av backup_fuel backup_works ///
										charge_emerg_yes consent drugs1_antib* drugs2_antimal* ///
										drugs3_anticonv* drugs4_resp* drugs5_oxyt* drugs6_emerg* ///
										drugs_store oic_phone_yes serv* {
					lab val `var' yn
				}

		*5.2.2 Applying yes/no/don't know to following variables
			
			foreach var of varlist 	drugs7_oth1 drugs7_oth2 drugs7_oth3 drugs7_oth4 drugs7_oth5 drugs7_oth6 ///
									drugs7_oth7 duty_ros eq10_av eq11_av eq12_av eq13_av eq14_av eq15_av ///
									eq16_av eq17_av eq18_av eq19_av eq1_av eq20_av eq21_av eq22_av eq23_av ///
									eq24_av eq2_av eq3_av eq4_av eq5_av eq6_av eq7_av eq8_av eq9_av ///
									ipc_disinf_av ipc_reuse ipc_sharps_av ipc_soap_av lab live_prem ///
									obs_arr_dist obs_bowl obs_bowl_change obs_curt obs_curtclean ///
									obs_extable obs_glove_on obs_infout obs_mask_on obs_n95_on ///
									obs_san_cons obs_san_pat obs_sharps obs_shield_on obs_sign_dist ///
									obs_sign_face obs_sign_oth obs_sign_red obs_sign_sym ///
									obs_soap obs_waitdel obs_waitfan obs_wash obs_water ///
									oncall oncall_prem power_works toilet_works {
				
				lab val `var' yndk
			}
							 
		 *5.2.3 Labelling remaining variables
				
			lab val ambulance ambulance
			lab val ipc_infec ipc_infec
			lab val ipc_sharps ipc_sharps
			lab val ipc_steril ipc_steril
			lab val obs_build condition
			lab val obs_inclean clean
			lab val obs_infra condition
			lab val obs_outclean clean
			lab val power_source power_source
			lab val toilet toilet
			lab val water_source water_source				
		
	*5.3 Labelling variables
	
			lab var ambulance `"Ambulance type"'
			lab var ambulance_av `"Ambulance is available"'
			lab var ambulance_oth `"Ambulance type - Other (Specified)"'
			lab var backup_av `"Back-up generator available"'
			lab var backup_fuel `"Generator fuel currently available"'
			lab var backup_works `"Generator currently functioning"'
			lab var bed_tot `"Total beds (inpatient / maternity)"'
			lab var charge_anc1 `"Charges: ANC registration (Naira)"'
			lab var charge_anc2 `"Charges: Follow-up ANC visit (Naira)"'
			lab var charge_del `"Charges: Normal delivery (Naira)"'
			lab var charge_emerg_yes `"Charges:  (Naira)"'
			lab var charge_pnc `"Charges: Postnatal checkup (Naira)"'
			lab var consent `"Interv.: Consent"'
			lab var date `"Visit Date"'
			lab var drugs1_antib1 `"Antibiotics: Amoxicillin injection"'
			lab var drugs1_antib2 `"Antibiotics: Benzyl Penicillin injection"'
			lab var drugs1_antib3 `"Antibiotics: Cotrimoxazole"'
			lab var drugs1_antib4 `"Antibiotics: Erythromycin"'
			lab var drugs1_antib5 `"Antibiotics: Gentamicin injection"'
			lab var drugs1_antib6 `"Antibiotics: Metronidazole infusion"'
			lab var drugs2_antimal1 `"Antimalarials: Artemether + lumefantrine"'
			lab var drugs2_antimal2 `"Antimalarials: Artesunate"'
			lab var drugs2_antimal3 `"Antimalarials: Artesunate + Amodiaquine"'
			lab var drugs2_antimal4 `"Antimalarials: Quinine injection"'
			lab var drugs2_antimal5 `"Antimalarials: Sulphadoxine/pyrimethamine (SP)"'
			lab var drugs3_anticonv1 `"Anticonvulsants: Phenobarbital"'
			lab var drugs3_anticonv2 `"Anticonvulsants: Diazepam injection"'
			lab var drugs3_anticonv3 `"Anticonvulsants: Magnesium sulphate injection"'
			lab var drugs4_resp1 `"Resp. drugs: Beclomethasone"'
			lab var drugs4_resp2 `"Resp. drugs: Aminophylline"'
			lab var drugs4_resp3 `"Resp. drugs: Salbutamol"'
			lab var drugs5_oxyt1 `"Oxytocics: Ergometrine injection"'
			lab var drugs5_oxyt2 `"Oxytocics: Oxytocin injection"'
			lab var drugs6_emerg1 `"Emerg. drugs: Adrenaline (epinephrine)"'
			lab var drugs6_emerg2 `"Emerg. drugs: Hydrocortisone"'
			lab var drugs6_emerg3 `"Emerg. drugs: Promethazine"'
			lab var drugs7_oth1 `"Other drugs: Misoprostol"'
			lab var drugs7_oth2 `"Other drugs: IV fluids"'
			lab var drugs7_oth3 `"Other drugs: Tetanus toxoid vaccine"'
			lab var drugs7_oth4 `"Other drugs: Polio vaccine"'
			lab var drugs7_oth5 `"Other drugs: ORS sachets"'
			lab var drugs7_oth6 `"Other drugs: Ferrous sulfate or fumarate tablets"'
			lab var drugs7_oth7 `"Other drugs: Folic acid tablets"'
			lab var drugs_store `"Facility has a pharmacy / drug store"'
			lab var duty_ros `"Call duty roster available"'
			lab var end `"Interview end time"'
			lab var eq10_av `"Equip.: Oxygen/resuscitation set"'
			lab var eq10_tot `"Total: Oxygen/resuscitation set"'
			lab var eq11_av `"Equip.: Clinical oral thermometer"'
			lab var eq11_tot `"Total: Clinical oral thermometer"'
			lab var eq12_av `"Equip.: Rectal thermometer for newborn"'
			lab var eq12_tot `"Total: Rectal thermometer for newborn"'
			lab var eq13_av `"Equip.: IV Infusion stands"'
			lab var eq13_tot `"Total: IV Infusion stands"'
			lab var eq14_av `"Equip.: Newborn resuscitation table"'
			lab var eq14_tot `"Total: Newborn resuscitation table"'
			lab var eq15_av `"Equip.: Incubator"'
			lab var eq15_tot `"Total: Incubator"'
			lab var eq16_av `"Equip.: Radiant warmer"'
			lab var eq16_tot `"Total: Radiant warmer"'
			lab var eq17_av `"Equip.: Delivery set/pack"'
			lab var eq17_tot `"Total: Delivery set/pack"'
			lab var eq18_av `"Equip.: Vacuum extractor"'
			lab var eq18_tot `"Total: Vacuum extractor"'
			lab var eq19_av `"Equip.: Neonatal mucus extractor"'
			lab var eq19_tot `"Total: Neonatal mucus extractor"'
			lab var eq1_av `"Equip.: Sphygmomanometer"'
			lab var eq1_tot `"Total: Sphygmomanometer"'
			lab var eq20_av `"Equip.: Ambu bag"'
			lab var eq20_tot `"Total: Ambu bag"'
			lab var eq21_av `"Equip.: Suction aspirator"'
			lab var eq21_tot `"Total: Suction aspirator"'
			lab var eq22_av `"Equip.: Anti-shock garment"'
			lab var eq22_tot `"Total: Anti-shock garment"'
			lab var eq23_av `"Equip.: Refrigerator"'
			lab var eq23_tot `"Total: Refrigerator"'
			lab var eq24_av `"Equip.: Partograph forms"'
			lab var eq2_av `"Equip.: Adult stethoscope"'
			lab var eq2_tot `"Total: Adult stethoscope"'
			lab var eq3_av `"Equip.: Fetal stethoscope"'
			lab var eq3_tot `"Total: Fetal stethoscope"'
			lab var eq4_av `"Equip.: Adult weighing scale"'
			lab var eq4_tot `"Total: Adult weighing scale"'
			lab var eq5_av `"Equip.: Baby weighing scale"'
			lab var eq5_tot `"Total: Baby weighing scale"'
			lab var eq6_av `"Equip.: Examination couch"'
			lab var eq6_tot `"Total: Examination couch"'
			lab var eq7_av `"Equip.: Labor/delivery table"'
			lab var eq7_tot `"Total: Labor/delivery table"'
			lab var eq8_av `"Equip.: Sterilizer or autoclave"'
			lab var eq8_tot `"Total: Sterilizer or autoclave"'
			lab var eq9_av `"Equip.: Mama kits"'
			lab var eq9_tot `"Total: Mama kits"'
			lab var hfac `"Clinic Identifier"'
			lab var ipc_disinf_av `"IPC: Environmental disinfectant in stock"'
			lab var ipc_infec `"IPC: Infectious waste disposal method"'
			lab var ipc_infec_oth `"IPC: Infectious waste disposal method - Other (Specified)"'
			lab var ipc_reuse `"IPC: Needles / syringes ever reused"'
			lab var ipc_sharps `"IPC: Sharps disposal system"'
			lab var ipc_sharps_av `"IPC: Sharps disposal system available"'
			lab var ipc_sharps_oth `"IPC: Sharps disposal system - Other (Specified)"'
			lab var ipc_soap_av `"IPC: Soap in stock"'
			lab var ipc_steril `"IPC: Medical equipment sterilization method"'
			lab var ipc_steril_oth `"IPC: Medical equipment sterilization method - Other (Specified)"'
			lab var key `"Facility-Wave Identifier"'
			lab var lab `"Facility has a laboratory"'
			lab var live_prem `"A provider lives on the premises"'
			lab var obs_arr_dist `"Obs: Social distancing provisions"'
			lab var obs_bowl `"Obs: Bowl with water to wash hands (if no running water)"'
			lab var obs_bowl_change `"Obs: Water is changed each time the bowl is used"'
			lab var obs_build `"Obs: General conditions of building"'
			lab var obs_child_tot `"Obs: Total patients under 5 years"'
			lab var obs_curt `"Obs: Curtains close off the consultation room"'
			lab var obs_curtclean `"Obs: Curtains in the consultation room are clean"'
			lab var obs_extable `"Obs: Examination table in consultation room"'
			lab var obs_glove_on `"Obs: Provider wears gloves before touching the patient"'
			lab var obs_inclean `"Obs: Cleanliness of interiors"'
			lab var obs_infout `"Obs: Infectious waste outside of covered trash containe in consultation room"'
			lab var obs_infra `"Obs: General conditions of infrastructure"'
			lab var obs_mask_on `"Obs: Provider is wearing other face covering"'
			lab var obs_mask_tot `"Obs: Total patients wearing a face mask"'
			lab var obs_n95_on `"Obs: Provider is wearing a face mask"'
			lab var obs_outclean `"Obs: Cleanliness of surroundings"'
			lab var obs_pats_tot `"Obs: Total patients waiting"'
			lab var obs_san_cons `"Obs: Hand sanitizer"'
			lab var obs_san_pat `"Obs: Hand available sanitizer for patients"'
			lab var obs_sharps `"Obs: Sharps container in consultation room"'
			lab var obs_shield_on `"Obs: Provider is wearing a face shield"'
			lab var obs_sign_dist `"Obs: Signs requesting patient to practice social distancing"'
			lab var obs_sign_face `"Obs: Signs requesting patients to wear face masks"'
			lab var obs_sign_oth `"Obs: Other signs about COVID-19"'
			lab var obs_sign_red `"Obs: Signs about how to reduce the spread of COVID-19"'
			lab var obs_sign_sym `"Obs: Signs about COVID-19 symptoms"'
			lab var obs_soap `"Obs: Soap to wash hands"'
			lab var obs_waitdel `"Obs: Functional fan/AC in waiting area"'
			lab var obs_waitfan `"Obs: Functional fan/AC in delivery room"'
			lab var obs_wash `"Obs: Provider washes hands with soap after touching the patient"'
			lab var obs_water `"Obs: Running water"'
			lab var oic_phone_yes `"OIC has a phone number?"'
			lab var oncall `"A provider is on call after closing hours"'
			lab var oncall_prem `"Provider on call stays on the premises"'
			lab var power_source `"Source of electricity"'
			lab var power_source_oth `"Source of electricity - Other (Specified)"'
			lab var power_works `"Electricity currently functioning"'
			lab var serv1 `"Serv.: Inpatient admission"'
			lab var serv2 `"Serv.: Malaria test"'
			lab var serv3 `"Serv.: Hemoglobin test"'
			lab var serv4 `"Serv.: Urine test"'
			lab var serv5 `"Serv.: Blood transfusion"'
			lab var serv6 `"Serv.: HIV testing and counselling"'
			lab var serv7 `"Serv.: PMTCT of HIV"'
			lab var serv8 `"Serv.: Family planning counselling"'
			lab var serv9 `"Serv.: Child growth monitoring"'
			lab var serv10 `"Serv.: Routine immunization"'
			lab var serv11 `"Serv.: Child nutrition assessment"'
			lab var serv12 `"Serv.: Dispensing of ITN"'
			lab var serv13 `"Serv.: ACT for malaria management"'
			lab var serv14 `"Serv.: IPT for prophylaxis / treatment of malaria in pregnancy"'
			lab var serv15 `"Serv.: Integrated Management of Childhood Illnesses"'
			lab var serv16 `"Serv.: Caesarean Section"'
			lab var serv17 `"Serv.: Manual Vacuum Aspiration"'
			lab var serv18 `"Serv.: Dilation and curettage"'
			lab var serv19 `"Serv.: Assisted delivery - Vacuum extraction "'
			lab var serv20 `"Serv.: Assisted delivery - Forceps delivery"'
			lab var serv21 `"Serv.: Manual removal of placenta"'
			lab var serv22 `"Serv.: IV administration of antibiotics for sepsis"'
			lab var serv23 `"Serv.: IV administration of magnesium sulfate for pre-eclampsia/eclampsia"'
			lab var serv24 `"Serv.: IV administration of oxytocic drugs for hemorrhage"'
			lab var serv25 `"Serv.: Resuscitation of newborn with bag and mask"'
			lab var serv26 `"Serv.: Monitoring and mgmt of labor using partograph"'
			lab var start `"Interview start time"'
			lab var toilet `"Availability of toilet for patients"'
			lab var toilet_oth `"Availability of toilet for patients - Other (Specified)"'
			lab var toilet_works `"Toilet currently functioning"'
			lab var water_source `"Primary source of water"'
			lab var water_source_oth `"Primary source of water - Other (Specified)"'
		
	*5.4 Merging facility-specific information from facility files 
		merge m:1 hfac using "${outputs}/facility.dta", keepus(sid clinic) assert(3) nogen
			
	*5.5 Sort data
		sort key hfac sid

	*Trimming all string variables
		 foreach var of varlist _all {
			capture confirm string variable `var'
				
			//Trimming if variable type is string
			
			if !_rc {
					replace `var' = trim(itrim(`var'))
					}
		 }
		 
	*5.6 Ordering variables
	order 	key hfac clinic sid date consent start oic_phone_yes bed_tot live_prem ///
			oncall duty_ros oncall_prem power_source power_source_oth power_works ///
			backup_av backup_works backup_fuel water_source water_source_oth ///
			toilet toilet_oth toilet_works ambulance_av ambulance ambulance_oth ///
			lab serv1 serv2 serv3 serv4 serv5 serv6 serv7 serv8 serv9 serv10 ///
			serv11 serv12 serv13 serv14 serv15 serv16 serv17 serv18 serv19 ///
			serv20 serv21 serv22 serv23 serv24 serv25 serv26 drugs_store ///
			drugs1_antib1 drugs1_antib2 drugs1_antib3 drugs1_antib4 ///
			drugs1_antib5 drugs1_antib6 drugs2_antimal1 drugs2_antimal2 ///
			drugs2_antimal3 drugs2_antimal4 drugs2_antimal5 drugs3_anticonv1 ///
			drugs3_anticonv2 drugs3_anticonv3 drugs4_resp1 drugs4_resp2 ///
			drugs4_resp3 drugs5_oxyt1 drugs5_oxyt2 drugs6_emerg1 drugs6_emerg2 ///
			drugs6_emerg3 drugs7_oth1 drugs7_oth2 drugs7_oth3 drugs7_oth4 ///
			drugs7_oth5 drugs7_oth6 drugs7_oth7 eq1_av eq1_tot eq2_av eq2_tot ///
			eq3_av eq3_tot eq4_av eq4_tot eq5_av eq5_tot eq6_av eq6_tot eq7_av ///
			eq7_tot eq8_av eq8_tot eq9_av eq9_tot eq10_av eq10_tot eq11_av ///
			eq11_tot eq12_av eq12_tot eq13_av eq13_tot eq14_av eq14_tot ///
			eq15_av eq15_tot eq16_av eq16_tot eq17_av eq17_tot eq18_av ///
			eq18_tot eq19_av eq19_tot eq20_av eq20_tot eq21_av eq21_tot ///
			eq22_av eq22_tot eq23_av eq23_tot eq24_av ipc_reuse ipc_steril ///
			ipc_steril_oth ipc_sharps_av ipc_sharps ipc_sharps_oth ipc_infec ///
			ipc_infec_oth ipc_disinf_av ipc_soap_av charge_emerg_yes ///
			charge_anc1 charge_anc2 charge_del charge_pnc obs_build obs_infra ///
			obs_inclean obs_outclean obs_waitfan obs_waitdel obs_sign_sym ///
			obs_sign_red obs_sign_face obs_sign_dist obs_sign_oth ///
			obs_arr_dist obs_san_pat obs_pats_tot obs_mask_tot ///
			obs_child_tot obs_curt obs_curtclean obs_extable obs_sharps ///
			obs_infout obs_n95_on obs_shield_on obs_mask_on ///
			obs_water obs_bowl obs_bowl_change obs_soap ///
			obs_san_cons obs_glove_on obs_wash end

	*Saving file
		save "${outputs}/facility_f1", replace


*6. Cleaning up 24-month follow-up data file
*********************************************

	*Opening file
		use "${inputs}/facility_f2", clear

	*6.1 Defining value labels
		
		lab def ambulance 	1 `"Bicycle"'  2 `"Motorcycle "' 3 `"Motor vehicle "'  88 `"Other (Specify)"'
		
		lab def clean 		1 `"Very dirty"'  2 `"Somewhat dirty"' 3 `"Clean"'  4 `"Very clean"'		
		
		lab def condition 	1 `"Poor (requires major rehabilitation)"' 2 `"Fair (requires some rehabilitation)"' ///
							3 `"Good (requires no rehabilitation)"'  4 `"Excellent (like new or almost new)"'			
		
		lab def ipc_infec 	1 `"Incinerator"'  2 `"Open burning"' 3 `"Dump without burning"' 4 `"Remove offsite"'  88 `"Other (Specify)"'

		lab def ipc_sharps 	1 `"Sharps bin"'  2 `"Safety box"'  3 `"Burn and bury site"'  4 `"Incinerator"'  ///
							5 `"Dustbin"'  6 `"Needle cutter"'  88 `"Other (Specify)"'

		lab def ipc_steril 	1 `"Autoclave "'2 `"Dry heat sterilizer "' 3 `"Boiling "' 4 `"Bleach/Jik"' ///
							5 `"Process outside the facility "' 88 `"Other (Specify)"'
							
		lab def power_source 0 `"No electricity "'  1 `"PHCN"' 2 `"Solar"' 88 `"Other (Specify)"'
		
		lab def water_source 	1 `"Piped into facility"' 2 `"Piped onto facility grounds"' 3 `"Public tap "' ///
								4 `"Borehole "' 5 `"Well"' 6 `"Spring"' 7 `"Rainwater "' 8 `"Tanker truck"'  ///
								9 `"Cart with small tank/drum "' 10 `"Surface water (river/lake/pond)"' 88 `"Other (Specify)"'
								
		
		
		lab def toilet 		0 `"No toilet "' 1 `"Pit Latrine"'  2 `"VIP"'  3 `"Water Closet (flush toilet)"'  88 `"Other (Specify)"'
		
		lab def yn 			0 `"No"' 1 `"Yes"'
		
		lab def yndk		0 `"No"' 1 `"Yes"' 99 `"Don't Know"'		
		
		

	*6.2 Labelling variable values

		*6.2.1 Applying yes/no value labels to the following variables

			foreach var of varlist 	ambulance_av backup_av backup_fuel backup_works charge_emerg_yes ///
									consent drugs1_antib* drugs2_antimal* drugs3_anticonv* drugs4_resp* ///
									drugs5_oxyt* drugs6_emerg* drugs_store oic_phone_yes serv* {
				lab val `var' yn
			}


		*6.2.2 Applying yes/no/don't know to following variables
				
			foreach var of varlist 	drugs7_oth1 drugs7_oth2 drugs7_oth3 drugs7_oth4 drugs7_oth5 ///
									drugs7_oth6 drugs7_oth7 duty_ros eq10_av eq11_av eq12_av eq13_av ///
									eq14_av eq15_av eq16_av eq17_av eq18_av eq19_av eq1_av eq20_av eq21_av ///
									eq22_av eq23_av eq24_av eq2_av eq3_av eq4_av eq5_av eq6_av eq7_av ///
									eq8_av eq9_av ipc_disinf_av ipc_reuse ipc_sharps_av ipc_soap_av lab ///
									live_prem obs_arr_dist obs_bowl obs_bowl_change obs_curt obs_curtclean ///
									obs_extable obs_glove_on obs_infout obs_mask_on obs_n95_on obs_san_cons ///
									obs_san_pat obs_sharps obs_shield_on obs_sign_dist obs_sign_face obs_sign_oth ///
									obs_sign_red obs_sign_sym obs_soap obs_waitdel obs_waitfan obs_wash ///
									obs_water oncall oncall_prem power_works toilet_works {
				
				lab val `var' yndk
			}
							 
		 *6.2.3 Labelling remaining variables
				
			lab val ambulance ambulance
			lab val ipc_infec ipc_infec
			lab val ipc_sharps ipc_sharps
			lab val ipc_steril ipc_steril
			lab val obs_build condition
			lab val obs_inclean clean
			lab val obs_infra condition
			lab val obs_outclean clean
			lab val power_source power_source
			lab val toilet toilet
			lab val water_source water_source
						
	*6.3 Labelling variables
		
			lab var ambulance `"Ambulance type"'
			lab var ambulance_av `"Ambulance is available"'
			lab var ambulance_oth `"Ambulance type - Other (Specified)"'
			lab var backup_av `"Back-up generator available"'
			lab var backup_fuel `"Generator fuel currently available"'
			lab var backup_works `"Generator currently functioning"'
			lab var bed_tot `"Total beds (inpatient / maternity)"'
			lab var charge_anc1 `"Charges: ANC registration (Naira)"'
			lab var charge_anc2 `"Charges: Follow-up ANC visit (Naira)"'
			lab var charge_del `"Charges: Normal delivery (Naira)"'
			lab var charge_emerg_yes `"Charges:  (Naira)"'
			lab var charge_pnc `"Charges: Postnatal checkup (Naira)"'
			lab var consent `"Interv.: Consent"'
			lab var date `"Visit Date"'
			lab var drugs1_antib1 `"Antibiotics: Amoxicillin injection"'
			lab var drugs1_antib2 `"Antibiotics: Benzyl Penicillin injection"'
			lab var drugs1_antib3 `"Antibiotics: Cotrimoxazole"'
			lab var drugs1_antib4 `"Antibiotics: Erythromycin"'
			lab var drugs1_antib5 `"Antibiotics: Gentamicin injection"'
			lab var drugs1_antib6 `"Antibiotics: Metronidazole infusion"'
			lab var drugs2_antimal1 `"Antimalarials: Artemether + lumefantrine"'
			lab var drugs2_antimal2 `"Antimalarials: Artesunate"'
			lab var drugs2_antimal3 `"Antimalarials: Artesunate + Amodiaquine"'
			lab var drugs2_antimal4 `"Antimalarials: Quinine injection"'
			lab var drugs2_antimal5 `"Antimalarials: Sulphadoxine/pyrimethamine (SP)"'
			lab var drugs3_anticonv1 `"Anticonvulsants: Phenobarbital"'
			lab var drugs3_anticonv2 `"Anticonvulsants: Diazepam injection"'
			lab var drugs3_anticonv3 `"Anticonvulsants: Magnesium sulphate injection"'
			lab var drugs4_resp1 `"Resp. drugs: Beclomethasone"'
			lab var drugs4_resp2 `"Resp. drugs: Aminophylline"'
			lab var drugs4_resp3 `"Resp. drugs: Salbutamol"'
			lab var drugs5_oxyt1 `"Oxytocics: Ergometrine injection"'
			lab var drugs5_oxyt2 `"Oxytocics: Oxytocin injection"'
			lab var drugs6_emerg1 `"Emerg. drugs: Adrenaline (epinephrine)"'
			lab var drugs6_emerg2 `"Emerg. drugs: Hydrocortisone"'
			lab var drugs6_emerg3 `"Emerg. drugs: Promethazine"'
			lab var drugs7_oth1 `"Other drugs: Misoprostol"'
			lab var drugs7_oth2 `"Other drugs: IV fluids"'
			lab var drugs7_oth3 `"Other drugs: Tetanus toxoid vaccine"'
			lab var drugs7_oth4 `"Other drugs: Polio vaccine"'
			lab var drugs7_oth5 `"Other drugs: ORS sachets"'
			lab var drugs7_oth6 `"Other drugs: Ferrous sulfate or fumarate tablets"'
			lab var drugs7_oth7 `"Other drugs: Folic acid tablets"'
			lab var drugs_store `"Facility has a pharmacy / drug store"'
			lab var duty_ros `"Call duty roster available"'
			lab var end `"Interview end time"'
			lab var eq1_av `"Equip.: Sphygmomanometer"'
			lab var eq1_tot `"Total: Sphygmomanometer"'
			lab var eq2_av `"Equip.: Adult stethoscope"'
			lab var eq2_tot `"Total: Adult stethoscope"'
			lab var eq3_av `"Equip.: Fetal stethoscope"'
			lab var eq3_tot `"Total: Fetal stethoscope"'
			lab var eq4_av `"Equip.: Adult weighing scale"'
			lab var eq4_tot `"Total: Adult weighing scale"'
			lab var eq5_av `"Equip.: Baby weighing scale"'
			lab var eq5_tot `"Total: Baby weighing scale"'
			lab var eq6_av `"Equip.: Examination couch"'
			lab var eq6_tot `"Total: Examination couch"'
			lab var eq7_av `"Equip.: Labor/delivery table"'
			lab var eq7_tot `"Total: Labor/delivery table"'
			lab var eq8_av `"Equip.: Sterilizer or autoclave"'
			lab var eq8_tot `"Total: Sterilizer or autoclave"'
			lab var eq9_av `"Equip.: Mama kits"'
			lab var eq9_tot `"Total: Mama kits"'
			lab var eq10_av `"Equip.: Oxygen/resuscitation set"'
			lab var eq10_tot `"Total: Oxygen/resuscitation set"'
			lab var eq11_av `"Equip.: Clinical oral thermometer"'
			lab var eq11_tot `"Total: Clinical oral thermometer"'
			lab var eq12_av `"Equip.: Rectal thermometer for newborn"'
			lab var eq12_tot `"Total: Rectal thermometer for newborn"'
			lab var eq13_av `"Equip.: IV Infusion stands"'
			lab var eq13_tot `"Total: IV Infusion stands"'
			lab var eq14_av `"Equip.: Newborn resuscitation table"'
			lab var eq14_tot `"Total: Newborn resuscitation table"'
			lab var eq15_av `"Equip.: Incubator"'
			lab var eq15_tot `"Total: Incubator"'
			lab var eq16_av `"Equip.: Radiant warmer"'
			lab var eq16_tot `"Total: Radiant warmer"'
			lab var eq17_av `"Equip.: Delivery set/pack"'
			lab var eq17_tot `"Total: Delivery set/pack"'
			lab var eq18_av `"Equip.: Vacuum extractor"'
			lab var eq18_tot `"Total: Vacuum extractor"'
			lab var eq19_av `"Equip.: Neonatal mucus extractor"'
			lab var eq19_tot `"Total: Neonatal mucus extractor"'
			lab var eq20_av `"Equip.: Ambu bag"'
			lab var eq20_tot `"Total: Ambu bag"'
			lab var eq21_av `"Equip.: Suction aspirator"'
			lab var eq21_tot `"Total: Suction aspirator"'
			lab var eq22_av `"Equip.: Anti-shock garment"'
			lab var eq22_tot `"Total: Anti-shock garment"'
			lab var eq23_av `"Equip.: Refrigerator"'
			lab var eq23_tot `"Total: Refrigerator"'
			lab var eq24_av `"Equip.: Partograph forms"'
			lab var hfac `"Clinic Identifier"'
			lab var ipc_disinf_av `"IPC: Environmental disinfectant in stock"'
			lab var ipc_infec `"IPC: Infectious waste disposal method"'
			lab var ipc_infec_oth `"IPC: Infectious waste disposal method - Other (Specified)"'
			lab var ipc_reuse `"IPC: Needles / syringes ever reused"'
			lab var ipc_sharps `"IPC: Sharps disposal system"'
			lab var ipc_sharps_av `"IPC: Sharps disposal system available"'
			lab var ipc_sharps_oth `"IPC: Sharps disposal system - Other (Specified)"'
			lab var ipc_soap_av `"IPC: Soap in stock"'
			lab var ipc_steril `"IPC: Medical equipment sterilization method"'
			lab var ipc_steril_oth `"IPC: Medical equipment sterilization method - Other (Specified)"'
			lab var key `"Facility-Wave Identifier"'
			lab var lab `"Facility has a laboratory"'
			lab var live_prem `"A provider lives on the premises"'
			lab var obs_arr_dist `"Obs: Social distancing provisions"'
			lab var obs_bowl `"Obs: Bowl with water to wash hands (if no running water)"'
			lab var obs_bowl_change `"Obs: Water is changed each time the bowl is used"'
			lab var obs_build `"Obs: General conditions of building"'
			lab var obs_child_tot `"Obs: Total patients under 5 years"'
			lab var obs_curt `"Obs: Curtains close off the consultation room"'
			lab var obs_curtclean `"Obs: Curtains in the consultation room are clean"'
			lab var obs_extable `"Obs: Examination table in consultation room"'
			lab var obs_glove_on `"Obs: Provider wears gloves before touching the patient"'
			lab var obs_inclean `"Obs: Cleanliness of interiors"'
			lab var obs_infout `"Obs: Infectious waste outside of covered trash containe in consultation room"'
			lab var obs_infra `"Obs: General conditions of infrastructure"'
			lab var obs_mask_on `"Obs: Provider is wearing other face covering"'
			lab var obs_mask_tot `"Obs: Total patients wearing a face mask"'
			lab var obs_n95_on `"Obs: Provider is wearing a face mask"'
			lab var obs_outclean `"Obs: Cleanliness of surroundings"'
			lab var obs_pats_tot `"Obs: Total patients waiting"'
			lab var obs_san_cons `"Obs: Hand sanitizer"'
			lab var obs_san_pat `"Obs: Hand available sanitizer for patients"'
			lab var obs_sharps `"Obs: Sharps container in consultation room"'
			lab var obs_shield_on `"Obs: Provider is wearing a face shield"'
			lab var obs_sign_dist `"Obs: Signs requesting patient to practice social distancing"'
			lab var obs_sign_face `"Obs: Signs requesting patients to wear face masks"'
			lab var obs_sign_oth `"Obs: Other signs about COVID-19"'
			lab var obs_sign_red `"Obs: Signs about how to reduce the spread of COVID-19"'
			lab var obs_sign_sym `"Obs: Signs about COVID-19 symptoms"'
			lab var obs_soap `"Obs: Soap to wash hands"'
			lab var obs_waitdel `"Obs: Functional fan/AC in waiting area"'
			lab var obs_waitfan `"Obs: Functional fan/AC in delivery room"'
			lab var obs_wash `"Obs: Provider washes hands with soap after touching the patient"'
			lab var obs_water `"Obs: Running water"'
			lab var oic_phone_yes `"OIC has a phone number?"'
			lab var oncall `"A provider is on call after closing hours"'
			lab var oncall_prem `"Provider on call stays on the premises"'
			lab var power_source `"Source of electricity"'
			lab var power_source_oth `"Source of electricity - Other (Specified)"'
			lab var power_works `"Electricity currently functioning"'
			lab var serv1 `"Serv.: Inpatient admission"'
			lab var serv2 `"Serv.: Malaria test"'
			lab var serv3 `"Serv.: Hemoglobin test"'
			lab var serv4 `"Serv.: Urine test"'
			lab var serv5 `"Serv.: Blood transfusion"'
			lab var serv6 `"Serv.: HIV testing and counselling"'
			lab var serv7 `"Serv.: PMTCT of HIV"'
			lab var serv8 `"Serv.: Family planning counselling"'
			lab var serv9 `"Serv.: Child growth monitoring"'
			lab var serv10 `"Serv.: Routine immunization"'
			lab var serv11 `"Serv.: Child nutrition assessment"'
			lab var serv12 `"Serv.: Dispensing of ITN"'
			lab var serv13 `"Serv.: ACT for malaria management"'
			lab var serv14 `"Serv.: IPT for prophylaxis / treatment of malaria in pregnancy"'
			lab var serv15 `"Serv.: Integrated Management of Childhood Illnesses"'
			lab var serv16 `"Serv.: Caesarean Section"'
			lab var serv17 `"Serv.: Manual Vacuum Aspiration"'
			lab var serv18 `"Serv.: Dilation and curettage"'
			lab var serv19 `"Serv.: Assisted delivery - Vacuum extraction "'
			lab var serv20 `"Serv.: Assisted delivery - Forceps delivery"'
			lab var serv21 `"Serv.: Manual removal of placenta"'
			lab var serv22 `"Serv.: IV administration of antibiotics for sepsis"'
			lab var serv23 `"Serv.: IV administration of magnesium sulfate for pre-eclampsia/eclampsia"'
			lab var serv24 `"Serv.: IV administration of oxytocic drugs for hemorrhage"'
			lab var serv25 `"Serv.: Resuscitation of newborn with bag and mask"'
			lab var serv26 `"Serv.: Monitoring and mgmt of labor using partograph"'
			lab var start `"Interview start time"'
			lab var toilet `"Availability of toilet for patients"'
			lab var toilet_oth `"Availability of toilet for patients - Other (Specified)"'
			lab var toilet_works `"Toilet currently functioning"'
			lab var water_source `"Primary source of water"'
			lab var water_source_oth `"Primary source of water - Other (Specified)"'

		
	*6.4 Merging facility-specific information from facility files

		merge m:1 hfac using "${outputs}/facility.dta", keepus(sid clinic) keep(3) nogen
				
	*6.5 Sort data
		sort key hfac sid

	*Trimming all string variables
		 foreach var of varlist _all {
			capture confirm string variable `var'
				
			//Trimming if variable type is string
			
			if !_rc {
					replace `var' = trim(itrim(`var'))
					}
		 }
		 
	*6.6  Ordering variables
		order 	key hfac clinic sid date consent start oic_phone_yes bed_tot ///
				live_prem oncall duty_ros oncall_prem power_source ///
				power_source_oth power_works backup_av backup_works backup_fuel ///
				water_source water_source_oth toilet toilet_oth toilet_works ///
				ambulance_av ambulance ambulance_oth lab serv1 serv2 serv3 ///
				serv4 serv5 serv6 serv7 serv8 serv9 serv10 serv11 serv12 serv13 ///
				serv14 serv15 serv16 serv17 serv18 serv19 serv20 serv21 serv22 ///
				serv23 serv24 serv25 serv26 drugs_store drugs1_antib1 drugs1_antib2 ///
				drugs1_antib3 drugs1_antib4 drugs1_antib5 drugs1_antib6 ///
				drugs2_antimal1 drugs2_antimal2 drugs2_antimal3 drugs2_antimal4 ///
				drugs2_antimal5 drugs3_anticonv1 drugs3_anticonv2 drugs3_anticonv3 ///
				drugs4_resp1 drugs4_resp2 drugs4_resp3 drugs5_oxyt1 drugs5_oxyt2 ///
				drugs6_emerg1 drugs6_emerg2 drugs6_emerg3 drugs7_oth1 drugs7_oth2 ///
				drugs7_oth3 drugs7_oth4 drugs7_oth5 drugs7_oth6 drugs7_oth7 eq1_av ///
				eq1_tot eq2_av eq2_tot eq3_av eq3_tot eq4_av eq4_tot eq5_av ///
				eq5_tot eq6_av eq6_tot eq7_av eq7_tot eq8_av eq8_tot eq9_av ///
				eq9_tot eq10_av eq10_tot eq11_av eq11_tot eq12_av eq12_tot ///
				eq13_av eq13_tot eq14_av eq14_tot eq15_av eq15_tot eq16_av ///
				eq16_tot eq17_av eq17_tot eq18_av eq18_tot eq19_av eq19_tot ///
				eq20_av eq20_tot eq21_av eq21_tot eq22_av eq22_tot eq23_av ///
				eq23_tot eq24_av ipc_reuse ipc_steril ipc_steril_oth ipc_sharps_av ///
				ipc_sharps ipc_sharps_oth ipc_infec ipc_infec_oth ipc_disinf_av ///
				ipc_soap_av charge_emerg_yes charge_anc1 charge_anc2 charge_del ///
				charge_pnc obs_build obs_infra obs_inclean obs_outclean ///
				obs_waitfan obs_waitdel obs_sign_sym obs_sign_red obs_sign_face ///
				obs_sign_dist obs_sign_oth obs_arr_dist obs_san_pat obs_pats_tot ///
				obs_mask_tot obs_child_tot obs_curt obs_curtclean obs_extable ///
				obs_sharps obs_infout obs_n95_on obs_shield_on obs_mask_on ///
				obs_water obs_bowl obs_bowl_change obs_soap obs_san_cons ///
				obs_glove_on obs_wash end
				
	*Saving file
	save "${outputs}/facility_f2", replace
