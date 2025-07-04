norms_valid <- data.frame(sex = c(rep("male", 3), rep("female", 3)),
                          age_low = c(0, 20, 90),
                          age_high = c(19, 89, 150),
                          avg_util = c(1, 0.85, 0.67, 0.99, 0.4, 0.2))

# invalid_norms


lt_valid <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
                       x = c(0:100, 0:100),
                       q_x = c(seq(0, 1, 0.01)))

lt_invalid_1 <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
                           x = c(0:100, 0:100),
                           q_x = c(rep(5)))

lt_invalid_2 <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
                           x = c(-1:99, 0:100),
                           q_x = c(seq(0, 1, 0.01)))

lt_invalid_3 <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
                           x = c(-1:99, 0:100),
                           q_x = c(seq(0, 1, 0.01)))

lt_invalid_4 <- data.frame(sex2 = c(rep("male", 100), rep("female", 101)),
                           x = c(0:99, 0:100),
                           q_x = c(seq(0, 0.99, 0.01), seq(0, 1, 0.01)))

lt_invalid_5 <- data.frame(x = c(0:100, 0:100),
                           q_x = c(seq(0, 1, 0.01)))


ag_valid <- data.frame(age_low = c(seq(0,90,5)), age_high = c(seq(4,89,5), 100))




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

