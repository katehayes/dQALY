
## Working on period rather than cohort life tables ####



# Starts is age @ the year we care about (?) - implement that? or something more sensible?
# say the year we're going from is 2000
# then starts is 2000-yob

# below does not work even at all <3 but come back to it
# ok a little better
# but i don't have enough years

qx_cohort[, starts := 2050-yob]
qx_cohort <- qx_cohort[starts >= 0] |> setorder(starts, x, sex)


# this is where i INSIST that someone of every age is alive at the moment we start looking at them
qx_cohort[x < starts, q := 0]

qx_cohort[, l_x := cumprod(shift(1-q, fill = 1)^smr), by=.(starts, sex)]
qx_cohort[, L_x := (l_x + shift(l_x, type = "lead", fill = 0))/2, , by = .(starts, sex)]

dQALY_table <- as.data.table(utility_norms)[qx_cohort,
                                            on = .(sex, lower <= x, upper >= x),
                                            .(starts, sex, x, q, l_x, L_x, avg_hrqol)]

dQALY_table[, r_col := 0.035]


# x = 0 or starts?? i guess read the textbook
dQALY_table[x == 0, r_col := 0]
dQALY_table[x == starts, r_col := 0]


dQALY_table[, v := shift(1/cumprod(1+r_col), n = starts, type = "lag", fill = 0), by = .(starts, sex)]
dQALY_table <- dQALY_table[, .(dQALY = sum(L_x*avg_hrqol*v)), b= .(starts, sex)]








































## Here's the collapsing thing ####


diff <- 2


no_quality_weighting <- data.table(lower = 0,
                                   upper = 200,
                                   sex = c("male", "female"),
                                   avg_hrqol = 1)


calculate_dQALY(country = "England",
                year = 2019,
                norms = no_quality_weighting)

