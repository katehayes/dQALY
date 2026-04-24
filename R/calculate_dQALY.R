# age utils - don't need to specify the upper bound - last one is assumed to go to infinity
# how you treat the last one is a bit up in the air.
# always use lower to calculate upper on the fly
# why do we need to give the upper as well

# see here for an uncertainty approach
# https://bmjopen.bmj.com/content/14/3/e076704
# Approached via the Sullivan method, the uncertainty of health expectancies
# arises from the sum of its two component parts: the health and the mortality
# components.31 We estimated the uncertainty of QALE point estimates considering
# these two components and as described by Jagger et al.31


# feels possibly relevant:
# https://www.sciencedirect.com/science/article/pii/S0895435622001639


# -------------------------------------------------------------------------
#' Calculating QALY loss on death
# -------------------------------------------------------------------------
#'
# -------------------------------------------------------------------------
#' @param country `[string]`
#'
#' The name of a country (for which data is available & stored in the package).
#' Case-sensitive - please use function `hrqol_norms` to see the list of permissible country names.
#' Defaults to `NULL`.
#'
#' @param year `[integer]`
#'
#' A year (for which data is available & stored in the package).
#' Defaults to `NULL`.
#'
#' @param life_table `[data frame]` or `[tibble]` or `[data table]`
#'
#' The life table data that will be used in the QALY loss calculation.
#'
#' The default value for this argument is a call to a function - `package_lt(country, year)` -
#' which returns life table data stored by the package.
#'
#' We can see that this default depends on the user having specified values for
#' arguments `country` and `year`. Alternatively, the user can specify values for
#' `country` and `year` within the `package_lt` arguments. See examples & the
#' documentation for `package_lt` for more details.
#'
#' Additionally, users can supply their own life table data to the function, if they
#' want to perform the calculation with something other than the life table data
#' stored by the package. The life tables can be given in the form of a data frame, tibble,
#' or data table, and must have columns named 'sex', 'age', and 'q' (probability of death).
#'
#' @param norms `[data frame]` or `[tibble]` or `[data table]`
#'
#' The HRQoL data that will be used in the QALY loss calculation.
#'
#' The default value for this argument is a call to a function - `package_norms(country)` -
#' which returns HRQoL norms stored by the package.
#'
#' We can see that this default depends on the user having specified values for
#' arguments `country` . Alternatively, the user can specify values for
#' `country` within the `package_norms` arguments. See examples & the
#' documentation for `package_norms` for more details.
#'
#' Additionally, users can supply their own norms to the function, if they
#' want to perform the calculation with something other than the HRQoL data
#' stored by the package. The norms can be given in the form of a data frame, tibble,
#' or data table, and must have columns named 'lower' (lower bound of age band),
#' 'upper' (upper bound of age band), 'sex', and 'avg_hrqol' (utility score).
#'
#' @param r `[numeric]` or `[function]`
#'
#' Represents the discount rate that will be used in the calculation.
#' Defaults to 0.035 - the NICE reference case discount rate of 3.5%
#'
#' If `r` is numeric, it must be a numeric scalar between 0 and 1.
#'
#' Alternatively, to allow the user to specify a discount rate that varies
#' across time, `r` can be a vectorised function.
#'
#' The function must take as an argument an integer greater than 0 - for example
#' 'x' - and return and return the desired discount rate 'x' years into the future.
#'
#' @param smr `[numeric]`
#'
#' A standardised mortality ratio.
#'
#' Allows the user to make crude adjustments to packaged life table data,
#' which represent average life expectancy at country level.
#'
#' `smr` defaults to 1.
#'
#' If it is greater than/ less than 1 - for example 1.05/0.95 -
#' the calculation will estimate QALY loss due to death for a population assumed
#' to have a mortality rate 5% greater/lower than average mortality rate in the
#' selected country.
#'
#' @param qcm `[numeric]`
#'
#' Allows the user to make crude adjustments to the packaged utility data,
#' which represent average health-related quality of life at country level.
#'
#' `qcm` defaults to 1.
#'
#' If it is greater than/ less than 1 - for example 1.05/0.95 -
#' the calculation will estimate QALY loss due to death for a population assumed
#' experience health-related quality of life 5% greater/lower than the average
#' health related quality of life in the selected country.
#'
#'
#' @param collapse_age `[boolean]` or `[data frame]` or `[tibble]` or `[data table]`
#'
#' Allows users to control how function outputs are grouped by age.
#'
#' If `FALSE` (default), the function outputs an estimate of QALY loss due to
#' death for every year of age.
#'
#' Alternatively, if the user passes a data frame, tibble or data table that
#' describe a set of age groups to `collapse_age`, the function will return the
#' average QALY loss due to death for those age groups. The data frame, tibble,
#' or data table must have two columns named 'lower' and 'upper', indicating the
#' lower and upper bounds of the desired age groups. See the examples for more
#' details.
#'
#' If `collapse_age` is set to `TRUE`, the function outputs a single average
#' estimate of QALY loss due to death, aggregated across all ages - this is
#' equivalent to supplying a single age group that encompasses all ages.
#'
#'
#' @param collapse_sex `[boolean]`
#'
#' Allows users to control whether or not the function outputs sex-specific
#' estimates.
#'
#' If `FALSE` (default), outputted estimates are sex-specific. If `collapse_sex`
#' is set to `TRUE`, then the function outputs estimates aggregated across sex.
#'
#'
#' @param cohort `[data frame]` or `[tibble]` or `[data table]`
#'
#' The cohort data that will be used to calculate weighted averages iff the user
#' chooses to have the function output grouped estimates, as in that case we need
#' to assume a distribution for the population.
#'
#' The default value for this argument is a call to a function -
#' `package_cohort(country, year)` - which returns cohort data stored by the package.
#'
#' We can see that this default depends on the user having specified values for
#' arguments `country` and `year`. Alternatively, the user can specify values for
#' `country` and `year` within the `package_cohort` arguments. See examples & the
#' documentation for `package_lt` for more details.
#'
#' Additionally, users can supply their own cohort data to the function, specifying
#' a population distribution across age and sex, if they want to perform the
#' calculation with something other than the cohort data stored by the package.
#' Cohort data can be given in the form of a data frame, tibble,
#' or data table, and must have columns named 'sex', 'age', and 'count'.
#'
# -------------------------------------------------------------------------
#' @returns
#'
#' A data frame. The data frame will have column `dQALY`, containing estimates
#' of QALY loss due to death. Additionally, depending on how the user chooses
#' to group function outputs, the data frame may additional columns
#' `sex`, `age`, and `lower`/`upper` (representing the lower and upper bounds
#' of age groups).
#'
# -------------------------------------------------------------------------
#' @examples
#' #Output a table of dQALY values for all ages/genders, minimally specifying year & country
#' calculate_dQALY(country = "United Kingdom", year = 2019)
#'
#'
#' #Output a table of dQALY values for all ages/genders, specifying year, country and
#' #selecting a set of norms other than the default set for that country
#' calculate_dQALY(country = "United Kingdom", year = 2019,
#'                 norms = package_norms(country, id ="janssen_euvas"))
#'
#'
#' #Output a table of dQALY values for all ages/genders, specifying year & country,
#' #with user-supplied norms
#' my_norms <- data.frame(sex = c(rep("male", 3), rep("female", 3)),
#'                        lower = c(0, 20, 90),
#'                        upper = c(19, 89, 150),
#'                        avg_hrqol = c(1, 0.85, 0.67, 0.99, 0.4, 0.2))
#' calculate_dQALY(country = "United Kingdom", year = 2019, norms = my_norms)
#'
#'
#' #Output a table of dQALY values for all ages/genders, with user-specified norms and life tables
#' my_life_table <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
#'                             age = c(0:100, 0:100),
#'                             q = c(seq(0, 1, 0.01)))
#'
#' calculate_dQALY(life_table = my_life_table, norms = my_norms)
#'
#'
#' #Calculate dQALY values using a variable discount rate
#' rfun = function(x) ifelse(x < 31, 0.015, ifelse(x > 75, 0.0107, 0.0129))
#' calculate_dQALY(country = "United Kingdom", year = 2019, r = rfun)
#'
#'
#' #Calculate grouped dQALY values - using default country-level population weightings:
#' #1) collapse sex
#' calculate_dQALY(country = "United Kingdom", year = 2019,
#'                 collapse_sex = TRUE)
#' #2) age groups
#' my_age_groups <- data.frame(lower = c(seq(0,90,5)), upper = c(seq(4,89,5), 100))
#' calculate_dQALY(country = "United Kingdom", year = 2019,
#'                 collapse_age = my_age_groups)
#' #3) collapse sex and group age
#' calculate_dQALY(country = "United Kingdom", year = 2019,
#'                 collapse_age = my_age_groups, collapse_sex = TRUE)
#'
#' #Do any of these groupings with a user-supplied cohort
#' my_cohort <- data.frame(sex = c(rep("male", 5), rep("female", 8)),
#'                         age = c(89:93, 89:92, 95:97, 100),
#'                         count = c(1, 1, 2, 1, 1, 3, 2, 1, 1, 2, 1, 1, 1))
#' #note: any age and gender for which no count value is supplied is considered
#' #outside the cohort (count zero)
#' #1) collapse sex
#' calculate_dQALY(country = "United Kingdom", year = 2019,
#'                 collapse_sex = TRUE, cohort = my_cohort)
#' #2) age groups (note: of the age groups specified, only estimates for age groups that contain a
#' #member of the specified cohort are returned)
#' calculate_dQALY(country = "United Kingdom", year = 2019,
#'                 collapse_age = my_age_groups, cohort = my_cohort)
#' #3) collapse sex and group age
#' calculate_dQALY(country = "United Kingdom", year = 2019,
#'                 collapse_age = my_age_groups,
#'                 collapse_sex = TRUE, cohort = my_cohort)
#'
#' #It's possible (though perhaps not often advisable) to perform the calculation
#' #using data from various countries/years
#' calculate_dQALY(life_table = package_lt(country = "England", year = 2019),
#'                 norms = package_norms(country = "France"),
#'                 cohort = package_cohort(country = "Spain", year = 2020),
#'                 collapse_sex = TRUE)
# -------------------------------------------------------------------------
#' @export
calculate_dQALY <- function(country = NULL,
                            year = NULL,
                            life_table = package_lt(country, year),
                            norms = package_norms(country), # is it ridiculous to have three nested function calls
                            r = 0.035,
                            smr = 1, qcm = 1,
                            collapse_age = FALSE,
                            collapse_sex = FALSE,
                            cohort = package_cohort(country, year)) {
  # if you specify a country and a year argument, those are the default for the
  # get package data function args- but you can override with the country/year
  # args in the package functions if you want. is that a sensible set up?

  # Capturing the environment here because we're using data.table
  env <- environment()

  # due to NSE notes in R CMD check
  # . <-  avg_hrqol <- count <- default <- dQALY_x <- increment <- lower <- NULL
  # l_x <- L_x <- norm_country <- norm_id <- qmax <- q_x <- r_col <- sex <- NULL
  # upper <- x <- xmax <- NULL


  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # # # # #
  # # # # # # 1.Validity checks # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  # lots of the checks are done with internal functions, found at the end of
  # this script
  # While doing validity checks on life tables, norms, cohort, we also set
  # up the data for use later in the function

  # # # # # # # # # 1.1 combination of arguments # # # # # # # # # # # # # # #
  # Previously at this point we checked whether the user has given an ok
  # combination of arguments - need to think about whether this would still be
  # necessary
  # for example do we want to stop people from doing something like this:
  # calculate_dQALY(year = 2019,
  #                   life_table = package_lt(country = "England", year),
  #                   norms = package_norms(country = "France"),
  #                   cohort = package(country = "Spain", year))



  # # # # # # # # # 1.2 country, year # # # # # # # # # # # # # # # # # # # # #
  # previously at this point we did validity checks for appropriate values for
  # country, year - these are relevant when the user wants to use our package data
  # Now the checks are done inside the use package data functions instead





  # # # # # # # # # 1.3 life_table, norms, cohort # # # # # # # # # # # # # # #
  # Will bring this up to discuss whenever next meeting -
  # I'm trying to use rlang to delay the evaluation of user-supplied (as opposed
  # to default) arguments
  # (I have read that) Default arguments are evaluated inside the function
  # & user-supplied arguments are evaluated outside the function

  # this is the reason I want to delay the evaluation of non-default arguments:
  # Say the user wants to use package life tables but doesn't want to extend them
  # - so this is moving away from the default life_table argument where
  # the argument lt_extend of the function package_lt is set to TRUE -
  # I'd like the user to be able to write this
  # calculate_dQALY(country = "England", year = 2019,
  #                 life_table = package_lt(lt_extend = FALSE))
  # rather than have to write this to avoid erroring:
  # calculate_dQALY(country = "England", year = 2019,
  #                 life_table = package_lt(country = "England", year = 2019, lt_extend = FALSE))
  # So (I think) I want the user-supplied argument evaluated inside the function, where
  # values for country and year are defined

  # I don't have a good working understanding of environments/evaluation and so on
  # so I have little confidence in this set-up - but, as I said, will ask about it
  # in next meeting



  # here's a problem caused by this evaluation thing i think:
  # norm_id <- "vih_primary"
  # calculate_dQALY(country = "England",
  #                 year = 2020,
  #                 norms = package_norms(country, id = "vih_primary"))
  # calculate_dQALY(country = "England",
  #                 year = 2020,
  #                 norms = package_norms(country, id = norm_id))
  # the first call works fine but the second errors
  # presumably because I'm delaying the evaluation of the expression passed to the
  # norms argument --
  # and since norm_id is one of the objects that gets set to null at the beginning
  # of the function to avoid the check flags, then when it gets evaluated it is
  # evaluated as NULL?
  # could we just not set things to NULL?



  # Setting up the life table that will be used in the calculation
  exprssn <- rlang::enexpr(life_table)

  if(is.call(exprssn)) {
    if(rlang::call_name(exprssn) == "package_lt") {
      # we're using the package data function - evaluate the expression now
      # checks for valid country, year, and extend argument happen inside the package_lt function
      exprssn <- rlang::call_match(exprssn, package_lt)

      if(is.null(exprssn$country)) {
        exprssn$country <- country
      }

      if(is.null(exprssn$year)) {
        exprssn$year <- year
      }

      life_table <- eval(exprssn) |>
        setDT() |>
        setnames(old = c("age", "q"),
                 new = c("x", "q_x"))

    } else {
      # its a user supplied function (but not the package data function)
      # check it meets standards
      if(!.is_valid_custom_lt(life_table)) {
        stop("User-supplied life tables have failed validity checks.")
      } else {
        life_table <- as.data.table(life_table) |>
          setnames(old = c("age", "q"),
                   new = c("x", "q_x"))
      }
    }

  } else {
    # its a user supplied list-like object- check it meets standards
    if(!.is_valid_custom_lt(life_table)) {
      stop("User-supplied life tables have failed validity checks.")
    } else {
      life_table <- as.data.table(life_table) |>
        setnames(old = c("age", "q"),
                 new = c("x", "q_x"))
    }
  }


  # Setting up the utility norms that will be used in the calculation
  exprssn <- rlang::enexpr(norms)
  if(is.call(exprssn)) {
    if(rlang::call_name(exprssn) == "package_norms") {

      exprssn <- rlang::call_match(exprssn, package_norms)

      if(is.null(exprssn$country)) {
        exprssn$country <- country
      }

      # we're using the package data function - evaluate the expression now
      # checks for valid country, norm id, and avg_hrqol_young argument
      # happen inside the package_norms function
      utility_norms <- eval(exprssn) |>
        setDT()
    } else {
      # its a function but not the package data function
      if(!.are_valid_custom_norms(norms)) {
        stop("User-supplied utility norms have failed validity checks.")
      } else {
        utility_norms <- as.data.table(norms)
      }
    }
  } else {
    # its a user supplied list-like object - check it meets standards
    if(!.are_valid_custom_norms(norms)) {
      stop("User-supplied utility norms have failed validity checks.")
    } else {
      utility_norms <- as.data.table(norms)
    }
  }





  # check whether we need a cohort - i.e. check whether the user wants
  # grouped output. otherwise we won't need to set a value for the cohort object
  # If we're grouping, then set up the cohort that will be used to take weighted averages
  if(.will_group(env$collapse_age, env$collapse_sex)) {

    exprssn <- rlang::enexpr(cohort)
    if(is.call(exprssn)) {
      if(rlang::call_name(exprssn) == "package_cohort") {

        exprssn <- rlang::call_match(exprssn, package_cohort)

        if(is.null(exprssn$country)) {
          exprssn$country <- country
        }

        if(is.null(exprssn$year)) {
          exprssn$year <- year
        }

        # we're using the package data function - evaluate the expression now
        # checks for valid country & year happen inside the package_cohort function
        cohort <- eval(exprssn) |>
          setDT() |>
          setnames(old = c("age"),
                   new = c("x"))

      } else {
        # its a function but not the package data function
        if(!.is_valid_custom_cohort(cohort)) {
          stop("User-supplied cohort has failed validity checks.")
        } else {
          cohort <- as.data.table(cohort)
          setnames(cohort,
                   old = c("age"),
                   new = c("x"))

        }
      }
    } else {
      # its a user-supplied list-like object - check it meets standards
      if(!.is_valid_custom_cohort(cohort)) {
        stop("User-supplied cohort has failed validity checks.")
      } else {
        cohort <- as.data.table(cohort)
        setnames(cohort,
                 old = c("age"),
                 new = c("x"))

      }
    }

  }



  # # # # # 1.4 grouping arguments: collapse_age, collapse_sex # # # # # # # # #

  if(length(collapse_age) > 1L) {
    if(!.are_valid_custom_age_groups(collapse_age)) {
      stop("User-supplied age groups for grouping output, supplied in argument 'collapse_age', have failed validity checks.")
    } else {
      age_groups <- as.data.table(collapse_age)
    }
  }

  if (length(collapse_sex) != 1L || is.na(collapse_sex) || !is.logical(collapse_sex)) {
    stop("The argument 'collapse_sex' must be a boolean value.") # Set 'collapse_sex' to TRUE if you would like ...
  }


  # # # # # # # # # # # # 1.5 r, smr, qcm # # # # # # # # # # # # # # # # # # #

  if(!.is_valid_r(r)) {
    stop("Parameter r must be a numeric scalar between 0 and 1 or a function that
          specifies how the discount rate changes over time.
          See the README for examples of valid values for r.")
    # The function should take one argument (time point - number of years into the future) and return the desired discount rate at that time point.
  }

  if(!.is_valid_smr(smr)) {
    stop("Argument 'smr' must be a numeric scalar.")
  }


  if(!.is_valid_qcm(qcm)) {
    stop("Argument 'qcm' must be a numeric scalar.")
  }




  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # 3. Calculating dQALY # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


  # life tables might have different lengths (UN goes to 99, ONS to 100),
  # so taking lengths here, to be used in calculations below
  # assuming there is the same number of years of data for men & women
  min_x <- min(life_table$x)
  max_x <- max(life_table$x)


  # change from briggs method bc of issue raised by Neil
  # here's the big difference - going to assume we start with n men and n women of each age - letting n = 1
  # & will work all the intermediate variables out separately by age at the 'start' ie the first point in the time horizon of the calculation
  # still assuming q(x) and avg_hrqol constant over time - but i think setting the calculation up like this would make it easier to change that
  life_table <- life_table[, .(starts = c(min_x:max_x)), by = .(sex, x, q_x)] |> setorder(starts, x, sex)
  life_table[x < starts, q_x := 0]


  # we have q(x) - probability of dying at age x
  # first calculating l(x): the number surviving to age x >= 1 (in a population of 1)
  # again we're converting the probability q(x) to an instantaneous death rate,
  # adjusting the rate w parameter smr (if desired), then converting back to a probability
  # (here to probability of surviving ie 1-prob of dying)
  # then calculating L(x): years lived between ages x & x+1 for x>=1: (l(x) + l(x+1))/2
  # Note: This calculation assumes a uniform distribution of deaths during the year
  life_table[, l_x := cumprod(shift(1-q_x, fill = 1)^smr), by=.(starts, sex)]
  life_table[, L_x := (l_x + shift(l_x, type = "lead", fill = 0))/2, , by = .(starts, sex)]

  # assigning the appropriate population-level utility norm to corresponding age, sex
  # dropping l(x) bc we only need L(x) for the QALY calculation
  dQALY_table <- utility_norms[life_table,
                         on = .(sex, lower <= x, upper >= x),
                         .(starts, sex, x, q_x, l_x, L_x, avg_hrqol)]

  # adding this line below - so that if the calculation is involving life tables that reach
  # older age groups than the utility norm data being supplied, then we just assume
  # utility after that point is 0 and the rest of the calculation can happen
  # Note: relying on validity checks to catch it if user-supplied norms don't give
  # data for low enough/high enough age groups
  dQALY_table[is.na(avg_hrqol), avg_hrqol := 0]

  # We now have an estimate of the number of years lived between ages x & x+1
  # and a number between 0 and 1 representing the avg quality of life experienced at age x

  # to calculate QALY loss due to death we need to discount the future losses - get net present value of loss
  # making a matrix of zeros and powers of 1/(1+r)
  # getting a discounted sum of life years lost from age x onwards via matrix multiplication


  if (is.function(r)) {
    dQALY_table[, r_col := r(x)]
  } else {
    dQALY_table[, r_col := r]
  }


  dQALY_table[x == 0, r_col := 0]

  # change away from Briggs method -
  # no longer doing matrix multiplication because of the new data structure
  # l(x) is no longer in the denominator (bc we said its one in all cases)
  dQALY_table[, v := shift(1/cumprod(1+r_col), n = starts, type = "lag", fill = 0), by = .(starts, sex)]
  dQALY_table <- dQALY_table[, .(dQALY_x = sum(L_x*avg_hrqol*v)), b= .(starts, sex)] |> setnames(old = "starts", new = "x")

  # note - fix ordering of output - by x and then sex?


  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # 4. (if desired) Grouping output # # # # # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  # if dQALY values need to be calculated for a set of population groups
  if(.will_group(env$collapse_age, env$collapse_sex)) {

    dQALY_table <- dQALY_table[cohort,
                               on = .(sex, x)]

    # adding in this line here below
    # in case user supplies cohort with some years of age > 120
    # will just set all missing dQALY values to 0
    # that means that user can (for example) supply a cohort where someone is
    # older than 120 and also ask for output to be grouped & one of the groups
    # is (again, for example) 100:200 - and the grouped dQALY value for that
    # oldest group won't be NA & will take into account the fact that the user
    # has insisted there is a person alive in their cohort older than 120
    dQALY_table[is.na(dQALY_x), dQALY_x := 0]


    # if the user wants to collapse into AGE GROUPS (not just collapse age entirely)
    # - and has indicated this by supplying a set of age groups to the collapse_age
    # argument then add this information about what their desired age groups are into
    # the dQALY table
    if(length(collapse_age) > 1L) {

      age_groups <- age_groups[, .(age = paste(lower, upper, sep = "-"),
                                   x = c(lower:upper)), by = c("lower", "upper")]

      dQALY_table <- dQALY_table[age_groups,
                                 on = .(x),
                                 nomatch = NULL]

    }


    # assign a value to cols (vector of column names) based on whether the user
    # wants to collapse by age group, sex, or both note: previously, if the user
    # wanted to collapse age completely then they needed to specify an age group
    # like (0-120) - now if they want to do this they set collapse_age = TRUE.
    # (supplying age group 0-120 would still work though)
    if(length(collapse_age) > 1L) {
      cols <- c("age", "lower", "upper")
    } else if(collapse_age == TRUE) {
      cols <- character()
    } else if(collapse_age == FALSE) {
      cols <- c("x")
    }

    if(collapse_sex == F){
      cols <- c(cols, "sex")
    }

    # calculate a weighted mean dQALY value for each population group, using vector of column name cols
    dQALY_table <- dQALY_table[, .(dQALY_x = sum(dQALY_x*count)/sum(count)), by = cols]

  }

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # 5. Some final organising of the output # # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  # changing column names, turning data.table into data.frame
  # NOTE: not sure of what final output column names should be
  dQALY_table |>
    setnames(old = c("x", "dQALY_x"),
             new = c("age", "dQALY"),
             skip_absent = TRUE)

  setDF(dQALY_table)

  dQALY_table

}





# -------------------------------------------------------------------------
#' Calculate quality-adjusted life expectancy
# -------------------------------------------------------------------------
#' @description
#' Calculates quality-adjusted life expectancy for a given country and year
# -------------------------------------------------------------------------
#' @param country `[string]`
#'
#' The name of a country (for which data is available & stored in the package).
#' Case-sensitive - please use function `hrqol_norms` to see the list of permissible country names.
#' Defaults to `NULL`.
#'
#' @param year `[integer]`
#'
#' A year (for which data is available & stored in the package).
#' Defaults to `NULL`.
#'
#' @param life_table `[data frame]` or `[tibble]` or `[data table]`
#'
#' The life table data that will be used in the QALY loss calculation.
#'
#' The default value for this argument is a call to a function - `package_lt(country, year)` -
#' which returns life table data stored by the package.
#'
#' We can see that this default depends on the user having specified values for
#' arguments `country` and `year`. Alternatively, the user can specify values for
#' `country` and `year` within the `package_lt` arguments. See examples & the
#' documentation for `package_lt` for more details.
#'
#' Additionally, users can supply their own life table data to the function, if they
#' want to perform the calculation with something other than the life table data
#' stored by the package. The life tables can be given in the form of a data frame, tibble,
#' or data table, and must have columns named 'sex', 'age', and 'q' (probability of death).
#'
#' @param norms `[data frame]` or `[tibble]` or `[data table]`
#'
#' The HRQoL data that will be used in the QALY loss calculation.
#'
#' The default value for this argument is a call to a function - `package_norms(country)` -
#' which returns HRQoL norms stored by the package.
#'
#' We can see that this default depends on the user having specified values for
#' arguments `country` . Alternatively, the user can specify values for
#' `country` within the `package_norms` arguments. See examples & the
#' documentation for `package_norms` for more details.
#'
#' Additionally, users can supply their own norms to the function, if they
#' want to perform the calculation with something other than the HRQoL data
#' stored by the package. The norms can be given in the form of a data frame, tibble,
#' or data table, and must have columns named 'lower' (lower bound of age band),
#' 'upper' (upper bound of age band), 'sex', and 'avg_hrqol' (utility score).
#'
#' @param smr `[numeric]`
#'
#' A standardised mortality ratio.
#'
#' Allows the user to make crude adjustments to packaged life table data,
#' which represent average life expectancy at country level.
#'
#' `smr` defaults to 1.
#'
#' If it is greater than/ less than 1 - for example 1.05/0.95 -
#' the calculation will estimate QALY loss due to death for a population assumed
#' to have a mortality rate 5% greater/lower than average mortality rate in the
#' selected country.
#'
#' @param qcm `[numeric]`
#'
#' Allows the user to make crude adjustments to the packaged utility data,
#' which represent average health-related quality of life at country level.
#'
#' `qcm` defaults to 1.
#'
#' If it is greater than/ less than 1 - for example 1.05/0.95 -
#' the calculation will estimate QALY loss due to death for a population assumed
#' experience health-related quality of life 5% greater/lower than the average
#' health related quality of life in the selected country.
#'
#'
#' @param collapse_age `[boolean]` or `[data frame]` or `[tibble]` or `[data table]`
#'
#' Allows users to control how function outputs are grouped by age.
#'
#' If `FALSE` (default), the function outputs an estimate of QALY loss due to
#' death for every year of age.
#'
#' Alternatively, if the user passes a data frame, tibble or data table that
#' describe a set of age groups to `collapse_age`, the function will return the
#' average QALY loss due to death for those age groups. The data frame, tibble,
#' or data table must have two columns named 'lower' and 'upper', indicating the
#' lower and upper bounds of the desired age groups. See the examples for more
#' details.
#'
#' If `collapse_age` is set to `TRUE`, the function outputs a single average
#' estimate of QALY loss due to death, aggregated across all ages - this is
#' equivalent to supplying a single age group that encompasses all ages.
#'
#'
#' @param collapse_sex `[boolean]`
#'
#' Allows users to control whether or not the function outputs sex-specific
#' estimates.
#'
#' If `FALSE` (default), outputted estimates are sex-specific. If `collapse_sex`
#' is set to `TRUE`, then the function outputs estimates aggregated across sex.
#'
#'
#' @param cohort `[data frame]` or `[tibble]` or `[data table]`
#'
#' The cohort data that will be used to calculate weighted averages iff the user
#' chooses to have the function output grouped estimates, as in that case we need
#' to assume a distribution for the population.
#'
#' The default value for this argument is a call to a function -
#' `package_cohort(country, year)` - which returns cohort data stored by the package.
#'
#' We can see that this default depends on the user having specified values for
#' arguments `country` and `year`. Alternatively, the user can specify values for
#' `country` and `year` within the `package_cohort` arguments. See examples & the
#' documentation for `package_lt` for more details.
#'
#' Additionally, users can supply their own cohort data to the function, specifying
#' a population distribution across age and sex, if they want to perform the
#' calculation with something other than the cohort data stored by the package.
#' Cohort data can be given in the form of a data frame, tibble,
#' or data table, and must have columns named 'sex', 'age', and 'count'.
#'
#'
# -------------------------------------------------------------------------
#' @returns
#'
#' A data frame. The data frame will have column `QALE` (quality adjusted life
#' years). Additionally, depending on how the user chooses
#' to group function outputs, the data frame may additional columns
#' `sex`, `age`, and `lower`/`upper` (representing the lower and upper bounds
#' of age groups).
#'
# -------------------------------------------------------------------------
#' @examples
#' #See documentation for function calculate_dQALY for more examples
#' calculate_QALE(country = "England", year = 2018)
# -------------------------------------------------------------------------
#' @export
calculate_QALE <- function(country = NULL, #population
                           year = NULL,
                           life_table = package_lt(country, year,
                                                   lt_extend = TRUE),
                           norms = package_norms(country,
                                                 id = default_norms(country),
                                                 avg_hrqol_young = NULL),
                           smr = 1, qcm = 1,
                           collapse_age = FALSE,
                           collapse_sex = FALSE,
                           cohort = package_cohort(country, year)) {

  QALE_table <- calculate_dQALY(country = country,
                                year = year,
                                life_table = life_table,
                                norms = norms,
                                smr = smr,
                                qcm = qcm,
                                collapse_age = collapse_age,
                                collapse_sex = collapse_sex,
                                cohort = cohort,
                                r = 0)

  names(QALE_table)[names(QALE_table) == "dQALY"] <- "QALE"

  QALE_table

}






# ------------------------------------------------------------------------- #
# ---------------- INTERNALS - VALIDITY CHECKING -------------------------- #
# ------------------------------------------------------------------------- #

.will_group <- function(collapse_age, collapse_sex) {
  if(length(collapse_age) > 1L) {
    return(TRUE)
  } else if(collapse_age == TRUE | collapse_sex == TRUE) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

# --------Checking for appropriate combinations of arguments ---------------#

# old function is defunct - will think about writing new


# --------Checks at the single argument level---------------------------------#


# should we also check in this function or in another that the values supplied
# are appropriate (numeric scalar r should be between 0 and 1,
# function r should output number between 0 and 1 for inputs 0-120)
.is_valid_r <- function(r) {
  if (is.numeric(r) && length(r) == 1L && !is.na(r)) {
    if (r < 0 | r > 1) {
      # error or warning? something like this?
      warning("The value you have set for parameter r (the discount rate) is not between 0 and 1.
               In practice, discount rates are rarely outside of this range.
               Note that the QALY loss estimates you produce using this discount rate are likely innapropriate for use in most analyses.")
    }
    return(TRUE)
  }

  if (is.function(r)) {
    args <- formals(r)
    if (length(args) != 1L) {
      return(FALSE)
    }
    if (any(sapply(c(0:120), r) < 0 | sapply(c(0:120), r) > 1)) {
      warning("The function you have supplied for parameter r (which sets the discount rate) returns values that are not between 0 and 1.
               In practice, discount rates are rarely outside of this range.
               Note that the QALY loss estimates you produce using this discount rate are likely innapropriate for use in most analyses.")
    }
    return(TRUE)
  }

  FALSE

}


.is_valid_qcm <- function(qcm) {
  if (is.numeric(qcm) && length(qcm) == 1L && !is.na(qcm)) {
    if (qcm < 0) {
      warning("Argument `qcm` cannot take negative values.")
      return(FALSE)
    }
    return(TRUE)
  }
  FALSE
}

.is_valid_smr <- function(smr) {
  if (is.numeric(smr) && length(smr) == 1L && !is.na(smr)) {
    if (smr < 0 ) {
      warning("Argument `smr` cannot take negative values.")
      return(FALSE)
    }
    return(TRUE)
  }
  FALSE
}





# --------Checks at the single argument level when user is supplying own data---------------------------------
# need some decisions made about how much data/how complete the data the user
# supplies has to be/ how unlikely (data supplied for really old ages) it can be?

# what about something like the following:
# all packaged data (life tables, norms, cohorts) goes 0 to 120 (as default - users
# can still currently decide against extending life tables)
# all user supplied life tables/norms have to go 0 to 99 and can go further (as far as they want)
# user-supplied cohorts can do whatever, even things that make little sense
# (eg include a person aged 200)

# what should happen when there are mismatches between the years of age spanned/present
# in the different pieces of data?
# 1. validity checks should demand 0-99 inclusive for life tables and age groups that
# span 0-99 inclusive from utility norms. So the issues will be in the upper end of
# the age range - e.g. max age for life tables > max age for norms/
# max age for cohort > max age for life tables & norms

# 2. In general, the calculation should still run without throwing an error,
# but the dQALY values outputted should just be zero - since this will only be
# happening for older ages I think its ok to assume that the QALY loss due to death
# in these age groups is 0?

# 3. In the case of awkward mismatches between cohorts & user-supplied
# age groups - (hopefully this won't happen with frequency) -
# if the user supplies an age group, and the cohort that is in use in the calculation
# has no people at all within that age group, then the age group will just not
# appear in the function output (e.g. if the cohort has people up to 99,
# and the age groups are 0-49, 50-99, 100-200, then only the first two age
# groups will appear in the function output)





.are_valid_custom_norms <- function(norms) {
  # check if there is the right number of columns
  if(length(norms) != 4L) {
    warning("User-supplied utility norms are not in correct form.
             Utility norms need to be list-like object with four columns, with names 'lower', 'upper', 'sex', 'avg_hrqol'.")
    return(FALSE)

    # given there is the right number, check that the columns have the right names
  } else if(any(!colnames(norms) %in% c("lower", "upper", "sex", "avg_hrqol"))) {
    warning("User-supplied utility norms are not in correct form.
             Columns must have names 'lower', 'upper', 'sex', 'avg_hrqol'.")
    return(FALSE)

    # given they have the right names, check that the cols have the right type of values
  } else if(.is_valid_sex_col(norms$sex) == FALSE) {
    return(FALSE)
  } else if(.is_valid_lower_col(norms$lower) == FALSE) {
    return(FALSE)
  } else if(.is_valid_upper_col(norms$upper) == FALSE) {
    return(FALSE)
  } else if(.is_valid_avg_hrqol_col(norms$avg_hrqol) == FALSE) {
    return(FALSE)

    # given the cols have appropriate values individually, check that they relate appropriately to each other
  } else if(sum(norms$lower > norms$upper) > 0) {
    warning("For user-supplied utility norm, the value in column 'lower' must always
            be lower than or equal to the corresponding value in column 'upper'.")
    return(FALSE)
  #there's probably a neater way to do this by sex
  } else if(sum(norms[norms$sex == "female", ]$lower[-1] != norms[norms$sex == "female",]$upper[-nrow(norms[norms$sex == "female", ])] + 1) > 0) {
    warning("Age groups in user-supplied norms must be non-overlapping, but when
            combined they must cover all years of age without gaps (for each sex).
            This means that if the upper bound of one group is 'x', then the lower bound
            of the next group must be 'x+1'.")
    # confusing error message, needs a re-write
    return(FALSE)
  } else if(sum(norms[norms$sex == "male", ]$lower[-1] != norms[norms$sex == "male",]$upper[-nrow(norms[norms$sex == "male", ])] + 1) > 0) {
    warning("Age groups in user-supplied norms must be non-overlapping, but when
            combined they must cover all years of age without gaps (for each sex).
            This means that if the upper bound of one group is 'x', then the lower bound
            of the next group must be 'x+1'.")
    # confusing error message, needs a re-write
    return(FALSE)
  } else {

    # all checks are satisfied
    TRUE
  }

}


.is_valid_custom_cohort <- function(cohort) {

  # check if there is the right number of columns
  if(length(cohort) != 3L) {
    warning("User-supplied cohort is not in correct form.
             Cohort need to be list-like object with three columns, with names 'age', 'sex', 'count'.")
    return(FALSE)

    # given there is the right number, check that the columns have the right names
  } else if(any(!colnames(cohort) %in% c("age", "sex", "count"))) {
    warning("User-supplied cohort is not in correct form.
             Columns must have names 'age', 'sex', 'count'.")
    return(FALSE)

    # given they have the right names, check that the cols have the right type of values
  } else if(.is_valid_sex_col(cohort$sex) == FALSE) {
    return(FALSE)
  } else if(.is_valid_cohort_age_col(cohort$age) == FALSE) {
    return(FALSE)
  } else if(.is_valid_count_col(cohort$count) == FALSE) {
    return(FALSE)
  } else {

    # all checks are satisfied
    TRUE
  }

}

.is_valid_custom_lt <- function(life_table) {

  # check if there is the right number of columns
  if(length(life_table) != 3L) {
    warning("User-supplied life tables are not in correct form.
             Life tables need to be list-like object with three columns, with names 'sex', 'age', 'q'.")
    return(FALSE)

    # given there is the right number, check that the columns have the right names
  } else if(any(!colnames(life_table) %in% c("sex", "age", "q"))) {
    warning("User-supplied life tables are not in correct form.
             Columns must have names 'sex', 'age', 'q'.")
    return(FALSE)

    # given they have the right names, check that the cols have the right type of values
  } else if(.is_valid_sex_col(life_table$sex) == FALSE) {
    return(FALSE)
  } else if(.is_valid_lt_age_col(life_table$age) == FALSE) {
    return(FALSE)
  } else if(.is_valid_q_col(life_table$q) == FALSE) {
    return(FALSE)
  } else {
    # all checks are satisfied
    TRUE
  }

}


.are_valid_custom_age_groups <- function(age_groups) {

  # check if there is the right number of columns
  if(length(age_groups) != 2L) {
    warning("User-supplied age_groups are not in correct form.
             Age groups need to be list-like object with two columns, with names 'lower', 'upper'.")
    return(FALSE)

    # given there is the right number, check that the columns have the right names
  } else if(any(!colnames(age_groups) %in% c("lower", "upper"))) {
    warning("User-supplied age groups are not in correct form.
             Columns must have names 'lower', 'upper'.")
    return(FALSE)

    # given they have the right names, check that the cols have the right type of values
  } else if(.is_valid_age_group_col(age_groups$lower) == FALSE) {
    return(FALSE)
  } else if(.is_valid_age_group_col(age_groups$upper) == FALSE) {
    return(FALSE)

  # given the cols have appropriate values individually, check that they relate appropriately to each other
  } else if(sum(age_groups$lower > age_groups$upper) > 0) {
    warning("For user-supplied age groups, the value in column 'lower' must always
            be lower than or equal to the corresponding value in column 'upper'.")
    return(FALSE)
  } else if(sum(age_groups$upper[-nrow(age_groups)] >= age_groups$lower[-1]) > 0) {
    warning("User-supplied age groups must be non-overlapping. This means that
            the value given for the upper bound of one group must be strictly
            lower than the value given for the lower bound of the next group.")
    return(FALSE)
  } else {
    # all checks are satisfied
    TRUE
  }

}






# --------Column level checks (for user-supplied data)-----------------------------------------------------------

.is_valid_sex_col <- function(sex_col) {
  if(any(!(sex_col %in% c("male", "female")))) {
    # check that only values in column are either male or female
    warning("'sex' column should only take values \"male\" or \"female\".")
    return(FALSE)
  } else if(sum(sex_col == "male") != sum(sex_col == "female")) {
    # check whether there are same number of males as females
    # I think the function should be able to handle it if there aren't - (in the
    # case of utility norms & user-supplied cohorts and NOT in the case of life tables,
    # which do need to be equal (that condition is checked elsewhere)) -
    # but we can warn the user that it's not what we expect
    # NOTE: i need to come back to this warning message and re-write so its clear
    warning("User-supplied data does not have same number of values for sex =  \"female\" and sex = \"male\".")
    return(TRUE)
  } else {
    TRUE
  }
}


.is_valid_q_col <- function(q_col) {
  if(any(!is.numeric(q_col))) {
    stop("'q' column contain only numbers between 0 and 1.")
    return(FALSE)
  } else if(any(q_col < 0) | any(q_col > 1)) {
    warning("'q' column must contain only numbers between 0 and 1.")
    return(FALSE)
  } else {
    TRUE
  }
}


.is_valid_avg_hrqol_col <- function(avg_hrqol_col) {
  if(any(!is.numeric(avg_hrqol_col))) {
    stop("'avg_hrqol' column must contain only numbers between 0 and 1.")
    return(FALSE)
  } else if(any(avg_hrqol_col < 0) | any(avg_hrqol_col > 1)) {
    warning("'avg_hrqol' column must contain only numbers between 0 and 1.")
    return(FALSE)
  } else {
    TRUE
  }
}

# need different things from the age column in a user-supplied life table and a user-supplied cohort
.is_valid_lt_age_col <- function(age_col) {
  # 1. needs to be all natural numbers
  # 2. needs to start at 0 and go to at least....99?
  # 3. needs to have no missing numbers between lowest and highest
  if(any(!is.numeric(age_col))) {
    stop("'age' column in user-supplied life tables must contain only positive integers.")
    return(FALSE)
  } else if(any(age_col < 0) | any(age_col %% 1 != 0)) {
    warning("'age' column in user-supplied life tables must contain only positive integers.")
    return(FALSE)
  } else if(max(age_col) < 99 | min(age_col) != 0) {
    warning("User-supplied life tables must contain data for all ages from 0 up to and including 99
            (for both sexes).")
    return(FALSE)
  } else if(length(age_col) != 2*length(unique(age_col))) {
    warning("User-supplied life tables must contain data for all ages from 0 up to and including 99
            (for both sexes). Data provided for any year of age > 99 for males must also be provided
            for females and vice versa.")
    # there has to be two of everything (same number of years of data supplied for men & women)
    # confusing error message, needs re-write.
    return(FALSE)
  } else if(any(!(min(age_col):max(age_col) %in% age_col))) {
    # needs to have no missing numbers between lowest and highest
    warning("User-supplied life tables must contain data for all ages from 0 up to and including 99
            (for both sexes.")# up to the oldest age supplied? which must be min 99?
    return(FALSE)
  } else {
    TRUE
  }
}


# need different things from the age column in a user-supplied life table and a user-supplied cohort
.is_valid_cohort_age_col <- function(age_col) {
  # 1. needs to be all natural numbers
  if(any(!is.numeric(age_col))) {
    stop("'age' column in user-supplied cohort must contain only positive integers.")
    return(FALSE)
  } else if(any(age_col < 0) | any(age_col %% 1 != 0)) {
    warning("'age' column in user-supplied cohort must contain only positive integers.")
    return(FALSE)
  } else {
    TRUE
  }
}



# what is needed for lower and upper cols in the case of user-supplied
# utility norms is different to what is needed for lower and upper cols
# in the case of age groups supplied for grouping output
# this is the validity check for lower col in user-supplied utility norms
.is_valid_lower_col <- function(lower_col) {
  # 1. needs to be all natural numbers
  # 2. needs to start at 0
  if(any(!is.numeric(lower_col))) {
    stop("'lower' column must contain only positive integers.")
    return(FALSE)
  } else if(any(lower_col < 0) | any(lower_col %% 1 != 0)) {
    warning("'lower' column must contain only positive integers.")
    return(FALSE)
  } else if(min(lower_col) != 0) {
    # 99 is placeholder - need to figure out overall approach for dealing with low & high ages throughout package
    warning("User-supplied utility norms must include values for age groups spanning from age 0 until at least 99 inclusive.")
    return(FALSE)
  } else {
    TRUE
  }

}

# this is the validity check for upper col in user-supplied utility norms
.is_valid_upper_col <- function(upper_col) {
  # 1. needs to be all natural numbers
  # 2. needs to end at min 99 (placeholder)
  if(any(!is.numeric(upper_col))) {
    stop("'upper' column must contain only positive integers.")
    return(FALSE)
  } else if(any(upper_col < 0) | any(upper_col %% 1 != 0)) {
    warning("'upper' column must contain only positive integers.")
    return(FALSE)
  } else if(max(upper_col) < 99) {
    # 99 is placeholder - need to figure out overall approach for dealing with low & high ages throughout package
    warning("User-supplied utility norms must include values for age groups spanning from age 0 until at least 99 inclusive.")
    return(FALSE)
  } else {
    TRUE
  }

}

.is_valid_age_group_col <- function(age_group_col) {
  # 1. needs to be all natural numbers
  if(any(!is.numeric(age_group_col))) {
    stop("In user-supplied age groups, 'lower' and 'upper' columns must contain only positive integers.")
    return(FALSE)
  } else if(any(age_group_col < 0) | any(age_group_col %% 1 != 0)) {
    warning("In user-supplied age groups, 'lower' and 'upper' columns must contain only positive integers.")
    return(FALSE)
  } else {
    TRUE
  }
}

.is_valid_count_col <- function(count_col) {
  # 1. needs to be numbers >= 0
  if(any(!is.numeric(count_col))) {
    stop("'count' column must contain only positive integers.")
    return(FALSE)
  } else if(any(count_col < 0)) {
    warning("'count' column must contain only positive integers.")
    return(FALSE)
  } else {
    TRUE
  }

}


