libname mydata '/home/u64055575/LDA1';

proc means data=mydata.alzheimer25 mean std min max median n;
  var age; var bmi; var inkomen; var adl;
  var CDRSB0; var ABPET0; var TAUPET0;
run;

proc sgscatter data=mydata.alzheimer25;
  compare x=(age bmi adl inkomen cdrsb0 abpet0 taupet0) y=BPRS0;
  title "Scatterplots of Baseline BPRS vs Continuous Covariates";
run;
