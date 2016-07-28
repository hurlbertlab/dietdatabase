# Data summaries of the Avian Diet Database

setwd('z:/git/dietdatabase')

#################
simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
}



diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                  fill=T, stringsAsFactors = F)
refs = read.table('NA_avian_diet_refs.txt', header=T, sep = '\t', quote = '\"',
                  fill=T, stringsAsFactors = F)


# Replace typos
diet$Common_Name = sapply(diet$Common_Name, simpleCap)
diet$Common_Name = gsub('Western Wood-Pewee', 'Western Wood-pewee', diet$Common_Name)


dietSummary = function(diet, refs) {
  species = unique(diet[, c('Common_Name', 'Family')])
  allspecies = unique(refs[, c('common_name', 'family')])
  numSpecies = nrow(species)
  numStudies = length(unique(diet$Source))
  numRecords = nrow(diet)
  recordsPerSpecies = data.frame(table(diet$Common_Name))
  spCountByFamily = data.frame(table(species$Family))
  noDataSpecies = subset(allspecies, !common_name %in% species$Common_Name)
  noDataSpCountByFamily = data.frame(table(noDataSpecies$family))
  spCountByFamily2 = merge(spCountByFamily, noDataSpCountByFamily, by = "Var1", all = T)
  names(spCountByFamily2) = c('Family', 'SpeciesWithData', 'WithoutData')
  spCountByFamily2$WithoutData[is.na(spCountByFamily2$WithoutData)] = 0
  spCountByFamily2 = spCountByFamily2[spCountByFamily2$Family != "", ]
  return(list(numRecords=numRecords,
              numSpecies=numSpecies, 
              numStudies=numStudies, 
              recordsPerSpecies=recordsPerSpecies,
              speciesPerFamily = spCountByFamily2))
}

speciesSummary = function(commonName, diet) {
  if (!commonName %in% diet$Common_Name) {
    print("No species with that name in the diet database.")
    return(NULL)
  }
  
  dietsp = subset(diet, Common_Name == commonName)
  numStudies = length(unique(dietsp$Source))
  numRecords = nrow(dietsp)
  recordsPerYear = data.frame(table(dietsp$Observation_Year_Begin))
  recordsPerRegion = data.frame(table(dietsp$Location_Region))
  recordsPerType = data.frame(ByWtVol = sum(dietsp$Fraction_Diet_By_Wt_or_Vol > 0, na.rm = T),
                        ByNumItems = sum(dietsp$Fraction_Diet_By_Items > 0, na.rm = T),
                        ByOccurrence = sum(dietsp$Fraction_Occurrence > 0, na.rm = T),
                        Unspecified = sum(dietsp$Fraction_Diet_Unspecified > 0, na.rm = T))
  #preyOrders = 
  
  return(list(numStudies = numStudies,
              numRecords = numRecords,
              recordsPerYear = recordsPerYear,
              recordsPerRegion = recordsPerRegion,
              recordsPerType = recordsPerType))
}

dietSummary(diet, refs)
