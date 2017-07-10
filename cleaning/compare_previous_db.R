# Getting list of names that don't match between the current database and 
# an old version. (Apr 13 2017 seems to be last time cleaning was done)

# Read in datasets
diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                  fill=T, stringsAsFactors = F)

olddiet = read.table('dietdatabaseApr13.txt', header=T, sep = '\t', quote = '\"',
                     fill=T, stringsAsFactors = F)
olddiet2 = read.table('dietdatabaseJun22.txt', header=T, sep = '\t', quote = '\"',
                      fill=T, stringsAsFactors = F)

newentries = anti_join(olddiet, olddiet2, 
                 by = c("Common_Name", "Scientific_Name", "Subspecies", "Family", 
                        "Taxonomy", "Longitude_dd", "Latitude_dd", "Altitude_min_m", 
                        "Altitude_mean_m", "Altitude_max_m", "Location_Region", 
                        "Location_Specific", "Habitat_type", "Observation_Month_Begin", 
                        "Observation_Year_Begin", "Observation_Month_End", "Observation_Year_End", 
                        "Observation_Season", "Prey_Kingdom", "Prey_Phylum", "Prey_Class", 
                        "Prey_Order", "Prey_Suborder", "Prey_Family", "Prey_Genus", 
                        "Prey_Scientific_Name", "Unidentified", "Prey_Name_Status", 
                        "Prey_Stage", "Prey_Part", "Prey_Common_Name", "Fraction_Diet",
                        "Diet_Type", "Item_Sample_Size", "Bird_Sample_Size", "Study_Type", 
                        "Notes", "Entered_By", "Source"))

newnames = newentries %>% 
  select(Common_Name, Scientific_Name, Family) %>% 
  distinct()




# Getting fraction diet summaries
