# Instructions for taxonomic name cleaning and filling in Prey_Name_ITIS_ID

Taxonomic names may have changed since the study reporting them was originally
published. Errors may also creep into taxonomic names via typos during data
entry. 

The `clean_all_names()` function goes through each taxonomic level of prey
names and finds the ITIS ID number of names that match, and flags the names that
do not match. Here's an example using a test file with some known name problems.

```
> clean = clean_all_names('cleaning/test_namereplace_db.txt')

[1] "1 out of 1"

Retrieving data for taxon 'Stellaria'

       tsn                                  target                                      commonNames    nameUsage
1   915378                   Alsophila mostellaria                                               NA     accepted
2    44913                            Cristellaria                                               NA      invalid
3    23670                Harrimanella stellariana                                               NA not accepted
4   524470             Phlox bifida ssp. stellaria                                      cleft phlox     accepted
5   538671             Phlox bifida var. stellaria                                               NA not accepted
6   518969                         Phlox stellaria                                               NA not accepted
7    20357                         Pseudostellaria                                               NA     accepted
8    20358               Pseudostellaria jamesiana   sticky-starwort,sticky starwort,tuber starwort     accepted
9   823597               Pseudostellaria oxyphylla                                  robust starwort     accepted
10  823583                 Pseudostellaria sierrae                                               NA     accepted
11   20163                               Stellaria                                         starwort     accepted
12  989178                               Stellaria                                               NA      invalid
...
More than one TSN found for taxon 'Stellaria'!

            Enter rownumber of taxon (other inputs will return 'NA'):

1: 
```
Name cleaning will be an interactive process, as the computer will frequently need
your input to know how to proceed. In this case, the first name it tries to look up
is 'Stellaria', and it has found multiple potential matches (of which I'm only showing 
the first 12). As it indicates, you must decide which of these entities is the one
you want. Rows 11 and 12 are the only ones with just a simple genus name 'Stellaria',
and Row 12 says that entity is invalid while the name in Row 11 is accepted. Thus we would
type '11' and hit Enter, and R would move on to the next names to clean.

```
Input accepted, took taxon 'Stellaria'.

[1] "1 out of 1"

Retrieving data for taxon 'Acarina'

[1] "1 out of 2"

Retrieving data for taxon 'Rodentia'

[1] "2 out of 2"

Retrieving data for taxon 'Reptilia/Amphibia'

[1] "1 out of 3"

Retrieving data for taxon 'Streptophyta'

[1] "2 out of 3"

Retrieving data for taxon 'Foraminifera'

     tsn                      target commonNames nameUsage
1 879150       Edilemma foraminifera          NA     valid
2   1651 Paraphysomonas foraminifera          NA  accepted

More than one TSN found for taxon 'Foraminifera'!

            Enter rownumber of taxon (other inputs will return 'NA'):

1: 
```
The next several names R seems to know how to treat, until we get down to 
Foraminifera. In this case, it lists two individual species names, 
neither of which reflects the broad overall taxonomic group that are the
[Foraminifera](https://en.wikipedia.org/wiki/Foraminifera). If there is
no match (which will be the case with an old outdated name, as well), then
simply hit enter.

When the function has finished, we've created an object called clean, which has
two elements, one called `cleandb` and one called `badnames`. Each of these objects 
gets saved to the same folder that the original file was read in from:
"<originalFilename>_clean.txt" and "<originalFilename>_badnames.txt"
```
> names(clean)
[1] "cleandb"   "probnames"

> clean$cleandb

   Prey_Kingdom     Prey_Phylum        Prey_Class     Prey_Order Prey_Suborder     Prey_Family Prey_Genus Prey_Scientific_Name Unidentified Prey_Name_ITIS_ID 
1       Plantae    Tracheophyta     Magnoliopsida Caryophyllales            NA Caryophyllaceae  Stellaria                   NA                          20163 
2       Plantae    Tracheophyta     Magnoliopsida Caryophyllales            NA Caryophyllaceae  Stellaria                   NA                          20163 
3       Plantae    Streptophyta                                             NA                                              NA          yes        unverified 
4       Plantae    Streptophyta                                             NA                                              NA          yes        unverified 
5       Plantae    Streptophyta                                             NA                                              NA          yes        unverified 
6          <NA>    Foraminifera              <NA>           <NA>            NA            <NA>       <NA>                   NA         <NA>        unverified 
7          <NA>    Foraminifera              <NA>           <NA>            NA            <NA>       <NA>                   NA         <NA>        unverified 
8          <NA> Bacillariophyta              <NA>           <NA>            NA            <NA>       <NA>                   NA         <NA>        unverified 
9          <NA> Bacillariophyta              <NA>           <NA>            NA            <NA>       <NA>                   NA         <NA>        unverified 
10     Animalia        Chordata          Rodentia                           NA                                              NA           no        unverified 
11     Animalia        Chordata Reptilia/Amphibia                           NA                                              NA          yes        unverified 
12     Animalia        Chordata          Rodentia                           NA                                              NA           no        unverified 
13     Animalia        Chordata Reptilia/Amphibia                           NA                                              NA           no        unverified 
14     Animalia      Arthropoda         Arachnida        Acarina            NA                                              NA                     unverified 
15     Animalia      Arthropoda         Arachnida        Acarina            NA                                              NA                     unverified 
16     Animalia      Arthropoda           Insecta        Acarina            NA                                              NA                     unverified 
```
The `cleandb` object is simply a version of the original database but with prey 
taxonomic name info updated when it was obvious how to do so. Note that in the first
two rows corresponding to the Genus 'Stellaria', Prey_Phylum was changed from 
'Streptophyta' to 'Tracheophyta' according to ITIS taxonomy, and the ITIS ID
was added.

The `badnames` object is a list of names that did not match the ITIS database
at the taxonomic level specified:
```
> clean$probnames
    level              name            condition
1   Order           Acarina  wrong rank; too low
2   Class          Rodentia wrong rank; too high
3   Class Reptilia/Amphibia            unmatched
4  Phylum      Streptophyta  wrong rank; too low
5  Phylum      Foraminifera            unmatched
6  Phylum   Bacillariophyta  wrong rank; too low
7 Kingdom              <NA>      unaccepted name
```
These are names that you will have to decide how to fix or treat, and in some cases
the 'condition' column can help. 


1) To begin cleaning, first find and open the PDF of the study (given in the "study" column) this name 
appeared in. Most pdfs should be in the HurlbertLab folder > Databases > DietDatabase >
 Papers with data. If the paper is not in this folder, track it down online and 
