# Historical database cleaning

# A record of all cleaning changes made to the Avian Diet Database.
olsen = read.table('NewDietDatabaseLines.txt', sep = '\t', header = T, quote = "\"", fill = T)

#Date: 9 Feb 2017; By: Patrick Winner
#Cleaning Location_Specific
olsen$Location_Specific = gsub('Forest, Arataye', 'Arataye', olsen$Location_Specific)

#Date: 13 Feb 2017; By: Patrick Winner
#Cleaning Location_Specific
olsen$Location_Specific = gsub('Chiloé Island', 'Chiloe Island', olsen$Location_Specific)
olsen$Location_Specific = gsub('Fraser Delta', 'Fraser River Delta', olsen$Location_Specific)
olsen$Location_Specific = gsub('delta', 'Delta', olsen$Location_Specific)
olsen$Location_Specific = gsub('island', 'Island', olsen$Location_Specific)
olsen$Location_Specific = gsub('La Provincia de �'uble', 'La Provincia de Nuble', olsen$Location_Specific)
olsen$Location_Specific = gsub('Manganuiateao', 'Manganuioteao', olsen$Location_Specific)
olsen$Location_Specific = gsub('Santuario de Fauna y Flora Otún Quimbaya', 'Santuario de Fauna y Flora Otun Quimbaya', olsen$Location_Specific)
olsen$Location_Specific = gsub('Yucatán Peninsula', 'Yucatan Peninsula', olsen$Location_Specific)
olsen$Location_Specific = gsub('lake', 'Lake', olsen$Location_Specific)

#Cleaning Habitat_type
olsen$Habitat_type = tolower(olsen$Habitat_type)
olsen$Habitat_type = gsub(' and', ';', olsen$Habitat_type)
olsen$Habitat_type = gsub('coasts', 'coast', olsen$Habitat_type)
olsen$Habitat_type = gsub('cornfields', 'agriculture', olsen$Habitat_type)
olsen$Habitat_type = gsub('estuaries; coast', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('estuary', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('floodplain', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('freshwater tidal marshes', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('grass meadows', 'grassland', olsen$Habitat_type)
olsen$Habitat_type = gsub('meander belt', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('peripheral wetland', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('rice fields', 'agriculture', olsen$Habitat_type)
olsen$Habitat_type = gsub('river delta', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('saltwater wetlands', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('tidal flats', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('tidal impoundments', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('tidal marsh', 'wetland', olsen$Habitat_type)

#Cleaning Prey_Stage
olsen$Prey_Stage = gsub('adults', 'adult', olsen$Prey_Stage)
olsen$Prey_Stage = gsub('eggs', 'egg', olsen$Prey_Stage)

#Cleaning Prey_Part
olsen$Prey_Part = gsub('seeds', 'seed', olsen$Prey_Part)
olsen$Prey_Part = gsub('acorns', 'acorn', olsen$Prey_Part)
olsen$Prey_Part = gsub('buds', 'bud', olsen$Prey_Part)
olsen$Prey_Part = gsub('aquatic roots', 'root', olsen$Prey_Part)
olsen$Prey_Part = gsub('aquatic seed', 'seed', olsen$Prey_Part)
olsen$Prey_Part = gsub('bulbils', 'bulbil', olsen$Prey_Part)
olsen$Prey_Part = gsub('bulbs', 'bulb', olsen$Prey_Part)
olsen$Prey_Part = gsub('caryopses', 'caryopsis', olsen$Prey_Part)
olsen$Prey_Part = gsub('catkins', 'catkin', olsen$Prey_Part)
olsen$Prey_Part = gsub('corms', 'corm', olsen$Prey_Part)
olsen$Prey_Part = gsub('cotyledons', 'cotyledon', olsen$Prey_Part)
olsen$Prey_Part = gsub('flower bud', 'bud', olsen$Prey_Part)
olsen$Prey_Part = gsub('flowering parts', 'flower', olsen$Prey_Part)
olsen$Prey_Part = gsub('flowers', 'flower', olsen$Prey_Part)
olsen$Prey_Part = gsub('fruits', 'fruit', olsen$Prey_Part)
olsen$Prey_Part = gsub('leaves', 'leaf', olsen$Prey_Part)
olsen$Prey_Part = gsub('nutlets', 'nutlet', olsen$Prey_Part)
olsen$Prey_Part = gsub('nuts', 'nut', olsen$Prey_Part)
olsen$Prey_Part = gsub('oogonia', 'oogonium', olsen$Prey_Part)
olsen$Prey_Part = gsub('oospores', 'oospore', olsen$Prey_Part)
olsen$Prey_Part = gsub('propagules', 'propagule', olsen$Prey_Part)
olsen$Prey_Part = gsub('rhizomes', 'rhizome', olsen$Prey_Part)
olsen$Prey_Part = gsub('roots', 'root', olsen$Prey_Part)
olsen$Prey_Part = gsub('seed heads', 'seedheads', olsen$Prey_Part)
olsen$Prey_Part = gsub('seedheads', 'seedhead', olsen$Prey_Part)
olsen$Prey_Part = gsub('seed pods', 'seedpod', olsen$Prey_Part)
olsen$Prey_Part = gsub('sporangia', 'sporangium', olsen$Prey_Part)
olsen$Prey_Part = gsub('spore cases', 'spore case', olsen$Prey_Part)
olsen$Prey_Part = gsub('spores', 'spore', olsen$Prey_Part)
olsen$Prey_Part = gsub('stamens', 'stamen', olsen$Prey_Part)
olsen$Prey_Part = gsub('stems', 'stem', olsen$Prey_Part)
olsen$Prey_Part = gsub('stolons', 'stolon', olsen$Prey_Part)
olsen$Prey_Part = gsub('tubercles', 'tubercle', olsen$Prey_Part)
olsen$Prey_Part = gsub('tubers', 'tuber', olsen$Prey_Part)
olsen$Prey_Part = gsub('achenes', 'achene', olsen$Prey_Part)
olsen$Prey_Part = gsub('roottalks', 'rootstalk', olsen$Prey_Part)
olsen$Prey_Part = gsub('roottocks', 'rootstock', olsen$Prey_Part)

#Cleaning Habitat_type
olsen$Habitat_type = gsub('coast', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('coastal lakes', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('coastal rivers', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('deep freshwater impoundment', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('fresh water', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('freshwater', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('interior lakes', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('lagoon', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('lake', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('marine', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('mostly salt water', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('river', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('salt water', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('wetlandal wetlands', 'wetland', olsen$Habitat_type)


#----------------------------------------------------------------------
# When done for the day, save your changes by writing the file:
write.table(olsen, 'NewDietDatabaseLines.txt', sep = '\t', row.names = F)
# And don't forget to git commit and git push your changes