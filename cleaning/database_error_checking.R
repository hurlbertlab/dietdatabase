# Error checking Diet Database

library(dplyr)
library(tidyr)
library(taxize)
library(maps)
library(stringr)

options(dplyr.summarise.inform = FALSE) #suppress dplyr warnings when using summarise()

source('scripts/database_summary_functions.R')

# Error checking
# --function returns row numbers of any records outside specified range
# --or if no outliers present, then "OK"
outlier = function(field, min, max) {
  if (sum(is.na(field)) == length(field))  {
    out = 'All values NA'
  } else if (!class(field) %in% c("numeric", "integer")) {
    out = 'Field has non-numeric or non-integer values'
  } else {
    probs = which(!is.na(field) & (field < min | field > max))
    if (length(probs) == 0) { 
      out = 'OK'
    } else {
      out = probs
    }
  }
  return(out)
}


outlierCheck = function(diet) {
  out = list(
    long = outlier(diet$Longitude_dd, -180, 0),
    
    lat = outlier(diet$Latitude_dd, -90, 90),
    
    alt_min = outlier(diet$Altitude_min_m, -100, 10000),
    
    alt_mean = outlier(diet$Altitude_mean_m, -100, 10000),
    
    alt_max = outlier(diet$Altitude_max_m, -100, 10000),
    
    mon_beg = outlier(diet$Observation_Month_Begin, 0, 12),
    
    mon_end = outlier(diet$Observation_Month_End, 0, 12),
    
    year_beg = outlier(diet$Observation_Year_Begin, 1870, 2017),
    
    year_end = outlier(diet$Observation_Year_End, 0, 2017),
    
    frac_diet = outlier(diet$Fraction_Diet, 0, 1),
    
    item_sampsize = outlier(diet$Item_Sample_Size, 0, 64000), # max recorded is 63767
    
    bird_sampsize = outlier(diet$Bird_Sample_Size, 0, 4900), # max recorded is 4848
    
    sites = outlier(diet$Sites, 0, 100)
    
  )
  
  return(out)
}

# Function for capitalizing the first letter of each word (e.g. common names)
simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
}




# Bird name cleaning which must be named eBird_Taxonomy_v20XX.csv where xx is year
bird_name_clean = function(diet) {
  
  # Load most recent taxonomy file 
  filenames = list.files('birdtaxonomy', pattern = 'eBird_Taxonomy_v20[0-9][0-9].csv') %>%
    sort(decreasing = TRUE)
  
  tax = read.table(paste('birdtaxonomy/', filenames[1], sep = ''), header = T,
                   sep = ',', quote = '\"', stringsAsFactors = F)
  tax$Family = word(tax$FAMILY, 1)

  db_spp = select(diet, Common_Name, Scientific_Name, Family) %>% unique()
  
  # Find common names or scientific names that are unmatched with the eBird checklist
  unmatched = anti_join(db_spp, tax, by = c("Common_Name" = "PRIMARY_COM_NAME", 
                                             "Scientific_Name" = "SCI_NAME",
                                             "Family" = "Family"))
  
  if (nrow(unmatched) == 0){
    unmatched = paste("All names matched the current eBird taxonomy (", filenames[1], ").", sep = '')
  }
  return(unmatched)
}


# Checking that diet values sum to 1 for non-occurrence data
# (for each analysis, which is the unique combination of Source, Common_Name, Year, Month, etc.)

# 'accuracy' is the allowed deviation from 1.00 for the sum of Fraction_Diet
checksum = function(diet, accuracy = 0.05) {
  
  sum_not_one = diet %>% 
    
    filter(Diet_Type != "Occurrence",
           !grepl("values as reported do not sum to 100%", Notes)) %>%
    
    group_by(Source, Common_Name, Subspecies, Observation_Year_Begin, Observation_Month_Begin, Observation_Year_End, 
             Observation_Month_End, Observation_Season, Analysis_Number, Bird_Sample_Size, Habitat_type, Location_Region, 
             Location_Specific, Item_Sample_Size, Diet_Type, Study_Type, Sites) %>%
    
    summarize(Sum_Diet = sum(Fraction_Diet, na.rm = T)) %>%
    
    filter(Sum_Diet < (1 - accuracy) | Sum_Diet > (1 + accuracy)) %>%
    
    data.frame()
  
  if (nrow(sum_not_one) < 0) {
    sum_not_one = paste("For all analyses examined, diet sum is between ", 100*(1-accuracy), 
                        "-", 100(1+accuracy), "%", sep = "")
  }
  
  return(sum_not_one)
  
}


# Modification of taxize::taxize_capwords() so that it does not fail on an empty string

