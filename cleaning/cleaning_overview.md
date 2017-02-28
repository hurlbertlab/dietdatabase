#Cleaning the Avian Diet Database

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

If you find that the extreme values are correct and not actually outliers, then update the `outlierCheck` function
in the `database_summary_functions.r` file in the `scripts` folder. In that function, for each numeric field,
a range of "acceptable" values is provided to check against:
```
outlierCheck = function(diet) {
  out = list(
    long = outlier(diet$Longitude_dd, -180, 180),
    
    lat = outlier(diet$Latitude_dd, -180, 180),
    
    item_sampsize = outlier(diet$Item_Sample_Size, 0, 10000)
    
    )
  
  return(out)
}
```
In the abbreviated version above, you can see that longitudes and latitudes should range between -180 and 180, 
and the Item_Sample_Size should range between 0 and 10000. If you find that there are "true" values greater
than 10000, simply replace 10000 with the largest verified value you've found. Re-source the function
```
source('scripts/database_summary_functions.R')
```
and then rerun `outlierCheck(diet)` and it should now ignore the values that previously were flagged.

## Error checking text fields
Text fields don't have 'outliers' per se, but they may have typos, or we may have entered data
(e.g. on habitat type) in unstandardized ways (e.g. "coniferous forest", "Coniferous forest", and 
"pine forest"). One way to check this is simply to see all of the unique values within a given
text field and how many times they occur. If we wanted to do this for the Habitat_type field, we could 
simply type:
```
> count(diet, Habitat_type) %>% arrange(desc(n)) %>% data.frame()
                                          Habitat_type    n
1                                                 <NA> 4429
2                                          Agriculture 1751
3                                             multiple 1029
4                                                       836
5              Woodland; deciduous forest; agriculture  662
6                                            grassland  619
7                                             Multiple  614
8                                     Deciduous forest  599
9                                            Scrubland  551
10 Conifer forest, mountain shrubland, and shrubsteppe  494
11                                             Wetland  465
12                                           scrubland  436
13                                   Coniferous forest  355
14                                Grassland, shrubland  291
15                                   coniferous forest  290
...
```
For this field, refer to the list of acceptable names (forest, deciduous forest, coniferous forest, woodland,
shrubland, grassland, desert, wetland, agriculture, urban). They should all be lowercase (so "Scrubland" should be
replaced by "shrubland"), and they should be separated by semi-colons (so "Conifer forest, mountain shrubland, and shrubsteppe" should be changed to "coniferous forest; shrubland").

In general, be aware of non-standardized capitalization or punctuation, in addition to the words themselves.

Text fields that need this type of checking include: Location_Region, Location_Specific, Habitat_type, Observation_Season,
Prey_Name_Status, Prey_Stage, Prey_Part, Diet_Type, Sites, Study_Type

## Replacing text strings
To replace a text string with another in R (like Find and Replace in Excel) we use the function `gsub`. We need to specify
the (bad) original string, the (good) replacement string, and the field in which to look like this:
```
diet$Habitat_type = gsub('Scrubland', 'shrubland', diet$Habitat_type)
```

For every correction or typo substitution you do like this, record it in the file `db_cleaning_history.r` along with the date of the change.

## Cleaning taxonomic names
This is a big task, so we've got a separate page on it [here](https://github.com/hurlbertlab/dietdatabase/blob/master/cleaning/name_cleaning_instructions.md). 

## Checking the Fraction_Diet values for errors
We will do spot checks of all entered studies, double-checking what's in the original source paper to what was entered.
But first, a simple check for potential typos is to make sure that all values within a given diet analysis actually add
up to 100%. We're still working on tools for this, but one important check uses the `speciesSummary` function, where you specify 
the species common name, the diet database object, and the taxonomic level at which you want data summarized. E.g., 

