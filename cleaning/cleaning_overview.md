# Cleaning the Avian Diet Database

There are various sources of error that may creep into the database, and we will need to employ several
different strategies to catch and fix them.

In R or RStudio, open the RProject file in the main repository, source the cleaning functions, and read in the file to be cleaned (e.g. 
AvianDietDatabase_Beaver_and_Baldwin_1975.txt). 

```
### You'll want to replace the 'qa_qc_test_db.txt' file with the data file you want to clean.
source('cleaning/database_error_checking.R')
dietdb = read.table('cleaning/qa_qc_test_db.txt', header = T, sep = '\t', quote = '\"', stringsAsFactors = F)
```

In the example above we read in a test file, 'qa_qc_test_db.txt', that we know has several specific errors:

<table>
  <tr>
    <td><b>Row #</b></td>
    <td><b>Problem</b></td>
  </tr>
  <tr>
    <td>1</td>
    <td>Location_Region is 'Rode Island', a typo which does not match currently accepted names</td>
  </tr>
  <tr>
    <td>2</td>
    <td>Habitat_type is 'scrubland', which does not match currently accepted names (should be 'shrubland')</td>
  </tr>
  <tr>
    <td>3</td>
    <td>Longitude is not within (-180, 180)</td>
  </tr>
  <tr>
    <td>4</td>
    <td>Prey_Stage is 'juvie', which does not match currently accepted names (should be 'juvenile')</td>
  </tr>
  <tr>
    <td>5</td>
    <td>Location_Specific is 'Multipe', a typo of 'Multiple'</td>
  </tr>
  <tr>
    <td>7</td>
    <td>Prey_Part is 'fruity', which does not match currently accepted names (should be 'fruit')</td>
  </tr>
  <tr>
    <td>8</td>
    <td>Scientific_Name, 'Melospiza georgina', does not match any names in the most recent eBird Clements checklist</td>
  </tr>
  <tr>
    <td>9</td>
    <td>Observation_Month_Begin is the text string 'August' rather than an integer indicating month number.</td>
  </tr>
  <tr>
    <td>10</td>
    <td>Fraction_Diet is greater than 1</td>
  </tr>
  <tr>
    <td>10</td>
    <td>Taxonomy is different from the most recent bird taxonomy, eBird Clements Checklist v2016</td>
  </tr>
</table>


## Overall database summary
To get a sense of the total number of records, species covered, etc of the database sample you are cleaning, use the 
function `dbSummary()` like this:
```
> dbSummary(dietdb)
$numRecords
[1] 12

$numSpecies
[1] 3

$numStudies
[1] 1

$recordsPerSpecies
             Common_Name n
1         Eastern Towhee 4
2          Swamp Sparrow 4
3 White-throated Sparrow 4

$speciesPerFamily
               ORDER            Family SpeciesWithData WithoutData
1    Accipitriformes      Accipitridae               0          24
2    Accipitriformes       Cathartidae               0           3
3       Anseriformes          Anatidae               0          41
4   Caprimulgiformes          Apodidae               0           4
5   Caprimulgiformes     Caprimulgidae               0           6
6   Caprimulgiformes       Trochilidae               0          14
7    Charadriiformes           Alcidae               0          17
8    Charadriiformes      Charadriidae               0           6
...
```


## QA/QC: Checking for outliers, typos, and invalid values.
We use the 'qa_qc()' function to conduct a basic check to catch any obvious errors. The purpose of this 
QA/QC check is to point out records that should be double-checked or possibly corrected. Let's work through
the printed results.
```
> qa_qc(dietdb, fracsum_accuracy = 0.02)
$Problem_bird_names
    Common_Name    Scientific_Name      Family
1 Swamp Sparrow Melospiza georgina Emberizidae
```
The `$Problem_bird_names` section highlights any species that either 1) have a typo or invalid name for either the common name, scientific
name, or family name, or 2) have an error in the family assignment or scientific name assignment to the given common name. In this
case, a quick search of the eBird checklist reveals the scientific name should be 'Melospiza georgiana'. If a name is listed here as problematic but you cannot see any typos, try checking for leading or trailing spaces in the names. E.g., ' Melospiza georgiana'. 

```
$Taxonomy
                        Taxonomy n
1 eBird Clements Checklist v2015 1
```
Non-name based text fields are checked against accepted values. If no problems are detected then the field is "OK". Otherwise,
a table of unaccepted names (or possible typos) and their frequency are provided. In this case this is an out of date taxonomy
and should be verified or corrected if necessary.

```
$Longitude_dd
[1] 3

$Latitude_dd
[1] "OK"

$Altitude_min_m
[1] "All values NA"

$Altitude_mean_m
[1] "All values NA"

$Altitude_max_m
[1] "All values NA"

```
Numeric fields in the database are checked for any values that are suspicious or invalid. If all is well, output is simply "OK" 
for that field. Otherwise, the row number(s) of the flagged values are provided. In this case, row 3 has a problematic longitude value, 
while the Latitude field is ok. The Altitude fields are all NA, but this is ok and nothing needs to be done for those.

