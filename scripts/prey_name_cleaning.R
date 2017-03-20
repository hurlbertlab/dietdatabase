clean_names = function(preyTaxonLevel, write = FALSE) {
  require(taxize)
  require(stringr)
  
  levels = c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
            'Family', 'Genus', 'Scientific_Name')
  
  if (!preyTaxonLevel %in% levels) {
    warning("Please specify one of the following taxonomic levels to aggregate prey data:\n   Kingdom, Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }
  
  diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                    fill=T, stringsAsFactors = F)
  
    # Find unique names at specified preyTaxonLevel for all rows
  # that have no taxonomic identification at a lower level
  if (preyTaxonLevel = 'Kingdom') { 
    uniqueNames = unique(diet$Prey_Kingdom[!is.na(diet$Prey_Kingdom) &
                                      is.na(diet$Prey_Phylum) &
                                      is.na(diet$Prey_Class) &
                                      is.na(diet$Prey_Order) &
                                      is.na(diet$Prey_Suborder) &
                                      is.na(diet$Prey_Family) &
                                      is.na(diet$Prey_Genus) &
                                      is.na(diet$Prey_Scientific_Name)])
  } else if (preyTaxonLevel = 'Phylum') {
    uniqueNames = unique(diet$Prey_Phylum[!is.na(diet$Prey_Phylum) &
                                      is.na(diet$Prey_Class) &
                                      is.na(diet$Prey_Order) &
                                      is.na(diet$Prey_Suborder) &
                                      is.na(diet$Prey_Family) &
                                      is.na(diet$Prey_Genus) &
                                      is.na(diet$Prey_Scientific_Name)])
  } else if (preyTaxonLevel = 'Class') {
    uniqueNames = unique(diet$Prey_Class[!is.na(diet$Prey_Class) &
                                      is.na(diet$Prey_Order) &
                                      is.na(diet$Prey_Suborder) &
                                      is.na(diet$Prey_Family) &
                                      is.na(diet$Prey_Genus) &
                                      is.na(diet$Prey_Scientific_Name)])
  } else if (preyTaxonLevel = 'Order') {
    uniqueNames = unique(diet$Prey_Order[!is.na(diet$Prey_Order) &
                                    is.na(diet$Prey_Suborder) &
                                    is.na(diet$Prey_Family) &
                                    is.na(diet$Prey_Genus) &
                                    is.na(diet$Prey_Scientific_Name)])
  } else if (preyTaxonLevel = 'Suborder') {
    uniqueNames = unique(diet$Prey_Suborder[!is.na(diet$Prey_Suborder) &
                                    is.na(diet$Prey_Family) &
                                    is.na(diet$Prey_Genus) &
                                    is.na(diet$Prey_Scientific_Name)])
  } else if (preyTaxonLevel = 'Family') {
    uniqueNames = unique(diet$Prey_Family[!is.na(diet$Prey_Family) &
                                       is.na(diet$Prey_Genus) &
                                       is.na(diet$Prey_Scientific_Name)])
  } else if (preyTaxonLevel = 'Genus') {
    uniqueNames = unique(diet$Prey_Genus[!is.na(diet$Prey_Genus) &
                                        is.na(diet$Prey_Scientific_Name)])
  } else if (preyTaxonLevel = 'Scientific_Name') {
    uniqueNames = unique(diet$Prey_Scientific_Name[!is.na(diet$Prey_Scientific_Name)])
  }
  
  taxonLevel = paste('Prey_', preyTaxonLevel, sep = '')
  preyLevels = c('Prey_Kingdom', 'Prey_Phylum', 'Prey_Class',
                 'Prey_Order', 'Prey_Suborder', 'Prey_Family',
                 'Prey_Genus', 'Prey_Scientific_Name')
  
  level = which(preyLevels == taxonLevel)
  
  higherLevels = 1:min(level+1, 7)
  
  
  problemNames = data.frame(level = NULL, name = NULL)
  
  for (n in uniqueNames) {
    hierarchy = classification(n, db = 'itis')[[1]]
    
    if (...) {
      problemNames = rbind(problemNames, c(preyTaxonLevel, n))
    } else {
      for (l in higherLevels) {
        diet[diet[, level + 18] == n, preyLevels[l]] = hierarchy$name[hierarchy$rank == str_to_lower(preyTaxonLevel)]
      }
      
    }
  }
  
}