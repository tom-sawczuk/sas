* Let's think about building models. 
* When building statistical models, our aim is to gain an understanding of what is
* truely happening when we get a set of data. We account for statistical variability
* in the data and use this to understand trends within the data. Within frequentist
* statistics, this means we try to estimate the mean of the data we have, given the
* predictors/independent variables/fixed effects/random effects we have added to the
* model.

* We are going to focus on linear models. Linear models are 'additive' models, which 
* means that every independent variable you add to the model provides an adjustment to 
* the final output of the model depending on the data you give it. A linear model 
* requires the following assumptions to be met:
	
	* LINEAR RELATIONSHIP
	* NORMALITY - the RESIDUALS should be normally distributed
	* HOMOSCEDASTICITY - the RESIDUALS should be roughly symmetric about the x-axis
	* if plotted against the predictors/independent variables.
		* DATA INDEPENDENCE can have an impact here. Using methods such as ANOVAs,
		* data are assumed to be independent from one another. Mixed models allow us
		* to account for any lack of independence.

* We will work through how to check these assumptions over the course of the next few
* models. For now, let's move on to the statistical modelling process. Typically, it
* makes sense to start with an 'intercept' and build a model from there. In an
* intercept only model, the intercept represents the 'grand' mean of the data. The
* code for an intercept only model is below;
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	model jump_cm = / solution;
	estimate "Intercept" int 1/cl;
run;


* The grand mean gives us an early understanding of the data, but when looking at our
* data plot, it's probably not unreasonable to think that there are differences in
* jump height between seasons. Season 1 in particular may have a higher average jump
* height than seasons 3, 9 and 10. First, let's just focus on adding 'season' to the
* model as an independent variable. Doing so, will allow the model to perform an
* adjustment whereby every season is given a mean value slightly above or below the 
* intercept. This model, with one independent variable is called a one-way ANOVA;
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season;
	model jump_cm = season/ solution;
	lsmeans season/cl;
	estimate "Intercept" int 1/cl;
	lsmestimate season
		"1" [1,10],
		"2" [1, 9],
		"3" [1, 8],
		"4" [1, 7],
		"5" [1, 6],
		"6" [1, 5],
		"7" [1, 4],
		"8" [1, 3],
		"9" [1, 2],
		"10"[1, 1]
		/cl;
run;

* So now we have a mean for each season, we could run some comparisons between seasons
* to see if there are any statistical differences but let's see if we can improve the
* model first. If we look at the data plot, focussing on C, SF and SG, we can see that
* there are differences in the observed jump heights between them. If we can account
* for these differences, we might be able to improve the model. Let's add position to
* the model as an independent variable to make a Two way ANOVA;
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season position;
	model jump_cm = season position/ solution;
	lsmeans season position/cl;
	estimate "Intercept" int 1/cl;
	
	estimate "C: 1" int 1 season 0 0 0 0 0 0 0 0 0 1 position 1 /cl;
	estimate "C: 2" int 1 season 0 0 0 0 0 0 0 0 1 0 position 1 /cl;
	estimate "C: 3" int 1 season 0 0 0 0 0 0 0 1 0 0 position 1 /cl;
	estimate "C: 4" int 1 season 0 0 0 0 0 0 1 0 0 0 position 1 /cl;
	estimate "C: 5" int 1 season 0 0 0 0 0 1 0 0 0 0 position 1 /cl;
	estimate "C: 6" int 1 season 0 0 0 0 1 0 0 0 0 0 position 1 /cl;
	estimate "C: 7" int 1 season 0 0 0 1 0 0 0 0 0 0 position 1 /cl;
	estimate "C: 8" int 1 season 0 0 1 0 0 0 0 0 0 0 position 1 /cl;
	estimate "C: 9" int 1 season 0 1 0 0 0 0 0 0 0 0 position 1 /cl;
	estimate "C: 10" int 1 season 1 0 0 0 0 0 0 0 0 0 position 1 /cl;
	
	estimate "SF: 1" int 1 season 0 0 0 0 0 0 0 0 0 1 position 0 0 0 0 0 1 /cl;
	estimate "SF: 2" int 1 season 0 0 0 0 0 0 0 0 1 0 position 0 0 0 0 0 1 /cl;
	estimate "SF: 3" int 1 season 0 0 0 0 0 0 0 1 0 0 position 0 0 0 0 0 1 /cl;
	estimate "SF: 4" int 1 season 0 0 0 0 0 0 1 0 0 0 position 0 0 0 0 0 1 /cl;
	estimate "SF: 5" int 1 season 0 0 0 0 0 1 0 0 0 0 position 0 0 0 0 0 1 /cl;
	estimate "SF: 6" int 1 season 0 0 0 0 1 0 0 0 0 0 position 0 0 0 0 0 1 /cl;
	estimate "SF: 7" int 1 season 0 0 0 1 0 0 0 0 0 0 position 0 0 0 0 0 1 /cl;
	estimate "SF: 8" int 1 season 0 0 1 0 0 0 0 0 0 0 position 0 0 0 0 0 1 /cl;
	estimate "SF: 9" int 1 season 0 1 0 0 0 0 0 0 0 0 position 0 0 0 0 0 1 /cl;
	estimate "SF: 10" int 1 season 1 0 0 0 0 0 0 0 0 0 position 0 0 0 0 0 1 /cl;
	
	estimate "SG: 1" int 1 season 0 0 0 0 0 0 0 0 0 1 position 0 0 0 0 0 0 0 1 /cl;
	estimate "SG: 2" int 1 season 0 0 0 0 0 0 0 0 1 0 position 0 0 0 0 0 0 0 1 /cl;
	estimate "SG: 3" int 1 season 0 0 0 0 0 0 0 1 0 0 position 0 0 0 0 0 0 0 1 /cl;
	estimate "SG: 4" int 1 season 0 0 0 0 0 0 1 0 0 0 position 0 0 0 0 0 0 0 1 /cl;
	estimate "SG: 5" int 1 season 0 0 0 0 0 1 0 0 0 0 position 0 0 0 0 0 0 0 1 /cl;
	estimate "SG: 6" int 1 season 0 0 0 0 1 0 0 0 0 0 position 0 0 0 0 0 0 0 1 /cl;
	estimate "SG: 7" int 1 season 0 0 0 1 0 0 0 0 0 0 position 0 0 0 0 0 0 0 1 /cl;
	estimate "SG: 8" int 1 season 0 0 1 0 0 0 0 0 0 0 position 0 0 0 0 0 0 0 1 /cl;
	estimate "SG: 9" int 1 season 0 1 0 0 0 0 0 0 0 0 position 0 0 0 0 0 0 0 1 /cl;
	estimate "SG: 10" int 1 season 1 0 0 0 0 0 0 0 0 0 position 0 0 0 0 0 0 0 1 /cl;
