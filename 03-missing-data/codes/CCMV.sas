
	

libname mylib '/home/u64055575/LDA3';

proc mi data=mylib.alzheimer25 seed=123456 simple nimpute=10 round=0.1 out=df_ccmv;
	class sex ;
	var sex age bmi cdrsb0
		bprs0 bprs1 bprs2 bprs3 bprs4 bprs5 bprs6;
	monotone reg;
	mnar model (bprs0 bprs1 bprs2 bprs3 bprs4 bprs5 bprs6 / modelobs=ccmv);
run;

/* Long transform */

data df_ccmv_long;
	set df_ccmv;
	array c(0:6) bprs0-bprs6;
	do i=0 to 6;
	year=i;
	yearclass=year;
	cdrsbbl = cdrsb0;
	/* Grab the IMPUTED continuous value */
	bprs=c(i);
	/* Re-calculate the Binary Outcome based on the Imputed Value */
	output;
	end;
	drop c0-c6 i;
run;

proc sort data= df_ccmv_long;
	by _imputation_ patid year;
run;


proc mixed data=df_ccmv_long method=ml empirical;
    by _imputation_;
    class patid yearclass sex(ref='0');
    model bprs = sex age bmi cdrsbbl abpet0
                 year cdrsbbl*year
                 / solution;
    random intercept year / type=un subject=patid;
    repeated yearclass / type=arh(1) subject=patid;
    ods output SolutionF=fixeff CovParms=covparms;
run;


data fixeff_no2;
    set fixeff;
    if _imputation_ = 2 then delete;
    if _imputation_ > 2 then _imputation_ = _imputation_ - 1;
run;



proc mianalyze parms=fixeff_no2;
    class sex;
    modeleffects intercept sex age bmi cdrsbbl abpet0 year cdrsbbl*year;
run;




