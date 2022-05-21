* The ANOVA approach we have used so far for this dataset has been the right way of 
* doing things as we have all of the data for all Combine players in the last twenty
* years. In order to see how mixed models work, let's pretend that we don't. We still
* want to account for positional differences whilst we look at the season by season
* change in jump height, but we also want to account for the fact that we don't know
* about every single Combine player (i.e. those players that we don't know about who
* could change the positional differences). Our question could now be:

* 		After accounting for positional differences in this sample, has NBA Combine 
*		jump height changed significantly season by season?	

* Below is the mixed model for our new question;
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season position;
	model jump_cm = season/solution;
	random intercept/subject=position solution;
	lsmeans season/cl;
	
	* We can check how the differences between seasons compare to the two-way ANOVA
	* results. The lsmestimate statement gave:
	*		01 - 02: -3.4334 (-6.1823,-0.6845) p=0.0144
	* 		02 - 03:  4.9685 ( 2.3627, 7.5743) p=0.0002;
	lsmestimate season
	"01 - 02" [1,1] [-1,2],
	"02 - 03" [1,2] [-1,3],
	"03 - 04" [1,3] [-1,4],
	"04 - 05" [1,4] [-1,5],
	"05 - 06" [1,5] [-1,6],
	"06 - 07" [1,6] [-1,7],
	"07 - 08" [1,7] [-1,8],
	"08 - 09" [1,8] [-1,9],
	"09 - 10" [1,9] [-1,10],
	"10 - 11" [1,10] [-1,11],
	"11 - 12" [1,11] [-1,12],
	"12 - 13" [1,12] [-1,13],
	"13 - 14" [1,13] [-1,14],
	"14 - 15" [1,14] [-1,15],
	"15 - 16" [1,15] [-1,16],
	"16 - 17" [1,16] [-1,17],
	"17 - 18" [1,17] [-1,18],
	"18 - 19" [1,18] [-1,19],
	"19 - 20" [1,19] [-1,20],
	"20 - 21" [1,20] [-1,21]
	/cl;
run;