lt_graph <- function(diff = 1) {

  # what if we started with the info that is used to calculate life tables?
  # which is: mid year population, and a count of total calendar deaths (by age and sex)
  # (just for ease will make a rough version of this using the package data)
  precalc_lt <- as.data.table(package_lt(country = "England", year = 2022))[, .(m = 2*q/(2-q)), by = .(age, sex)][age <= 100]
  precalc_lt <- as.data.table(package_cohort(country = "England", year = 2022))[precalc_lt,
                                                                                on = .(age, sex)]
  precalc_lt[, totdeaths := m*count][, m := NULL]

  # collapsing at different points in the calculation makes more of a difference
  # when there is a bigger gap in mortality rates between sexes
  # so just artificially increasing male/ decreasing female mortality here
  precalc_lt[sex == "male", totdeaths := totdeaths*diff][sex == "female", totdeaths := totdeaths/diff][totdeaths > count, totdeaths := count - 1]


  # at this point we have data on midyear population & calendar deaths by age & sex
  # life tables as they are typically calculated
  sex_specific_lt <- copy(precalc_lt)
  sex_specific_lt[, m := totdeaths/count]
  sex_specific_lt[, q := 2*m/(2+m)]
  sex_specific_lt[, l := 100000*cumprod(shift(1-q, fill = 1)), by = sex]
  sex_specific_lt[, L := (l + shift(l, type = "lead", fill = 0))/2, by = sex]
  sex_specific_lt[, T := rev(cumsum(rev(L))), by = sex]
  sex_specific_lt[, e := ifelse(!is.nan(T/l), T/l, 0)]


  # useful comparator or benchmark to judge output of diff collapsing strategies?
  # we're making life tables for both sexes together, collapsing midyear pop and deaths together
  comparator <- copy(precalc_lt)[, .(count = sum(count),
                                     totdeaths = sum(totdeaths)), by = age]
  comparator[, m := totdeaths/count]
  comparator[, q := 2*m/(2+m)]
  comparator[, l := 100000*cumprod(shift(1-q, fill = 1))]
  comparator[, L := (l + shift(l, type = "lead", fill = 0))/2]
  comparator[, T := rev(cumsum(rev(L)))]
  comparator[, e := ifelse(!is.nan(T/l), T/l, 0)]



  # Here is the information we usually start our calculation with (ie get from the ONS):
  # info on m and q
  accessible_lt <- copy(sex_specific_lt)[, .(age, sex, m, q)]

  # now need to add population 'counts' to do the collapsing
  # not sure if the pop data from the ONS is the same pop data they use when making
  # life tables? maybe let's assume the pop data we have in the package is slightly
  # different? lets just use a diff year of data maybe?
  observed_count <- as.data.table(package_cohort(country = "England", year = 2018))
  accessible_lt <- observed_count[accessible_lt,
                                  on = .(age, sex)]
  # accessible_lt[, start_year_count := count + 0.5*m*count]

  # collapse at m (neil's method)
  method1 <- copy(accessible_lt)
  method1 <- method1[, .(m = sum(m*count)/sum(count)), by = age]
  method1[, q := 2*m/(2+m)]
  method1[, l := 100000*cumprod(shift(1-q, fill = 1))]
  method1[, L := (l + shift(l, type = "lead", fill = 0))/2]
  method1[, T := rev(cumsum(rev(L)))]
  method1[, e := ifelse(!is.nan(T/l), T/l, 0)]

  # collapse at l - Briggs method
  # this is the way that l(x)'s for each sex are collapsed together in the excel
  # workbook that accompanies the original methods paper
  # (doesn't use a 'count' to do the collapsing - which is an issue if we want
  # to do the calculation with a cohort that isn't the general population?)
  method2 <- copy(accessible_lt)
  method2[, l := 100000*cumprod(shift(1-q, fill = 1)), by = sex]
  method2[, interim := l/sum(l), by = age]
  method2 <- method2[, .(l = sum(l*interim)), by = age]
  method2[, L := (l + shift(l, type = "lead", fill = 0))/2]
  method2[, T := rev(cumsum(rev(L)))]
  method2[, e := ifelse(!is.nan(T/l), T/l, 0)]

  # other collapse at l
  # I added this other way of collapsing at l, just to see what happens
  # (again doesn't use a 'count' to do the collapsing)
  method3 <- copy(accessible_lt)
  method3[, l := 100000*cumprod(shift(1-q, fill = 1)), by = sex]
  method3 <- method3[, .(l = sum(l)), by = age]
  method3[, L := (l + shift(l, type = "lead", fill = 0))/2]
  method3[, T := rev(cumsum(rev(L)))]
  method3[, e := ifelse(!is.nan(T/l), T/l, 0)]

  # collapse at e (current dQALY method)
  method4 <- copy(accessible_lt)
  method4[, l := 100000*cumprod(shift(1-q, fill = 1)), by = sex]
  method4[, L := (l + shift(l, type = "lead", fill = 0))/2, by = sex]
  method4[, T := rev(cumsum(rev(L))), by = sex]
  method4[, e := ifelse(!is.nan(T/l), T/l, 0)]
  # method4 <- method4[, .(e = sum(e*start_year_count)/sum(start_year_count)), by = age]
  method4 <- method4[, .(e = sum(e*count)/sum(count)), by = age]

  # adding all methods together
  rbind(comparator[, method := "collapse pre-m"],
        method1[, method := "collapse at m (neil)"],
        method2[, method := "collapse at l (briggs)"],
        method3[, method := "collapse at l (other)"],
        method4[, method := "collapse at e (dQALY)"], fill = T)[, method:= factor(method, levels = c("collapse pre-m", "collapse at m (neil)", "collapse at l (briggs)", "collapse at l (other)", "collapse at e (dQALY)"))] |>
    ggplot() +
    # geom_line(aes(x = age, y = e, colour = method)) +
    # adding the sex-specific e's for comparison
    geom_line(data = sex_specific_lt,
              aes(x = age, y = e, group = sex),
              linetype = "dashed")

}


lt_graph(diff = 3)

# does 'count' mean something different when used to collapse
# at m and used to collapse at e?

# is e(x) life expectancy at the START of being age x?
# so count at e is like: we have this number of people who just turned x?

