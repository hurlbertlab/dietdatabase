# Link 

# Common names from iNat database (through 2018) as hosted on Hurlbert Lab server
# assigning kingdoms based on iconic_taxon_name
icon_kingdom = data.frame(iconic_taxon_name = c("Plantae", "Insecta", "Animalia", "Aves", "Fungi", "Mollusca",
                                                "Actinopterygii", "Arachnida", "Reptilia", "Mammalia",
                                                "Amphibia", "Chromista", "Protozoa"),
                          Prey_Kingdom = c("Plantae", "Animalia", "Animalia", "Animalia", "Fungi",
                                           "Animalia", "Animalia", "Animalia", "Animalia", "Animalia",
                                           "Animalia", "Chromista", "Protozoa"))

info <- sessionInfo()
bioark <- ifelse(grepl("apple", info$platform), "/Volumes", "\\\\BioArk")
setwd(paste0(bioark, "/HurlbertLab/Databases/iNaturalist/"))
con <- DBI::dbConnect(RSQLite::SQLite(), dbname = "iNaturalist_s.db")
db_list_tables(con)
inat = tbl(con, "inat")

# Takes ~20-30 minutes
commNames = inat %>% 
  distinct(scientific_name, common_name, iconic_taxon_name) %>%
  filter(common_name != "",
         !grepl("Unconfirmed", common_name)) %>%
  left_join(icon_kingdom, by = 'iconic_taxon_name') %>%
  select(-iconic_taxon_name) %>%
  distinct() %>%
  collect()


diet = read.table('AvianDietDatabase.txt', header = T, sep = '\t', quote = '\"', fill = T)
dietnames = distinct(diet, Prey_Kingdom, Prey_Phylum, Prey_Class, Prey_Order, Prey_Suborder, Prey_Family, Prey_Genus, Prey_Scientific_Name)
  
phylumNames = dietnames %>%
  distinct(Prey_Kingdom, Prey_Phylum) %>%
  filter(Prey_Phylum != "", !is.na(Prey_Phylum)) %>% 
  left_join(commNames, by = c('Prey_Phylum' = 'scientific_name', 'Prey_Kingdom' = 'Prey_Kingdom')) %>%
  filter(!is.na(common_name),
         common_name != 'Mosses') %>% # leaving Bryophyta = mosses, deleting duplicate Bryophyta = Mosses
  mutate(rank = 'Prey_Phylum') %>%
  rename(taxon = Prey_Phylum) %>%
  arrange(taxon)

classNames = dietnames %>%
  distinct(Prey_Kingdom, Prey_Class) %>%
  filter(Prey_Class != "", !is.na(Prey_Class)) %>% 
  left_join(commNames, by = c('Prey_Class' = 'scientific_name', 'Prey_Kingdom' = 'Prey_Kingdom')) %>%
  filter(!is.na(common_name)) %>%
  mutate(rank = 'Prey_Class') %>%
  rename(taxon = Prey_Class) %>%
  arrange(taxon)

orderNames = dietnames %>%
  distinct(Prey_Kingdom, Prey_Order) %>%
  filter(Prey_Order != "", !is.na(Prey_Order)) %>% 
  left_join(commNames, by = c('Prey_Order' = 'scientific_name', 'Prey_Kingdom' = 'Prey_Kingdom')) %>%
  filter(!is.na(common_name),
         !common_name %in% c('Even-toed Ungulates and Cetaceans', 'pinks, cacti, and allies')) %>%
  mutate(rank = 'Prey_Order') %>%
  rename(taxon = Prey_Order) %>%
  arrange(taxon)

# Check names in this list for errors
suborderNames = dietnames %>%
  distinct(Prey_Kingdom, Prey_Suborder) %>%
  filter(Prey_Suborder != "", !is.na(Prey_Suborder)) %>% 
  left_join(commNames, by = c('Prey_Suborder' = 'scientific_name', 'Prey_Kingdom' = 'Prey_Kingdom')) %>%
  filter(!is.na(common_name),
         !common_name %in% c('')) %>%
  mutate(rank = 'Prey_Suborder') %>%
  rename(taxon = Prey_Suborder) %>%
  arrange(taxon)

