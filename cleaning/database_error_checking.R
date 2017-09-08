# Error checking Diet Database

library(dplyr)
library(tidyr)
library(taxize)
library(maps)


source('scripts/database_summary_functions.R')
source('cleaning/prey_name_cleaning.R')


# Checking that diet values sum to 1 for non-occurrence data
# (for each analysis, which is the unique combination of Source, Common_Name, Year, Month, etc.)

# 'accuracy' is the allowed deviation from 1.00 for the sum of Fraction_Diet
checksum = function(diet, accuracy = 0.05) {
  
  sum_not_one = diet %>% 
    
    filter(Diet_Type != "Occurrence") %>%
    
    group_by(Source, Common_Name, Observation_Year_Begin, Observation_Month_Begin, Observation_Season, 
             Bird_Sample_Size, Habitat_type, Location_Region, Item_Sample_Size, Diet_Type) %>%
    
    summarize(Sum_Diet = sum(Fraction_Diet, na.rm = T)) %>%
    
    filter(Sum_Diet < (1 - accuracy) | Sum_Diet > (1 + accuracy)) %>%
    
    data.frame()
  
  if (nrow(sum_not_one) < 0) {
    sum_not_one = paste("For all analyses examined, diet sum is between ", 100*(1-accuracy), 
                        "-", 100(1+accuracy), "%", sep = "")
  }
  
  return(sum_not_one)
  
}


qa_qc = function(diet, write = FALSE, filename = NULL, fracsum_accuracy = .05) {
  
  # Error checking -- numeric fields
  outliers = outlierCheck(diet)

  # Error checking -- text fields
  season = count(diet, Observation_Season) %>% 
    filter(!tolower(Observation_Season) %in% c('multiple', 'summer', 'spring', 'fall', 'winter', NA)) %>%
    arrange(desc(n)) %>%
    data.frame()
  if (nrow(season) == 0) {
    season = "Observation_Season field OK"
  }

      
  habitat = strsplit(diet$Habitat_type, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    filter(!tolower(.) %in% c('agriculture', 'coniferous forest', 'deciduous forest', 'desert',
                              'forest', 'grassland', 'mangrove forest', 'multiple', 'shrubland', 
                              'urban', 'wetland', 'woodland'))
  if (nrow(habitat) == 0) {
    habitat = "Habitat_type field OK"
  } else {
    names(habitat)[1] = 'Habitat_type'
  }
  

  stage = strsplit(diet$Prey_Stage, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    filter(!tolower(.) %in% c('adult', 'egg', 'juvenile', 'larva', 'nymph', 'pupa', 'teneral'))
  if (nrow(stage) == 0) {
    stage = "Prey_Stage field OK"
  } else {
    names(stage)[1] = 'Prey_Stage'
  }
  
  
  part = strsplit(diet$Prey_Part, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    filter(!tolower(.) %in% c('bark', 'bud', 'dung', 'egg', 'feces', 'flower', 'fruit',
                              'gall', 'oogonium', 'pollen', 'root', 'sap', 'seed',
                              'spore', 'statoblasts', 'vegetation'))
  if (nrow(part) == 0) {
    part = "Prey_Part field OK"
  } else {
    names(part)[1] = 'Prey_Part'
  }

  
  diettype = count(diet, Diet_Type) %>% 
    filter(!Diet_Type %in% c('Wt_or_Vol', 'Items', 'Occurrence', 'Unspecified')) %>%
    arrange(desc(n)) %>%
    data.frame()
  if (nrow(diettype) == 0) {
    diettype = "Diet_Type field OK"
  }
    

  studytype = strsplit(diet$Study_Type, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    filter(!tolower(.) %in% c('behavioral observation', 'crop contents', 'emetic',
                              'esophagus contents', 'fecal contents', 'nest debris', 
                              'pellet contents', 'prey remains', 'stomach contents'))
  if (nrow(studytype) == 0) {
    studytype = "Study_Type field OK"
  } else {
    names(studytype)[1] = 'Study_Type'
  }
  
  
  
  taxonomy = count(diet, Taxonomy) %>% 
    filter(!Taxonomy %in% c('eBird Clements Checklist v2016', 'eBird Clements Checklist v2017')) %>%
    data.frame()
  if (nrow(taxonomy) == 0) {
    taxonomy = "Taxonomy field OK"
  }
  

  countries = map('world', plot = F)$names %>%
    strsplit(":") %>% 
    lapply(`[[`, 1) %>%
    unlist() %>%
    unique()

  region = strsplit(diet$Location_Region, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    arrange(desc(Freq)) %>%
    filter(!. %in% c(state.name, countries, 'North America', 'United States', 
                     'New England', 'Western United States', 'Southeastern United States',
                     'Eastern United States', 'Northeastern United States',
                     'Southwestern United States', 'Western North America', 
                     'Central North America', 'Eastern North America', 'United Kingdom',
                     'Alberta', 'British Columbia', 'Manitoba', 'New Brunswick', 'Nova Scotia', 
                     'Northwest Territories', 'Ontario', 'Quebec', 'Saskatchewan',
                     'Newfoundland', 'Nunavut', 'Chesapeake Bay', 'Lake Ontario', 'Lake Erie',
                     'Lake Michigan', 'Great Plains', 'New South Wales', 'Queensland', 'Victoria',
                     'Northern Territory', 'Fennoscandia', 'Siberia', 'Svalbard', 
                     'Sonora', 'Jalisco', 'Sinaloa', 'Lesser Antilles'))
  if (nrow(region) == 0) {
    region = "Location_Region field OK"
  } else {
    names(region)[1] = 'Location_Region'
  }
  
  
  location = count(diet, Location_Specific) %>% arrange(desc(n)) %>% data.frame()
  
  
  fraction_sum_check = checksum(diet, accuracy = fracsum_accuracy)
  
  output = list(outliers = outliers, 
                season = season, 
                habitat = habitat, 
                taxonomy = taxonomy, 
                stage = stage, 
                part = part, 
                diettype = diettype,
                studytype = studytype, 
                region = region, 
                location = location, 
                fraction_sum_check = fraction_sum_check)
  
  return(output)
}


# Taxonomic name cleaning (designed espec)
clean_all_names = function(diet, ...) {
  
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

  return(output)
}


  
