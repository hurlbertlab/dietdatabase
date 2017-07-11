# Data summaries of the Avian Diet Database

library(dplyr)
library(stringr)
library(tidyr)

#################

dbSummary = function() {
  diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                    fill=T, stringsAsFactors = F)
  refs = read.table('NA_avian_diet_refs.txt', header=T, sep = '\t', quote = '\"',
                    fill=T, stringsAsFactors = F)
  orders = read.csv('birdtaxonomy/orders.csv', header = T, stringsAsFactors = F)
  species = unique(diet[, c('Common_Name', 'Family')])
  allspecies = unique(refs[, c('common_name', 'family')])
  numSpecies = nrow(species)
  numStudies = length(unique(diet$Source))
  numRecords = nrow(diet)
  recordsPerSpecies = data.frame(count(diet, Common_Name))
  spCountByFamily = data.frame(table(species$Family))
  noDataSpecies = subset(allspecies, !common_name %in% species$Common_Name)
  noDataSpCountByFamily = data.frame(table(noDataSpecies$family))
  spCountByFamily2 = merge(spCountByFamily, noDataSpCountByFamily, by = "Var1", all = T)
  names(spCountByFamily2) = c('Family', 'SpeciesWithData', 'WithoutData')
  spCountByFamily2$Family = as.character(spCountByFamily2$Family)
  spCountByFamily2$WithoutData[is.na(spCountByFamily2$WithoutData)] = 0
  spCountByFamily2 = spCountByFamily2[spCountByFamily2$Family != "", ]
  spCountByFamily3 = spCountByFamily2 %>% 
    inner_join(orders, by = 'Family') %>%
    select(Order, Family, SpeciesWithData, WithoutData) %>%
    arrange(Order)
  spCountByFamily3$SpeciesWithData[is.na(spCountByFamily3$SpeciesWithData)] = 0
  return(list(numRecords=numRecords,
              numSpecies=numSpecies, 
              numStudies=numStudies, 
              recordsPerSpecies=recordsPerSpecies,
              speciesPerFamily = spCountByFamily3))
}


# For a particular bird species, summarize diet database info at a specified taxonomic level

# Argument "by" may specify the prey's 'Kingdom', 'Phylum', 'Class', 'Order', 'Family',
#   'Genus', or 'Scientific_Name' ('Species' will not work)
speciesSummary = function(commonName, by = 'Order') {
  diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                    fill=T, stringsAsFactors = F)
  
  if (!commonName %in% diet$Common_Name) {
    warning("No species with that name in the Diet Database.")
    return(NULL)
  }
  if (!by %in% c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
                 'Family', 'Genus', 'Scientific_Name')) {
    warning("Please specify one of the following taxonomic levels to aggregate prey data:\n   Kingdom, Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }
  
  dietsp = subset(diet, Common_Name == commonName)
  numStudies = length(unique(dietsp$Source))
  Studies = unique(dietsp$Source)
  numRecords = nrow(dietsp)
  recordsPerYear = data.frame(count(dietsp, Observation_Year_End))
  recordsPerRegion = data.frame(count(dietsp, Location_Region))
  recordsPerType = data.frame(count(dietsp, Diet_Type))
  
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
  
  preySummary = rbind(preySummary_nonOccurrence, preySummary_Occurrence)
  
    return(list(numStudies = numStudies,
              Studies = Studies,
              numRecords = numRecords,
              recordsPerYear = recordsPerYear,
              recordsPerRegion = recordsPerRegion,
              recordsPerPreyIDLevel = recordsPerPreyIDLevel,
              recordsPerType = recordsPerType,
              analysesPerDietType = data.frame(analysesPerDietType),
              preySummary = data.frame(preySummary)))
}


# Error checking
# --function returns row numbers of any records outside specified range
# --or if no outliers present, then "OK"
outlier = function(field, min, max) {
  if (class(field) != "numeric") {
    field = suppressWarnings(as.numeric(field))
  }
  out = which(!is.na(field) & (field < min | field > max))
  if (length(out) == 0) { out = 'OK'}
  return(out)
}


outlierCheck = function(diet) {
  out = list(
    long = outlier(diet$Longitude_dd, -180, 180),
    
    lat = outlier(diet$Latitude_dd, -180, 180),
    
    alt_min = outlier(diet$Altitude_min_m, -100, 10000),
    
    alt_mean = outlier(diet$Altitude_mean_m, -100, 10000),
    
    alt_max = outlier(diet$Altitude_max_m, -100, 10000),
    
    mon_beg = outlier(diet$Observation_Month_Begin, 0, 12),
    
    mon_end = outlier(diet$Observation_Month_End, 0, 12),
    
    year_beg = outlier(diet$Observation_Year_Begin, 1800, 2017),
    
    year_end = outlier(diet$Observation_Year_End, 0, 2017),
    
    frac_diet = outlier(diet$Fraction_Diet, 0, 1),
    
    item_sampsize = outlier(diet$Item_Sample_Size, 0, 27000), # max recorded is 26958
    
    bird_sampsize = outlier(diet$Bird_Sample_Size, 0, 1300),
    
    sites = outlier(diet$Sites, 0, 100)
    
  )
  
  return(out)
}

# Function for capitalizing the first letter of each word (e.g. common names)
simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
}

# Function to remove unintended leading or trailing spaces from text fields

LeadingAndTrailingSpaceRemover = function(dietdatabase) {
  characterFields = which(sapply(dietdatabase, class) == "character")
  
  for (i in characterFields) {
    for (j in 1:nrow(dietdatabase)) {
      val = dietdatabase[j, i]
      #leading and trailing spaces
      if (substring(val, 1, 1) == " " & substring(val, nchar(val), nchar(val)) == " ") {
        dietdatabase[j, i] = substring(val, 2, nchar(val) - 1)
      #leading spaces
      } else if (substring(val, 1, 1) == " ") {
        dietdatabase[j, i] = substring(val, 2, nchar(val))
      #trailing spaces
      } else if (substring(val, nchar(val), nchar(val)) == " ") {
        dietdatabase[j, i] = substring(val, 1, nchar(val) - 1)
      }
    }
  }
  return(dietdatabase)
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