familyNames = dietnames %>%
  distinct(Prey_Kingdom, Prey_Family) %>%
  filter(Prey_Family != "", !is.na(Prey_Family)) %>% 
  left_join(commNames, by = c('Prey_Family' = 'scientific_name', 'Prey_Kingdom' = 'Prey_Kingdom')) %>%
  filter(!is.na(common_name),
         !common_name %in% c('gourds, squashes, pumpkins, and allies', 
                             'Cascade Beetle', 
                             'ratanies', 
                             '<U+8568><U+985E>', 
                             'Tiphiid Flower Wasps')) %>%
  mutate(rank = 'Prey_Family') %>%
  rename(taxon = Prey_Family) %>%
  arrange(taxon)


genusNames = dietnames %>%
  distinct(Prey_Kingdom, Prey_Genus) %>%
  filter(Prey_Genus != "", !is.na(Prey_Genus)) %>% 
  left_join(commNames, by = c('Prey_Genus' = 'scientific_name', 'Prey_Kingdom' = 'Prey_Kingdom')) %>%
  filter(!is.na(common_name),
         !grepl(" sect. ", common_name),
         !common_name %in% c('Copperheads, Cottonmouths, and Cantils',
                             'Thimbleweeds, anemones, and windflowers',
                             'Cavity-nesting Honey Bees',
                             'Eurasian Water Voles',
                             'Water Melons',
                             'Sotol',
                             'Starapples',
                             'Cellophane-cuckoo Bees',
                             'Fig Shells',
                             'Witch hazels',
                             'Hog-nosed Snakes',
                             'Ilex oaks',
                             'Iris Mantises',
                             'needle-leaf junipers',
                             'Monkeyflowers','Annual or Dogday Cicadas',
                             'evening primroses, sundrops, and beeblossums',
                             'evening primroses, sundrops, and beeblossoms',
                             'Typical passionflowers',
                             'Eurasian, red, and tropical pines',
                             'hard pines',
                             'dominula-group Paper Wasps',
                             'Blackclocks',
                             'North American white oaks',
                             'high-latitude oaks',
                             'noseburn',
                             'Narrow-fronted Fiddler Crabs'),
         !(Prey_Kingdom == 'Animalia' & common_name == 'marram grasses'),
         !(Prey_Kingdom == 'Plantae' & common_name == 'Thread-waisted Sand Wasps')) %>%  
  mutate(rank = 'Prey_Genus') %>%
  rename(taxon = Prey_Genus) %>%
  arrange(taxon)

genusNames$common_name[genusNames$taxon == "Limnophila" & genusNames$Prey_Kingdom == "Plantae"] = "marshweed"
genusNames$Prey_Kingdom[genusNames$taxon == "Oenanthe" & genusNames$iconic_taxon_name == "Water-dropworts"] = "Plantae"
genusNames$Prey_Kingdom[genusNames$taxon == "Passerina" & genusNames$iconic_taxon_name == "Gonnas"] = "Plantae"

# Currently there are 4 homonymns where the genus name is present in both Animalia and Plantae:
#  Limnophila, Oenanthe, Passerina, and Ammophila


# Create entry for caterpillars to add to list:

caterpillars = data.frame(taxon = 'Lepidoptera', rank = 'Prey_Order', commonName = 'caterpillars', 
                          Prey_Kingdom = 'Animalia', Prey_Stage = 'larva')

commonNamesList = rbind(phylumNames, classNames, orderNames, suborderNames, familyNames, genusNames) %>%
  mutate(commonName = tolower(common_name), 
         Prey_Stage = NA) %>%
  select(taxon, rank, commonName, Prey_Kingdom, Prey_Stage) %>%
  rbind(caterpillars)

commonNamesList$Prey_Stage[commonNamesList$taxon == "Lepidoptera" & 
                             commonNamesList$commonName == "butterflies and moths"] = "adult"

write.csv(commonNamesList, 'preyCommonNames.csv', row.names = F)  

