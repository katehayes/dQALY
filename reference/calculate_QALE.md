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
#>        sex age       QALE
#> 1   female   0 68.2347237
#> 2     male   0 68.1606887
#> 3   female   1 67.6000313
#> 4     male   1 67.5373168
#> 5   female   2 66.7366084
#> 6     male   2 66.6358892
#> 7   female   3 65.8670955
#> 8     male   3 65.7268905
#> 9   female   4 64.9957699
#> 10    male   4 64.8157443
#> 11  female   5 64.1220955
#> 12    male   5 63.9040519
#> 13  female   6 63.2497638
#> 14    male   6 62.9919529
#> 15  female   7 62.3768519
#> 16    male   7 62.0793312
#> 17  female   8 61.5026922
#> 18    male   8 61.1659530
#> 19  female   9 60.6286616
#> 20    male   9 60.2518992
#> 21  female  10 59.7540927
#> 22    male  10 59.3376664
#> 23  female  11 58.8799484
#> 24    male  11 58.4239649
#> 25  female  12 58.0056304
#> 26    male  12 57.5107184
#> 27  female  13 57.1309119
#> 28    male  13 56.5987665
#> 29  female  14 56.2574476
#> 30    male  14 55.6877849
#> 31  female  15 55.3845275
#> 32    male  15 54.7760817
#> 33  female  16 54.5118578
#> 34    male  16 53.8671541
#> 35  female  17 53.6418076
#> 36    male  17 52.9608531
#> 37  female  18 52.7722682
#> 38    male  18 52.0589236
#> 39  female  19 51.9272628
#> 40    male  19 51.1490530
#> 41  female  20 51.0810496
#> 42    male  20 50.2400957
#> 43  female  21 50.2308645
#> 44    male  21 49.3711542
#> 45  female  22 49.3815278
#> 46    male  22 48.5016775
#> 47  female  23 48.5325650
#> 48    male  23 47.6309472
#> 49  female  24 47.6826101
#> 50    male  24 46.7595119
#> 51  female  25 46.8334881
#> 52    male  25 45.8900242
#> 53  female  26 45.9755337
#> 54    male  26 45.0206228
#> 55  female  27 45.1180585
#> 56    male  27 44.1511332
#> 57  female  28 44.2608133
#> 58    male  28 43.2825461
#> 59  female  29 43.4047021
#> 60    male  29 42.4157501
#> 61  female  30 42.5481670
#> 62    male  30 41.5496022
#> 63  female  31 41.6936170
#> 64    male  31 40.6643744
#> 65  female  32 40.8391866
#> 66    male  32 39.7807200
#> 67  female  33 39.9870424
#> 68    male  33 38.8956283
#> 69  female  34 39.1352552
#> 70    male  34 38.0139831
#> 71  female  35 38.2859639
#> 72    male  35 37.1326639
#> 73  female  36 37.4524188
#> 74    male  36 36.3052251
#> 75  female  37 36.6195353
#> 76    male  37 35.4798961
#> 77  female  38 35.7919752
#> 78    male  38 34.6592155
#> 79  female  39 34.9622168
#> 80    male  39 33.8363088
#> 81  female  40 34.1342068
#> 82    male  40 33.0161218
#> 83  female  41 33.3155350
#> 84    male  41 32.1904514
#> 85  female  42 32.4990332
#> 86    male  42 31.3668235
#> 87  female  43 31.6853984
#> 88    male  43 30.5462230
#> 89  female  44 30.8731357
#> 90    male  44 29.7293955
#> 91  female  45 30.0648797
#> 92    male  45 28.9143351
#> 93  female  46 29.2986799
#> 94    male  46 28.1553239
#> 95  female  47 28.5352771
#> 96    male  47 27.3968648
#> 97  female  48 27.7741915
#> 98    male  48 26.6437462
#> 99  female  49 27.0160103
#> 100   male  49 25.8922917
#> 101 female  50 26.2598698
#> 102   male  50 25.1470937
#> 103 female  51 25.5153311
#> 104   male  51 24.3904560
#> 105 female  52 24.7740460
#> 106   male  52 23.6377128
#> 107 female  53 24.0361320
#> 108   male  53 22.8885998
#> 109 female  54 23.2991785
#> 110   male  54 22.1427752
#> 111 female  55 22.5645579
#> 112   male  55 21.4005075
#> 113 female  56 21.8419157
#> 114   male  56 20.6892772
#> 115 female  57 21.1237800
#> 116   male  57 19.9856125
#> 117 female  58 20.4092583
#> 118   male  58 19.2880725
#> 119 female  59 19.7001279
#> 120   male  59 18.5960971
#> 121 female  60 18.9945020
#> 122   male  60 17.9093789
#> 123 female  61 18.3093713
#> 124   male  61 17.2365299
#> 125 female  62 17.6291686
#> 126   male  62 16.5698096
#> 127 female  63 16.9593866
#> 128   male  63 15.9134812
#> 129 female  64 16.2919900
#> 130   male  64 15.2659177
#> 131 female  65 15.6289415
#> 132   male  65 14.6242643
#> 133 female  66 14.9728924
#> 134   male  66 13.9981235
#> 135 female  67 14.3203203
#> 136   male  67 13.3799819
#> 137 female  68 13.6732591
#> 138   male  68 12.7692797
#> 139 female  69 13.0342211
#> 140   male  69 12.1669563
#> 141 female  70 12.3988351
#> 142   male  70 11.5735409
#> 143 female  71 11.7611961
#> 144   male  71 10.9768670
#> 145 female  72 11.1265922
#> 146   male  72 10.3916451
#> 147 female  73 10.5046472
#> 148   male  73  9.8135672
#> 149 female  74  9.8957760
#> 150   male  74  9.2558591
#> 151 female  75  9.2922221
#> 152   male  75  8.7043221
#> 153 female  76  8.7521692
#> 154   male  76  8.1785832
#> 155 female  77  8.2240021
#> 156   male  77  7.6693075
#> 157 female  78  7.7088389
#> 158   male  78  7.1703567
#> 159 female  79  7.2068422
#> 160   male  79  6.6866698
#> 161 female  80  6.7161790
#> 162   male  80  6.2116938
#> 163 female  81  6.2565381
#> 164   male  81  5.7736064
#> 165 female  82  5.8093940
#> 166   male  82  5.3478023
#> 167 female  83  5.3761694
#> 168   male  83  4.9310241
#> 169 female  84  4.9626553
#> 170   male  84  4.5294546
#> 171 female  85  4.5630480
#> 172   male  85  4.1446534
#> 173 female  86  4.2254772
#> 174   male  86  3.8106127
#> 175 female  87  3.9095837
#> 176   male  87  3.4953522
#> 177 female  88  3.6115860
#> 178   male  88  3.1935919
#> 179 female  89  3.3381657
#> 180   male  89  2.9089786
#> 181 female  90  3.0786541
#> 182   male  90  2.6379287
#> 183 female  91  2.8352184
#> 184   male  91  2.4306014
#> 185 female  92  2.6110427
#> 186   male  92  2.2438227
#> 187 female  93  2.4051538
#> 188   male  93  2.0695716
#> 189 female  94  2.2131721
#> 190   male  94  1.9076130
#> 191 female  95  2.0393701
#> 192   male  95  1.7593974
#> 193 female  96  1.8845194
#> 194   male  96  1.6276133
#> 195 female  97  1.7466259
#> 196   male  97  1.5189099
#> 197 female  98  1.6057259
#> 198   male  98  1.4010186
#> 199 female  99  1.4807129
#> 200   male  99  1.2743812
#> 201 female 100  1.3527704
#> 202   male 100  1.1849488
#> 203 female 101  1.2479732
#> 204   male 101  1.0992156
#> 205 female 102  1.1510332
#> 206   male 102  1.0197499
#> 207 female 103  1.0615670
#> 208   male 103  0.9462449
#> 209 female 104  0.9791982
#> 210   male 104  0.8784022
#> 211 female 105  0.9035587
#> 212   male 105  0.8159330
#> 213 female 106  0.8342914
#> 214   male 106  0.7585586
#> 215 female 107  0.7710511
#> 216   male 107  0.7060116
#> 217 female 108  0.7135059
#> 218   male 108  0.6580355
#> 219 female 109  0.6613378
#> 220   male 109  0.6143853
#> 221 female 110  0.6142429
#> 222   male 110  0.5748273
#> 223 female 111  0.5719316
#> 224   male 111  0.5391382
#> 225 female 112  0.5341274
#> 226   male 112  0.5071045
#> 227 female 113  0.5005655
#> 228   male 113  0.4785213
#> 229 female 114  0.4709915
#> 230   male 114  0.4531902
#> 231 female 115  0.4451578
#> 232   male 115  0.4309180
#> 233 female 116  0.4228203
#> 234   male 116  0.4115131
#> 235 female 117  0.4037271
#> 236   male 117  0.3947759
#> 237 female 118  0.3875291
#> 238   male 118  0.3804111
#> 239 female 119  0.3725418
#> 240   male 119  0.3667789
#> 241 female 120  0.3330000
#> 242   male 120  0.3280000
```
