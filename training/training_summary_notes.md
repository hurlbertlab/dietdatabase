# Training dataset notes

## Training Dataset 1. Beaver & Baldwin 1975

### Taxonomy
1. *Western flycatcher*. You should have found that Western Flycatcher (*Empidonax difficilis*)
was split into two species, the Pacific-slope Flycatcher (which retained the scientific name
*E. difficilis*) and the Cordilleran Flycatcher (*E. occidentalis*). How do you know which
of these two is represented by the study? By examining the range maps 
[here](http://avibase.bsc-eoc.org/species.jsp?lang=EN&avibaseid=44A2028364A252A6&sec=ebird) and 
[here](http://avibase.bsc-eoc.org/species.jsp?lang=EN&avibaseid=6FD04659A3D0CAC8&sec=ebird). 
The study was done in Colorado, so clearly they must have been examining the Cordilleran Flycatcher.
This means both the common name and the scientific name must be altered in the Diet Database.

2. *Homoptera*. Refers to leafhoppers, treehoppers, and cicadas and was historically considered 
an Order, but is now considered to be a suborder of Hemiptera by ITIS. Furthermore, its new
name is [Auchenorrhynca](http://resolver.globalnames.org/name_resolvers/ffrsyur980io).

3. *Bombidae*. Bumblebees, used to be considered a full family, but now is considered a
subfamily Bombinae within the family Apidae.

4. *Choristoneura fumiferana*. The spruce budworm in the Lepidoptera family Tortricidae is
now known as *Archips fumiferana* according to [ITIS](http://resolver.globalnames.org/name_resolvers/kku1hn1kuimh).

### Diet fractions
5. *Source*. Both Tables 4 and 5 include quantitative information on diet, but in Table 4, the data
reflect fraction of the diet by number of items, while in Table 5 the data reflect fraction by weight. 
This means that the Orders should each have two diet fraction entries within each row: 
Fraction_Diet_By_Items from Table 4 and Fraction_Diet_By_Wt_or_Vol from Table 5.

6. *Table 4*. Diet should be recorded to the finest taxonomic resolution possible. In most cases
here this is Family, but the values provided are percentages of the Order that family falls in
rather than percentages of the diet overall. This means you must multiply the Order % by the Family %. 
For example, Buprestidae makes up 8% of Coleoptera, which make up 16% of the diet, so Buprestidae 
makes up 1.28% (or a diet fraction of 0.0128, you can round to 0.013) of the overall diet, etc.

### Other
7. *Longitude and Latitude*. The study reports a location using "Township and Range" coordinates, 
T.23S., R.69W. These can be converted to longitude and latitude through websites like this
[one](http://www.earthpoint.us/TownshipsSearchByDescription.aspx).

8. *Location_Specific*. Either "San Isabel National Forest" or "Wet Mountains, San Isabel National
Forest" would be fine here.

9. *Habitat_type*. This study mentions collection in both deciduous and coniferous forest. We can
list them both, separated by a ";". Remember to stick to just these few standardized habitat names:
+deciduous forest 
+coniferous forest 
+woodland 
+scrubland 
+grassland 
+desert 
+wetland 
+agriculture 
+urban


## Training Dataset 2. Allaire & Fisher 1975

### Taxonomy
1. *Aimophila aestivalis*. The scientific name for Bachman's Sparrow was changed to 
*Peucaea aestivalis*.

2. *Genus sp.*. When an entry is listed as, for example, "Digitaria sp.", go ahead
and enter the Prey_Genus as "Digitaria", and set the Unidentified field to "no". This
implies that the data represents all members of this genus.

3. *Graminae*. This is an old family name for Grasses--the current name is "Poaceae".
Also, two species labeled "Graminae sp. 1" and "Graminae sp. 2" are listed, however we have
no way of linking these names to an existing taxonomic entity. As such, we will simply
create an entry for Prey_Family "Graminae" where Unidentified is "yes" and include the
sum of both of these species in a single entry. (E.g., for Field Sparrow in winter, the
Fraction_Diet_By_Items would be (0.46 + 0.14) times the fraction of all prey that are seeds; see below.)

4. *Compositae*. The new name of this plant family is "Asteraceae".

5. *Leguminosae*. The new name of this plant family is "Fabaceae".

6. *Triodia*. This name has no entry in the Global Names Resolver from the ITIS database,
but it is listed under NCBI, so we will consider this a good name.

7. *Homoptera*. See Training Dataset 1 notes.

8. *Arachnoides / Araneae*. Aranaea is a good Order, but the Global Names Resolver indicates
that it should be considered in the Class Arachnida, not Arachnoides.

9. *Isoptera*. The termites used to be considered their own order, but now are considered
to be within the order Blattodea which includes the cockroaches. But since termites and
cockroaches are pretty distinctive, we still want to separate them. In this case, we'll
keep Isoptera as the Prey_Suborder.

### Diet data
10. *Seeds*. Be sure to specify "seed" in the Prey_Part field when entering all of the
data from Table 1. Otherwise, it would be unclear whether the birds were eating
fruits, or leaves or other plant parts. Prey_Part is especially important for characterizing
plant diet items in general.

11. *Calculating the fraction*. As in the training example, to get an estimate of the fraction
of a given diet item in the overall diet, you need to multiply the reported % by the fraction
of all diet items that are seeds (for Table 1) or arthropods (for Table 2). For example, 
Digitaria makes up 92.2% of the seed diet for Field Sparrow in the summer, and the observed
diet consisted of 220 seeds and 12 arthropods. In this example, the Item_Sample_Size will be 232
total diet items. So, Fraction_Diet_By_Items = 92.2 * (220 / 220 + 12) = 87.4% or 0.874. 
Because data were not simply transcribed from a table, you should make a comment in the Notes 
field like "values provided by source are for % of seed diet and % of insect diet; % of total 
diet calculated based on relative abundance of seeds and insects."

### Other
12. *Bird Sample Size*. This is given in one of the bottom rows of each table. Note that in 
a given season, they collected (i.e. shot) birds, sorted their stomach contents, and then
broke the data down into these two tables. The total number of birds examined should be
the same in each table for a given species and season. This helps clue us into the fact
that the listing of 44 Bachman's Sparrows being examined for seeds in the winter must be a
typo, since a) only 4 stomachs had seeds, and b) only 4 stomachs were examined for insects.
Need to add a note to this effect in the Notes field.

13. *Longitude and Latitude*. Not provided, but pasting "Nacogdoches County, Texas lat long"
into Google provides estimates that can be used.