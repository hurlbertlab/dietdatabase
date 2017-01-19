# Historical database cleaning

# A record of all cleaning changes made to the Avian Diet Database.


# Date: 11 Jan 2017; By Allen Hurlbert

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


# Date: 12 Jan 2017; By: Allen Hurlbert

# Cleaning Observation_Season
diet$Observation_Season = gsub('Fall', 'fall', diet$Observation_Season)
diet$Observation_Season = gsub('Fall; Spring', 'Fall/spring', diet$Observation_Season)

# Date: 19 Jan 2017; By: Patrick Winner

#Cleaning Location_Region
diet$Location_Region = gsub('Oxford, England', 'England', diet$Location_Region)
diet$Location_Region = gsub('Boise, Ada County, Idaho', 'Idaho', diet$Location_Region)
diet$Location_Region = gsub('US & Canada', 'United States; Canada', diet$Location_Region)
diet$Location_Region = gsub('North Central Utah', 'Utah', diet$Location_Region)
diet$Location_Region = gsub('Northern Colorado', 'Colorado', diet$Location_Region)
diet$Location_Region = gsub('Southeastern Wisconsin', 'Wisconsin', diet$Location_Region)
diet$Location_Region = gsub('SW South Dakota', 'South Dakota', diet$Location_Region)
diet$Location_Region = gsub('United States, Canada', 'United States; Canada', diet$Location_Region)
diet$Location_Region = gsub('NW Texas', 'Texas', diet$Location_Region)
diet$Location_Region = gsub('Eastern to Central US, Canada', 'United States; Canada', diet$Location_Region)
diet$Location_Region = gsub('NE Oklahoma', 'Oklahoma', diet$Location_Region)
diet$Location_Region = gsub('Western United States', 'United States', diet$Location_Region)
diet$Location_Region = gsub('SE Washington', 'Washington', diet$Location_Region)
diet$Location_Region = gsub('Central Chile', 'Chile', diet$Location_Region)
diet$Location_Region = gsub('Eastern Washington', 'Washington', diet$Location_Region)
diet$Location_Region = gsub('Manitoba, Canada', 'Manitoba', diet$Location_Region)
diet$Location_Region = gsub('Northwestern US', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Central Kentucky', 'Kentucky', diet$Location_Region)
diet$Location_Region = gsub('Northwestern North Dakota', 'North Dakota', diet$Location_Region)
diet$Location_Region = gsub('Central Alberta', 'Alberta', diet$Location_Region)
diet$Location_Region = gsub('Northeastern US and most of Canada', 'United States; Canada', diet$Location_Region)
diet$Location_Region = gsub('Texas (one bird from Florida)', 'Texas; Florida', diet$Location_Region)
diet$Location_Region = gsub('Eastern California', 'California', diet$Location_Region)
diet$Location_Region = gsub('New Brunswick, Canada', 'New Brunswick', diet$Location_Region)
diet$Location_Region = gsub('Southern Mexico and Central America', 'Mexico; Central America', diet$Location_Region)
diet$Location_Region = gsub('Southwestern Oklahoma', 'Oklahoma', diet$Location_Region)
diet$Location_Region = gsub('Western US and Mexico', 'United States; Mexico', diet$Location_Region)
diet$Location_Region = gsub('SW United States, Mexico', 'United States; Mexico', diet$Location_Region)
diet$Location_Region = gsub('Georgia ', 'Georgia', diet$Location_Region)
diet$Location_Region = gsub('Central Illinois', 'Illinois', diet$Location_Region)
diet$Location_Region = gsub('Southeastern Manitoba and Northern Minnesota', 'Manitoba; Minnesota', diet$Location_Region)
diet$Location_Region = gsub('Contra Costa County, California', 'California', diet$Location_Region)
diet$Location_Region = gsub('Southeastern Idaho and Northwestern Wyoming', 'Idaho; Wyoming', diet$Location_Region)
diet$Location_Region = gsub('North-Central Florida', 'Florida', diet$Location_Region)
diet$Location_Region = gsub('United States, West of the Rocky Mountains', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Southern Texas', 'Texas', diet$Location_Region)
diet$Location_Region = gsub('Northeastern Oregon', 'Oregon', diet$Location_Region)
diet$Location_Region = gsub('Western North America', 'North America', diet$Location_Region)
diet$Location_Region = gsub('Western US and Canada', 'United States; Canada', diet$Location_Region)
diet$Location_Region = gsub('Western Texas, North-central Mexico, California', 'Texas; California; Mexico', diet$Location_Region)
diet$Location_Region = gsub('Northeastern US', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Northeast US', 'United States', diet$Location_Region)
diet$Location_Region = gsub('West and Northwestern United States', 'United States', diet$Location_Region)
diet$Location_Region = gsub('New york', 'New York', diet$Location_Region)
diet$Location_Region = gsub('Western Alberta, Canada', 'Alberta', diet$Location_Region)
diet$Location_Region = gsub('Western to Central US and Alaska', 'United States; Alaska', diet$Location_Region)
diet$Location_Region = gsub('Wyoming, Utah', 'Wyoming; Utah', diet$Location_Region)
diet$Location_Region = gsub('Sucre, Venezuela', 'Sucre', diet$Location_Region)
diet$Location_Region = gsub('Central US', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Eastern US', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Northern Europe', 'Europe', diet$Location_Region)
diet$Location_Region = gsub('Willow: Most of US except Southeastern, Alder: Northeastern US and most of Canada', 'United States; Canada', diet$Location_Region)
diet$Location_Region = gsub('Western to Central US', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Western US, Canada', 'United States; Canada', diet$Location_Region)
diet$Location_Region = gsub('Central and Western United States', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Northern California', 'California', diet$Location_Region)
diet$Location_Region = gsub('Southwestern Kansas', 'Kansas', diet$Location_Region)
diet$Location_Region = gsub('West Haven, Vermont; other areas in Northeastern US', 'New England', diet$Location_Region)
diet$Location_Region = gsub('Western Finland', 'Finland', diet$Location_Region)
diet$Location_Region = gsub('Western Maine', 'Maine', diet$Location_Region)
diet$Location_Region = gsub('Western US', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Alaska and Virginia', 'Alaska; Virginia', diet$Location_Region)
diet$Location_Region = gsub('Northeastern Kansas', 'Kansas', diet$Location_Region)
diet$Location_Region = gsub('Southern Arizona', 'Arizona', diet$Location_Region)
diet$Location_Region = gsub('Texas and New Mexico', 'Texas; New Mexico', diet$Location_Region)
diet$Location_Region = gsub('US', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Central Arizona', 'Arizona', diet$Location_Region)
diet$Location_Region = gsub('Southern Texas and Arizona, Coastal Mexico, Central America', 'Texas; Arizona; Mexico; Central America', diet$Location_Region)
diet$Location_Region = gsub('Southern Wisconsin', 'Wisconsin', diet$Location_Region)
diet$Location_Region = gsub('Pantanal, Brazil', 'Pantanal', diet$Location_Region)
diet$Location_Region = gsub('Brittish Columbia', 'British Columbia', diet$Location_Region)
diet$Location_Region = gsub('Southern Arizona, Mexico, Central America', 'Arizona; Mexico; Central America', diet$Location_Region)
diet$Location_Region = gsub('Montana, Wyoming, Idaho, Washington, and Oregon', 'Montana; Wyoming; Idaho; Washington; Oregon', diet$Location_Region)
diet$Location_Region = gsub('New york, massachusetts, wisconsin', 'New York; Massachusetts; Wisconsin', diet$Location_Region)
diet$Location_Region = gsub('Southern Arizona to Central America', 'Arizona; Mexico; Central America', diet$Location_Region)
diet$Location_Region = gsub('Southern US, Mexico', 'United States; Mexico', diet$Location_Region)
diet$Location_Region = gsub('Alaska and Oregon', 'Alaska; Oregon', diet$Location_Region)
diet$Location_Region = gsub('Alabama, Florida, Louisiana, and Texas', 'Alabama; Florida; Louisiana; Texas', diet$Location_Region)
diet$Location_Region = gsub('Southern United States', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Southwest US and North Mexico', 'United States; Mexico', diet$Location_Region)
diet$Location_Region = gsub('Texas/Louisiana', 'Texas; Louisiana', diet$Location_Region)
diet$Location_Region = gsub('Western-Southern Mexico, South America', 'Mexico; South America', diet$Location_Region)
diet$Location_Region = gsub('Jalisco, Mexico', 'Jalisco', diet$Location_Region)
diet$Location_Region = gsub('Maryland, Michigan, New York, Pennsylvania, Ohio, Indiana, Kansas', 'Maryland; Michigan; New York; Pennsylvania; Ohio; Indiana; Kansas', diet$Location_Region)
diet$Location_Region = gsub('Northeastern Oregon; Blue Mountains', 'Oregon; Blue Mountains', diet$Location_Region)
diet$Location_Region = gsub('Southern Texas, Mexico', 'Texas; Mexico', diet$Location_Region)
diet$Location_Region = gsub('West Haven, Vermont', 'Vermont', diet$Location_Region)




#----------------------------------------------------------------------
# When done for the day, save your changes by writing the file:
write.table(diet, 'AvianDietDatabase.txt', sep = '\t', row.names = F)
# And don't forget to git commit and git push your changes