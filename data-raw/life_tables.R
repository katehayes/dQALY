## code to prepare life_tables dataset



temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables/current/nlte198020213.xlsx",
              temp, mode = "wb")

life_tables <- data.table(sex = character(), age = integer(), qx = numeric(), y = integer(), c = character())

for (n in 5:9) {

  lt_male <- as.data.table(readxl::read_xlsx(temp, sheet = n, range = "A6:F107"))
  lt_male[, sex := "male"]


  lt_female <- as.data.table(readxl::read_xlsx(temp, sheet = n, range = "H6:M107"))
  lt_female[, sex := "female"]

  lt_temp <- rbind(lt_male[, .(sex, age, qx)], lt_female[, .(sex, age, qx)])

  lt_temp[, y := 2022-(n-5)]
  lt_temp[, c := "England"]

  life_tables <- life_tables |>
    rbind(lt_temp)

}


life_tables <- life_tables |>
  setnames(new = c("sex", "x","q_x", "y", "c")) |>
  setcolorder(c("c", "y", "sex", "x", "q_x")) |>
  setorder(y, x, sex)



usethis::use_data(life_tables, internal = TRUE, overwrite = TRUE)
