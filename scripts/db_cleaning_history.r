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
diet$Habitat_type = gsub('shrubland', 'scrubland', diet$Habitat_type)
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





#----------------------------------------------------------------------
# When done for the day, save your changes by writing the file:
write.table(diet, 'AvianDietDatabase.txt', sep = '\t', row.names = F)
# And don't forget to git commit and git push your changes