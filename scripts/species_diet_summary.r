# Species diet summary from Avian Diet Database

db = read.table('aviandietdatabase.txt', header = T, sep = '\t', quote = '\"', fill = T)

baea = subset(db, Common_Name=='Bald Eagle')

dim(baea)

names(baea)

# Which types of diet data are more prevalent for this species?
apply(baea[,30:33], 2, function(x) sum(!is.na(x)))

baea_items = subset(baea, !is.na(Fraction_Diet_By_Items))

table(baea_items$Prey_Class)

# Average fraction of diet by Prey Class
baea_prey = aggregate(baea_items$Fraction_Diet_By_Items, 
                      by = list(baea_items$Prey_Class), 
                      function(x) sum(x)/sum(baea_items$Fraction_Diet_By_Items))

baea_prey = baea_prey[order(baea_prey$x, decreasing = T),]

# Distribution of records across regions
regions = data.frame(table(baea$Location_Region))
regions = regions[regions$Freq != 0, ]
