# Error checking Diet Database

library(dplyr)
library(tidyr)
library(taxize)
library(maps)


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
             Bird_Sample_Size, Habitat_type, Location_Region, Item_Sample_Size, Diet_Type, Study_Type, Sites) %>%
    
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
    stage = "only NAs"
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
    part = "only NAs"
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
    studytype = "only NAs"
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
    region = "only NAs"
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
                     'Sonora', 'Jalisco', 'Sinaloa', 'Lesser Antilles', 'Washington D.C.'))
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

clean_names = function(preyTaxonLevel, diet = NULL, problemNames = NULL, 
                       write = FALSE, all = FALSE) {
  require(taxize)
  require(stringr)
  
  levels = c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
             'Family', 'Genus', 'Scientific_Name')
  
  if (!preyTaxonLevel %in% levels[2:8]) {
    warning("Please specify one of the following taxonomic levels to for name cleaning:\n   Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }
  
  if (is.null(diet)) {
    diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                      fill=T, stringsAsFactors = F) 
  }
  
  if (all == FALSE) {
    diet2 = diet[diet$Prey_Name_ITIS_ID == 'unverified' | 
                   diet$Prey_Name_ITIS_ID == '' | 
                   is.na(diet$Prey_Name_ITIS_ID), ]
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
    return(list(diet = diet2, badnames = problemNames, error = 1))
    
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
      hierarchy = classification(n, db = 'itis')[[1]]
      
      # Identify all records with the specified name where all lower taxonomic
      # levels are blank or NA
      if (level < 7) {
        lowerLevelCheck = rowSums(is.na(diet2[, (level+1):8 + 18]) | diet2[, (level+1):8 + 18] == "") == (8 - level)
      } else if (level == 7) {
        lowerLevelCheck = is.na(diet2[, (level+1):8 + 18]) | diet2[, (level+1):8 + 18] == ""
      } else if (level == 8) {
        lowerLevelCheck = TRUE
      }
      
      recs = which(!is.na(diet2[, taxonLevel]) & diet2[,taxonLevel] == n & lowerLevelCheck)
      
      # class is logical if taxonomic name does not match any existing names
      if (is.null(nrow(hierarchy))) {
        problemNames = rbind(problemNames, 
                             data.frame(level = preyTaxonLevel, 
                                        name = n,
                                        condition = 'unmatched'))
        
        diet2$Prey_Name_ITIS_ID[recs] = 'unverified'
        
      } else if (nrow(hierarchy) == 1) {
        problemNames = rbind(problemNames, 
                             data.frame(level = preyTaxonLevel, 
                                        name = n,
                                        condition = 'unmatched'))
        
        diet2$Prey_Name_ITIS_ID[recs] = 'unverified'
        
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
          
          diet2$Prey_Name_ITIS_ID[recs] = 'unverified'
          
        } else if (focalrank %in% hierarchy$rank & 
                   hierarchy$name[hierarchy$rank == focalrank] != n) {
          problemNames = rbind(problemNames, 
                               data.frame(level = preyTaxonLevel, 
                                          name = n,
                                          condition = 'wrong rank; too high'))
          
          diet2$Prey_Name_ITIS_ID[recs] = 'unverified'
          
          # Otherwise, grab 
        } else {
          
          itis_id = hierarchy$id[hierarchy$rank == focalrank & hierarchy$name == n]
          
          diet2$Prey_Name_ITIS_ID[recs] = itis_id
          
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
              
              diet2[recs, l + 18] = hierarchy$name[hierarchy$rank == rank]
              
            } # end if rank
            
          } # end for l
          
        } # end else (correct rank)
        
      } # end else (taxize name match)
      
      namecount = namecount + 1
      
      if (write) {
        write.table(diet2, 'AvianDietDatabase.txt', sep = '\t', row.names = F)
        write.table(problemNames, 'unmatched_ITIS_names.txt', sep = '\t', row.names = F)
      }
      
    } # end for n
    
  } # end else
  
  return(list(diet = diet2, badnames = problemNames))
  
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
  
  kings = unique(diet$Prey_Kingdom)
  
  badkings = kings[!kings %in% c('Animalia', 'Plantae', 'Chromista', 'Fungi', 'Bacteria')]
  
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
    
  output = list(cleandb = clean_phy$diet,
                badnames = badnames)  
  
  if (write) {
    filenameparts = unlist(strsplit(filename, '[.]'))
    write.table(clean_phy$diet, paste(filenameparts[1], '_clean.txt', sep = ''), sep = '\t', row.names = F)
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
                         levelnum = 19:26)
  
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
    if (level < 25) {
      lowerLevelCheck = rowSums(is.na(diet[, (level+1):26]) | diet[, (level+1):26] == "") == (26 - level)
    } else if (level == 25) {
      lowerLevelCheck = is.na(diet[, (level+1):26]) | diet[, (level+1):26] == ""
    } else if (level == 26) {
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
