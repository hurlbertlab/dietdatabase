# Error checking Diet Database

library(dplyr)
library(tidyr)
library(taxize)

# Error checking -- quantitative valeus
# Checks for outliers that should be double-checked and/or fixed
out = outlierCheck(diet)


# Error checking -- text fields
# Checks for the 
season = count(diet, Observation_Season) %>% arrange(desc(n)) %>% data.frame()

region = count(diet, Location_Region) %>% arrange(desc(n)) %>% data.frame()

location = count(diet, Location_Specific) %>% arrange(desc(n)) %>% data.frame()

habitat = count(diet, Habitat_type) %>% arrange(desc(n)) %>% data.frame()

taxonomy = count(diet, Taxonomy) %>% arrange(desc(n)) %>% data.frame()

stage = count(diet, Prey_Stage) %>% arrange(desc(n)) %>% data.frame()

part = count(diet, Prey_Part) %>% arrange(desc(n)) %>% data.frame()

diettype = count(diet, Diet_Type) %>% arrange(desc(n)) %>% data.frame()


# Finding a list of studies where habitat type is blank
diet %>% filter(Habitat_type=="") %>% select(Source) %>% unique()