save a PDF here.

2) Search the PDF for the unmatched name (use Ctrl-F). 

3) If you find the unmatched name, pay attention to any contextual clues about 
what organism the name refers to. For example, the Beal (1912) source refers to a
species called "Megilla maculata". This species is listed under Coleoptera.

6) Now paste this name into the [Global Names Resolver](http://resolver.globalnames.org/).
If we are lucky, it will link to the currently accepted taxonomic name for that entity.
If so, make sure the higher classification matches up with whatever info you gleaned
from the original source. 

7) If the name you pasted in does not generate any results in the Global Names Resolver,
then try Google. Again, you are looking for clues for what this name refers to. In the 
case of "Megilla maculata", the first hit in Google is for a study called "Notes on the
parasite of the Spotted Lady-Beetle (Megilla maculata)". Great! So, now try Googling
"Spotted lady-beetle". This points us towards web entries for "Coleomegilla maculata", which
certainly makes sense. Let's paste this new name in the [Global Names Resolver](http://resolver.globalnames.org/)
just to be sure. Yes, looks good.

8) Now we want to provide a conversion table to tell R how to fix these names. Open the
the 'badnames' file in the cleaning folder on your machine and open up this file in Excel.
Add two new columns on to the right hand side, one called 'replacewith', and one called 'notes'.

For problem names which were the result of a typo or taxnomic name update, you can
put the corrected or updated name in the 'replacewith' column.

If a taxonomic update also requires editing other fields as well, this can be done in the notes
column. As long as the updated name is a valid ITIS name at the specificed taxonomic
level, then usually no notes will be required.

However, in the example above, 'Rodentia' is problematic because it is not a Class, 
but rather an Order within Class Mammalia. Thus, we would write 'Mammalia' in the 'replacewith'
column and in the 'notes' column we would type 'Order = Rodentia'.

In the case of 'Acarina', we find that not only is the name outdated (the currently 
accepted name is ['Acari'](https://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=733321#null)),
but it is not an Order, but rather a Subclass. Thus we would leave 'replacewith' blank
because this taxonomic entity does not specify any particular order, and in the 'notes'
field we might write 'Class = Arachnida & Phylum = Arthropoda & Kingdom = Animalia'.
We can specify as many fields as we would like as long as each phrase of the form
'(fieldname) = (value)' is separated by a '&'.



As always, if you have any questions, don't hesitate to ask me!

