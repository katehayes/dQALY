# Return norm data stored by package

Return norm data stored by package

## Usage

``` r
package_norms(country, id = default_norms(country), avg_hrqol_young = NULL)
```

## Arguments

- country:

  `[string]`

  The name of a country (for which data is available & stored in the
  package). Case-sensitive - please use function `hrqol_norms` to see
  the list of permissible country names.

- id:

  `[string]`

  Often, more than one set of HRQoL norms are available for a single
  country. The default value for this argument is a call to the function
  `default_norms`, which returns the ID of the default norms for the
  chosen country. If users wish to return an alternative set of norms
  belonging to the chosen country, they can pass the ID to this
  argument. Use function `hrqol_norms` to see the IDs of the norms
  available for each country.

- avg_hrqol_young:

  `[numeric]`

  Allows users to control the way in which assumptions are made about
  the average health-related quality of life of those under 18, for whom
  data is not typically available.

  Defaults to `NULL`. In this case the youngest age group is assumed to
  have the same average utility score as that of the next youngest
  group.

  Alternatively, the user can make their own assumption about the HRQoL
  score given to the youngest group, by passing `avg_hrqol_young` a
  numeric value between 0 and 1, where 1 would be equivalent to assuming
  the youngest age group is in perfect health.

## Value

A data frame, containing HRQoL data.

## Examples

``` r
package_norms(country = "Romania")
#>    lower upper    sex avg_hrqol
#> 1      0    17 female     0.976
#> 2      0    17   male     0.984
#> 3     18    24 female     0.976
#> 4     18    24   male     0.984
#> 5     25    34 female     0.979
#> 6     25    34   male     0.973
#> 7     35    44 female     0.969
#> 8     35    44   male     0.968
#> 9     45    54 female     0.951
#> 10    45    54   male     0.946
#> 11    55    64 female     0.906
#> 12    55    64   male     0.907
#> 13    65    74 female     0.838
#> 14    65    74   male     0.893
#> 15    75   200 female     0.760
#> 16    75   200   male     0.823
package_norms(country = "Romania", id = "rom_5L")
#>    lower upper    sex avg_hrqol
#> 1      0    17 female     0.981
#> 2      0    17   male     0.974
#> 3     18    24 female     0.981
#> 4     18    24   male     0.974
#> 5     25    34 female     0.974
#> 6     25    34   male     0.951
#> 7     35    44 female     0.963
#> 8     35    44   male     0.979
#> 9     45    54 female     0.950
#> 10    45    54   male     0.947
#> 11    55    64 female     0.896
#> 12    55    64   male     0.915
#> 13    65    74 female     0.826
#> 14    65    74   male     0.885
#> 15    75   200 female     0.743
#> 16    75   200   male     0.804
package_norms(country = "Romania", id = "rom_5L", avg_hrqol_young = 1)
#>    lower upper    sex avg_hrqol
#> 1      0    17 female     1.000
#> 2      0    17   male     1.000
#> 3     18    24 female     0.981
#> 4     18    24   male     0.974
#> 5     25    34 female     0.974
#> 6     25    34   male     0.951
#> 7     35    44 female     0.963
#> 8     35    44   male     0.979
#> 9     45    54 female     0.950
#> 10    45    54   male     0.947
#> 11    55    64 female     0.896
#> 12    55    64   male     0.915
#> 13    65    74 female     0.826
#> 14    65    74   male     0.885
#> 15    75   200 female     0.743
#> 16    75   200   male     0.804
```
