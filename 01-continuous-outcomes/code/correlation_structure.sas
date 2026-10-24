libname mydata '/home/u64055575/LDA1';

proc sgscatter data=mydata.alzheimer25;
  matrix BPRS0 BPRS1 BPRS2 BPRS3 BPRS4 BPRS5 BPRS6 / 
         diagonal=(histogram);
  title "Pairwise Scatterplots of BPRS Measurements Over Time";
run;


