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
vih_primary[, norm_id := "vih_primary"]
vih_primary[, norm_country := "England"]

yg <- vih_primary[age_low == min(age_low)]
yg[, age_high := age_low - 1]
yg[, age_low := 0]

vih_primary <- rbind(vih_primary, yg)



temp <- tempfile()
download.file(url = "https://raw.githubusercontent.com/bitowaqr/shortfall/main/src%20manuscript/output/hrqol_cw_ci_df.csv", temp)

vih_secondary <- as.data.table(utils::read.csv(temp))


vih_secondary[, age_low := as.numeric(substring(age5_str, 1, 2))]
vih_secondary[, age_high := as.numeric(substring(age5_str, 4, 5))]
vih_secondary[age_low == max(age_low), age_high := 200]
vih_secondary[, avg_util := sub(" .*", "", m_ci)]
vih_secondary[, c("age5_str", "m_ci", "n"):=NULL]
vih_secondary[, norm_id := "vih_secondary"]
vih_secondary[, norm_country := "England"]

yg <- vih_secondary[age_low == min(age_low)]
yg[, age_high := age_low - 1]
yg[, age_low := 0]

vih_secondary <- rbind(vih_secondary, yg)


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
# Romania
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

rom_norms <- extract_janssen_norms(url = "https://hqlo.biomedcentral.com/articles/10.1186/s12955-023-02144-8/tables/2",
                                   element = ".c-article-table-container")


rom_5L <- rom_norms[Indicator == "Mean (SE)", c(1,4,5)] |>
  setnames(new = rom_norms[1, c(1,4,5)] |>
           unlist()) |>
  setnames(old = "Age group", new = "age_low") |>
  melt(measure.vars = c("Men", "Women"),
       variable.name = "sex",
       value.name = "avg_util")

rom_5L[, age_high := as.numeric(substring(age_low, 4, 5))]
rom_5L[, age_low := as.numeric(substring(age_low, 1, 2))]
rom_5L[age_low == max(age_low), age_high := 200]
rom_5L[, avg_util := as.numeric(substring(avg_util, 1, 5))]
rom_5L[, sex := ifelse(sex == "Men", "male", "female")]
rom_5L[, norm_id := "rom_5L"]
rom_5L[, norm_country := "Romania"]

rom_3L <- rom_norms[Indicator == "Mean (SE)", c(1,7,8)] |>
  setnames(new = rom_norms[1, c(1,7,8)] |>
             unlist()) |>
  setnames(old = "Age group", new = "age_low") |>
  melt(measure.vars = c("Men", "Women"),
       variable.name = "sex",
       value.name = "avg_util")

rom_3L[, age_high := as.numeric(substring(age_low, 4, 5))]
rom_3L[, age_low := as.numeric(substring(age_low, 1, 2))]
rom_3L[age_low == max(age_low), age_high := 200]
rom_3L[, avg_util := as.numeric(substring(avg_util, 1, 5))]
rom_3L[, sex := ifelse(sex == "Men", "male", "female")]
rom_3L[, norm_id := "rom_3L"]
rom_3L[, norm_country := "Romania"]



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# LA-level utility norms
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# should I change norm_country to norm_location?

temp <- tempfile()
download.file(url = "https://osf.io/download/cx2w8/", temp)

la_code2name <- as.data.table(utils::read.csv(temp))[, .(norm_country = geography_name, geography_code)] |>
  unique()


temp <- tempfile()
download.file(url = "https://osf.io/download/mc2sk/", temp)

la_utils <- as.data.table(utils::read.csv(temp))[, .(sex = sex_name, geography_code = la_code,
                                                     age_name, avg_util = eq5d_util_lf_6v_wt)]

la_utils <- la_code2name[la_utils,
                         on = .(geography_code),
                         .(norm_country, sex, age_name, avg_util)][
                           , sex := ifelse(sex == "Female", "female", "male")
                         ]


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Long term conditions in UK
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# NOTE FOR LATER
# if we only have values for older age groups for specific population groups like disease groups,
# we could just output dQALY measures for those years on?

