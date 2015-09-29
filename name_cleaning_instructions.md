## Instructions for taxonomic name cleaning

Taxonomic names may have changed since the study reporting them was originally
published. Errors may also creep into taxonomic names via typos during data
entry. Taxonomic names are automatically checked against the main online
taxonomic name databases through our partner Global Biotic Interactions.

1) To see a list of names that currently do not match up with existing databases,
go to http://globalbioticinteractions.org/references.html and click on the
unmatchedTaxa.csv file in the upper right.

2) This file has unmatched taxonomic names from a large variety of sources, but 
if you open this file in Excel, you can sort by the 'source' column and focus
in on the rows for "Allen Hurlbert. Avian Diet Database".

3) Names to be cleaned are in the "unmatched taxon name" column. To begin cleaning,
first find and open the PDF of the study (given in the "study" column) this name 
appeared in. Most pdfs should be in the HurlbertLab folder > Databases > DietDatabase >
 Papers with data. If the paper is not in this folder, track it down online and 
save a PDF here.

4) Search the PDF for the unmatched name (use Ctrl-F). 

5) If you find the unmatched name, pay attention to any contextual clues about 
what organism the name refers to. For example, the Beal (1912) source refers to a
species called "Megilla maculata". This species is listed under Coleoptera.

6) Now paste this name into the [Global Names Resolver](http://resolver.globalnames.org/).
If we are lucky, it will link to the currently accepted taxonomic name for that entity.
If so, make sure the higher classification matches up with whatever info you gleaned
from the original source. The unmatchedTaxa.csv file may actually provide some
possible suggestions to check under the "similar to taxon path" column.

7) If the name you pasted in does not generate any results in the Global Names Resolver,
then try Google. Again, you are looking for clues for what this name refers to. In the 
case of "Megilla maculata", the first hit in Google is for a study called "Notes on the
parasite of the Spotted Lady-Beetle (Megilla maculata)". Great! So, now try Googling
"Spotted lady-beetle". This points us towards web entries for "Coleomegilla maculata", which
certainly makes sense. Let's paste this new name in the [Global Names Resolver](http://resolver.globalnames.org/)
just to be sure. Yes, looks good.

8) Now we want to update the Avian Diet Database. With the Avian Diet Database open 
in Excel, hit Ctrl-H for Find and Replace, and type in the old and new names respectively. 
Then hit "Replace All".

9) Now we want to record the fact that we've changed the taxonomic name from what
was originally reported in the study. Do this in the name_changes.txt where you'll
record the old and new names in the 'source taxon name' and 'name changed to' fields,
respectively. If the new name appears as a suggestion in the unmatchedTaxa.csv file
and has a taxon id, then record this as well. The taxon id reflects a database source
and a id number, e.g. "ITIS:193675". Finally, paste in the citation for the original
study from the 'study' field of the unmatchedTaxa.csv file.

10) TYPOS! Typos are just as likely as changes in taxonomy to lead to bad names. 
If the name was typed incorrectly when data were entered, then the name you search
will not match with anything in the PDF. Try searching just the genus name, or just 
the species name if this is the case. For example, if the unmatched name is "Apodius 
vittatus", but this represnts a typo during entry of "Aphodius vittatus". Then 
searches of "Apodius vittatus" or "Apodius" will not match anything in the pdf, but 
a search of "vittatus" would. At that point you would realize there had been a typo 
during data entry, and that "Aphodius vittatus" is what should have been entered.

11) Now you want to make sure this is still a commonly accepted name using the Global
Names Resolver. If it is, then you should go ahead and Find-and-Replace the typos in
the Avian Diet Database. You're done with this name and on to the next. NO NEED TO
ENTER THIS CORRECTION INTO THE name_changes.txt FILE SINCE IT DOES NOT REFLECT A
TAXONOMIC NAME CHANGE, JUST A TYPO THAT NEVER SHOULD HAVE BEEN MADE IN THE FIRST PLACE.

12) If the typo-corrected name HAS been replaced by a more modern taxonomic concept, 
then go ahead and follow steps 7-9 to correct the name and record the change.

As always, if you have any questions, don't hesitate to ask me!