# and count at m is like - this is the present?? number of people who are x
# i wonder if that basically means for people with higher death rates, they
# are like......more represented than count at e












































temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables/current/nlte198020213.xlsx",
              temp, mode = "wb")

lt_male <- as.data.table(readxl::read_xlsx(temp, sheet = 5, range = "A6:F107"))
lt_male[, sex := "male"]
lt_male[, mx2 := 2*qx/(2 + qx)]



lt_female <- as.data.table(readxl::read_xlsx(temp, sheet = 5, range = "H6:M107"))
lt_female[, sex := "female"]

lt  <- rbind(lt_temp)




package_cohort("England", 2022) |>
  dplyr::as_tibble() -> cohort
package_lt("England", 2022) |>
  dplyr::as_tibble() |>
  # cut life table at 104 to match cohort
  dplyr::filter(age <= 104) |>
  dplyr::mutate(q = ifelse(age == 104, 1, q)) -> lt


lt <- dplyr::as_tibble(as.data.table(lt)[, q := mean(q), by = .(age)])
cohort <- dplyr::as_tibble(as.data.table(cohort)[, count := mean(count), by = .(age)])



# Do the calculation by sex and then collapse sex at the end (through e)
lt |>
  dplyr::mutate(l = purrr::accumulate(q, ~ .x - .x * .y, .init = 100000)[-(length(q) + 1)],
                L = (l + dplyr::coalesce(dplyr::lead(l), 0))/2,
                T = rev(cumsum(rev(L))),
                e = T/l,
                .by = sex) |>
  dplyr::left_join(cohort, by = c("sex", "age")) |>
  dplyr::summarise(e = sum(e*count)/sum(count), .by = age) |>
  dplyr::mutate(method = "end") -> method1

# Collapse sex at the start (through m) and then do the calculation overall
lt |>
  dplyr::left_join(cohort, by = c("sex", "age")) |>
  dplyr::mutate(m = 2*q/(2 + q)) -> check1

lt |>
  dplyr::left_join(cohort, by = c("sex", "age")) |>
  dplyr::mutate(m = 2*q/(2 + q)) |>
  dplyr::summarise(m = sum(m*count)/sum(count), .by = age) -> check2


lt |>
  dplyr::left_join(cohort, by = c("sex", "age")) |>
  dplyr::mutate(m = 2*q/(2 + q)) |>
  dplyr::summarise(m = sum(m*count)/sum(count), .by = age) |>
  dplyr::mutate(q = 2*m/(2 + m)) -> check3


lt |>
  dplyr::left_join(cohort, by = c("sex", "age")) |>
  dplyr::mutate(m = 2*q/(2 - q)) |>
  dplyr::mutate(q2 = 2*m/(2 + m)) -> check4


                ,
                l = purrr::accumulate(q, ~ .x - .x * .y, .init = 100000)[-(length(q) + 1)],
                L = (l + dplyr::coalesce(dplyr::lead(l), 0))/2,
                T = rev(cumsum(rev(L))),
                e = T/l) |>
  dplyr::select(age, e) |>
  dplyr::mutate(method = "start") -> method2

# Plot to compare - they are a bit different
dplyr::bind_rows(method1, method2) |>
  ggplot(aes(x = age, y = e, group = method, colour = method)) +
  geom_line()


# they are different even when men and women have the same life expectancy
# and the same age distribution
# start is higher in both cases




package_cohort("England", 2022) |>
  dplyr::as_tibble() -> cohort
package_lt("England", 2022) |>
  dplyr::as_tibble() |>
  # cut life table at 104 to match cohort
  dplyr::filter(age <= 104) |>
  dplyr::mutate(q = ifelse(age == 104, 1, q)) -> lt

# lt <- dplyr::as_tibble(as.data.table(lt)[, q := mean(q), by = .(age)])
cohort <- dplyr::as_tibble(as.data.table(cohort)[, count := mean(count), by = .(age)])

lt |>
  dplyr::left_join(cohort, by = c("sex", "age")) -> check

