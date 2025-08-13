
# so is there any way to do it so that when you call the function within the other functions arguments,
# and you want to change one thing, don't have to specify country again?
# calculate_dQALY(country = "England", year = 2019, norms = package_norms(country = "England", id = "vih_secondary"))


#' Use norm data stored in package
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




