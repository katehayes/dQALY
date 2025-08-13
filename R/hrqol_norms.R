
# so is there any way to do it so that when you call the function within the other functions arguments,
# and you want to change one thing, don't have to specify country again?
# calculate_dQALY(country = "England", year = 2019, norms = package_norms(country = "England", id = "vih_secondary"))

# calculate_dQALY(life_table = package_lt(country = "England", year = 2019), norms = package_norms(country = "France"), cohort = package_cohort(country = "Spain", year = 2020), collapse_sex = T)
# you can currently do something like the above

# -------------------------------------------------------------------------
#' Use norm data stored by package
# -------------------------------------------------------------------------
#'
#' @param country
#' @param id
#' @param avg_hrqol_young
#'
#' @returns
#'
#' @examples
#' @export
package_norms <- function(country,
                          id = default_norms(country),
                          avg_hrqol_young = NULL) {

  # check that country supplied is valid
  if (!is.null(country)) {
    avail_countries <- norm_info$norm_country
    if(!(country %in% avail_countries)) {
      stop("Value for `country` must be chosen from the list of available
      countries. Use hrqol_norms() to see the list.")
    }
  }

  # check that the norm id they supplied is valid
  # error message referring user to norm info function - could do with re-write
  # formerly in section 1.3
  if(!(id %in% norm_info[norm_country == country, norm_id])) {
    stop("Invalid norm ID. Use function hrqol_norms() to see the IDs for the norms available for your chosen country.")
  }

  # validity check - formerly 1.6
  if(!.is_valid_avg_hrqol_young(avg_hrqol_young)) {
    stop("If not set to its default value of NULL, 'avg_hrqol_young' must be
           a numeric scalar.")
  }

  # retrieving norms from package data
  utility_norms <- utility_norms[norm_country == country & norm_id == id][, c("norm_country", "norm_id"):=NULL]


  # changing assumption re youngest group in utility norms
  # formerly 2.2
  if(!is.null(avg_hrqol_young)) {
    utility_norms[lower == min(lower), avg_hrqol := avg_hrqol_young]
  }


  utility_norms[]

}



# -------------------------------------------------------------------------
#' Use life table data stored by package
# -------------------------------------------------------------------------
#'
#' @param country
#' @param year
#' @param lt_extend
#'
#' @returns
#'
#' @examples
#'
#' @export
package_lt <- function(country, year,
                       lt_extend = TRUE) {

  # Capturing the environment here because we're using data.table
  env <- environment()

  # check that country supplied is valid
  if (!is.null(country)) {
    avail_countries <- norm_info$norm_country
    if(!(country %in% avail_countries)) {
      stop("Value for `country` must be chosen from the list of available
      countries. Use hrqol_norms() to see the list.")
    }
  }

  # check the year is valid
  if (!is.null(year)) {
    avail_years <- life_tables[country == get("country", env), year]
    if (!(year %in% avail_years)) {
      stop(paste("Currently the package only stores life table data for ", country,
                 " for the years ",
                 min(avail_years), "-", max(avail_years), ".
                 Please set `year` to a value within this period.", sep = ""))
    }
  }


  # checking if lt_extend is valid - formerly 1.6
  # NOTE - do I need to incorporate some guidelines into this check so users don't put silly numbers?
  if(!.is_valid_lt_extend(lt_extend)) {
    stop("'lt_extend' must be a boolean value or a numeric scalar that is
         greater than 1.")
  }


  # Filtering the package data to select life tables for the chosen country, year
  # Used to happen in section  1.3
  life_table <- life_tables[country == get("country", env) & year == get("year", env)][, c("country", "year"):=NULL]


  # Formerly section 2.1 - Extending life tables
  # NOTE: these extensions are only applied to package data.
  # we're assuming that the user provides the data they want (makes whatever
  # assumptions they want already)

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


  # now we know lt_extend is bool (TRUE/FALSE) or scalar numeric and we update as long as it is not FALSE
  if (!isFALSE(lt_extend)) {
    life_table[, xmax := max(age, na.rm = TRUE), by = "sex"]
    if (is.numeric(lt_extend)) {
      life_table[, increment := lt_extend]
    } else {
      life_table[, increment := .SD[age >= xmax - 10, mean(q/shift(q, type = "lag"), na.rm = T)], by = "sex"]
    }
    life_table <- life_table[CJ(sex = c("male", "female"), age = 0:120), on = c("sex", "age")]
    life_table[, c("xmax", "qmax", "increment") := lapply(list(xmax, q, increment), max, na.rm = TRUE), by = "sex"]
    # q(x) is the probability of dying within the year at age x
    # to increment the probability without it exceeding 1, we convert to the instantaneous death rate,
    # apply the increment, then convert back to a probability
    life_table[age > xmax, q :=  1 - (1 - qmax)^increment^(age - xmax)]
    life_table[,c("xmax", "qmax", "increment") := NULL]
    setorder(life_table, age, sex)
  }


  life_table[]

}


# -------------------------------------------------------------------------
#' Use population data stored by package
# -------------------------------------------------------------------------
#'
#' @param country
#' @param year
#'
#' @returns
#'
#' @examples
#'
#' @export
package_cohort <- function(country, year) {


  # Capturing the environment here because we're using data.table
  env <- environment()

  # check that country supplied is valid
  if (!is.null(country)) {
    avail_countries <- norm_info$norm_country
    if(!(country %in% avail_countries)) {
      stop("Value for `country` must be chosen from the list of available
      countries. Use hrqol_norms() to see the list.")
    }
  }

  # check the year is valid
  if (!is.null(year)) {
    avail_years <- populations[country == get("country", env), year]
    if (!(year %in% avail_years)) {
      stop(paste("Currently the package only stores population data for ", country,
                 " for the years ",
                 min(avail_years), "-", max(avail_years), ".
                 Please set `year` to a value within this period.", sep = ""))
    }
  }


  cohort <- populations[country == get("country", env) & year == get("year", env)][, c("country", "year"):=NULL]

  cohort[]

}











# -------------------------------------------------------------------------
#' Get info on the available HRQoL population norms
# -------------------------------------------------------------------------
#'
#' @param country `[string]`
#'
#' The name of a country (for which data is available & stored in the package).
#'
#' Defaults to `NULL` - in this case, info about the HRQoL norms stored for
#' all available countries are returned. If the user passes the name of a
#' country to this argument, only information about the HRQoL norm data of
#' that specific country is returned by the function.
#'
#' Case-sensitive - users can view the list of permissible country names by
#' calling the function without specifying a value for `country`.
#'
#'
#' @param references `[boolean]`
#'
#' Default `FALSE`. Set to `TRUE` in order to view information about the sources
#' of HRQoL data (DOIs/URLs).
#'
#' @returns A data frame containing information about available HRQoL norms.
#'
#' @examples
#' head(hrqol_norms())
#'
#' hrqol_norms(country = "England")
#'
#' hrqol_norms(country = "England", references = TRUE)
#'
#'
#' @export
hrqol_norms <- function(country = NULL, references = FALSE) {

  norm_country <- NULL # due to NSE notes in R CMD check

  norm_copy <- copy(norm_info)

  avail_countries <- unique(norm_copy$norm_country)

  if(!is.null(country)) {
    if(!(country %in% avail_countries)) {
      stop("Country not found. Countries for which HRQoL norms are available currently include: ", toString(avail_countries))
    } else {
      norm_copy <- norm_copy[norm_country == country]
    }
  }

  if(references == FALSE) {
    norm_copy[, c("norm_doi", "norm_url"):=NULL]
  }

  setDF(norm_copy)

  norm_copy

}


# -------------------------------------------------------------------------
#' Inspect the default HRQoL norms for a given country
# -------------------------------------------------------------------------
#'
#' @param country `[string]`
#'
#' The name of a country (for which data is available & stored in the package).
#'
#' Case-sensitive - users can view the list of permissible country names by
#' calling the function `hrqol_norms` without specifying a value for `country`.
#'
#' @returns A string - the ID given to the set of HRQoL norms that have been
#' selected as the default norms for the chosen country.
#'
#' @examples
#' default_norms(country = "England")
#' default_norms(country = "France")
#'
#' @export
default_norms <- function(country) {

  default <- norm_country <- NULL # due to NSE notes in R CMD check

  # we could also make it more complicated & allow user to choose between rules for selecting the default?
  # eg most recent study, largest sample size, & so on

  avail_countries <- unique(norm_info$norm_country)

  if(!(country %in% avail_countries)) {
    stop("Country not found. Countries for which utility norms are available currently include: ", toString(avail_countries))
  }

  norm_info[norm_country == country & default == TRUE]$norm_id
}




