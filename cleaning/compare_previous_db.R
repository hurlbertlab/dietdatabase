# Getting list of names that don't match between the current database and 
# an old version. (Apr 13 2017 seems to be last time cleaning was done)

# Read in datasets
diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                  fill=T, stringsAsFactors = F)

olddiet = read.table('olddietdatabase.txt', header=T, sep = '\t', quote = '\"',
                     fill=T, stringsAsFactors = F)

list = anti_join(diet, olddiet) %>% select(Common_Name) %>% distinct()






# old
dnames = select(diet, Common_Name) %>% distinct()
oldnames = select(olddiet, Common_Name) %>% distinct()
