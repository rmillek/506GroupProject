/* file name */
filename seeds '~/stat506/project/seeds_dataset.txt';

/* import data */
data seeds_original;
	infile seeds delimiter = '	' MISSOVER;
	input area
		  peri
		  comp
		  l
		  w
		  asym
		  igroove
		  group;
run;

/* train and test split by group */
proc surveyselect data=seeds_original rate=.3 outall out=seeds_select;
	strata group;
run;

/* training set*/
data seeds_train;
	set seeds_select;
	where Selected = 0;
	drop Selected SelectionProb SamplingWeight;
run;

/* test set*/
data seeds_test;
	set seeds_select;
	where Selected = 1;
	drop Selected SelectionProb SamplingWeight;
run;

/* summary of training dataset*/
proc means data=seeds_train n mean std min max;
  var area peri comp l w asym igroove;
run;

/* summary of training dataset by group*/
proc means data=seeds_train n mean std;
  class group;
  var area peri comp l w asym igroove;
run;

/* correlation */
proc corr data=seeds_train;
  var area peri comp l w asym igroove;
run;


/* analysis */
proc discrim data=seeds_train testdata=seeds_test testout=fake_out out=discrim_out can;
  class group;
  var area peri comp l w asym igroove;
run;


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
run;