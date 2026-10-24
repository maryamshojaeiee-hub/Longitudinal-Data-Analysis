proc import out=alzheimer25_long
            datafile='/home/u64055575/LDA3/alzheimerlongas4.txt'
            dbms=dlm replace;
    delimiter='09'x;     /* Tab character */
run;

libname datasets '/home/u64055575/';

/* full model  + UN */
proc mixed data=alzheimer25_long method=reml empirical;
    class patid yearclass sex;
    model bprs = sex age bmi cdrsbbl abpetbl
                 year sex*year age*year bmi*year cdrsbbl*year abpetbl*year
                 / noint solution;
    random intercept year/ type=un subject=patid;
    repeated yearclass / type=un subject=patid;
run;

/* full model  + toep */
proc mixed data=alzheimer25_long method=reml empirical;
    class patid yearclass sex;
    model bprs = sex age bmi cdrsbbl abpetbl
                 year sex*year age*year bmi*year cdrsbbl*year abpetbl*year
                 / noint solution;
    random intercept year/ type=un subject=patid;
    repeated yearclass / type=toep subject=patid;
run;

/* full model  + arh(1) */
proc mixed data=alzheimer25_long method=reml empirical;
    class patid yearclass sex;
    model bprs = sex age bmi cdrsbbl abpetbl
                 year sex*year age*year bmi*year cdrsbbl*year abpetbl*year
                 / noint solution;
    random intercept year/ type=un subject=patid;
    repeated yearclass / type=arh(1) subject=patid;
run;


/* now I am going to reduce mean structure 
from here ML is used*/

proc mixed data=alzheimer25_long method=ml empirical;
    class patid yearclass sex;
    model bprs = sex age bmi cdrsbbl abpetbl
                 year sex*year age*year bmi*year cdrsbbl*year abpetbl*year
                 / noint solution;
    random intercept year/ type=un subject=patid;
    repeated yearclass / type=arh(1) subject=patid;
run;

proc mixed data=alzheimer25_long method=ml empirical;
    class patid yearclass sex;
    model bprs = sex age bmi cdrsbbl abpetbl
                 year sex*year age*year bmi*year cdrsbbl*year 
                 / noint solution;
    random intercept year/ type=un subject=patid;
    repeated yearclass / type=arh(1) subject=patid;
run;

proc mixed data=alzheimer25_long method=ml empirical;
    class patid yearclass sex;
    model bprs = sex age bmi cdrsbbl abpetbl
                 year sex*year age*year  cdrsbbl*year 
                 / noint solution;
    random intercept year/ type=un subject=patid;
    repeated yearclass / type=arh(1) subject=patid;
run;

proc mixed data=alzheimer25_long method=ml empirical;
    class patid yearclass sex;
    model bprs = sex age bmi cdrsbbl abpetbl
                 year sex*year  cdrsbbl*year 
                 / noint solution;
    random intercept year/ type=un subject=patid;
    repeated yearclass / type=arh(1) subject=patid;
run;

proc mixed data=alzheimer25_long method=ml empirical;
    class patid yearclass sex;
    model bprs = sex age bmi cdrsbbl abpetbl
                 year  cdrsbbl*year 
                 / noint solution;
    random intercept year/ type=un subject=patid;
    repeated yearclass / type=arh(1) subject=patid;
run;

/* now reducing intercept, we have slope for cdrsb so we wont check it*/
proc mixed data=alzheimer25_long method=ml empirical;
    class patid yearclass sex(ref = '0');
    model bprs = sex age bmi cdrsbbl abpetbl
                 year  cdrsbbl*year 
                 / solution;
    random intercept year/ type=un subject=patid;
    repeated yearclass / type=arh(1) subject=patid;
run;

