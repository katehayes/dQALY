# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Norms from the 1993 Measurement and Valuation of Health Study
# https://www.york.ac.uk/che/pdf/DP172.pdf
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

mvh <- data.table(sex = c(rep("male", 8), rep("female", 8)),
                  age_low = c(0, 18, 25, 35, 45, 55, 65, 75),
                  age_high = c(17, 24, 34, 44, 54, 64, 74, 200),
                  un = c(# male
                        c(0.94, 0.94, 0.93, 0.91, 0.84, 0.78, 0.78, 0.75),
                        # female
                        c(0.94, 0.94, 0.93, 0.91, 0.85, 0.81, 0.78, 0.71)),
                  id = "mvh",
                  c = "United Kingdom")



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
vih_primary[, un := sub(" .*", "", m_ci)]
vih_primary[, c("age5_str", "m_ci", "n"):=NULL]
vih_primary[, id := "vih"]
vih_primary[, c := "England"]

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


extract_janssen_norms <- function(url) {

  rvest::read_html(url) |>
    rvest::html_element(".large_tbl") |>
    rvest::html_table(fill = T) |>
    as.data.table() -> norms

}


transform_janssen_norms <- function(norms, norm_name) {

  names <- norms[1, ] |>
    unlist()
  names[1] <- "c"

  setnames(norms, new = names)

  n <- norms[c == "Regional", which = TRUE]

  # only keeping the national-level norms for now
  # melting wide to long
  norms <- norms[-c(1:2, n:nrow(norms)), -9] |>
    melt(measure = 2:8,
         variable.name = "age_low",
         value.name = "un")

  norms[, un := as.numeric(un)]
  norms[grepl("England", c), c := "England"]

  # changing country names so they line up with UN life tables
  norms[c == "Korea", c := "Republic of Korea"]
  norms[c == "UK", c := "United Kingdom"]
  norms[c == "US", c := "United States of America"]

  norms[, age_high := as.numeric(substring(age_low, 4, 5))]
  norms[, age_low := as.numeric(substring(age_low, 1, 2))]
  norms[age_low == max(age_low), age_high := 200]
  norms[, id := norm_name]

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
  setcolorder(c("c", "id", "age_low", "age_high", "sex", "un")) |>
  setorder(c, id, age_low, sex)

utility_norms[, age_low := as.numeric(age_low)]
utility_norms[, age_high := as.numeric(age_high)]
utility_norms[, un := as.numeric(un)]



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# info about the utility norms?
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


norm_info <- unique(utility_norms[, .(c, id)])[
  , c("doi", "external_url"):=""
][
  , c("survey", "value_set"):=""
][
  , default:=.N, by=c
][
  , default:= ifelse(default==1, T, F)
]





