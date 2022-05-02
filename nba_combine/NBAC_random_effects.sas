* Given the similarity in the season by season differences, it's fair to ask what is so
* special about random effects. Aside from accounting for correlated data to work with
* datasets where the assumption of independence cannot be met, there are two key reasons
* that random effects work well:
	* Degrees of freedom
	* Shrinkage
	
* Let's look at both of these now by comparing two-way ANOVA and mixed model outputs.
* Note, within the two-way ANOVA, I am including the intercept to simplify the
* calculations. Otherwise, both models are the same as in the previous tutorials. 
* I've removed the season differences and solution statements to tidy up the output
* for our needs;

* Two-way ANOVA;
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season position;
	model jump_cm = season position/ solution;
	
	* Position estimates;
	estimate "Intercept" int 1/cl;
	estimate "C" int 1 position 1 0 0 0 0 0 0 0 0/cl;
	estimate "C_PF" int 1 position 0 1 0 0 0 0 0 0 0/cl;
	estimate "PF" int 1 position 0 0 1 0 0 0 0 0 0/cl;
	estimate "PF_SF" int 1 position 0 0 0 1 0 0 0 0 0/cl;
	estimate "PG" int 1 position 0 0 0 0 1 0 0 0 0/cl;
	estimate "SF" int 1 position 0 0 0 0 0 1 0 0 0/cl;
	estimate "SF_SG" int 1 position 0 0 0 0 0 0 1 0 0/cl;
	estimate "SG" int 1 position 0 0 0 0 0 0 0 1 0/cl;
	estimate "SG_PG" int 1 position 0 0 0 0 0 0 0 0 1/cl;

run;

* Mixed Model;
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season position;
	model jump_cm = season;
	random intercept/subject=position solution;
	
	* Position estimates;
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

run;