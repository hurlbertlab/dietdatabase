# Error checking Diet Database

library(dplyr)
library(tidyr)
library(taxize)
library(maps)


source('scripts/database_summary_functions.R')
source('cleaning/prey_name_cleaning.R')

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



# Bird name cleaning which must be named eBird_Taxonomy_v20XX.csv where xx is year
bird_name_clean = function(diet) {
  
  # Load most recent taxonomy file 
  filename = list.files('birdtaxonomy', pattern = 'eBird_Taxonomy_v20[0-9][0-9].csv')
  
  tax = read.table(paste('birdtaxonomy/', filename, sep = ''), header = T,
                   sep = ',', quote = '\"', stringsAsFactors = F)
  tax$Family = word(tax$FAMILY, 1)

  db_spp = select(diet, Common_Name, Scientific_Name, Family) %>% unique()
  
  # Find common names or scientific names that are unmatched with the eBird checklist
  unmatched = anti_join(db_spp, tax, by = c("Common_Name" = "PRIMARY_COM_NAME", 
                                             "Scientific_Name" = "SCI_NAME",
                                             "Family" = "Family"))
  return(unmatched)
}


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


qa_qc = function(diet, write = FALSE, filename = NULL, fracsum_accuracy = .03) {
  

  probbirdnames = bird_name_clean(diet)
  
  taxonomy = count(diet, Taxonomy) %>% 
    filter(!Taxonomy %in% c('eBird Clements Checklist v2016', 'eBird Clements Checklist v2017')) %>%
    data.frame()
  if (nrow(taxonomy) == 0) {
    taxonomy = "OK"
  }
  
  
  # Error checking -- numeric fields
  outliers = outlierCheck(diet)

  # Error checking -- text fields
  season = count(diet, Observation_Season) %>% 
    filter(!tolower(Observation_Season) %in% c('multiple', 'summer', 'spring', 'fall', 'winter', NA)) %>%
    arrange(desc(n)) %>%
    data.frame()
  if (nrow(season) == 0) {
    season = "OK"
  } 

  
  if (sum(is.na(diet$Habitat_type)) == nrow(diet)) {
    habitat = "only NAs"
  } else {
    habitat = strsplit(diet$Habitat_type, ";") %>%
      unlist() %>%
      trimws() %>%
      table() %>%
      data.frame() %>%
      filter(!tolower(.) %in% c('agriculture', 'coniferous forest', 'deciduous forest', 'desert',
                                'forest', 'grassland', 'mangrove forest', 'multiple', 'shrubland', 
                                'urban', 'wetland', 'woodland'))
    if (nrow(habitat) == 0) {
      habitat = "OK"
    } else {
      names(habitat) = c('Habitat_type', 'n')
    }
  }
  

  if (sum(is.na(diet$Prey_Stage)) == nrow(diet)) {
    habitat = "only NAs"
  } else {
    stage = strsplit(diet$Prey_Stage, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    filter(!tolower(.) %in% c('adult', 'egg', 'juvenile', 'larva', 'nymph', 'pupa', 'teneral'))
    if (nrow(stage) == 0) {
      stage = "OK"
    } else {
      names(stage) = c('Prey_Stage', 'n')
    }
  }
  
  if (sum(is.na(diet$Prey_Part)) == nrow(diet)) {
    habitat = "only NAs"
  } else {
    part = strsplit(diet$Prey_Part, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    filter(!tolower(.) %in% c('bark', 'bud', 'dung', 'egg', 'feces', 'flower', 'fruit',
                              'gall', 'oogonium', 'pollen', 'root', 'sap', 'seed',
                              'spore', 'statoblasts', 'vegetation'))
    if (nrow(part) == 0) {
      part = "OK"
    } else {
      names(part) = c('Prey_Part', 'n')
    }
  }
  
  
  diettype = count(diet, Diet_Type) %>% 
    filter(!Diet_Type %in% c('Wt_or_Vol', 'Items', 'Occurrence', 'Unspecified')) %>%
    arrange(desc(n)) %>%
    data.frame()
  if (nrow(diettype) == 0) {
    diettype = "OK"
  }
    

  if (sum(is.na(diet$Study_Type)) == nrow(diet)) {
    habitat = "only NAs"
  } else {
    studytype = strsplit(diet$Study_Type, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    filter(!tolower(.) %in% c('behavioral observation', 'crop contents', 'emetic',
                              'esophagus contents', 'fecal contents', 'nest debris', 
                              'pellet contents', 'prey remains', 'stomach contents'))
    if (nrow(studytype) == 0) {
      studytype = "OK"
    } else {
      names(studytype) = c('Study_Type', 'n')
    }
  }
    
  
  countries = map('world', plot = F)$names %>%
    strsplit(":") %>% 
    lapply(`[[`, 1) %>%
    unlist() %>%
    unique()

  if (sum(is.na(diet$Location_Region)) == nrow(diet)) {
    habitat = "only NAs"
  } else {
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
      region = "OK"
    } else {
      names(region) = c('Location_Region', 'n')
    }
  }
  
  
  locations = count(diet, Location_Specific) %>% arrange(desc(n)) %>% data.frame()
  
  
  fraction_sum_check = checksum(diet, accuracy = fracsum_accuracy)
  
  output = list(Problem_bird_names = probbirdnames,
                Taxonomy = taxonomy, 
                Longitude_dd = outliers$long,
                Latitude_dd = outliers$lat,
                Altitude_min_m = outliers$alt_min,
                Altitude_mean_m = outliers$alt_mean,
                Altitude_max_m = outliers$alt_max,
                Location_Region = region, 
                Location_Specific = locations, 
                Observation_Season = season, 
                Habitat_type = habitat, 
                Observation_Month_Begin = outliers$mon_beg,
                Observation_Year_Begin = outliers$year_beg,
                Observation_Month_End = outliers$mon_end,
                Observation_Year_End = outliers$year_end,
                Prey_Stage = stage, 
                Prey_Part = part, 
                Fraction_Diet = outliers$frac_diet,
                Diet_Type = diettype,
                Item_Sample_Size = outliers$item_sampsize,
                Bird_Sample_Size = outliers$bird_sampsize,
                Sites = outliers$sites,
                Study_Type = studytype, 
                Fraction_sum_check = fraction_sum_check)
  
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


  
