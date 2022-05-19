* Now, let's refine the analysis. Previously we averaged all the players together to
* see the 'global' jump height averaged across NBA Combine Players per season. However,
* it's not unreasonable to suggest that the position of a player would impact upon this
* figure as some positions require more athletically gifted players than others. Let's
* account for position in the analysis now using a two-way ANOVA.

* The question is now;

* 		In the last two decades, has NBA combine jump height increased significantly
* 		season by season when positional differences have been accounted for?

*Let's model it;
proc mixed data=nbac.data plots(only)=studentpanel(conditional) alpha=0.05 covtest;
	class season position;
	model jump_cm = season position/solution noint;
	lsmeans season position/cl;
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
	estimate "C - PG" position 1 0 0 0 -1 0 0 0 0/cl;
	lsmestimate position
	"C - PG" [1,1] [-1,5]
	/ cl;
run;

