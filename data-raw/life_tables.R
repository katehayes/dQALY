# usethis::use_data(life_tables, utility_norms, populations, internal = TRUE, overwrite = TRUE)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# English life tables from ONS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables/current/nlte198020213.xlsx",
              temp, mode = "wb")

eng_lt <- data.table(sex = character(), age = integer(), qx = numeric(), y = integer(), c = character())

for (n in 5:9) {

  lt_male <- as.data.table(readxl::read_xlsx(temp, sheet = n, range = "A6:F107"))
  lt_male[, sex := "male"]


  lt_female <- as.data.table(readxl::read_xlsx(temp, sheet = n, range = "H6:M107"))
  lt_female[, sex := "female"]

  lt_temp <- rbind(lt_male[, .(sex, age, qx)], lt_female[, .(sex, age, qx)])

  lt_temp[, y := 2022-(n-5)]
  lt_temp[, c := "England"]

  eng_lt  <- eng_lt |>
    rbind(lt_temp)

}


eng_lt  <- eng_lt |>
  setnames(new = c("sex", "x","q_x", "y", "c"))





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


# binding male/female tables together and only keeping the countries for which we have qaly norms
# note - need to have run the code in qaly_norms.R & made the table
# only keeping years from 2015 for the moment
# need to discuss how much data to store?
# for now removing the age group from 100 onwards
un_lt <- rbind(lt_male, lt_female)[
  Location %in% utility_norms[, c] & Time >= 2015 & AgeGrpStart < 100
][
  , Sex := fifelse(Sex == "Male", "male", "female")
] |>
  setnames(new = c("c", "y", "sex", "x", "q_x"))



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Collecting together
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

life_tables <- rbind(eng_lt, un_lt) |>
  setcolorder(c("c", "y", "sex", "x", "q_x")) |>
  setorder(c, y, x, sex)

























