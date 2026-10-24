libname mydata '/home/u64055575/LDA1';

data BPRS_long;
  set mydata.alzheimer25;
  array BPRS_w[7] BPRS0-BPRS6;
  do time = 0 to 6;
    BPRS = BPRS_w[time+1];
    output;
  end;
  keep PATID SEX TRIAL EDU JOB time BPRS age adl wzc ABPET0 TAUPET0 cdrsb0;
run;

proc contents data=BPRS_long;
run;

proc mixed data=BPRS_long method=ml;
  class SEX JOB EDU time;
  model BPRS = time AGE ADL ABPET0 SEX JOB EDU cdrsb0 / solution;
  repeated time / type=un subject=PATID r rcorr;
run;

proc mixed data=BPRS_long method=ml;
  class SEX JOB EDU time;
  model BPRS = time AGE ADL ABPET0 SEX JOB EDU / solution;
  repeated time / type=un subject=PATID r rcorr;
run;

data LR_test;
  G2 = 27796.7 - 27790;
  df = 1;  /* difference in # of parameters */
  p_value = 1 - probchi(G2, df);
run;

proc print data=LR_test noobs;
  var G2 df p_value;
run;