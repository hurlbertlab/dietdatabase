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
studies in particular may be using one that is out of date. Paste the scientific
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
    *Setophaga townsendi*. It's the latter name that should be used in the database
    even if the study the data are coming from called it the former.
 
    *Empidonax difficilis*. This one is more complicated, with many more species 
    concepts listed. Many of these are different subspecies which we can ignore 
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
    of the two split species. Click on the "eBird" link across the top of this page
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
the study quantified diet. This will determine the column in which you will 
enter diet data. The options are: 

<table>
  <tr>
    <td>Fraction_Diet_By_Wt_or_Vol</td>
    <td>Fraction of the diet as measured by weight or volume. E.g., all beetles 
    in the stomach contents were weighed, and this value was divided by the mass
    of all stomach contents. Convert all %s to fractions between 0 and 1.</td>
  </tr>
  <tr>
    <td>Fraction_Diet_By_Items</td>
    <td>Fraction of the diet as measured by a count of the number of prey items. 
    E.g., the number of beetles in the stomach contents were counted, and this 
    value was divided by the total number of unique prey items in the stomach 
    contents. Convert all %s to fractions between 0 and 1.</td>
  </tr>
  <tr>
    <td>Fraction_Occurrence</td>
    <td>Fraction of the birds examined that contained at least one individual of 
    this prey type.  Convert all %s to fractions between 0 and 1.</td>
  </tr>
  <tr>
    <td>Fraction_Diet_Unspecified</td>
    <td>Fraction of the diet of the prey item based on a currency unspecified by 
    the authors.  Convert all %s to fractions between 0 and 1.</td>
  </tr>
  <tr>
</table>

In some cases, the data will not be provided as a fraction or %, and you will 
need to calculate this yourself. If so, make a note about what you did in the
Notes field.

7. Typically, you will be inserting your rows of data into the middle of the 
diet database in the section for the relevant Family. If you are working in
Excel, simply select the row above which you would like to insert the new data,
and then highlight downward as many rows as you will be inserting. Right click
"Insert" and you should have the appropriate number of blank rows in which to
enter or paste your new data.