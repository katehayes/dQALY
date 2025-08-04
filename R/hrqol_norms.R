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
      stop(paste("Country not found. Countries for which HRQoL norms are available currently include:", paste(avail_countries, collapse = ", ")))
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

  norm_copy <- copy(norm_info)
  avail_countries <- unique(norm_copy$norm_country)

  if(!(country %in% avail_countries)) {
    stop(paste("Country not found. Countries for which utility norms are available currently include:", paste(avail_countries, collapse = ", ")))
  } else {
    default_norms <- norm_copy[norm_country == country & default == T]$norm_id
  }

  default_norms

}




