# Data summaries of the Avian Diet Database

library(dplyr)
library(stringr)

#################
simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
}


# Read in diet database, references, and eBird taxonomy tables
diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                  fill=T, stringsAsFactors = F)
refs = read.table('NA_avian_diet_refs.txt', header=T, sep = '\t', quote = '\"',
                  fill=T, stringsAsFactors = F)
# Make sure to grab the most recent eBird table in the directory
taxfiles = file.info(list.files()[grep('eBird', list.files())])
taxfiles$name = row.names(taxfiles)
tax = read.table(taxfiles$name[taxfiles$mtime == max(taxfiles$mtime)], header = T,
                 sep = ',', quote = '\"', stringsAsFactors = F)
orders = unique(tax[, c('ORDER', 'FAMILY')])
orders$Family = word(orders$FAMILY, 1)
orders = filter(orders, FAMILY != "" & ORDER != "") %>%
  select(ORDER, Family)
  
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
  spCountByFamily2$Family = as.character(spCountByFamily2$Family)
  spCountByFamily2$WithoutData[is.na(spCountByFamily2$WithoutData)] = 0
  spCountByFamily2 = spCountByFamily2[spCountByFamily2$Family != "", ]
  spCountByFamily3 = inner_join(spCountByFamily2, orders, by = 'Family')
  spCountByFamily3 = spCountByFamily3[, c('ORDER', 'Family', 'SpeciesWithData',
                                          'WithoutData')] %>%
    arrange(ORDER)
  return(list(numRecords=numRecords,
              numSpecies=numSpecies, 
              numStudies=numStudies, 
              recordsPerSpecies=recordsPerSpecies,
              speciesPerFamily = spCountByFamily3))
}


# Argument "by" may specify 'Kingdom', 'Phylum', 'Class', 'Order', 'Family',
#   'Genus', or 'Scientific_Name' ('Species' will not work)
speciesSummary = function(commonName, diet, by = 'Order') {
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
  
  # Still need to make sure aggregation of lower level data is occurring properly,
  # and decide how to treat "" at the specified taxonomic level for summary.
  # Aggregates by summing within study ('Source'), but in some cases a study
  # has different subsets of data (e.g. different methods: fecal vs stomach)
  # each of which will sum to 100%. Need to add a dietAnalysisID to distinguish
  # separate analyses both within and between studies?
  
  # Prey_Stage should only matter for distinguishing things at the Order level and 
  # below (e.g. distinguishing between Lepidoptera larvae and adults).
  taxonLevel = paste('Prey_', by, sep = '')
  if (by %in% c('Order', 'Family', 'Genus', 'Scientific_Name')) {
    dietsp$Taxon = paste(dietsp[, taxonLevel], dietsp$Prey_Stage, sep = "")
  } else {
    dietsp$Taxon = dietsp[, taxonLevel]
  }
  preySummary = dietsp %>% 
    group_by(Taxon, Source) %>%
    summarize(By_Wt_Or_Vol = sum(Fraction_Diet_By_Wt_or_Vol, na.rm = T),
              By_Items = sum(Fraction_Diet_By_Items, na.rm = T),
              Occurrence = sum(Fraction_Occurrence, na.rm = T),
              Unspecified = sum(Fraction_Diet_Unspecified, na.rm = T)) %>%
    group_by(Taxon) %>%
    summarize(By_Wt_Or_Vol = sum(By_Wt_Or_Vol, na.rm = T)/length(unique(dietsp$Source)),
              By_Items = sum(By_Items, na.rm = T)/length(unique(dietsp$Source)),
              Occurrence = sum(Occurrence, na.rm = T)/length(unique(dietsp$Source)),
              Unspecified = sum(Unspecified, na.rm = T)/length(unique(dietsp$Source)))
  
  return(list(numStudies = numStudies,
              numRecords = numRecords,
              recordsPerYear = recordsPerYear,
              recordsPerRegion = recordsPerRegion,
              recordsPerType = recordsPerType,
              preySummary = preySummary))
}

dietSummary(diet, refs)