check <- as.data.table(check)
check[, deaths := count*q]
check[, m := deaths/(count-0.5*q*count)]
check[, m2 := 2*q/(2-q)]
check[, midpoint := count - 0.5*q*count]
# Do the calculation by sex and then collapse sex at the end (through e)
lt |>
  dplyr::mutate(l = purrr::accumulate(q, ~ .x - .x * .y, .init = 100000)[-(length(q) + 1)],
                L = (l + dplyr::coalesce(dplyr::lead(l), 0))/2,
                T = rev(cumsum(rev(L))),
                e = T/l,
                .by = sex) |>
  dplyr::left_join(cohort, by = c("sex", "age")) |>
  dplyr::summarise(e = sum(e*count)/sum(count), .by = age) |>
  dplyr::mutate(method = "end") -> method1

# Collapse sex at the start (through m) and then do the calculation overall
lt |>
  dplyr::left_join(cohort, by = c("sex", "age")) |>
  dplyr::mutate(m = 2*q/(2 - q)) |>
  dplyr::summarise(m = sum(m*count)/sum(count), .by = age) |>
  dplyr::mutate(q = 2*m/(2 + m),
                l = purrr::accumulate(q, ~ .x - .x * .y, .init = 100000)[-(length(q) + 1)],
                L = (l + dplyr::coalesce(dplyr::lead(l), 0))/2,
                T = rev(cumsum(rev(L))),
                e = T/l) |>
  dplyr::select(age, e) |>
  dplyr::mutate(method = "start") -> method2

# Plot to compare - they are a bit different
dplyr::bind_rows(method1, method2) |>
  ggplot(aes(x = age, y = e, group = method, colour = method)) +
  geom_line()




# The bigger the difference between m for men and women
# the bigger the difference between doing it at the start and the end

# why on earth is doing it at the end so much higher
# check l(x) (the briggs way)

# set it up with a realistic number of men and women over time


lt <- as.data.table(package_cohort(country = "England", year = 2020))[as.data.table(package_lt(country = "England", year = 2020))[age < 105],
                                                                      on = .(age, sex)]
lt[sex == "male", q := q*3][sex == "female", q := q/3][q > 1, q := 1]
lt[, totdeaths := count*q]
# lt[, totdeaths := totdeaths + sample(-(totdeaths/20):(totdeaths/20), size = 1), by = .(age, sex)]
lt[, midpointpop := count-0.5*totdeaths]

acceaccessible_lt[sex == "male", count := count*2][sex == "female", count := count/2]ssible_lt[sex == "male", count := count*2][sex == "female", count := count/2]

diff <- 2