run;

* OK, we have a decision to make now. According to our assumptions, we can see that
* we must account for position in some way because the data are clustered in some way
* around each position. Therefore, we need to decide whether we truely cared about 
* estimating the mean for the position variable or if we just wanted to account for 
* the similarities within that position. This decision is important because there are
* actually two ways we can put an independent variable into a model:
	
	* Fixed effects, which estimate the mean of each class
	* Random effects, which estimate the standard deviation across the classes
	
* So far, our ANOVAs have used fixed effects only. Let's now move on to show a model
* with fixed and random effects - a mixed model. We use season as our fixed effect
* because we definitely want to know the means and differences between means for this
* independent variable. However, we now switch position to be a random effect rather
* than a fixed effect as we decide we are not too worried by comparing differences
* between positions, we just want to account for the differences occurring. The model
* code for this RANDOM INTERCEPTS model is below;
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season position;
	model jump_cm = season;
	random intercept/subject=position solution;
	lsmeans season/cl;
	estimate "Intercept" int 1/cl;
	
	estimate "C" int 1 | int 1 / subject 1 0 0 0 0 0 0 0 0 cl;
	estimate "C_PF" int 1 | int 1 / subject 0 1 0 0 0 0 0 0 0 cl;
	estimate "PF" int 1 | int 1 / subject 0 0 1 0 0 0 0 0 0 cl;
	estimate "PF_SF" int 1 | int 1 / subject 0 0 0 1 0 0 0 0 0 cl;
	estimate "PG" int 1 | int 1 / subject 0 0 0 0 1 0 0 0 0 cl;
	estimate "SF" int 1 | int 1 / subject 0 0 0 0 0 1 0 0 0 cl;
	estimate "SF_SG" int 1 | int 1 / subject 0 0 0 0 0 0 1 0 0 cl;
	estimate "SG" int 1 | int 1 / subject 0 0 0 0 0 0 0 1 0 cl;
	estimate "SG_PG" int 1 | int 1 / subject 0 0 0 0 0 0 0 0 1 cl;

	estimate "C: 1" int 1 season 0 0 0 0 0 0 0 0 0 1 | int 1 / subject 1 cl;
	estimate "C: 2" int 1 season 0 0 0 0 0 0 0 0 1 0 | int 1 / subject 1 cl;
	estimate "C: 3" int 1 season 0 0 0 0 0 0 0 1 0 0 | int 1 / subject 1 cl;
	estimate "C: 4" int 1 season 0 0 0 0 0 0 1 0 0 0 | int 1 / subject 1 cl;
	estimate "C: 5" int 1 season 0 0 0 0 0 1 0 0 0 0 | int 1 / subject 1 cl;
	estimate "C: 6" int 1 season 0 0 0 0 1 0 0 0 0 0 | int 1 / subject 1 cl;
	estimate "C: 7" int 1 season 0 0 0 1 0 0 0 0 0 0 | int 1 / subject 1 cl;
	estimate "C: 8" int 1 season 0 0 1 0 0 0 0 0 0 0 | int 1 / subject 1 cl;
	estimate "C: 9" int 1 season 0 1 0 0 0 0 0 0 0 0 | int 1 / subject 1 cl;
	estimate "C: 10" int 1 season 1 0 0 0 0 0 0 0 0 0 | int 1 / subject 1 cl;
	
	estimate "SF: 1" int 1 season 0 0 0 0 0 0 0 0 0 1 | int 1 / subject 0 0 0 0 0 1 cl;
	estimate "SF: 2" int 1 season 0 0 0 0 0 0 0 0 1 0 | int 1 / subject 0 0 0 0 0 1 cl;
	estimate "SF: 3" int 1 season 0 0 0 0 0 0 0 1 0 0 | int 1 / subject 0 0 0 0 0 1 cl;
	estimate "SF: 4" int 1 season 0 0 0 0 0 0 1 0 0 0 | int 1 / subject 0 0 0 0 0 1 cl;
	estimate "SF: 5" int 1 season 0 0 0 0 0 1 0 0 0 0 | int 1 / subject 0 0 0 0 0 1 cl;
	estimate "SF: 6" int 1 season 0 0 0 0 1 0 0 0 0 0 | int 1 / subject 0 0 0 0 0 1 cl;
	estimate "SF: 7" int 1 season 0 0 0 1 0 0 0 0 0 0 | int 1 / subject 0 0 0 0 0 1 cl;
	estimate "SF: 8" int 1 season 0 0 1 0 0 0 0 0 0 0 | int 1 / subject 0 0 0 0 0 1 cl;
	estimate "SF: 9" int 1 season 0 1 0 0 0 0 0 0 0 0 | int 1 / subject 0 0 0 0 0 1 cl;
	estimate "SF: 10" int 1 season 1 0 0 0 0 0 0 0 0 0 | int 1 / subject 0 0 0 0 0 1 cl;
	
	estimate "SG: 1" int 1 season 0 0 0 0 0 0 0 0 0 1 | int 1 / subject 0 0 0 0 0 0 0 1 cl;
	estimate "SG: 2" int 1 season 0 0 0 0 0 0 0 0 1 0 | int 1 / subject 0 0 0 0 0 0 0 1 cl;
	estimate "SG: 3" int 1 season 0 0 0 0 0 0 0 1 0 0 | int 1 / subject 0 0 0 0 0 0 0 1 cl;
	estimate "SG: 4" int 1 season 0 0 0 0 0 0 1 0 0 0 | int 1 / subject 0 0 0 0 0 0 0 1 cl;
	estimate "SG: 5" int 1 season 0 0 0 0 0 1 0 0 0 0 | int 1 / subject 0 0 0 0 0 0 0 1 cl;
	estimate "SG: 6" int 1 season 0 0 0 0 1 0 0 0 0 0 | int 1 / subject 0 0 0 0 0 0 0 1 cl;
	estimate "SG: 7" int 1 season 0 0 0 1 0 0 0 0 0 0 | int 1 / subject 0 0 0 0 0 0 0 1 cl;
	estimate "SG: 8" int 1 season 0 0 1 0 0 0 0 0 0 0 | int 1 / subject 0 0 0 0 0 0 0 1 cl;
	estimate "SG: 9" int 1 season 0 1 0 0 0 0 0 0 0 0 | int 1 / subject 0 0 0 0 0 0 0 1 cl;
	estimate "SG: 10" int 1 season 1 0 0 0 0 0 0 0 0 0 | int 1 / subject 0 0 0 0 0 0 0 1 cl;
run;

* Finally, let's take our first look at interpreting the results we have obtained.
* Below is the code to obtain pairwise differences for consecutive seasons from our
* mixed model. We also take the difference between the first and last season to
* understand what the long-term trend in jump heights has been for NBA Combine players
* over the period studied;
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season position;
	model jump_cm = season;
	random intercept/subject=position;
	lsmestimate season
		"1" [1,10],
		"2" [1, 9],
		"3" [1, 8],
		"4" [1, 7],
		"5" [1, 6],
		"6" [1, 5],
		"7" [1, 4],
		"8" [1, 3],
		"9" [1, 2],
		"10"[1, 1]
		/cl;
	lsmestimate season
		"2-1"  [1, 9] [-1,10],
		"3-2"  [1, 8] [-1, 9],
		"4-3"  [1, 7] [-1, 8],
		"5-4"  [1, 6] [-1, 7],
		"6-5"  [1, 5] [-1, 6],
		"7-6"  [1, 4] [-1, 5],
		"8-7"  [1, 3] [-1, 4],
		"9-8"  [1, 2] [-1, 3],
		"10-9" [1, 1] [-1, 2],
		"1-10" [1, 10][-1, 1]		
		/cl;
run;