###Cleaning the Avian Diet Database

There are various sources of error that may creep into the database, and we will need to employ several
different strategies to catch and fix them.

Much of the cleaning will require the use of R or RStudio. Open a session and set your working 
directory to wherever the dietdatabase folder is on the machine you are working on. Then load 
the Diet Database and all of the cleaning and summary functions using `source` like this:

```
setwd('C:/Git/dietdatabase')
source('scripts/database_summary_functions.R')
```

There should now be an object in your working environment called `diet` which is the database.

##Checking for outliers
Check for outliers of numeric values by typing `outlierCheck(diet)` into R. You should get something that looks like this:
```
> outlierCheck(diet)
$long
[1] "OK"

$lat
[1] "OK"

$alt_min
[1] "OK"

$alt_mean
[1] "OK"

$alt_max
[1] "OK"

$mon_beg
[1] "OK"

$mon_end
[1] "OK"

$year_beg
[1] "OK"

$year_end
[1] "OK"

$diet_wt
[1] "OK"

$diet_items
[1] "OK"

$diet_occ
[1] "OK"

$diet_unk
[1] "OK"

$item_sampsize
 [1]  5285  5286  5287  5288  5289  5290  5291  5292  5293  5294  5295  5296  5297  5298  5299
[16]  5300  5301  5302  5303  5304  5305  5306  5307  5308  5309  5310  5311  5312  5313  5314
[31]  5315  5316  5317  5318  5319  5320  5321  5322  5323  5324  5325  5326  5327  5328  5329
[46]  5330  5331  5332  5333  5334  5335  5336  5337  5338  5339  5340  5341  5342  5343  5344
[61]  5345  5346  5347  5348  5349  5350  5351  5352  5353  5354  5355  5356  5357  5358  5359
[76]  5360  5361  5362  5363 17897 17898 17899 17900 17901 20954 20955 20956 20957 20958

$bird_sampsize
  [1] 10618 10619 10620 10621 10622 10623 10624 10625 10626 10627 10628 10681 10682 10683 10684
 [16] 10685 10686 10687 10688 10689 10690 10691 10692 10693 10711 10712 10713 10714 10715 10716
```
If there are any records where the values seem unusual, then the row numbers with the potentially
problematic values are listed (as for 'item_samplesize' and 'bird_sampsize'). Look up these rows,
find the original source data and double check the values. Correct if necessary.

If the output for a given field is "OK", then there were no outliers.
