library(data.table)

calc_dQALY <- function(life_table, utility_norms, cohort,
                       r = 0.035, smr = 1, qcm = 1) {

  life_table <- as.data.table(life_table)[, .(x = age, sex = sex, q_x = q)]

  min_x <- min(life_table$x)
  max_x <- max(life_table$x)

  # here's the big difference - going to assume we start with n men and n women of each age - letting n = 1
  # & will work all the intermediate variables out separately by age at the 'start' ie the first point in the time horizon of the calculation
  # still assuming q(x) and avg_hrqol constant over time - but i think setting the calculation up like this would make it easier to change that
  life_table <- life_table[, .(starts = c(min_x:max_x)), by = .(sex, x, q_x)] |> setorder(starts, x, sex)
  life_table[x < starts, q_x := 0]

  # making l_x and L_x
  life_table[, l_x := cumprod(shift(1-q_x, fill = 1)^smr), by=.(starts, sex)]
  life_table[, L_x := (l_x + shift(l_x, type = "lead", fill = 0))/2, , by = .(starts, sex)]

  # joining in the utility norms
  dQALY_table <- as.data.table(utility_norms)[life_table,
                                              on = .(sex, lower <= x, upper >= x),
                                              .(starts, sex, x, q_x, l_x, L_x, avg_hrqol)]

  # working out discount rates
  dQALY_table[, r_col := r]
  dQALY_table[x == 0, r_col := 0]
  dQALY_table[, v := shift(1/cumprod(1+r_col), n = starts, type = "lag", fill = 0), by = .(starts, sex)]

  # calculating dQALY
  # no more matrix multiplication because of the new data structure
  # l(x) is no longer in the denominator (bc we said its one in all cases)
  dQALY_table <- dQALY_table[, .(dQALY = sum(L_x*avg_hrqol*v)), b= .(starts, sex)] |> setnames(old = "starts", new = "x")

  # joining cohort, taking average, outputting
  cohort <- as.data.table(cohort)[, .(x = age, sex = sex, count = count)]
  dQALY_table <- dQALY_table[cohort,
                             on = .(sex, x)]
  dQALY_table <- dQALY_table[, .(dQALY = sum(dQALY*count)/sum(count)), by = .(x)]

  dQALY_table |> setnames(old = "x", new = "age")
  dQALY_table[]


}

# Read ONS population data
tibble::tibble(sex = c("female", "male"),
               sheet1 = c("MYE2 - Females", "MYE2 - Males"),
               sheet2 = c("England Women", "England Men")) |>
  purrr::pmap(function(sex, sheet1, sheet2) {
    # Population <90
    download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland/mid2023/mye23tablesuk.xlsx",
                  "temp.xlsx", mode = "wb")
    readxl::read_excel("temp.xlsx", sheet = sheet1, .name_repair = "unique_quiet") |>
      dplyr::slice(11) |>
      dplyr::select(-c(1:4, 95)) |>
      setNames(0:89) -> dat0
    # Population 90+
    download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/ageing/datasets/midyearpopulationestimatesoftheveryoldincludingcentenariansengland/current/englandevo2024.xls",
                  "temp.xls", mode = "wb")
    readxl::read_excel("temp.xls", sheet = sheet2, .name_repair = "unique_quiet") |>
      dplyr::slice(25) |>
      dplyr::select(-c(1:4)) |>
      setNames(90:105) %>%
      dplyr::bind_cols(dat0, .) |>
      tidyr::pivot_longer(1:106, names_to = "lower",
                          names_transform = as.numeric, values_transform = as.numeric) |>
      dplyr::mutate(sex = sex)}) |>
  dplyr::bind_rows() |>
  dplyr::rename(age = lower) |>
  dplyr::mutate(age = ifelse(age > 100, 100, age)) |>
  dplyr::summarise(value = sum(value), .by = c(age, sex)) |>
  tidyr::pivot_wider(names_from = sex, values_from = value) |>
  tidyr::pivot_longer(-age, names_to = "sex", values_to = "count") -> ons_pop



# Read ONS life table data
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables/current/nlte198020213.xlsx",
              "temp.xlsx", mode = "wb")
readxl::read_excel("temp.xlsx", sheet = "2021-2023",
                   .name_repair = "unique_quiet") |>
  dplyr::slice(-c(1:5)) |>
  dplyr::select(-c(7:8)) |>
  setNames(c("age", paste0(rep(c("male", "female"), each = 5), "_", rep(c("m", "q", "l", "d", "e"), 2), "x"))) |>
  tidyr::pivot_longer(2:11, names_to = c("sex", ".value"), names_sep = "\\_") |>
  dplyr::mutate(dplyr::across(-sex, as.numeric)) -> ons_life_tab



# Read utility norms
temp <- tempfile()
download.file(url = "https://raw.githubusercontent.com/bitowaqr/shortfall/main/src%20manuscript/output/hrqol_co_ci_df.csv", temp)
vih_primary <- as.data.table(utils::read.csv(temp))

vih_primary[, lower := as.numeric(substring(age5_str, 1, 2))]
vih_primary[, upper := as.numeric(substring(age5_str, 4, 5))]
vih_primary[lower == max(lower), upper := 200]
vih_primary[, avg_hrqol := as.numeric(sub(" .*", "", m_ci))]
vih_primary[, c("age5_str", "m_ci", "n"):=NULL]

yg <- vih_primary[lower == min(lower)]
yg[, upper := lower - 1]
yg[, lower := 0]

vih_primary <- rbind(vih_primary, yg)

# NW: QALY calculation with varying q for age = 0
seq(0, 1, 0.1) |>
  purrr::map(function(x) {
    dQALY::calculate_dQALY(country = "England",
                           life_table = ons_life_tab |>
                             dplyr::mutate(qx = ifelse(age == 0, x, qx)) |>
                             dplyr::select(sex, age, q = qx),
                           r = 0.035,
                           collapse_sex = T,
                           cohort = ons_pop) |>
      dplyr::mutate(name = x)}) |>
  dplyr::bind_rows() |>
  dplyr::as_tibble() |>
  tidyr::pivot_wider(names_from = name, values_from = dQALY)
# Changing q between 0 and 0.9 only influences the output for age = 0, but not
# for any of the older ages, as expected. But for q = 1 this is not the case

# New QALY calculation with varying q for age = 0
seq(0, 1, 0.1) |>
  purrr::map(function(x) {calc_dQALY(life_table = ons_life_tab |>
                                       dplyr::mutate(qx = ifelse(age == 0, x, qx)) |>
                                       dplyr::select(sex, age, q = qx),
                                     utility_norms = vih_primary,
                                     cohort = ons_pop) |>
      dplyr::mutate(name = x)}) |>
  dplyr::bind_rows() |>
  dplyr::as_tibble() |>
  tidyr::pivot_wider(names_from = name, values_from = dQALY)

# and age 7
seq(0, 1, 0.1) |>
  purrr::map(function(x) {calc_dQALY(life_table = ons_life_tab |>
                                       dplyr::mutate(qx = ifelse(age == 7, x, qx)) |>
                                       dplyr::select(sex, age, q = qx),
                                     utility_norms = vih_primary,
                                     cohort = ons_pop) |>
      dplyr::mutate(name = x)}) |>
  dplyr::bind_rows() |>
  dplyr::as_tibble() |>
  tidyr::pivot_wider(names_from = name, values_from = dQALY)



