# -------------------------------------------------------------------------

extract_html_norms <- function(url, element = ".large_tbl") {

  rvest::read_html(url) |>
    rvest::html_element(element) |>
    rvest::html_table(fill = T) |>
    as.data.table() -> norms

}

# -------------------------------------------------------------------------







# -------------------------------------------------------------------------
# Norms from the 1993 Measurement and Valuation of Health Study
# https://www.york.ac.uk/che/pdf/DP172.pdf
# -------------------------------------------------------------------------

mvh <- data.table(sex = c(rep("male", 8), rep("female", 8)),
                  lower = c(0, 18, 25, 35, 45, 55, 65, 75),
                  upper = c(17, 24, 34, 44, 54, 64, 74, 200),
                  avg_hrqol = c(# male
                        c(0.94, 0.94, 0.93, 0.91, 0.84, 0.78, 0.78, 0.75),
                        # female
                        c(0.94, 0.94, 0.93, 0.91, 0.85, 0.81, 0.78, 0.71)),
                  norm_id = "mvh",
                  norm_country = "United Kingdom")



# -------------------------------------------------------------------------
# Newer qaly norms from the 2023 Value in Health paper:
# https://www.valueinhealthjournal.com/article/S1098-3015(22)02101-5/fulltext
# extracted from their github repo: https://github.com/bitowaqr/shortfall/tree/main
# -------------------------------------------------------------------------

temp <- tempfile()
download.file(url = "https://raw.githubusercontent.com/bitowaqr/shortfall/main/src%20manuscript/output/hrqol_co_ci_df.csv", temp)

vih_primary <- as.data.table(utils::read.csv(temp))

vih_primary[, lower := as.numeric(substring(age5_str, 1, 2))]
vih_primary[, upper := as.numeric(substring(age5_str, 4, 5))]
vih_primary[lower == max(lower), upper := 200]
vih_primary[, avg_hrqol := sub(" .*", "", m_ci)]
vih_primary[, c("age5_str", "m_ci", "n"):=NULL]
vih_primary[, norm_id := "vih_primary"]
vih_primary[, norm_country := "England"]

yg <- vih_primary[lower == min(lower)]
yg[, upper := lower - 1]
yg[, lower := 0]

vih_primary <- rbind(vih_primary, yg)



temp <- tempfile()
download.file(url = "https://raw.githubusercontent.com/bitowaqr/shortfall/main/src%20manuscript/output/hrqol_cw_ci_df.csv", temp)

vih_secondary <- as.data.table(utils::read.csv(temp))


vih_secondary[, lower := as.numeric(substring(age5_str, 1, 2))]
vih_secondary[, upper := as.numeric(substring(age5_str, 4, 5))]
vih_secondary[lower == max(lower), upper := 200]
vih_secondary[, avg_hrqol := sub(" .*", "", m_ci)]
vih_secondary[, c("age5_str", "m_ci", "n"):=NULL]
vih_secondary[, norm_id := "vih_secondary"]
vih_secondary[, norm_country := "England"]

yg <- vih_secondary[lower == min(lower)]
yg[, upper := lower - 1]
yg[, lower := 0]

vih_secondary <- rbind(vih_secondary, yg)



# -------------------------------------------------------------------------
# janssen
# -------------------------------------------------------------------------

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
         variable.name = "lower",
         value.name = "avg_hrqol")

  norms[, avg_hrqol := as.numeric(avg_hrqol)]
  norms[grepl("England", norm_country), norm_country := "England"]

  # changing country names so they line up with UN life tables
  norms[norm_country == "Korea", norm_country := "Republic of Korea"]
  norms[norm_country == "UK", norm_country := "United Kingdom"]
  norms[norm_country == "US", norm_country := "United States of America"]

  norms[, upper := as.numeric(substring(lower, 4, 5))]
  norms[, lower := as.numeric(substring(lower, 1, 2))]
  norms[lower == max(lower), upper := 200]
  norms[, norm_id := norm_name]

  yg <- norms[lower == min(lower)]
  yg[, upper := lower - 1]
  yg[, lower := 0]

  # Other norms are sex-specific
  rbind(norms, yg, norms, yg) |>
    cbind(data.table(sex = c(rep("male", nrow(norms) + nrow(yg)),
                             rep("female", nrow(norms) + nrow(yg))))) -> norms

}


janssen <- extract_html_norms(url = "https://www.ncbi.nlm.nih.gov/books/NBK500364/table/ch3.Tab6/?report=objectonly") |>
  transform_janssen_norms(norm_name = "janssen_tto") |>
  rbind(extract_html_norms(url = "https://www.ncbi.nlm.nih.gov/books/NBK500364/table/ch3.Tab7/?report=objectonly") |>
          transform_janssen_norms(norm_name = "janssen_vas")) |>
  rbind(extract_html_norms(url = "https://www.ncbi.nlm.nih.gov/books/NBK500364/table/ch3.Tab5/?report=objectonly") |>
          transform_janssen_norms(norm_name = "janssen_euvas"))


# -------------------------------------------------------------------------
# Romania
# -------------------------------------------------------------------------

