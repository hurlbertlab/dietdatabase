# 
library(dplyr)

# Read in files
# AOU species list from BBS:
spp = read.table('z:/lab/databases/bbs/species.txt', header=T, sep = '\t', quote = '')

# Species in reference list
refs = read.table('NA_avian_diet_refs.txt', header=T, sep = '\t', quote = '\"',
                  fill=T, stringsAsFactors = F)
refsp = unique(refs[, c('common_name', 'family')])

# Add lowercase name column to facilitate merging
spp$lowsp = tolower(spp$Common.Name.English)
refsp$lowsp = tolower(refsp$common_name)

bbs_not_db = anti_join(spp, refsp, by = 'lowsp')
db_not_bbs = anti_join(refsp, spp, by = 'lowsp')