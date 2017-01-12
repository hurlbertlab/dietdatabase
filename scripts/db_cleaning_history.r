# Historical database cleaning

# A record of all cleaning changes made to the Avian Diet Database.


# Date: 11 Jan 2017

# CONVERSION OF OLD DB FORMAT (different column for each Fraction_Diet data type)
# TO NEW FORMAT (Gather all diet data into a single column, with column for data type)
# Also re-ordering rows
diet2 = gather(diet, Diet_Type, Fraction_Diet, Fraction_Diet_By_Wt_or_Vol:Fraction_Diet_Unspecified) %>%
  filter(!is.na(Fraction_Diet)) %>%
  mutate(Diet_Type = replace(Diet_Type, Diet_Type == 'Fraction_Diet_By_Wt_or_Vol', 'Wt_or_Vol')) %>%
  mutate(Diet_Type = replace(Diet_Type, Diet_Type == 'Fraction_Diet_By_Items', 'Items')) %>%
  mutate(Diet_Type = replace(Diet_Type, Diet_Type == 'Fraction_Diet_Unspecified', 'Unspecified')) %>%
  mutate(Diet_Type = replace(Diet_Type, Diet_Type == 'Fraction_Occurrence', 'Occurrence')) %>%
  select(1:31, 40, 39, 32:38) %>%
  arrange(Family, Common_Name, Source, Location_Specific, Observation_Year_Begin, Observation_Month_Begin)
write.table(diet2, 'AvianDietDatabase.txt', sep = '\t', row.names = F)

# Old AvianDietDatabase with previous structure now saved as AvianDietDatabase_old.txt


# Replace typos
diet$Common_Name = sapply(diet$Common_Name, simpleCap)
diet$Common_Name = gsub('Western Wood-Pewee', 'Western Wood-pewee', diet$Common_Name)


# Date: 12 Jan 2017

# Cleaning Observation_Season
diet$Observation_Season = gsub('Fall', 'fall', diet$Observation_Season)
diet$Observation_Season = gsub('Fall; Spring', 'Fall/spring', diet$Observation_Season)

# When done for the day, save your changes by writing the file:
# write.table(diet, 'AvianDietDatabase.txt', sep = '\t', row.names = F)
