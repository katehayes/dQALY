# if utility norms were stored & supplied as functions
# norm_fun = approxfun(x=c(0,30,60,121), y = c(1,0.9,0.87,0.8), method = "constant")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Norms from the 1993 Measurement and Valuation of Health Study
# https://www.york.ac.uk/che/pdf/DP172.pdf
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

mvh <- data.table(sex = c(rep("male", 8), rep("female", 8)),
                  age_low = c(0, 18, 25, 35, 45, 55, 65, 75),
                  age_high = c(17, 24, 34, 44, 54, 64, 74, 200),
                  avg_util = c(# male
                        c(0.94, 0.94, 0.93, 0.91, 0.84, 0.78, 0.78, 0.75),
                        # female
                        c(0.94, 0.94, 0.93, 0.91, 0.85, 0.81, 0.78, 0.71)),
                  norm_id = "mvh",
                  norm_country = "United Kingdom")



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Newer qaly norms from the 2023 Value in Health paper:
# https://www.valueinhealthjournal.com/article/S1098-3015(22)02101-5/fulltext
# extracted from their github repo: https://github.com/bitowaqr/shortfall/tree/main
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

temp <- tempfile()
download.file(url = "https://raw.githubusercontent.com/bitowaqr/shortfall/main/src%20manuscript/output/hrqol_co_ci_df.csv", temp)

vih_primary <- as.data.table(utils::read.csv(temp))


vih_primary[, age_low := as.numeric(substring(age5_str, 1, 2))]
vih_primary[, age_high := as.numeric(substring(age5_str, 4, 5))]
vih_primary[age_low == max(age_low), age_high := 200]
vih_primary[, avg_util := sub(" .*", "", m_ci)]
vih_primary[, c("age5_str", "m_ci", "n"):=NULL]
vih_primary[, norm_id := "vih"]
vih_primary[, norm_country := "England"]

yg <- vih_primary[age_low == min(age_low)]
yg[, age_high := age_low - 1]
yg[, age_low := 0]

vih_primary <- rbind(vih_primary, yg)




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# janssen
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # Table 3.5
# # EQ-5D index population norms (European VAS value set)
# "https://www.ncbi.nlm.nih.gov/books/NBK500364/table/ch3.Tab5/?report=objectonly"

# # Table 3.6
# # EQ-5D index population norms (country-specific TTO value sets)
# "https://www.ncbi.nlm.nih.gov/books/NBK500364/table/ch3.Tab6/?report=objectonly"

# # Table 3.7
# # EQ-5D index population norms (country-specific VAS value set)
# "https://www.ncbi.nlm.nih.gov/books/NBK500364/table/ch3.Tab7/?report=objectonly"


# Norms used in NN's Covid dQALY code (https://github.com/LSHTM-GHECO/COVID19_QALY_App)
# are from Janssen et al 2014 -- they are the UK estimates of EQ-5D valued via TTO


extract_janssen_norms <- function(url, element = ".large_tbl") {

  rvest::read_html(url) |>
    rvest::html_element(element) |>
    rvest::html_table(fill = T) |>
    as.data.table() -> norms

}


transform_janssen_norms <- function(norms, norm_name) {

  names <- norms[1, ] |>
    unlist()
  names[1] <- "norm_country"

  setnames(norms, new = names)

  n <- norms[norm_country == "Regional", which = TRUE]

  # only keeping the national-level norms for now
  # melting wide to long
  norms <- norms[-c(1:2, n:nrow(norms)), -9] |>
    melt(measure = 2:8,
         variable.name = "age_low",
         value.name = "avg_util")

  norms[, avg_util := as.numeric(avg_util)]
  norms[grepl("England", norm_country), norm_country := "England"]

  # changing country names so they line up with UN life tables
  norms[norm_country == "Korea", norm_country := "Republic of Korea"]
  norms[norm_country == "UK", norm_country := "United Kingdom"]
  norms[norm_country == "US", norm_country := "United States of America"]

  norms[, age_high := as.numeric(substring(age_low, 4, 5))]
  norms[, age_low := as.numeric(substring(age_low, 1, 2))]
  norms[age_low == max(age_low), age_high := 200]
  norms[, norm_id := norm_name]

  yg <- norms[age_low == min(age_low)]
  yg[, age_high := age_low - 1]
  yg[, age_low := 0]

  # Other norms are sex-specific
  rbind(norms, yg, norms, yg) |>
    cbind(data.table(sex = c(rep("male", nrow(norms) + nrow(yg)),
                             rep("female", nrow(norms) + nrow(yg))))) -> norms

}


