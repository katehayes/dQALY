# -------------------------------------------------------------------------
#' Calculating QALY loss on death
# -------------------------------------------------------------------------
#'
# -------------------------------------------------------------------------
#' @param mod_output A datatable(?)
#' default is NULL - presently has to have columns sex and age
#'
#' @param country String
#' value is name of a permissible country
#'
#' @param year Integer
#' permissible year
#'
#' @param norms string
#' specify which set of qaly norms to use in the dQALY calculation
#'
#' Need to make sensible system for naming the norms we collect (eq5d package categorises
#' value sets according to version, type, country, and then pubmed/doi/isbn reference)
#'
#' @param r Numeric
#' between 0 and 1, discount rate
#'
#' @param smr Numeric
#' a 'mortality ratio' - default is 1 -
#' if less than 1 then population is less likely to die than average (and vice versa)
#'
#' @param qcm Numeric
#' adjusts morbidity/quality of life - default is 1 -
#' if less than 1 then population has lower quality of life than average (and vice versa)
#'
#' @param lt_extend Boolean
#' option to extend life tables past last year of data, default is T
#'
#' @param lt_increment Null or numeric - default NULL, if null then increment calculation
#' done automatically - if not null, should be a number greater than 1 (e.g. 1.05 if you want
#' mortality rates to get 5% bigger each year after the last year for which data is avail)
#'
#' @param un_young Null/numeric - default is that the youngest age group (for which no qaly norm
#' data is available) is assumed to have the same qn value as the youngest group for which we have data -
#' you can change that assumption & set your own value with qn_young (most likely other assumption would be
#' setting qn_young to 1)
#'
#' @param age_groups
#' @param sex_group
#' @param cohort
#'
# -------------------------------------------------------------------------
#' @returns either a datatable w columns age, sex and dQALY estimates, or adds
#' a column dQALY to existing datatable mod_output
#'
# -------------------------------------------------------------------------
#' @examples
#' #Output a table of dQALY values for all ages/genders, minimally specifying year, country and norm
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019)
#'
#' #Calculate dQALY values for a datatable w model output
#' my_mod_out <- data.table(sex = c(rep("male",8), rep("female",8)),
#'                  age = c(0, 18, 25, 35, 45, 55, 65, 75))
#'
#' calculate_dQALY(mod_output = my_mod_out, country = "United Kingdom", norms = "mvh", year = 2019)
#'
#' #Calculate grouped dQALY values - 1) collapse sex 2) age groups 3) collapse sex and group age
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019, sex_group = T)
#' my_age_groups <- data.table(age_low = c(seq(0,90,5)), age_high = c(seq(4,89,5), 100))
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019, age_groups = my_age_groups)
#' calculate_dQALY(country = "United Kingdom", norms = "mvh", year = 2019, age_groups = my_age_groups, sex_group = T)
#'
# -------------------------------------------------------------------------
#' @export
calculate_dQALY <- function(mod_output = NULL,
                            country, year,
                            norms,
                            r = 0.035,
                            smr = 1, qcm = 1,
                            lt_extend = T,
                            lt_increment = NULL,
                            un_young = NULL,
                            age_groups = NULL,
                            sex_group = F,
                            cohort = NULL) {

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Filtering the package data to select the chosen country, year, instance of norms
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # (should we set default norms for each country?)
  lt <- life_tables[c == country & y == year][, c("c", "y"):=NULL]

  # if(is.null(norms)) {
  #
  # }


  utility_norms <- utility_norms[c == country & id == norms][, c("c", "id"):=NULL]


  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Life table options # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  # Life tables given by UN and ONS only go up to 99/100 - what if we want dQALY
  # estimates for people older than that - we might want to extend life tables

  # at the moment lt_extend controls whether we extend or not (default we do)
  # and lt_increment controls how the extension is done - the default is that, for
  # the selected life tables, the mean increase in mortality rate across the 10
  # highest years for which mortality rates are given to us is calculated (for males and females)
  # we then say that mortality rates from q(max x) onwards increases by this same amount each year
  # (note: this is a deviation from the way Lucy & I originally were doing the extension,
  # where, say for example the max age for which we have data is 100, then q(101) is set as 1/e(100)
  # (life expectancy at age 100) and q(x) for x > 101 is then incremented
  # - that's just one extra step, which I can include at the small?/large?? cost
  # of storing an additional life expectancy column for each set of life tables (or just e(100) for m/f))
  # (could add the ability to set the upper age limit - doesn't have to be 120)

  # can come back here & clean up - or could also pull out into separate function
  if (lt_extend == T) {

    max_x <- max(lt$x, na.rm = TRUE)

    qmax_male <- unlist(lt[x == max_x & sex == "male", .(q_x)])
    qmax_female <- unlist(lt[x == max_x & sex == "female", .(q_x)])

    if (is.null(lt_increment)) {

      incr_male <- unlist(lt[x >= max_x-10 & sex == "male"][, .(diff_q = mean(q_x/shift(q_x, type = "lag"), na.rm = T))])
      incr_female <- unlist(lt[x >= max_x-10 & sex == "female"][, .(diff_q = mean(q_x/shift(q_x, type = "lag"), na.rm = T))])

    } else {

      incr_male <- lt_increment
      incr_female <- lt_increment

    }

    lt <- lt |>
      rbind(data.table(sex = c(rep("male", 120-max_x), rep("female", 120-max_x)),
                       x = c((max_x+1):120, (max_x+1):120),
                       q_x = NA))

    # q(x) is the probability of dying within the year at age x
    # to increment the probability without it exceeding 1, we convert to the instantaneous death rate,
    # apply the increment, then convert back to a probability
    lt[x > max_x & sex == "male", q_x := 1-exp(-(-log(1-qmax_male))*incr_male^(x-max_x))]
    lt[x > max_x & sex == "female", q_x := 1-exp(-(-log(1-qmax_female))*incr_female^(x-max_x))]


  }

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # QALY norm options # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  if(!is.null(un_young)) {
    utility_norms[age_low == min(age_low), un := un_young]
  }


  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Calculating dQALY # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


  # life tables might have different lengths (UN goes to 99, ONS to 100),
  # so taking lengths here, to be used in calculations below
  # assuming there is the same number of years of data for men & women
  min_x <- min(lt$x, na.rm = TRUE)
  max_x <- max(lt$x, na.rm = TRUE)

  # first calculating l(x): the number surviving to age x >= 1 for a reference population of 1
  # again we're converting to rate, adjusting the rate w parameter smr (if desired), then converting back
  # (here to probability of surviving ie 1-prob of dying)
  # then calculating L(x): years lived between ages x & x+1 for x>=1: (l(x) + l(x+1))/2
  # Note: This calculation assumes a uniform distribution of deaths during the year
  lt[, l_x := cumprod(exp(-shift(-log(1-q_x), type = "lag", fill = 0)*smr)), by = .(sex)]
  lt[, L_x := (l_x + shift(l_x, type = "lead", fill = 0))/2, , by = .(sex)]

  # assigning the appropriate pop quality of life norm to corresponding age, sex
  dQALY_table <- utility_norms[lt,
                         on = .(sex, age_low <= x, age_high >= x),
                         .(sex, x, L_x, un)]

  # discounting
  # making a matrix of zeros and powers of 1/(1+r)
  # getting a discounted sum of life years lost from age x onwards via matrix multiplication
  dQALY_table[, (paste("v", min_x:max_x, sep="")) := shift((1+r)^-x, n = x, type = "lag", fill = 0), by = .(sex)]
  dQALY_table[, dQALY_x := t(.SD) %*% (L_x*un*qcm), .SDcols = patterns("^v"), by = .(sex)]

  # dropping cols we don't need anymore
  dQALY_table[, c(paste("v", min_x:max_x, sep=""), "L_x", "un"):=NULL]



  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Organising output # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  #if there is no grouping of dQALY values (values will be sex and year-of-age specific)
  if(is.null(age_groups) & sex_group == F) {


    # if a datatable (with columns representing sex and age at death) is given as an input to the function
    # then attach a dQALY column
    # make sex case insensitive, allow user to specify age and sex column name
    # (should there be an option to have a column death = 0 or 1 indicating that
    # only some of the people in the table have died)
    # (allow grouped age too as long as they specify pop distribution? or accept
    # country-level population data as default distribution?)
    if (!is.null(mod_output)) {
      dQALY_table[mod_output,
                  on = .(sex, x = age)]
    }



  # if dQALY values need to be calculated for a set of population groups
  } else {

    # need a cohort to do the grouping
    # if the user doesn't supply a cohort with specific population distribution across age and sex
    # then use the population distribution of whatever country has been selected (this is the default)
    if(is.null(cohort)) {
      cohort <- populations[c == country & y == year][, c("c", "y"):=NULL]
    }


    dQALY_table <- dQALY_table[cohort,
                               on = .(sex, x)]


    # if the user wants to group by age - and has indicated this by supplying a set of age groups
    # then add this information about what their desired age groups are into the dQALY table
    if(!is.null(age_groups)) {

      age_expand <- do.call(rbind, Map(grouper, age_groups$age_low, age_groups$age_high))

      dQALY_table <- dQALY_table[age_expand,
                                 on = .(x),
                                 nomatch = NULL]

    }


    # asign a value to cols based on whether the user wants to collapse by age group, sex, or both
    # note: at present if the user wants to collapse age completely then they need to specify an age group like (0-120)
    cols <- c("x")

    if(!is.null(age_groups)) {
      cols <- c("age_group")
    }

    if(sex_group == F){
      cols <- c(cols, "sex")
    }

    # calculate a weighted mean dQALY value for each population group
    dQALY_table <- dQALY_table[, .(dQALY_grouped = sum(dQALY_x*count)/sum(count)), by = cols]

  }

  dQALY_table

}




# ------------------------------------------------------------------------- #
# -------------------------------- INTERNALS ------------------------------ #
# ------------------------------------------------------------------------- #

# extend <- function() {
#
# }

grouper <- function(x, y) data.table(age_low = x, age_high = y, age_group = paste(x, y, sep = "-"), x = c(x:y))


