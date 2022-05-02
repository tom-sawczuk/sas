* Let's take things a step further and imagine that, rather than only the combine jump
* height, for which we have all the data, we want to know how the average jump
* height of college basketball players has changed in the last two decades. We don't
* have the data for all the college basketball players over the last two decades, but 
* our combine data does provide a sample of them (albeit a poorly representative
* sample). Our question is now:

* 		In the last two decades, has college basketball jump height increased 
*		significantly season by season?	

* To answer this question, we need to use a mixed model. Mixed models work on the basis
* that we have a sample of observations from the population. Clustering around these
* observations allows us to get more accurate and generalisable results. In this 
* analysis, we cluster around position. In effect, we are saying: Here is a subset of 
* all the players who played college basketball in the last two decades. First, estimate 
* a general jump height value for ALL players who played college basketball (not just 
* our sample of combine players) in the same position. Next, evaluate the difference in 
* jump height between seasons, knowing the variation in jump height that can occur 
* within and between positions in this group of athletes. 

* A mixed model includes both fixed effects (which work with means) and random effects 
* (which work with standard deviations). This differentiation is important because it 
* allows the random effects to consider clustering around a given variable. It will also
* be important for our understanding of the model output. The ANOVAs we have used so 
* far are examples of fixed-effects only models, which do not consider clustering.

* Below is the mixed model for our new question;
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season position;
	model jump_cm = season/solution;
	random intercept/subject=position solution;
	lsmeans season/cl;
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