First, get a summary of the entries for a specific bird
```
> speciesSummary('Black-throated Blue Warbler', diet, by = 'Order')
$numStudies
[1] 3

$Studies
[1] "King, F. H. 1883. Economic relations of Wisconsin birds. Geology of Wisconsin 441-610."                                                                               
[2] "Robinson, S. K. and R. T. Holmes. 1982. Foraging behavior of forest birds: the relationship among search tactics, diet, and habitat structure. Ecology 63:1918-1931." 
[3] "Robinson, S. K. and R. T. Holmes. 1982. Foraging behavior of forest birds: the relationships among search tactics, diet, and habitat structure. Ecology 63:1918-1931."

$numRecords
[1] 17

$recordsPerYear
  Observation_Year_Begin  n
1                   1875  3
2                   1974 10
3                   1976  4

$recordsPerRegion
  Location_Region n
1   New Hampshire 9
2   United States 5
3       Wisconsin 3

$recordsPerType
   Diet_Type  n
1      Items 14
2 Occurrence  3

$analysesPerDietType
   Diet_Type n
1      Items 3
2 Occurrence 1

$preySummary
    Diet_Type              Taxon  Frac_Diet
1       Items Lepidoptera larvae 0.26900000
2       Items        Coleoptera  0.16666667
3       Items   coleoptera adult 0.16666667
4       Items Lepidoptera Larvae 0.09200000
5       Items Lepidoptera Larval 0.09200000
6       Items  Lepidoptera adult 0.04600000
7       Items           Diptera  0.04600000
8       Items      Diptera adult 0.04000000
9       Items         Homoptera  0.01733333
10      Items    Homoptera adult 0.01733333
11      Items       Hymenoptera  0.01733333
12      Items  Hymenoptera adult 0.01733333
13      Items           Araneae  0.01233333
14 Occurrence        Coleoptera  0.83333333
15 Occurrence       Hymenoptera  0.16666667
16 Occurrence       Lepidoptera  0.16666667
```
Storing species summary in a variable makes working with it easier. For each new bird, simply make a new abbreviation as the variable name and substitute in the bird name inside the ```speciesSummary``` function. The following shoes the same as above:
```
> bluwarb = speciesSummary("Black-throated Blue Warbler", diet, by = "Order")
> bluwarb
$numStudies
[1] 2

$Studies
[1] "King, F. H. 1883. Economic relations of Wisconsin birds. Geology of Wisconsin 441-610."                                                                               
[2] "Robinson, S. K. and R. T. Holmes. 1982. Foraging behavior of forest birds: the relationships among search tactics, diet, and habitat structure. Ecology 63:1918-1931."

$numRecords
[1] 17

$recordsPerYear
  Observation_Year_Begin  n
1                   1875  3
2                   1974 10
3                   1976  4

$recordsPerRegion
  Location_Region  n
1   New Hampshire 14
2       Wisconsin  3

$recordsPerType
   Diet_Type  n
1      Items 14
2 Occurrence  3

$analysesPerDietType
   Diet_Type n
1      Items 3
2 Occurrence 1

$preySummary
    Diet_Type              Taxon  Frac_Diet
1       Items Lepidoptera larvae 0.45300000
2       Items        Coleoptera  0.16666667
3       Items   coleoptera adult 0.16666667
4       Items  Lepidoptera adult 0.04600000
5       Items           Diptera  0.04600000
6       Items      Diptera adult 0.04000000
7       Items         Homoptera  0.01733333
8       Items    Homoptera adult 0.01733333
9       Items       Hymenoptera  0.01733333
10      Items  Hymenoptera adult 0.01733333
11      Items           Araneae  0.01233333
12 Occurrence        Coleoptera  0.83333333
13 Occurrence       Hymenoptera  0.16666667
14 Occurrence       Lepidoptera  0.16666667
```
Now, look at which Diet Types are listed:
Items, Wt_or_Vol, and Unspecified are what we'll be checking with the following code (not Occurence): 
```
> sum(subset(bluwarb$preySummary, Diet_Type=="Items")$Frac_Diet)
[1] 1
```
To find the sum of the different Diet Types, simply change "Items" to whichever Diet Type you want, such as "Unspecified" or "Wt_or_Vol".
The sum of each Diet Diet should be 1.0 or reasonably close. If the value is not about 1.0, it means there is probably a typo, error, or other problem somewhere in the entries. Open up the AvianDietDatabase and check the values for the Diet Type(s) where the sum was not 1.0 to find the problem. You most likely will have to consult the sources or papers themselves to reference the values. Make the necessary corrections and re-check the new sum.
