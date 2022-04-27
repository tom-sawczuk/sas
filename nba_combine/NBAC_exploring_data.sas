* Let's look at some simple procedures we can use to explore our data;

* We can print our dataset out using proc print;
proc print data=nbac.data (obs=100);
run;

* Proc contents lets us see variable names, types and length;
proc contents data=nbac.data;
run;

* We can use proc means to get some descriptive data for our variables;
proc means data=nbac.data;
run;

* We can use 'var' and 'by' to get descriptive data for specific variables. To do this,
* we need to sort our data first;
proc sort data=nbac.data;
by position;
run;

proc means data=nbac.data;
var jump_cm;
by position;
run;

* We can explore the data using proc univariate;
proc univariate data=nbac.data normal plot;
*var height_cm;
run;

* After exploring the data, we may wish to transform variables. We can do this using the
* data procedure;
data nbac.data2;
set nbac.data;
log_weight_kg = 100 * log(weight_kg);
run;

* We can explore this new variable;
proc univariate data=nbac.data2 normal plot;
var log_weight_kg;
run;

* And we can look at the difference between raw and log transformed weight using proc
* univariate;
proc univariate data=nbac.data2 plot;
var weight_kg log_weight_kg;
run;