lt_graph <- function(diff = 1) {

  # what if we started with the info that is used to calculate life tables?
  # which is: mid year population, and a count of total calendar deaths (by age and sex)
  # (just for ease will make a rough version of this using the package data)
  precalc_lt <- as.data.table(package_lt(country = "England", year = 2022))[, .(m = 2*q/(2-q)), by = .(age, sex)][age <= 100]
  precalc_lt <- as.data.table(package_cohort(country = "England", year = 2022))[precalc_lt,
                                                                                on = .(age, sex)]
  precalc_lt[, totdeaths := m*count][, m := NULL]

  # collapsing at different points in the calculation makes more of a difference
  # when there is a bigger gap in mortality rates between sexes
  # so just artificially increasing male/ decreasing female mortality here
  precalc_lt[sex == "male", totdeaths := totdeaths*diff][sex == "female", totdeaths := totdeaths/diff][totdeaths > count, totdeaths := count - 1]


  # at this point we have data on midyear population & calendar deaths by age & sex
  # life tables as they are typically calculated
  sex_specific_lt <- copy(precalc_lt)
  sex_specific_lt[, m := totdeaths/count]
  sex_specific_lt[, q := 2*m/(2+m)]
  sex_specific_lt[, l := 100000*cumprod(shift(1-q, fill = 1)), by = sex]
  sex_specific_lt[, L := (l + shift(l, type = "lead", fill = 0))/2, by = sex]
  sex_specific_lt[, T := rev(cumsum(rev(L))), by = sex]
  sex_specific_lt[, e := ifelse(!is.nan(T/l), T/l, 0)]


  # useful comparator or benchmark to judge output of diff collapsing strategies?
  # we're making life tables for both sexes together, collapsing midyear pop and deaths together
  comparator <- copy(precalc_lt)[, .(count = sum(count),
                                     totdeaths = sum(totdeaths)), by = age]
  comparator[, m := totdeaths/count]
  comparator[, q := 2*m/(2+m)]
  comparator[, l := 100000*cumprod(shift(1-q, fill = 1))]
  comparator[, L := (l + shift(l, type = "lead", fill = 0))/2]
  comparator[, T := rev(cumsum(rev(L)))]
  comparator[, e := ifelse(!is.nan(T/l), T/l, 0)]



  # Here is the information we usually start our calculation with (ie get from the ONS):
  # info on m and q
  accessible_lt <- copy(sex_specific_lt)[, .(age, sex, m, q)]

  # now need to add population 'counts' to do the collapsing
  # not sure if the pop data from the ONS is the same pop data they use when making
  # life tables? maybe let's assume the pop data we have in the package is slightly
  # different? lets just use a diff year of data maybe?
  observed_count <- as.data.table(package_cohort(country = "England", year = 2018))
  accessible_lt <- observed_count[accessible_lt,
                                  on = .(age, sex)]
  # accessible_lt[, start_year_count := count + 0.5*m*count]

  # collapse at m (neil's method)
  method1 <- copy(accessible_lt)
  method1 <- method1[, .(m = sum(m*count)/sum(count)), by = age]
  method1[, q := 2*m/(2+m)]
  method1[, l := 100000*cumprod(shift(1-q, fill = 1))]
  method1[, L := (l + shift(l, type = "lead", fill = 0))/2]
  method1[, T := rev(cumsum(rev(L)))]
  method1[, e := ifelse(!is.nan(T/l), T/l, 0)]

  # collapse at l - Briggs method
  # this is the way that l(x)'s for each sex are collapsed together in the excel
  # workbook that accompanies the original methods paper
  # (doesn't use a 'count' to do the collapsing - which is an issue if we want
  # to do the calculation with a cohort that isn't the general population?)
  method2 <- copy(accessible_lt)
  method2[, l := 100000*cumprod(shift(1-q, fill = 1)), by = sex]
  method2[, interim := l/sum(l), by = age]
  method2 <- method2[, .(l = sum(l*interim)), by = age]
  method2[, L := (l + shift(l, type = "lead", fill = 0))/2]
  method2[, T := rev(cumsum(rev(L)))]
  method2[, e := ifelse(!is.nan(T/l), T/l, 0)]

  # other collapse at l
  # I added this other way of collapsing at l, just to see what happens
  # (again doesn't use a 'count' to do the collapsing)
  method3 <- copy(accessible_lt)
  method3[, l := 100000*cumprod(shift(1-q, fill = 1)), by = sex]
  method3 <- method3[, .(l = sum(l)), by = age]
  method3[, L := (l + shift(l, type = "lead", fill = 0))/2]
  method3[, T := rev(cumsum(rev(L)))]
  method3[, e := ifelse(!is.nan(T/l), T/l, 0)]

  # collapse at e (current dQALY method)
  method4 <- copy(accessible_lt)
  method4[, l := 100000*cumprod(shift(1-q, fill = 1)), by = sex]
  method4[, L := (l + shift(l, type = "lead", fill = 0))/2, by = sex]
  method4[, T := rev(cumsum(rev(L))), by = sex]
  method4[, e := ifelse(!is.nan(T/l), T/l, 0)]
  # method4 <- method4[, .(e = sum(e*start_year_count)/sum(start_year_count)), by = age]
  method4 <- method4[, .(e = sum(e*count)/sum(count)), by = age]

  # adding all methods together
  rbind(comparator[, method := "collapse pre-m"],
        method1[, method := "collapse at m (neil)"],
        method2[, method := "collapse at l (briggs)"],
        method3[, method := "collapse at l (other)"],
        method4[, method := "collapse at e (dQALY)"], fill = T)[, method:= factor(method, levels = c("collapse pre-m", "collapse at m (neil)", "collapse at l (briggs)", "collapse at l (other)", "collapse at e (dQALY)"))] |>
    ggplot() +
    geom_line(aes(x = age, y = e, colour = method)) +
    # adding the sex-specific e's for comparison
    geom_line(data = sex_specific_lt,
              aes(x = age, y = e, group = sex),
              linetype = "dashed")

}

