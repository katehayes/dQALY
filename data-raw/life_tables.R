root <- file.path(here::here(), "data-raw")
utility_norms <- as.data.table(read.csv(file.path(root, "utility_norms.csv"), row.names = 1L))


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# English life tables from ONS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables/current/nlte198020213.xlsx",
              temp, mode = "wb")

eng_lt <- data.table(sex = character(), age = integer(), qx = numeric(), year = integer(), country = character())

for (n in 5:9) {

  lt_male <- as.data.table(readxl::read_xlsx(temp, sheet = n, range = "A6:F107"))
  lt_male[, sex := "male"]


  lt_female <- as.data.table(readxl::read_xlsx(temp, sheet = n, range = "H6:M107"))
  lt_female[, sex := "female"]

  lt_temp <- rbind(lt_male[, .(sex, age, qx)], lt_female[, .(sex, age, qx)])

  lt_temp[, year := 2022-(n-5)]
  lt_temp[, country := "England"]

  eng_lt  <- eng_lt |>
    rbind(lt_temp)

}


eng_lt  <- eng_lt |>
  setnames(new = c("sex", "x","q_x", "year", "country"))





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Life tables from united nations
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

options(timeout = 1000)

# getting list of current country/region codes
temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://population.un.org/wpp/assets/Excel%20Files/4_Metadata/WPP2024_F01_LOCATIONS.xlsx",
              temp, mode = "wb")
codes <- as.data.table(readxl::read_xlsx(temp, sheet = 2))[, .(LocID, Location)]



# getting male and female life tables
temp <- tempfile(fileext = ".csv.gz")
download.file(url = "https://population.un.org/wpp/assets/Excel%20Files/1_Indicator%20(Standard)/CSV_FILES/WPP2024_Life_Table_Complete_Medium_Female_1950-2023.csv.gz",
              temp)

lt_female <- fread(file = temp)[, .(Location, Time, Sex, AgeGrpStart, qx)]


temp <- tempfile(fileext = ".csv.gz")
download.file(url = "https://population.un.org/wpp/assets/Excel%20Files/1_Indicator%20(Standard)/CSV_FILES/WPP2024_Life_Table_Complete_Medium_Male_1950-2023.csv.gz",
              temp)

lt_male <- fread(file = temp)[, .(Location, Time, Sex, AgeGrpStart, qx)]


# binding male/female tables together and only keeping the countries for which we have utility norms
# note - need to have run the code in qaly_norms.R & made the table
# only keeping years from 2015 for the moment
# need to discuss how much data to store?
# for now removing the age group from 100 onwards
un_lt <- rbind(lt_male, lt_female)[
  Location %in% utility_norms[, norm_country] & Time >= 2015 & AgeGrpStart < 100
][
  , Sex := fifelse(Sex == "Male", "male", "female")
] |>
  setnames(new = c("country", "year", "sex", "x", "q_x"))


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# LA-level life tables
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

temp <- tempfile()
download.file(url = "https://osf.io/download/cx2w8/", temp)

la_lts <- as.data.table(utils::read.csv(temp))[, .(country = geography_name, year, sex = sex_name,
                                                   x = age_code, q_x = qx)][
                                                     , sex := ifelse(sex == "Female", "female", "male")
                                                   ]





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Collecting together
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

life_tables <- rbind(eng_lt, un_lt) |>
  setcolorder(c("country", "year", "sex", "x", "q_x")) |>
  setorder(country, year, x, sex) |>
  # should make a long term fix to this
  # currently adding a use package life tables function
  # and at the moment I can't figure out a sensible way to only run
  # the validity checks I wrote for the custom life tables to the custom life tables
  # and not to the package data.
  # those checks want the col names to be age and q
  # so just changing the names of the cols in the lt data we store, as a fudge
  setnames(old = c("x", "q_x"),
           new = c("age", "q"))

write.csv(life_tables, file.path(root, "life_tables.csv"))






















