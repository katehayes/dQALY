root <- file.path(here::here(), "data-raw")
utility_norms <- as.data.table(read.csv(file.path(root, "utility_norms.csv"), row.names = 1L))

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# UK population data from ONS ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
## UK projected population data - 2022 to 2122 ####


temp <- tempfile()
temp2 <- tempfile()

download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationprojections/datasets/z1zippedpopulationprojectionsdatafilesuk/2022based/uk.zip", temp)
unzip(zipfile = temp, exdir = temp2)

uk_pop_proj <- as.data.table(readxl::read_xlsx(file.path(temp2, "uk/uk_ppp_machine_readable.xlsx"), sheet = 3)) |>
  setnames(old = c("Sex", "Age"), new = c("sex", "x")) |>
  melt(measure.vars = patterns("^2"),
       variable.name = "year",
       value.name = "count")
uk_pop_proj[, sex := ifelse(sex == "Females", "female", "male")]
uk_pop_proj <- uk_pop_proj[x %in% c(0:104)][, x := as.numeric(x)][, year := as.numeric(as.character(year))]


# little haphazard extension of the pop data up to 120 - not sure we need this?
# uk_pop_proj <- uk_pop_proj[CJ(year = 2022:2122, sex = c("male", "female"), x = 0:120), on = c("sex", "x", "year")] |>
#   setorder(year, x, sex)
# uk_pop_proj[, count_104 := min(count, na.rm = T), by = .(sex, year)]
# uk_pop_proj[, count_104 := count_104*0.5^(x-103), by = .(sex, year)]
# uk_pop_proj[is.na(count), count := count_104][, count_104 := NULL]




## past data -- 1972 to 2024 ####

temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland/ukpopulationestimates1838to2024/ukpopulationestimates18382024.xlsx",
              temp, mode = "wb")


pop_sub90 <- as.data.table(readxl::read_xlsx(temp, sheet = 7, range = "A2:BC278"))[Sex != "Persons" & Age != "All Ages"] |>
  melt(measure.vars = patterns("^Mid-"),
       variable.name = "y",
       value.name = "count") |>
  setnames(new = c("x", "sex", "year", "count")) |>
  setcolorder(c("sex", "x", "year", "count"))

pop_sub90[sex == "Males", sex := "male"]
pop_sub90[sex == "Females", sex := "female"]
pop_sub90[, year := sub("Mid-", "", year)]



## past data -- 2002-2024 - for the very old ####
# bringing in the more granular estimates for the very old,
# only available for some of the past years

temp <- tempfile(fileext = ".xls")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/ageing/datasets/midyearpopulationestimatesoftheveryoldincludingcentenariansunitedkingdom/current/ukevo2024.xls",
              temp, mode = "wb")

pop_90plus_male <- as.data.table(readxl::read_xls(temp, sheet = 6, range = "A4:T27"))[
  , -c(2,3,4)
][
  , sex := "male"
] |>
  melt(measure = 2:17,
       variable.name = "x",
       value.name = "count")


pop_90plus_female <- as.data.table(readxl::read_xls(temp, sheet = 7, range = "A4:T27"))[
  , -c(2,3,4)
][
  , sex := "female"
] |>
  melt(measure = 2:17,
       variable.name = "x",
       value.name = "count")

pop_90plus <- rbind(pop_90plus_male, pop_90plus_female) |>
  setnames(new = c("year", "sex", "x", "count")) |>
  setcolorder(c("sex", "x", "year", "count"))



# 2002 is the earliest year where we've got nice info for very old people
# now have to just do a little bit of assumption making for the rest of the years
# where info ends at 89/90
# going to extend everything to age 104 but I guess that's a bit arbitrary
# could go further by extending the years 2002 onwards in the same way I'm about
# to extend the earlier years.

q_proj <- lm(q ~ as.character(year) - 1 + sex:x,
             data = pop_sub90[year < 2002][, q := (shift(count, type = "lag") - count)/lag(count, type = "lag")][x %in% c(87:89)][, x := as.numeric(as.character(x))])