# does 'count' mean something different when used to collapse
# at m and used to collapse at e?

# is e(x) life expectancy at the START of being age x?
# so count at e is like: we have this number of people who just turned x?

# and count at m is like - this is the present?? number of people who are x
# i wonder if that basically means for people with higher death rates, they
# are like,,,, more represented than count at e



lt_graph(diff = 3)






















lt <- data.table(sex = c(rep("male", 101), rep("female", 101)),
                 age = c(0:100, 0:100))
lt[, midpointpop := 1000]
lt[, totdeaths := age*3]
lt[sex == "male", totdeaths := totdeaths + 100 + age]
lt[age == 100, totdeaths := 2000]
lt[, m := totdeaths/midpointpop]
lt[, q := 2*m/(2+m)]
lt[, l := 100000*cumprod(shift(1-q, fill = 1)), by = sex]
lt[, L := (l + shift(l, type = "lead", fill = 0))/2, by = sex]
lt[, T := rev(cumsum(rev(L))), by = sex]
lt[, e := T/l]








method1 <- copy(lt)[, .(e = sum(e*midpointpop)/sum(midpointpop)), by = age]

method2 <- copy(lt)[, .(m = sum(m*midpointpop)/sum(midpointpop)), by = age]
method2[, q := 2*m/(2+m)]
method2[, l := 100000*cumprod(shift(1-q, fill = 1))]
method2[, L := (l + shift(l, type = "lead", fill = 0))/2]
method2[, T := rev(cumsum(rev(L)))]
method2[, e := T/l]


rbind(method1[, method := "end"],
      method2[, method := "start"], fill = T) |>
  ggplot() +
  geom_line(aes(x = age, y = e, colour = method), size = 1) +
  geom_line(data = method0,
            aes(x = age, y = e), colour = "black", linetype = "dashed", size = 1) +
  geom_line(data = lt,
            aes(x = age, y = e, group = sex), colour = "black")











lt <- as.data.table(package_lt("England", year = 2019))
# lt[sex == "male", q := 10*q][q > 1, q := 0.999]
lt[, q := mean(q), by = age]
lt[sex == "male" & age == 75, q := 0.99]
lt[, count := 1]

method1 <- copy(lt)[, l := 100000*cumprod(shift(1-q, fill = 1)), by = sex]
method1[, L := (l + shift(l, type = "lead", fill = 0))/2, by = sex]
method1[, T := rev(cumsum(rev(L))), by = sex]
method1[, e := T/l][is.nan(e), e := 0]
sex_sep <- copy(method1)
method1 <- method1[, .(e = sum(e*count)/sum(count)), by = age]

method2 <- copy(lt)[, m := 2*q/(2-q)][, .(m = sum(m*count)/sum(count)), by = age]
method2[, q := 2*m/(2+m)]
method2[, l := 100000*cumprod(shift(1-q, fill = 1))]
method2[, L := (l + shift(l, type = "lead", fill = 0))/2]
method2[, T := rev(cumsum(rev(L)))]
method2[, e := T/l]



rbind(method1[, method := "end"],
      method2[, method := "start"],
      fill = T) |>
  ggplot() +
  geom_line(aes(x = age, y = e, colour = method), size = 1) + geom_line(data = sex_sep, aes(x = age, y = e, group = sex))





library(data.table)





|> setnames(old = "starts", new = "x")




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



