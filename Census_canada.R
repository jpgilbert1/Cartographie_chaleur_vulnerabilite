
install.packages("cancensus")

library(cancensus)

options(cancensus.api_key = "CensusMapper_c675492d5573663989d1712af729a53d")

census_data <- get_census(dataset='CA16', regions=list(CMA="24421"),
                          
                          level='DB', use_cache = FALSE, geo_format = NA)

e <- list_census_regions("CA16")

options(cancensus.cache_path = "custom cache path")