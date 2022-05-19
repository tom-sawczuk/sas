* So far, we have specifically stated that we've been looking at the NBA Combine jump
* heights from the last 20 years. Let's take things a step further now and imagine that
* we want to generalise to all years. Our question is now:

* 		After accounting for positional differences, has college basketball jump height  
*		changed significantly season by season?	

* To answer this question, we need to use a mixed model. Mixed models work on the basis
* that we have a sample of observations from the population. Clustering around these
* observations allows us to get more accurate and generalisable results. In this 
* analysis, we cluster around position. In effect, we are saying: "Here is the data for
* all the players who reached the Combine in the last two decades. We expect that future
* players in these positions, who reach the Combine, will have similar physical 
* qualities so please account for this in the model.

* Below is the mixed model for our new question. The first line remains the same as
* previously;
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
