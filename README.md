Avian Diet Database 
===================

This repository is the temporary home for the Avian Diet Database being built
by the Hurlbert Lab at the University of North Carolina.    

The goal is to organize all available information (from published studies, gray literature, etc) on the diets 
of North American birds in its rawest form possible with the idea that this may be a resource for a broad 
range of ecological questions.

These data are automatically incorporated into the Global Biotic Interactions (GloBI) database.
See [http://www.globalbioticinteractions.org](http://www.globalbioticinteractions.org/index.html) for more details.

## Finding Diet Data
We are focusing our search for diet data in the published literature. References related to avian diets have been scraped
from individual species accounts on the [Birds of North America website](http://bna.birds.cornell.edu/bna/), and are
provided in the file 'NA_avian_diet_refs.txt'. For each species, look up the listed references to see if they contain
raw diet data summaries. If you were able to look up the reference, put a 'y' in the 'checked' column. If the reference was 
unavailable (couldn't access it online, not in the library) put a 'n'. For those that you checked, indicate (y/n) whether it
contained diet data in the 'useable_data' column.

_*NOTE*_: Place pdfs of all papers you find with usable data in the following folder on the HurlbertLab drive:
*HurlbertLab > Databases > DietDatabase > Papers with data*. The file should be saved with the last name of the author(s) and the year. 
For example, "Beaver and Baldwin 1975.pdf" or "Hurlbert et al 2007.pdf".

After you have examined all of the references listed in this table for a given species, you will perform a literature search
to see if any additional papers have been published on the diet of this species since the Birds of North America species
account was published or last revised (the year in the "revised" column). 

### Web of Science search
Go to [Web of Science](http://apps.webofknowledge.com) and in the Topic search box enter:  

```
"[common name]" AND (diet OR foraging OR food)
```
replacing [common name] with the actual common name of the species you are searching.

Click on +Add Another Field, and select Year Published. Search all years since the last revised date for that species as listed in the 
'NA_avian_diet_refs' table.    

Look up the papers in the search results, and be sure to add any that contain useful data to the NA_avian_diet_refs.txt table.

## Data Entry Details
When you've found a study with quantitative diet data, open the file 'AvianDietDatabase_template.txt' in Excel and re-save it, replacing
the word 'template' with the study author and year, e.g. 'AvianDietDatabase_Beaver_and_Baldwin_1975.txt'. Then proceed to enter as
much of the information described below as you can ascertain from the study.

To maximize the utility of the data, we need to record many types of information describing the what, when, where, and how 
of its collection, and so our database has many fields. In the table below we explain what exactly is characterized in each
of these fields, and how data should be entered. Further instructions about how to enter data in the database are provided 
[here](https://github.com/hurlbertlab/dietdatabase/blob/master/diet_data_instructions.md).


<table>
  <tr>
    <td>Field</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>Common_Name</td>
    <td>The common name of the species whose diet is being characterized, following the most recent Clements / eBird 
	  checklist. Make sure that this is the currently accepted name by 
    checking http://help.ebird.org/customer/portal/kb_article_attachments/35388/original.xls?1407441617 and
    http://avibase.bsc-eoc.org/. Names from older papers are potentially out of date and will need to be fixed.</td>
  </tr>
  <tr>
    <td>Scientific_Name</td>
    <td>Genus and species of the species whose diet is being characterized. For North American birds 
    we will generally follow the most recent Clements / eBird checklist. Make sure that this is the currently accepted name by 
    checking http://help.ebird.org/customer/portal/kb_article_attachments/35388/original.xls?1407441617 and
    http://avibase.bsc-eoc.org/. Names from older papers are potentially out of date and will need to be fixed.</td>
  </tr>
  <tr>
    <td>Family</td>
    <td>Family of the species whose diet is being characterized.</td>
  </tr>
  <tr>
    <td>Taxonomy</td>
    <td>The taxonomic authority for the scientific name. For example, eBird Clements checklist v2016.</td>
  </tr>
  <tr>
    <td>Longitude_dd</td>
    <td>Longitude of the study, if provided, in decimal degrees. NOTE: Most studies that provide lat-long info will do
    so by providing it in degree-minutes-seconds, e.g. 89W 30' 15", so you will have to convert such values to decimal
    degrees. Do this by adding up the degrees, the minutes/60, and the seconds/3600. E.g., 89 + 30/60 + 15/3600. Lastly, 
    all longitudes west of the prime meridian (e.g. in North America) are NEGATIVE, so be sure to put a minus sign in front!</td>
  </tr>
  <tr>
    <td>Latitude_dd</td>
    <td>Latitude of the study, if provided, in decimal degrees. Latitudes south of the equator are NEGATIVE.</td>
  </tr>
  <tr>
    <td>Altitude_min_m</td>
    <td>Minimum altitude of the study in meters if a range was provided. If altitude is given in anything other than meters, don't
    forget to convert first!</td>
  </tr>
  <tr>
    <td>Altitude_mean_m</td>
    <td>Altitude of the study in meters if a single value was provided. If altitude is given in anything other than meters, don't
    forget to convert first!</td>
  </tr>
  <tr>
    <td>Altitude_max_m</td>
    <td>Maximum altitude of the study in meters if a range was provided. If altitude is given in anything other than meters, don't
    forget to convert first!</td>
  </tr>
  <tr>
    <td>Location_Region</td>
    <td>Location of the study based on national or subnational place name (e.g., Florida, or Jamaica). If the study spans multiple
	  regions they can be listed separated by semi-colons (e.g. "Florida; Alabama; Georgia").</td>
  </tr>
  <tr>
    <td>Location_Specific</td>
    <td>Location of the study using the most specific placename provided in the study (e.g. Hubbard Brook Experimental Forest, 
    or Huachuca Mountains, or Dare County).</td>
  </tr>
  <tr>
    <td>Habitat_type</td>
    <td>List one or more of the following habitat designations describing the habitat in which the study was conducted. If listing 
    multiple habitat types, use a ";" to separate them.
        +forest  
        +deciduous forest  
        +coniferous forest  
        +woodland  
        +scrubland  
        +grassland  
        +desert  
        +wetland  
        +agriculture  
        +urban
	+tundra  
	+mudflats  
        E.g. "deciduous forest; woodland"
        </td>
  </tr>
  <tr>
    <td>Observation_Month_Begin</td>
    <td>The month in which diet data were first collected, using numbers <b>1-12</b>.</td>
  </tr>
  <tr>
    <td>Observation_Year_Begin</td>
    <td>The year in which diet data were first collected in the study.</td>
  </tr>
  <tr>
    <td>Observation_Month_End</td>
    <td>The month in which diet data were last collected, using numbers <b>1-12</b>.</td>
  </tr>
  <tr>
    <td>Observation_Year_End</td>
    <td>The year in which diet data were last collected in the study.</td>
  </tr>
  <tr>
    <td>Observation_Season</td>
    <td>The season(s) in which diet data were last collected. Possible values include spring, summer, fall, winter, or multiple. Two or more values may be listed separated by a semi-colon, e.g. "spring; summer".</td>
  </tr>
  <tr>
    <td>Prey_Kingdom</td>
    <td>Kingdom to which the prey item belongs (e.g. Plantae, Animalia).</td>
  </tr>
  <tr>
    <td>Prey_Phylum</td>
    <td>Phylum to which the prey item belongs (e.g. Arthropoda).</td>
  </tr>
  <tr>
    <td>Prey_Class</td>
    <td>Class to which the prey item belongs (e.g. Insecta).</td>
  </tr>
  <tr>
    <td>Prey_Order</td>
    <td>Order to which the prey item belongs (e.g. Lepidoptera).</td>
  </tr>
  <tr>
    <td>Prey_Suborder</td>
    <td>Suborder to which the prey item belongs. This field will most frequently be used when older studies report prey orders 
    "Homoptera", "Hemiptera", and "Heteroptera", which now all fall under the Order Hemiptera. Thus, a report of "Homoptera" should
    be classified as Order Hemiptera, Suborder Homoptera. An older (pre-2000s) report of "Hemiptera" should be classified as Order
    Hemiptera, Suborder Heteroptera.</td>
  </tr>
  <tr>
    <td>Prey_Family</td>
    <td>Family to which the prey item belongs (e.g. Formicidae).</td>
  </tr>
  <tr>
    <td>Prey_Genus</td>
    <td>Genus to which the prey item belongs. If the prey was identified to species, this field can be left blank and reported
    under Prey_Scientific_Name.</td>
  </tr>
  <tr>
    <td>Prey_Scientific_Name</td>
    <td>The full scientific name, genus and species, to which the prey item belongs.</td>
  </tr>
  <tr>
    <td>Inclusive_Prey_Taxon</td>
    <td>Does the % diet data listed correspond to the importance of the listed prey taxon inclusively defined ("yes") or only for an unstated subset of the listed prey taxon ("no"). For example, let's say some diet items are identified to various families within Coleoptera, while some diet items are listed as "Unidentified Coleoptera" with the family unknown. In this case, we would have separate lines for the families "Tenebrionidae" and "Carabidae" for which <i>Inclusive_Prey_Taxon</i> would be "yes", but we might also have a line that identifies only down to Order Coleoptera for which <i>Inclusive_Prey_Taxon</i> would be "no" because the value in this row does not represent the fraction of the diet made up of all Coleoptera, only the Coleoptera that were not assigned to other groups. <b>Use this field rather than ever entering "Unidentified" or "Unknown" in any of the prey taxonomic rank fields.</b></td>
  </tr>
  <tr>
    <td>Prey_Name_ITIS_ID</td>
    <td>The Integrated Taxonomic Information Service (ITIS) taxon ID associated with the prey item. This field should be left blank and will be populated by an R script automatically.</td>
  </tr>
  <tr>
    <td>Prey_Name_Status</td>
    <td>Taxonomic status of the prey name, filled in automatically by R clean_all_names() function. "Verified" indicates the name matched a valid ITIS ID. "Unverified" means the name did not match a valid ITIS ID and needs to be investigated further.
    "Accepted" means the name did not match a valid ITIS ID, but investigation revealed that it reflects an accepted taxonomic entity not in ITIS. For "accepted" names, Prey_Name_ITIS_ID will be NA.</td>
  </tr>
  <tr>
    <td>Prey_Stage</td>
    <td>The lifestage of the identified prey item (e.g., 'adult', 'egg', 'juvenile', 'larva', 'nymph', 'pupa', 'teneral'). In general, you only need to worry about this column if the information is explicitly provided in the data source. <b>BUT NOTE: Always specify 'adult' or 'larva' for the Prey_Order "Lepidoptera" if you can figure it out.</b></td>
  </tr>
  <tr>
    <td>Prey_Part</td>
    <td>The part of the prey species represented in the diet if only a part was (likely) consumed. Especially for plant-based
    diet items, e.g., 'bark', 'bud', 'dung', 'feces', 'flower', 'fruit','gall', 'oogonium', 'pollen', 'root', 'sap', 'seed','spore', 'statoblasts', 'vegetation'.</td>
  </tr>
  <tr>
    <td>Prey_Common_Name</td>
    <td>Common name of the prey item if provided.</td>
  </tr>
  <tr>
    <td>Fraction_Diet</td>
    <td>Fraction of the bird's total diet made up by this prey item. Convert all %s to fractions between 0 and 1. In cases where information is reported separately for animal and plant diet items (e.g. Coleoptera make up 20% of the animal-based diet), be sure to combine plant and animal items together and recalculate % of the total diet.</td>
  </tr>
  <tr>
    <td>Diet_Type</td>
	<td>4 possible values. <b>Wt_or_Vol</b>: Fraction of the diet as measured by weight or volume. E.g., all beetles in the stomach 
    contents were weighed, and this value was divided by the mass of all stomach contents. <b>Items</b>: Fraction of the diet as
    measured by a count of the number of prey items. E.g., the number of beetles in the stomach contents were counted, and this 
    value was divided by the total number of unique prey items in the stomach contents. <b>Occurrence</b>: Fraction of the birds examined that contained at least one individual of this prey type. <b>Unspecified</b>: Fraction of the diet of the prey item based on a
    methodology unspecified by the authors.</td>
  </tr>
  <tr>
    <td>Item_Sample_Size</td>
    <td>Total number of prey items identified in the diet sample.</td>
  </tr>
  <tr>
    <td>Bird_Sample_Size</td>
    <td>Total number of individuals of the focal bird species used to characterize diet.</td>
  </tr>
  <tr>
    <td>Sites</td>
    <td>Number of study sites over which individuals were used to characterize the diet.</td>
  </tr>
  <tr>
    <td>Study_Type</td>
    <td>The way that diet data were collected. Options include: emetic, fecal contents, stomach contents, esophagus contents, 
	crop contents, pellet contents, behavioral observation, nest debris, prey remains.</td>
  </tr>
  <tr>
    <td>Notes</td>
    <td>Any useful information about the nature of the study or the diet information that does not fit in the previous fields.</td>
  </tr>
  <tr>
    <td>Entered_By</td>
    <td>Initials of the person entering the data.</td>
  </tr>
  <tr>
    <td>Source</td>
    <td>The complete citation of the study from which the diet information comes.</td>
  </tr>
</table>


## Other tasks

### Version control
We use a version control system called Git to manage so that we can easily go back to previous states, it's automatically
backed up, and many people can access it and add records simultaneously from different computers.

See [this page](git_dietdatabase_help.md) for instructions on how to use Git to manage the Avian Diet Database.

### Data cleaning
See [this page](cleaning/cleaning_overview.md) for instructions on cleaning newly entered data.

### Summarizing data
Use the `dbSummary()` function to get summary statistics for the diet database as a whole.
```
> dbSummary()
$numRecords
[1] 29548

$numSpecies
[1] 432

$numStudies
[1] 539

$recordsPerSpecies
                                      Common_Name    n
1                                  Abert's Towhee    5
2                              Acadian Flycatcher   32
3                                Acorn Woodpecker   70
4                             African Pygmy-Goose   10
5   Alder/Willow Flycatcher (Traill's Flycatcher)   88
6                             American Black Duck   43
7                                   American Crow  211
8                              American Goldfinch   17
...

$speciesPerFamily
               Order            Family SpeciesWithData WithoutData
1    Accipitriformes      Accipitridae              25           5
2    Accipitriformes       Cathartidae               3           1
3    Accipitriformes       Pandionidae               1           0
4       Anseriformes          Anatidae             100           4
5       Anseriformes         Anhimidae               1           0
6       Anseriformes     Anseranatidae               1           0
7   Caprimulgiformes          Apodidae               2           2
8   Caprimulgiformes     Caprimulgidae               4           4
9   Caprimulgiformes       Trochilidae               3          11
...
```

The `speciesSummary()` function will summarize all of the information available for a given bird species.
```
> speciesSummary("Black-throated Blue Warbler")
$numStudies
[1] 3

$Studies
[1] "King, F. H. 1883. Economic relations of Wisconsin birds. Geology of Wisconsin 441-610."                                             
[2] "Robinson, S. K. and R. T. Holmes. 1982. Foraging behavior of forest birds: the relationships among search tactics, diet, and habitat structure. Ecology 63:1918-1931."
[3] "Parrish, J. D. 1997. Patterns of Frugivory and Energetic Condition in Nearctic Birds During Autumn Migration. Condor 99: 681-697."          
$numRecords
[1] 16

$recordsPerSeason
  Observation_Season  n
1             spring  3
2             summer 13

$recordsPerYearRegion
  Location_Region 1875 1976 1979 1995
1   New Hampshire   NA    5    4   NA
2    Rhode Island   NA   NA   NA    4
3       Wisconsin    3   NA   NA   NA

$recordsPerPreyIDLevel
    level  n
1 Kingdom  0
2  Phylum  0
3   Class  4
4   Order 11
5  Family  0
6   Genus  0
7 Species  0

$recordsPerType
   Diet_Type n
1      Items 9
2 Occurrence 5
3  Wt_or_Vol 2

$analysesPerDietType
   Diet_Type n
1      Items 2
2 Occurrence 2
3  Wt_or_Vol 1

$preySummary
                Taxon  Items Wt_or_Vol Occurrence
1   Lepidoptera larva 0.5415        NA     0.0833
2          Coleoptera 0.2500        NA     0.4167
3             Diptera 0.0690        NA         NA
4         Lepidoptera 0.0690        NA         NA
5           Hemiptera 0.0260        NA         NA
6         Hymenoptera 0.0260        NA     0.0833
7             Araneae 0.0185        NA         NA
8       Unid. Insecta     NA     0.641     0.4645
9 Unid. Magnoliopsida     NA     0.359     0.3215
```
