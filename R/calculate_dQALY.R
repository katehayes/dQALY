## usethis namespace: start
#' @import data.table
## usethis namespace: end


calculate_dQALY <- function(
    # dt = mod_output,
                            country, year,
                            norms,
                            r = 0.035,
                            smr = 1, qcm = 1) {

  lt <- life_tables[c == country & y == year]
  qaly_norms <- qaly_norms[c == country & name == norms]

  # calculating l(x): the number surviving to age x >= 1 for a reference population of 1
  lt[, l_x := cumprod(exp(-shift(-log(1-q_x), type = "lag", fill = 0)*smr)), by = .(sex)]

  # calculating L(x): years lived between ages x & x+1 for x>=1: (l(x) + l(x+1))/2
  # Note: This calculation assumes a uniform distribution of deaths during the year
  lt[, L_x := (l_x + shift(l_x, type = "lead", fill = 0))/2, , by = .(sex)]

  min_x <- min(lt$x, na.rm = TRUE)
  max_x <- max(lt$x, na.rm = TRUE)

  # assigning the appropriate pop QALE norm to right age
  dQALY_table <- qaly_norms[lt,
                       on = .(sex, age_low <= x, age_high >= x),
                       .(sex, x, L_x, qn)]

  # discounting
  dQALY_table[, (paste("v", min_x:max_x, sep="")) := shift((1+r)^-x, n = x, type = "lag", fill = 0), by = .(sex)]
  dQALY_table[, dQALY_x := t(.SD) %*% (L_x*qn*qcm), .SDcols = patterns("^v"), by = .(sex)]

  # dropping cols we don't need anymore
  dQALY_table[, c(paste("v", min_x:max_x, sep=""), "L_x", "qn"):=NULL]


  # dQALY_table[mod_output,
  #             on = .(sex, x = age),
  #             .(sex, age, dQALY_x)]

  return(dQALY_table)

}


# check <- calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019)
