libname mydata '/home/u64055575/LDA1';

/* Convert wide BPRS0-BPRS6 into long format */
data BPRS_long;
  set mydata.alzheimer25;
  array BPRS_w[7] BPRS0-BPRS6;
  do time = 0 to 6;
    BPRS = BPRS_w[time+1];
    output;
  end;
  keep PATID time BPRS;
run;

/* sorted by patient and time */
proc sort data=BPRS_long;
  by PATID time;
run;

data BPRS_summary;
  set BPRS_long;
  by PATID time;

  retain BPRS0 BPRS_last;

  /* Change from baseline */
  if first.PATID then do;
    BPRS0 = BPRS;
    BPRS_last = .; 
  end;

  if not missing(BPRS) then BPRS_last = BPRS;

  if last.PATID then do;
    BPRS_change = BPRS_last - BPRS0;
    output;
  end;

  keep PATID BPRS0 BPRS_last BPRS_change;
run;

proc print data=BPRS_summary(obs=20);
run;

proc reg data=BPRS_long outest=BPRS_slope noprint;
  by PATID;
  model BPRS = time;
run;

  /* Slope of BPRS over time (per subject) */
 proc reg data=BPRS_long outest=BPRS_slope noprint;
  by PATID;
  model BPRS = time;
run;

 /*Area Under the Curve (AUC) */
proc means data=BPRS_long noprint;
  by PATID;
  var BPRS;
  output out=BPRS_AUC sum=BPRS_AUC mean=BPRS_mean;
run;

 /*Merge all summaries into one dataset */
/* Clean up before merging */
data BPRS_summary_change;
  set BPRS_summary; /* your earlier step created BPRS_summary, rename to _change for clarity */
run;

data BPRS_slope_clean;
  set BPRS_slope;
  keep PATID time BPRS time; /* remove _TYPE_ and _FREQ_ */
  drop _TYPE_ _FREQ_;
run;

data BPRS_AUC_clean;
  set BPRS_AUC;
  drop _TYPE_ _FREQ_;
run;

/* Merge all summaries into one dataset */
/* Clean up before merging */
data BPRS_summary_change;
  set BPRS_summary; /* your earlier step created BPRS_summary, rename to _change for clarity */
run;

data BPRS_slope_clean;
  set BPRS_slope;
  keep PATID time;
  rename time = Slope_BPRS;
run;

data BPRS_AUC_clean;
  set BPRS_AUC;
  drop _TYPE_ _FREQ_;
run;

/* Merge all summaries into one dataset */
data BPRS_summary_all;
  merge BPRS_summary_change(in=a)
        BPRS_slope_clean(in=b)
        BPRS_AUC_clean(in=c);
  by PATID;
  if a; /* keep only patients in the change dataset */
run;

proc print data=BPRS_summary_all(obs=20);
run;

/* Classical analyses for all summaries */
data baseline_cov;
  set mydata.alzheimer25;
  keep PATID SEX EDU JOB WZC AGE BMI ADL CDRSB0 ABPET0 TAUPET0;
run;

proc sort data=baseline_cov;      by PATID; run;
proc sort data=BPRS_summary_all;  by PATID; run;

data BPRS_summary_all;
  merge BPRS_summary_all(in=a) baseline_cov(in=b);
  by PATID;
  if a;  /* keep only patients with BPRS summary info */
run;

proc glm data=BPRS_summary_all;
  class SEX EDU JOB WZC;
  model BPRS_change = SEX EDU JOB WZC AGE BMI ADL CDRSB0 ABPET0 TAUPET0;
  title "Model 1: Predictors of total BPRS change (last - baseline)";
run;

proc glm data=BPRS_summary_all;
  class SEX EDU JOB WZC;
  model Slope_BPRS = SEX EDU JOB WZC AGE BMI ADL CDRSB0 ABPET0 TAUPET0;
  title "Model 2: Predictors of BPRS slope (rate of change)";
run;

proc glm data=BPRS_summary_all;
  class SEX EDU JOB WZC;
  model BPRS_mean = SEX EDU JOB WZC AGE BMI ADL CDRSB0 ABPET0 TAUPET0;
  title "Model 3: Predictors of average BPRS (AUC-based mean)";
run;
quit;