extend <- CJ(year = 1972:2001, sex = c("male", "female"), x = 90:104)
extend[, q := predict(q_proj, extend[, year := as.character(year)])]

extend <- pop_sub90[x == "90+", .(year, sex, count)][extend,
                                                   on = .(sex, year)]

extend[, pc_left := cumprod(1-shift(q, type = "lag", fill = 0)), by = .(sex, year)]
extend[, count := count*pc_left/sum(pc_left), by = .(sex, year)]




## gathering up everything, adding projections to past data + my assumptions ####
# going to take from past rather than the projected data for the 2 years they
# overlap (2023 & 2024)

uk_pop <- rbind(uk_pop_proj[year < 2024],
                pop_sub90[x != "90+"],
                pop_90plus[x != "105 \nand over"],
                extend[, .(year, sex, x, count)])[
  , country := "United Kingdom"
]

uk_pop[, year := as.numeric(as.character(year))]
uk_pop[, x := as.numeric(as.character(x))] |>
  setcolorder(c("country", "year", "sex", "x", "count")) |>
  setorder(country, year, x, sex)

# just taking the years for which we have life tables
uk_pop <- uk_pop[year %in% c(1981:2072)]






# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# English population data from ONS ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

## English projected population data - 2022 to 2122 ####
temp <- tempfile()
temp2 <- tempfile()

download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationprojections/datasets/z3zippedpopulationprojectionsdatafilesengland/2022based/en.zip", temp)
unzip(zipfile = temp, exdir = temp2)

eng_pop_proj <- as.data.table(readxl::read_xlsx(file.path(temp2, "en/en_ppp_machine_readable.xlsx"), sheet = 3)) |>
  setnames(old = c("Sex", "Age"), new = c("sex", "x")) |>
  melt(measure.vars = patterns("^2"),
       variable.name = "year",
       value.name = "count")
eng_pop_proj[, sex := ifelse(sex == "Females", "female", "male")]
eng_pop_proj <- eng_pop_proj[x %in% c(0:104)][, x := as.numeric(x)][, year := as.numeric(as.character(year))]



## past data -- 1972 to 2024 ####
# Note - ONS release data by year of age for ages 0-89 in one Excel workbook,
# and for ages 90-104 in another
# Do we still need to decide what to do for ages 105 plus?

temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland/ukpopulationestimates1838to2024/ukpopulationestimates18382024.xlsx",
              temp, mode = "wb")


pop_sub90 <- as.data.table(readxl::read_xlsx(temp, sheet = 15, range = "A2:BC278"))[Sex != "Persons" & Age != "All Ages"] |>
  melt(measure.vars = patterns("^Mid-"),
       variable.name = "y",
       value.name = "count") |>
  setnames(new = c("x", "sex", "year", "count")) |>
  setcolorder(c("sex", "x", "year", "count"))

pop_sub90[sex == "Males", sex := "male"]
pop_sub90[sex == "Females", sex := "female"]
pop_sub90[, year := sub("Mid-", "", year)]



## past data -- 2002-2024 - for the very old ####
# bringing in the more granular estimates for the very old,
# only available for some of the past years

temp <- tempfile(fileext = ".xls")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/ageing/datasets/midyearpopulationestimatesoftheveryoldincludingcentenariansengland/current/englandevo2024.xls",
              temp, mode = "wb")

pop_90plus_male <- as.data.table(readxl::read_xls(temp, sheet = 6, range = "A4:T27"))[
  , -c(2,3,4)
][
  , sex := "male"
] |>
  melt(measure = 2:17,
       variable.name = "x",
       value.name = "count")


pop_90plus_female <- as.data.table(readxl::read_xls(temp, sheet = 7, range = "A4:T27"))[
  , -c(2,3,4)
][
  , sex := "female"
] |>
  melt(measure = 2:17,
       variable.name = "x",
       value.name = "count")

