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
olsen$Habitat_type = gsub('peripheral floodplain', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('rice fields', 'agriculture', olsen$Habitat_type)
olsen$Habitat_type = gsub('river delta', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('saltwater wetlands', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('tidal flats', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('tidal impoundments', 'wetland', olsen$Habitat_type)
olsen$Habitat_type = gsub('tidal marsh', 'wetland', olsen$Habitat_type)

olsen$Habitat_type = gsub('', '', olsen$Habitat_type)



#----------------------------------------------------------------------
# When done for the day, save your changes by writing the file:
write.table(olsen, 'NewDietDatabaseLines.txt', sep = '\t', row.names = F)
# And don't forget to git commit and git push your changes