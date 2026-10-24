libname mydata '/home/u64055575/LDA1';

proc means data=mydata.alzheimer25 n nmiss;
  var BPRS0 BPRS1 BPRS2 BPRS3 BPRS4 BPRS5 BPRS6;
  title "Counts (N) and Missing (NMiss) for BPRS at each time point";
run;

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

/* Randomly select 20 patients */
proc surveyselect data=mydata.alzheimer25 out=sample_patients
                  method=srs sampsize=50 seed=12345;
run;

/* Keep only the selected patients in long dataset */
proc sql;
  create table BPRS_sampled as
  select L.*
  from BPRS_long as L
  inner join sample_patients as S
  on L.PATID = S.PATID;
quit;

/* Plot simple black lines for 20 patients */
proc sgplot data=BPRS_sampled;
  series x=time y=BPRS / group=PATID lineattrs=(color=black pattern=solid thickness=1);
  xaxis label="Time (years)" values=(0 1 2 3 4 5 6);
  yaxis label="BPRS Score";
  title "Individual BPRS Profiles for 50 Random Patients";
run;


