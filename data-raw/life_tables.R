root <- file.path(here::here(), "data-raw")
utility_norms <- as.data.table(read.csv(file.path(root, "utility_norms.csv"), row.names = 1L))



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# English life tables from ONS ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


## JUST EXPLORATION ####
# English - investigating cohort life expectancy
# https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/mortalityratesqxprincipalprojectionengland
temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/mortalityratesqxprincipalprojectionengland/2024based/enppp24qx.xlsx",
              temp, mode = "wb")

qx_male <- as.data.table(readxl::read_excel(temp, sheet = "males cohort qx", range = "A4:CQ105")) |>
  setnames(old = c("Year of birth 1981", "Exact age (years)"), new = c("1981", "x")) |>
  melt(measure.vars = patterns("^1|^2"),
       variable.name = "yob",
       value.name = "q_x")

qx_male[, q_x := q_x/100000]
qx_male[, sex := "male"]

qx_female <- as.data.table(readxl::read_excel(temp, sheet = "females cohort qx", range = "A4:CQ105")) |>
  setnames(old = c("Year of birth 1981", "Exact age (years)"), new = c("1981", "x")) |>
  melt(measure.vars = patterns("^1|^2"),
       variable.name = "yob",
       value.name = "q_x")

qx_female[, q_x := q_x/100000]
qx_female[, sex := "female"]

qx_cohort <- rbind(qx_male, qx_female)
qx_cohort[, yob := as.numeric(as.character(yob))]
qx_cohort[, year := yob + x]



# think i might have to bring in period life tables for the earlier years
# Projected period life tables

qx_male <- as.data.table(readxl::read_excel(temp, sheet = "males period qx", range = "A4:CQ105")) |>
  setnames(old = c("Year 1981", "Exact age (years)"), new = c("1981", "x")) |>
  melt(measure.vars = patterns("^1|^2"),
       variable.name = "year",
       value.name = "q_x")

qx_male[, q_x := q_x/100000]
qx_male[, sex := "male"]

qx_female <- as.data.table(readxl::read_excel(temp, sheet = "females period qx", range = "A4:CQ105")) |>
  setnames(old = c("Year 1981", "Exact age (years)"), new = c("1981", "x")) |>
  melt(measure.vars = patterns("^1|^2"),
       variable.name = "year",
       value.name = "q_x")

qx_female[, q_x := q_x/100000]
qx_female[, sex := "female"]

qx_period <- rbind(qx_male, qx_female)
qx_period[, year := as.numeric(as.character(year))]
qx_period[, yob := year - x]


# putting info from period & cohort tables together
qx_cohort |> setnames(old = "q_x", new = "cohort_q")
qx_period |> setnames(old = "q_x", new = "period_q")

qx_cohort <- setkey(qx_cohort, yob, year, x, sex)
qx_period <- setkey(qx_period, yob, year, x, sex)

eng_lts <- merge(qx_cohort,
                 qx_period,
                 by = c("yob", "year", "x", "sex"),
                 all = TRUE)

if(isFALSE(all(copy(eng_lts)[!is.na(cohort_q) & !is.na(period_q), (cohort_q == period_q)]))) {
  message("Something (bad) is going on!")
} else {
  message("All good")
}

eng_lts[, q_x := rowMeans(.SD, na.rm = T), .SDcols = c("cohort_q", "period_q")]
eng_lts <- eng_lts[, .(year, sex, x, q_x)]
eng_lts[, country := "England"]





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# UK life tables from ONS ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

## Projected period life tables 1981 - 2074 ####
temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/mortalityratesqxprincipalprojectionunitedkingdom/2024based/ukppp24qx.xlsx",
              temp, mode = "wb")

qx_male <- as.data.table(readxl::read_excel(temp, sheet = "males period qx", range = "A4:CQ105")) |>
  setnames(old = c("Year 1981", "Exact age (years)"), new = c("1981", "x")) |>
  melt(measure.vars = patterns("^1|^2"),
       variable.name = "year",
       value.name = "q_x")

