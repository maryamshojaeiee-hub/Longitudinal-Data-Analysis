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

proc mixed data=BPRS_long;
  class PATID time;
  model BPRS = time / solution;
  random intercept / subject=PATID;
  repeated time / subject=PATID type=un rcorr; 
run;