# ltc_norms <- extract_janssen_norms(url = "https://www.ncbi.nlm.nih.gov/books/NBK592229/table/table18/?report=objectonly")
#
# names <- ltc_norms[1, ] |>
#   unlist()
#
# setnames(ltc_norms, new = names)
#
# ltc_norms <- ltc_norms[4, -c(1,3,5,7,9:11)] |>
#   melt(measure.vars = patterns("years"),
#        variable.name = "age_low",
#        value.name = "avg_util")
#
# ltc_norms[, avg_util := as.numeric(substring(avg_util, 1, 5))]
# ltc_norms[, age_high := as.numeric(substring(age_low, 4, 5))]
# ltc_norms[, age_low := as.numeric(substring(age_low, 1, 2))]

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# collecting into one table
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


utility_norms <- rbind(mvh, vih_primary, vih_secondary, janssen, rom_3L, rom_5L) |>
  setcolorder(c("norm_country", "norm_id", "age_low", "age_high", "sex", "avg_util")) |>
  setorder(norm_country, norm_id, age_low, sex)

utility_norms[, age_low := as.numeric(age_low)]
utility_norms[, age_high := as.numeric(age_high)]
utility_norms[, avg_util := as.numeric(avg_util)]



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# info about the utility norms
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# making a data.table that stores information about the package utility norms
# and will also be used to select a default utility norm to be used in the dQALY calculation
# should the user not specify the norm they'd like to use by name or supply their own
# Note to self: at some point write test checking that there is only one default for every country
# should we add value_set_doi/url in addition to having norm_doi/url
# look at the workflow eq5d package has in place for updating valuesets. the save-data script? relevant?

norm_info <- unique(utility_norms[, .(norm_id, norm_country)])

norm_info[
  , c("eq5d_data_version", "value_set_country", "value_set_version", "value_set_type", "value_set_year"):=""
][
  , c("norm_doi", "norm_url"):=""
][
  , score := fcase(grepl("tto", norm_id), 3,
                     grepl("_vas", norm_id), 2,
                     grepl("vih_primary", norm_id), 5,
                     grepl("mvh", norm_id), 5,
                     grepl("3L", norm_id), 5)
][
  , score := ifelse(is.na(score), 1, score)
][
  , default := ifelse(score == max(score), T, F), by = norm_country
][
  , score := NULL
]


# Get some info about the EQ5D data that were used to calculate population-level
# utility norms from the article https://pmc.ncbi.nlm.nih.gov/articles/PMC6438939/
# here i'm throwing away info about sample size etc. but I could start collecting this
janssen_eq5d_data_info <- extract_janssen_norms(url = "https://pmc.ncbi.nlm.nih.gov/articles/PMC6438939/table/Tab1/",
                                                element = ".content")[, .(Country, `Data collection`)][
                                                  # changing country names so they line up with UN life tables
                                                  Country == "Korea", Country := "Republic of Korea"
                                                ][
                                                  Country == "United States", Country := "United States of America"
                                                ] |>
  setnames(new = c("norm_country", "eq5d_data_year"))



norm_info <- janssen_eq5d_data_info[norm_info, on = .(norm_country)][
  , eq5d_data_year := gsub("–", "-", eq5d_data_year)
][
  !(grepl("janssen", norm_id)), eq5d_data_year := NA
]




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


norm_info[grepl("vih", norm_id), ':='(eq5d_data_version = "EQ-5D-5L", eq5d_data_year = "2017-2018",
                              value_set_version = "EQ-5D-3L", value_set_year = 1993)]
norm_info[grepl("vih", norm_id), value_set_type := ifelse(norm_id == "vih_primary", "DSU", "CW")]


norm_info[grepl("janssen", norm_id), norm_doi := "10.1007/978-94-007-7596-1_3"][
  grepl("janssen", norm_id), norm_url := "https://www.ncbi.nlm.nih.gov/books/NBK500364/"
][
  grepl("vih", norm_id), norm_doi := "10.1016/j.jval.2022.07.005"
][
  grepl("vih", norm_id), norm_url := "https://www.valueinhealthjournal.com/article/S1098-3015(22)02101-5/fulltext"
][
  grepl("mvh", norm_id), norm_url := "https://www.york.ac.uk/che/pdf/DP172.pdf"
]

norm_info[, value_set_version := "EQ-5D-3L"]


norm_info[grepl("rom", norm_id), ':='(norm_doi = "10.1186/s12955-023-02144-8",
                                      norm_url = "https://hqlo.biomedcentral.com/articles/10.1186/s12955-023-02144-8",
                                      eq5d_data_year = "2018-2019",
                                      value_set_year = "2018-2019")]
