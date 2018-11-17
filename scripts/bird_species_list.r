# Checklist of birds of the United States and Canada obtained from Avibase here:
# https://avibase.bsc-eoc.org/checklist.jsp?lang=EN&p2=1&list=clements&synlang=&region=NA1&version=text&lifelist=&highlight=0

#Description: All 50 US States, Canada, St-Pierre & Miquelon
#Number of species: 1216
#Number of endemics: 25
#Number of breeding endemics: 1
#Number of globally threatened species: 106
#Number of extinct species: 24
#Number of introduced species: 130

# Read this file in, then weed out all species that are Extinct, Rare/Accidental, or Introduced.

library(dplyr)
library(stringr)

birdtax = read.csv('birdtaxonomy/eBird_Taxonomy_v2016_NorthAmerica.csv', header=T, 
                     quote = '', fill = T, stringsAsFactors = FALSE)

exclude = c("Introduced", "Extinct", "Extirpated", "Rare/Accidental")

btax = filter(birdtax, !grepl(paste(exclude, collapse = "|"), Status))

# Add a few species that are introduced but long enough ago to be considered part of the avifauna
add = filter(birdtax, CommonName %in% c("Rock Pigeon", "House Sparrow", "Alder/Willow Flycatcher (Traill's Flycatcher)",
                                        "Mute Swan", "Ring-necked Pheasant", "European Starling"))

tax = rbind(btax, add)

# Merge in Family and Order names from overall eBird 2018 checklist
# available here: http://www.birds.cornell.edu/clementschecklist/download/
ebird = read.table('birdtaxonomy/eBird_Taxonomy_v2018_14Aug2018.csv', header = T,
                 sep = ',', quote = '\"', stringsAsFactors = F)

spplist = left_join(tax, ebird, by = c("CommonName" = "PRIMARY_COM_NAME")) %>%
  mutate(Family = word(FAMILY, 1), list = 1) %>% 
  select(CommonName, SciName, Family, ORDER1, list)

# Now compare to species in the Diet Database
diet = read.table('AvianDietDatabase.txt', header=T, sep = '\t', quote = '', fill = T, stringsAsFactors = FALSE)

dietsp = data.frame(CommonName = unique(diet$Common_Name), dietdb = 1)

spplist2 = full_join(spplist, dietsp)

spplist2$list[is.na(spplist2$list)] = 0
spplist2$dietdb[is.na(spplist2$dietdb)] = 0


famtotals = spplist2 %>% group_by(ORDER1, Family) %>% 
  summarize(TotalSp = sum(list), WithData = sum(dietdb)) %>%
  mutate(WithoutData = TotalSp - WithData) %>%
  data.frame()

