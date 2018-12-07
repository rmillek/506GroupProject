/* 506 group project SAS code
 * Group 11
 * Data: seeds
 * Dec. 7th, 2018
 */

/* file name */
filename seeds '~/stat506/project/seeds.csv';

/* format for grouping variable */
proc format;
	value group_f 1 = 'K' 
				  2 = 'R'
				  3	= 'C';
run;

/* import data */
data seeds_original;
	infile seeds delimiter = '	' MISSOVER firstobs=2;
	input area
		  peri
		  comp
		  l
		  w
		  asym
		  lgroove
		  group;
	format group group_f.;
run;

/* summary of the dataset*/
proc means data=seeds_original n mean std min max;
  var area peri comp l w asym lgroove;
run;

/* summary of the dataset by group*/
proc means data=seeds_original n mean std;
  class group;
  var area peri comp l w asym lgroove;
run;

/* correlation table */
proc corr data=seeds_original;
  var area peri comp l w asym lgroove;
run;


/* train and test split by group */
proc surveyselect data=seeds_original rate=.3 outall out=seeds_select;
	strata group;
run;

/* generate the training dataset*/
data seeds_train;
	set seeds_select;
	where Selected = 0;
	drop Selected SelectionProb SamplingWeight;
run;

/* generate the testing dataset*/
data seeds_test;
	set seeds_select;
	where Selected = 1;
	drop Selected SelectionProb SamplingWeight;
run;


/* Discriminant analysis */
proc discrim data=seeds_train testdata=seeds_test testout=fake_out out=discrim_out can;
  class group;
  var area peri comp l w asym lgroove;
run;

/* making plot using PROC SGRENDER Statement*/
data plotclass;
  merge fake_out discrim_out;
run;

proc template;
  define statgraph classify;
    begingraph;
      layout overlay;
        contourplotparm x=Can1 y=Can2 z=_into_ / contourtype=fill  
						 nhint = 30 gridded = false;
        scatterplot x=Can1 y=Can2 / group=group includemissinggroup=false
	                 	    markercharactergroup = group;
      endlayout;
    endgraph;
  end;
run;

proc sgrender data = plotclass template = classify;
	title "Discriminant function score";
run;