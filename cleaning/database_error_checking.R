# Error checking Diet Database

library(dplyr)
library(tidyr)
library(taxize)

source('scripts/database_summary_functions.R')
source('cleaning/prey_name_cleaning.R')


qa_qc = function(diet, write = FALSE, filename = NULL) {
  
  # Error checking -- numeric fields
  outliers = outlierCheck(diet)

  # Error checking -- text fields
  season = count(diet, Observation_Season) %>% arrange(desc(n)) %>% data.frame()
  
  region = count(diet, Location_Region) %>% arrange(desc(n)) %>% data.frame()
  
  location = count(diet, Location_Specific) %>% arrange(desc(n)) %>% data.frame()
  
  habitat = count(diet, Habitat_type) %>% arrange(desc(n)) %>% data.frame()
  
  taxonomy = count(diet, Taxonomy) %>% arrange(desc(n)) %>% data.frame()
  
  stage = count(diet, Prey_Stage) %>% arrange(desc(n)) %>% data.frame()
  
  part = count(diet, Prey_Part) %>% arrange(desc(n)) %>% data.frame()
  
  diettype = count(diet, Diet_Type) %>% arrange(desc(n)) %>% data.frame()
  
  output = list(outliers, season, region, location, habitat, 
                taxonomy, stage, part, diettype)
  
  return(output)
}


# Taxonomic name cleaning (designed espec)
clean_all_names = function(filename, write = TRUE) {
  
  diet = read.txt(filename, header= T, sep = '\t', quote = '\"')
  
  clean_spp = clean_names('Scientific_Name', diet, all = TRUE)
  
  clean_gen = clean_names('Genus', clean_spp$diet, all = TRUE, problemNames = clean_spp$badnames)

  clean_fam = clean_names('Family', clean_gen$diet, all = TRUE, problemNames = clean_gen$badnames)
  
  clean_subo = clean_names('Suborder', clean_fam$diet, all = TRUE, problemnames = clean_fam$badnames)
  
  clean_ord = clean_names('Order', clean_subo$diet, all = TRUE, problemNames = clean_subo$badnames)
  
  clean_cla = clean_names('Class', clean_ord$diet, all = TRUE, problemNames = clean_ord$badnames)
  
  clean_phy = clean_names('Phylum', clean_cla$diet, all = TRUE, problemNames = clean_cla$badnames)
  
  kings = unique(diet$Prey_Kingdom)
  
  badkings = kings[!kings %in% c('Animalia', 'Plantae', 'Chromista', 'Fungi', 'Bacteria')]
  
  probnames = rbind(clean_phy$badnames, data.frame(level = 'Kingdom',
                                                   name = badkings,
                                                   condition = 'unaccepted name'))
  output = list(cleandb = clean_phy$diet,
                probnames = badnames)  
  
  if (write) {
    filenameparts = unlist(strsplit(filename, '[.]'))
    write.table(clean_phy$diet, paste(filenameparts[1], '_clean.txt', sep = ''), row.names = F)
  }

  return(output)
}
