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

You can now open the database file ('AvianDietDatabase.txt') in Excel or Open Office and begin entering data. More details
on this below. When you are finished with data entry for the day, be sure to Save As a tab-delimited .txt file (with the same name,
in the same folder).

Now you need to stage your committed changes, add a descriptive message of what you've added, and 'push' the new version
to the master repository.

```
$ git commit -am "added 3 diet studies for red-eyed vireo and 2 for white-eyed vireo"
$ git push origin master
```

Enter your github userid and password if prompted. Now your up-to-date files are available for incorporation into GloBI and
for others to add to!

##Potential Problems
Occasionally, when you try to push your latest changes, you will get an error like this:

```
error: failed to push some refs to 'https://github.com/hurlbertlab/dietdatabase.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

This comes up when two people both download the latest version of the database, and each
person makes some changes (i.e., adds some data) independent of the other. The second
person to try to push their changes doesn't have the changes made by the first, and so
Git points out the potential problem.

As the hint message suggests, try re-pulling the repository with a `$ git pull origin master`.
(Note that you need to have closed the database file on your machine before pulling,
or you will get a message that your file is "unlinked". In that case, just close the file
and try again.) Usually, this will take care of the problem and you will see a message like this:

```
Auto-merging AvianDietDatabase.txt
Merge made by the 'recursive' strategy.
```

In that case, Git figured out that you both were making changes to different parts of the 
database, and incorporated both sets of changes to the most up to date version.

However, if you were both editing the same part of the database (and this 
includes a scenario where both people are simply adding different data to the 
bottom of the file), you might see this message after you try to pull.

```
Auto-merging AvianDietDatabase.txt
CONFLICT (content): Merge conflict in AvianDietDatabase.txt
Automatic merge failed; fix conflicts and then commit the result.
```

In this case, Git couldn't figure out what to do, so you will have to resolve the problem
manually. Open the file that has the merge conflict like you normally would. Git 
has flagged the conflict within the region, so search (Ctrl-F) for the following
text: "<<<<<<< HEAD" (without the quotes). Now let's say you just added a row of data
for American Robin as the last line in the database, and someone else added a row of
data for Red-winged Blackbird. Then you will see something like this:

```
<<<<<<< HEAD
American Robin	(and whatever other data is in this line)
========
Red-winged Blackbird (and whatever other data is in THIS line)
>>>>>>>dca3kdjs33jdj3
```

Everything above the ======= line is one version, and everything below is the other
version. In this case, you want both of the edits to be saved in the final version,
so simply delete the entire lines starting with <<<<<<<, ========, and >>>>>>>.

```
American Robin	(and whatever other data)
Red-winged Blackbird (and whatever other data)
```

Then save the file, commit the change with a short message, and push it as you 
normally would. There should be no error messages!

In the event that both of you actually edited the same line in the database, and
one of the versions is out of date or incorrect, then you would simply delete
the edits you did not want to keep in addition to the <<<<<<, =======, and >>>>>>> lines.

```
<<<<<<< HEAD
American Robin	some wrong data on this line
=======
American Robin 	some correct data, or edits that you want to keep
>>>>>>>dca83kd9sfas933ks33
```

gets edited down to just

```
American Robin	some correct data, or edits that you want to keep
```

Save. Commit. Push.


##Finding Diet Data
We are focusing our search for diet data in the published literature. References related to avian diets have been scraped
from individual species accounts on the [Birds of North America website](http://bna.birds.cornell.edu/bna/), and are
provided in the file 'NA_avian_diet_refs.txt'. For each species, look up the listed references to see if they contain
raw diet data summaries. If you were able to look up the reference, put a 'y' in the 'checked' column. If the reference was 
unavailable (couldn't access it online, not in the library) put a 'n'. For those that you checked, indicate (y/n) whether it
contained diet data in the 'useable_data' column.

_*NOTE*_: Place pdfs of all papers you find with usable data in the following folder on the HurlbertLab drive:
*HurlbertLab > Databases > DietDatabase > Papers with data*. The file should be saved with the last name of the author(s) and the year. For example, "Beaver and Baldwin 1975.pdf" or "Hurlbert et al 2007.pdf".

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
    <td>Common_Name</td>
    <td>The common name of the species whose diet is being characterized.</td>
  </tr>
  <tr>
    <td>Scientific_Name</td>
    <td>Genus and species of the species whose diet is being characterized. For North American birds 
    we will generally follow the most recent AOU checklist. Make sure that this is the currently accepted name by 
    checking http://help.ebird.org/customer/portal/kb_article_attachments/35388/original.xls?1407441617 and
    http://avibase.bsc-eoc.org/. Names from older papers are potentially out of date.</td>
  </tr>
  <tr>
    <td>Family</td>
    <td>Family of the species whose diet is being characterized.</td>
  </tr>
  <tr>
    <td>Taxonomy</td>
    <td>The taxonomic authority for the scientific name. For example, the American Ornithologists' Union supplement. 
    Refer to http://avibase.bsc-eoc.org/ (and then search for the species) for the most up to date taxonomy.</td>
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
    <td>Prey_Scientific_Name</td>
    <td>The full scientific name, genus and species, to which the prey item belongs.</td>
  </tr>
  <tr>
    <td>Unassigned</td>
    <td>If "NO", then the diet fraction reported represents the fraction made up by all members of that lowest level of taxonomic classification reported. If "YES", then the diet fraction reported represents the fraction made up by those members of that lowest level of taxonomic classification reported that were not identified to lower levels. For example, let's say some diet items are identified to various families within Coleoptera, while some diet items are listed as "Unidentified Coleoptera" with the family unknown. In this case, we would have separate lines for the families "Tenebrionidae" and "Carabidae" for which <i>Unassigned</i> would be "NO", but we might also have a line that identifies only down to Order Coleoptera for which <i>Unassigned</i> would be "YES" because the value in this row does not represent the fraction of the diet made up of all Coleoptera, only the Coleoptera that were not assigned to other groups. <b>Use this field rather than ever entering "Unidentified" or "Unknown" in any of the prey taxonomic rank fields.</b>
    of the diet in that rank, or it could refer to the fraction of the diet .</td>
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
    <td>The way that diet data were collected. Options include: emetic, fecal examination, stomach contents, 
	behavioral observation. "Stomach contents"
    implies that the birds were sacrificed and their complete stomach contents were examined.</td>
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
