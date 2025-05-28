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
