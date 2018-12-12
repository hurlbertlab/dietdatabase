# Convert data from Martin 1961 in the following format:

#Common_Name	Scientific_Name	Observation_Season	Fraction_Diet_Plant	Bird_Sample_Size
#Brant	Branta bernicla	Winter	1	60
#Brant	Branta bernicla	Spring	0.93	33

# into Diet Database format

martin = read.table('AvianDietDatabase_Martin_1961.txt', header = T, sep = '\t', quote = '"', 
                    stringsAsFactors = FALSE)

martindb = data.frame(
  Common_Name = rep(martin$Common_Name, each = 2),
  Scientific_Name = rep(martin$Scientific_Name, each = 2),
  Subspecies = NA,
  Family = NA,
  Taxonomy = NA,
  Longitude_dd = NA,
  Latitude_dd = NA,
  Altitude_min_m = NA,
  Altitude_mean_m = NA,
  Altitude_max_m = NA,
  Location_Region = rep('North America', 2*nrow(martin)),
  Location_Specific = NA,
  Habitat_type = NA,
  Observation_Month_Begin = NA,
  Observation_Year_Begin = NA,
  Observation_Month_End = NA,
  Observation_Year_End = rep(1961, 2*nrow(martin)),
  Observation_Season = rep(martin$Observation_Season, each = 2),
  Prey_Kingdom = rep(c('Plantae', 'Animalia'), nrow(martin)),
  Prey_Phylum = NA,
  Prey_Class = NA,
  Prey_Order = NA,
  Prey_Suborder = NA,
  Prey_Family = NA,
  Prey_Genus = NA,
  Prey_Scientific_Name = NA,
  Unidentified = rep('no', 2*nrow(martin)),
  Prey_Name_ITIS_ID = rep(c(202422,202423), nrow(martin)),
  Prey_Name_Status = rep('verified', 2*nrow(martin)),
  Prey_Stage = NA,
  Prey_Part = NA,
  Prey_Common_Name = NA,
  Fraction_Diet = as.vector(matrix(c(martin$Fraction_Diet_Plant, 1 - martin$Fraction_Diet_Plant),
                                   ncol = nrow(martin), byrow = TRUE)),
  Diet_Type = rep('Wt_or_Vol', 2*nrow(martin)),
  Item_Sample_Size = NA,
  Bird_Sample_Size = rep(martin$Bird_Sample_Size, each = 2),
  Sites = NA,
  Study_Type = NA,
  Notes = NA,
  Entered_By = rep('AHH', 2*nrow(martin)),
  Source = rep('Martin, A. C. 1961. American wildlife & plants : a guide to wildlife food habits : the use of trees, shrubs, weeds, and herbs by birds and mammals of the United States. Dover Publications, New York, 500 pp.', 2)
)

martindb = martindb[martindb$Fraction_Diet != 0,]
write.table(martindb, 'AvianDietDatabase_Martin_1961_cleaned.txt', sep = '\t', row.names = FALSE)
