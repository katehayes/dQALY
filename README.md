
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

# Return all utility norm sets for all countries (first 6 only)
head(get_norm_info())
#>          norm_id norm_country eq5d_data_version eq5d_data_year
#>           <char>       <char>            <char>         <char>
#> 1: janssen_euvas    Argentina          EQ-5D-3L           2005
#> 2:   janssen_tto    Argentina          EQ-5D-3L           2005
#> 3:   janssen_vas    Argentina          EQ-5D-3L           2005
#> 4: janssen_euvas      Belgium          EQ-5D-3L      2001–2003
#> 5:   janssen_vas      Belgium          EQ-5D-3L      2001–2003
#> 6: janssen_euvas        China          EQ-5D-3L           2010
#>    value_set_country value_set_version value_set_type value_set_year default
#>               <char>            <char>         <char>         <char>  <lgcl>
#> 1:            Europe                              VAS                  FALSE
#> 2:         Argentina                              TTO                   TRUE
#> 3:         Argentina                              VAS                  FALSE
#> 4:            Europe                              VAS                  FALSE
#> 5:           Belgium                              VAS                   TRUE
#> 6:            Europe                              VAS                   TRUE

# Return all English utility norm sets with reference information
get_norm_info(country = "England", references = T)
#>          norm_id norm_country eq5d_data_version eq5d_data_year
#>           <char>       <char>            <char>         <char>
#> 1: janssen_euvas      England          EQ-5D-3L           2008
#> 2:   janssen_tto      England          EQ-5D-3L           2008
#> 3:   janssen_vas      England          EQ-5D-3L           2008
#> 4:           vih      England          EQ-5D-5L      2017/2018
#>    value_set_country value_set_version value_set_type value_set_year
#>               <char>            <char>         <char>         <char>
#> 1:            Europe                              VAS               
#> 2:           England                              TTO               
#> 3:           England                              VAS               
#> 4:           England          EQ-5D-3L            TTO           1993
#>                       norm_doi
#>                         <char>
#> 1: 10.1007/978-94-007-7596-1_3
#> 2: 10.1007/978-94-007-7596-1_3
#> 3: 10.1007/978-94-007-7596-1_3
#> 4:  10.1016/j.jval.2022.07.005
#>                                                                       norm_url
#>                                                                         <char>
#> 1:                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 2:                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 3:                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 4: https://www.valueinhealthjournal.com/article/S1098-3015(22)02101-5/fulltext
#>    default
#>     <lgcl>
#> 1:   FALSE
#> 2:   FALSE
#> 3:   FALSE
#> 4:    TRUE
```
