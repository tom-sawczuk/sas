* Let's try another example, this time using athlete monitoring data. When working
* with multiple measurements from the same person (i.e. repeated measures), we know
* that there is no chance the data is independent. Athlete monitoring data is a prime
* example. Some athletes will always feel better than others, some will get extremely
* fatigued by training, others will handle it better. As such, it is important that
* we account for all of these correlations/differences within the models we produce.
* We will do that here.

* As a reference point, let's start with the null model like last time;
proc mixed data=mon.data1 plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	model DWB100 = ;
	estimate "Intercept" int 1/cl;
run;

* Now, we group sleep into z-score groups (LOW: <-1z, MED: -1z to 1z, HIGH >1z) and
* run a random intercept mixed model. This works exactly the same as last time;
proc mixed data=mon.data1 plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class NameID zgroupsleep;
	model DWB100 = zgroupsleep/solution;
	random intercept/subject=NameID solution;
	estimate "Intercept" int 1/cl;
	estimate "Int 9"  int 1 | int 1 /subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Int 11" int 1 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Int 12" int 1 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Int 13" int 1 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	lsmeans zgroupsleep/pdiff=all cl;
	estimate "Athlete 9: Low"  int 1 zgroupsleep 1 0 0 | int 1 /subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 9: Med"  int 1 zgroupsleep 0 1 0 | int 1 /subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 9: High" int 1 zgroupsleep 0 0 1 | int 1 /subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11: Low" int 1 zgroupsleep 1 0 0 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11: Med" int 1 zgroupsleep 0 1 0 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11: High"int 1 zgroupsleep 0 0 1 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12: Low" int 1 zgroupsleep 1 0 0 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12: Med" int 1 zgroupsleep 0 1 0 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12: High"int 1 zgroupsleep 0 0 1 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 13: Low" int 1 zgroupsleep 1 0 0 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 13: Med" int 1 zgroupsleep 0 1 0 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 13: High"int 1 zgroupsleep 0 0 1 | int 1 /subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;	
run;

* The problem with discretising a continous measure such as sleep like we have done so
* far is the amount of information we lose in doing it. Sometimes that's a good thing
* as it simplifies the problem, but sometimes the amount of information and model
* flexibility we lose isn't worth it. Let's have a look at the same analysis, but using
* sleep as a continous variable. With sleep as a continuous variable, we now don't have
* the point estimates we have been using previously, we can simply fit a line through
* the athletes' individual data. This is still a random intercepts model;
proc mixed data=mon.data1 plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class NameID;
	model DWB100 = mcsleep_sas/solution;
	random intercept/subject=NameID solution;
	estimate "1hr sleep" mcsleep_sas 1/cl;
	estimate "Intercept -6" int 1 mcsleep_sas -6/cl;
	estimate "Intercept +8" int 1 mcsleep_sas 8/cl;
	estimate "Athlete 9 -6"  int 1 mcsleep_sas -6| int 1/subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 9 +8"  int 1 mcsleep_sas 8| int 1/subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11 -6" int 1 mcsleep_sas -6| int 1/subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11 +8" int 1 mcsleep_sas 8| int 1/subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 -6" int 1 mcsleep_sas -6| int 1/subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 +8" int 1 mcsleep_sas 8| int 1/subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 13 -6" int 1 mcsleep_sas -6| int 1/subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 13 -6" int 1 mcsleep_sas 8| int 1/subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
run;

* Using a random intercept with a covariate is good as it allows for some of the
* variation between athletes to be accounted for, but it's also limited because every
* athlete's intercept must have the same gradient as the covariate mean. To change
* this, we can use a random slopes model, which allows every athlete to have their
* own intercept AND slope, giving the model full flexibility to model the response;
proc mixed data=mon.data1 plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class NameID;
	model DWB100 = mcsleep_sas/solution;
	random intercept mcsleep_sas/subject=NameID solution type=un;
	estimate "1hr sleep" mcsleep_sas 1/cl;
	estimate "Intercept -6" int 1 mcsleep_sas -6/cl;
	estimate "Intercept +8" int 1 mcsleep_sas 8/cl;
	estimate "Athlete 9 -6"  int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 9 +8"  int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11 -6" int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11 +8" int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 -6" int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 +8" int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 -6" int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 -6" int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
run;

* Now that we've got a pretty good understanding of the relationship between sleep and
* DWB at an individual level, let's add training load to the model;
proc mixed data=mon.data1 plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class NameID;
	model DWB100 = mcsleep_sas mcload_sas/solution;
	random intercept mcsleep_sas /subject=NameID solution type=un;
	estimate "1hr sleep" mcsleep_sas 1/cl;
	estimate "1 unit load" mcload_sas 1/cl;
	estimate "Intercept -6" int 1 mcsleep_sas -6/cl;
	estimate "Intercept +8" int 1 mcsleep_sas 8/cl;
	estimate "Athlete 9 -6"  int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 9 +8"  int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11 -6" int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11 +8" int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 -6" int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 +8" int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 13 -6" int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 13 -6" int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
run;

