
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dQALY

<!-- badges: start -->
<!-- badges: end -->

<span style="color:red"> ***This package is currently under active
development and the code is subject to change.*** </span>

The goal of the dQALY package is to provide an easy and flexible way of
calculating the number of QALYs that are ‘lost’ when a person dies.

This package has been built using code adapted from the
[COVID19_QALY_App](https://github.com/LSHTM-GHECO/COVID19_QALY_App),
written by Nichola Naylor at LSHTM. The app was itself adapted from an
[Excel
tool](https://avalonecon.com/estimating-qaly-losses-associated-with-deaths-in-hospital-covid-19/)
built by Andrew Briggs to operationalise the methods he & others set out
in a [letter](https://onlinelibrary.wiley.com/doi/10.1002/hec.4208)
published in the journal Health Economics in 2020.

## Installation

You can install the development version of dQALY from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("katehayes/dQALY")
```

## Calculating QALY loss due to death - get started

``` r
library(dQALY)

# you have to minimally specify country and year
calculate_dQALY(country = "United Kingdom", year = 2015)
#>         sex age_at_death                    dQALY
#>      <char>        <int>                    <num>
#>   1: female            0 25.202848363859853719759
#>   2:   male            0 24.910017515877601823604
#>   3: female            1 25.113672994174926600408
#>   4:   male            1 24.811095618008316421310
#>   5: female            2 25.023127464102557837577
#>  ---                                             
#> 238:   male          118  0.000000000000792045576
#> 239: female          119  0.000000000000353110909
#> 240:   male          119  0.000000000000056666340
#> 241: female          120  0.000000000000017340804
#> 242:   male          120  0.000000000000002951434

# Note: If country or year you choose aren't available, it will tell you
# calculate_dQALY(country = "Scotland", year = 2015)
# calculate_dQALY(country = "United Kingdom", year = 2010)


# You can also output mean dQALY values for population groups:
# Outputting one average value for both sexes together
# calculate_dQALY(country = "United Kingdom", year = 2015, sex_group = T)

# Outputting average values for a set of age groups you specify
# my_age_groups <- data.table(age_low = c(seq(0,90,5)), age_high = c(seq(4,89,5), 100))
# calculate_dQALY(country = "United Kingdom", year = 2015, age_groups = my_age_groups)

# Outputting average values for both sexes and for the specified age groups
# calculate_dQALY(country = "United Kingdom", year = 2015, sex_group = T, age_groups = my_age_groups)
```

## Population-average health utility scores (utility norms)

The available utility norms can be viewed using the `get_norm_info`
function. Results can be filtered by country, and returned with or
without reference information.

``` r

# Return all utility norm sets for all countries (10 rows only)
print(get_norm_info(), class = FALSE, nrows = 10)
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
# print(get_norm_info(country = "England", references = T), class = FALSE)
```

For some countries, there is more than one set of utility norms stored
in the package data. For every country, we have chosen a set of default
norms - these are the norms that will be used when the `calculate_dQALY`
function is called without specifying a value for the `norms` argument.
Alternatively, the user specify what set of package norms they would
like to use by passing its ID to `norms`. Its also possible to supply
custom norms.

``` r

library(ggplot2)

# Calculating dQALY for four different countries using the country-specific 
# default utility norms set by the package
ggplot(data = calculate_dQALY(country = "England", year = 2019, 
                              sex_group = T),
       aes(x = age_at_death, y = dQALY)) +
  geom_line(colour = "red") +
  geom_line(data = calculate_dQALY(country = "Argentina", year = 2019, 
                                   sex_group = T),
            colour = "green") +
  geom_line(data = calculate_dQALY(country = "France", year = 2019, 
                                   sex_group = T),
            colour = "blue") +
  geom_line(data = calculate_dQALY(country = "Hungary", year = 2019, 
                                   sex_group = T),
            colour = "purple") +
  scale_x_continuous(name = "Age at death",
                     limits = c(0, 125),
                     expand = c(0,0)) +
  scale_y_continuous(name = "QALY loss",
                     limits = c(0, 30),
                     expand = c(0,0)) +
  theme_classic()
```

<img src="man/figures/README-package_norm_plots-1.png" width="100%" />

``` r


# Calculating dQALY using the same set of utility norms for every country
# note that the ID used needs to be valid. e.g.:
# calculate_dQALY(country = "England", year = 2019, norms = "invalid") won't work
ggplot(data = calculate_dQALY(country = "England", year = 2019, 
                              sex_group = T,
                              norms = "janssen_euvas"),
       aes(x = age_at_death, y = dQALY)) +
  geom_line(colour = "red") +
  geom_line(data = calculate_dQALY(country = "Argentina", year = 2019, 
                                   sex_group = T,
                                   norms = "janssen_euvas"),
            colour = "green") +
  geom_line(data = calculate_dQALY(country = "France", year = 2019, 
                                   sex_group = T,
                                   norms = "janssen_euvas"),
            colour = "blue") +
  geom_line(data = calculate_dQALY(country = "Hungary", year = 2019, 
                                   sex_group = T,
                                   #in hungary's case, EUVAS norms
                                   #are already the default
                                   norms = "janssen_euvas"),
            colour = "purple") +
  scale_x_continuous(name = "Age at death",
                     limits = c(0, 125),
                     expand = c(0,0)) +
  scale_y_continuous(name = "QALY loss",
                     limits = c(0, 30),
                     expand = c(0,0)) +
  theme_classic()
```

<img src="man/figures/README-package_norm_plots-2.png" width="100%" />

``` r
library(data.table)

# how to specify your own set of utility norms
my_norms <- data.table(sex = c(rep("male", 3), 
                               rep("female", 3)),
                       age_low = c(0, 20, 90),
                       age_high = c(19, 89, 150),
                       avg_util = c(1, 0.85, 0.67,
                                    0.99, 0.4, 0.2))

# if we set the health utility score for all ages equal to 1
# then we'll be calculating life years as opposed to QALYs lost
no_quality_adjustment <- data.table(sex = c("male", "female"),
                                    age_low = 0,
                                    age_high = 150,
                                    avg_util = 1)


ggplot(data = calculate_dQALY(country = "England", year = 2019, 
                              sex_group = T),
       aes(x = age_at_death, y = dQALY)) +
  geom_line(colour = "black") +
  geom_line(data = calculate_dQALY(country = "England", year = 2019, 
                                   sex_group = T,
                                   norms = no_quality_adjustment),
            colour = "red") +
  scale_x_continuous(name = "Age at death",
                     limits = c(0, 125),
                     expand = c(0,0)) +
  scale_y_continuous(name = "QALY loss",
                     limits = c(0, 30),
                     expand = c(0,0)) +
  theme_classic()
```

<img src="man/figures/README-custom_norms-1.png" width="100%" />

## Discounting

To get the net present value of the losses, we apply a discount rate. In
our package, the default discount rate is set at 3.5% as per the [NICE
health technology evaluations
manual](https://www.nice.org.uk/process/pmg36/chapter/economic-evaluation-2#discounting).
However, the most appropriate discount rate to apply in a given
evaluation/analysis is commonly subject to debate. [The Green
Book](https://www.gov.uk/government/publications/the-green-book-appraisal-and-evaluation-in-central-government/the-green-book-2020#a6-discounting),
guidance on evaluation methods issued by the Treasury, discusses a
number of discounting regimes and the reasons one might use them.

Our package allows discount rates to be specified flexibly.

``` r

# Defining a number of different discount regimes
# No discounting
r_none <- 0 #equivalently, r_none <- function(x) 0

# NICE reference case discount rate/ Green Book standard Social Time Preference Rate
r_standard <- 0.035 #equivalently, r_standard <- function(x) 0.035
# NICE alternative discount rate/Green Book recommended discount rate for health or life values
r_health <- 0.015 #equivalently, r_health <- function(x) 0.015

# Long term discounting
# Green Book recommended declining long term discount rate for health or life values
r_health_lt <- function(x) ifelse(x < 31, 0.015, ifelse(x > 75, 0.0107, 0.0129))
# Green Book recommended rate reduced by excluding pure social time preference
# (relevant if intervention may effect substantial/irreversible wealth transfers between generations)
r_health_lt_reduced <- function(x) ifelse(x < 31, 0.01, ifelse(x > 75, 0.0071, 0.0086))



# Plotting QALY loss due to death for England in 2019, 
# as discount regimes vary
library(dQALY)
library(ggplot2)

ggplot(data = calculate_dQALY(country = "England", year = 2019, 
                              sex_group = T), #equivalently, r = r_standard
       aes(x = age_at_death, y = dQALY)) +
  geom_line() +
  geom_line(data = calculate_dQALY(country = "England", year = 2019, 
                                   sex_group = T,
                                   r = r_health),
            colour = "green") +
  geom_line(data = calculate_dQALY(country = "England", year = 2019, 
                                   sex_group = T,
                                   r = r_health_lt),
            colour = "blue") +
  geom_line(data = calculate_dQALY(country = "England", year = 2019, 
                                   sex_group = T,
                                   r = r_health_lt_reduced),
            colour = "purple") +
  geom_line(data = calculate_dQALY(country = "England", year = 2019, 
                                   sex_group = T,
                                   r = r_none),
            colour = "red") +
  scale_x_continuous(name = "Age at death",
                     limits = c(0, 125),
                     expand = c(0,0)) +
  scale_y_continuous(name = "QALY loss",
                     limits = c(0, 80),
                     expand = c(0,0)) +
  theme_classic()
```

<img src="man/figures/README-discounting-1.png" width="100%" />
