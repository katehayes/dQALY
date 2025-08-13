# -------------------------------------------------------------------------
#' Calculating QALY loss on death
# -------------------------------------------------------------------------
#'
# -------------------------------------------------------------------------
#' @param country `[string]`
#'
#' The name of a country (for which data is available & stored in the package).
#'
#' Case-sensitive - please use function `hrqol_norms` to see the list of permissible country names.
#'
#' Defaults to `NULL` - if `NULL` then the user must supply own life tables and utility norms.
#'
#' @param year `[integer]`
#'
#' A year (for which data is available & stored in the package).
#'
#' Defaults to `NULL` - if `NULL` then the user must supply own life tables.
#'
#' @param life_table `[data frame]` or `[tibble]` or `[data table]`
#'
#' Allows users to supply their own life tables to the function, instead of using packaged life tables.
#'
#' Must have columns named 'sex', 'age', and 'q' (probability of death).
#'
#' Defaults to `NULL`.
#'
#' @param norms Null or string or data.frame (or tibble or data.table)
#' MAKING CHANGES HERE - WILL WRITE
#'
#' @param r `[numeric]` or `[function]`
#'
#' Represents the discount rate that will be used in the calculation.
#'
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
#' @param lt_extend `[boolean]` or `[numeric]`
#'
#' Allows users to control whether/ the way in which assumptions are made about
#' mortality rates among people older than 99, for whom data is not available.
#'
#' If `FALSE`, no assumption is made, and the function assumes no people live
#' beyond 99.
#'
#' If `TRUE` (default), the function assumes that people can live up to 120
#' and calculates a mortality rate for the older ages by assuming that
#' mortality rates increase year on year by a constant increment - which is
#' set equal to the average rate of increase over the last 10 years for which
#' data is available.
#'
#' Alternatively, the user can specify their own increment, instead of allowing
#' the function to calculate an increment automatically based on existing data.
#' This is done by passing `lt_extend` a numeric value greater than 1 - for
#' example, letting `lt_extend` to 1.05 means the function assumes mortality rates
#' will increase by 5% year on year after the last year for which data is available.
#'
#'
#' @param avg_hrqol_young `[numeric]`
#'
#' Allows users to control the way in which assumptions are made about the average
#' health-related quality of life of those under 18, for whom data is not typically
#' available.
#'
#' Defaults to `NULL`. In this case the youngest age group is assumed to have
#' the same average utility score as that of the next youngest group.
#'
#' Alternatively, the user can make their own assumption about the HRQoL score
#' given to the youngest group, by passing `avg_hrqol_young` a numeric value
#' between 0 and 1, where 1 would be equivalent to assuming the youngest age
#' group is in perfect health.
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
#' If the user chooses to have the function output grouped estimates,
#' then the function needs to assume a distribution for the population in order
#' to calculate weighted averages.
#'
#' If `cohort` is `NULL` (default), then (if the user has specified a value for
#' `country` and `year` in order to use packaged life tables) the calculation
#' will use packaged population data, selecting the appropriate country and year.
#'
#' Alternatively, the user can specify a population distribution across age and
#' sex to be used in the grouping by passing a  data frame, tibble or data table
#' to `cohort`, with columns 'sex', 'age', and 'count'. Note that if the
#' user supplied custom life tables to the function, they will be required to
#' supply a custom cohort too.
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
#' #Output a table of dQALY values for all ages/genders, specifying year, country and norm by name
#' calculate_dQALY(country = "United Kingdom", norms = "janssen_euvas", year = 2019)
#'
#'
#' #Output a table of dQALY values for all ages/genders, specifying year & country,
#' #with user-specified norms
#' my_norms <- data.frame(sex = c(rep("male", 3), rep("female", 3)),
#'                        lower = c(0, 20, 90),
#'                        upper = c(19, 89, 150),
#'                        avg_hrqol = c(1, 0.85, 0.67, 0.99, 0.4, 0.2))
#' calculate_dQALY(country = "United Kingdom", norms = my_norms, year = 2019)
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
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019, r = rfun)
#'
#'
#' #Calculate grouped dQALY values - using default country-level population weightings:
#' #1) collapse sex
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019,
#'                 collapse_sex = TRUE)
#' #2) age groups
#' my_age_groups <- data.frame(lower = c(seq(0,90,5)), upper = c(seq(4,89,5), 100))
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019,
#'                 collapse_age = my_age_groups)
#' #3) collapse sex and group age
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019,
#'                 collapse_age = my_age_groups, collapse_sex = TRUE)
#'
#' #Do any of these groupings with a user-supplied cohort
#' my_cohort <- data.frame(sex = c(rep("male", 5), rep("female", 8)),
#'                         age = c(89:93, 89:92, 95:97, 100),
#'                         count = c(1, 1, 2, 1, 1, 3, 2, 1, 1, 2, 1, 1, 1))
#' #note: any age and gender for which no count value is supplied is considered
#' #outside the cohort (count zero)
#' #1) collapse sex
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019,
#'                 collapse_sex = TRUE, cohort = my_cohort)
#' #2) age groups (note: of the age groups specified, only estimates for age groups that contain a
#' #member of the specified cohort are returned)
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019,
#'                 collapse_age = my_age_groups, cohort = my_cohort)
#' #3) collapse sex and group age
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019,
#'                 collapse_age = my_age_groups,
#'                 collapse_sex = TRUE, cohort = my_cohort)
# -------------------------------------------------------------------------
#' @export
calculate_dQALY <- function(# we had discussed removing the default NULL from country & year parameters
                            # but I've remembered that actually it is possible to run the function without
                            # specifying values for country or year - in the case where the user
                            # is not relying on package data at all, is instead supplying all their own
                            # data (life tables, utility norms, cohort if grouping)
                            country = NULL, #population
                            year = NULL,
                            # put three dots? https://adv-r.hadley.nz/functions.html#fun-dot-dot-dot
                            life_table = NULL,
                            norms = NULL,
                            r = 0.035,
                            smr = 1, qcm = 1,
                            lt_extend = TRUE, #needs new name? what about lt_assumption?
                            avg_hrqol_young = NULL, #needs new name? what about hrqol_assumption?
                            collapse_age = FALSE,
                            collapse_sex = FALSE,
                            cohort = NULL) { #population_weight

  # Capturing the environment here because we're using data.table
  env <- environment()

  # due to NSE notes in R CMD check
  . <-  avg_hrqol <- count <- default <- dQALY_x <- increment <- lower <- NULL
  l_x <- L_x <- norm_country <- norm_id <- qmax <- q_x <- r_col <- sex <- NULL
  upper <- x <- xmax <- NULL

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # 1.Validity checks # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  # all validity checking is moved to the top of the function
  # lots of the checks are done with internal functions, found at the end of
  # this script
  # first we check whether an appropriate combination of arguments has been
  # supplied, then we check that each argument has an appropriate value

  # a change: while doing the validity checks (which involve checking whether
  # or not the user is supplying custom data), at that point we also
  # "get" the life tables, utility norms, and (if needed) cohorts that will
  # be used in the calculation - we either retrieve life tables, utility norms,
  # and cohorts from the packaged data (when appropriate) OR, when those
  # objects are user-supplied, we run them through as.data.table()
  # Previously this was done in the first part of parts 2, 3 & 5 of the
  # function, labelled "getting life tables" and "getting utility norms" and
  # "organising output"
  # if it doesn't make sense to do it like this, can change

  # # # # # # # # # 1.1 combination of arguments # # # # # # # # # # # # # # #
  # checking whether the user has given the right combination of arguments
  if(!.is_valid_arg_combination(life_table, country, year,
                               collapse_age, collapse_sex, cohort,
                               norms)) {
    stop()
  }

  # # # # # # # # # 1.2 country, year # # # # # # # # # # # # # # # # # # # # #
  # doing validity checks for appropriate values for country, year
  # these are relevant when the user wants to use our package data

  if (!is.null(country)) {
    avail_countries <- norm_info$norm_country
    if(!(country %in% avail_countries)) {
      stop("Value for `country` must be chosen from the list of available
      countries. Use hrqol_norms() to see the list. If you wish to calculate
      QALY loss estimates for a country that is not currently available,
      you can do so by supplying custom life tables and utility norms to
      the function.")
    }
  }

  # if year is specified (and the arg combination validity check was passed),
  # then country has to have been specified
  if (!is.null(year)) {
    avail_years <- life_tables[country == get("country", env), year]
    if (!(year %in% avail_years)) {
      stop(paste("Currently, QALY loss estimates for ", country,
                 " can only be calculated for the years ",
                 min(avail_years), "-", max(avail_years), ".
                 Please set `year` to a value within this period.", sep = ""))
    }
  }



  # # # # # # # # # 1.3 life_table, norms, cohort # # # # # # # # # # # # # # #

  # if the user supplied their own life tables, check they are valid
  # OR if no custom life tables, retrieve package data
  if(.is_user_supplied(life_table)) {
    if(!.is_valid_custom_lt(life_table)) {
      stop("User-supplied life tables have failed validity checks.")
    } else {
      life_table <- as.data.table(life_table) |>
        setnames(old = c("age", "q"),
                 new = c("x", "q_x"))
      lt_is_us <- TRUE # record that life tables are user-supplied
    }
  } else {
    # Filtering the package data to select life tables for the chosen country, year
    life_table <- life_tables[country == get("country", env) & year == get("year", env)][, c("country", "year"):=NULL]
    lt_is_us <- FALSE # record that life tables are NOT user-supplied
  }



  if(.is_user_supplied(norms)) {
    if(!.are_valid_custom_norms(norms)) {
      stop("User-supplied utility norms have failed validity checks.")
    } else {
      utility_norms <- as.data.table(norms)
      ut_is_us <- TRUE # record that utility data is user-supplied
    }
  } else {
    ut_is_us <- FALSE # record that utility data is NOT user-supplied
    if(is.null(norms)) {
      # if user doesn't either a) supply their own utility norms or b) specify by name which ones they want to use by name
      # then we can get info on which norm to use for that country as default, from package data norm_info
      utility_norms <- utility_norms[norm_info[, .(norm_country, norm_id, default)],
                                     , on = .(norm_country, norm_id)]
      utility_norms <- utility_norms[norm_country == get("country", env) & default == T][, c("norm_country", "norm_id", "default"):=NULL]

    } else {
      # if the user specified norms using our norm ids
      # check that the norm id they supplied is valid
      # error message referring user to norm info function - could do with re-write
      if(!(norms %in% norm_info[norm_country == country, norm_id])) {
        stop("Invalid norm ID. Use function hrqol_norms() to see the IDs for the norms available for your chosen country.")
      }

      utility_norms <- utility_norms[norm_country == get("country", env) & norm_id == norms][, c("norm_country", "norm_id"):=NULL]

    }
  }


  # check whether we need a cohort - i.e. check whether the user wants
  # grouped output. otherwise we won't need to set a value for the cohort object
  if(.will_group(env$collapse_age, env$collapse_sex)) {
    # in the case that we need a cohort to group the output, check if user gives one
    if(.is_user_supplied(cohort)) {
      # if user gives a cohort, check it meets standards
      if(.is_valid_custom_cohort(cohort) == FALSE) {
        stop("User-supplied cohort has failed validity checks.")
      } else {
        cohort <- as.data.table(cohort)
        setnames(cohort,
                 old = c("age"),
                 new = c("x"))

      }
    } else {
      # if the user doesn't supply a cohort with specific population distribution across age and sex
      # then use the population distribution of whatever country has been selected (this is the default)
      cohort <- populations[country == get("country", env) & year == get("year", env)][, c("country", "year"):=NULL]
    }
  }



  # # # # # 1.4 grouping arguments: collapse_age, collapse_sex # # # # # # # # #

  if(.is_user_supplied(collapse_age)) {
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


  # # # # # # 1.6 lt_extend, avg_hrqol_young # # # # # # # # # # # # # # # # # #
  # validity checks for the arguments that adjust packaged life tables and
  # utility norms. NOTE: these arguments need new names

  if(!.is_valid_lt_extend(lt_extend)) {
    stop("'lt_extend' must be a boolean value or a numeric scalar that is
         greater than 1.")
  }

  if(!.is_valid_avg_hrqol_young(avg_hrqol_young)) {
    stop("If not set to its default value of NULL, 'avg_hrqol_young' must be
           a numeric scalar.")
  }

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # 2. Options for altering life tables/ utility norms before the calculation #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  # NOTE: these extensions are only applied to package data.
  # we're assuming that the user provides the data they want (makes whatever
  # assumptions they want already)

  # # 2.1 Extending life tables # # # # # # # # # # # # # # # # # # # # # # # #

  # Life tables given by UN and ONS only go up to 99/100 - what if we want dQALY
  # estimates for people older than that - we might want to extend life tables

  # at the moment lt_extend controls whether we extend or not (default we do)
  # and also controls how the extension is done - the default is that, for
  # the selected life tables, the mean increase in mortality rate across the 10
  # highest years for which mortality rates are given to us is calculated (for males and females)
  # we then say that mortality rates from q(max x) onwards increases by this same amount each year
  # (note: this is a deviation from the way Lucy & I originally were doing the extension,
  # where, say for example the max age for which we have data is 100, then q(101) is set as 1/e(100)
  # (life expectancy at age 100) and q(x) for x > 101 is then incremented
  # - that's just one extra step, which I can include at the small?/large?? cost
  # of storing an additional life expectancy column for each set of life tables (or just e(100) for m/f))
  # (could add the ability to set the upper age limit - doesn't have to be 120)


  if(lt_is_us == FALSE) {
    # now we know lt_extend is bool (TRUE/FALSE) or scalar numeric and we update as long as it is not FALSE
    if (!isFALSE(lt_extend)) {
      life_table[, xmax := max(x, na.rm = TRUE), by = "sex"]
      if (is.numeric(lt_extend)) {
        life_table[, increment := lt_extend]
      } else {
        life_table[, increment := .SD[x >= xmax - 10, mean(q_x / shift(q_x, type = "lag"), na.rm = T)], by = "sex"]
      }
      life_table <- life_table[CJ(sex = c("male", "female"), x = 0:120), on = c("sex", "x")]
      life_table[, c("xmax", "qmax", "increment") := lapply(list(xmax, q_x, increment), max, na.rm = TRUE), by = "sex"]
      # q(x) is the probability of dying within the year at age x
      # to increment the probability without it exceeding 1, we convert to the instantaneous death rate,
      # apply the increment, then convert back to a probability
      life_table[x > xmax,q_x :=  1- (1-qmax) ^ increment^(x - xmax)]
      life_table[,c("xmax", "qmax", "increment") := NULL]
      setorder(life_table, x, sex)
    }
  }



  # # # 2.2 changing assumption re youngest group in utility norms # # # # # # #

  if(ut_is_us == FALSE) {
    if(!is.null(avg_hrqol_young)) {
      utility_norms[lower == min(lower), avg_hrqol := avg_hrqol_young]
    }
  }




  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # 3. Calculating dQALY # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


  # life tables might have different lengths (UN goes to 99, ONS to 100),
  # so taking lengths here, to be used in calculations below
  # assuming there is the same number of years of data for men & women
  min_x <- min(life_table$x)
  max_x <- max(life_table$x)


  # we have q(x) - probability of dying at age x
  # first calculating l(x): the number surviving to age x >= 1 (in a population of 1)
  # again we're converting the probability q(x) to an instantaneous death rate,
  # adjusting the rate w parameter smr (if desired), then converting back to a probability
  # (here to probability of surviving ie 1-prob of dying)
  # then calculating L(x): years lived between ages x & x+1 for x>=1: (l(x) + l(x+1))/2
  # Note: This calculation assumes a uniform distribution of deaths during the year
  life_table[, l_x := cumprod(shift(1-q_x, fill = 1)^smr), by=.(sex)]
  life_table[, L_x := (l_x + shift(l_x, type = "lead", fill = 0))/2, , by = .(sex)]

  # assigning the appropriate population-level utility norm to corresponding age, sex
  # dropping l(x) bc we only need L(x) for the QALY calculation
  dQALY_table <- utility_norms[life_table,
                         on = .(sex, lower <= x, upper >= x),
                         .(sex, x, l_x, L_x, avg_hrqol)]

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

  dQALY_table[, (paste("v", min_x:max_x, sep="")) := shift(1/cumprod(1+r_col), n = x, type = "lag", fill = 0), by = .(sex)]
  dQALY_table[, dQALY_x := (t(.SD) %*% (L_x*avg_hrqol*qcm))/l_x, .SDcols = patterns("^v"), by = .(sex)]

  # dropping cols we don't need anymore
  dQALY_table[, c(paste("v", min_x:max_x, sep=""), "r_col", "l_x", "L_x", "avg_hrqol") := NULL]

  # note - fix ordering of output - by x and then sex



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
#'
#' Case-sensitive - please use function `hrqol_norms` to see the list of permissible country names.
#'
#' Defaults to `NULL` - if `NULL` then the user must supply own life tables and utility norms.
#'
#' @param year `[integer]`
#'
#' A year (for which data is available & stored in the package).
#'
#' Defaults to `NULL` - if `NULL` then the user must supply own life tables.
#'
#' @param life_table `[data frame]` or `[tibble]` or `[data table]`
#'
#' Allows users to supply their own life tables to the function, instead of using packaged life tables.
#'
#' Must have columns named 'sex', 'age', and 'q' (probability of death).
#'
#' Defaults to `NULL`.
#'
#' @param norms Null or string or data.frame (or tibble or data.table)
#' MAKING CHANGES HERE - WILL WRITE
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
#' the calculation will estimate QALE for a population assumed to have a
#' mortality rate 5% greater/lower than average mortality rate in the
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
#' the calculation will estimate QALE for a population assumed to experience
#' health-related quality of life 5% greater/lower than the average
#' health-related quality of life in the selected country.
#'
#'
#' @param lt_extend `[boolean]` or `[numeric]`
#'
#' Allows users to control whether/ the way in which assumptions are made about
#' mortality rates among people older than 99, for whom data is not available.
#'
#' If `FALSE`, no assumption is made, and the function assumes no people live
#' beyond 99.
#'
#' If `TRUE` (default), the function assumes that people can live up to 120
#' and calculates a mortality rate for the older ages by assuming that
#' mortality rates increase year on year by a constant increment - which is
#' set equal to the average rate of increase over the last 10 years for which
#' data is available.
#'
#' Alternatively, the user can specify their own increment, instead of allowing
#' the function to calculate an increment automatically based on existing data.
#' This is done by passing `lt_extend` a numeric value greater than 1 - for
#' example, letting `lt_extend` to 1.05 means the function assumes mortality rates
#' will increase by 5% year on year after the last year for which data is available.
#'
#'
#' @param avg_hrqol_young `[numeric]`
#'
#' Allows users to control the way in which assumptions are made about the average
#' health-related quality of life of those under 18, for whom data is not typically
#' available.
#'
#' Defaults to `NULL`. In this case the youngest age group is assumed to have
#' the same average utility score as that of the next youngest group.
#'
#' Alternatively, the user can make their own assumption about the utility score
#' given to the youngest group, by passing `avg_hrqol_young` a numeric value
#' between 0 and 1, where 1 would be equivalent to assuming the youngest age
#' group is in perfect health.
#'
#'
#' @param collapse_age `[boolean]` or `[data frame]` or `[tibble]` or `[data table]`
#'
#' Allows users to control how function outputs are grouped by age.
#'
#' If `FALSE` (default), the function outputs an estimate of QALE at every year
#' of age.
#'
#' Alternatively, if the user passes a data frame, tibble or data table that
#' describe a set of age groups to `collapse_age`, the function will return the
#' average QALE for those age groups. The data frame, tibble, or data table must
#' have two columns named 'lower' and 'upper', indicating the lower and upper
#' bounds of the desired age groups. See the examples for more details.
#'
#' If `collapse_age` is set to `TRUE`, the function outputs a single average
#' estimate of QALE, aggregated across all ages - this is equivalent to
#' supplying a single age group that encompasses all ages.
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
#' If the user chooses to have the function output grouped estimates,
#' then the function needs to assume a distribution for the population in order
#' to calculate weighted averages.
#'
#' If `cohort` is `NULL` (default), then (if the user has specified a value for
#' `country` and `year` in order to use packaged life tables) the calculation
#' will use packaged population data, selecting the appropriate country and year.
#'
#' Alternatively, the user can specify a population distribution across age and
#' sex to be used in the grouping by passing a  data frame, tibble or data table
#' to `cohort`, with columns 'sex', 'age', and 'count'. Note that if the
#' user supplied custom life tables to the function, they will be required to
#' supply a custom cohort too.
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
#' calculate_QALE(country = "England", year = 2018)
# -------------------------------------------------------------------------
#' @export
calculate_QALE <- function(country = NULL,
                           year = NULL,
                           life_table = NULL,
                           norms = NULL,
                           smr = 1, qcm = 1,
                           lt_extend = TRUE,
                           avg_hrqol_young = NULL,
                           collapse_age = FALSE,
                           collapse_sex = FALSE,
                           cohort = NULL) {

  QALE_table <- calculate_dQALY(country = country,
                                year = year,
                                life_table = life_table,
                                norms = norms,
                                smr = smr,
                                qcm = qcm,
                                lt_extend = lt_extend,
                                avg_hrqol_young = avg_hrqol_young,
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


# --------Checking for appropriate combinations of arguments ---------------#

# Note: error messages need a re-write for clarity/completeness

.is_valid_arg_combination <- function(life_table, country, year,
                                      collapse_age, collapse_sex, cohort,
                                      norms) {
  # browser()
  # check for appropriate combination of parameters:
  # User can interact with function in a number of ways
  # 1. rely entirely on package data
  # 2. supply all their own data - life tables, utility norms & (if needed bc user is grouping) cohort
  # 3. use mix of package & own data
  # As a result there are a few different sets of possible combinations of values for arguments


  # 1. in the case when the user is relying on package life tables
  if(.is_user_supplied(life_table) == FALSE) {

    # The user must specify a country and a year
    if(is.null(country) || is.null(year)) {
      warning("Since you are not providing your own life tables, please specify values for both of the arguments 'country' and 'year'.")
      return(FALSE)
    }

  # 2. in the case when the user is supplying their own life tables
  } else if(.is_user_supplied(life_table) == TRUE) {

    # RULE: if the user would like to group output, they need to supply their own cohort too
    # (this could change if it isn't sensible - my the logic for this choice is that it doesn't
    # make a lot of sense to me methodologically to provide your own custom life tables
    # and then use a default country-level population weighting to group, since saying that survival is
    # significantly different from the country-level average in the cohort you're trying to study is
    # equivalent to saying that the cohort structure is significantly different)
    if(.will_group(collapse_age, collapse_sex) == TRUE) {
      if(is.null(cohort)) {
        warning("If you are supplying your own custom life tables to the function, and you would
        like to group the function output, then you must also supply your own custom cohort
        to the function.")
        return(FALSE)
      }
    }


    # 2.1 in the case when the user is supplying their own life tables but NOT supplying their own utility norms (ie using package utility norms)
    if(.is_user_supplied(norms) == FALSE) {

      # the user doesn't have to specify YEAR but must still specify COUNTRY
      if(is.null(country)) {
        # Very much need to return to re-write warning
        # This check/this error message might change subject to whether we allow users to select a norm from ANY country
        # using norm_ids (would have to revise norm_ids so they are all unique - not just as they are presently which is
        # unique within countries)
        # (note to self - another option - probably more complicated?, would be to have a function that allows users to
        # return instances of the actual norm data the package stores, and then they could use this data as input to the
        # calculation, and we'd treat it as a user-supplied custom set of norms??)
        warning("No custom utility norms have been supplied to the function.
        That means an appropriate set of utility norms stored in package data must be selected for use in the calculation.
        Please indicate which country you intend to produce estimates for, by specifying a value for the argument 'country',
        so that the function can make an appropriate selection.")
        # PERHAPS ADD: "or evaluate the appropriateness of your selection."
        return(FALSE)
      }

      # 2.2 in the case when the user is supplying their own life tables and utility norms
    } else if(.is_user_supplied(norms) == TRUE) {

      # if the user also supplied country and year, let them know that the values they chose are
      # irrelevant/are not being used to produce estimates.
      # Previously, the function didn't stop in this case, but I think it might be simpler
      # to write the argument by argument validation checks if this extraneous provision
      # of year or country does actually stop the function
      if(!is.null(country) || !is.null(year)) {
        warning("If you are supplying your own custom life tables AND custom utility norms
        to the function, then you do not have to supply a value for arguments 'country'
        and 'year' - please re-run the function without supplying a value to these arguments.")
        return(FALSE)
      }
    }

  }

  # won't stop the function but just letting user know that if they aren't grouping
  # then supplying a cohort won't do anything
  if(.will_group(collapse_age, collapse_sex) == FALSE) {
    if(!is.null(cohort)) {
      warning("If you do not want to output estimates averaged across age and/or
      sex groups, then you do not need to supply cohort data to the function
      - any cohort data that is supplied will not be used in the calculation.")
    }
  }

  return(TRUE)

}



.is_user_supplied <- function(argument) {
  if(is.null(argument)) {
    return(FALSE)
  } else if(length(argument) > 1L) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}




.will_group <- function(collapse_age, collapse_sex) {
  if(length(collapse_age) > 1L) {
    return(TRUE)
  } else if(collapse_age == TRUE | collapse_sex == TRUE) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}


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



.is_valid_lt_extend <- function(lt_extend) {
  if (length(lt_extend) != 1L || is.na(lt_extend) || (!(is.logical(lt_extend) || is.numeric(lt_extend)))) {
    return(FALSE)
  } else if(is.numeric(lt_extend)) {
    if(lt_extend < 1) {
      warning("The value passed to argument `lt_extend` must be greater than 1 -
              mortality rates must increase with age for ages > 99.")
      return(FALSE)
    }
  }
  TRUE
}


.is_valid_avg_hrqol_young <- function(avg_hrqol_young) {
  if (!is.null(avg_hrqol_young)) {
    if (length(avg_hrqol_young) != 1L || !is.numeric(avg_hrqol_young)) {
      return(FALSE)
    } else if(avg_hrqol_young < 0 | avg_hrqol_young > 1) {
      warning("The argument 'avg_hrqol_young' has been supplied a value that is not
            between 0 and 1. This argument sets the utility score of the
            youngest population group and utility scores are generally between
            0 and 1, likely closer to 1 in younger age groups. Please reconsider
            the value you have supplied to this argument.")
    }
  }
  TRUE
}




# --------Checks at the single argument level when user is supplying own data----------------------------------------------------------
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


