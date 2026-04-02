# Calculate quality-adjusted life expectancy

Calculates quality-adjusted life expectancy for a given country and year

## Usage

``` r
calculate_QALE(
  country = NULL,
  year = NULL,
  life_table = package_lt(country, year, lt_extend = TRUE),
  norms = package_norms(country, id = default_norms(country), avg_hrqol_young = NULL),
  smr = 1,
  qcm = 1,
  collapse_age = FALSE,
  collapse_sex = FALSE,
  cohort = package_cohort(country, year)
)
```

## Arguments

- country:

  `[string]`

  The name of a country (for which data is available & stored in the
  package). Case-sensitive - please use function `hrqol_norms` to see
  the list of permissible country names. Defaults to `NULL`.

- year:

  `[integer]`

  A year (for which data is available & stored in the package). Defaults
  to `NULL`.

- life_table:

  `[data frame]` or `[tibble]` or `[data table]`

  The life table data that will be used in the QALY loss calculation.

  The default value for this argument is a call to a function -
  `package_lt(country, year)` - which returns life table data stored by
  the package.

  We can see that this default depends on the user having specified
  values for arguments `country` and `year`. Alternatively, the user can
  specify values for `country` and `year` within the `package_lt`
  arguments. See examples & the documentation for `package_lt` for more
  details.

  Additionally, users can supply their own life table data to the
  function, if they want to perform the calculation with something other
  than the life table data stored by the package. The life tables can be
  given in the form of a data frame, tibble, or data table, and must
  have columns named 'sex', 'age', and 'q' (probability of death).

- norms:

  `[data frame]` or `[tibble]` or `[data table]`

  The HRQoL data that will be used in the QALY loss calculation.

  The default value for this argument is a call to a function -
  `package_norms(country)` - which returns HRQoL norms stored by the
  package.

  We can see that this default depends on the user having specified
  values for arguments `country` . Alternatively, the user can specify
  values for `country` within the `package_norms` arguments. See
  examples & the documentation for `package_norms` for more details.

  Additionally, users can supply their own norms to the function, if
  they want to perform the calculation with something other than the
  HRQoL data stored by the package. The norms can be given in the form
  of a data frame, tibble, or data table, and must have columns named
  'lower' (lower bound of age band), 'upper' (upper bound of age band),
  'sex', and 'avg_hrqol' (utility score).

- smr:

  `[numeric]`

  A standardised mortality ratio.

  Allows the user to make crude adjustments to packaged life table data,
  which represent average life expectancy at country level.

  `smr` defaults to 1.

  If it is greater than/ less than 1 - for example 1.05/0.95 - the
  calculation will estimate QALY loss due to death for a population
  assumed to have a mortality rate 5% greater/lower than average
  mortality rate in the selected country.

- qcm:

  `[numeric]`

  Allows the user to make crude adjustments to the packaged utility
  data, which represent average health-related quality of life at
  country level.

  `qcm` defaults to 1.

  If it is greater than/ less than 1 - for example 1.05/0.95 - the
  calculation will estimate QALY loss due to death for a population
  assumed experience health-related quality of life 5% greater/lower
  than the average health related quality of life in the selected
  country.

- collapse_age:

  `[boolean]` or `[data frame]` or `[tibble]` or `[data table]`

  Allows users to control how function outputs are grouped by age.

  If `FALSE` (default), the function outputs an estimate of QALY loss
  due to death for every year of age.

  Alternatively, if the user passes a data frame, tibble or data table
  that describe a set of age groups to `collapse_age`, the function will
  return the average QALY loss due to death for those age groups. The
  data frame, tibble, or data table must have two columns named 'lower'
  and 'upper', indicating the lower and upper bounds of the desired age
  groups. See the examples for more details.

  If `collapse_age` is set to `TRUE`, the function outputs a single
  average estimate of QALY loss due to death, aggregated across all
  ages - this is equivalent to supplying a single age group that
  encompasses all ages.

- collapse_sex:

  `[boolean]`

  Allows users to control whether or not the function outputs
  sex-specific estimates.

  If `FALSE` (default), outputted estimates are sex-specific. If
  `collapse_sex` is set to `TRUE`, then the function outputs estimates
  aggregated across sex.

- cohort:

  `[data frame]` or `[tibble]` or `[data table]`

  The cohort data that will be used to calculate weighted averages iff
  the user chooses to have the function output grouped estimates, as in
  that case we need to assume a distribution for the population.

  The default value for this argument is a call to a function -
  `package_cohort(country, year)` - which returns cohort data stored by
  the package.

  We can see that this default depends on the user having specified
  values for arguments `country` and `year`. Alternatively, the user can
  specify values for `country` and `year` within the `package_cohort`
  arguments. See examples & the documentation for `package_lt` for more
  details.

  Additionally, users can supply their own cohort data to the function,
  specifying a population distribution across age and sex, if they want
  to perform the calculation with something other than the cohort data
  stored by the package. Cohort data can be given in the form of a data
  frame, tibble, or data table, and must have columns named 'sex',
  'age', and 'count'.

