# Data summaries of the Avian Diet Database

library(dplyr)
library(stringr)
library(tidyr)

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

# Gather different diet type columns into a single column
diet2 = gather(diet, Diet_Type, Fraction_Diet, Fraction_Diet_By_Wt_or_Vol:Fraction_Diet_Unspecified) %>%
  filter(!is.na(Fraction_Diet)) %>%
  mutate(Diet_Type = replace(Diet_Type, Diet_Type == 'Fraction_Diet_By_Wt_or_Vol', 'Wt_or_Vol')) %>%
  mutate(Diet_Type = replace(Diet_Type, Diet_Type == 'Fraction_Diet_By_Items', 'Items')) %>%
  mutate(Diet_Type = replace(Diet_Type, Diet_Type == 'Fraction_Diet_Unspecified', 'Unspecified')) %>%
  mutate(Diet_Type = replace(Diet_Type, Diet_Type == 'Fraction_Occurrence', 'Occurrence'))

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
  spCountByFamily3 = spCountByFamily2 %>% 
    inner_join(orders, by = 'Family') %>%
    select(ORDER, Family, SpeciesWithData, WithoutData) %>%
    arrange(ORDER)
  spCountByFamily3$SpeciesWithData[is.na(spCountByFamily3$SpeciesWithData)] = 0
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
    warning("No species with that name in the Diet Database.")
    return(NULL)
  }
  if (!by %in% c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
                 'Family', 'Genus', 'Scientific_Name')) {
    warning("Please specify one of the following taxonomic levels to aggregate prey data:\n   Kingdom, Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }
  
  
  dietsp = subset(diet, Common_Name == commonName)
  numStudies = length(unique(dietsp$Source))
  numRecords = nrow(dietsp)
  recordsPerYear = data.frame(count(dietsp, Observation_Year_Begin))
  recordsPerRegion = data.frame(count(dietsp, Location_Region))
  recordsPerType = data.frame(count(dietsp, Diet_Type))
  
  taxonLevel = paste('Prey_', by, sep = '')
  
  # If prey not identified down to taxon level specified, replace "" with
  # "Unidentified XXX" where XXX is the lowest level specified (e.g. Unidentified Animalia)
  dietprey = dietsp[, c('Prey_Kingdom', 'Prey_Phylum', 'Prey_Class',
                        'Prey_Order', 'Prey_Suborder', 'Prey_Family',
                        'Prey_Genus', 'Prey_Scientific_Name')]
  level = which(names(dietprey) == taxonLevel)
  dietsp[, taxonLevel] = apply(dietprey, 1, function(x)
    if(x[level] == "") { paste("Unid.", x[max(which(x != "")[which(x != "") < level])])} 
    else { x[level] })
  
  # Prey_Stage should only matter for distinguishing things at the Order level and 
  # below (e.g. distinguishing between Lepidoptera larvae and adults).
  if (by %in% c('Order', 'Family', 'Genus', 'Scientific_Name')) {
    dietsp$Taxon = paste(dietsp[, taxonLevel], dietsp$Prey_Stage, sep = "")
  } else {
    dietsp$Taxon = dietsp[, taxonLevel]
  }
  
  studiesPerDietType = dietsp %>%
    select(Source, Observation_Year_Begin, Item_Sample_Size, Diet_Type) %>%
    distinct() %>%
    count(Diet_Type)
  
  # Equal-weighted mean fraction of diet (all studies weighted equally despite
  #  variation in sample size)
  preySummary = dietsp %>% 
    group_by(Source, Observation_Year_Begin, Item_Sample_Size, Taxon, Diet_Type) %>%
    summarize(Sum_Diet = sum(Fraction_Diet, na.rm = T)) %>%
    group_by(Diet_Type, Taxon) %>%
    summarize(Sum_Diet2 = sum(Sum_Diet, na.rm = T)) %>%
    left_join(studiesPerDietType, by = c('Diet_Type' = 'Diet_Type')) %>%
    mutate(Frac_Diet = Sum_Diet2/n) %>%
    select(Diet_Type, Taxon, Frac_Diet) %>%
    arrange(Diet_Type, desc(Frac_Diet))
  
  return(list(numStudies = numStudies,
              numRecords = numRecords,
              recordsPerYear = recordsPerYear,
              recordsPerRegion = recordsPerRegion,
              recordsPerType = recordsPerType,
              preySummary = preySummary))
}

dietSummary(diet2, refs)



# TESTING

# Create test dataset based on two studies of Bald eagle
ret = diet2[grep("Retfalvi, L. 1970", diet2$Source),]
mers = diet2[grep("Mersmann, T. J. 1989", diet2$Source),]
dietsp = rbind(ret, mers) %>% 
  select(Common_Name, Observation_Year_Begin, Location_Region,
         Prey_Kingdom:Prey_Scientific_Name, Prey_Stage, 
         Diet_Type, Fraction_Diet, Item_Sample_Size, Source)
dietsp$Source[grep("Retfalvi", dietsp$Source)] = "Retfalvi 1970"
dietsp$Source[grep("Mersmann", dietsp$Source)] = "Mersmann 1989"

