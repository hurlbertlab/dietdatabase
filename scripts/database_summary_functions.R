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
  recordsPerSpecies = count(diet, Common_Name) %>% as_tibble()
  
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


# For a particular bird species, summarize diet database info at a specified taxonomic level

# Argument "by" may specify the prey's 'Kingdom', 'Phylum', 'Class', 'Order', 'Family',
#   'Genus', or 'Species')
speciesSummary = function(commonName, by = 'Order') {
  diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                    fill=T, stringsAsFactors = F)
  
  if (!tolower(commonName) %in% tolower(diet$Common_Name)) {
    warning("No species with that name in the Diet Database.")
    return(NULL)
  }
  
  if (by == 'Species') { by = 'Scientific_Name' }
  
  if (!by %in% c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
                 'Family', 'Genus', 'Scientific_Name')) {
    warning("Please specify one of the following taxonomic levels to aggregate prey data:\n   Kingdom, Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }
  
  dietsp = subset(diet, tolower(Common_Name) == tolower(commonName))
  numStudies = length(unique(dietsp$Source))
  Studies = unique(dietsp$Source)
  numRecords = nrow(dietsp)
  recordsPerYearRegion = data.frame(count(dietsp, Observation_Year_End, Location_Region)) %>%
    rename(Year = Observation_Year_End) %>%
    spread(Year, value = n)
  recordsPerType = data.frame(count(dietsp, Diet_Type))
  recordsPerSeason = data.frame(count(dietsp, Observation_Season))
  
  # Report the number of records for which prey are identified to the different 
  # taxonomic levels, which will be important for interpreting summary occurrence data
  king_n = nrow(dietsp[!is.na(dietsp$Prey_Kingdom) & dietsp$Prey_Kingdom != "" &
                         !(!is.na(dietsp$Prey_Phylum) & dietsp$Prey_Phylum != "") &
                         !(!is.na(dietsp$Prey_Class) & dietsp$Prey_Class != "") &
                         !(!is.na(dietsp$Prey_Order) & dietsp$Prey_Order != "") &
                         !(!is.na(dietsp$Prey_Suborder) & dietsp$Prey_Suborder != "") &
                         !(!is.na(dietsp$Prey_Family) & dietsp$Prey_Family != "") &
                         !(!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "") &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  phyl_n = nrow(dietsp[!is.na(dietsp$Prey_Phylum) & dietsp$Prey_Phylum != "" &
                         !(!is.na(dietsp$Prey_Class) & dietsp$Prey_Class != "") &
                         !(!is.na(dietsp$Prey_Order) & dietsp$Prey_Order != "") &
                         !(!is.na(dietsp$Prey_Suborder) & dietsp$Prey_Suborder != "") &
                         !(!is.na(dietsp$Prey_Family) & dietsp$Prey_Family != "") &
                         !(!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "") &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  clas_n = nrow(dietsp[!is.na(dietsp$Prey_Class) & dietsp$Prey_Class != "" &
                         !(!is.na(dietsp$Prey_Order) & dietsp$Prey_Order != "") &
                         !(!is.na(dietsp$Prey_Suborder) & dietsp$Prey_Suborder != "") &
                         !(!is.na(dietsp$Prey_Family) & dietsp$Prey_Family != "") &
                         !(!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "") &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  orde_n = nrow(dietsp[!is.na(dietsp$Prey_Order) & dietsp$Prey_Order != "" &
                         !(!is.na(dietsp$Prey_Suborder) & dietsp$Prey_Suborder != "") &
                         !(!is.na(dietsp$Prey_Family) & dietsp$Prey_Family != "") &
                         !(!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "") &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  fami_n = nrow(dietsp[!is.na(dietsp$Prey_Family) & dietsp$Prey_Family != "" &
                         !(!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "") &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  genu_n = nrow(dietsp[!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "" &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  spec_n = nrow(dietsp[!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != "", ])
  
  recordsPerPreyIDLevel = data.frame(level = c('Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus', 'Species'),
                                     n = c(king_n, phyl_n, clas_n, orde_n, fami_n, genu_n, spec_n))
  
  
  
  
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
  
  analysesPerDietType = dietsp %>%
    select(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season, 
           Bird_Sample_Size, Habitat_type, Location_Region, Location_Specific, Item_Sample_Size, Diet_Type, Study_Type) %>%
    distinct() %>%
    count(Diet_Type)
  
  # Equal-weighted mean fraction of diet (all studies weighted equally despite
  #  variation in sample size)
  preySummary_nonOccurrence = dietsp %>% filter(Diet_Type != "Occurrence") %>%

    group_by(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season, 
             Bird_Sample_Size, Habitat_type, Location_Region, Item_Sample_Size, Taxon, Diet_Type) %>%
    
    summarize(Sum_Diet = sum(Fraction_Diet, na.rm = T)) %>%
    group_by(Diet_Type, Taxon) %>%
    summarize(Sum_Diet2 = sum(Sum_Diet, na.rm = T)) %>%
    left_join(analysesPerDietType, by = c('Diet_Type' = 'Diet_Type')) %>%
    mutate(Frac_Diet = round(Sum_Diet2/n, 4)) %>%
    select(Diet_Type, Taxon, Frac_Diet) %>%
    arrange(Diet_Type, desc(Frac_Diet))
  
  # Fraction Occurrence values don't sum to 1, so all we can do is say that at
  # a given taxonomic level, at least X% of samples included that prey type
  # based on the maximum % occurrence of prey within that taxonomic group.
  # We then average occurrence values across studies/analyses.
  preySummary_Occurrence = dietsp %>% filter(Diet_Type == "Occurrence") %>%
    
    group_by(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season, 
             Bird_Sample_Size, Habitat_type, Location_Region, Item_Sample_Size, Taxon, Diet_Type) %>%
    
    summarize(Max_Diet = max(Fraction_Diet, na.rm = T)) %>%
    group_by(Diet_Type, Taxon) %>%
    summarize(Sum_Diet2 = sum(Max_Diet, na.rm = T)) %>%
    left_join(analysesPerDietType, by = c('Diet_Type' = 'Diet_Type')) %>%
    mutate(Frac_Diet = round(Sum_Diet2/n, 4)) %>%
    select(Diet_Type, Taxon, Frac_Diet) %>%
    arrange(Diet_Type, desc(Frac_Diet))
  
  preySummary = rbind(preySummary_nonOccurrence, preySummary_Occurrence) %>%
    spread(Diet_Type, value = Frac_Diet)
  
  # Get Frac_Diet output columns in standardized order
  allCols = data.frame(col = c('Items', 'Wt_or_Vol', 'Unspecified', 'Occurrence'), order = 1:4)
  allCols$col = as.character(allCols$col)
  
  cols = data.frame(col = names(preySummary)[2:ncol(preySummary)])
  cols$col = as.character(cols$col)
  
  colOrdered = cols %>%
    left_join(allCols, by = 'col') %>%
    arrange(order) %>%
    select(col)
  
  preySummary2 = preySummary[, c('Taxon', colOrdered[,1])]
  preySummary2 = preySummary2[order(preySummary2[[2]], decreasing = TRUE), ]
  
  return(list(numStudies = numStudies,
              Studies = Studies,
              numRecords = numRecords,
              recordsPerSeason = recordsPerSeason,
              recordsPerYearRegion = recordsPerYearRegion,
              recordsPerPreyIDLevel = recordsPerPreyIDLevel,
              recordsPerType = recordsPerType,
              analysesPerDietType = data.frame(analysesPerDietType),
              preySummary = data.frame(preySummary2)))
}



# For a particular bird species, summarize diet database info at a specified taxonomic level,
# with option to specify Diet_Type, season, region, and year range

# Argument "by" may specify the prey's 'Kingdom', 'Phylum', 'Class', 'Order', 'Family',
#   'Genus', or 'Species')
dietSummary = function(commonName, 
                       by = 'Order', 
                       dietType = 'Items',
                       season = NULL,
                       region = NULL,
                       yearRange = c(1700, 2100)) {
  
  if (!exists("diet")) {
    diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                      fill=T, stringsAsFactors = F)    
  }

  
  # Checking for valid arguments
  
  if (!tolower(commonName) %in% tolower(diet$Common_Name)) {
    warning("No species with that name in the Diet Database.")
    return(NULL)
  }
  
  if (by == 'Species') { by = 'Scientific_Name' }
  
  if (!by %in% c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
                 'Family', 'Genus', 'Scientific_Name')) {
    warning("Please specify one of the following taxonomic levels to aggregate prey data:\n   Kingdom, Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }
  
  if (!dietType %in% c('Items', 'Wt_or_Vol', 'Unspecified', 'Occurrence')) {
    warning("dietType argument must be one of the following: 'Items', 'Wt_or_Vol', 'Unspecified', or 'Occurrence'.")
    return(NULL)
  }
  

  dietsub = filter(diet, tolower(Common_Name) == tolower(commonName),
                  Observation_Year_End >= min(yearRange),
                  Observation_Year_End <= max(yearRange))
  
  if (is.null(dietType)) {
    dietType = c('Items', 'Wt_or_Vol', 'Unspecified', 'Occurrence')
  }
  if (is.null(season)) {
    season = unique(dietsub$Observation_Season)
  } else {
    season = tolower(season)
    if (sum(sapply(season, function(x) x %in% c('spring', 'summer', 'fall', 'winter', 'any'))) != length(season)) {
      warning("season argument must be one or more of the following: 'spring', 'summer', 'fall', 'winter', or 'any'.")
      return(NULL)
    }
    if ('any' %in% season) {
      season = unique(dietsub$Observation_Season)
    }
  }
  if (is.null(region)) {
    region = unique(dietsub$Location_Region)
  }
  
  dietsp = filter(dietsub, Diet_Type %in% dietType, 
                  tolower(Observation_Season) %in% season, 
                  Location_Region %in% region)

  
  if (nrow(dietsp) == 0) {
    warning("No records for the specified combination of diet type, season, region, and years.")
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
  
  # Equal-weighted mean fraction of diet (all studies weighted equally despite
  #  variation in sample size)
  
  numAnalyses = dietsp %>%
    select(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season, 
           Bird_Sample_Size, Habitat_type, Location_Region, Location_Specific, Item_Sample_Size, Diet_Type, Study_Type) %>%
    distinct() %>%
    nrow()
  
  if (dietType == 'Occurrence') {
    # Fraction Occurrence values don't sum to 1, so all we can do is say that at
    # a given taxonomic level, at least X% of samples included that prey type
    # based on the maximum % occurrence of prey within that taxonomic group.
    # We then average occurrence values across studies/analyses.
    preySummary = dietsp %>% filter(Diet_Type == "Occurrence") %>%
      
      group_by(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season, 
               Bird_Sample_Size, Habitat_type, Location_Region, Item_Sample_Size, Taxon) %>%
      
      summarize(Max_Diet = max(Fraction_Diet, na.rm = T)) %>%
      group_by(Taxon) %>%
      summarize(Sum_Diet2 = sum(Max_Diet, na.rm = T)) %>%
      mutate(Frac_Diet = round(Sum_Diet2/numAnalyses, 4)) %>%
      select(Taxon, Frac_Diet) %>%
      arrange(desc(Frac_Diet)) %>%
      data.frame()
    
  } else {
    preySummary = dietsp %>% filter(Diet_Type == dietType) %>%
      
      group_by(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season, 
               Bird_Sample_Size, Habitat_type, Location_Region, Item_Sample_Size, Taxon) %>%
      
      summarize(Sum_Diet = sum(Fraction_Diet, na.rm = T)) %>%
      group_by(Taxon) %>%
      summarize(Sum_Diet2 = sum(Sum_Diet, na.rm = T)) %>%
      mutate(Frac_Diet = round(Sum_Diet2/numAnalyses, 4)) %>%
      select(Taxon, Frac_Diet) %>%
      arrange(desc(Frac_Diet)) %>%
      data.frame()
  }
  
  return(preySummary)
}





# For a particular prey item (and associated taxonomic level), summarize diet database info 
# based on avian predators, with option to specify Diet_Type, season, region, and year range

whatEatsThis = function(preyName,
                        preyLevel, 
                        larvaOnly = FALSE,
                        dietType = NULL,
                        season = NULL,
                        region = NULL,
                        yearRange = c(1700, 2100)) {
  
  if (!exists("diet")) {
    diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                      fill=T, stringsAsFactors = F)    
  }
  
  # Checking for valid arguments
  
  if (preyLevel == 'Species') { preyLevel = 'Scientific_Name' }
  
  if (!preyLevel %in% c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
                 'Family', 'Genus', 'Scientific_Name')) {
    warning("Please specify one of the following taxonomic levels for describing prey:\n   Kingdom, Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }
  
  taxonLevel = paste('Prey_', preyLevel, sep = '')
  
  if (!tolower(preyName) %in% tolower(diet[, taxonLevel])) {
    warning(paste("No prey taxa named", preyName, "at the level of", preyLevel, "were found in the Diet Database."))
    return(NULL)
  }
  
  if (is.null(dietType)) {
    dietType = c('Items', 'Wt_or_Vol', 'Unspecified', 'Occurrence')
  } else {
    if (!dietType %in% c('Items', 'Wt_or_Vol', 'Unspecified', 'Occurrence')) {
      warning("dietType argument must be one or more of the following: 'Items', 'Wt_or_Vol', 'Unspecified', or 'Occurrence'.")
      return(NULL)
    }
  }
  
  if (is.null(season)) {
    season = unique(diet$Observation_Season)
  } else {
    season = tolower(season)
    if (sum(sapply(season, function(x) x %in% c('spring', 'summer', 'fall', 'winter', 'any'))) != length(season)) {
      warning("season argument must be one or more of the following: 'spring', 'summer', 'fall', 'winter', or 'any'.")
      return(NULL)
    }
    if ('any' %in% season) {
      season = unique(diet$Observation_Season)
    }
  }
  
  if (is.null(region)) {
    region = unique(diet$Location_Region)
  }
  
    
  # Note this is strict, and will not include records which list 'larva' in addition to other stages
  # (e.g. ('pupa; larva' or 'adult; larva'))
  if (larvaOnly) {
    diet2 = filter(diet, Prey_Stage == 'larva')
  } else {
    diet2 = diet
  }
    
  dietsub = diet2 %>% 
    filter(get(taxonLevel) == preyName,
           Observation_Year_End >= min(yearRange),
           Observation_Year_End <= max(yearRange),
           Diet_Type %in% dietType, 
           tolower(Observation_Season) %in% season, 
           Location_Region %in% region) %>%
    arrange(Diet_Type, desc(Fraction_Diet)) %>%
    select(Common_Name, Family, Location_Region, Observation_Year_End, Observation_Season, Diet_Type, Fraction_Diet) %>%
    mutate(PreyName = preyName, PreyLevel = preyLevel, LarvaOnly = larvaOnly)
    
  if (nrow(dietsub) == 0) {
    warning("No records for the specified combination of prey, prey stage, diet type, season, region, and years.")
    return(NULL)
  }

  output = list(items = filter(dietsub, Diet_Type == 'Items'),
                wt_or_vol = filter(dietsub, Diet_Type == 'Wt_or_Vol'),
                occurrence = filter(dietsub, Diet_Type == 'Occurrence'),
                unspecified = filter(dietsub, Diet_Type == 'Unspecified'))
  
  return(output)
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