# Romania
# https://hqlo.biomedcentral.com/articles/10.1186/s12955-023-02144-8
# Olariu E, Mohammed W, Oluboyede Y, Caplescu R, Niculescu-Aron IG,
# Paveliu MS, Vale L. EQ-5D-5L: a value set for Romania. Eur J Health Econ.
# 2023;24:399–412.
# Paveliu MS, Olariu E, Caplescu R, Oluboyede Y, Niculescu-Aron IG, Ernu S,
# Vale L. Estimating an EQ-5D-3L Value Set for Romania Using Time TradeOf. Int J Environ Res Public Health. 2021;18(14):7415.


rom_norms <- extract_html_norms(url = "https://hqlo.biomedcentral.com/articles/10.1186/s12955-023-02144-8/tables/2",
                                   element = ".c-article-table-container")


rom_5L <- rom_norms[Indicator == "Mean (SE)", c(1,4,5)] |>
  setnames(new = rom_norms[1, c(1,4,5)] |>
           unlist()) |>
  setnames(old = "Age group", new = "lower") |>
  melt(measure.vars = c("Men", "Women"),
       variable.name = "sex",
       value.name = "avg_hrqol")

rom_5L[, upper := as.numeric(substring(lower, 4, 5))]
rom_5L[, lower := as.numeric(substring(lower, 1, 2))]
rom_5L[lower == max(lower), upper := 200]
rom_5L[, avg_hrqol := as.numeric(substring(avg_hrqol, 1, 5))]
rom_5L[, sex := ifelse(sex == "Men", "male", "female")]
rom_5L[, norm_id := "rom_5L"]
rom_5L[, norm_country := "Romania"]

yg <- rom_5L[lower == min(lower)]
yg[, upper := lower - 1]
yg[, lower := 0]

rom_5L <- rbind(yg, rom_5L)


rom_3L <- rom_norms[Indicator == "Mean (SE)", c(1,7,8)] |>
  setnames(new = rom_norms[1, c(1,7,8)] |>
             unlist()) |>
  setnames(old = "Age group", new = "lower") |>
  melt(measure.vars = c("Men", "Women"),
       variable.name = "sex",
       value.name = "avg_hrqol")

rom_3L[, upper := as.numeric(substring(lower, 4, 5))]
rom_3L[, lower := as.numeric(substring(lower, 1, 2))]
rom_3L[lower == max(lower), upper := 200]
rom_3L[, avg_hrqol := as.numeric(substring(avg_hrqol, 1, 5))]
rom_3L[, sex := ifelse(sex == "Men", "male", "female")]
rom_3L[, norm_id := "rom_3L"]
rom_3L[, norm_country := "Romania"]

yg <- rom_3L[lower == min(lower)]
yg[, upper := lower - 1]
yg[, lower := 0]

rom_3L <- rbind(yg, rom_3L)


# -------------------------------------------------------------------------
# LA-level utility norms
# -------------------------------------------------------------------------

# should I change norm_country to norm_location?

temp <- tempfile()
download.file(url = "https://osf.io/download/cx2w8/", temp)

la_code2name <- as.data.table(utils::read.csv(temp))[, .(norm_country = geography_name, geography_code)] |>
  unique()


temp <- tempfile()
download.file(url = "https://osf.io/download/mc2sk/", temp)

la_utils <- as.data.table(utils::read.csv(temp))[, .(sex = sex_name, geography_code = la_code,
                                                     age_name, avg_hrqol = eq5d_util_lf_6v_wt)]

la_utils <- la_code2name[la_utils,
                         on = .(geography_code),
                         .(norm_country, sex, age_name, avg_hrqol)][
                           , sex := ifelse(sex == "Female", "female", "male")
                         ][
                           , lower := as.numeric(substring(age_name, 1, 2))
                         ][
                           is.na(lower), lower := 0
                         ][
                           , upper := as.numeric(substring(age_name, 4, 5))
                         ][
                           lower == 0, upper := 20
                         ][
                           lower == 80, upper := 200
                         ][
                           , age_name := NULL
                         ]




# -------------------------------------------------------------------------
# collecting into one table
# -------------------------------------------------------------------------


utility_norms <- rbind(mvh, vih_primary, vih_secondary, janssen, rom_3L, rom_5L) |>
  setcolorder(c("norm_country", "norm_id", "lower", "upper", "sex", "avg_hrqol")) |>
  setorder(norm_country, norm_id, lower, sex)

utility_norms[, lower := as.numeric(lower)]
utility_norms[, upper := as.numeric(upper)]
utility_norms[, avg_hrqol := as.numeric(avg_hrqol)]


root <- file.path(here::here(), "data-raw")
write.csv(utility_norms, file.path(root, "utility_norms.csv"))




# -------------------------------------------------------------------------
# Long term conditions in UK
# -------------------------------------------------------------------------
# NOTE FOR LATER
# if we only have values for older age groups for specific population groups like disease groups,
# we could just output dQALY measures for those years on?

# ltc_norms <- extract_html_norms(url = "https://www.ncbi.nlm.nih.gov/books/NBK592229/table/table18/?report=objectonly")
#
# names <- ltc_norms[1, ] |>
#   unlist()
#
# setnames(ltc_norms, new = names)
#
# ltc_norms <- ltc_norms[4, -c(1,3,5,7,9:11)] |>
#   melt(measure.vars = patterns("years"),
#        variable.name = "lower",
#        value.name = "avg_hrqol")
#
# ltc_norms[, avg_hrqol := as.numeric(substring(avg_hrqol, 1, 5))]
# ltc_norms[, upper := as.numeric(substring(lower, 4, 5))]
# ltc_norms[, lower := as.numeric(substring(lower, 1, 2))]


