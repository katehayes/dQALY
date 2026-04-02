# Return info on the available HRQoL population norms

Return info on the available HRQoL population norms

## Usage

``` r
hrqol_norms(country = NULL, references = FALSE)
```

## Arguments

- country:

  `[string]`

  The name of a country (for which data is available & stored in the
  package).

  Defaults to `NULL` - in this case, info about the HRQoL norms stored
  for all available countries are returned. If the user passes the name
  of a country to this argument, only information about the HRQoL norm
  data of that specific country is returned by the function.

  Case-sensitive - users can view the list of permissible country names
  by calling the function without specifying a value for `country`.

- references:

  `[boolean]`

  Default `FALSE`. Set to `TRUE` in order to view information about the
  sources of HRQoL data (DOIs/URLs).

## Value

A data frame containing information about available HRQoL norms.

## Examples

``` r
head(hrqol_norms())
#>   norm_country eq5d_data_year       norm_id eq5d_data_version value_set_country
#> 1    Argentina           2005 janssen_euvas          EQ-5D-3L            Europe
#> 2    Argentina           2005   janssen_tto          EQ-5D-3L         Argentina
#> 3    Argentina           2005   janssen_vas          EQ-5D-3L         Argentina
#> 4      Belgium      2001-2003 janssen_euvas          EQ-5D-3L            Europe
#> 5      Belgium      2001-2003   janssen_vas          EQ-5D-3L           Belgium
#> 6        China           2010 janssen_euvas          EQ-5D-3L            Europe
#>   value_set_version value_set_type value_set_year default
#> 1          EQ-5D-3L            VAS                  FALSE
#> 2          EQ-5D-3L            TTO                   TRUE
#> 3          EQ-5D-3L            VAS                  FALSE
#> 4          EQ-5D-3L            VAS                  FALSE
#> 5          EQ-5D-3L            VAS                   TRUE
#> 6          EQ-5D-3L            VAS                   TRUE
hrqol_norms(country = "England")
#>   norm_country eq5d_data_year       norm_id eq5d_data_version value_set_country
#> 1      England           2008 janssen_euvas          EQ-5D-3L            Europe
#> 2      England           2008   janssen_tto          EQ-5D-3L           England
#> 3      England           2008   janssen_vas          EQ-5D-3L           England
#> 4      England      2017-2018   vih_primary          EQ-5D-5L           England
#> 5      England      2017-2018 vih_secondary          EQ-5D-5L           England
#>   value_set_version value_set_type value_set_year default
#> 1          EQ-5D-3L            VAS                  FALSE
#> 2          EQ-5D-3L            TTO                  FALSE
#> 3          EQ-5D-3L            VAS                  FALSE
#> 4          EQ-5D-3L            DSU           1993    TRUE
#> 5          EQ-5D-3L             CW           1993   FALSE
hrqol_norms(country = "England", references = TRUE)
#>   norm_country eq5d_data_year       norm_id eq5d_data_version value_set_country
#> 1      England           2008 janssen_euvas          EQ-5D-3L            Europe
#> 2      England           2008   janssen_tto          EQ-5D-3L           England
#> 3      England           2008   janssen_vas          EQ-5D-3L           England
#> 4      England      2017-2018   vih_primary          EQ-5D-5L           England
#> 5      England      2017-2018 vih_secondary          EQ-5D-5L           England
#>   value_set_version value_set_type value_set_year                    norm_doi
#> 1          EQ-5D-3L            VAS                10.1007/978-94-007-7596-1_3
#> 2          EQ-5D-3L            TTO                10.1007/978-94-007-7596-1_3
#> 3          EQ-5D-3L            VAS                10.1007/978-94-007-7596-1_3
#> 4          EQ-5D-3L            DSU           1993  10.1016/j.jval.2022.07.005
#> 5          EQ-5D-3L             CW           1993  10.1016/j.jval.2022.07.005
#>                                                                      norm_url
#> 1                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 2                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 3                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
#> 4 https://www.valueinhealthjournal.com/article/S1098-3015(22)02101-5/fulltext
#> 5 https://www.valueinhealthjournal.com/article/S1098-3015(22)02101-5/fulltext
#>   default
#> 1   FALSE
#> 2   FALSE
#> 3   FALSE
#> 4    TRUE
#> 5   FALSE
```
