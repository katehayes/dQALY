
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dQALY

<!-- badges: start -->
<!-- badges: end -->

<span style="color:red"> ***This package is currently under active
development and the code subject to change.*** </span>

Our package was originally adapted from the
[COVID19_QALY_App](https://github.com/LSHTM-GHECO/COVID19_QALY_App)
built by Nichola Naylor at LSHTM. This app was itself adapted from an
[Excel
tool](https://avalonecon.com/estimating-qaly-losses-associated-with-deaths-in-hospital-covid-19/)
built by Andrew Briggs to operationalise the methods he & others set out
a [letter](https://onlinelibrary.wiley.com/doi/10.1002/hec.4208)
published in the journal Health Economics in 2020.

The goal of dQALY is to …

## Installation

You can install the development version of dQALY from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("katehayes/dQALY")
```

## Utility norms

The available utility norms can be viewed using the ***get_norm_info***
function. Results can be filtered by country, and returned with or
without reference information.

``` r
library(dQALY)

# Return all utility norm sets for all countries (first 10 only)
print(get_norm_info(), class = FALSE, nrows = 10)
#> Index: <norm_id>
#>           norm_id             norm_country eq5d_data_version eq5d_data_year
#>  1: janssen_euvas                Argentina          EQ-5D-3L           2005
#>  2:   janssen_tto                Argentina          EQ-5D-3L           2005
#>  3:   janssen_vas                Argentina          EQ-5D-3L           2005
#>  4: janssen_euvas                  Belgium          EQ-5D-3L      2001–2003
#>  5:   janssen_vas                  Belgium          EQ-5D-3L      2001–2003
#>  6: janssen_euvas                    China          EQ-5D-3L           2010
#>  7: janssen_euvas                  Denmark          EQ-5D-3L      2000–2001
#>  8:   janssen_tto                  Denmark          EQ-5D-3L      2000–2001
#>  9:   janssen_vas                  Denmark          EQ-5D-3L      2000–2001
#> 10: janssen_euvas                  England          EQ-5D-3L           2008
#> 11:   janssen_tto                  England          EQ-5D-3L           2008
#> 12:   janssen_vas                  England          EQ-5D-3L           2008
#> 13:           vih                  England          EQ-5D-5L      2017/2018
#> 14: janssen_euvas                  Finland          EQ-5D-3L           2000
#> 15:   janssen_vas                  Finland          EQ-5D-3L           2000
#> 16: janssen_euvas                   France          EQ-5D-3L      2001–2003
#> 17:   janssen_tto                   France          EQ-5D-3L      2001–2003
#> 18: janssen_euvas                  Germany          EQ-5D-3L      2001–2003
#> 19:   janssen_tto                  Germany          EQ-5D-3L      2001–2003
#> 20:   janssen_vas                  Germany          EQ-5D-3L      2001–2003
#> 21: janssen_euvas                   Greece          EQ-5D-3L           1998
#> 22: janssen_euvas                  Hungary          EQ-5D-3L           2000
#> 23: janssen_euvas                    Italy          EQ-5D-3L      2001–2003
#> 24:   janssen_tto                    Italy          EQ-5D-3L      2001–2003
#> 25: janssen_euvas        Republic of Korea          EQ-5D-3L           2007
#> 26:   janssen_tto        Republic of Korea          EQ-5D-3L           2007
#> 27: janssen_euvas              Netherlands          EQ-5D-3L      2001–2003
#> 28:   janssen_tto              Netherlands          EQ-5D-3L      2001–2003
#> 29: janssen_euvas              New Zealand          EQ-5D-3L           1999
#> 30:   janssen_vas              New Zealand          EQ-5D-3L           1999
#> 31: janssen_euvas                 Slovenia          EQ-5D-3L           2000
#> 32:   janssen_vas                 Slovenia          EQ-5D-3L           2000
#> 33: janssen_euvas                    Spain          EQ-5D-3L      2001–2003
#> 34:   janssen_tto                    Spain          EQ-5D-3L      2001–2003
#> 35:   janssen_vas                    Spain          EQ-5D-3L      2001–2003
#> 36: janssen_euvas                   Sweden          EQ-5D-3L           1994
#> 37: janssen_euvas                 Thailand          EQ-5D-3L           2007
#> 38: janssen_euvas           United Kingdom          EQ-5D-3L           1993
#> 39:   janssen_tto           United Kingdom          EQ-5D-3L           1993
#> 40:   janssen_vas           United Kingdom          EQ-5D-3L           1993
#> 41:           mvh           United Kingdom          EQ-5D-3L           1993
#> 42: janssen_euvas United States of America          EQ-5D-3L      2000–2002
#> 43:   janssen_tto United States of America          EQ-5D-3L      2000–2002
#>           norm_id             norm_country eq5d_data_version eq5d_data_year
#>            value_set_country value_set_version value_set_type value_set_year
#>  1:                   Europe                              VAS               
#>  2:                Argentina                              TTO               
#>  3:                Argentina                              VAS               
#>  4:                   Europe                              VAS               
#>  5:                  Belgium                              VAS               
#>  6:                   Europe                              VAS               
#>  7:                   Europe                              VAS               
#>  8:                  Denmark                              TTO               
#>  9:                  Denmark                              VAS               
#> 10:                   Europe                              VAS               
#> 11:                  England                              TTO               
#> 12:                  England                              VAS               
#> 13:                  England          EQ-5D-3L            TTO           1993
#> 14:                   Europe                              VAS               
#> 15:                  Finland                              VAS               
#> 16:                   Europe                              VAS               
#> 17:                   France                              TTO               
#> 18:                   Europe                              VAS               
#> 19:                  Germany                              TTO               
#> 20:                  Germany                              VAS               
#> 21:                   Europe                              VAS               
#> 22:                   Europe                              VAS               
#> 23:                   Europe                              VAS               
#> 24:                    Italy                              TTO               
#> 25:                   Europe                              VAS               
#> 26:        Republic of Korea                              TTO               
#> 27:                   Europe                              VAS               
#> 28:              Netherlands                              TTO               
#> 29:                   Europe                              VAS               
#> 30:              New Zealand                              VAS               
#> 31:                   Europe                              VAS               
#> 32:                 Slovenia                              VAS               
#> 33:                   Europe                              VAS               
#> 34:                    Spain                              TTO               
#> 35:                    Spain                              VAS               
#> 36:                   Europe                              VAS               
#> 37:                   Europe                              VAS               
#> 38:                   Europe                              VAS               
#> 39:           United Kingdom                              TTO               
#> 40:           United Kingdom                              VAS               
#> 41:           United Kingdom          EQ-5D-3L            TTO           1993
#> 42:                   Europe                              VAS               
#> 43: United States of America                              TTO               
#>            value_set_country value_set_version value_set_type value_set_year
#>     default
#>  1:   FALSE
#>  2:    TRUE
#>  3:   FALSE
#>  4:   FALSE
#>  5:    TRUE
#>  6:    TRUE
#>  7:   FALSE
#>  8:    TRUE
#>  9:   FALSE
#> 10:   FALSE
#> 11:   FALSE
#> 12:   FALSE
#> 13:    TRUE
#> 14:   FALSE
#> 15:    TRUE
#> 16:   FALSE
#> 17:    TRUE
#> 18:   FALSE
#> 19:    TRUE
#> 20:   FALSE
#> 21:    TRUE
#> 22:    TRUE
#> 23:   FALSE
#> 24:    TRUE
#> 25:   FALSE
#> 26:    TRUE
#> 27:   FALSE
#> 28:    TRUE
#> 29:   FALSE
#> 30:    TRUE
#> 31:   FALSE
#> 32:    TRUE
#> 33:   FALSE
#> 34:    TRUE
#> 35:   FALSE
#> 36:    TRUE
#> 37:    TRUE
#> 38:   FALSE
#> 39:   FALSE
#> 40:   FALSE
#> 41:    TRUE
#> 42:   FALSE
#> 43:    TRUE
#>     default
#> Index: <norm_id>
#>           norm_id             norm_country eq5d_data_version eq5d_data_year
#>  1: janssen_euvas                Argentina          EQ-5D-3L           2005
#>  2:   janssen_tto                Argentina          EQ-5D-3L           2005
#>  3:   janssen_vas                Argentina          EQ-5D-3L           2005
#>  4: janssen_euvas                  Belgium          EQ-5D-3L      2001–2003
#>  5:   janssen_vas                  Belgium          EQ-5D-3L      2001–2003
#> ---                                                                        
#> 39:   janssen_tto           United Kingdom          EQ-5D-3L           1993
#> 40:   janssen_vas           United Kingdom          EQ-5D-3L           1993
#> 41:           mvh           United Kingdom          EQ-5D-3L           1993
#> 42: janssen_euvas United States of America          EQ-5D-3L      2000–2002
#> 43:   janssen_tto United States of America          EQ-5D-3L      2000–2002
#>            value_set_country value_set_version value_set_type value_set_year
#>  1:                   Europe                              VAS               
#>  2:                Argentina                              TTO               
#>  3:                Argentina                              VAS               
#>  4:                   Europe                              VAS               
#>  5:                  Belgium                              VAS               
#> ---                                                                         
#> 39:           United Kingdom                              TTO               
#> 40:           United Kingdom                              VAS               
#> 41:           United Kingdom          EQ-5D-3L            TTO           1993
#> 42:                   Europe                              VAS               
#> 43: United States of America                              TTO               
#>     default
#>  1:   FALSE
#>  2:    TRUE
#>  3:   FALSE
#>  4:   FALSE
#>  5:    TRUE
#> ---        
#> 39:   FALSE
#> 40:   FALSE
#> 41:    TRUE
#> 42:   FALSE
#> 43:    TRUE

# Return all English utility norm sets with reference information
print(get_norm_info(country = "England", references = T), class = FALSE)
#>          norm_id norm_country eq5d_data_version eq5d_data_year
#> 1: janssen_euvas      England          EQ-5D-3L           2008
#> 2:   janssen_tto      England          EQ-5D-3L           2008
#> 3:   janssen_vas      England          EQ-5D-3L           2008
#> 4:           vih      England          EQ-5D-5L      2017/2018
#>    value_set_country value_set_version value_set_type value_set_year
#> 1:            Europe                              VAS               
#> 2:           England                              TTO               
#> 3:           England                              VAS               
#> 4:           England          EQ-5D-3L            TTO           1993
#>                       norm_doi
#> 1: 10.1007/978-94-007-7596-1_3
#> 2: 10.1007/978-94-007-7596-1_3
#> 3: 10.1007/978-94-007-7596-1_3
#> 4:  10.1016/j.jval.2022.07.005
#>                                                                       norm_url
#> 1:                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 2:                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 3:                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 4: https://www.valueinhealthjournal.com/article/S1098-3015(22)02101-5/fulltext
#>    default
#> 1:   FALSE
#> 2:   FALSE
#> 3:   FALSE
#> 4:    TRUE
#>          norm_id norm_country eq5d_data_version eq5d_data_year
#> 1: janssen_euvas      England          EQ-5D-3L           2008
#> 2:   janssen_tto      England          EQ-5D-3L           2008
#> 3:   janssen_vas      England          EQ-5D-3L           2008
#> 4:           vih      England          EQ-5D-5L      2017/2018
#>    value_set_country value_set_version value_set_type value_set_year
#> 1:            Europe                              VAS               
#> 2:           England                              TTO               
#> 3:           England                              VAS               
#> 4:           England          EQ-5D-3L            TTO           1993
#>                       norm_doi
#> 1: 10.1007/978-94-007-7596-1_3
#> 2: 10.1007/978-94-007-7596-1_3
#> 3: 10.1007/978-94-007-7596-1_3
#> 4:  10.1016/j.jval.2022.07.005
#>                                                                       norm_url
#> 1:                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 2:                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 3:                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 4: https://www.valueinhealthjournal.com/article/S1098-3015(22)02101-5/fulltext
#>    default
#> 1:   FALSE
#> 2:   FALSE
#> 3:   FALSE
#> 4:    TRUE
```
