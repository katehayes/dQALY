# this is set up like the eq5d package
# but would the below be simpler? not sure
# https://github.com/r-lib/usethis/issues/1512

root <- file.path(here::here(), "data-raw")

utility_norms <- read.csv(file.path(root, "utility_norms.csv"), row.names = 1L)
norm_info <- read.csv(file.path(root, "norm_info.csv"), row.names = 1L)
life_tables <- read.csv(file.path(root, "life_tables.csv"), row.names = 1L)
populations <- read.csv(file.path(root, "populations.csv"), row.names = 1L)


# Build sysdata.rda
usethis::use_data(
  utility_norms, norm_info, life_tables, populations,
  internal = TRUE,
  overwrite = TRUE
)
