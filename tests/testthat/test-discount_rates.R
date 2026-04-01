# testthat::test_file("tests/testthat/test-discount_rates.R")
# --------Tests-----------------------------------------------------------------
## --------r_default------------------------------------------------------------
test_that("r_default returns correct value", {
  expect_equal(r_default(), 0.035)
  expect_equal(r_default(1), 0.035)
  expect_equal(r_default(1000000), 0.035)
})

## --------r_health-------------------------------------------------------------
test_that("r_health returns correct value", {
  expect_equal(r_health(), 0.015)
  expect_equal(r_health(1), 0.015)
  expect_equal(r_health(1000000), 0.015)
})

## --------r_lt_health----------------------------------------------------------
test_that("r_lt_health returns correct value", {
  expect_snapshot(data.table(x = c(0:200))[, r := r_lt_health(x)])
})

## --------r_lt_health_reduced----------------------------------------------------------
test_that("r_lt_health_reduced returns correct value", {
  expect_snapshot(data.table(x = c(0:200))[, r := r_lt_health_reduced(x)])
})
