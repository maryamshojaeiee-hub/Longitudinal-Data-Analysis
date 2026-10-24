libname mydata '/home/u64055575/LDA1';

data BPRS_long;
  set mydata.alzheimer25;
  array BPRS_w[7] BPRS0-BPRS6;
  do time = 0 to 6;
    BPRS = BPRS_w[time+1];
    output;
  end;
  keep PATID SEX TRIAL EDU JOB time BPRS;
run;

proc loess data=BPRS_long plots=none;
  model BPRS = time;
  output out=BPRS_residuals predicted=meanBPRS residual=residBPRS;
run;

ods graphics / loessmaxobs=10000;

proc sgplot data=BPRS_residuals;
  scatter x=time y=residBPRS / markerattrs=(symbol=CircleFilled color=red);  /* points */
  loess x=time y=residBPRS / lineattrs=(thickness=2 color=black);            /* smoothed curve */
  refline 0 / axis=y lineattrs=(pattern=shortdash color=blue);               /* zero reference */
  xaxis label="Time (years)";
  yaxis label="Residuals (Observed − Mean)";
  title "Residuals of BPRS over Time with LOESS Smoothing";
run;
