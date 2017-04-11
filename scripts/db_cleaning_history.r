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

# Date: 23 Jan 2017; By: Patrick Winner

#Cleaning Location_Region
diet$Location_Region = gsub('Continental United States; Canada', 'United States; Canada', diet$Location_Region)
diet$Location_Region = gsub('Willow: Most of United States except Southeastern, Alder: United States; Canada', 'United States; Canada', diet$Location_Region)
diet$Location_Region = gsub('Texas (one bird from Florida)', 'Texas; Florida', diet$Location_Region)
diet$Location_Region = gsub('Continental United States', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Western to United States', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Central and United States', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Vermont; other areas in United States', 'United States', diet$Location_Region)
diet$Location_Region = gsub('Texas and Arizona, Coastal Mexico, Central America', 'Texas; Arizona; Mexico; Central America', diet$Location_Region)
diet$Location_Region = gsub('Arizona, Mexico, Central America', 'Arizona; Mexico; Central America', diet$Location_Region)
diet$Location_Region = gsub('New York, massachusetts, wisconsin', 'New York; Massachusetts; Wisconsin', diet$Location_Region)
diet$Location_Region = gsub('United States, Mexico', 'United States; Mexico', diet$Location_Region)
diet$Location_Region = gsub('Southwest United States and North Mexico', 'United States; Mexico', diet$Location_Region)
diet$Location_Region = gsub('Texas, Mexico', 'Texas; Mexico', diet$Location_Region)
diet$Location_Region = gsub('Arizona to Central America', 'Arizona; Mexico; Central America', diet$Location_Region)
diet$Location_Region = gsub('Texas (one bird from Florida)', 'Texas; Florida', diet$Location_Region)
diet$Location_Region = gsub('Oregon; Blue Mountains', 'Oregon', diet$Location_Region)

#Cleaning Location_Specific
diet$Location_Specific = gsub('12 US states (incl. Alaska) and Canada', 'NA', diet$Location_Specific)
diet$Location_Specific = gsub('13 US states (incl. Alaska) and Canada', 'NA', diet$Location_Specific)
diet$Location_Specific = gsub('14 US states and Canada', 'NA', diet$Location_Specific)
diet$Location_Specific = gsub('16 US states (incl. Alaska) and Canada', 'NA', diet$Location_Specific)
diet$Location_Specific = gsub('18 US states and Canada', 'NA', diet$Location_Specific)
diet$Location_Specific = gsub('28 US states (incl. Alaska & DC) and Canada', 'NA', diet$Location_Specific)
diet$Location_Specific = gsub('7 US states (incl. Texas)', 'NA', diet$Location_Specific)
diet$Location_Specific = gsub('Barrow, AK', 'Barrow', diet$Location_Specific)
diet$Location_Specific = gsub('Bill Williams River Delta, Arizona', 'Bill Williams River Delta', diet$Location_Specific)
diet$Location_Specific = gsub('Blue Mountains, Oregon', 'Blue Mountains', diet$Location_Specific)
diet$Location_Specific = gsub('Brook Experimental Forest, West Thornton', 'Hubbard Brook Experimental Forest', diet$Location_Specific)
diet$Location_Specific = gsub('Burke County, ND', 'Burke County', diet$Location_Specific)
diet$Location_Specific = gsub('Caparu Biological Station, Bolivia', 'Caparu Biological Station', diet$Location_Specific)


# Date: 24 Jan 2017; By: Patrick Winner

#Cleaning Location_Specific
diet$Location_Specific = gsub('Culberson County, Texas; Eddy and Otero Counties, New Mexico', 'Culberson County, TX; Eddy and Otero Counties, NM', diet$Location_Specific)
diet$Location_Specific = gsub('Dane, Sauk, and Columbia counties, WI', 'Dane, Sauk, and Columbia counties', diet$Location_Specific)
diet$Location_Specific = gsub('Dodge and Jefferson counties, WI', 'Dodge and Jefferson counties', diet$Location_Specific)
diet$Location_Specific = gsub('Esquatzel Coulee, Franklin County, WA', 'Esquatzel Coulee', diet$Location_Specific)
diet$Location_Specific = gsub('Everglades', 'Everglades National Park', diet$Location_Specific)
diet$Location_Specific = gsub('HEREDIA, HEREDIA PROVINCE', 'Heredia', diet$Location_Specific)
diet$Location_Specific = gsub('Ithica', 'Ithaca', diet$Location_Specific)
diet$Location_Specific = gsub('Jackson County, OK', 'Jackson County', diet$Location_Specific)
diet$Location_Specific = gsub('La Michilia', 'La Michilia Biosphere Reserve', diet$Location_Specific)
diet$Location_Specific = gsub('Larimer and Weld Counties, CO', 'Larimer and Weld Counties', diet$Location_Specific)
diet$Location_Specific = gsub('Lower Colorado valley', 'Lower Colorado River Valley', diet$Location_Specific)
diet$Location_Specific = gsub('Mexico', 'NA', diet$Location_Specific)
diet$Location_Specific = gsub('Norias Division of the King Ranch, Kennedy County, Texas', 'Norias Division of the King Ranch', diet$Location_Specific)
diet$Location_Specific = gsub('northern', 'Northern Chesapeake Bay', diet$Location_Specific)
diet$Location_Specific = gsub('Park and Sweetgrass Counies', 'Park and Sweetgrass Counties', diet$Location_Specific)
diet$Location_Specific = gsub('Rochester, Alberta, Canada', 'Rochester', diet$Location_Specific)

#Date: 26 Jan 2017; By: Patrick Winner

#Cleaning Location_Specific
diet$Location_Specific = gsub('SAN ISIDRO, SAN JOSE PROVINCE', 'San Isidro, San Jose Province', diet$Location_Specific)
diet$Location_Specific = gsub('San Joacquin Experimental Range, CA', 'San Joaquin Experimental Range', diet$Location_Specific)
diet$Location_Specific = gsub('Spruce Siding, MB, Canada and Roseau Bog, MN, USA', 'Spruce Siding, MB; Roseau Bog, MN', diet$Location_Specific)
diet$Location_Specific = gsub('Stutsman, Kidder, Logan, and Burleigh counties.', 'Stutsman, Kidder, Logan, and Burleigh counties', diet$Location_Specific)
diet$Location_Specific = gsub('TABOGA, GUANACASTE PROVINCE', 'Taboga, Guanacaste Province', diet$Location_Specific)
diet$Location_Specific = gsub('Trans-Peco region', 'Trans-Pecos', diet$Location_Specific)
diet$Location_Specific = gsub('Trans-Pecos, Texas', 'Trans-Pecos', diet$Location_Specific)
diet$Location_Specific = gsub('Tule Lake National Wildlife Refuge, CA', 'Tule Lake National Wildlife Refuge', diet$Location_Specific)
diet$Location_Specific = gsub('Turbialba, Cartago Province', 'Turrialba, Cartago Province', diet$Location_Specific)
diet$Location_Specific = gsub('TURRIALBA, CARTAGO PROVINCE', 'Turrialba, Cartago Province', diet$Location_Specific)
diet$Location_Specific = gsub('Tuscon (rural)', 'Tucson Metropolitan Area', diet$Location_Specific)
diet$Location_Specific = gsub('Tuscon Metropolitan Area', 'Tucson Metropolitan Area', diet$Location_Specific)

#Cleaning Habitat_Type
diet$Habitat_type = gsub('Agriculture', 'agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('Agriculture, deciduous forest', 'agriculture; deciduous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Agriculture, scrubland', 'agriculture; shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('Agriculture; desert', 'agriculture; desert', diet$Habitat_type)
diet$Habitat_type = gsub('Agriculture; marsh', 'agriculture; wetland', diet$Habitat_type)
diet$Habitat_type = gsub('agriculture; scrubland', 'agriculture; shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('Agriculture; shrubland', 'agriculture; shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('Agriculture; wetland', 'agriculture; wetland', diet$Habitat_type)
diet$Habitat_type = gsub('Ariculture; woodland', 'agriculture; woodland', diet$Habitat_type)
diet$Habitat_type = gsub('Boreal forest', 'coniferous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Boreal Forest', 'coniferous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Conifer forest', 'coniferous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Conifer forest, mountain shrubland, and shrubsteppe', 'coniferous forest; shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('Conifer; deciduous forest', 'coniferous forest; deciduous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Coniferous forest', 'coniferous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Coniferous forest, grassland', 'coniferous forest; grassland', diet$Habitat_type)
diet$Habitat_type = gsub('Coniferous forest, woodland', 'coniferous forest; woodland', diet$Habitat_type)
diet$Habitat_type = gsub('Coniferous forest, woodland, wetland', 'coniferous forest; woodland; wetland', diet$Habitat_type)
diet$Habitat_type = gsub('Coniferous forest; agriculture', 'coniferous forest; agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('Coniferous forest; deciduous forest; agriculture', 'coniferous forest; deciduous forest; agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('coniferous forest; woodland; shrubland;', 'coniferous forest; woodland; shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('Cool, shady and mountainous forests', 'forest', diet$Habitat_type)
diet$Habitat_type = gsub('Corn fields, marshland and open fields', 'agriculture; wetland', diet$Habitat_type)
diet$Habitat_type = gsub('Deciduous', 'deciduous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Deciduous forest', 'deciduous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Deciduous forest, agriculture', 'deciduous forest; agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('Deciduous, semi-deciduous forest', 'deciduous forest; forest', diet$Habitat_type)
diet$Habitat_type = gsub('evergreen forest', 'coniferous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Forest', 'forest', diet$Habitat_type)
diet$Habitat_type = gsub('Forest ', 'forest', diet$Habitat_type)
diet$Habitat_type = gsub('Forest; agriculture; wetland; urban', 'forest; agriculture; wetland; urban', diet$Habitat_type)
diet$Habitat_type = gsub('Forest; grassland; wetland', 'forest; grassland; wetland', diet$Habitat_type)
diet$Habitat_type = gsub('forest; grove; swamp', 'forest; wetland', diet$Habitat_type)
diet$Habitat_type = gsub('forest; swamp', 'forest; wetland', diet$Habitat_type)
diet$Habitat_type = gsub('Forest; urban', 'forest; urban', diet$Habitat_type)
diet$Habitat_type = gsub('Grassland', 'grassland', diet$Habitat_type)
diet$Habitat_type = gsub('Grassland, agriculture', 'grassland; agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('Grassland, shrubland', 'grassland; shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('Grassland; Agriculture', 'grassland; agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('grassland; scrubland', 'grassland; shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('Grassland; scrubland', 'grassland; shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('grassland; scrubland; agriculture', 'grassland; shrubland; agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('grassland; scrubland; woodland', 'grassland; shrubland; woodland', diet$Habitat_type)
diet$Habitat_type = gsub('grassland; woodland; scrubland; agriculture', 'grassland; woodland; shrubland; agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('long-leaf and loblolly pine forest', 'coniferous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Juniper Oak Forest', 'forest', diet$Habitat_type)
diet$Habitat_type = gsub('Mesquite woodlands, gray-thorn understory', 'woodland; shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('Mixed woodland; grassland', 'woodland; grassland', diet$Habitat_type)
diet$Habitat_type = gsub('Multiple', 'multiple', diet$Habitat_type)
diet$Habitat_type = gsub('Northern Hardwood Forest', 'deciduous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Oak and pine forest', 'forest', diet$Habitat_type)
diet$Habitat_type = gsub('Open riparian cottonwood woodland', 'woodland', diet$Habitat_type)
diet$Habitat_type = gsub('Pin oak forest', 'deciduous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Prairies with scattered trees', 'grassland', diet$Habitat_type)
diet$Habitat_type = gsub('scrubland', 'shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('Scrubland', 'shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('scrubland; agriculture', 'shrubland; agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('scrubland; forest', 'shrubland; forest', diet$Habitat_type)
diet$Habitat_type = gsub('scrubland;grassland', 'shrubland; grassland', diet$Habitat_type)
diet$Habitat_type = gsub('deciduous forest forest', 'deciduous forest', diet$Habitat_type)


# Date: 30 Jan 2017; By: Patrick Winner
#Cleaning Location_Specific
diet$Location_Specific = gsub('Everglades National Park National Park', 'Everglades National Park', diet$Location_Specific)

# Subset db to where Location_Region is "United States"
new_regions = diet$Location_Specific[diet$Location_Region == "United States" &
                                           !diet$Location_Specific %in% c(NA, "", "multiple", "Multiple")]
new_region_indices = which(diet$Location_Region == "United States" &
                                           !diet$Location_Specific %in% c(NA, "", "multiple", "Multiple"))

diet$Location_Region[new_region_indices] = new_regions
diet$Location_Specific[new_region_indices] = NA

#Cleaning Location_Specific
diet$Location_Specific = gsub('eastern shore', 'Eastern Shore of Maryland', diet$Location_Specific)
diet$Location_Specific = gsub('La Michilia Biosphere Reserve Biosphere Reserve', 'La Michilia Biosphere Reserve', diet$Location_Specific)
diet$Location_Specific = gsub('Northeast', 'Northeast Mexico', diet$Location_Specific)
diet$Location_Specific = gsub('Snake River Canyon; scrubland', 'Snake River Canyon', diet$Location_Specific)

#Cleaning Habitat_type
diet$Habitat_type = gsub('agriculture, grassland', 'agriculture; grassland', diet$Habitat_type)
diet$Habitat_type = gsub('agriculture, shrubland', 'agriculture; scrubland', diet$Habitat_type)
diet$Habitat_type = gsub('coniferous forest, grassland', 'coniferous forest; grassland', diet$Habitat_type)
diet$Habitat_type = gsub('coniferous forest; mountain scrubland; and shrubsteppe', 'coniferous forest; scrubland', diet$Habitat_type)
diet$Habitat_type = gsub('coniferous forest, woodland', 'coniferous forest; woodland', diet$Habitat_type)
diet$Habitat_type = gsub('coniferous forest, woodland, wetland', 'coniferous forest; woodland; wetland', diet$Habitat_type)
diet$Habitat_type = gsub('deciduous forest woodland; coniferous woodland; wetland; riparian', 'deciduous forest; coniferous forest; woodland; wetland; riparian', diet$Habitat_type)
diet$Habitat_type = gsub('deciduous forest, agriculture', 'deciduous forest; agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('deciduous forest, semi-deciduous forest', 'deciduous forest; forest', diet$Habitat_type)
diet$Habitat_type = gsub('grassland, agriculture', 'agriculture; grassland', diet$Habitat_type)
diet$Habitat_type = gsub('grassland, shrubland', 'grassland; scrubland', diet$Habitat_type)
diet$Habitat_type = gsub('scrubland', 'shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('Juniper Oak forest', 'forest', diet$Habitat_type)
diet$Habitat_type = gsub('Mesquite-acacia woodlands', 'woodland', diet$Habitat_type)

#Date: 31 Jan 2017; By: Patrick Winner
#Cleaning Habitat_type
diet$Habitat_type = gsub(',', ';', diet$Habitat_type)
diet$Habitat_type = gsub('forest ', 'forest', diet$Habitat_type)
diet$Habitat_type = gsub('conifer forests', 'coniferous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Northern Hardwood forest', 'deciduous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Primarily Cottonwood; Willow and Salt cedar forest', 'forest', diet$Habitat_type)
diet$Habitat_type = gsub('Riparian woodlands', 'woodland', diet$Habitat_type)
diet$Habitat_type = gsub('scrubland;grassland', 'grassland; scrubland', diet$Habitat_type)
diet$Habitat_type = gsub('Shrub and grassland', 'grassland; scrubland', diet$Habitat_type)
diet$Habitat_type = gsub('shade coffee; second-growth scrub; and undisturbed dry limestone forest', 'scrubland; forest', diet$Habitat_type)
diet$Habitat_type = gsub('Sugar maple; American beech; Yellow birch', 'deciduous forest', diet$Habitat_type)
diet$Habitat_type = gsub('Thick hardwoods - primarily Yellow birch and Sugar maple. forestfloor composed primarily of dead leaves', 'deciduous forest', diet$Habitat_type)
diet$Habitat_type = gsub('ungrazed grassland', 'grassland', diet$Habitat_type)
diet$Habitat_type = gsub('Upland deciduous forest. Primarily white oak; red oak; black oak and shagbark hickory', 'deciduous forest', diet$Habitat_type)
diet$Habitat_type = gsub('upland forest; sagebrush grassland; floodplain forest; and agricultural lands', 'forest; grassland; scrubland; agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('Urban', 'urban', diet$Habitat_type)
diet$Habitat_type = gsub('Wetland', 'wetland', diet$Habitat_type)
diet$Habitat_type = gsub('Woodland', 'woodland', diet$Habitat_type)
diet$Habitat_type = gsub('woodland;grassland', 'woodland; grassland', diet$Habitat_type)
diet$Habitat_type = gsub('Woodlands', 'woodland', diet$Habitat_type)
diet$Habitat_type = gsub('Woolands', 'woodland', diet$Habitat_type)
diet$Habitat_type = gsub('Zone of transition from tall-grass prairie to short-grass prairie', 'grassland', diet$Habitat_type)
diet$Habitat_type = gsub('woodlands', 'woodland', diet$Habitat_type)

#Cleaning Observation_Season
diet$Observation_Season = gsub('fall', 'Fall', diet$Observation_Season)
diet$Observation_Season = gsub('spring', 'Spring', diet$Observation_Season)
diet$Observation_Season = gsub('summer', 'Summer', diet$Observation_Season)
diet$Observation_Season = gsub('winter', 'Winter', diet$Observation_Season)
diet$Observation_Season = gsub('/', ';', diet$Observation_Season)
diet$Observation_Season = gsub('Spring;Summer', 'Spring; Summer', diet$Observation_Season)
diet$Observation_Season = gsub('Autumn', 'Fall', diet$Observation_Season)
diet$Observation_Season = gsub(' &', ';', diet$Observation_Season)
diet$Observation_Season = gsub('multiple', 'Multiple', diet$Observation_Season)
diet$Observation_Season = gsub('Winter ', 'Winter', diet$Observation_Season)
diet$Observation_Season = gsub('Late Spring; Summer;Early Fall', 'Spring; Summer; Fall', diet$Observation_Season)
diet$Observation_Season = gsub('Fall;Spring', 'Fall; Spring', diet$Observation_Season)
diet$Observation_Season = gsub('Summer;Fall', 'Summer; Fall', diet$Observation_Season)
diet$Observation_Season = gsub(' and', ';', diet$Observation_Season)
diet$Observation_Season = gsub('Summers', 'Summer', diet$Observation_Season)
diet$Observation_Season = gsub('Fall;Winter', 'Fall; Winter', diet$Observation_Season)
diet$Observation_Season = gsub(',', ';', diet$Observation_Season)
diet$Observation_Season = gsub('Winter; Spring;; Fall', 'Winter; Spring; Fall', diet$Observation_Season)

#Cleaning Prey_Stage
diet$Prey_Stage = gsub('Larvae', 'larvae', diet$Prey_Stage)
diet$Prey_Stage = gsub('Adult', 'adult', diet$Prey_Stage)
diet$Prey_Stage = gsub('/', '; ', diet$Prey_Stage)
diet$Prey_Stage = gsub('pupae; larvae', 'larvae; pupae', diet$Prey_Stage)
diet$Prey_Stage = gsub('Pupae', 'pupae', diet$Prey_Stage)
diet$Prey_Stage = gsub(' and', ';', diet$Prey_Stage)
diet$Prey_Stage = gsub('Egg', 'egg', diet$Prey_Stage)
diet$Prey_Stage = gsub('Caterpillar', 'larvae', diet$Prey_Stage)
diet$Prey_Stage = gsub('Larva', 'larvae', diet$Prey_Stage)
diet$Prey_Stage = gsub('Eggs', 'eggs', diet$Prey_Stage)
diet$Prey_Stage = gsub('Juvenile', 'juvenile', diet$Prey_Stage)
diet$Prey_Stage = gsub('Young', 'young', diet$Prey_Stage)
diet$Prey_Stage = gsub(',', ';', diet$Prey_Stage)
diet$Prey_Stage = gsub('Larval', 'larvae', diet$Prey_Stage)
diet$Prey_Stage = gsub('larva', 'larvae', diet$Prey_Stage)
diet$Prey_Stage = gsub('adult; larvae;pupae', 'adult; larvae; pupae', diet$Prey_Stage)
diet$Prey_Stage = gsub('larve', 'larvae', diet$Prey_Stage)
diet$Prey_Stage = gsub('Adults', 'adult', diet$Prey_Stage)
diet$Prey_Stage = gsub('Fledgling', 'fledgling', diet$Prey_Stage)
diet$Prey_Stage = gsub('Egg Case', 'egg case', diet$Prey_Stage)
diet$Prey_Stage = gsub('larvaee', 'larvae', diet$Prey_Stage)
diet$Prey_Stage = gsub('adults', 'adult', diet$Prey_Stage)
diet$Prey_Stage = gsub('eggs', 'egg', diet$Prey_Stage)
diet$Prey_Stage = gsub('shells', 'shell', diet$Prey_Stage)
diet$Prey_Stage = gsub('larvael', 'larvae', diet$Prey_Stage)
diet$Prey_Stage = gsub('egg Case', 'egg case', diet$Prey_Stage)

#Date: 2 Feb 2017; By: Patrick Winner
#Cleaning Prey_Stage
diet$Prey_Stage = tolower(diet$Prey_Stage)
diet$Prey_Stage = gsub('both', 'larvae; adult', diet$Prey_Stage)

#Cleaning Prey_Part
diet$Prey_Part = tolower(diet$Prey_Part)
diet$Prey_Part = gsub('seeds', 'seed', diet$Prey_Part)
diet$Prey_Part = gsub('fruits', 'fruit', diet$Prey_Part)
diet$Prey_Part = gsub('flowers', 'flower', diet$Prey_Part)
diet$Prey_Part = gsub('/', '; ', diet$Prey_Part)
diet$Prey_Part = gsub(' and', ';', diet$Prey_Part)
diet$Prey_Part = gsub('offal;afterbirth', 'offal; afterbirth', diet$Prey_Part)
diet$Prey_Part = gsub(',', ';', diet$Prey_Part)
diet$Prey_Part = gsub('feathers', 'feather', diet$Prey_Part)
diet$Prey_Part = gsub('nuts', 'nut', diet$Prey_Part)
diet$Prey_Part = gsub('buds', 'bud', diet$Prey_Part)
diet$Prey_Part = gsub('mandibles', 'mandible', diet$Prey_Part)

#Date: 6 Feb 2017; By: Patrick Winner
#Cleaning Prey_Stage
diet$Prey_Stage = gsub('larva; pupae; adult', 'larvae; pupae; adult', diet$Prey_Stage)
diet$Prey_Part = gsub('bones', 'bone', diet$Prey_Part)
diet$Prey_Part = gsub('fibers', 'fiber', diet$Prey_Part)
diet$Prey_Part = gsub('some fruit', 'fruit', diet$Prey_Part)

#Cleaning Study_Type 

diet$Study_Type = tolower(diet$Study_Type)
diet$Study_Type = gsub('observance', 'observation', diet$Study_Type)
diet$Study_Type = gsub(',', ';', diet$Study_Type)
diet$Study_Type = gsub(' and', ';', diet$Study_Type)
diet$Study_Type = gsub('/', '; ', diet$Study_Type)
diet$Study_Type = gsub('examinations', 'examination', diet$Study_Type)
diet$Study_Type = gsub('observations', 'observation', diet$Study_Type)
diet$Study_Type = gsub('fecal contents', 'fecal examination', diet$Study_Type)


#Date: 7 Feb 2017; By: Patrick Winner
#Fixing previous subbing of scrubland for shrubland
diet$Habitat_type = gsub('scrubland', 'shrubland', diet$Habitat_type)
#Cleaning Habitat_type
diet$Habitat_type = tolower(diet$Habitat_type)

#Cleaning Study Type
diet$Study_Type = gsub('stomach contents; mcatee describes notes made by beal in his work; with a smaller sample of birds', 'stomach contents', diet$Study_Type)

#Date: 14 Feb 2017; By: Patrick Winner
#Cleaning Habitat_type
diet$Habitat_type = gsub('marsh', 'wetland', diet$Habitat_type)
diet$Habitat_type = gsub('agriculture; orchard', 'agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('orchard', 'agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('brush', 'shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('shrublandland', 'shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('bushy thickets; near streams', 'shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('cactus or riparian communties', 'wetland', diet$Habitat_type)
diet$Habitat_type = gsub('coastal mangroves and trees', 'wetland', diet$Habitat_type)
diet$Habitat_type = gsub('orchards', 'agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('foresttrees', 'forest', diet$Habitat_type)
diet$Habitat_type = gsub('edge and open country', 'grassland', diet$Habitat_type)
diet$Habitat_type = gsub('edge of forests; open groves', 'woodland', diet$Habitat_type)
diet$Habitat_type = gsub('forests; open groves; orchards', 'forest; woodland; agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('groves', 'woodland', diet$Habitat_type)
diet$Habitat_type = gsub('thickets', 'shrubland', diet$Habitat_type)
diet$Habitat_type = gsub('hilly open area; nest in trees', 'grassland; woodland', diet$Habitat_type)
diet$Habitat_type = gsub('scattered trees', 'woodland', diet$Habitat_type)
diet$Habitat_type = gsub('residential areas', 'urban', diet$Habitat_type)
diet$Habitat_type = gsub('gardens', 'agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('mangrove forest', 'wetland', diet$Habitat_type)
diet$Habitat_type = gsub('open parklike country', 'grassland', diet$Habitat_type)
diet$Habitat_type = gsub('open; sometimes forest', 'grassland; forest', diet$Habitat_type)
diet$Habitat_type = gsub(' and', ';', diet$Habitat_type)
diet$Habitat_type = gsub('open pastures', 'grassland', diet$Habitat_type)
diet$Habitat_type = gsub('primarily bushes near water courses and fields', 'shrubland; grassland', diet$Habitat_type)
diet$Habitat_type = gsub('forestedges', 'forest', diet$Habitat_type)
diet$Habitat_type = gsub('agricultures', 'agriculture', diet$Habitat_type)
diet$Habitat_type = gsub('grasslands', 'grassland', diet$Habitat_type)
diet$Habitat_type = gsub('forests', 'forest', diet$Habitat_type)

#Cleaning Prey_Part
diet$Prey_Part = gsub('catkins', 'catkin', diet$Prey_Part)
diet$Prey_Part = gsub('leaves', 'leaf', diet$Prey_Part)


#Date: 21 Feb 2017; By: Allen Hurlbert

# Assign Prey_Phylum = 'Foraminifera' for all records where common name is foraminifera
diet$Prey_Phylum[diet$Prey_Common_Name == 'foraminifera'] = 'Foraminifera'
diet$Prey_Kingdom[diet$Prey_Common_Name == 'algae'] = 'Plantae'

# Use Kingdoms 'Animalia' and 'Plantae' instead of 'Metazoa' and 'Viridiplantae'
diet$Prey_Kingdom[diet$Prey_Kingdom == 'Metazoa'] = 'Animalia'
diet$Prey_Kingdom[diet$Prey_Kingdom == 'Animali'] = 'Animalia'
diet$Prey_Kingdom[diet$Prey_Kingdom == 'Viridiplantae'] = 'Plantae'
diet$Prey_Family[diet$Prey_Phylum == 'Graminea'] = 'Poaceae'
diet$Prey_Order[diet$Prey_Phylum == 'Graminea'] = 'Poales'
diet$Prey_Class[diet$Prey_Phylum == 'Graminea'] = 'Magnoliopsida'
diet$Prey_Phylum[diet$Prey_Phylum == 'Graminea'] = ''

diet$Subspecies[diet$Subspecies == ""] = NA


#Date: 29 March 2017; By: Allen Hurlbert
# This script must be run interactively because of input required by taxize

clean_phy = clean_names('Phylum')

# ITIS options when multiple names match:
# Chlorophyta: 1 (5414)

clean_cl = clean_names('Class', diet = clean_phy$diet, problemNames = clean_phy$badnames)

# ITIS options when multiple names match:
# Clitellata: 2 (914165)
# Oligochaeta: 3 (914193)
# Collembola: 2( 914185)
# Polychaeta: 15 (914166)

clean_or = clean_names('Order', diet = clean_cl$diet, problemNames = clean_cl$badnames)

# ITIS options when multiple names match:
# Chelonia: NA (not an Order, should be Testudines)
# Oligochaeta: 3 (914193)
# Scorpionida: NA (should be Scorpiones)
# Mantodea: 2 (914220)
# Aranae: NA (should be Araneae)
# Lepidoptera : NA (remove trailing space)
# Acarina : NA (remove trailing space)
# Other: NA

clean_fa = clean_names('Family', diet = clean_or$diet, problemNames = clean_or$badnames)

# ITIS options when multiple names match:
# Aphidae: NA
# Jassidae: NA (should be Cicadellidae)
# Scatophagidae: NA (should be Scathophagidae)
# Geridae: NA (should be Gerridae)
# Argidae: 1 (152757)
# Sphaeriidae: NA (should be Pisidiidae)

write.table(clean_fa$diet, 'cleaning/phy_cla_ord_fam_cleaned_db.txt', 
            sep = '\t', row.names = F)
write.table(clean_fa$badnames, 'cleaning/phy_cla_ord_fam_cleaning.txt', 
            sep = '\t', row.names = F)
# This latter file was gone through by hand to determine how each problem 
# name should be dealt with. This was saved as phy_cla_ord_fam_problemnames.txt

for (n in 1:ncol(clean_fa$diet)) {
  clean_fa$diet[, n] = str_trim(clean_fa$diet[, n])
}

clean_ge = clean_names('Genus', diet = clean_fa$diet)


# ITIS options when multiple names match:
# Micropterus: 13 (168158)
# Passer: 51 (179627) #INITIALLY 'CLEANED' USING WRONG TAXIZE #
# Avena: 26 (41455)
# Limnophila: 17 (33634) #INITIALLY 'CLEANED' USING WRONG TAXIZE #
# Paniscus: NA (should be Ophion)
# Bouteloua: 1 (41491) #probably ok but check
# Elymus: 17 (40677) #probably ok but check
# Ficus: 166 (19081) #INITIALLY 'CLEANED' USING WRONG TAXIZE #
# Morus: 34 (19064) #INITIALLY 'CLEANED' USING WRONG TAXIZE #
# Siren: 35 (773312) #INITIALLY 'CLEANED' USING WRONG TAXIZE #
# Sida: 842 (21725)
# Chloris: 51 (41552)
# Graminea: NA (should be blank)
# Stellaria: 11 (20163)
# Bromus: 9 (40478)
# Digitaria: 4 (203845)
# Triodia: NA (should be blank)
# Choris: NA (should be Chloris)
# Arenaria: 19 (20235)
# grass: NA
# Ulmus: 4 (19048)
# Iris: ?? (43191) #cant find taxize #, but 1 record is correctly classified
# Bembidium: NA (should be Bembidion)
# Macrops: NA (should be Listronotus)
# Tomicus: NA (Family should be Curculionidae, replace with blank, no ITIS match)
# Pimpla: NA (Family should be Ichneumonidae, no ITIS match)
# Ophion: NA (Family should be Ichneumonidae, no ITIS match)
# Scymnus: 35 (187044)
# Ichneumon: NA (Family should be Ichneumonidae, no ITIS match)
# Scambus: NA (Family should be Ichneumonidae, no ITIS match)
# Stictocephalus: NA (Family should be Membracidae, no ITIS match)
# Pamera: NA (Family should be Rhyparochromidae, no ITIS match)
# Olyra: 13 (41963)
# Melanophthalma: NA (Family should be Latridiidae, no ITIS match)
# Choristoneura: NA (should be Archips)
# Lagurus: 8 (180354)
# Bolboceras: NA (Family should be Geotrupidae, no ITIS match)
# Lycopus: 1 (32253)
# Evarthrus: 1 (931447) (actually Cyclotrachelus)
# Agonoderus: NA (should be Pterostichus)
# Opatrinus: NA (Family should be Tenebrionidae, no ITIS match)
# Amnesia: NA (Family should be Curculionidae, no ITIS match)
# Sitones: NA (should be Sitona)
# Cleonus: NA (should be Cleonis)
# Balaninus: NA (should be Curculio)
# Alsine: NA (should be Stellaria (taxize #11))
# Byrrhus: 4 (728016)
# Chaetophora: 4 (728026)
# Diplotaxis: 2 (926466)
# Halticus: 3 (105712)
# Gastroidea: NA (should be Gastrophysa)
# Staphylinus: NA (Family should be Staphylinidae, no ITIS match)
# Deromyia: NA (Family should be Asilidae, no ITIS match)
# Odynerus: NA (Family should be Vespidae, no ITIS match)
# Cryptus: NA (Family should be Ichneumonidae, no ITIS match)
# Ammophila: 5 (40447)
# Pompilus: NA (should be Anoplius)
# Tettix: NA (should be Tetrix)
# Pteromalus: NA (should be Eupteromalus)
# Hemiteles: 3 (153373)
# Elater: NA (Family should be Elateridae, no ITIS match)
# Tortrix: NA (Family should be Tortricidae, no ITIS match)
# Callitriche: 2 (32051)
# Griselinia: NA (Family should be Griseliniaceae, no ITIS match)
# Ceratophallus: NA (Family should be Planorbidae, no ITIS match)
# Tridens: 101 (42220)
# Xanthocnemis: NA (Family should be Coenagrionidae, no ITIS match)
# Gilia: 98 (31075)
# Chrysochlamys: NA (Family should be Clusiaceae, no ITIS match)
# Podolepis: NA (Family should be Asteraceae)
# Pontogeneia: 1 (93720)
# Cucumaria: 1 (158191)
# Bassia: 2 (20586)
# Sphaerium: 19 (81391)
# Citronella: NA (Family should be Cardiopteridaceae, no ITIS match)

write.table(clean_ge$diet, 'cleaning/phy_cla_ord_fam_gen_cleaned_db.txt', 
            sep = '\t', row.names = F)
write.table(clean_ge$badnames, 'cleaning/phy_cla_ord_fam_gen_cleaning.txt', 
            sep = '\t', row.names = F)


clean_sp = clean_names('Scientific_Name', diet = clean_ge$diet)

write.table(clean_sp$diet, 'cleaning/phy_cla_ord_fam_gen_spp_cleaned_db.txt', 
            sep = '\t', row.names = F)
write.table(clean_ge$badnames, 'cleaning/phy_cla_ord_fam_gen_spp_cleaning.txt', 
            sep = '\t', row.names = F)





diet = clean_fa$diet

# For each problem name, replace or fix record as needed
probnames = read.table('cleaning/phy_cla_ord_fam_problemnames.txt',
                       header = T, sep = '\t', quote = '\"', stringsAsFactors = F)
probnames$taxonLevel = paste('Prey_', probnames$level, sep = '')

taxlevels = data.frame(level = c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 
                                 'Family', 'Genus', 'Scientific_Name'),
                       levelnum = 19:26)

probnames = left_join(probnames, taxlevels)

for (i in 1:nrow(probnames)) {
  
  level = probnames$levelnum[i]
  taxonLevel = probnames$taxonLevel[i]
  
  # Check that all names below the taxonomic level specified are blank or NA
  if (level < 25) {
    lowerLevelCheck = rowSums(is.na(diet[, (level+1):26]) | diet[, (level+1):26] == "") == (26 - level)
  } else if (level == 25) {
    lowerLevelCheck = is.na(diet[, (level+1):26]) | diet[, (level+1):26] == ""
  } else if (level == 26) {
    lowerLevelCheck = TRUE
  }
  
  recs = which(!is.na(diet[, taxonLevel]) & diet[,taxonLevel] == probnames$name[i] & lowerLevelCheck)
  
  if (probnames$notes[i] != "keep as is") {
    diet[recs, level] = probnames$replacewith[i]
    print(paste("Replaced", probnames$name[i], "with", probnames$replacewith[i]))
  }

  if (!(probnames$notes[i] == "" | probnames$notes[i] == "keep as is")) {
  
    if (grepl("&", probnames$notes[i])) {
      split = unlist(strsplit(probnames$notes[i], " & "))
      for (j in split) {
        note = unlist(strsplit(j, " = "))
        diet[recs, paste('Prey_', note[1], sep = '')] = note[2]
        print(paste("Assigned", note[2], "to Prey", note[1]))
      }
    } else {
      note = unlist(strsplit(probnames$notes[i], " = "))
      
      diet[recs, paste('Prey_', note[1], sep = '')] = note[2]
      print(paste("Assigned", note[2], "to Prey", note[1]))
    }
    rm(note)
  }      
  print(paste(i, "out of", nrow(probnames)))
}



# Cleaning Sites column
diet$Sites[diet$Sites %in% c('multiple', 'Multiple', '')] = NA
diet$Sites = as.numeric(diet$Sites)

#----------------------------------------------------------------------
# When done for the day, save your changes by writing the file:
write.table(diet, 'AvianDietDatabase.txt', sep = '\t', row.names = F)
# And don't forget to git commit and git push your changes