qx_male[, q_x := q_x/100000]
qx_male[, sex := "male"]

qx_female <- as.data.table(readxl::read_excel(temp, sheet = "females period qx", range = "A4:CQ105")) |>
  setnames(old = c("Year 1981", "Exact age (years)"), new = c("1981", "x")) |>
  melt(measure.vars = patterns("^1|^2"),
       variable.name = "year",
       value.name = "q_x")

qx_female[, q_x := q_x/100000]
qx_female[, sex := "female"]

qx_period <- rbind(qx_male, qx_female)
qx_period[, year := as.numeric(as.character(year))]
qx_period[, yob := year - x]


# now the cohort tables
qx_male <- as.data.table(readxl::read_excel(temp, sheet = "males cohort qx", range = "A4:CQ105")) |>
  setnames(old = c("Year of birth 1981", "Exact age (years)"), new = c("1981", "x")) |>
  melt(measure.vars = patterns("^1|^2"),
       variable.name = "yob",
       value.name = "q_x")

qx_male[, q_x := q_x/100000]
qx_male[, sex := "male"]

qx_female <- as.data.table(readxl::read_excel(temp, sheet = "females cohort qx", range = "A4:CQ105")) |>
  setnames(old = c("Year of birth 1981", "Exact age (years)"), new = c("1981", "x")) |>
  melt(measure.vars = patterns("^1|^2"),
       variable.name = "yob",
       value.name = "q_x")

qx_female[, q_x := q_x/100000]
qx_female[, sex := "female"]

qx_cohort <- rbind(qx_male, qx_female)
qx_cohort[, yob := as.numeric(as.character(yob))]
qx_cohort[, year := yob + x]


# putting info from period & cohort tables together
qx_cohort |> setnames(old = "q_x", new = "cohort_q")
qx_period |> setnames(old = "q_x", new = "period_q")

qx_cohort <- setkey(qx_cohort, yob, year, x, sex)
qx_period <- setkey(qx_period, yob, year, x, sex)

uk_lts <- merge(qx_cohort,
                qx_period,
                by = c("yob", "year", "x", "sex"),
                all = TRUE)

if(isFALSE(all(copy(uk_lts)[!is.na(cohort_q) & !is.na(period_q), (cohort_q == period_q)]))) {
  message("Something (bad) is going on!")
} else {
  message("All good")
}

uk_lts[, q_x := rowMeans(.SD, na.rm = T), .SDcols = c("cohort_q", "period_q")]
uk_lts <- uk_lts[, .(year, sex, x, q_x)]
uk_lts[, country := "United Kingdom"]

















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


# going to start adding in lts for the UK from the ONS - can include projections etc
un_lt <- un_lt[country != "United Kingdom"]


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

life_tables <- rbind(eng_lts, uk_lts, un_lt) |>
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



rbind(as.data.table(calculate_dQALY(country = "England",
                                    year = 1990,
                                    life_table = package_lt_draft(cohort = TRUE)))[, type := "cohort"],
      as.data.table(calculate_dQALY(country = "England",
                                    year = 1990,
                                    life_table = package_lt_draft(cohort = FALSE)))[, type := "period"]) |>
  ggplot() +
  geom_line(aes(x = age, y = dQALY, group = type, colour = type)) +
  facet_wrap(~sex) +
  scale_x_continuous(breaks = c(seq(0, 125, 5)))



rbind(as.data.table(calculate_dQALY(country = "England",
                                    year = 2000,
                                    life_table = package_lt(cohort = TRUE)))[, type := "cohort"],
      as.data.table(calculate_dQALY(country = "England",
                                    year = 2000,
                                    life_table = package_lt(cohort = FALSE)))[, type := "period"]) |>
  ggplot() +
  geom_line(aes(x = age, y = dQALY, group = type, colour = type)) +
  facet_wrap(~sex) +
  scale_x_continuous(breaks = c(seq(0, 125, 5)))






calculate_dQALY(country = "England",
                year = 2000,
                life_table = package_lt(cohort = TRUE))










