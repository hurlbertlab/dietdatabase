# Error checking Diet Database

library(dplyr)
library(tidyr)
library(taxize)

source('scripts/database_summary_functions.R')


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


# Taxonomic name cleaning
