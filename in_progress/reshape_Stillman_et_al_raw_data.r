library(dplyr)
library(stringr)


otu_dat = read.csv('OTU_dataset.csv', header = F) %>%
  rename(OTU_ID = V1)


otu_tax = read.csv('OTU_taxonomy.csv', header = T) %>%
  mutate_all(function(x) str_replace(x, "N/A","NA")) %>%
  mutate(Prey_Kingdom = str_replace(kingdom, "k:", ""),
         Prey_Phylum = str_replace(phylum, "p:", ""),
         Prey_Class = str_replace(class, "c:", ""),
         Prey_Order = str_replace(order, "o:", ""),
         Prey_Suborder = NA,
         Prey_Family = str_replace(family, "f:", ""),
         Prey_Genus = str_replace(genus, "g:", ""),
         Prey_Scientific_Name = str_replace(species, "s:", "")) %>%
  select(OTU_ID, Prey_Kingdom, Prey_Phylum, Prey_Class, Prey_Order, Prey_Suborder, 
         Prey_Family, Prey_Genus, Prey_Scientific_Name)
  
otu_join = left_join(otu_dat, otu_tax, by = 'OTU_ID') %>%
  select(Prey_Kingdom:Prey_Scientific_Name, V2:V75)

write.csv(otu_join, 'Stillman_et_al_2022_raw_woodpecker_data.csv', row.names = F)