janssen <- extract_janssen_norms(url = "https://www.ncbi.nlm.nih.gov/books/NBK500364/table/ch3.Tab6/?report=objectonly") |>
  transform_janssen_norms(norm_name = "janssen_tto") |>
  rbind(extract_janssen_norms(url = "https://www.ncbi.nlm.nih.gov/books/NBK500364/table/ch3.Tab7/?report=objectonly") |>
          transform_janssen_norms(norm_name = "janssen_vas")) |>
  rbind(extract_janssen_norms(url = "https://www.ncbi.nlm.nih.gov/books/NBK500364/table/ch3.Tab5/?report=objectonly") |>
          transform_janssen_norms(norm_name = "janssen_euvas"))




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# collecting into one table
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


utility_norms <- rbind(mvh, vih_primary, janssen) |>
  setcolorder(c("norm_country", "norm_id", "age_low", "age_high", "sex", "avg_util")) |>
  setorder(norm_country, norm_id, age_low, sex)

utility_norms[, age_low := as.numeric(age_low)]
utility_norms[, age_high := as.numeric(age_high)]
utility_norms[, avg_util := as.numeric(avg_util)]



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# info about the utility norms?
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# making a data.table that stores information about the package utility norms
# and will also be used to select a default utility norm to be used in the dQALY calculation
# should the user not specify the norm they'd like to use by name or supply their own
# Note to self: at some point write test checking that there is only one default for every country

norm_info <- unique(utility_norms[, .(norm_id, norm_country)])

norm_info[
  , c("eq5d_data_version", "eq5d_data_year", "value_set_country", "value_set_version", "value_set_type", "value_set_year"):=""
][
  , c("norm_doi", "norm_url"):=""
][
  , score := fcase(grepl("tto", norm_id), 3,
                     grepl("_vas", norm_id), 2,
                     grepl("vih", norm_id), 5,
                     grepl("mvh", norm_id), 5)
][
  , score := ifelse(is.na(score), 1, score)
][
  , default := ifelse(score == max(score), T, F), by = norm_country
][
  , score := NULL
]


# Get some info about the EQ5D data that were used to calculate population-level
# utility norms from the article https://pmc.ncbi.nlm.nih.gov/articles/PMC6438939/
janssen_eq5d_data_info <- extract_janssen_norms(url = "https://pmc.ncbi.nlm.nih.gov/articles/PMC6438939/table/Tab1/",
                                                element = ".content")[, .(Country, `Data collection`)][
                                                  # changing country names so they line up with UN life tables
                                                  Country == "Korea", Country := "Republic of Korea"
                                                ][
                                                  Country == "United States", Country := "United States of America"
                                                ] |>
  setnames(new = c("norm_country", "eq5d_data_year"))


norm_info <- norm_info[janssen_eq5d_data_info, on = .(norm_country)][
  , eq5d_data_year := fcoalesce(i.eq5d_data_year, eq5d_data_year)
][, i.eq5d_data_year := NULL]


# adding in other pieces on info
norm_info[grepl("tto", norm_id), value_set_type := "TTO"][
  grepl("vas", norm_id), value_set_type := "VAS"
]

norm_info[, value_set_country := norm_country][
  grepl("_eu", norm_id), value_set_country := "Europe"  # (Finland, Germany, The Netherlands, Spain, Sweden, the UK)
]

norm_info[grepl("janssen", norm_id), eq5d_data_version := "EQ-5D-3L"]

norm_info[norm_id == "mvh", value_set_type := "TTO"][
  norm_id == "mvh", c("eq5d_data_year", "value_set_year") := 1993
][
  norm_id == "mvh", c("eq5d_data_version", "value_set_version") := "EQ-5D-3L"
]


norm_info[norm_id == "vih", ':='(eq5d_data_version = "EQ-5D-5L", eq5d_data_year = "2017/2018",
                              value_set_version = "EQ-5D-3L", value_set_type = "TTO", value_set_year = 1993)]


norm_info[grepl("janssen", norm_id), norm_doi := "10.1007/978-94-007-7596-1_3"][
  grepl("janssen", norm_id), norm_url := "https://www.ncbi.nlm.nih.gov/books/NBK500364/"
][
  grepl("vih", norm_id), norm_doi := "10.1016/j.jval.2022.07.005"
][
  grepl("vih", norm_id), norm_url := "https://www.valueinhealthjournal.com/article/S1098-3015(22)02101-5/fulltext"
][
  grepl("mvh", norm_id), norm_url := "https://www.york.ac.uk/che/pdf/DP172.pdf"
]






# should the value set link to/reference the eq5d package in some way?
# check: mvh is probably the same set of norms as one of them in the janssen stuff


# Come back & read properly & integrate info if relevant
# https://link.springer.com/article/10.1007/s10198-021-01326-9
# https://pophealthmetrics.biomedcentral.com/articles/10.1186/1478-7954-9-17
