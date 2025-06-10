# -------------------------------------------------------------------------
#' Calculating QALY loss on death
# -------------------------------------------------------------------------
#'
# -------------------------------------------------------------------------
#' @param country String
#' value is name of a permissible country
#'
#' @param year Integer
#' permissible year
#'
#' @param life_table Null or data.frame (or tibble or data.table)
#' Allows users to supply their own life tables - has to have columns sex, x, q_x
#'
#' @param norms Null or string or data.frame (or tibble or data.table)
#' (is it ok to allow an argument to be flexible like this?)
#' specify which set of utility norms to use in the dQALY calculation by name
#' OR
#' provide your own norms a dataframe (or tibble or data.table) with columns age_low, age_high, sex = "male" or "female, and avg_util
#' min(age_low) needs to be zero and max(age_high) needs to be (lets say) 100 for both sexes?
#' Need to make sensible system for naming the norms we collect (eq5d package categorises
#' value sets according to version, type, country, and then pubmed/doi/isbn reference)?
#' &collect that info in norm_info package data?
#'
#' @param r Numeric or function
#' r is the discount rate
#' r can either be a numeric scalar between 0 and 1 (default is 0.035)
#' OR r can be a vectorised function
#' the function takes as an argument the number of years into the future
#' and returns value of the discount rate at that point
#
#' @param smr Numeric
#' a 'mortality ratio' - default is 1 -
#' if less than 1 then population is less likely to die than average (and vice versa)
#'
#' @param qcm Numeric
#' adjusts morbidity/quality of life - default is 1 -
#' if less than 1 then population has lower quality of life than average (and vice versa)
#'
#' @param lt_extend Boolean or numeric
#'
#' Option to extend life tables past last year of data. If TRUE (default) then increment calculation
#' done automatically. If numeric, should be a number greater than 1 (e.g. 1.05 if you want
#' mortality rates to get 5% bigger each year after the last year for which data is avail).
#'
#' @param avg_util_young Null/numeric - default is that the youngest age group (for which no qaly norm
#' data is available) is assumed to have the same avg util value as the youngest group for which we have data -
#' you can change that assumption & set your own value with avg_util_young (most likely other assumption would be
#' setting avg_util_young to 1)
#'
#' @param collapse_age Boolean (default FALSE) or a dataframe (or tibble or data.table) with cols age_low and age_high
#' (lower and upper bounds), allowing user to specify age groups for which we should produce grouped estimates
#' collapse age is default false, if true then all ages collapsed together,
#' OR the user can pass in age groups and that indicates that they want age collapsed into the supplied groups
#'
#' @param collapse_sex Boolean, default FALSE
#' Whether or not to group male & female estimates together
#'
#' @param cohort Null (default) or a dataframe (or tibble or data.table) with columns named sex, x, and count,
#' allowing user to specify the distribution of a particular cohort by age and sex,
#' so that they can calculate grouped estimates for this specific cohort
#'
# -------------------------------------------------------------------------
#' @returns a dataframe w columns age, sex and dQALY estimates
#'
# -------------------------------------------------------------------------
#' @examples
#' #Output a table of dQALY values for all ages/genders, minimally specifying year & country
#' calculate_dQALY(country = "United Kingdom", year = 2019)
#'
#' #Output a table of dQALY values for all ages/genders, specifying year, country and norm by name
#' calculate_dQALY(country = "United Kingdom", norms = "janssen_euvas", year = 2019)
#'
#' #Output a table of dQALY values for all ages/genders, specifying year & country,
#' #with user-specified norms
#' my_norms <- data.frame(sex = c(rep("male", 3), rep("female", 3)),
#'                        age_low = c(0, 20, 90),
#'                        age_high = c(19, 89, 150),
#'                        avg_util = c(1, 0.85, 0.67, 0.99, 0.4, 0.2))
#' calculate_dQALY(country = "United Kingdom", norms = my_norms, year = 2019)
#'
#' #Output a table of dQALY values for all ages/genders, with user-specified norms and life tables
#' my_life_table <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
#'                             x = c(0:100, 0:100),
#'                             q_x = c(seq(0, 1, 0.01)))
#'
#' calculate_dQALY(life_table = my_life_table, norms = my_norms)
#'
#' #Calculate dQALY values using a variable discount rate
#' rfun = function(x) ifelse(x < 31, 0.015, ifelse(x > 75, 0.0107, 0.0129))
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019, r = rfun)
#'
#' #Calculate grouped dQALY values - using default country-level population weightings:
#' #1) collapse sex
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019,
#'                 collapse_sex = TRUE)
#' #2) age groups
#' my_age_groups <- data.frame(age_low = c(seq(0,90,5)), age_high = c(seq(4,89,5), 100))
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019, collapse_age = my_age_groups)
#' #3) collapse sex and group age
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019,
#'                 collapse_age = my_age_groups, collapse_sex = TRUE)
#'
#' #Do any of these groupings with a user-supplied cohort
#' my_cohort <- data.frame(sex = c(rep("male", 5), rep("female", 8)),
#'                         x = c(89:93, 89:92, 95:97, 100),
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
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019, collapse_age = my_age_groups,
#'                 collapse_sex = TRUE, cohort = my_cohort)
# -------------------------------------------------------------------------
#' @export
calculate_dQALY <- function(# we had discussed removing the default NULL from country & year parameters
                            # but I've remembered that actually it is possible to run the function without
                            # specifying values for country or year - in the case where the user
                            # is not relying on package data at all, is instead supplying all their own
                            # data (life tables, utility norms, cohort if grouping)
                            country = NULL,
                            year = NULL,
                            # put three dots? https://adv-r.hadley.nz/functions.html#fun-dot-dot-dot
                            life_table = NULL,
                            norms = NULL,
                            r = 0.035,
                            smr = 1, qcm = 1,
                            lt_extend = TRUE, #needs new name
                            avg_util_young = NULL, #needs new name
                            collapse_age = FALSE,
                            collapse_sex = FALSE,
                            cohort = NULL) {

  env <- environment()


  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # 1. Validity checks # # # # # # # # # # # # # # # # # # ## # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


  if(.is_valid_r(r) == F) {
    stop("Parameter r must be a numeric scalar between 0 and 1 or a function that specifies how the discount rate changes over time.
          See the README for examples of valid values for r.")
    # The function should take one argument (time point - number of years into the future) and return the desired discount rate at that time point.
  }



  # if you specify a country you must specify a year
  avail_countries <- norm_info$norm_country

  if (!is.null(country)) {
    if(!(country %in% avail_countries)) {
      stop("Value for `country` must be chosen from the list of available countries. Use get_norm_info() to see the list.
         If you wish to calculate QALY loss estimates for a country that is not currently available, you can do so by
         supplying appropriate life tables and utility norms to the function.")
    }
  }


  if (!is.null(year)) {
    avail_years <- life_tables[country == get("country", env), year]
    if (!(year %in% avail_years)) {
      stop(paste("Currently, QALY loss estimates for ", country, " can only be calculated for the years ",
                 min(avail_years), "-", max(avail_years), ".
                 Please set `year` to a value within this period.", sep = ""))
    }
  }



  # if user doesn't want to group output:
  # user can either specify country, year, norms (or just country and year if we set default norms for each country) OR
  # user can specify country, year, and provide own norms OR
  # user can specify country, norms, and provide life tables OR
  # (OR - if we set default utility norms for each country - user can provide own life table and specify country?)
  # OR user can provide own life table and utility norms


  # if user is providing own life table and utility norms but wants to group output:
  # either they need to provide their own cohort
  # OR they also need to specify country and year, in order to get the default population norm

  # (probably wouldn't make a lot of sense methodologically to provide your own custom life tables
  # and then use a default country-level population weighting to group)


  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # 2. Getting the life_tables that will be used in the main dQALY calculation
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  # if the user hasn't supplied their own set of life tables
  if(is.null(life_table)) {

    # Filtering the package data to select the chosen country, year
    # https://cran.r-project.org/web/packages/data.table/vignettes/datatable-programming.html
    life_table <- life_tables[country == get("country", env) & year == get("year", env)][, c("country", "year"):=NULL]

    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    # Options for packaged life tables # # # # # # # # # # # # # # # # # # # # # #
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

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


    if (length(lt_extend) != 1L || is.na(lt_extend) || (!(is.logical(lt_extend) || is.numeric(lt_extend)))) {
      stop("`lt_extend must be a boolean value or a numeric scalar.")
    }

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
      life_table[x > xmax, q_x := 1 - exp(-(-log(1 - qmax)) * increment^(x - xmax))]
      life_table[,c("xmax", "qmax", "increment") := NULL]
      setorder(life_table, x, sex)
    }

  } else {
    # user has supplied their own life tables

    # should probably revisit the way these checks are formulated
    if((length(collapse_age) == 2L | any(collapse_age == TRUE)) | collapse_sex == TRUE) {
      # not sure about this (error message too wordy anyway)
      stop("In order to calculate QALY loss estimates for population groups: if you supplied your own life tables to the calculation, you must also supply your own population cohort (needed to derive group averages).")
    }

    life_table <- as.data.table(life_table)


  }


  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # 3. Getting the utility norms that will be used in the main dQALY calculation
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


  if(length(norms) > 1) {
    # if the user supplies their own norms
    # Should there be a series of checks that the norms provided are sensible
    # and a series of error messages?
    utility_norms <- as.data.table(norms)

  } else {

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
        stop("Invalid norm ID. Use function get_norm_info() to see the IDs for the norms available for your chosen country.")
      }

      utility_norms <- utility_norms[norm_country == get("country", env) & norm_id == norms][, c("norm_country", "norm_id"):=NULL]

    }


    # Options for changing assumptions made when using packaged utility norms # # # # # # # # # # # # # # # # # #
    if(!is.null(avg_util_young)) {
      utility_norms[age_low == min(age_low), avg_util := avg_util_young]
    }


  }








  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # 4. Calculating dQALY # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


  # life tables might have different lengths (UN goes to 99, ONS to 100),
  # so taking lengths here, to be used in calculations below
  # assuming there is the same number of years of data for men & women
  min_x <- min(life_table$x, na.rm = TRUE)
  max_x <- max(life_table$x, na.rm = TRUE)


  # we have q(x) - probability of dying at age x
  # first calculating l(x): the number surviving to age x >= 1 (in a population of 1)
  # again we're converting the probability q(x) to an instantaneous death rate,
  # adjusting the rate w parameter smr (if desired), then converting back to a probability
  # (here to probability of surviving ie 1-prob of dying)
  # then calculating L(x): years lived between ages x & x+1 for x>=1: (l(x) + l(x+1))/2
  # Note: This calculation assumes a uniform distribution of deaths during the year
  life_table[, l_x := cumprod(exp(-shift(-log(1-q_x), type = "lag", fill = 0)*smr)), by = .(sex)]
  life_table[, L_x := (l_x + shift(l_x, type = "lead", fill = 0))/2, , by = .(sex)]

  # assigning the appropriate population-level utility norm to corresponding age, sex
  # dropping l(x) bc we only need L(x) for the QALY calculation
  dQALY_table <- utility_norms[life_table,
                         on = .(sex, age_low <= x, age_high >= x),
                         .(sex, x, L_x, avg_util)]


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


  dQALY_table[, r_col := ifelse(x == 0, 0, r_col)]

  dQALY_table[, (paste("v", min_x:max_x, sep="")) := shift(1/cumprod(1+r_col), n = x, type = "lag", fill = 0), by = .(sex)]
  dQALY_table[, dQALY_x := t(.SD) %*% (L_x*avg_util*qcm), .SDcols = patterns("^v"), by = .(sex)]

  # dropping cols we don't need anymore
  dQALY_table[, c(paste("v", min_x:max_x, sep=""), "r_col", "L_x", "avg_util"):=NULL]

  # note - fix ordering of output - by x and then sex



  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # 5. Organising output # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  # if dQALY values need to be calculated for a set of population groups
  if((length(collapse_age) == 2L | any(collapse_age == TRUE)) | collapse_sex == TRUE) {

    # need a cohort to do the grouping
    # if the user doesn't supply a cohort with specific population distribution across age and sex
    # then use the population distribution of whatever country has been selected (this is the default)
    if(is.null(cohort)) {
      cohort <- populations[country == get("country", env) & year == get("year", env)][, c("country", "year"):=NULL]
    } else {
      cohort <- as.data.table(cohort)
    }


    dQALY_table <- dQALY_table[cohort,
                               on = .(sex, x)]


    # if the user wants to collapse into AGE GROUPS (not just collapse age entirely) - and has indicated this by
    # supplying a set of age groups to the collapse_age argument
    # then add this information about what their desired age groups are into the dQALY table
    if(length(collapse_age) == 2L) {

      age_groups <- as.data.table(collapse_age)

      age_expand <- do.call(rbind, Map(grouper, collapse_age$age_low, collapse_age$age_high))

      dQALY_table <- dQALY_table[age_expand,
                                 on = .(x),
                                 nomatch = NULL]

    }


    # assign a value to cols (vector of column names) based on whether the user wants to collapse by age group, sex, or both
    # note: previously, if the user wanted to collapse age completely then they needed to specify an age group like (0-120)
    # now if they want to do this they set collapse_age = TRUE & do not supply any custom age groups
    if(length(collapse_age) == 2L) {
      cols <- c("age_group")
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


  # some final organisation of output - changing column names, turning data.table into data.frame
  dQALY_table |>
    setnames(old = c("sex", "x", "dQALY_x", "age_group"), new = c("sex", "age_at_death", "dQALY", "age_at_death"), skip_absent = TRUE)

  setDF(dQALY_table)

  dQALY_table

}



# -------------------------------------------------------------------------
#' Calculate quality-adjusted life expectancy
# -------------------------------------------------------------------------
#' @description
#' Calculates quality-adjusted life expectancy for a given country and year
# -------------------------------------------------------------------------
#' @param ...
# -------------------------------------------------------------------------
#' @returns
#'
# -------------------------------------------------------------------------
#' @examples
# -------------------------------------------------------------------------
#' @export
calculate_QALE <- function(...) {
  calculate_dQALY(..., r = 0)
}






# ------------------------------------------------------------------------- #
# -------------------------------- INTERNALS ------------------------------ #
# ------------------------------------------------------------------------- #


grouper <- function(x, y) data.table(age_low = x, age_high = y, age_group = paste(x, y, sep = "-"), x = c(x:y))




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


#
# .are_valid_norms <- function(norms) {
#   if (is.character(norms) && length(norms) == 1L && !is.na(norms)) {
#     norm_copy <- copy(norm_info)
#     avail_ids <- unique(norm_copy$norm_id)
#     if (!norms %in% avail_ids) {
#       stop("Invalid norm ID. Use function get_norm_info() to see the IDs for available norms.")
#     }
#     return(TRUE)
#   }
#
#
#   norm_copy <- copy(norm_info)
#   avail_countries <- unique(norm_copy$norm_country)
#   avail_ids <- unique(norm_copy$norm_id)
#
#   if (is.function(norms)) {
#     args <- formals(norms)
#     if (length(args) != 1L) {
#       return(FALSE)
#     }
#     if (any(!(sapply(avail_countries, norms) %in% avail_ids))) { #NO non non no
#       warning("")
#     }
#     return(TRUE)
#   }
#
#   FALSE
#
# }