norm_info[grepl("rom", norm_id), value_set_version := ifelse(norm_id == "rom_3L", "EQ-5D-3L", "EQ-5D-5L")]
norm_info[grepl("rom", norm_id), value_set_type := ifelse(norm_id == "rom_3L", "cTTO", "VT")]
norm_info[grepl("rom", norm_id), eq5d_data_version := ifelse(norm_id == "rom_3L", "EQ-5D-3L", "EQ-5D-5L")]


# Looking at the way eq5d package categorises value sets
# Version   Type  Country
# EQ-5D-5L	VT	  Peru_cTTO
# EQ-5D-5L	VT	  Peru_DCE
# in eq5d package, type isn't exactly equivalent to valuation method


# should the value set link to/reference the eq5d package in some way?
# ie the eq5d function call that brings up that value set?
# check: mvh is probably the same set of norms as one of them in the janssen stuff


# Come back & read properly & integrate info if relevant
# https://link.springer.com/article/10.1007/s10198-021-01326-9
# https://pophealthmetrics.biomedcentral.com/articles/10.1186/1478-7954-9-17


# Euroqol repository
# https://euroqol.org/information-and-support/resources/population-norms/

# Romania(!)
# https://hqlo.biomedcentral.com/articles/10.1186/s12955-023-02144-8
# Olariu E, Mohammed W, Oluboyede Y, Caplescu R, Niculescu-Aron IG,
# Paveliu MS, Vale L. EQ-5D-5L: a value set for Romania. Eur J Health Econ.
# 2023;24:399–412.
# Paveliu MS, Olariu E, Caplescu R, Oluboyede Y, Niculescu-Aron IG, Ernu S,
# Vale L. Estimating an EQ-5D-3L Value Set for Romania Using Time TradeOf. Int J Environ Res Public Health. 2021;18(14):7415.

# GB LA level
# https://bmjopen.bmj.com/content/14/3/e076704

# Iran
# https://pophealthmetrics.biomedcentral.com/articles/10.1186/s12963-025-00366-0
# Goudarzi R, Sari AA, Zeraati H, Rashidian A, Mohammad K, Amini S. Valuation of quality weights for EuroQol 5-dimensional health states with the time trade-off method in the capital of Iran. Value Health Reg Issues. 2019;18:170–5.
# https://pubmed.ncbi.nlm.nih.gov/38450671/
# https://hqlo.biomedcentral.com/articles/10.1186/s12955-020-01365-5

# Australia
# https://pubmed.ncbi.nlm.nih.gov/38085452/
# https://pure.york.ac.uk/portal/en/publications/australian-health-related-quality-of-life-population-norms-derive
# South australia
# https://hqlo.biomedcentral.com/articles/10.1186/s12955-016-0537-0

# Norway
# https://www.scup.com/doi/full/10.18261/tfo.10.2.6
# https://eprints.whiterose.ac.uk/id/eprint/198905/1/s12889_023_15663_2.pdf

# Singapore
# https://annals.edu.sg/health-related-quality-of-life-in-singapore-population-norms-for-the-eq-5d-5l-and-eortc-qlq-c30/

# Sri Lanka
# https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0108434
# https://eprints.qut.edu.au/200583/

# India
# https://jogh.org/2023/jogh-13-04018

# Peru & argentina
# file:///C:/Users/kate.hayes2/Downloads/Thesis-final-Alba-Dominguez-Galvan.pdf

# Russia (moscow)
# https://d-nb.info/1224529464/34

# Poland
# https://www.archivesofmedicalscience.com/pdf-53544-57925?filename=57925.pdf

# Belgium
# https://archpublichealth.biomedcentral.com/articles/10.1186/s13690-022-01011-0


# Dutch females specifically?
# https://link.springer.com/article/10.1007/s11136-022-03271-3

# Range of different diseases
# https://www.frontiersin.org/journals/public-health/articles/10.3389/fpubh.2021.675523/full

# MI survivors in Portugal
# https://revportcardiol.org/en-quality-life-in-adults-living-articulo-S2174204920302919

# People with multiple sclerosis in USA
# https://jpro.springeropen.com/articles/10.1186/s41687-022-00415-4

# Malaysia - also, different patient groups (hypertension)
# https://scialert.net/fulltext/?doi=jms.2011.84.89

# North East England, adults with type 2 diabetes
# https://www.ncbi.nlm.nih.gov/books/NBK592229/


