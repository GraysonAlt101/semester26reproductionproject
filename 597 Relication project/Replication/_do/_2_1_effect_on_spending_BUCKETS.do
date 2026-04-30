/*=========================================================================================================
** Making Bricks from Straw: Resources and Productivity in Health Care
** MODIFIED VERSION - Three-bucket spending regression for Table 3
**
** This file is a modified copy of _2_1_effect_on_spending.do
** The modification: instead of running Table 3 on 7 separate spending categories,
** we combine them into 3 buckets following Okeke's own narrative summary
** ("47 cents to quality, 35 cents to subsidies, the rest to operations"):
**
**     Quality investment  = Equipment + Renovation + Supplies + Staff
**     Demand subsidy      = Patient incentives
**     Operations          = Running costs + Outreach
**
** What this file produces:
**     - Original Table 2 (effect on spending) - UNCHANGED from Okeke
**     - Modified Table 3 (3 buckets instead of 7) -> tab_spend3_buckets.tex
**     - All other tables/figures - UNCHANGED from Okeke
=========================================================================================================*/


/*------------------------------
    Preamble
 -------------------------------*/

clear all
set more off
set seed 123    // set seed


/*---------------------------------------------------------------------------------------------
    Read in SDS - monthly data
    (Loads the service delivery survey data and merges with baseline + treatment indicators)
---------------------------------------------------------------------------------------------*/

    use "${db_Clean}/sds_month", clear
    merge m:1 hfac using "${data}/bl", nogen                    // baseline controls
    merge m:1 hfac using "${db_Clean}/treatment", nogen keep(3) // treatment indicators


    /*-----------------------------------------------------------------------
        Reassign 'Other' expenses to the appropriate spending category.
        These are manual fixes for cases where data collectors put expenses
        in the wrong bucket. Okeke goes through specific text strings and
        moves them to the correct category.
    -----------------------------------------------------------------------*/

    loc exp e_other_tot
    loc type e_other_type

    // Move emergency referral spending into patient incentives
    foreach string in "emergency referral of 3 accident clients to federal medical center gombe,who has no means of transportation." {
        replace e_inc_p_tot=e_inc_p_tot+`exp' if `type'=="`string'"
        replace `exp'=0 if `type'=="`string'"
    }

    // Move photocopy/medical-document spending into medicine spending
    foreach string in "(Photocopy of photograph.). (Photo copy of WHO check list.)." {
        replace e_med_tot=e_med_tot+`exp' if `type'=="`string'"
        replace `exp'=0 if `type'=="`string'"
    }

    // Move various building/furniture purchases into renovation
    foreach string in "Purchase of sitting benches, Lanter and broom" "Windows and doors contains" ///
    "Facility windows and doors curtains" "New benches for ANC AND R.I" "Pad lock, book, extension wire" "Termites paste" "Labour paid" "Labour room contains" {
        replace e_renov_tot=e_renov_tot+`exp' if `type'=="`string'"
        replace `exp'=0 if `type'=="`string'"
    }

    // Move outreach activities into outreach
    foreach string in "Creation of outreach activities" {
        replace e_out_tot=e_out_tot+`exp' if `type'=="`string'"
        replace `exp'=0 if `type'=="`string'"
    }

    // Move staff-related expenses into staff incentives
    foreach string in "Casual staff House rent payment" "Refreshment during staff meeting" {
        replace e_inc_s_tot=e_inc_s_tot+`exp' if `type'=="`string'"
        replace `exp'=0 if `type'=="`string'"
    }

    // Split this expense across staff and renovation (1/3 staff, 2/3 renovation)
    foreach string in "1.Payment of casual staff 2.purchase of maternity sterilization cooker gas 3.purchase of notice board" {
        replace e_inc_s_tot=e_inc_s_tot+(`exp'*1/3) if `type'=="`string'"
        replace e_renov_tot=e_renov_tot+(`exp'*2/3) if `type'=="`string'"
        replace `exp'=0 if `type'=="`string'"
    }


    /*-----------------------------------------------------------------------
        Create the 7 spending categories used in Table 3
        (Each is built from one or more raw spending variables)
    -----------------------------------------------------------------------*/

    g incent=e_inc_p_tot                                                                              // patient incentives
    egen equip=rowtotal(e_eq_tot e_repair_tot)                                                        // equipment + repairs
    egen infra=rowtotal(e_renov_tot)                                                                  // renovations
    egen supp=rowtotal(e_drug_tot e_med_tot)                                                          // drugs + medical consumables
    egen run=rowtotal(e_power_tot e_water_tot e_fuel_tot e_waste_tot e_laundry_tot e_stat_tot e_comm_tot)  // running costs
    g staff=e_inc_s_tot                                                                               // staff incentives
    g outreach=e_out_tot                                                                              // outreach
    egen total=rowtotal(e_*_tot)                                                                      // total spending

    // Variable labels (used for table headers)
    label var total "TOTAL"
    label var incent "Patient incentives"
    label var staff "Staff incentives"
    label var outreach "Outreach"
    label var supp "Supplies"
    label var equip "Equipment"
    label var run "Running costs"
    label var infra "Renovation/repairs"


    /*-----------------------------------------------------------------------
        Identify outliers and top-code them at the 99th percentile.
        Outliers = values more than 4 SDs from the clinic's mean.
        Note: incentives, equipment, renovation, and staff are NOT top-coded
        because Okeke says these are "extremely lumpy" and the high values
        are real, not data errors.
    -----------------------------------------------------------------------*/

    // For these 4 categories: just copy the raw value (no top-coding)
    foreach y of varlist incent equip infra staff {
        g _`y'=`y'
    }

    // For these 3 categories: top-code outliers
    foreach y of varlist supp run outreach {
        tempvar x
        qui bys hfac: egen `x'=std(`y')
        g out_`y'=`x'>4 & `x'<.                          // flag outliers
        g _`y'=`y'
        g x1=`y' if out_`y'==0
        bys hfac: egen x2=pctile(x1), p(99)
        replace _`y'=x2 if x1==.                         // replace outlier with 99th percentile
        drop x?
    }

    // Total spending after top-coding (used in Table 2)
    g _total= _incent+_equip+_infra+_staff+_supp+_run+_outreach



/*------------------------------------------------------------------------------------------------------
    Figure 3: Median monthly facility spending
    (UNCHANGED from Okeke - produces total.eps showing spending trends across 3 arms)
-------------------------------------------------------------------------------------------------------*/

    foreach y in total {
        preserve
            loc a : variable label `y'
            loc x month
            format month %tdMon-YY
            loc style lpat(dot) style(unextended)
            collapse (p50) `y', by(clinic `x')                              // collapse to median by month-arm
            replace `y'=`y'/1000                                            // rescale to thousands
            #delimit;
                twoway (connected `y' `x' if clinic==2, mc(red) lcolor(red) lp(dash))
                (connected `y' `x' if clinic==1, mc(blue) lcolor(blue))
                (connected `y' `x' if clinic==0, mc(gs10) lcolor(gs10)),
                tline(01Jun2019, `style') tline(01Oct2019, `style')
                tline(01Jan2020, `style') tline(01Jun2020, `style')
                title("", margin(b=3)) ytitle("Spending (N000's)") xtitle("")
                ysc(range(0 100)) yla(20(20)100)
                saving("$out/`y'", replace) scheme(s1mono)
                legend(order(1 "Grant" 2 "Encourage" 3 "Control" )
                rows(3) position(2) ring(0) symxsize(3) size(small) region(lw(none)));
                gr export "$out/`y'.eps", as(eps) preview(off) replace;
            #delimit cr
        restore
    }


/*------------------------------------------------------------------------------------------------------
    Table 2: Effect on spending
    (UNCHANGED from Okeke - produces tab_total.tex showing total monthly spending effects)
-------------------------------------------------------------------------------------------------------*/

    // Load custom test programs (defines test_effects, etc.)
    do "${replication_do}/programs"

    keep if month>=td(01Jun2019)            // restrict to observation period

    eststo clear
    loc x lab

    // Column 1: GLM with no baseline controls
    preserve
        loc y _total
        replace `y'=`y'/1000                // rescale to thousands

        qui glm `y' i.($tvars $xvars clinic), link(log) fam(gamma) vce(cl $cl)
        eststo: margins, dydx(clinic) post
        sum `y' if clinic==0 & e(sample)==1
        test_effects

        // Column 2: GLM with lab baseline control
        qui glm `y' i.(`x' $tvars $xvars clinic), link(log) fam(gamma) vce(cl $cl)
        eststo: margins, dydx(clinic) post
        sum `y' if clinic==0 & e(sample)==1
        test_effects
    restore

    // Column 3: Median (quantile) regression
    preserve
        loc y total
        replace `y'=`y'/1000
        qui qreg2 `y' i.(`x' $tvars $xvars clinic), cluster($cl)
        eststo: margins, dydx(clinic) post
        sum `y' if clinic==0 & e(sample)==1
        test_effects
    restore

    // Column 4: Log-OLS regression
    preserve
        loc y _total
        replace `y'=ln(`y')
        eststo: reghdfe `y' i.(`x' clinic), cluster($cl) abs($tvars $xvars)
        sum `y' if clinic==0 & e(sample)==1
        test_effects
    restore

    esttab using "$out/tab_total", $posttext mtitles("Spending (N000's)" "Spending (N000's)" "Spending (N000's)" "Log spending") $scalar



/*========================================================================================================
    *** MODIFICATION STARTS HERE ***
    Build the three combined buckets used in our modified Table 3.
========================================================================================================*/

/*------------------------------------------------------------------------------------------------------
    Build the 3 combined buckets
        Quality investment  = Equipment + Renovation + Supplies + Staff
        Demand subsidy      = Patient incentives
        Operations          = Running costs + Outreach
-------------------------------------------------------------------------------------------------------*/

    // Build the three buckets using the top-coded variables (the underscore versions)
    gen _quality_invest = _equip + _infra + _supp + _staff
    gen _demand_subsidy = _incent
    gen _operations     = _run + _outreach

    // Add labels for table headers
    label var _quality_invest "Quality investment"
    label var _demand_subsidy "Demand subsidy"
    label var _operations "Operations"

    // Sanity check: the three buckets should sum to the same total as the 7 categories
    // (If this fails, something is wrong with the bucket construction)
    assert _quality_invest + _demand_subsidy + _operations == ///
           _incent + _equip + _infra + _supp + _staff + _run + _outreach



/*------------------------------------------------------------------------------------------------------
    *** MODIFIED Table 3: How did health workers allocate the capital? (3 buckets version)
    Saves to: tab_spend3_buckets.tex
    (This replaces Okeke's 7-column Table 3 with a 3-column version using our buckets)
-------------------------------------------------------------------------------------------------------*/

    // List of outcomes (3 buckets instead of 7 categories)
    loc yvars _quality_invest _demand_subsidy _operations
    loc label \textsc{Quality investment} \textsc{Demand subsidy} \textsc{Operations}
    loc x lab
    loc it logit

    eststo clear
    foreach y of local yvars {
        preserve
            replace `y'=`y'/1000                                                                // rescale to thousands

            // Two-part model: logit for any spending, GLM for amount given any
            twopm `y' i.(`x' $xvars $tvars clinic), f(`it', asis) s(glm, family(gamma) link(log)) vce(cl $cl)
            eststo: margins, dydx(clinic) post

            // Calculate fraction of zeros (for the table footer)
            count if e(sample)==1
            loc den=r(N)
            count if `y'==0 & e(sample)==1
            loc num=r(N)
            scalar n=`num'/`den'
            estadd sca n

            // Calculate control mean (for the table footer)
            sum `y' if e(sample) & clinic==0
            test_effects
        restore
    }

    // Export the modified table
    esttab using "$out/tab_spend3_buckets", $posttext mtitles(`label') scalars("mean Control mean" "n Fraction of zeros" "test1 p (Grant=Control)" "test2 p (Grant=Encourage)" "test3 p (Grant=Non-Grant)")


/*========================================================================================================
    *** MODIFICATION ENDS HERE ***
    Below this point everything is Okeke's original code, unchanged.
    These produce the appendix tables (A.2, A.3, A.4, A.5, A.6) and Figure A.5.
========================================================================================================*/



/*------------------------------------------------------------------------------------------------------
    Table A.2: Effect on spending (simple OLS)
    (UNCHANGED - produces tab_total_ols.tex)
-------------------------------------------------------------------------------------------------------*/

    eststo clear
    loc x lab
    preserve
        loc y _total
        replace `y'=`y'/1000

        qui eststo: reghdfe `y' `x' i.(clinic), abs($tvars $xvars) vce(cl $cl)
        sum `y' if clinic==0 & e(sample)==1
        test_effects
    restore
    esttab using "$out/tab_total_ols", $posttext nomtitles $scalar



/*------------------------------------------------------------------------------------------------------
    Table A.4: How did health workers allocate the capital (Two-part model)
    (UNCHANGED - produces tab_spend1.tex and tab_spend2.tex showing extensive/intensive margins)
-------------------------------------------------------------------------------------------------------*/

    // Note: this still uses the original 7 categories, not our 3 buckets
    loc yvars _incent _equip _infra _supp _staff _run _outreach
    loc label \textsc{Incentives} \textsc{Equipment} \textsc{Renovation} \textsc{Supplies} \textsc{Staff} \textsc{Running} \textsc{Outreach}
    loc x lab
    loc it logit

    // Extensive margin: probability of any spending
    eststo clear
    foreach y of local yvars {
        preserve
            replace `y'=`y'>0
            qui `it' `y' i.(`x' $xvars $tvars clinic), asis vce(cl $cl)
            eststo: margins, dydx(clinic) post
            sum `y' if e(sample) & clinic==0
            test_effects
        restore
    }
    esttab using "$out/tab_spend1", $posttext mtitles(`label') $scalar

    // Intensive margin: amount given any spending
    eststo clear
    foreach y of local yvars {
        preserve
            replace `y'=`y'/1000
            qui glm `y' i.(`x' $xvars $tvars clinic) if `y'>0, family(gamma) link(log) vce(cl $cl)
            eststo: margins, dydx(clinic) post
            sum `y' if e(sample) & clinic==0
            test_effects
        restore
    }
    esttab using "$out/tab_spend2", $posttext nonum mtitles(`label') $scalar



/*------------------------------------------------------------------------------------------------------
    Table A.5: How did health workers allocate the capital (OLS)
    (UNCHANGED - produces tab_spend_ols.tex)
-------------------------------------------------------------------------------------------------------*/

    preserve
        eststo clear
        foreach y of local yvars {
            replace `y'=`y'/1000
            qui reghdfe `y' i.(`x' clinic), vce(cluster $cl) abs($xvars $tvars)
            eststo: margins, dydx(clinic) post
            sum `y' if e(sample) & clinic==0
            test_effects
        }
        esttab using "$out/tab_spend_ols", $posttext mtitles(`label') $scalar
    restore



/*------------------------------------------------------------------------------------------------------
    Table A.6: How did health workers allocate the capital (extensive/intensive margins)
    (UNCHANGED - produces tab_spendlog1.tex and tab_spendlog2.tex)
-------------------------------------------------------------------------------------------------------*/

    loc yvars _incent _equip _infra _supp _staff _run _outreach
    loc label \textsc{Incentives} \textsc{Equipment} \textsc{Renovation} \textsc{Supplies} \textsc{Staff} \textsc{Running} \textsc{Outreach}
    loc x lab

    // Extensive margin (linear probability model)
    eststo clear
    foreach y of local yvars {
        preserve
            replace `y'=`y'>0
            eststo: reghdfe `y' i.(`x' clinic), abs($xvars $tvars) vce(cl $cl)
            sum `y' if e(sample) & clinic==0
            test_effects
        restore
    }
    esttab using "$out/tab_spendlog1", $posttext mtitles(`label') $scalar

    // Intensive margin (log OLS)
    eststo clear
    foreach y of local yvars {
        preserve
            replace `y'=ln(`y')
            eststo: reghdfe `y' i.(`x' clinic), abs($xvars $tvars) vce(cl $cl)
            sum `y' if e(sample) & clinic==0
            test_effects
        restore
    }
    esttab using "$out/tab_spendlog2", $posttext nonum mtitles(`label') $scalar



/*------------------------------------------------------------------------------------------------------
    Did the grant crowd out other sources of external funding?
    (UNCHANGED - reloads data for the crowd-out analysis)
-------------------------------------------------------------------------------------------------------*/

    use "${db_Clean}/sds_month", clear
    merge m:1 hfac using "${data}/bl", nogen
    merge m:1 hfac using "${db_Clean}/treatment", nogen keep(3)

    // Fix one obvious data entry error in Kano state
    replace r_sg_tot=100000 if r_sg_tot==1000000



/*------------------------------------------------------------------------------------------------------
    Figure A.5: Payments received from a non-governmental organization
    (UNCHANGED - produces ngofunds.eps)
-------------------------------------------------------------------------------------------------------*/

    label define clinic 0 Control 1 Encourage 2 Grant, modify
    label values clinic clinic
    #delimit;
        hist r_ngo_tot if r_ngo_tot>0, frac width(10000)
        by(, title("") caption(`""')
        note(`""')) by(clinic, row(1))  by(, legend(off))
         by(clinic) xti("") saving("$out/ngofunds", replace)
         ysc(range(.2 1)) xla(0(50000)400000, angle(90) labsize(small));
         gr export "$out/ngofunds.eps", as(eps) preview(off) replace;
    #delimit cr



/*------------------------------------------------------------------------------------------------------
    Table A.3: Did the grant crowd out other sources of external funding?
    (UNCHANGED - produces tab_crowdout.tex)
-------------------------------------------------------------------------------------------------------*/

    // List of all non-grant funding sources
    loc funds r_fg_tot r_sg_tot r_lg_tot r_ins_tot r_ngo_tot r_comm_tot r_phil_tot r_s_oth_tot

    // Version 1: exclude N50,000 monthly equivalents
    loc v funds
    replace r_ngo_tot=0 if inlist(r_ngo_tot,50000) & clinic==2
    egen `v'= rowtotal(`funds')
    g any`v'=`v'>0
    g log`v'=ln(`v')

    // Version 2: exclude N150,000 actual quarterly payments
    loc v funds2
    replace r_ngo_tot=0 if inlist(r_ngo_tot,150000) & clinic==2
    egen `v'= rowtotal(`funds')
    g any`v'=`v'>0
    g log`v'=ln(`v')

    loc x lab

    // Run regressions on both versions
    eststo clear
    foreach y in anyfunds logfunds anyfunds2 logfunds2 {
        qui eststo:reghdfe `y' i.(`x' clinic), cl($cl) abs($xvars $tvars)
        sum `y' if clinic==0 & e(sample)==1
        test_effects
    }

    // Export with grouped column headers
    #delimit;
        esttab using "$out/tab_crowdout", $posttext $scalar
        mtitle("Any funds" "Log funds" "Any funds" "Log funds")
        mgroups("Excludes any N50,000 payments" "Excludes any N150,000 payments", pattern(1 0 1 0)
        prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}));
    #delimit cr


/* END OF FILE */
