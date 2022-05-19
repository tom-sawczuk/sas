* Let's analyse some data using SAS. Proc Mixed is really useful for our analyses
* because it can be used for both ANOVAs and Mixed Models depending on how we set up
* the model.

* First, we need to know our question. 

*		In the last two decades, has NBA combine jump height changed significantly
* 		season by season?

* We can ask this question in multiple ways, but we will start with the one-way ANOVA 
* approach. It is called a one-way ANOVA because we are trying to estimate the mean
* for one 'fixed effect' (or category). Let's use jump height as our dependent variable
* (the thing we want to know) and season as our fixed effect so we can estimate the 
* mean jump height for each season. The model is below;

proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season;
	model jump_cm = season/solution noint;

	lsmeans season/cl;
run;

* The above model gives us the least square means for jump height each season, but it
* doesn't tell us whether any of the differences are significant. We can get this
* analysis from the model in 3 ways: lsmeans (via pdiff), estimate and lsmestimate. 
* Let's look at all 3 now.;
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season;
	model jump_cm = season/solution noint;
	
	lsmeans season/pdiff=all cl;
	
	estimate "01 - 02" season 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "02 - 03" season 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "03 - 04" season 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "04 - 05" season 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "05 - 06" season 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "06 - 07" season 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "07 - 08" season 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "08 - 09" season 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "09 - 10" season 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "10 - 11" season 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "11 - 12" season 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "12 - 13" season 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "13 - 14" season 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "14 - 15" season 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0/cl alpha=0.05;
	estimate "15 - 16" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0/cl alpha=0.05;
	estimate "16 - 17" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0/cl alpha=0.05;
	estimate "17 - 18" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0/cl alpha=0.05;
	estimate "18 - 19" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0/cl alpha=0.05;
	estimate "19 - 20" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0/cl alpha=0.05;
	estimate "20 - 21" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1/cl alpha=0.05;
	
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

* Alongside its easier syntax, lsmestimate has another enormous advantage over
* estimate - the ability to group estimates/differences together. This is particularly
* important when we want to correct for the assessment of multiple differences (e.g
* via the Bonferroni correction);
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season;
	model jump_cm = season/solution noint;
	
	lsmeans season/pdiff=all cl adjust=bon;

	estimate "01 - 02" season 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "02 - 03" season 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "03 - 04" season 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "04 - 05" season 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "05 - 06" season 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "06 - 07" season 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "07 - 08" season 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "08 - 09" season 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "09 - 10" season 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "10 - 11" season 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "11 - 12" season 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "12 - 13" season 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "13 - 14" season 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0/cl alpha=0.05;
	estimate "14 - 15" season 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0/cl alpha=0.05;
	estimate "15 - 16" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0/cl alpha=0.05;
	estimate "16 - 17" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0/cl alpha=0.05;
	estimate "17 - 18" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0/cl alpha=0.05;
	estimate "18 - 19" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0/cl alpha=0.05;
	estimate "19 - 20" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0/cl alpha=0.05;
	estimate "20 - 21" season 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1/cl alpha=0.05;
	
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
	/cl adjust=bon;
run;
