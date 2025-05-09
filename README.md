
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dQALY

<!-- badges: start -->
<!-- badges: end -->

\[!WARNING\]  
This package is a work in progress.

Our code was originally adapted from Nichola Naylor’s github repo.

The goal of dQALY is to …

## Installation

You can install the development version of dQALY from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("katehayes/dQALY")
```

## Utility Norms

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
#>    value_set_country value_set_version value_set_type value_set_year default
#>               <char>            <char>         <char>         <char>  <lgcl>
#> 1:            Europe                              VAS                  FALSE
#> 2:           England                              TTO                  FALSE
#> 3:           England                              VAS                  FALSE
#> 4:           England          EQ-5D-3L            TTO           1993    TRUE
```
