#' Calculating QALY loss on death
#'
#' @param country String, value is name of a permissible country
#' @param year Integer, permissible year
#' @param norms String, permissible norm name
#' @param r Numeric, between 0 and 1, discount rate
#' @param smr Numeric, a 'mortality ratio' - default is 1 -
#' if less than 1 then population is less likely to die than average (and vice versa)
#' @param qcm Numeric, adjusts morbidity/quality of life - default is 1 -
#' if less than 1 then population has lower quality of life than average (and vice versa)
#' @param mod_output A datatable(?) - default is NULL -
#'
#' @returns either a datatable w columns age, sex and dQALY estimates, or adds
#' a column dQALY to existing datatable mod_output
#'
#' @examples
#' #Output a table of dQALY values for all ages/genders, minimally specifying year, country and norm
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019)
#'
#' #Calculate dQALY values for a datatable w model output
#' dt <- data.table(sex = c(rep("male",8), rep("female",8)),
#'                  age = c(0, 18, 25, 35, 45, 55, 65, 75))
#'
#' calculate_dQALY(mod_output = dt, country = "United Kingdom", norms = "mvh", year = 2019)
#'
#' @export
calculate_dQALY <- function(mod_output = NULL,
                                    country, year,
                                    norms,
                                    r = 0.035,
                                    smr = 1, qcm = 1) {

  # Filtering the package data to select the chosen country, year, instance of norms
  # (should we set default norms for each country?)
  lt <- life_tables[c == country & y == year]
  qaly_norms <- qaly_norms[c == country & name == norms]

  # first calculating l(x): the number surviving to age x >= 1 for a reference population of 1
  # then calculating L(x): years lived between ages x & x+1 for x>=1: (l(x) + l(x+1))/2
  # Note: This calculation assumes a uniform distribution of deaths during the year
  lt[, l_x := cumprod(exp(-shift(-log(1-q_x), type = "lag", fill = 0)*smr)), by = .(sex)]
  lt[, L_x := (l_x + shift(l_x, type = "lead", fill = 0))/2, , by = .(sex)]

  # assigning the appropriate pop quality of life norm to corresponding age, sex
  dQALY_table <- qaly_norms[lt,
                       on = .(sex, age_low <= x, age_high >= x),
                       .(sex, x, L_x, qn)]

  # discounting
  # life tables might have different lengths, so taking lengths here
  min_x <- min(lt$x, na.rm = TRUE)
  max_x <- max(lt$x, na.rm = TRUE)

  # making a matrix of zeros and powers of 1/(1+r)
  # getting a discounted sum of life years lost from age x onwards via matrix multiplication
  dQALY_table[, (paste("v", min_x:max_x, sep="")) := shift((1+r)^-x, n = x, type = "lag", fill = 0), by = .(sex)]
  dQALY_table[, dQALY_x := t(.SD) %*% (L_x*qn*qcm), .SDcols = patterns("^v"), by = .(sex)]

  # dropping cols we don't need anymore
  dQALY_table[, c(paste("v", min_x:max_x, sep=""), "L_x", "qn"):=NULL]

  # if a datatable (with columns representing sex and age at death) is given as an input to the function
  # then attach a dQALY column
  # (should there be an option to have a column death = 0 or 1 indicating that
  # only some of the people in the table have died)
  if (!is.null(mod_output)) {
    dQALY_table[mod_output,
                 on = .(sex, x = age)]
  }

  dQALY_table

}




