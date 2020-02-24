# Get a species list of North American birds based on the ABA checklist,
# and merge in families and orders from NACC (AOU).

# This requires manually cleaning/troubleshooting names that do not match between lists.
# This has been done and is included in the aba_to_ebird_taxonomy_conversion.csv,
# which might need to be updated with future list releases.

library(tidyverse)
library(devtools)
install_github('tidyverse/stringr')
library(stringr)

aba_ebird = read_csv('birdtaxonomy/aba_to_ebird_taxonomy_conversion.csv', col_names = T, quote = '\"')

ebird = read_csv('birdtaxonomy/eBird_Taxonomy_v2019.csv', col_names = T, quote = '\"') %>%
  rename(common_name = PRIMARY_COM_NAME, sci_name = SCI_NAME, order = ORDER1) %>%
  mutate(family = str_split_n(FAMILY, " ", 1)) %>%
  filter(CATEGORY == 'species') %>%
  select(common_name, sci_name, family, order)

aba = read_csv('birdtaxonomy/ABA_Checklist-8.0.6a.csv', skip = 2, quote = '\"', col_names = FALSE) %>%
  rename(common_name = X2, sci_name = X3) %>%
  select(common_name, sci_name) %>%
  filter(!is.na(common_name))

matched = aba %>%
  inner_join(ebird, by = c('common_name', 'sci_name'))

unmatched = aba_ebird %>%
  left_join(ebird, by = c('common_name.ebird' = 'common_name', 'sci_name.ebird' = 'sci_name')) %>%
  rename(common_name = common_name.ebird, sci_name = sci_name.ebird) %>%
  select(common_name, sci_name, family, order)

NA_specieslist = bind_rows(matched, unmatched) %>%
  arrange(order, family, sci_name)

write.csv(NA_specieslist, 'birdtaxonomy/NA_specieslist.csv', row.names = F)
