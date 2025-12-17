# I wonder if some kind of integration with eq5d package - so eq5d data could be converted to
# index scores using the eq5d functions & then output fed straight into dQALY calculation
# as utility norm values?
# there is also handling uncertainty..
# I am also seeing some descriptions of HRQoL scores across populations being
# given in terms of regression output rather than tables

# we could also have a series of disutility weights????? for various conditions??

# -------------------------------------------------------------------------
#' Use norm data stored by package
# -------------------------------------------------------------------------
#'
#' @param country `[string]`
#'
#' The name of a country (for which data is available & stored in the package).
#' Case-sensitive - please use function `hrqol_norms` to see the list of permissible country names.
#'
#' @param id `[string]`
#'
#' Often, more than one set of HRQoL norms are available for a single country.
#' The default value for this argument is a call to the function `default_norms`,
#' which returns the ID of the default norms for the chosen country.
#' If users wish to return an alternative set of norms belonging to the chosen
#' country, they can pass the ID to this argument.
#' Use function `hrqol_norms` to see the IDs for the norms available for each country.
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
#' @returns
#'
#' A data frame, containing HRQoL data.
#'
#' @examples
#' package_norms(country = "Romania")
#' package_norms(country = "Romania", id = "rom_5L")
#' package_norms(country = "Romania", id = "rom_5L", avg_hrqol_young = 1)
#'
#' @export
package_norms <- function(country,
                          id = default_norms(country),
                          avg_hrqol_young = NULL) {


  # due to NSE notes in R CMD check
  norm_country <- lower <- avg_hrqol <- norm_id <- NULL


  # ----------validity checks ----------------------------------------------------
  # check that country supplied is valid
  if(is.null(country)) {
    stop("No value for `country` supplied to function `package_norms`.
         Use function `hrqol_norms` to see the list of available countries.")
  } else {
    avail_countries <- norm_info$norm_country
    if(!(country %in% avail_countries)) {
      stop("Value for `country` must be chosen from the list of available
      countries. Use hrqol_norms() to see the list.")
    }
  }

  # check that the norm id they supplied is valid
  # error message referring user to norm info function - could do with re-write
  # formerly in section 1.3
  if(is.null(id)) {
    stop("No value for `id` supplied to function `package_norms`.
         Use function `hrqol_norms` to see the list of available countries and corresponding norm IDs.")
  } else {
    if(!(id %in% norm_info[norm_country == country, norm_id])) {
      stop("Invalid norm ID. Use function hrqol_norms() to see the IDs for the norms available for your chosen country.")
    }
  }


  # check avg_hrqol_young - formerly 1.6
  if(!.is_valid_avg_hrqol_young(avg_hrqol_young)) {
    stop("If not set to its default value of NULL, 'avg_hrqol_young' must be
           a numeric scalar.")
  }


  # ----------getting data ----------------------------------------------------
  # filtering package data to retrieving norms w chosen country, id
  utility_norms <- utility_norms[norm_country == country & norm_id == id][, c("norm_country", "norm_id"):=NULL]



  # ---------changing assumption re youngest group-------------------------------
  # formerly 2.2
  if(!is.null(avg_hrqol_young)) {
    utility_norms[lower == min(lower), avg_hrqol := avg_hrqol_young]
  }


  # ----------return ------------------------------------------------------
  setDF(utility_norms)
  utility_norms

}



# -------------------------------------------------------------------------
#' Use life table data stored by package
# -------------------------------------------------------------------------
#'
#' @param country `[string]`
#'
#' The name of a country (for which data is available & stored in the package).
#' Case-sensitive. Please use function `hrqol_norms` to see the list of permissible country names.
#'
#' @param year `[integer]`
#'
#' A year (for which data is available & stored in the package).
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
#' @returns
#'
#' A data frame, containing life tables for the chosen country and year.
#'
#' @examples
#' package_lt(country = "Romania", year = 2022)
#' package_lt(country = "Romania", year = 2022, lt_extend = FALSE)
#' package_lt(country = "Romania", year = 2022, lt_extend = 1.5)
#'
#' @export
package_lt <- function(country, year,
                       lt_extend = TRUE) {

  # Capturing the environment here because we're using data.table
  env <- environment()

  # due to NSE notes in R CMD check
  xmax <- age <- increment <- qmax <- sex <- NULL


  # ----------validity checks ----------------------------------------------------
  # check that country supplied is valid
  if(is.null(country)) {
    stop("No value for `country` supplied to function `package_lt`.
         Use function `hrqol_norms` to see the list of available countries.")
  } else {
    avail_countries <- life_tables$country
    if(!(country %in% avail_countries)) {
      stop("Value for `country` must be chosen from the list of available
      countries. Use hrqol_norms() to see the list.")
    }
  }

  # check the year is valid
  if(is.null(year)) {
    stop("No value for `year` supplied to function `package_lt`.")
  } else {
    avail_years <- life_tables[country == get("country", env), year]
    if (!(year %in% avail_years)) {
      stop(paste("Currently the package only stores life table data for ", country,
                 " for the years ",
                 min(avail_years), "-", max(avail_years), ".
                 Please set `year` to a value within this period.", sep = ""))
    }
  }

  # checking if lt_extend is valid - formerly in section 1.6
  # NOTE - do I need to incorporate some guidelines into this check so users don't put silly numbers?
  if(!.is_valid_lt_extend(lt_extend)) {
    stop("'lt_extend' must be a boolean value or a numeric scalar that is
         greater than 1.")
  }


  # ----------getting data ----------------------------------------------------
  # Filtering the package data to select life tables for the chosen country, year
  # Used to happen in section  1.3
  life_table <- life_tables[country == get("country", env) & year == get("year", env)][, c("country", "year"):=NULL]



  # ----------extending life tables-------------------------------------------
  # Formerly section 2.1
  # NOTE: because these extensions happen within the package_lt function,
  # they are only applied to package data. we're assuming that the user
  # provides the data they want (makes whatever assumptions they want already)
  # This is also how it was done previously

  # Life tables given by UN and ONS only go up to 99/100 - what if we want dQALY
  # estimates for people older than that - we might want to extend life tables

  # at the moment lt_extend controls whether we extend or not (default we do)
  # and also controls how the extension is done - the default is that, for
  # the selected life tables, the mean increase in mortality rate across the 10
  # oldest years for which mortality rates are available is calculated (for males and females)
  # we then say that mortality rates from q(max x) onwards increases by this same amount each year

  # (could add the ability to set the upper age limit - doesn't have to be 120)


  # we know lt_extend is bool (TRUE/FALSE) or scalar numeric and we update as long as it is not FALSE
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

  # ----------return ------------------------------------------------------
  setDF(life_table)
  life_table

}



# -------------------------------------------------------------------------
#' Use population data stored by package
# -------------------------------------------------------------------------
#'
#' @param country `[string]`
#'
#' The name of a country (for which data is available & stored in the package).
#' Case-sensitive. Please use function `hrqol_norms` to see the list of permissible country names.
#'
#' @param year `[integer]`
#'
#' A year (for which data is available & stored in the package).
#'
#' @returns
#'
#' A data frame, containing population data for the chosen country and year.
#'
#' @examples
#' package_cohort(country = "Romania", year = 2022)
#'
#' @export
package_cohort <- function(country, year) {

  # Capturing the environment here because we're using data.table
  env <- environment()


  # ----------validity checks ----------------------------------------------------
  # check that country supplied is valid
  if(is.null(country)) {
    stop("No value for `country` supplied to function `package_cohort`.
         Use function `hrqol_norms` to see the list of available countries.")
  } else {
    avail_countries <- populations$country
    if(!(country %in% avail_countries)) {
      stop("Value for `country` must be chosen from the list of available
      countries. Use hrqol_norms() to see the list.")
    }
  }


  # check the year is valid
  if(is.null(year)) {
    stop("No value for `year` supplied to function `package_cohort`.")
  } else {
    avail_years <- populations[country == get("country", env), year]
    if (!(year %in% avail_years)) {
      stop(paste("Currently the package only stores population data for ", country,
                 " for the years ",
                 min(avail_years), "-", max(avail_years), ".
                 Please set `year` to a value within this period.", sep = ""))
    }
  }

  # ----------getting data ----------------------------------------------------
  # Filtering the package data to select cohort for the chosen country, year
  cohort <- populations[country == get("country", env) & year == get("year", env)][, c("country", "year"):=NULL]


  # ----------return ------------------------------------------------------
  setDF(cohort)
  cohort

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
#' hrqol_norms(country = "England")
#' hrqol_norms(country = "England", references = TRUE)
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



# ------------------------------------------------------------------------- #
# ---------------- INTERNALS - VALIDITY CHECKING -------------------------- #
# ------------------------------------------------------------------------- #


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


