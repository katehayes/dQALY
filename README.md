
<!-- devtools::build_readme() -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

# dQALY

<!-- badges: start -->

<!-- badges: end -->

<span style="color:red"> ***This package is currently under active
development and the code is subject to change.*** </span>

The quality-adjusted life year, or QALY, is a widely used outcome
measure in the field of health economics. When evaluating the impact of
a policy/programme/intervention, we often want to express the health
impacts of preventing or failing to prevent a death in terms of the
QALYs that would be gained or lost.

The goal of the dQALY package is to provide an easy and flexible way of
calculating the number of QALYs that are ‘lost’ when a person dies.

This package has been built using code adapted from the
[COVID19_QALY_App](https://github.com/LSHTM-GHECO/COVID19_QALY_App),
written by Nichola Naylor at LSHTM. The
[COVID19_QALY_App](https://github.com/LSHTM-GHECO/COVID19_QALY_App) was
itself adapted from an [Excel
tool](https://avalonecon.com/estimating-qaly-losses-associated-with-deaths-in-hospital-covid-19/)
built by Andrew Briggs to operationalise the methods for calculating
QALY loss due to death that he & others set out in a
[letter](https://onlinelibrary.wiley.com/doi/10.1002/hec.4208) published
in the journal Health Economics in 2020.
<!-- Some of the setup borrowed from qalytools & eq5d packages -->

## Installation

You can install the development version of dQALY from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("katehayes/dQALY@change-arguments")
```

## Calculating QALY loss due to death - get started with package data

The function `calculate_dQALY` produces estimates of QALY loss due to
death for a given population, using data on life expectancy and
health-related quality of life within that population. For more details
regarding how the estimates are calculated, refer to the [methods
vignette](methods.html). The package stores this data for a number of
countries. You have to minimally specify country and year:

``` r
calculate_dQALY(country = "United Kingdom", year = 2015) |> head()
#>      sex age    dQALY
#> 1 female   0 25.20285
#> 2   male   0 24.91002
#> 3 female   1 25.19784
#> 4   male   1 24.92008
#> 5 female   2 25.11352
#> 6   male   2 24.82673
calculate_dQALY(country = "France", year = 2020) |> head()
#>      sex age    dQALY
#> 1 female   0 25.74592
#> 2   male   0 25.36175
#> 3 female   1 25.74985
#> 4   male   1 25.36617
#> 5 female   2 25.67541
#> 6   male   2 25.27770
```

If country or year you choose aren’t available (the package does not
store sufficient data), you’ll get an error message informing you of
that:

``` r
calculate_dQALY(country = "Scotland", year = 2015)
#> Error in package_lt(country, year): Value for `country` must be chosen from the list of available
#>       countries. Use hrqol_norms() to see the list.
calculate_dQALY(country = "United Kingdom", year = 2010)
#> Error in package_lt(country, year): Currently the package only stores life table data for United Kingdom for the years 2015-2023.
#>                  Please set `year` to a value within this period.
```

You can also output mean dQALY values for population groups. Here, we’re
outputting one average value for each year of age for both sexes
together:

``` r
calculate_dQALY(country = "United Kingdom", year = 2015, collapse_sex = T) |> head()
#>   age    dQALY
#> 1   0 25.05262
#> 2   1 25.05541
#> 3   2 24.96654
#> 4   3 24.87112
#> 5   4 24.77174
#> 6   5 24.66846
```

Here we’re outputting average values for a set of age groups that we
specify:

``` r
my_age_groups <- data.table(lower = c(0, 90), upper = c(89, 99))
calculate_dQALY(country = "United Kingdom", year = 2015, collapse_age = my_age_groups)
#>     age lower upper    sex     dQALY
#> 1  0-89     0    89 female 17.414236
#> 2  0-89     0    89   male 17.237184
#> 3 90-99    90    99 female  2.383301
#> 4 90-99    90    99   male  2.262557
```

And lastly, here we’re outputting average values for both sexes together
and for the specified age groups:

``` r
calculate_dQALY(country = "United Kingdom", year = 2015, collapse_sex = T, collapse_age = my_age_groups)
#>     age lower upper     dQALY
#> 1  0-89     0    89 17.327103
#> 2 90-99    90    99  2.347774
```

## Exploring and altering underlying package data

### Health related quality of life (HRQoL) population norm data

Using life tables & HRQoL norms. HRQoL norms themselves are constructed
from health state data & value sets. **\[Explain norms\]** Some
discussion of HRQoL norms can be found on the [EuroQol
website](https://euroqol.org/information-and-support/resources/population-norms/).

For most countries, there is more than one set of HRQoL norms stored in
the package data. The list of available HRQoL norms and their IDs can be
viewed using the `hrqol_norms` function. This function also returns
information we have documented about the make-up of each set of HRQoL
norms - specifically, about the EQ-5D data and value sets from which the
norms are estimated. We have tried to adopt the same
terminology/categorisation scheme used by the eq5d package to document
information about value sets. Results can be filtered by country, and
returned with or without reference information.

``` r
# Return all English utility norm sets without reference information
hrqol_norms(country = "England", references = F)
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
```

We can see that the package stores five different sets of English HRQoL
population norm data. We can also see how these norms differ from each
other with regards to what population the health state was data gathered
from/ what population valued the health states/ when the data was
collected/ what methods were used to elicit the states/values.

So, contextual information about package norms can be returned using
`hrqol_norms` - another way for the user to explore package norms is to
return the actual norms themselves using the function `package_norms`:

``` r
package_norms(country = "England", id = "janssen_euvas")
#>    lower upper    sex avg_hrqol
#> 1      0    17 female     0.922
#> 2      0    17   male     0.922
#> 3     18    24 female     0.922
#> 4     18    24   male     0.922
#> 5     25    34 female     0.915
#> 6     25    34   male     0.915
#> 7     35    44 female     0.891
#> 8     35    44   male     0.891
#> 9     45    54 female     0.857
#> 10    45    54   male     0.857
#> 11    55    64 female     0.819
#> 12    55    64   male     0.819
#> 13    65    74 female     0.785
#> 14    65    74   male     0.785
#> 15    75   200 female     0.720
#> 16    75   200   male     0.720
package_norms(country = "England", id = "vih_secondary")
#>    lower upper    sex avg_hrqol
#> 1      0    15 female     0.881
#> 2      0    15   male     0.916
#> 3     16    17 female     0.881
#> 4     16    17   male     0.916
#> 5     18    19 female     0.864
#> 6     18    19   male     0.933
#> 7     20    24 female     0.866
#> 8     20    24   male     0.895
#> 9     25    29 female     0.873
#> 10    25    29   male     0.895
#> 11    30    34 female     0.870
#> 12    30    34   male     0.916
#> 13    35    39 female     0.857
#> 14    35    39   male     0.862
#> 15    40    44 female     0.850
#> 16    40    44   male     0.870
#> 17    45    49 female     0.815
#> 18    45    49   male     0.824
#> 19    50    54 female     0.805
#> 20    50    54   male     0.837
#> 21    55    59 female     0.802
#> 22    55    59   male     0.817
#> 23    60    64 female     0.784
#> 24    60    64   male     0.809
#> 25    65    69 female     0.782
#> 26    65    69   male     0.798
#> 27    70    74 female     0.787
#> 28    70    74   male     0.802
#> 29    75    79 female     0.741
#> 30    75    79   male     0.791
#> 31    80    84 female     0.717
#> 32    80    84   male     0.773
#> 33    85    89 female     0.665
#> 34    85    89   male     0.718
#> 35    90   200 female     0.665
#> 36    90   200   male     0.663
```

For every country, we have chosen a set of default norms. The default
set is indicated in the info returned by the `hrqol_norms` function, or
alternatively is returned directly by the function `default_norms` - for
England, the default norms have ID “vih_primary”. These are the norms
that will be returned when the `package_norms` function is called
without specifying a value for the `id` argument, like so:

``` r
default_norms(country = "England")
#> [1] "vih_primary"
all.equal(package_norms(country = "England"), package_norms(country = "England", id = "vih_primary"))
#> [1] TRUE
```

- these are the norms that will be used when the `calculate_dQALY`
  function is called without specifying a value for the `norms`
  argument. Alternatively, the user can specify what set of package
  norms they would like to use by passing its ID to `norms`. Hopefully,
  being able to access information about the package norms via
  `hrqol_norms` allows the user to understand the implications of
  choosing to use one set of norms over another - and to make a
  judgement about the set of norms that is most appropriate for their
  purposes.

It is also possible for the user to supply their own norm data to the
calculation.

<!-- Note: we could also store info about the model used to estimate the pop-level norms from the input data (eq5d profiles valued w the value sets) - e.g. in the ViH paper they use a linear model - What modelling methods were used to estimate population averages? -->
