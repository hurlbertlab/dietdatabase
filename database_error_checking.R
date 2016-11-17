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


check = function(diet) {
  long = outlier(diet$Longitude_dd, -180, 180)
  
  lat = outlier(diet$Latitude_dd, -180, 180)
  
  alt_min = outlier(diet$Altitude_min_m, -100, 10000)
  
  alt_mean = outlier(diet$Altitude_mean_m, -100, 10000)
  
  alt_max = outlier(diet$Altitude_max_m, -100, 10000)
  
  region = count(diet, Location_Region) 
  
  location = count(diet, Location_Specific)
  
  habitat = count(diet, Habitat_type)
  
  mon_beg = outlier(diet$Observation_Month_Begin, 0, 12)
  
  mon_end = outlier(diet$Observation_Month_End, 0, 12)
  
  year_beg = outlier(diet$Observation_Year_Begin, 1800, 2017)
  
  year_end = outlier(diet$Observation_Year_End, 0, 2017)
}