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


ods graphics / loessmaxobs=10000;

proc sgplot data=BPRS_long;
  loess x=time y=BPRS / nomarkers lineattrs=(thickness=2 color=black);
  xaxis label="Time (years)";
  yaxis label="BPRS";
  title "LOESS Smoothing of BPRS Over Time";
run;

ods graphics / loessmaxobs=10000;

proc sgplot data=BPRS_long;
  scatter x=time y=BPRS / markerattrs=(symbol=CircleFilled color=red); 
  loess x=time y=BPRS / lineattrs=(thickness=2 color=black);          
  xaxis label="Time (years)";
  yaxis label="BPRS";
  title "LOESS Smoothing of BPRS Over Time (with all observations)";
run;


ods graphics / loessmaxobs=10000;

proc sgplot data=BPRS_long;
  scatter x=time y=BPRS / group=SEX markerattrs=(symbol=CircleFilled size=4) transparency=0.5;
  loess x=time y=BPRS / group=SEX lineattrs=(thickness=2);
  xaxis label="Time (years)" values=(0 1 2 3 4 5 6);
  yaxis label="BPRS";
  title "LOESS Smoothing of BPRS Over Time by Sex";
run;

proc sgplot data=BPRS_long;
  scatter x=time y=BPRS / group=edu markerattrs=(symbol=CircleFilled size=4) transparency=0.5;
  loess x=time y=BPRS / group=edu lineattrs=(thickness=2);
  xaxis label="Time (years)" values=(0 1 2 3 4 5 6);
  yaxis label="BPRS";
  title "LOESS Smoothing of BPRS Over Time by edu";
run;

proc sgplot data=BPRS_long;
  scatter x=time y=BPRS / group=job markerattrs=(symbol=CircleFilled size=4) transparency=0.5;
  loess x=time y=BPRS / group=job lineattrs=(thickness=2);
  xaxis label="Time (years)" values=(0 1 2 3 4 5 6);
  yaxis label="BPRS";
  title "LOESS Smoothing of BPRS Over Time by job";
run;

proc sgplot data=BPRS_long;
  scatter x=time y=BPRS / group=trial markerattrs=(symbol=CircleFilled size=4) transparency=0.5;
  loess x=time y=BPRS / group=trial lineattrs=(thickness=2);
  xaxis label="Time (years)" values=(0 1 2 3 4 5 6);
  yaxis label="BPRS";
  title "LOESS Smoothing of BPRS Over Time by trial";
run;

proc sgplot data=BPRS_long;
  loess x=time y=BPRS / group=trial lineattrs=(thickness=2) nomarkers;
  xaxis label="Time (years)" values=(0 1 2 3 4 5 6);
  yaxis label="BPRS";
  title "LOESS Smoothing of BPRS Over Time by trial";
run;