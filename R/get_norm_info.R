#' Get info on utility norms
#'
#' @param country string - name of a permissible country
#' @param references boolean - set to T if you wish to return reference information (DOI, URL)
#'
#' @returns A dataframe containing information about utility norms
#'
#' @examples
#' get_norm_info()
#' get_norm_info(country = "England")
#' @export
get_norm_info <- function(country = NULL, references = F) {

  norm_copy <- copy(norm_info)

  avail_countries <- unique(norm_copy$norm_country)

  if(!is.null(country)) {
    if(!(country %in% avail_countries)) {
      stop(paste("Country not found. Countries for which utility norms are available currently include:", paste(avail_countries, collapse = ", ")))
    } else {
      norm_copy <- norm_copy[norm_country == country]
    }
  }

  if(references == F) {
    norm_copy[, c("norm_doi", "norm_url"):=NULL]
  }

  setDF(norm_copy)

  norm_copy

}


#' Return default norms for a given country
#'
#' @param country A string - name of a permissible country
#'
#' @returns A string - the name of the default norm for the specified country
#'
#' @examples
#' default_norms(country = "England")
#' @export
default_norms <- function(country) {

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

