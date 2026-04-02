# Return the default HRQoL norm ID for a given country

Return the default HRQoL norm ID for a given country

## Usage

``` r
default_norms(country)
```

## Arguments

- country:

  `[string]`

  The name of a country (for which data is available & stored in the
  package).

  Case-sensitive - users can view the list of permissible country names
  by calling the function `hrqol_norms` without specifying a value for
  `country`.

## Value

A string - the ID given to the set of HRQoL norms that have been
selected as the default norms for the chosen country.

## Examples

``` r
default_norms(country = "England")
#> [1] "vih_primary"
default_norms(country = "France")
#> [1] "janssen_tto"
```