* And the really cool thing is that we can get individual slopes for the training load
* as well! Let's try that now.;
proc mixed data=mon.data1 plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class NameID;
	model DWB100 = mcsleep_sas mcload_sas/solution;
	random intercept mcsleep_sas mcload_sas/subject=NameID solution type=un;
	estimate "1hr sleep" mcsleep_sas 1/cl;
	estimate "1 unit load" mcload_sas 1/cl;
	estimate "Intercept -6" int 1 mcsleep_sas -6/cl;
	estimate "Intercept +8" int 1 mcsleep_sas 8/cl;
	estimate "Athlete 9 -6"  int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 9 +8"  int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11 -6" int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11 +8" int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 -6" int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 +8" int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 13 -6" int 1 mcsleep_sas -6| int 1 mcsleep_sas -6/subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 13 -6" int 1 mcsleep_sas 8| int 1 mcsleep_sas 8/subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
run;

* Unfortunately, we run into problems because the two covariates aren't on the same
* scale. 1 hr of sleep has a much greater effect than 1 unit of training load, so it
* overpowers the effect of load and makes it difficult for the model to estimate
* parameters for both. The way to resolve this is to put both variables on the same
* scale so that they can be treated equally. As per Gelman(2008), we use a scale which
* standardises sleep and training load to two within-participant standard deviation 
* changes here and run the model again;
proc mixed data=mon.data1 plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class NameID;
	model DWB100 = z2sleep z2load/solution;
	random intercept z2sleep z2load/subject=NameID type=un;
	estimate "2SD+ sleep" z2sleep 1/cl;
	estimate "2SD+ load" z2load 1/cl;
	estimate "Intercept -1.35" int 1 z2sleep -0.5/cl;
	estimate "Intercept +1.35" int 1 z2sleep 0.5/cl;
	estimate "Athlete 9 -1SD"  int 1 z2sleep -0.5| int 1 z2sleep -0.5/subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 9 +1SD"  int 1 z2sleep 0.5| int 1 z2sleep 0.5/subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11 -1SD" int 1 z2sleep -0.5| int 1 z2sleep -0.5/subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 11 +1SD" int 1 z2sleep 0.5| int 1 z2sleep 0.5/subject 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 -1SD" int 1 z2sleep -0.5| int 1 z2sleep -0.5/subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 12 +1SD" int 1 z2sleep 0.5| int 1 z2sleep 0.5/subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 13 -1SD" int 1 z2sleep -0.5| int 1 z2sleep -0.5/subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Athlete 13 +1SD" int 1 z2sleep 0.5| int 1 z2sleep 0.5/subject 0 0 0 0 0 0 0 0 0 0 0 0 1 cl;
run;


* There's a problem with this model though. So far, all we can say is that reducing 
* sleep duration and increasing training load is associated with a lower DWB score the 
* next day. Unfortunately, with the model we have run, we haven't yet established the 
* influence of either variable on the CHANGE in DWB. And that's what we are really 
* interested in. So let's do that now using a reformatted version of the dataset;
proc mixed data=mon.data2 plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class player_id;
	model change_DWB = z2prev_DWB z2sleep z2load/solution;
	random intercept z2sleep z2load/subject=player_id type=un;
	estimate "2SD+ sleep" z2sleep 1/cl;
	estimate "2SD+ TL" z2load 1/cl;
run;

* Finally, there are numerous other things you could consider, but let's consider
* the additive effect of match load. Does playing in a match have an additional 
* impact on the DWB change above and beyond that expected by the load itself?;
proc mixed data=mon.data2 plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class player_id match;
	model change_DWB = z2prev_DWB z2sleep z2load match/solution;
	random intercept z2sleep z2load/subject=player_id type=un;
	estimate "2SD+ sleep" z2sleep 1/cl;
	estimate "2SD+ load" z2load 1/cl;
	estimate "2SD+ load with match" z2load 1 match 0 1/cl;
	estimate "2SD+ load w/o match" z2load 1 match 1 0/cl;
run;

* And because we've added match as a covariate, we can also attempt to understand the
* between athlete differences in the effect of match exposure on DWB change. This helps
* us to understand whether some athletes experience a greater change in DWB post-match
* exposure than others or if the response is fairly uniform across all athletes;
proc mixed data=mon.data2 plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class player_id;
	model change_DWB = z2prev_DWB z2sleep z2load match/solution;
	random intercept z2sleep z2load/subject=player_id type=un;
	random match/subject=player_id;
	estimate "2SD+ previous DWB" z2prev_DWB 1/cl;
	estimate "2SD+ sleep" z2sleep 1/cl;
	estimate "2SD+ load" z2load 1/cl;
	estimate "Match exposure" match 1 /cl;
	estimate "2SD+ load with match" z2load 1 match 0/cl;
	estimate "2SD+ load w/o match" z2load 1 match 1/cl;
	estimate "Player 9 2SD+ load with match" z2load 1 match 1 | z2load 1 match 1 / subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Player 9 2SD+ load w/o match" z2load 1 match 0 | z2load 1 / subject 0 0 0 0 0 0 0 0 1 cl;
	estimate "Player 12 2SD+ load with match" z2load 1 match 1 | z2load 1 match 1 / subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
	estimate "Player 12 2SD+ load w/o match" z2load 1 match 0 | z2load 1 / subject 0 0 0 0 0 0 0 0 0 0 0 1 cl;
run;

