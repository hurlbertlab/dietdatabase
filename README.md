Avian Diet Database
===================

This repository is the temporary home for the Avian Diet Database being built
by the Hurlbert Lab at the University of North Carolina.

The goal is to organize all available information (from published studies, gray literature, etc) on the diets 
of North American birds in its rawest form possible with the idea that this may be a resource for a broad 
range of ecological questions.

These data are automatically incorporated into the Global Biotic Interactions (GloBI) database.
See [http://www.globalbioticinteractions.org](http://www.globalbioticinteractions.org/index.html) for more details.

##Data Entry and Versioning using Git

The database is under version control using Git so that we can easily go back to previous states, it's automatically
backed up, and many people can access it and add records simultaneously from different computers.

This means that you will need to learn some basic Git commands for working with it. 

From your local machine, open Git (e.g. using Git Bash from a Windows machine), and 'pull' down the most up-to-date
version of the database after making sure you're in the right directory housing the repository.

```
$ cd /c/git/dietdatabase
$ git pull origin master
```

You can now open the database file ('AvianDietDatabase.csv') in Excel or Open Office and begin entering data. More details
on this below. When you are finished with data entry for the day, be sure to Save As a .csv file (with the same name,
in the same folder).

Now you need to stage your committed changes, add a descriptive message of what you've added, and 'push' the new version
to the master repository.

```
$ git commit -am "added 3 diet studies for red-eyed vireo and 2 for white-eyed vireo"
$ git push origin master
```

Enter your github userid and password if prompted. Now your up-to-date files are available for incorporation into GloBI and
for others to add to!

##Finding Diet Data
We are focusing our search for diet data in the published literature. References related to avian diets have been scraped
from individual species accounts on the [Birds of North America website](http://bna.birds.cornell.edu/bna/), and are
provided in the file 'NA_avian_diet_refs.txt'. For each species, look up the listed references to see if they contain
raw diet data summaries. If you were able to look up the reference, put a 'y' in the 'checked' column. If the reference was 
unavailable (couldn't access it online, not in the library) put a 'n'. For those that you checked, indicate (y/n) whether it
contained diet data in the 'useable_data' column.

After you have examined all of the references listed in this table for a given species, you will perform a literature search
to see if any additional papers have been published on the diet of this species since the Birds of North America species
account was published or last revised (the year in the "revised" column). 

###Web of Science search
Go to [Web of Science](http://apps.webofknowledge.com) and in the Topic search box enter:  

"[common name] AND (diet OR foraging OR food)", replacing [common name] with the actual common name of the species you are searching.

Click on +Add Another Field, and select Year Published. Search all years since the last revised date for that species as listed in the 
'NA_avian_diet_refs' table.  

Look up the papers in the search results, and be sure to add any that contain useful data to the NA_avian_diet_refs.txt table.

##Data Entry Details
To maximize the utility of the data, we need to record many types of information describing the what, when, where, and how 
of its collection, and so our database has many fields. In the table below we explain what exactly is characterized in each
of these fields, and how data should be entered.

<table>
  <tr>
    <td>Field</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>ID</td>
    <td>A unique row ID referring to one particular trophic link between a bird and a prey item as identified from a particular study.
    Each row should be incremented by one.</td>
  </tr>
  <tr>
    <td>Common_Name</td>
    <td>The common name of the species whose diet is being characterized.</td>
  </tr>
  <tr>
    <td>Scientific_Name</td>
    <td>Genus and species of the species whose diet is being characterized. Make sure that this is the currently accepted name by 
    checking here and here. Names from older papers are potentially out of date.</td>
  </tr>
  <tr>
    <td>Family</td>
    <td>Family of the species whose diet is being characterized.</td>
  </tr>
  <tr>
    <td>Taxonomy</td>
    <td>The taxonomic authority for the scientific name. For example, the American Ornithologists' Union supplement.</td>
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
    <td>Location of the study based on national or subnational place name (e.g., Florida, or Jamaica).</td>
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
        +urban. 
        E.g. "deciduous forest; woodland"
        </td>
  </tr>
  <tr>
    <td>Observation_Month_Begin</td>
    <td>The month in which diet data were first collected, using numbers 1-12.</td>
  </tr>
  <tr>
    <td>Observation_Year_Begin</td>
    <td>The year in which diet data were first collected in the study.</td>
  </tr>
  <tr>
    <td>Observation_Month_End</td>
    <td>The month in which diet data were last collected, using numbers 1-12.</td>
  </tr>
  <tr>
    <td>Observation_Year_End</td>
    <td>The year in which diet data were last collected in the study.</td>
  </tr>
  <tr>
    <td>Observation_Season</td>
    <td>The season(s) in which diet data were last collected. Possible values include spring, summer, fall, winter, or multiple.</td>
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
    be classified as Order Hemiptera, Suborder Homoptera. A report of "Hemiptera" should be classified as Order Hemiptera, 
    Suborder Heteroptera.</td>
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
    <td>Prey_Scientific_Name </td>
    <td>The full scientific name, genus and species, to which the prey item belongs.</td>
  </tr>
  <tr>
    <td>Prey_Stage</td>
    <td>The lifestage of the identified prey item (e.g., adult, larvae, egg).</td>
  </tr>
  <tr>
    <td>Prey_Part</td>
    <td>The part of the prey species represented in the diet if only a part was (likely) consumed. Especially for plant-based
    diet items, e.g., seed, fruit, etc.</td>
  </tr>
  <tr>
    <td>Prey_Common_Name</td>
    <td>Common name of the prey item if provided.</td>
  </tr>
  <tr>
    <td>Fraction_Diet_By_Wt_or_Vol</td>
    <td>Fraction of the diet as measured by weight or volume. E.g., all beetles in the stomach contents were weighed, and this
    value was divided by the mass of all stomach contents. Convert all %s to fractions between 0 and 1.</td>
  </tr>
  <tr>
    <td>Fraction_Diet_By_Items</td>
    <td>Fraction of the diet as measured by a count of the number of prey items. E.g., the number of beetles in the stomach
    contents were counted, and this value was divided by the total number of unique prey items in the stomach contents.
     Convert all %s to fractions between 0 and 1.</td>
  </tr>
  <tr>
    <td>Fraction_Occurrence</td>
    <td>Fraction of the birds examined that contained at least one individual of this prey type.  Convert all %s to 
    fractions between 0 and 1.</td>
  </tr>
  <tr>
    <td>Fraction_Diet_Unspecified</td>
    <td>Fraction of the diet of the prey item based on a currency unspecified by the authors.  Convert all %s to 
    fractions between 0 and 1.</td>
  </tr>
  <tr>
    <td>Item_Sample_Size</td>
    <td>Number of prey items identified in the diet sample.</td>
  </tr>
  <tr>
    <td>Bird_Sample_Size</td>
    <td>Number of individuals of the focal bird species used to characterize diet.</td>
  </tr>
  <tr>
    <td>Sites</td>
    <td>Number of study sites over which individuals were used to characterize the diet.</td>
  </tr>
  <tr>
    <td>Study_Type</td>
    <td>The way that diet data were collected. Options include: emetic, fecal examination, stomach contents. "Stomach contents"
    implies that the birds were sacrificed and their complete stomach contents were examined.</td>
  </tr>
  <tr>
    <td>Notes</td>
    <td>Any useful information about the nature of the study or the diet information that does not fit in the previous fields.</td>
  </tr>
  <tr>
    <td>Source</td>
    <td>The complete citation of the study from which the diet information comes.</td>
  </tr>
</table>
