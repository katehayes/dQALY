# Methods

We want to produce an estimate of $`dQALY(x)`$, the QALY loss associated
with death at age $`x`$, for particular populations (usually
country-level) and particular time periods (years). Our package
implements a method for calculating QALY loss due to death described by
Briggs et al. in a
[letter](https://onlinelibrary.wiley.com/doi/10.1002/hec.4208) published
in the journal Health Economics.

## Calculating QALY loss due to death

To produce estimates of QALY loss due to death for a given population,
we require data regarding life expectancy and health-related quality of
life within that population.

Life tables report $`q(x)`$, the probability of dying between ages $`x`$
and $`x+1`$, for $`x = 0,1,..,x_{max}`$, $`x_{max}`$ being the max age
we are interested in or have data for. With $`q(x)`$, we can calculate
$`l(x)`$, the number surviving to age $`x \ge 1`$ for a reference
population of size N,

``` math
l(x) = N\cdot\prod_{i=0}^{x}\big(1-q(i)\big)
```

and then (assuming a uniform distribution of death during the year)
$`L(x)`$, the number of years lived between ages $`x`$ and $`x+1`$,

``` math
L(x) = \frac{l(x) + l(x+1)}{2}
```

$`L(x)`$ and $`l(x)`$ can be used to calculate $`LE(x)`$, life
expectancy at age $`x`$, as follows:

``` math
LE(x) = \frac{\sum_{i=x}^{x_{max}}L(i)}{l(x)}
```

The second kind of data needed is information about the average
health-related quality of life (expressed as a number between 0 and 1)
of people within the population at each age, which we can denote
$`Q(x)`$. We’ll refer to this type of data as HRQoL norms.

Life expectancy at age $`x`$ is the number of life years a person at age
$`x`$ can expect to live over the remainder of their life - quality
adjusted life expectancy, $`QALE(x)`$, is the number of quality-adjusted
life years or QALYs that a person at age $`x`$ can expect to experience.
It’s given by

``` math
\begin{equation} \label{eq:qale}
QALE(x) = \frac{\sum_{i=x}^{x_{max}}Q(i)\cdot  L(i)}{l(x)} 
\end{equation}
```

When a person dies at age $`x`$ we don’t say that the number of QALYs
lost due to their death is exactly the same as the number of QALYs they
were expected to experience over the remainder of their life - we apply
a discount rate $`r`$ to the QALYs they would have accrued. This
reflects the idea that to us in the present, the value of QALYs that
would be experienced years into the future is less than the value of
QALYs experienced today. The discount rate is usually set at 3.5%.

``` math
\begin{equation} \label{eq:dqaly}
dQALY(x) = \frac{\sum_{i=x}^{x_{max}}Q(i)\cdot  L(i)\cdot \frac{1}{(1+r)^{(i-x)}}}{l(x)}
\end{equation}
```

  
  
With the `dQALY` package, the functions `calculate_QALE` and
`calculate_dQALY` implement the calculations described above. For more
practical details on the use of these functions see the function
documentation or the [demo
vignette](https://katehayes.github.io/dQALY/articles/demo.md).

## Adjusting mortality and morbidity

The method described above can be applied to any population for which we
have life expectancy and health-related quality of life data. However,
in practice, life tables and HRQoL norms are most commonly available at
national level. If we would like to calculate QALY loss due to death in
a population that we expect to have mortality and morbidity rates that
are significantly different from the national average (e.g. people with
Type I diabetes), then we can make adjustments to our calculation in
order to reflect this difference.  

A standardised mortality ratio $`(SMR)`$ is a measure that describes how
mortality rates in a specific group differ with respect to some standard
or reference population, after standardisation by age and sex. If the
$`SMR`$ is greater than / lesser than 1, mortality rates in the group
are greater than / lesser than rates in the reference population.  

We want to use the estimates we have of the probability of dying between
ages $`x`$ and $`x+1`$ in the reference population and the $`SMR`$ which
captures the difference in mortality rates between the reference
population and the group of interest to produce $`q_{adj}(x)`$, an
adjusted probability of dying between ages $`x`$ and $`x+1`$.  

If we let $`q_{adj}(x) = SMR \cdot q(x)`$, then it would be possible
that where $`x`$ is large, $`q_{adj}(x)`$ would exceed 1. We need to
covert $`q(x)`$, the probability of dying between ages $`x`$ and
$`x+1`$, into the corresponding instantaneous death rate, which Briggs
et al. denote $`d(x)`$, before applying the adjustment factor.  

The relationship between $`q(x)`$ and $`d(x)`$ is the relationship
between a probability and a rate:

``` math
q(x) =1 - e^{-d(x)} \iff d(x) = -ln\big(1-q(x)\big)
```

Instead of adjusting $`q(x)`$ directly, we apply our adjustment to
$`d(x)`$, letting $`d_{adj}(x) = SMR \cdot d(x)`$ - so we can express
$`q_{adj}(x)`$ in terms of $`q(x)`$ and $`SMR`$ as follows:  

``` math

\begin{aligned}
q_{adj}(x) &= 1 - e^{-d_{adj}(x)} \\&= 1 - e^{-SMR \cdot d(x)} \\&= 1 -  e^{-SMR \cdot \big( -ln(1-q(x))\big)} \\&= 1 - e^{ln((1-q(x))^{SMR})} \\&= 1 - (1 - q(x))^{SMR}
\end{aligned}
```
So,

``` math

\begin{aligned}
l_{adj}(x) &= N \cdot \prod_{i=0}^{x}\big(1-q_{adj}(i)\big) \\&= N \cdot \prod_{i=0}^{x}\big(1-q(i)\big)^{SMR}
\end{aligned}
```

and

``` math
LE_{adj}(x) = \frac{l_{adj}(x) + l_{adj}(x+1)}{2}
```
  
  

Next, we’ll use parameter $`qCM`$ to express our assumptions about how
morbidity or health related quality of life in the population of
interest differs from the reference population. With $`qCM`$, we try to
quantify the impact of pre-existing comorbidities on quality of life. If
$`qCM`$ is greater than / lesser than 1, then quality of life in the
population of interest is better than / worse than quality of life in
the reference population. We can adjust $`Q(x)`$, average quality of
life in the reference population directly, letting

``` math
Q_{adj}(x) = qCM \cdot Q(x)
```

From this point on, $`QALE(x)`$ and $`dQALY(x)`$ for the group of
interest are derived from $`l_{adj}(x)`$, $`LE_{adj}(x)`$, and
$`Q_{adj}(x)`$ exactly as shown previously in equations (1) and (2).  
  

In this package, the functions `calculate_QALE` and `calculate_dQALY`
have arguments `smr` and `qcm`, which allow the user to adjust for
mortality and morbidity as described. Again, see the function
documentation or the [demo
vignette](https://katehayes.github.io/dQALY/articles/demo.md) for
examples of this adjustment in practice.

## Note on deviations from the Briggs method

Our implementation of the method described in the Briggs letter differs
in some minor respects to theirs, resulting in slightly different dQALY
estimates. Briggs is calculating dQALY values for the United Kingdom
using 2016-18 life tables - here are their estimates, taken from the
Excel tool provided along with the letter, compared with the equivalent
estimates generated by the `calculate_dQALY` function.

``` r
library(data.table)
library(dQALY)

# reading from the Briggs excel tool 
temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.lshtm.ac.uk/media/42556",
              temp, mode = "wb")

cbind(calculate_dQALY(country = "United Kingdom",
                      year = 2017,
                      collapse_sex = T,
                      collapse_age = data.frame(lower = seq(0, 90, 10),
                                                upper = seq(9, 99, 10)))[, c(1,4)],
      data.frame(briggs_dQALY = readxl::read_xlsx(temp, sheet = 2, range = "J17:J27")$dQALY))
#>      age     dQALY briggs_dQALY
#> 1    0-9 24.704106    25.325990
#> 2  10-19 23.482892    23.606144
#> 3  20-29 21.783660    21.719500
#> 4  30-39 19.605902    19.517843
#> 5  40-49 16.823114    16.726313
#> 6  50-59 13.957527    13.788401
#> 7  60-69 10.776346    10.641562
#> 8  70-79  7.483427     7.142218
#> 9  80-89  4.437147     4.152098
#> 10 90-99  2.395034     2.065034
```

The basic calculation remains the same - the differences are to do with
choices around input data and grouping of estimates. In this section
we’ll show how to produce the Briggs results using the `calculate_dQALY`
function - hopefully this exercise will help explain the source of the
differences to those who are interested.

### Life tables

Briggs is not interested in producing sex-specific estimates at any
point. Instead of optionally pooling estimates at the end of the
calculation he a) takes sex-specific q(x)’s, b) produces sex-specific
l(x)’s, and then pools those l(x)’s together to get an average, and goes
from there. We’re just going to pull these values for l(x) in from the
Briggs excel tool, and then - since we want to be able to use the
`calculate_dQALY` function as its set up - we need the life expectancy
information in terms of q(x), so we’ll back-calculate it:

``` r
temp <- tempfile(fileext = ".xlsx")
download.file(url = "https://www.lshtm.ac.uk/media/42556",
              temp, mode = "wb")

lt <- as.data.table(readxl::read_xlsx(temp, sheet = 6, range = "R6:S127"))
lt[, q := 1 - shift(smrlx, type = "lead")/smrlx]
lt[, q := ifelse(is.na(q), shift(q, type = "lag"), q)]
lt <- lt[, .(age = Age, q)][, .(sex = c("male", "female")), by = .(age, q)]
```

### HRQoL norms

We can see in the excel tool (in the sheet called ‘LookUpTables’) that
Briggs is using getting HRQoL norms for the UK from the Janssen paper,
specifically the TTO values. This is data that we have stored in the
package.

We can also see that Briggs has assumed that the HRQoL norm for the
youngest age group (0-17) is 1. The default assumption this package
makes is more conservative - it takes the HRQoL norm for the 0-17 group
from the next youngest group. To line up with Briggs, we can use the
argument `avg_hrqol_young`:

``` r
package_norms(country = "United Kingdom", 
              id = "janssen_tto",
              avg_hrqol_young = 1)
#>    lower upper    sex avg_hrqol
#> 1      0    17 female     1.000
#> 2      0    17   male     1.000
#> 3     18    24 female     0.940
#> 4     18    24   male     0.940
#> 5     25    34 female     0.927
#> 6     25    34   male     0.927
#> 7     35    44 female     0.911
#> 8     35    44   male     0.911
#> 9     45    54 female     0.847
#> 10    45    54   male     0.847
#> 11    55    64 female     0.799
#> 12    55    64   male     0.799
#> 13    65    74 female     0.779
#> 14    65    74   male     0.779
#> 15    75   200 female     0.726
#> 16    75   200   male     0.726
```

### Grouping estimates

In the sheet called ‘Results’ (which looks up values in sheet
‘Calculations’) we can see that Briggs is outputting estimates grouped
into 10 year age bands. To produce a representative dQALY estimate for
an age group, the excel tool selects the dQALY estimate belonging to the
median age within the interval.

The calculate_dQALY function does something different - it takes a
weighted average of all the dQALY estimates in each group. By default,
population-level age/sex distribution data provides the weightings. In
order to mimic the Briggs output, in addition to defining 10 year age
groups we need to construct a new cohort to use for the weighting which
consists of one male/female aged 5, one male/female aged 15, and so on:

``` r
age_grps <- data.frame(lower = seq(0, 90, 10),
                       upper = seq(9, 99, 10))
chrt <- data.frame(sex = c(rep("male", 10), rep("female", 10)),
                   age = c(seq(5, 95, 10), seq(5, 95, 10)),
                   count = 1)
```

### Matching Briggs output

The output of the following function call should match the Briggs
results:

``` r
calculate_dQALY(life_table = lt,
                norms = package_norms(country = "United Kingdom", 
                                      id = "janssen_tto",
                                      avg_hrqol_young = 1),
                collapse_sex = T,
                collapse_age = age_grps,
                cohort = chrt)
#>      age lower upper     dQALY
#> 1    0-9     0     9 25.325990
#> 2  10-19    10    19 23.606144
#> 3  20-29    20    29 21.719500
#> 4  30-39    30    39 19.517843
#> 5  40-49    40    49 16.726313
#> 6  50-59    50    59 13.788401
#> 7  60-69    60    69 10.641562
#> 8  70-79    70    79  7.142218
#> 9  80-89    80    89  4.152098
#> 10 90-99    90    99  2.065034
```
