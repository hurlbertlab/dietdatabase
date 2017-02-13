# Historical database cleaning

# A record of all cleaning changes made to the Avian Diet Database.
olsen = read.table('NewDietDatabaseLines.txt', sep = '\t', header = T, quote = "", fill = T)

#Date: 9 Feb 2017; By: Patrick Winner
#Cleaning Location_Specific
olsen$Location_Specific = gsub('Forest, Arataye', 'Arataye', olsen$Location_Specific)




#----------------------------------------------------------------------
# When done for the day, save your changes by writing the file:
write.table(olsen, 'NewDietDatabaseLines.txt', sep = '\t', row.names = F)
# And don't forget to git commit and git push your changes