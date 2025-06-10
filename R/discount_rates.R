# Defining a number of different discount regimes
# We're asking the user to give us a function that returns the discount rate at each year into the future
# Thought I could make a couple of these functions for them for ease?

# Not sure if i should include trivial examples like r_none() below, or r_default()?
# But for the others, I think there is value in us having gone & checked the guidance &
# come up with a list of recommended rates? Or in having made the function, for those who aren't comfortable doing that?
# https://www.nice.org.uk/process/pmg36/chapter/economic-evaluation-2#discounting
# https://www.gov.uk/government/publications/the-green-book-appraisal-and-evaluation-in-central-government/the-green-book-2020#a6-discounting


# -------------------------------------------------------------------------
#' No Discounting
# -------------------------------------------------------------------------
#'
#' @param x Numeric, number of years into the future
#'
#' @returns Numeric, discount rate at that point in the future
#'
# -------------------------------------------------------------------------
#' @examples
#' r_none(10)
#' r_none(50)
#' r_none(100)
# -------------------------------------------------------------------------
#' @export
r_none <- function(x) {
  # No discounting
  0
}

# -------------------------------------------------------------------------
#' NICE Reference Case Discount Rate
# -------------------------------------------------------------------------
#'
#' @param x Numeric, number of years into the future
#'
#' @returns Numeric, discount rate at that point in the future
#'
# -------------------------------------------------------------------------
#' @examples
#' r_default(10)
#' r_default(50)
#' r_default(100)
# -------------------------------------------------------------------------
#' @export
r_default <- function(x) {
  # NICE reference case discount rate/ Green Book standard Social Time Preference Rate
  0.035
}


# -------------------------------------------------------------------------
#' Green Book Health Discount Rate
# -------------------------------------------------------------------------
#'
#' @param x Numeric, number of years into the future
#'
#' @returns Numeric, discount rate at that point in the future
#'
# -------------------------------------------------------------------------
#' @examples
#' r_health(10)
#' r_health(50)
#' r_health(100)
# -------------------------------------------------------------------------
#' @export
r_health <- function(x) {
  # NICE alternative discount rate/Green Book recommended discount rate for health or life values
  0.015
}


# -------------------------------------------------------------------------
#' Green Book Long Term Health Discount Rate
# -------------------------------------------------------------------------
#'
#' @param x Numeric, number of years into the future
#'
#' @returns Numeric, discount rate at that point in the future
#'
# -------------------------------------------------------------------------
#' @examples
#' r_lt_health(10)
#' r_lt_health(50)
#' r_lt_health(100)
# -------------------------------------------------------------------------
#' @export
r_lt_health <- function(x) {
  # Long term discounting
  # Green Book recommended declining long term discount rate for health or life values
  ifelse(x < 31, 0.015, ifelse(x > 75, 0.0107, 0.0129))
}


# -------------------------------------------------------------------------
#' Green Book Reduced Long Term Health Discount Rate
# -------------------------------------------------------------------------
#'
#' @param x Numeric, number of years into the future
#'
#' @returns Numeric, discount rate at that point in the future
#'
# -------------------------------------------------------------------------
#' @examples
#' r_lt_health_reduced(10)
#' r_lt_health_reduced(50)
#' r_lt_health_reduced(100)
# -------------------------------------------------------------------------
#' @export
r_lt_health_reduced <- function(x) {
  # Long term discounting
  # Green Book recommended rate reduced by excluding pure social time preference
  # (relevant if intervention may effect substantial/irreversible wealth transfers between generations)
  ifelse(x < 31, 0.01, ifelse(x > 75, 0.0071, 0.0086))
}




