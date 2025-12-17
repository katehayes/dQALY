#testthat::test_file("tests/testthat/test-calculate_dQALY.R")





temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.lshtm.ac.uk/media/42556",
              temp, mode = "wb")

briggs_1_1_0035 <- readxl::read_xlsx(temp, sheet = 2, range = "J17:J27")

avg_lt <- readxl::read_xlsx(temp, sheet = 6, range = "R6:S127") %>%
  mutate(q = 1 - lead(smrlx)/smrlx) %>%
  mutate(q = ifelse(is.na(q), lag(q), q)) %>%
  rename(age = Age) %>%
  select(age, q)

lt <- rbind(avg_lt %>%
              mutate(sex = "male"),
            avg_lt %>%
              mutate(sex = "female"))

age_grps <- data.frame(lower = seq(0, 90, 10),
                       upper = seq(10, 101, 10)-1)

chrt <- data.frame(sex = c(rep("male", 10), rep("female", 10)),
                   age = c(seq(5, 95, 10), seq(5, 95, 10)),
                   count = 1)


test_that("calculate_dQALY gives same results as Briggs when tweaked so methods align", {
  expect_equal(calculate_dQALY(life_table = lt,
                               norms = package_norms(country = "United Kingdom",
                                                     id = "janssen_tto",
                                                     avg_hrqol_young = 1),
                               collapse_sex = T,
                               collapse_age = age_grps,
                               cohort = chrt) |> select(dQALY),
               briggs_1_1_0035,
               ignore_attr = TRUE)
})



test_that("calculate_dQALY with no discounting gives same results as calculate_QALE", {
  expect_equal(calculate_dQALY(country = "France", year = 2017, r = 0),
               calculate_QALE(country = "France", year = 2017),
               ignore_attr = TRUE)
})



lt_test <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
                      age = c(0:100, 0:100),
                      q = c(rep(0, 99), 1, 1))

norms_no_qa <- data.frame(sex = c("male", "female"),
                          lower= 0,
                          upper = 100,
                          avg_hrqol = 1)



calculate_dQALY(life_table = lt_test, norms = norms_no_qa, r = 0)






# briggs_15_09_0035 <- readxl::read_xlsx(temp, sheet = 2, range = "N17:N27")
# briggs_2_08_0035 <- readxl::read_xlsx(temp, sheet = 2, range = "R17:R27")
# expect_equal(calculate_dQALY(life_table = lt,
#                              norms = package_norms(country = "United Kingdom",
#                                                    id = "janssen_tto",
#                                                    avg_hrqol_young = 1),
#                              smr = 1.5, qcm = 0.9,
#                              collapse_sex = T,
#                              collapse_age = age_grps,
#                              cohort = chrt) |> select(dQALY),
#              briggs_15_09_0035,
#              ignore_attr = TRUE)
# expect_equal(calculate_dQALY(life_table = lt,
#                              norms = package_norms(country = "United Kingdom",
#                                                    id = "janssen_tto",
#                                                    avg_hrqol_young = 1),
#                              smr = 2, qcm = 0.8,
#                              collapse_sex = T,
#                              collapse_age = age_grps,
#                              cohort = chrt) |> select(dQALY),
#              briggs_2_08_0035,
#              ignore_attr = TRUE)






norms_valid <- data.frame(sex = c(rep("male", 3), rep("female", 3)),
                          lower= c(0, 20, 90),
                          upper = c(19, 89, 150),
                          avg_util = c(1, 0.85, 0.67, 0.99, 0.4, 0.2))

norms_valid_2 <- data.frame(sex = c(rep("male", 3), rep("female", 2)),
                            lower= c(0, 20, 90, 0, 100),
                            upper = c(19, 89, 150, 99, 1000),
                            avg_util = c(1, 0.85, 0.67, 0.99, 0.2))

norms_invalid_1 <- data.frame(sex = c(rep("male", 3), rep("female", 2)),
                            lower= c(0, 20, 90, 0, 500),
                            upper = c(19, 89, 150, 99, 1000),
                            avg_util = c(1, 0.85, 0.67, 0.99, 0.2))

lt_valid <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
                       age = c(0:100, 0:100),
                       q = c(seq(0, 1, 0.01)))

lt_valid_2 <- data.frame(sex = c(rep("male", 201), rep("female", 201)),
                         age = c(0:200, 0:200),
                         q = c(0.05))


lt_invalid_1 <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
                           age = c(0:100, 0:100),
                           q = c(rep(5)))

lt_invalid_2 <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
                           age = c(-1:99, 0:100),
                           q = c(seq(0, 1, 0.01)))

lt_invalid_3 <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
                           age = c(-1:99, 0:100),
                           q = c(seq(0, 1, 0.01)))

lt_invalid_4 <- data.frame(sex2 = c(rep("male", 100), rep("female", 101)),
                           age = c(0:99, 0:100),
                           q = c(seq(0, 0.99, 0.01), seq(0, 1, 0.01)))

lt_invalid_5 <- data.frame(age = c(0:100, 0:100),
                           q = c(seq(0, 1, 0.01)))


ag_valid_1 <- data.frame(lower = c(seq(0,90,5)), upper = c(seq(4,89,5), 100))
ag_valid_2 <- data.frame(lower = c(1, 2, 100), upper = c(1, 2, 100))
ag_valid_3 <- data.frame(lower = 100, upper = 1000)

ag_invalid_1 <- data.frame(lower = c(1,2,3), upper = c(4,5,6))
ag_invalid_2 <- data.frame(lower = c(1,1,6), upper = c(1,5,6))
ag_invalid_3 <- data.frame(lower = c(1, 5, 10), upper = c(10, 15, 20))

ag_invalid_4 <- data.frame(lower = c(-1,2,3), upper = c(1,2,3))

cohort_valid_1 <- data.frame(age = c(0:99),
                             sex = "male",
                             count = 1)

cohort_valid_2 <- data.frame(age = c(0, 10, 1000),
                             sex = "male",
                             count = 1)






test_that("calculate_dQALY throws error for invalid argument combination", {
  expect_error(calculate_dQALY())
  expect_error(calculate_dQALY(country = "England", year = 2019, life_table = lt_valid, norms = norms_valid))
  expect_error(calculate_dQALY(year = 2019, life_table = lt_valid))
  expect_error(calculate_dQALY(life_table = lt_valid, norms = norms_valid, collapse_sex = T))
})


# test_that("calculate_dQALY throws error due to individual invalid argument", {
#   expect_error(calculate_dQALY(country = "England", year = "sixteen"))
# })

# stephs_age_groups <- data.frame(age_low = c(0, 1, 15, 45, 65, 75, 85), age_high = c(0, 14, 44, 64, 74, 84, 200))

