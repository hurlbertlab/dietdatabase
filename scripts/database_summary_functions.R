# Data summaries of the Avian Diet Database

library(dplyr)
library(stringr)
library(tidyr)


#################

dbSummary = function(diet = NULL) {
  # Silence dplyr summarize warning
  options(dplyr.summarise.inform = FALSE)
  
  if (is.null(diet)) {
    diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = "\"",
                      fill=T, stringsAsFactors = F)
  }
  speciesList = read.csv('birdtaxonomy/NA_specieslist.csv', header = T, quote = '\"')
  
  dbSpecies = unique(diet[, c('Common_Name', 'Family')])
  dbSpecies$db = 1
  numSpecies = nrow(dbSpecies)
  numStudies = length(unique(diet$Source))
  numRecords = nrow(diet)
  
  analysesPerSpecies = diet %>%
    group_by(Common_Name) %>%
    summarize(analyses = n_distinct(Longitude_dd,
                                    Latitude_dd, Altitude_min_m, Altitude_mean_m, Altitude_max_m,
                                    Location_Region, Location_Specific, Habitat_type,
                                    Observation_Month_Begin, Observation_Year_Begin,
                                    Observation_Month_End, Observation_Year_End, Observation_Season,
                                    Analysis_Number, Source))
  
  recordsPerSpecies = count(diet, Common_Name) %>% 
    as_tibble() %>%
    left_join(analysesPerSpecies, by = 'Common_Name') %>%
    rename(records = n)
  
  
  familyCoverage = left_join(speciesList, dbSpecies, by = c('common_name' = 'Common_Name', 'family' = 'Family')) %>%
    group_by(order, family) %>%
    summarize(SpeciesWithData = sum(db, na.rm = TRUE),
              SpeciesWithoutData = sum(is.na(db)),
              PercentComplete = round(100*SpeciesWithData/(SpeciesWithData + SpeciesWithoutData))) %>%
    rename(Order = order, Family = family)
  
  return(list(numRecords=numRecords,
              numSpecies=numSpecies, 
              numStudies=numStudies, 
              recordsPerSpecies=recordsPerSpecies,
              speciesPerFamily = familyCoverage))
}




  


# Re classify diet database to a different taxonomic level (of prey).
# Only returns results for Diet_Type 'Items', 'Wt_or_Vol', or 'Unspecified' since
# 'Occurrence' cannot be summed hierarchically.

reclassifyPrey = function(diet = NULL, by = 'Order') {
  if (is.null(diet)) {
    diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                      fill=T, stringsAsFactors = F)    
  }
  
  if (by == 'Species') { by = 'Scientific_Name' }
  
  if (!by %in% c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
                 'Family', 'Genus', 'Scientific_Name')) {
    warning("Please specify one of the following taxonomic levels to aggregate prey data:\n   Kingdom, Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }
  
  dietsp = filter(diet, Diet_Type != 'Occurrence')
  
  if (nrow(dietsp) == 0) {
    warning("No available records with a DietType of 'Items', 'Wt_or_Vol', or 'Unspecified' to reclassify.")
    return(NULL)
  }
  
  taxonLevel = paste('Prey_', by, sep = '')
  
  # If prey not identified down to taxon level specified, replace "" with
  # "Unidentified XXX" where XXX is the lowest level specified (e.g. Unidentified Animalia)
  dietprey = dietsp[, c('Prey_Kingdom', 'Prey_Phylum', 'Prey_Class',
                        'Prey_Order', 'Prey_Suborder', 'Prey_Family',
                        'Prey_Genus', 'Prey_Scientific_Name')]
  level = which(names(dietprey) == taxonLevel)
  dietsp[, taxonLevel] = apply(dietprey, 1, function(x)
    if(x[level] == "" | is.na(x[level])) { paste("Unid.", x[max(which(x != "")[which(x != "") < level], na.rm = T)])} 
    else { x[level] })
  
  # Prey_Stage should only matter for distinguishing things at the Order level and 
  # below (e.g. distinguishing between Lepidoptera larvae and adults).
  if (by %in% c('Order', 'Family', 'Genus', 'Scientific_Name')) {
    stage = dietsp$Prey_Stage
    stage[is.na(stage)] = ""
    stage[stage == 'adult'] = ""
    dietsp$Taxon = paste(dietsp[, taxonLevel], stage) %>% trimws("both")
  } else {
    dietsp$Taxon = dietsp[, taxonLevel]
  }

  TaxonLevelAbove = names(dietprey)[level - 1]
    
  # Summarizing by new taxonomic level
  reclassified = dietsp %>% 
    group_by(Common_Name, Scientific_Name, Subspecies, Family, Taxonomy, Longitude_dd, Latitude_dd,
             Altitude_min_m, Altitude_mean_m, Altitude_max_m, Location_Region, Location_Specific, 
             Habitat_type, Observation_Month_Begin, Observation_Year_Begin, Observation_Month_End,
             Observation_Year_End, Observation_Season, Prey_Kingdom, get(TaxonLevelAbove, envir = as.environment(dietsp)), 
             get(taxonLevel, envir = as.environment(dietsp)), Diet_Type, Item_Sample_Size, Bird_Sample_Size, 
             Sites, Study_Type, Source) %>%
    summarize(Frac_Diet = sum(Fraction_Diet, na.rm = T)) %>%
    select(Common_Name, Scientific_Name, Subspecies, Family, Taxonomy, Longitude_dd, Latitude_dd,
           Altitude_min_m, Altitude_mean_m, Altitude_max_m, Location_Region, Location_Specific, 
           Habitat_type, Observation_Month_Begin, Observation_Year_Begin, Observation_Month_End,
           Observation_Year_End, Observation_Season, Prey_Kingdom,  "get(TaxonLevelAbove, envir = as.environment(dietsp))", 
           "get(taxonLevel, envir = as.environment(dietsp))", Frac_Diet, Diet_Type, Item_Sample_Size, 
           Bird_Sample_Size, Sites, Study_Type, Source)
  names(reclassified)[names(reclassified) == "get(TaxonLevelAbove, envir = as.environment(dietsp))"] = TaxonLevelAbove
  names(reclassified)[names(reclassified) == "get(taxonLevel, envir = as.environment(dietsp))"] = taxonLevel
  
  reclassified = as.data.frame(reclassified)
  return(reclassified)
}




# For dates with no clear Observation_Year_End, replace
# Observation_Year_End with the publication year.
# (rapply is to exclude any years in the article title)

fill_study_years = function(diet) {
  fixed = diet %>% mutate(pubyear = str_match_all(Source, "[0-9][0-9][0-9][0-9]") %>%
                           rapply(function(x) head(x, 1)) %>% as.numeric()) %>%
    mutate(Observation_Year_End = ifelse(is.na(Observation_Year_End), pubyear, Observation_Year_End)) %>%
    select(Common_Name:Source)
return(fixed)  
}