taxize_capwords0 = function(s, strict = FALSE, onlyfirst = FALSE) {
  
  cap = sapply(s, function(x) {
    if (x == "" | is.na(x)) {
      ""
    } else {
      taxize_capwords(x, strict, onlyfirst)
    }
  })
  return(cap)
}



# Function for ensuring standardization of capital/lower case and trimming whitespace
standardizing_case_and_whitespace = function(diet, write = FALSE, filename = NULL) {

  if (write & is.null(filename)) {
    stop("Please specify a filename for the cleaned file.")
  }

  dietOut = diet
  dietOut$Common_Name = trimws(taxize_capwords0(diet$Common_Name))
  dietOut$Scientific_Name = taxize_capwords0(trimws(diet$Scientific_Name), onlyfirst = TRUE)
  dietOut$Subspecies = trimws(tolower(diet$Subspecies))
  dietOut$Family = trimws(taxize_capwords0(diet$Family))
  dietOut$Location_Region = trimws(taxize_capwords0(diet$Location_Region))
  dietOut$Location_Region = gsub(",", ";", dietOut$Location_Region)
  dietOut$Location_Region = gsub("; ", ";", dietOut$Location_Region)
  dietOut$Location_Specific = gsub("Multiple", "multiple", diet$Location_Specific)
  dietOut$Habitat_type = trimws(tolower(diet$Habitat_type))
  dietOut$Habitat_type = gsub(",", ";", dietOut$Habitat_type)
  dietOut$Habitat_type = gsub("; ", ";", dietOut$Habitat_type)
  dietOut$Observation_Season = trimws(tolower(diet$Observation_Season))
  dietOut$Observation_Season = gsub(",", ";", dietOut$Observation_Season)
  dietOut$Observation_Season = gsub("; ", ";", dietOut$Observation_Season)
  dietOut$Prey_Kingdom = trimws(taxize_capwords0(diet$Prey_Kingdom))
  dietOut$Prey_Phylum = trimws(taxize_capwords0(diet$Prey_Phylum))
  dietOut$Prey_Class = trimws(taxize_capwords0(diet$Prey_Class))
  dietOut$Prey_Order = trimws(taxize_capwords0(diet$Prey_Order))
  dietOut$Prey_Suborder = trimws(taxize_capwords0(diet$Prey_Suborder))
  dietOut$Prey_Family = trimws(taxize_capwords0(diet$Prey_Family))
  dietOut$Prey_Genus = trimws(taxize_capwords0(diet$Prey_Genus))
  dietOut$Prey_Scientific_Name = taxize_capwords0(trimws(diet$Prey_Scientific_Name), onlyfirst = TRUE)
  dietOut$Inclusive_Prey_Taxon = trimws(tolower(diet$Inclusive_Prey_Taxon))
  dietOut$Prey_Name_Status = trimws(tolower(diet$Prey_Name_Status))
  dietOut$Prey_Stage = trimws(tolower(diet$Prey_Stage))
  dietOut$Prey_Stage = gsub(",", ";", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("; ", ";", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("adult;pupa;larva", "larva;pupa;adult", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("adult;larva;pupa", "larva;pupa;adult", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("pupa;larva;adult", "larva;pupa;adult", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("pupa;adult;larva", "larva;pupa;adult", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("larva;adult;pupa", "larva;pupa;adult", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("adult;larva", "larva;adult", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("adult;pupa", "pupa;adult", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("adult;juvenile", "juvenile;adult", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("adult;nymph", "nymph;adult", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("adult;egg", "egg;adult", dietOut$Prey_Stage)
  dietOut$Prey_Stage = gsub("pupa;larva", "larva;pupa", dietOut$Prey_Stage)
  dietOut$Prey_Part = trimws(tolower(diet$Prey_Part))
  dietOut$Prey_Part = gsub(",", ";", dietOut$Prey_Part)
  dietOut$Prey_Part = gsub("; ", ";", dietOut$Prey_Part)
  dietOut$Diet_Type = trimws(taxize_capwords0(diet$Diet_Type))
  dietOut$Diet_Type = gsub("vol", "Vol", dietOut$Diet_Type)
  dietOut$Diet_Type = gsub("_Or_", "_or_", dietOut$Diet_Type)
  dietOut$Study_Type = trimws(tolower(diet$Study_Type))
  dietOut$Study_Type = gsub("dna", "DNA", dietOut$Study_Type)
  dietOut$Entered_By = trimws(toupper(diet$Entered_By))
  dietOut$Source = trimws(diet$Source)
  
  if (write) {
    write.table(dietOut, filename, sep = '\t', row.names = FALSE)
  }
  return(dietOut)
}




# Returns the first row number of every consecutive series of 4 more values
# (a run of at least 3 consecutive differences of 1)
# that increment by one (indicating an accidental Autofill in Excel, since
# the values in these fields should typically be constant within a given study)
checkAutofilledRows  = function(dbField) {
  if (!class(dbField) %in% c('integer', 'numeric')) {
    indices = NA
  } else {
    diff = dbField[2:length(dbField)] - dbField[1:(length(dbField) - 1)]
    runs = rle(diff)
    indices = cumsum(runs$lengths)[which(runs$values == 1 & runs$lengths >= 3)] - 
      (runs$lengths[which(runs$values == 1 & runs$lengths >= 3)] - 1)
    
    if (length(indices) == 0) indices = NA
  }
  return(indices)
}


qa_qc = function(dietdb, write = TRUE, filename = NULL, fracsum_accuracy = .03) {
  
  if (write & is.null(filename)) {
    stop("Please specify a filename for the cleaned file.")
  }
  
  diet = standardizing_case_and_whitespace(dietdb, write, filename)

  problemFields = c()
  
  probbirdnames = bird_name_clean(diet)
  
  if (class(probbirdnames) == 'data.frame') {
    probbirdtext = "some of the bird names as well as in"
  } else {
    probbirdtext = ""
  }
  
  
  taxonomy = count(diet, Taxonomy) %>% 
    filter(!Taxonomy %in% c('eBird Clements Checklist v2018', 'eBird Clements Checklist v2019')) %>%
    data.frame()
  if (nrow(taxonomy) == 0) {
    taxonomy = "OK"
  } else {
    problemFields = c(problemFields, "Taxonomy")
  }
  
  
  # Error checking -- numeric fields
  outliers = outlierCheck(diet)

  # Error checking -- erroneous "auto-fill" values
  checkAutofill = list()
  checkAutofill$Altitude_min = checkAutofilledRows(diet$Altitude_min_m)
  checkAutofill$Altitude_mean = checkAutofilledRows(diet$Altitude_mean_m)
  checkAutofill$Altitude_max = checkAutofilledRows(diet$Altitude_max_m)
  checkAutofill$Year_Begin = checkAutofilledRows(diet$Observation_Year_Begin)
  checkAutofill$Year_End = checkAutofilledRows(diet$Observation_Year_End)
  checkAutofill$Month_Begin = checkAutofilledRows(diet$Observation_Month_Begin)
  checkAutofill$Month_End = checkAutofilledRows(diet$Observation_Month_End)
  checkAutofill$Item_Sample_Size = checkAutofilledRows(diet$Item_Sample_Size)
  checkAutofill$Bird_Sample_Size = checkAutofilledRows(diet$Bird_Sample_Size)
  checkAutofill$Sites = checkAutofilledRows(diet$Sites)
  
  checkAutofill = checkAutofill[!is.na(checkAutofill)]
  
  if (length(checkAutofill) == 0) checkAutofill = 'OK'
  

  # Error checking -- text fields
  season = strsplit(as.character(diet$Observation_Season), ";") %>%
      unlist() %>%
      trimws() %>%
      table() %>%
      data.frame() %>%
      # List of acceptable values here
      filter(!tolower(.) %in% c('multiple', 'summer', 'spring', 'fall', 'winter', NA))
    if (nrow(season) == 0) {
      season = "OK"
    } else {
      names(season) = c('Observation_Season', 'n')
      problemFields = c(problemFields, "Observation_Season")
    }

  

  
  if (sum(is.na(diet$Habitat_type)) == nrow(diet)) {
    habitat = "only NAs"
  } else {
    habitat = strsplit(diet$Habitat_type, ";") %>%
      unlist() %>%
      trimws() %>%
      table() %>%
      data.frame() %>%
      # List of acceptable values here
      filter(!tolower(.) %in% c('agriculture', 'broadleaf evergreen forest', 'coniferous forest', 'deciduous forest', 'desert', 'estuary',
                                'forest', 'grassland', 'lake', 'mangrove', 'marine', 'multiple', 'river', 'shrubland', 
                                'urban', 'wetland', 'woodland', 'tundra', 'mudflat', 'rock'))
    if (nrow(habitat) == 0) {
      habitat = "OK"
    } else {
      names(habitat) = c('Habitat_type', 'n')
      problemFields = c(problemFields, "Habitat_type")
    }
  }
  

  if (sum(is.na(diet$Prey_Stage)) == nrow(diet)) {
    stage = "only NAs"
  } else {
    stage = strsplit(diet$Prey_Stage, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    # List of acceptable values here
    filter(!tolower(.) %in% c('adult', 'egg', 'juvenile', 'larva', 'nymph', 'pupa', 'teneral', 'unspecified'))
    if (nrow(stage) == 0) {
      stage = "OK"
    } else {
      names(stage) = c('Prey_Stage', 'n')
      problemFields = c(problemFields, "Prey_Stage")
    }
  }
  
  if (sum(is.na(diet$Prey_Part)) == nrow(diet)) {
    part = "only NAs"
  } else {
    part = strsplit(diet$Prey_Part, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    # List of acceptable values here
    filter(!tolower(.) %in% c('bark', 'bud', 'dung', 'egg', 'feces', 'flower', 'fruit',
                              'gall', 'oogonium', 'pollen', 'root', 'sap', 'seed',
                              'spore', 'statoblasts', 'vegetation', 'bulb', 'tuber'))
    if (nrow(part) == 0) {
      part = "OK"
    } else {
      names(part) = c('Prey_Part', 'n')
      problemFields = c(problemFields, "Prey_Part")
    }
  }
  
  
  diettype = count(diet, Diet_Type) %>% 
    filter(!Diet_Type %in% c('Wt_or_Vol', 'Items', 'Occurrence', 'Unspecified')) %>%
    arrange(desc(n)) %>%
    data.frame()
  if (nrow(diettype) == 0) {
    diettype = "OK"
  } else {
    problemFields = c(problemFields, "Diet_Type")
  }
    

  if (sum(is.na(diet$Study_Type)) == nrow(diet)) {
    studytype = "only NAs"
  } else {
    studytype = strsplit(diet$Study_Type, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    filter(!tolower(.) %in% c('behavioral observation', 'crop contents', 'emetic',
                              'esophagus contents', 'fecal contents', 'nest debris', 
                              'pellet contents', 'prey remains', 'stomach contents', 'dna sequencing'))
    if (nrow(studytype) == 0) {
      studytype = "OK"
    } else {
      names(studytype) = c('Study_Type', 'n')
      problemFields = c(problemFields, "Study_Type")
    }
  }
    
  
  countries = map('world', plot = F)$names %>%
    strsplit(":") %>% 
    lapply(`[[`, 1) %>%
    unlist() %>%
    unique()

  if (sum(is.na(diet$Location_Region)) == nrow(diet)) {
    region = "only NAs"
  } else {
    region = strsplit(diet$Location_Region, ";") %>%
    unlist() %>%
    trimws() %>%
    table() %>%
    data.frame() %>%
    arrange(desc(Freq)) %>%
      #Add region names below that are acceptable
    filter(!. %in% c(state.name, countries, 'North America', 'United States', 
                     'New England', 'Western United States', 'Southeastern United States',
                     'Eastern United States', 'Northeastern United States',
                     'Southwestern United States', 'Western North America', 
                     'Central North America', 'Eastern North America', 'United Kingdom',
                     'Alberta', 'British Columbia', 'Manitoba', 'New Brunswick', 'Nova Scotia', 
                     'Northwest Territories', 'Ontario', 'Quebec', 'Saskatchewan',
                     'Newfoundland and Labrador', 'Nunavut', 'Chesapeake Bay', 'Lake Ontario', 'Lake Erie',
                     'Lake Michigan', 'Great Plains', 'New South Wales', 'Queensland', 'Victoria',
                     'Northern Territory', 'Fennoscandia', 'Siberia', 'Svalbard', 
                     'Sonora', 'Jalisco', 'Sinaloa', 'Lesser Antilles', 'Washington D.C.',
                     'England', 'Scotland', 'Northern Ireland', 'US Virgin Islands', 'French West Indies',
                     'Seychelles','Northern Pacific Ocean'))
    if (nrow(region) == 0) {
      region = "OK"
    } else {
      names(region) = c('Location_Region', 'n')
      problemFields = c(problemFields, "Location_Region")
    }
  }
  
  
  locations = count(diet, Location_Specific) %>% arrange(desc(n)) %>% data.frame()
  
  
  fraction_sum_check = checksum(diet, accuracy = fracsum_accuracy)
  
  if (nrow(fraction_sum_check) == 0) {
    fraction_sum_check = "OK"
  }
  
  
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
                checkAutofilledValues = checkAutofill,
                Study_Type = studytype, 
                Fraction_sum_check = fraction_sum_check)
  
  if (write) {
    writetext = paste("* A cleaned database file with standardized upper/lower cases and trimmed white space was saved as '", filename, "'. Be sure to use this file rather than the original for further cleaning.", sep = "")
  } else {
    writetext = ""
  }
  
  if (length(problemFields) > 0) {
    cat(paste("* Problems were identified in ", probbirdtext, " the following fields: ", paste0(problemFields, collapse = ", "), 
                ".  \n* Refer to the output below (or in the saved object) for details. Pay particular attention to any fields in the QA/QC output that are not 'OK'.\n", writetext, 
              "\n\n", sep = ""))
  }
  return(output)
}




# Function for cleaning prey taxonomic names to conform to ITIS nomenclature.
# Note that this name focuses on the lowest taxonomic level identified, and fills
# in names of higher taxonomic levels as specified by ITIS (from taxize)

# preyTaxonLevel: Kingdom, Phylum, Class, Order, Suborder, Family, Genus, Scientific_Name
#                 NOTE: Phylum is equivalent to 'Division' in plants
# diet: diet database data.frame, if NULL will read in from repo
# problemNames: data.frame of problem names if you want to append to existing df
# write: if TRUE, will write to database after every name is cleaned
#         (useful when there are 100s to 1000s of names that won't all get processed
#          in one sitting)
# all: if TRUE, will clean all names at specified level; if FALSE, will only examine
#      and clean records for which Prey_Name_ITIS_ID is != 'verified'

clean_names = function(preyTaxonLevel, diet, problemNames = NULL, all = TRUE) {
  require(taxize)
  require(stringr)
  
  levels = c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
             'Family', 'Genus', 'Scientific_Name')
  
  if (!preyTaxonLevel %in% levels[2:8]) {
    warning("Please specify one of the following taxonomic levels to for name cleaning:\n   Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }
  
  if (all == FALSE) {
    diet2 = diet[diet$Prey_Name_Status == 'unverified' | 
                   diet$Prey_Name_Status == '' | 
                   is.na(diet$Prey_Name_Status), ]
  } else {
    diet2 = diet
  }
  
  # Find unique names at specified preyTaxonLevel for all rows
  # that have no taxonomic identification at a lower level
  if (preyTaxonLevel == 'Phylum') {
    uniqueNames = unique(diet2$Prey_Phylum[!is.na(diet2$Prey_Phylum) &
                                             !(!is.na(diet2$Prey_Class) & diet2$Prey_Class != "") &
                                             !(!is.na(diet2$Prey_Order) & diet2$Prey_Order != "") &
                                             !(!is.na(diet2$Prey_Suborder) & diet2$Prey_Suborder != "") &
                                             !(!is.na(diet2$Prey_Family) & diet2$Prey_Family != "") &
                                             !(!is.na(diet2$Prey_Genus) & diet2$Prey_Genus != "") &
                                             !(!is.na(diet2$Prey_Scientific_Name) & diet2$Prey_Scientific_Name != "")]) %>%
      as.character()
  } else if (preyTaxonLevel == 'Class') {
    uniqueNames = unique(diet2$Prey_Class[!is.na(diet2$Prey_Class) &
                                            !(!is.na(diet2$Prey_Order) & diet2$Prey_Order != "") &
                                            !(!is.na(diet2$Prey_Suborder) & diet2$Prey_Suborder != "") &
                                            !(!is.na(diet2$Prey_Family) & diet2$Prey_Family != "") &
                                            !(!is.na(diet2$Prey_Genus) & diet2$Prey_Genus != "") &
                                            !(!is.na(diet2$Prey_Scientific_Name) & diet2$Prey_Scientific_Name != "")]) %>%
      as.character()
  } else if (preyTaxonLevel == 'Order') {
    uniqueNames = unique(diet2$Prey_Order[!is.na(diet2$Prey_Order) &
                                            !(!is.na(diet2$Prey_Suborder) & diet2$Prey_Suborder != "") &
                                            !(!is.na(diet2$Prey_Family) & diet2$Prey_Family != "") &
                                            !(!is.na(diet2$Prey_Genus) & diet2$Prey_Genus != "") &
                                            !(!is.na(diet2$Prey_Scientific_Name) & diet2$Prey_Scientific_Name != "")]) %>%
      as.character()
  } else if (preyTaxonLevel == 'Suborder') {
    uniqueNames = unique(diet2$Prey_Suborder[!is.na(diet2$Prey_Suborder) &
                                               !(!is.na(diet2$Prey_Family) & diet2$Prey_Family != "") &
                                               !(!is.na(diet2$Prey_Genus) & diet2$Prey_Genus != "") &
                                               !(!is.na(diet2$Prey_Scientific_Name) & diet2$Prey_Scientific_Name != "")]) %>%
      as.character()
  } else if (preyTaxonLevel == 'Family') {
    uniqueNames = unique(diet2$Prey_Family[!is.na(diet2$Prey_Family) &
                                             !(!is.na(diet2$Prey_Genus) & diet2$Prey_Genus != "") &
                                             !(!is.na(diet2$Prey_Scientific_Name) & diet2$Prey_Scientific_Name != "")]) %>%
      as.character()
  } else if (preyTaxonLevel == 'Genus') {
    uniqueNames = unique(diet2$Prey_Genus[!is.na(diet2$Prey_Genus) &
                                            !(!is.na(diet2$Prey_Scientific_Name) & diet2$Prey_Scientific_Name != "")]) %>%
      as.character()
  } else if (preyTaxonLevel == 'Scientific_Name') {
    uniqueNames = unique(diet2$Prey_Scientific_Name[!is.na(diet2$Prey_Scientific_Name)]) %>%
      as.character()
  }
  
  uniqueNames = uniqueNames[uniqueNames != "" & !is.na(uniqueNames)]
  
  
  # Check to see whether there are any names to clean at this taxonomic level
  if (length(uniqueNames) == 0) {
    #stop("No unique names identified only to this taxonomic level")
    
    if (is.null(problemNames)) {
      problemNames = data.frame()
    }
    
    # This error code won't get propagated through clean_all_names at the moment
    return(list(diet = diet, badnames = problemNames, error = 1))
    
  } else {
    taxonLevel = paste('Prey_', preyTaxonLevel, sep = '')
    preyLevels = paste('Prey_', levels, sep = '')
    
    level = which(preyLevels == taxonLevel)
    
    higherLevels = 1:(level-1)
    
    if (is.null(problemNames)) {
      problemNames = data.frame(level = NULL, name = NULL, condition = NULL)
    }
    namecount = 1
    for (n in uniqueNames) {
      print(paste(preyTaxonLevel, namecount, "out of", length(uniqueNames)))
      hierarchy = classification(n, db = 'itis', accepted = TRUE)[[1]]
      
      # Identify all records with the specified name where all lower taxonomic
      # levels are blank or NA
      if (level < 7) {
        lowerLevelCheck = rowSums(is.na(diet[, (level+1):8 + 19]) | diet[, (level+1):8 + 19] == "") == (8 - level)
      } else if (level == 7) {
        lowerLevelCheck = is.na(diet[, (level+1):8 + 19]) | diet[, (level+1):8 + 19] == ""
      } else if (level == 8) {
        lowerLevelCheck = TRUE
      }
      
      recs = which(!is.na(diet[, taxonLevel]) & diet[,taxonLevel] == n & lowerLevelCheck)
      
      # class is logical if taxonomic name does not match any existing names
      if (is.null(nrow(hierarchy))) {
        problemNames = rbind(problemNames, 
                             data.frame(level = preyTaxonLevel, 
                                        name = n,
                                        condition = 'unmatched'))
        
        diet$Prey_Name_Status[recs] = 'unverified'
        
      } else if (nrow(hierarchy) == 1) {
        problemNames = rbind(problemNames, 
                             data.frame(level = preyTaxonLevel, 
                                        name = n,
                                        condition = 'unmatched'))
        
        diet$Prey_Name_Status[recs] = 'unverified'
        
      } else {
        
        # If the name matches, but has been assigned the wrong rank, add to problemNames
        
        if (preyTaxonLevel == 'Phylum' & 
            (hierarchy$name[1] %in% c('Plantae', 'Chromista', 'Fungi'))) {
          focalrank = 'division'
        } else if (preyTaxonLevel == 'Scientific_Name') {
          focalrank = 'species'
        } else {
          focalrank = str_to_lower(levels[level])
        }
        
        if (!focalrank %in% hierarchy$rank) {
          problemNames = rbind(problemNames, 
                               data.frame(level = preyTaxonLevel, 
                                          name = n,
                                          condition = 'wrong rank; too low'))
          
          diet$Prey_Name_Status[recs] = 'unverified'
          
        } else if (focalrank %in% hierarchy$rank & 
                   hierarchy$name[hierarchy$rank == focalrank] != n) {
          problemNames = rbind(problemNames, 
                               data.frame(level = preyTaxonLevel, 
                                          name = n,
                                          condition = 'wrong rank; too high'))
          
          diet$Prey_Name_Status[recs] = 'unverified'
          
          # Otherwise, grab 
        } else {
          
          itis_id = hierarchy$id[hierarchy$rank == focalrank & hierarchy$name == n]
          
          diet$Prey_Name_ITIS_ID[recs] = itis_id
          diet$Prey_Name_Status[recs] = 'verified'
          
          for (l in higherLevels) {
            if (l == 2 & hierarchy$name[1] == 'Plantae') {
              rank = 'division'
            } else {
              rank = str_to_lower(levels[l])
            }
            
            # Otherwise, if the rank is one that is returned by the taxize match:
            if (rank %in% hierarchy$rank) {
              # For names at the specified level that are not NA, assign to the
              # specified HIGHER taxonomic level the name from ITIS ('hierarchy')
              
              diet[recs, l + 19] = hierarchy$name[hierarchy$rank == rank]
              
            } # end if rank
            
          } # end for l
          
        } # end else (correct rank)
        
      } # end else (taxize name match)
      
      namecount = namecount + 1
      
    } # end for n
    
  } # end else
  
  return(list(diet = diet, badnames = problemNames))
  
}





# Function for cleaning prey  names at each taxonomic level from
# scientific name up through kingdom using clean_names().
# Output includes a cleaned diet database file and a list of problem
# names and their taxonomic levels that did not match in ITIS.
# 
# Most important additional argument to specify is all = TRUE if you
# want to clean all names, even those that already have ITIS IDs.
# Default is all = FALSE which will be much faster, and will only examine
# names where Prey_Name_ITIS_ID is 'unverified' or blank or NA.

# BUG: need to specify argument 'all = TRUE' when running clean_all_names,
#      which gets passed to clean_names()
#      Not sure why this isn't working properly when 'all = FALSE' at the moment.

clean_all_names = function(filename, write = TRUE, ...) {
  
  diet = read.table(filename, header= T, sep = '\t', quote = '\"', stringsAsFactors = FALSE)
  
  clean_spp = clean_names('Scientific_Name', diet, ...)
  
  clean_gen = clean_names('Genus', clean_spp$diet, problemNames = clean_spp$badnames, ...)

  clean_fam = clean_names('Family', clean_gen$diet, problemNames = clean_gen$badnames, ...)
  
  clean_subo = clean_names('Suborder', clean_fam$diet, problemNames = clean_fam$badnames, ...)
  
  clean_ord = clean_names('Order', clean_subo$diet, problemNames = clean_subo$badnames, ...)
  
  clean_cla = clean_names('Class', clean_ord$diet, problemNames = clean_ord$badnames, ...)
  
  clean_phy = clean_names('Phylum', clean_cla$diet, problemNames = clean_cla$badnames, ...)
  
  diet2 = clean_phy$diet
  
  kings = unique(diet$Prey_Kingdom)
  
  goodkings = c('Animalia', 'Plantae', 'Chromista', 'Fungi', 
                'Bacteria', 'Non-biological', 'Unknown')
  
  badkings = kings[!kings %in% goodkings]
  
  king_ids = c(202423, 202422, 630578, 555705, 50)
  
  for (k in 1:5) {
    
    diet2$Prey_Name_ITIS_ID[diet2$Prey_Kingdom == goodkings[k] & 
                             (diet2$Prey_Phylum == '' | is.na(diet2$Prey_Phylum)) &
                             (diet2$Prey_Class == '' | is.na(diet2$Prey_Class)) & 
                             (diet2$Prey_Order == '' | is.na(diet2$Prey_Order)) & 
                             (diet2$Prey_Suborder == '' | is.na(diet2$Prey_Suborder)) &
                             (diet2$Prey_Family == '' | is.na(diet2$Prey_Family)) & 
                             (diet2$Prey_Genus == '' | is.na(diet2$Prey_Genus)) &
                             (diet2$Prey_Scientific_Name == '' | is.na(diet2$Prey_Scientific_Name))] = king_ids[k]
    diet2$Prey_Name_Status[diet2$Prey_Kingdom == goodkings[k] & 
                            (diet2$Prey_Phylum == '' | is.na(diet2$Prey_Phylum)) &
                            (diet2$Prey_Class == '' | is.na(diet2$Prey_Class)) & 
                            (diet2$Prey_Order == '' | is.na(diet2$Prey_Order)) & 
                            (diet2$Prey_Suborder == '' | is.na(diet2$Prey_Suborder)) &
                            (diet2$Prey_Family == '' | is.na(diet2$Prey_Family)) & 
                            (diet2$Prey_Genus == '' | is.na(diet2$Prey_Genus)) &
                            (diet2$Prey_Scientific_Name == '' | is.na(diet2$Prey_Scientific_Name))] = 'verified'
    
  }
  
  for (k in 6:7) {
    
    diet2$Prey_Name_Status[diet2$Prey_Kingdom == goodkings[k] & 
                            (diet2$Prey_Phylum == '' | is.na(diet2$Prey_Phylum)) &
                            (diet2$Prey_Class == '' | is.na(diet2$Prey_Class)) & 
                            (diet2$Prey_Order == '' | is.na(diet2$Prey_Order)) & 
                            (diet2$Prey_Suborder == '' | is.na(diet2$Prey_Suborder)) &
                            (diet2$Prey_Family == '' | is.na(diet2$Prey_Family)) & 
                            (diet2$Prey_Genus == '' | is.na(diet2$Prey_Genus)) &
                            (diet2$Prey_Scientific_Name == '' | is.na(diet2$Prey_Scientific_Name))] = 'accepted'
    
  }
  
  # No bad names
  if (nrow(clean_phy$badnames) == 0 & length(badkings) == 0) {
    badnames = NULL
  } else if (nrow(clean_phy$badnames) > 0 & length(badkings) == 0) {
    badnames = clean_phy$badnames
  } else if (nrow(clean_phy$badnames) == 0 & length(badkings) > 0) {
    badking_df = data.frame(level = 'Kingdom',
                            name = badkings,
                            condition = 'unaccepted name')
    badnames = badking_df
  } else {
    badking_df = data.frame(level = 'Kingdom',
                            name = badkings,
                            condition = 'unaccepted name')
    badnames = rbind(clean_phy$badnames, badking_df)
  }
    
  output = list(cleandb = diet2,
                badnames = badnames)  
  
  if (write) {
    filenameparts = unlist(strsplit(filename, '[.]'))
    write.table(diet2, paste(filenameparts[1], '_clean.txt', sep = ''), sep = '\t', row.names = F)
    write.table(badnames, paste(filenameparts[1], '_badnames.txt', sep = ''), sep = '\t', row.names = F)
  }

  return(output)
}




# Function that replaces or fixes previously identified problem prey names in
# a specified diet database file.

# probnames_filename : a character string of a file name (w path if necessary) 
#                      produced by clean_all_names() with level, name, condition, 
#                      replacewith, and notes fields
# dietdb_filename :  a character string of a file name (w path if necessary)
#                    of a diet database file for which problem names will be replaced

fix_prob_names = function(probnames_filename, dietdb_filename, write = T) {
  probnames = read.table(probnames_filename,
                         header = T, sep = '\t', quote = '\"', stringsAsFactors = F)
  probnames$taxonLevel = paste('Prey_', probnames$level, sep = '')
  
  taxlevels = data.frame(level = c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
                                   'Family', 'Genus', 'Scientific_Name'),
                         levelnum = 20:27)
  
  probnames = left_join(probnames, taxlevels)
  
  probnames$notes = gsub("Kingdom", "Prey_Kingdom", probnames$notes)
  probnames$notes = gsub("Phylum", "Prey_Phylum", probnames$notes)
  probnames$notes = gsub("Class", "Prey_Class", probnames$notes)
  probnames$notes = gsub("Order", "Prey_Order", probnames$notes)
  probnames$notes = gsub("Suborder", "Prey_Suborder", probnames$notes)
  probnames$notes = gsub("Family", "Prey_Family", probnames$notes)
  probnames$notes = gsub("Genus", "Prey_Genus", probnames$notes)
  probnames$notes = gsub("Scientific_Name", "Prey_Scientific_Name", probnames$notes)
  
  diet = read.table(dietdb_filename, header = T, sep = '\t', quote = '\"', stringsAsFactors = F)
  
  for (i in 1:nrow(probnames)) {
    
    level = probnames$levelnum[i]
    taxonLevel = probnames$taxonLevel[i]
    
    # Check that all names below the taxonomic level specified are blank or NA
    if (level < 26) {
      lowerLevelCheck = rowSums(is.na(diet[, (level+1):27]) | diet[, (level+1):27] == "") == (27 - level)
    } else if (level == 26) {
      lowerLevelCheck = is.na(diet[, (level+1):27]) | diet[, (level+1):27] == ""
    } else if (level == 27) {
      lowerLevelCheck = TRUE
    }
    
    recs = which(!is.na(diet[, taxonLevel]) & diet[,taxonLevel] == probnames$name[i] & lowerLevelCheck)
    
    if (probnames$notes[i] != "keep as is") {
      diet[recs, level] = probnames$replacewith[i]
      print(paste("Replaced", probnames$name[i], "with", probnames$replacewith[i]))
    }
    
    if (!(probnames$notes[i] == "" | probnames$notes[i] == "keep as is")) {
      
      if (grepl("&", probnames$notes[i])) {
        split = unlist(strsplit(probnames$notes[i], " & "))
        for (j in split) {
          note = unlist(strsplit(j, " = "))
          diet[recs, note[1]] = note[2]
          print(paste("Assigned", note[2], "to Prey", note[1]))
        }
      } else {
        note = unlist(strsplit(probnames$notes[i], " = "))
        
        diet[recs, note[1]] = note[2]
        print(paste("Assigned", note[2], "to Prey", note[1]))
      }
      rm(note)
    }      
    print(paste(i, "out of", nrow(probnames)))
  }
  
  if (write) {
    filenameparts = unlist(strsplit(dietdb_filename, '[.]'))
    write.table(diet, paste(filenameparts[1], '_fixed.txt', sep = ''), sep = '\t', row.names = F)
  }
  
}
