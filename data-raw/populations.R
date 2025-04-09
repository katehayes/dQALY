# Reading in other ONS population data for England directly from their website
# You have to specify the year you want to select via the 'year' argument.
# Note - ONS release data by year of age for ages 0-89 in one Excel workbook,
# and for ages 90-104 in another
# Do we still need to decide what to do for ages 105 plus?


temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/estimatesofthepopulationforenglandandwales/ukpopulationestimates1838to2023editionofthisdataset/ukpopulationestimates18382023.xlsx",
              temp, mode = "wb")

pop_sub90 <- as.data.table(readxl::read_xlsx(temp, sheet = 15, range = "A2:BC278"))[Sex != "Persons" & Age != "All Ages"] |>
  melt(measure.vars = patterns("^Mid-"),
       variable.name = "y",
       value.name = "count") |>
  setnames(new = c("x", "sex", "y", "count")) |>
  setcolorder(c("sex", "x", "y", "count"))

pop_sub90[sex == "Males", sex := "male"]
pop_sub90[sex == "Females", sex := "female"]
pop_sub90[, y := sub("Mid-", "", y)]



temp <- tempfile(fileext = ".xls")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/ageing/datasets/midyearpopulationestimatesoftheveryoldincludingcentenariansengland/current/englandevo2023.xls",
              temp, mode = "wb")

pop_90plus_male <- as.data.table(readxl::read_xls(temp, sheet = 6, range = "A4:T26"))[
  , -c(2,3,4)
][
  , sex := "male"
] |>
  melt(measure = 2:17,
       variable.name = "x",
       value.name = "count")


pop_90plus_female <- as.data.table(readxl::read_xls(temp, sheet = 7, range = "A4:T26"))[
  , -c(2,3,4)
][
  , sex := "female"
] |>
  melt(measure = 2:17,
       variable.name = "x",
       value.name = "count")

pop_90plus <- rbind(pop_90plus_male, pop_90plus_female) |>
  setnames(new = c("y", "sex", "x", "count")) |>
  setcolorder(c("sex", "x", "y", "count"))


ons_pop <- rbind(pop_sub90[x != "90+"], pop_90plus[x != "105 & over"])[
  , c := "England"
]




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# population data from united nations
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# pulling from estimates sheet - explore medium/high/low variants?

temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://population.un.org/wpp/assets/Excel%20Files/1_Indicator%20(Standard)/EXCEL_FILES/2_Population/WPP2024_POP_F01_2_POPULATION_SINGLE_AGE_MALE.xlsx",
              temp, mode = "wb")


pop_male <- as.data.table(readxl::read_xlsx(temp, sheet = 1, range = "C17:DH22000"))[, -c(2:8)][
  `Region, subregion, country or area *` %in% utility_norms[, c] & Year >= 2015
][
  , sex := "male"
] |> melt(measure = 3:103,
          variable.name = "x",
          value.name = "count")




temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://population.un.org/wpp/assets/Excel%20Files/1_Indicator%20(Standard)/EXCEL_FILES/2_Population/WPP2024_POP_F01_3_POPULATION_SINGLE_AGE_FEMALE.xlsx",
              temp, mode = "wb")


pop_female <- as.data.table(readxl::read_xlsx(temp, sheet = 1, range = "C17:DH22000"))[, -c(2:8)][
  `Region, subregion, country or area *` %in% utility_norms[, c] & Year >= 2015
][
  , sex := "female"
] |> melt(measure = 3:103,
          variable.name = "x",
          value.name = "count")

un_pop <- rbind(pop_male, pop_female) |>
  setnames(new = c("c", "y", "sex", "x", "count"))

un_pop[, count := as.numeric(count)*1000]


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Collecting together
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

populations <- rbind(ons_pop[y >= 2015], un_pop[x != "100+"])[
  , x := as.numeric(x)
] |>
  setcolorder(c("c", "y", "sex", "x", "count")) |>
  setorder(c, y, x, sex)



