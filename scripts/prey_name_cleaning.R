clean_names = function(diet, preyTaxonLevel, write = FALSE) {
  require(taxize)
  require(stringr)
  
  levels = c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
            'Family', 'Genus', 'Scientific_Name')
  
  if (!preyTaxonLevel %in% levels[2:8]) {
    warning("Please specify one of the following taxonomic levels to for name cleaning:\n   Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }
  
  #diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
  #                  fill=T, stringsAsFactors = F)
  
    # Find unique names at specified preyTaxonLevel for all rows
  # that have no taxonomic identification at a lower level
  if (preyTaxonLevel == 'Phylum') {
    uniqueNames = unique(diet$Prey_Phylum[!is.na(diet$Prey_Phylum) &
                                      is.na(diet$Prey_Class) &
                                      is.na(diet$Prey_Order) &
                                      is.na(diet$Prey_Suborder) &
                                      is.na(diet$Prey_Family) &
                                      is.na(diet$Prey_Genus) &
                                      is.na(diet$Prey_Scientific_Name)]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Class') {
    uniqueNames = unique(diet$Prey_Class[!is.na(diet$Prey_Class) &
                                      is.na(diet$Prey_Order) &
                                      is.na(diet$Prey_Suborder) &
                                      is.na(diet$Prey_Family) &
                                      is.na(diet$Prey_Genus) &
                                      is.na(diet$Prey_Scientific_Name)]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Order') {
    uniqueNames = unique(diet$Prey_Order[!is.na(diet$Prey_Order) &
                                    is.na(diet$Prey_Suborder) &
                                    is.na(diet$Prey_Family) &
                                    is.na(diet$Prey_Genus) &
                                    is.na(diet$Prey_Scientific_Name)]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Suborder') {
    uniqueNames = unique(diet$Prey_Suborder[!is.na(diet$Prey_Suborder) &
                                    is.na(diet$Prey_Family) &
                                    is.na(diet$Prey_Genus) &
                                    is.na(diet$Prey_Scientific_Name)]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Family') {
    uniqueNames = unique(diet$Prey_Family[!is.na(diet$Prey_Family) &
                                       is.na(diet$Prey_Genus) &
                                       is.na(diet$Prey_Scientific_Name)]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Genus') {
    uniqueNames = unique(diet$Prey_Genus[!is.na(diet$Prey_Genus) &
                                        is.na(diet$Prey_Scientific_Name)]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Scientific_Name') {
    uniqueNames = unique(diet$Prey_Scientific_Name[!is.na(diet$Prey_Scientific_Name)]) %>%
                                as.character()
  }
  
  uniqueNames = uniqueNames[uniqueNames != "" & !is.na(uniqueNames)]
  
  taxonLevel = paste('Prey_', preyTaxonLevel, sep = '')
  preyLevels = c('Prey_Kingdom', 'Prey_Phylum', 'Prey_Class',
                 'Prey_Order', 'Prey_Suborder', 'Prey_Family',
                 'Prey_Genus', 'Prey_Scientific_Name')
  
  level = which(preyLevels == taxonLevel)
  
  higherLevels = 1:(level-1)
  
  
  problemNames = data.frame(level = NULL, name = NULL)
  
  for (n in uniqueNames) {
    #hierarchy = classification(n, db = 'itis')[[1]]
    
    #if (...) {
    #  problemNames = rbind(problemNames, c(preyTaxonLevel, n))
    #} else {
      for (l in higherLevels) {
        if (l == 2 & hierarchy$name[1] == 'Plantae') {
          rank = 'division'
        } else {
          rank = str_to_lower(levels[l])
        }
        
        if (rank %in% hierarchy$rank) {
          # For names at the specified level that are not NA, assign to the
          # specified HIGHER taxonomic level the name from ITIS ('hierarchy')
          
          if (level < 7) {
            lowerLevelCheck = rowSums(is.na(diet[, (level+1):8 + 18]) | diet[, (level+1):8 + 18] == "") == (8 - level)
          } else if (level == 7) {
            lowerLevelCheck = is.na(diet[, (level+1):8 + 18]) | diet[, (level+1):8 + 18] == ""
          } else if (level == 8) {
            lowerLevelCheck = TRUE
          }
            
          recs = which(!is.na(diet[, taxonLevel]) & diet[,taxonLevel] == n & lowerLevelCheck)

          
          diet[recs, l + 18] = hierarchy$name[hierarchy$rank == rank]
        }
      }
    }
  return(diet)
}

