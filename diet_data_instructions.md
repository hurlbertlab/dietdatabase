INSTRUCTIONS FOR FINDING AND ENTERING AVIAN DIET DATA
=====================================================

1. Use the "NA_avian_diet_refs.txt" file to identify potential studies with diet
information for the species you are working on.

2. Find the study by pasting the title into Google Scholar or Web of Science.

3. Search for tabular, quantitative diet data. In some cases, it's possible
that quantitative diet data is described in the text and a table is not provided
but this should be rare.

4. Make sure you understand which bird species is being studied. Many species
names (both common names and scientific names) have changed over time, so older
studies in particular may be using one that is out of date. Check whether the 
common and scientific names of your bird are listed in the [most recent eBird
taxonomy checklist](birdtaxonomy/eBird_Taxonomy_V2016.csv) in the `birdtaxonomy` 
folder (try using Ctrl-F or Cmd-F to search for a name). If both names are present
in the eBird checklist then you can enter them as is into the database file.

If the name is not in the eBird taxonomy checklist, try pasting the scientific
name into the search bar at http://avibase.bsc-eoc.org. If a "Search results"
page comes up, click on the first link for which "Status" is blank and for
which there is no additional subspecies name listed. This should bring you to an
information page for this taxon. Click on the "taxon grid" link across the top,
and then on "American Ornithologists' Union - versions 1 to 7". In general, we
will be using the scientific and common names according to the most recent
edition (currently the 7th) of the American Ornithologists' Union taxonomy.

Try this for the following species and see what happens: 

*Dendroica townsendi*. Note that this search goes straight to the taxon page. 
    The taxon grid is quite straightforward, and shows that there is a single 
    species concept which has changed names over time from *Dendroica townsendi* to 
    *Setophaga townsendi*. Re-check the eBird Taxonomy checklist for this name, and
    you'll find it's present--that's the name that should be used in the database
    even if the study the data are coming from called it the former.
 
