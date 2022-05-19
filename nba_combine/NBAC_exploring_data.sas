* Let's start by having a quick look at some SAS syntax.
* Use a '*' to write a comment, which the server will ignore for calculation purposes.
* Finish every coded line with a semi-colon or you will bump into errors. This seems 
* less important for blocks of comment like this.
* Every procedure is followed by a line stating 'run (with a semi-colon)' so SAS knows
* that is the procedure has been fully defined.

* First thing to do is load some data into SAS. We then permanently assign it to a
* dataset using the 'data' procedure;
data nbac.data;
set work.import;
run;

* Now, let's look at some simple procedures we can use to explore our data.
* We can print our dataset out using proc print;
proc print data=nbac.data (obs=100);
run;

* Proc contents lets us see variable names, types and length;
proc contents data=nbac.data;
run;

* We can use proc means to get some descriptive data for our variables;
proc means data=nbac.data;
run;

proc sort data=nbac.data;
by position;
run;

proc means data=nbac.data;
var jump_cm;
by position;
run;

* To explore assumptions of normality, we can use proc univariate, which also provides
* us with a lot of descriptives, some of which we've seen before in proc means;
proc univariate data=nbac.data normal plot;
var height_cm weight_kg jump_cm;
run;

* We can use the 'data' procedure to assign data to a new dataset (which
* can be named the same thing to overwrite the dataset if you want it to);
data nbac.data2;
set nbac.data;
log_weight_kg = 100 * log(weight_kg);
run;

* Then we can run our assumption tests again;
proc univariate data=nbac.data2 normal plot;
var log_weight_kg;
run;

proc univariate data=nbac.data2 plot;
var weight_kg log_weight_kg;
run;
