# Script for replacing typos and updating Name_Status field of
# the Hurlbert Lab's Avian Diet Database.

# Working from dietdatabase Git repository

dd = read.table('AvianDietDatabase.txt', sep = '\t', 
                quote = '\"', fill = T, header = T)

# Any names listed in the Name Report should get status changed to 'unknown'

# Need to make this grab the name report directly through rglobi
nameReport = read.table('name_report.txt', sep = '\t',
                        quote = '\"', fill = T, header = T)

badNames = nameReport$unmatched_name

dd$Name_Status[dd$Prey_Kingdom %in% badNames |
               dd$Prey_Phylum %in% badNames |
               dd$Prey_Class %in% badNames |
               dd$Prey_Order %in% badNames |
               dd$Prey_Suborder %in% badNames |
               dd$Prey_Family %in% badNames |
               dd$Prey_Genus %in% badNames |
               dd$Prey_Scientific_Name %in% badNames] = 'unknown'

write.table(dd, 'AvianDietDatabase.txt', sep = '\t', row.names = F)