*Empidonax difficilis*. This one is more complicated, with many more species 
    concepts listed on [Avibase](http://avibase.bsc-eoc.org/species.jsp?avibaseid=44A2028364A252A6&sec=taxontable&version=aou). 
    Many of these are different subspecies which we can ignore 
    (e.g., the bottom two rows, and 3 of the middle rows). Otherwise, what this
    taxon grid shows is that up through the 6th edition (1983), there was a single
    species concept referred to as *Empidonax difficilis* with the common name 
    "Western Flycatcher". However, by 1998 and the publication of the 7th edition,
    taxonomists had split this species into two separate species. One of them
    retained *Empidonax difficilis* as its scientific name, but the common name
    changed to "Pacific-slope Flycatcher". The other took on the scientific name
    *Empidonax occidentalis* and the common name "Cordilleran Flycatcher". 

If you came across a study reporting diet info for *Empidonax difficilis*, 
    which species is it referring to? If it's an older study, it could be referring
    to either one. One way to figure this out is by checking the geographic ranges
    of the two split species. Click on the "eBird" link across the top of the Avibase page
    to see where "Pacific-slope Flycatcher" (i.e. the concept that *Empidonax
    difficilis* currently refers to) occurs. Take a look, and then in the "Related 
    taxa" dropdown menu, select "*Empidonax occidentalis*" to see where "Cordilleran
    Flycatcher" occurs. There is some overlap, but if the study was done in
    California, they were probably referring to Pacific-slope Flycatcher. If it was
    done in Colorado, it was probably referring to Cordilleran Flycatcher. Usually 
    (but not always!) this information will help you narrow down which species
    the study actually refers to.

5. Read the study and enter as much information as you can find about where 
(latitude, longitude, altitude, regions, place names) and when (years, season) 
it was conducted. Refer to the https://github.com/hurlbertlab/dietdatabase 
README file for more details.

6. Read the table caption and/or Methods section carefully to understand how
the study quantified diet. This will determine what you specify as the "Diet_Type". The options are: 

    <table>
      <tr>
        <td>Wt_or_Vol</td>
        <td>Fraction of the diet as measured by weight or volume. E.g., all beetles 
        in the stomach contents were weighed, and this value was divided by the mass
        of all stomach contents. Convert all %s to fractions between 0 and 1.</td>
      </tr>
      <tr>
        <td>Items</td>
        <td>Fraction of the diet as measured by a count of the number of prey items. 
        E.g., the number of beetles in the stomach contents were counted, and this 
        value was divided by the total number of unique prey items in the stomach 
        contents. Convert all %s to fractions between 0 and 1.</td>
      </tr>
      <tr>
        <td>Occurrence</td>
        <td>Fraction of the birds examined that contained at least one individual of 
        this prey type.  Convert all %s to fractions between 0 and 1.</td>
      </tr>
      <tr>
        <td>Unspecified</td>
        <td>Fraction of the diet of the prey item based on a methodology unspecified by 
        the authors.  Convert all %s to fractions between 0 and 1.</td>
      </tr>
      <tr>
    </table>

    In some cases, the data will not be provided as a fraction or %, and you will 
    need to calculate this yourself. If so, make a note about what you did in the
    Notes field. If you are calculating fractions yourself, **round entries to the 
    nearest 0.001**. If a value is reported as "<0.01", then **DO NOT ENTER the "<" sign**
    but instead, enter one half of the upper limit reported (in this example, 0.005).

7. When entering information on the prey, try to fill in all of the higher taxonomic level 
information above the taxonomic level reported. For example, if the prey category reported is the Order "Coleoptera" 
(i.e. beetles), then you would also fill in "Animalia", "Arthropoda", and "Insecta" for the 
Prey_Kingdom, Prey_Phylum, and Prey_Class fields. You can verify this information by pasting
the prey name into the [Global Names Resolver](http://resolver.globalnames.biodinfo.org/) and 
clicking on "Resolve Names". This will generate a report of the hierarchical classification
of your name as reported by various entities. For consistency, we will typically rely on the 
reported classification of ITIS (Integrated Taxonomic Information System), which in
this example provides a report that looks like this (try finding "ITIS" on the browser page 
using Ctrl-F as it may be a ways down in the report):

Coleoptera Linnaeus, 1758 [ exact canonical match, Score: 0.75 ]  
ITIS  
Animalia (Kingdom) >> Bilateria (Subkingdom) >> Protostomia (Infrakingdom) >> Ecdysozoa (Superphylum) >> Arthropoda (Phylum) >> Hexapoda (Subphylum) >> Insecta (Class) >> Pterygota (Subclass) >> Neoptera (Infraclass) >> Holometabola (Superorder) >> Coleoptera (Order) 

This provides many intermediate levels of the taxonomic hierarchy, and for our purposes we are just focusing on 
Kingdom, Phylum, Class, Order, Suborder (if listed), Family, Genus, or full Scientific Name.

8. In some cases, the prey name as given in the paper will not match any currently accepted 
ITIS name. Sometimes you may find an indication that the name has been changed, and you
can see if that changed name is recognized by ITIS. If so, go ahead and enter the valid ITIS
name in the database. If you cannot find a valid name, simply enter the name as reported.

---

Try entering data from the two studies listed below. Open the AvianDietDatabase_template.txt
template in Excel and then Save into the same folder using a new file name where you add 
your initials to the end (e.g. 'training_dietdatabase_AHH.txt').

# Training Dataset 1

Beaver and Baldwin 1975. Ecological overlap and the problem of competition and sympatry
in the Western and Hammond's Flycatchers. Condor 77: 1-13.

Look out for any taxonomic issues!

# Training Dataset 2

Allaire, P. N. and C. D. Fisher. 1975. Feeding ecology of three resident sympatric 
sparrows in eastern Texas. Auk 92:260-269.

Note here that diet information is provided for different seasons, which should be
entered separately. 

In addition, percentages given are for seeds and arthropods separately such that 
each group adds to 100%. If you want to characterize the stomach contents so that
seeds plus arthropods adds up to 100%, how would you do it? Consider this example,
where you know that there were 110 total seeds found in the stomach contents, and 30
total insect individuals.

| Diet item | Percent |
|----------|---------|
| Seed 1   | 80 |
| Seed 2   | 20 |
| Insect 1 | 60 |
| Insect 2 | 40 |

Try to work it out for yourself.

You should have gotten 62.9% of Seed 1 (.8 * 110) / (110 + 30),  
15.7% of Seed 2 (.2 * 110) / (110 + 30),  
12.9% of Insect 1 (.6 * 30) / (110 + 30), and   
8.6% of Insect 2 (.4 * 30) / (110 + 30).
