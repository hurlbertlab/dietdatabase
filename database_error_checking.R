# Error checking Diet Database

library(dplyr)
library(tidyr)
library(taxize)

diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                    fill=T, stringsAsFactors = F)

# Taxonomy name checks done through GlOBI
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
    
    diet_wt = outlier(diet$Fraction_Diet_By_Wt_or_Vol, 0, 1),
    
    diet_items = outlier(diet$Fraction_Diet_By_Items, 0, 1),
    
    diet_occ = outlier(diet$Fraction_Occurrence, 0, 1),
    
    diet_unk = outlier(diet$Fraction_Diet_Unspecified, 0, 1),
    
    item_sampsize = outlier(diet$Item_Sample_Size, 0, 10000),
    
    bird_sampsize = outlier(diet$Bird_Sample_Size, 0, 1000)
    
  )
    
  return(out)
}

# Checks for unusual values that might get replaced

season = count(diet, Observation_Season)

region = count(diet, Location_Region)

location = count(diet, Location_Specific)

habitat = count(diet, Habitat_type)


