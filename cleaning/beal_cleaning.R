install.packages(c('dplyr', 'stringr', 'tidyr'))

setwd('C:/git/dietdatabase')
source('scripts/database_summary_functions.R')

diet = read.table('aviandietdatabase.txt', header=T, sep = '\t', quote = '\"',
                  fill=T, stringsAsFactors = F)


beal = unique(diet[grep("Beal", diet$Source), c('Common_Name', 'Source')]) %>%
  arrange(Common_Name, study)

beal$study = substr(beal$Source, 1, 19)

beal[, c(1,3)]