```
$Location_Region
  Location_Region n
1     Rode Island 1
```
In this case, the typo 'Rode Island' was noted as occurring once, and this should be corrected in the database. If a phrase comes up
here that you think should be a valid region name, then post an issue on Github, and we will revise the list of accepted names if appropriate.

```
$Location_Specific
  Location_Specific  n
1          Multiple 11
2           Multipe  1
```
There are too many possible Location_Specific names and those names are expected to be highly variable so we do not have a list of 
accepted possibilities to check against. As such, _this is the one field for which ALL values are listed along with their frequency 
in the database._ Using this table, we should be able to standardize these names within each database sample and catch simple typos 
like 'Multipe' instead of 'Multiple'.

```
$Observation_Season
[1] "OK"

$Habitat_type
  Habitat_type n
1    scrubland 1
```
'Scrubland' did not match our list of accepted habitat types. In this case, it should be replaced by 'shrubland'.

```
$Observation_Month_Begin
[1] "Field has non-numeric or non-integer values"

$Observation_Year_Begin
[1] "OK"

$Observation_Month_End
[1] "OK"

$Observation_Year_End
[1] "OK"

$Prey_Stage
  Prey_Stage n
1      juvie 1

$Prey_Part
  Prey_Part n
1    fruity 1
```
Observation month and year fields are ok, except for Observation_Month_Begin which should be a value from 1 to 12, but apparently has some non-numeric values. Upon inspection, we can see that someone typed 'August' instead of using the number 8. 'juvie' is an unacceptable Prey_Stage name, and 'fruity' is an unacceptable
Prey_Part name. Both values should be fixed or replaced as appropriate (e.g. 'juvenile', 'fruit').

```
$Fraction_Diet
[1]  9 10
```
Rows 9 and 10 have Fraction_Diet values that are outside of the range 0-1. In this case, someone probably forgot to convert
%s to fractions.

```
$Diet_Type
[1] "OK"

$Item_Sample_Size
[1] "OK"

$Bird_Sample_Size
[1] "OK"

$Sites
[1] "OK"

$Study_Type
[1] "OK"
```
No errors in these fields.

```
$Fraction_sum_check
  Source            Common_Name Observation_Year_Begin Observation_Month_Begin Observation_Season Bird_Sample_Size Habitat_type
1   test White-throated Sparrow                   1993                       8               fall               38    shrubland
2   test White-throated Sparrow                   1993                       8             summer               38    shrubland
  Location_Region Item_Sample_Size Diet_Type Sum_Diet
1    Rhode Island               NA Wt_or_Vol  176.300
2    Rhode Island               NA Wt_or_Vol    1.021
```
The final check is whether, for each diet analysis (i.e. combination of study, bird species, date, location, and habitat), the 
diet values of the different prey in the analysis sum to close to 1. Summing to 1 is only expected for Wt_or_Vol, Items, or 
Unspecified diet types, but not for Occurrence data. The `fracsum_accuracy` argument when calling `qa_qc()` specifies how
close to 1 that sum should be. In this example, it was set to 0.02, which means any analyses where the sum of diet fractions is
<0.98 or >1.02 will be listed here.

In the first study , the Sum_Diet value is 176.3, way above 1. Something is clearly wrong with the Fraction_Diet data entered 
for this study. As we already noted above, someone probably entered %s instead of fractions, but even after that is corrected,
this will still return 1.76. In this case, the possibilities are a typo in the values entered (so look up the original paper
and check that they were entered correctly), or that the Diet_Type should actually be Occurrence instead of Wt_or_Vol, in which
case a sum greater than 1 is ok.

In the second study listed, you can see that the Sum_Diet is 1.021. This may reflect a small typo in the Fraction_Diet values
entered (so compare values to the original paper), but it is so small it could also just reflect the accumulation of rounding
errors. *I recommend setting `fracsum_accuracy = 0.03` as the default to minimize these types of false positives.

## Cleaning taxonomic names of prey
This is a big task, so we've got a separate page on it [here](https://github.com/hurlbertlab/dietdatabase/blob/master/cleaning/name_cleaning_instructions.md). 

## Incorporating cleaned database records into main database
One all typos, outliers, unaccepted values, and invalid taxonomic names have been corrected for the study you have entered, 
you may now incorporate these records into the main Avian Diet Database. The easiest way to do this is to
1) make sure you have the latest version of all files by typing `git pull origin master` in Git,
2) open your cleaned file (e.g. 'AvianDietDatabase_Beaver_and_Baldwin_1975.txt'),
3) copy everything EXCEPT the header row,
4) open the main database file ('AvianDietDatabase.txt'),
5) paste the new cleaned records at the bottom and save the file,
6) commit this change in commit like `git commit -am "adding cleaned records from Beaver & Baldwin 1975"`
7) push these changes to the master repo: `git push origin master`
8) now you can delete all of the temporary files associated with that paper that has been entered (e.g. the original file, the 'clean' and 'badnames' files)