## Value

A data frame. The data frame will have column `QALE` (quality adjusted
life years). Additionally, depending on how the user chooses to group
function outputs, the data frame may additional columns `sex`, `age`,
and `lower`/`upper` (representing the lower and upper bounds of age
groups).

## Examples

``` r
#See documentation for function calculate_dQALY for more examples
calculate_QALE(country = "England", year = 2018)
#>     age    sex       QALE
#> 1     0 female 68.2347237
#> 2     0   male 68.1606887
#> 3     1 female 67.6000313
#> 4     1   male 67.5373168
#> 5     2 female 66.7366084
#> 6     2   male 66.6358892
#> 7     3 female 65.8670955
#> 8     3   male 65.7268905
#> 9     4 female 64.9957699
#> 10    4   male 64.8157443
#> 11    5 female 64.1220955
#> 12    5   male 63.9040519
#> 13    6 female 63.2497638
#> 14    6   male 62.9919529
#> 15    7 female 62.3768519
#> 16    7   male 62.0793312
#> 17    8 female 61.5026922
#> 18    8   male 61.1659530
#> 19    9 female 60.6286616
#> 20    9   male 60.2518992
#> 21   10 female 59.7540927
#> 22   10   male 59.3376664
#> 23   11 female 58.8799484
#> 24   11   male 58.4239649
#> 25   12 female 58.0056304
#> 26   12   male 57.5107184
#> 27   13 female 57.1309119
#> 28   13   male 56.5987665
#> 29   14 female 56.2574476
#> 30   14   male 55.6877849
#> 31   15 female 55.3845275
#> 32   15   male 54.7760817
#> 33   16 female 54.5118578
#> 34   16   male 53.8671541
#> 35   17 female 53.6418076
#> 36   17   male 52.9608531
#> 37   18 female 52.7722682
#> 38   18   male 52.0589236
#> 39   19 female 51.9272628
#> 40   19   male 51.1490530
#> 41   20 female 51.0810496
#> 42   20   male 50.2400957
#> 43   21 female 50.2308645
#> 44   21   male 49.3711542
#> 45   22 female 49.3815278
#> 46   22   male 48.5016775
#> 47   23 female 48.5325650
#> 48   23   male 47.6309472
#> 49   24 female 47.6826101
#> 50   24   male 46.7595119
#> 51   25 female 46.8334881
#> 52   25   male 45.8900242
#> 53   26 female 45.9755337
#> 54   26   male 45.0206228
#> 55   27 female 45.1180585
#> 56   27   male 44.1511332
#> 57   28 female 44.2608133
#> 58   28   male 43.2825461
#> 59   29 female 43.4047021
#> 60   29   male 42.4157501
#> 61   30 female 42.5481670
#> 62   30   male 41.5496022
#> 63   31 female 41.6936170
#> 64   31   male 40.6643744
#> 65   32 female 40.8391866
#> 66   32   male 39.7807200
#> 67   33 female 39.9870424
#> 68   33   male 38.8956283
#> 69   34 female 39.1352552
#> 70   34   male 38.0139831
#> 71   35 female 38.2859639
#> 72   35   male 37.1326639
#> 73   36 female 37.4524188
#> 74   36   male 36.3052251
#> 75   37 female 36.6195353
#> 76   37   male 35.4798961
#> 77   38 female 35.7919752
#> 78   38   male 34.6592155
#> 79   39 female 34.9622168
#> 80   39   male 33.8363088
#> 81   40 female 34.1342068
#> 82   40   male 33.0161218
#> 83   41 female 33.3155350
#> 84   41   male 32.1904514
#> 85   42 female 32.4990332
#> 86   42   male 31.3668235
#> 87   43 female 31.6853984
#> 88   43   male 30.5462230
#> 89   44 female 30.8731357
#> 90   44   male 29.7293955
#> 91   45 female 30.0648797
#> 92   45   male 28.9143351
#> 93   46 female 29.2986799
#> 94   46   male 28.1553239
#> 95   47 female 28.5352771
#> 96   47   male 27.3968648
#> 97   48 female 27.7741915
#> 98   48   male 26.6437462
#> 99   49 female 27.0160103
#> 100  49   male 25.8922917
#> 101  50 female 26.2598698
#> 102  50   male 25.1470937
#> 103  51 female 25.5153311
#> 104  51   male 24.3904560
#> 105  52 female 24.7740460
#> 106  52   male 23.6377128
#> 107  53 female 24.0361320
#> 108  53   male 22.8885998
#> 109  54 female 23.2991785
#> 110  54   male 22.1427752
#> 111  55 female 22.5645579
#> 112  55   male 21.4005075
#> 113  56 female 21.8419157
#> 114  56   male 20.6892772
#> 115  57 female 21.1237800
#> 116  57   male 19.9856125
#> 117  58 female 20.4092583
#> 118  58   male 19.2880725
#> 119  59 female 19.7001279
#> 120  59   male 18.5960971
#> 121  60 female 18.9945020
#> 122  60   male 17.9093789
#> 123  61 female 18.3093713
#> 124  61   male 17.2365299
#> 125  62 female 17.6291686
#> 126  62   male 16.5698096
#> 127  63 female 16.9593866
#> 128  63   male 15.9134812
#> 129  64 female 16.2919900
#> 130  64   male 15.2659177
#> 131  65 female 15.6289415
#> 132  65   male 14.6242643
#> 133  66 female 14.9728924
#> 134  66   male 13.9981235
#> 135  67 female 14.3203203
#> 136  67   male 13.3799819
#> 137  68 female 13.6732591
#> 138  68   male 12.7692797
#> 139  69 female 13.0342211
#> 140  69   male 12.1669563
#> 141  70 female 12.3988351
#> 142  70   male 11.5735409
#> 143  71 female 11.7611961
#> 144  71   male 10.9768670
#> 145  72 female 11.1265922
#> 146  72   male 10.3916451
#> 147  73 female 10.5046472
#> 148  73   male  9.8135672
#> 149  74 female  9.8957760
#> 150  74   male  9.2558591
#> 151  75 female  9.2922221
#> 152  75   male  8.7043221
#> 153  76 female  8.7521692
#> 154  76   male  8.1785832
#> 155  77 female  8.2240021
#> 156  77   male  7.6693075
#> 157  78 female  7.7088389
#> 158  78   male  7.1703567
#> 159  79 female  7.2068422
#> 160  79   male  6.6866698
#> 161  80 female  6.7161790
#> 162  80   male  6.2116938
#> 163  81 female  6.2565381
#> 164  81   male  5.7736064
#> 165  82 female  5.8093940
#> 166  82   male  5.3478023
#> 167  83 female  5.3761694
#> 168  83   male  4.9310241
#> 169  84 female  4.9626553
#> 170  84   male  4.5294546
#> 171  85 female  4.5630480
#> 172  85   male  4.1446534
#> 173  86 female  4.2254772
#> 174  86   male  3.8106127
#> 175  87 female  3.9095837
#> 176  87   male  3.4953522
#> 177  88 female  3.6115860
#> 178  88   male  3.1935919
#> 179  89 female  3.3381657
#> 180  89   male  2.9089786
#> 181  90 female  3.0786541
#> 182  90   male  2.6379287
#> 183  91 female  2.8352184
#> 184  91   male  2.4306014
#> 185  92 female  2.6110427
#> 186  92   male  2.2438227
#> 187  93 female  2.4051538
#> 188  93   male  2.0695716
#> 189  94 female  2.2131721
#> 190  94   male  1.9076130
#> 191  95 female  2.0393701
#> 192  95   male  1.7593974
#> 193  96 female  1.8845194
#> 194  96   male  1.6276133
#> 195  97 female  1.7466259
#> 196  97   male  1.5189099
#> 197  98 female  1.6057259
#> 198  98   male  1.4010186
#> 199  99 female  1.4807129
#> 200  99   male  1.2743812
#> 201 100 female  1.3527704
#> 202 100   male  1.1849488
#> 203 101 female  1.2479732
#> 204 101   male  1.0992156
#> 205 102 female  1.1510332
#> 206 102   male  1.0197499
#> 207 103 female  1.0615670
#> 208 103   male  0.9462449
#> 209 104 female  0.9791982
#> 210 104   male  0.8784022
#> 211 105 female  0.9035587
#> 212 105   male  0.8159330
#> 213 106 female  0.8342914
#> 214 106   male  0.7585586
#> 215 107 female  0.7710511
#> 216 107   male  0.7060116
#> 217 108 female  0.7135059
#> 218 108   male  0.6580355
#> 219 109 female  0.6613378
#> 220 109   male  0.6143853
#> 221 110 female  0.6142429
#> 222 110   male  0.5748273
#> 223 111 female  0.5719316
#> 224 111   male  0.5391382
#> 225 112 female  0.5341274
#> 226 112   male  0.5071045
#> 227 113 female  0.5005655
#> 228 113   male  0.4785213
#> 229 114 female  0.4709915
#> 230 114   male  0.4531902
#> 231 115 female  0.4451578
#> 232 115   male  0.4309180
#> 233 116 female  0.4228203
#> 234 116   male  0.4115131
#> 235 117 female  0.4037271
#> 236 117   male  0.3947759
#> 237 118 female  0.3875291
#> 238 118   male  0.3804111
#> 239 119 female  0.3725418
#> 240 119   male  0.3667789
#> 241 120 female  0.3330000
#> 242 120   male  0.3280000
```
