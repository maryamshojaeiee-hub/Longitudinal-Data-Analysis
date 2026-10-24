proc import out=alzheimer25_long
            datafile='/home/u64055575/LDA3/alzheimerlongas4.txt'
            dbms=dlm replace;
    delimiter='09'x;     /* Tab character */
run;

libname datasets '/home/u64055575/';

proc sort data=alzheimer25_long; 
    by patid year; 
run;

data for_gee;
    set alzheimer25_long;
    by patid;
    
    /* Create the lagged variable */
    previous_outcome = lag(cdrsbb);
    
    /* Ensure the lag doesn't carry over from the previous person */
    if first.patid then previous_outcome = 1; 
run;

proc gee data=for_gee descending;
    class patid yearclass sex (ref = '0');
    model cdrsbb = sex bmi age adl abpetbl year
                   sex*year bmi*year age*year adl*year abpetbl*year / dist=bin link=logit;
    repeated subject=patid / type=unstr;
    
    /* Use it here to model the missingness */
    missmodel sex adl abpetbl bmi age previous_outcome / type=obslevel; 
run;