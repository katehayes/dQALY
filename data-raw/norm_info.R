
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# info about the utility norms
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# making a data.table that stores information about the package utility norms
# and will also be used to select a default utility norm to be used in the dQALY calculation
# should the user not specify the norm they'd like to use by name or supply their own
# Note to self: at some point write test checking that there is only one default for every country
# should we add value_set_doi/url in addition to having norm_doi/url
# look at the workflow eq5d package has in place for updating valuesets. the save-data script? relevant?

root <- file.path(here::here(), "data-raw")
utility_norms <- as.data.table(read.csv(file.path(root, "utility_norms.csv"), row.names = 1L))


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
janssen_eq5d_data_info <- extract_html_norms(url = "https://pmc.ncbi.nlm.nih.gov/articles/PMC6438939/table/Tab1/",
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




write.csv(norm_info, file.path(root, "norm_info.csv"))








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
