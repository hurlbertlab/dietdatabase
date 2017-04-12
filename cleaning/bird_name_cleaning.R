# Cleaning bird taxonomic names to be in line with the eBird Clements 2016 checklist.

library(dplyr)
library(stringr)

#-------------------------------------------------------------------------------------------                               
# Read in diet database and eBird taxonomy table
diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                  fill=T, stringsAsFactors = F)

# Make sure to grab the most recent eBird table in the directory
taxfiles = file.info(list.files()[grep('eBird', list.files())])
taxfiles$name = row.names(taxfiles)
tax = read.table(taxfiles$name[taxfiles$mtime == max(taxfiles$mtime)], header = T,
                 sep = ',', quote = '\"', stringsAsFactors = F)
tax$Family = word(tax$FAMILY, 1)

orders = unique(tax[, c('ORDER', 'FAMILY')])
orders$Family = word(orders$FAMILY, 1)
orders = filter(orders, FAMILY != "" & ORDER != "") %>%
  select(ORDER, Family)


db_spp = select(diet, Common_Name, Scientific_Name, Family) %>% unique()

# Find common names or scientific names that are unmatched with the eBird checklist
unmatched = anti_join(db_spp, tax, by = c("Common_Name" = "PRIMARY_COM_NAME"))

unmatchedsci = anti_join(db_spp, tax, by = c("Scientific_Name" = "SCI_NAME"))

unmatched2 = anti_join(db_spp, tax, by = c("Common_Name" = "PRIMARY_COM_NAME", "Scientific_Name" = "SCI_NAME"))

unmatched3 = anti_join(db_spp, tax, by = c("Common_Name" = "PRIMARY_COM_NAME", 
                                           "Scientific_Name" = "SCI_NAME",
                                           "Family" = "Family"))
