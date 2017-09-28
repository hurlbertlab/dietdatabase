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
    diet2 = diet[diet$Prey_Name_ITIS_ID == 'unverified' | is.na(diet$Prey_Name_ITIS_ID), ]
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
      if (class(hierarchy)[1] == 'logical') {
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

