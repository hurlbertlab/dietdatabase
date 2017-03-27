clean_names = function(preyTaxonLevel, diet = NULL, problemNames = NULL, write = FALSE) {
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

  # Find unique names at specified preyTaxonLevel for all rows
  # that have no taxonomic identification at a lower level
  if (preyTaxonLevel == 'Phylum') {
    uniqueNames = unique(diet$Prey_Phylum[!is.na(diet$Prey_Phylum) &
                                  !(!is.na(diet$Prey_Class) & diet$Prey_Class != "") &
                                      !(!is.na(diet$Prey_Order) & diet$Prey_Order != "") &
                                      !(!is.na(diet$Prey_Suborder) & diet$Prey_Suborder != "") &
                                      !(!is.na(diet$Prey_Family) & diet$Prey_Family != "") &
                                      !(!is.na(diet$Prey_Genus) & diet$Prey_Genus != "") &
                                      !(!is.na(diet$Prey_Scientific_Name) & diet$Prey_Scientific_Name != "")]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Class') {
    uniqueNames = unique(diet$Prey_Class[!is.na(diet$Prey_Class) &
                                           !(!is.na(diet$Prey_Order) & diet$Prey_Order != "") &
                                           !(!is.na(diet$Prey_Suborder) & diet$Prey_Suborder != "") &
                                           !(!is.na(diet$Prey_Family) & diet$Prey_Family != "") &
                                           !(!is.na(diet$Prey_Genus) & diet$Prey_Genus != "") &
                                           !(!is.na(diet$Prey_Scientific_Name) & diet$Prey_Scientific_Name != "")]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Order') {
    uniqueNames = unique(diet$Prey_Order[!is.na(diet$Prey_Order) &
                                           !(!is.na(diet$Prey_Suborder) & diet$Prey_Suborder != "") &
                                           !(!is.na(diet$Prey_Family) & diet$Prey_Family != "") &
                                           !(!is.na(diet$Prey_Genus) & diet$Prey_Genus != "") &
                                           !(!is.na(diet$Prey_Scientific_Name) & diet$Prey_Scientific_Name != "")]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Suborder') {
    uniqueNames = unique(diet$Prey_Suborder[!is.na(diet$Prey_Suborder) &
                                              !(!is.na(diet$Prey_Family) & diet$Prey_Family != "") &
                                              !(!is.na(diet$Prey_Genus) & diet$Prey_Genus != "") &
                                              !(!is.na(diet$Prey_Scientific_Name) & diet$Prey_Scientific_Name != "")]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Family') {
    uniqueNames = unique(diet$Prey_Family[!is.na(diet$Prey_Family) &
                                            !(!is.na(diet$Prey_Genus) & diet$Prey_Genus != "") &
                                            !(!is.na(diet$Prey_Scientific_Name) & diet$Prey_Scientific_Name != "")]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Genus') {
    uniqueNames = unique(diet$Prey_Genus[!is.na(diet$Prey_Genus) &
                                           !(!is.na(diet$Prey_Scientific_Name) & diet$Prey_Scientific_Name != "")]) %>%
                                as.character()
  } else if (preyTaxonLevel == 'Scientific_Name') {
    uniqueNames = unique(diet$Prey_Scientific_Name[!is.na(diet$Prey_Scientific_Name)]) %>%
                                as.character()
  }
  
  uniqueNames = uniqueNames[uniqueNames != "" & !is.na(uniqueNames)]
  
  taxonLevel = paste('Prey_', preyTaxonLevel, sep = '')
  preyLevels = paste('Prey_', levels, sep = '')
  
  level = which(preyLevels == taxonLevel)
  
  higherLevels = 1:(level-1)
  
  if (is.null(problemNames)) {
    problemNames = data.frame(level = NULL, name = NULL)
  }
  
  for (n in uniqueNames) {
    hierarchy = classification(n, db = 'itis')[[1]]
    
    # class is logical if taxonomic name does not match any existing names
    if (class(hierarchy)[1] == 'logical') {
      problemNames = rbind(problemNames, data.frame(level = preyTaxonLevel, name = n))
    } else {

      for (l in higherLevels) {
        if (l == 2 & hierarchy$name[1] == 'Plantae') {
          rank = 'division'
        } else {
          rank = str_to_lower(levels[l])
        }
        
        # If the name matches, but has been assigned the wrong rank, add to problemNames
        if (hierarchy$name[hierarchy$rank == rank] != n) {
          problemNames = rbind(problemNames, data.frame(level = preyTaxonLevel, name = n))
        
        # Otherwise, grab 
        } else if (rank %in% hierarchy$rank & hierarchy$name[hierarchy$rank == rank] == n) {
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
        } # end if rank
      } # end for l
    } # end else
  } # end for n
  
  if (write) {
    write.table(diet, 'AvianDietDatabase.txt', sep = '\t', row.names = F)
    write.table(problemNames, 'unmatched_ITIS_names.txt', sep = '\t', row.names = F)
  }
  return(list(diet = diet, badnames = problemNames))
}

# Example cleaning
diet = read.table('AvianDietDatabase.txt', header = T, sep = '\t', quote = '\"', stringsAsFactors = F)
clean_phy = clean_names('Phylum')
clean_cl = clean_names('Class', diet = clean_phy$diet, problemNames = clean_phy$badnames)
clean_or = clean_names('Order', diet = clean_cl$diet, problemNames = clean_cl$badnames)

