
#









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

