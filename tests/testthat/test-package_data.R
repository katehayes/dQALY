# testthat::test_file("tests/testthat/test-package_data.R")
# package_norms
# package_lt
# package_cohort
# hrqol_norms
# default_norms


# Am testing whether the correct numbers are stored in a really strange way
# that is not at all conducive to adding more data to the package
# got to have

# --------Making objects for testing--------------------------------------------
country_list <- data.table(country = c("Argentina", "Belgium", "China", "Denmark", "England",
                                       "Finland", "France", "Germany", "Greece", "Hungary",
                                       "Italy", "Netherlands", "New Zealand", "Republic of Korea", "Romania",
                                       "Slovenia", "Spain", "Sweden", "Thailand", "United Kingdom",
                                       "United States of America"))


# --------Tests-----------------------------------------------------------------
## --------package_lt-----------------------------------------------------------
# test_that("package_lt returns (probably) same numbers for list of avail countries & years", {
#   expect_snapshot(copy(country_list[country != "England"])[, paste0("sum", c(15:23)) := lapply(c(2015:2023), function(x) sum(package_lt(country, year = x)$q, na.rm = T)), by = country])
#   expect_snapshot(copy(country_list[country == "England"])[, paste0("sum", c(15:23)) := lapply(c(2018:2022), function(x) sum(package_lt(country, year = x)$q, na.rm = T)), by = country])
# })


test_that("package_lt default extension to 120 works", {
  expect_snapshot(copy(country_list[country != "England"])[, paste0("length", c(15:23)) := lapply(c(2015:2023), function(x) nrow(package_lt(country, year = x))), by = country])
})


test_that("turning off package_lt default extension works", {
  expect_snapshot(copy(country_list[country != "England"])[, paste0("length", c(15:23)) := lapply(c(2015:2023), function(x) nrow(package_lt(country, year = x, lt_extend = F))), by = country])
})



test_that("package_lt returns error if country arg is invalid", {
  expect_snapshot(package_lt("Ireland"), error = TRUE)
  expect_snapshot(package_lt(), error = TRUE)
})



test_that("package_lt returns error if year arg is invalid", {
  expect_snapshot(package_lt(country = "England", year = 3), error = TRUE)
  expect_snapshot(package_lt(country = "England", year = NULL), error = TRUE)
})


## --------package_norms()-----------------------------------------------------------
test_that("package_norms inheriting norm id from default norms argument in the correct way", {
  expect_equal(package_norms(country = "England"),
               package_norms(country = "England", id = default_norms(country = "England")))
})

# test_that("package_norms return (probably) same default for list of avail countries", {
#   expect_snapshot(copy(country_list)[, .(sum = sum(package_norms(country)$avg_hrqol, na.rm = T),
#                                          mean = mean(package_norms(country)$avg_hrqol, na.rm = T)), by = country])
# })
#
# test_that("package_norms return (probably) same numbers for list of avail countries, after adjustment", {
#   expect_snapshot(copy(country_list)[, .(sum = sum(package_norms(country, avg_hrqol_young = 0)$avg_hrqol, na.rm = T),
#                                          mean = mean(package_norms(country, avg_hrqol_young = 0)$avg_hrqol, na.rm = T)), by = country])
# })


test_that("package_norms returns error if country arg is invalid", {
  expect_snapshot(package_norms("Ireland"), error = TRUE)
  expect_snapshot(package_norms(), error = TRUE)
})


test_that("package_norms returns error if id arg is invalid", {
  expect_snapshot(package_norms(country = "England", id = "england_default"), error = TRUE)
  expect_snapshot(package_norms(country = "England", id = NULL), error = TRUE)
  expect_snapshot(package_norms(country = "England", id = default_norms(country = "england")), error = TRUE)
})


test_that("package_norms returns error if avg_hrqol_young arg is invalid", {
  expect_snapshot(package_norms(country = "England", avg_hrqol_young = c(1,0)), error = TRUE)
  expect_snapshot(package_norms(country = "England", avg_hrqol_young = "a"), error = TRUE)
})


test_that("package_norms returns warning message if avg_hrqol_young arg is unusual", {
  expect_snapshot(package_norms(country = "England", avg_hrqol_young = 100))
})


## --------package_cohort-------------------------------------------------------
# test_that("package_cohort returns (probably) correct numbers for list of avail countries & years", {
#   expect_snapshot(copy(country_list[country != "England"])[, paste0("sum", c(15:23)) := lapply(c(2015:2023), function(x) sum(package_cohort(country, year = x)$count, na.rm = T)), by = country])
#   expect_snapshot(copy(country_list[country == "England"])[, paste0("sum", c(15:23)) := lapply(c(2018:2022), function(x) sum(package_cohort(country, year = x)$count, na.rm = T)), by = country])
# })
#

test_that("package_cohort returns error if country arg is invalid", {
  expect_snapshot(package_cohort("Ireland"), error = TRUE)
  expect_snapshot(package_cohort(), error = TRUE)
})


test_that("package_cohort returns error if year arg is invalid", {
  expect_snapshot(package_cohort(country = "England", year = 1890), error = TRUE)
  expect_snapshot(package_cohort(country = "England", year = NULL), error = TRUE)
})



## --------hrqol_norms----------------------------------------------------------
test_that("hrqol_norms returns same as ever", {
  expect_snapshot(hrqol_norms())
  expect_snapshot(hrqol_norms(references = T))
  expect_snapshot(hrqol_norms(country = "France"))
})


## --------default_norms--------------------------------------------------------
test_that("default_norms return correct default for list of avail countries", {
  expect_snapshot(copy(country_list)[, default_norm := default_norms(country), by = country])
})


test_that("default_norms returns error if country arg is invalid", {
  expect_snapshot(default_norms("Ireland"), error = TRUE)
  expect_snapshot(default_norms(7), error = TRUE)
})