pop_90plus <- rbind(pop_90plus_male, pop_90plus_female) |>
  setnames(new = c("year", "sex", "x", "count")) |>
  setcolorder(c("sex", "x", "year", "count"))



# 2002 is the earliest year where we've got nice info for very old people
# now have to just do a little bit of assumption making for the rest of the years
# where info ends at 89/90
# going to extend everything to age 104 but I guess that's a bit arbitrary
# could go further by extending the years 2002 onwards in the same way I'm about
# to extend the earlier years.

q_proj <- lm(q ~ as.character(year) - 1 + sex:x,
             data = pop_sub90[year < 2002][, q := (shift(count, type = "lag") - count)/lag(count, type = "lag")][x %in% c(87:89)][, x := as.numeric(as.character(x))])

extend <- CJ(year = 1972:2001, sex = c("male", "female"), x = 90:104)
extend[, q := predict(q_proj, extend[, year := as.character(year)])]

extend <- pop_sub90[x == "90+", .(year, sex, count)][extend,
                                                     on = .(sex, year)]

extend[, pc_left := cumprod(1-shift(q, type = "lag", fill = 0)), by = .(sex, year)]
extend[, count := count*pc_left/sum(pc_left), by = .(sex, year)]




## gathering up everything, adding projections to past data + my assumptions ####
# going to take from past rather than the projected data for the 2 years they
# overlap (2023 & 2024)

eng_pop <- rbind(eng_pop_proj[year < 2024],
                pop_sub90[x != "90+"],
                pop_90plus[x != "105 and over"],
                extend[, .(year, sex, x, count)])[
                  , country := "England"
                ]

eng_pop[, year := as.numeric(as.character(year))]
eng_pop[, x := as.numeric(as.character(x))] |>
  setcolorder(c("country", "year", "sex", "x", "count")) |>
  setorder(country, year, x, sex)
# just taking the years for which we have life tables
eng_pop <- eng_pop[year %in% c(1981:2072)]









# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# population data from united nations ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# pulling from estimates sheet - explore medium/high/low variants?

temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://population.un.org/wpp/assets/Excel%20Files/1_Indicator%20(Standard)/EXCEL_FILES/2_Population/WPP2024_POP_F01_2_POPULATION_SINGLE_AGE_MALE.xlsx",
              temp, mode = "wb")


pop_male <- as.data.table(readxl::read_xlsx(temp, sheet = 1, range = "C17:DH22000"))[, -c(2:8)][
  `Region, subregion, country or area *` %in% utility_norms[, norm_country] & Year >= 2015
][
  , sex := "male"
] |> melt(measure = 3:103,
          variable.name = "x",
          value.name = "count")

temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://population.un.org/wpp/assets/Excel%20Files/1_Indicator%20(Standard)/EXCEL_FILES/2_Population/WPP2024_POP_F01_3_POPULATION_SINGLE_AGE_FEMALE.xlsx",
              temp, mode = "wb")

pop_female <- as.data.table(readxl::read_xlsx(temp, sheet = 1, range = "C17:DH22000"))[, -c(2:8)][
  `Region, subregion, country or area *` %in% utility_norms[, norm_country] & Year >= 2015
][
  , sex := "female"
] |> melt(measure = 3:103,
          variable.name = "x",
          value.name = "count")

un_pop <- rbind(pop_male, pop_female) |>
  setnames(new = c("country", "year", "sex", "x", "count"))

un_pop[, count := as.numeric(count)*1000]


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Collecting together ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

populations <- rbind(eng_pop,
                     uk_pop,
                     un_pop[x != "100+"][country != "United Kingdom"])[
  , x := as.numeric(as.character(x))
] |>
  setcolorder(c("country", "year", "sex", "x", "count")) |>
  setorder(country, year, x, sex) |>
  # should make a long term fix to this
  # same thing in life table script
  # for now just changing the names of the cols in the cohort data we store, as a fudge
  setnames(old = c("x"),
           new = c("age"))

write.csv(populations, file.path(root, "populations.csv"))

