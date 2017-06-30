# Getting list of names that don't match between the current database and 
# an old version.

# Read in datasets
diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                  fill=T, stringsAsFactors = F)

olddiet = read.table('olddietdatabase.txt' ...)

list = anti_join(diet, olddiet) %>% select(Common_Name) %>% distinct()






# old
dnames = select(diet, Common_Name) %>% distinct()
oldnames = select(olddiet, Common_Name) %>% distinct()
