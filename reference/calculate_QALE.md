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
#> 1     0 female 68.1469693
#> 2     0   male 68.0697494
#> 3     1 female 67.5103117
#> 4     1   male 67.4415081
#> 5     2 female 66.6480973
#> 6     2   male 66.5411023
#> 7     3 female 65.7758646
#> 8     3   male 65.6314958
#> 9     4 female 64.9045884
#> 10    4   male 64.7202549
#> 11    5 female 64.0293864
#> 12    5   male 63.8096393
#> 13    6 female 63.1583312
#> 14    6   male 62.8969296
#> 15    7 female 62.2849728
#> 16    7   male 61.9838501
#> 17    8 female 61.4104549
#> 18    8   male 61.0708709
#> 19    9 female 60.5362902
#> 20    9   male 60.1568412
#> 21   10 female 59.6628219
#> 22   10   male 59.2415875
#> 23   11 female 58.7894654
#> 24   11   male 58.3286491
#> 25   12 female 57.9150950
#> 26   12   male 57.4166392
#> 27   13 female 57.0398368
#> 28   13   male 56.5043241
#> 29   14 female 56.1662294
#> 30   14   male 55.5925010
#> 31   15 female 55.2929777
#> 32   15   male 54.6821822
#> 33   16 female 54.4212428
#> 34   16   male 53.7748608
#> 35   17 female 53.5507743
#> 36   17   male 52.8688009
#> 37   18 female 52.6808007
#> 38   18   male 51.9685581
#> 39   19 female 51.8349868
#> 40   19   male 51.0618122
#> 41   20 female 50.9900880
#> 42   20   male 50.1538162
#> 43   21 female 50.1408885
#> 44   21   male 49.2849507
#> 45   22 female 49.2923152
#> 46   22   male 48.4171517
#> 47   23 female 48.4442971
#> 48   23   male 47.5474177
#> 49   24 female 47.5935186
#> 50   24   male 46.6772154
#> 51   25 female 46.7445290
#> 52   25   male 45.8088041
#> 53   26 female 45.8891481
#> 54   26   male 44.9381762
#> 55   27 female 45.0312509
#> 56   27   male 44.0689735
#> 57   28 female 44.1738624
#> 58   28   male 43.2008041
#> 59   29 female 43.3186534
#> 60   29   male 42.3343396
#> 61   30 female 42.4626942
#> 62   30   male 41.4691381
#> 63   31 female 41.6089349
#> 64   31   male 40.5844148
#> 65   32 female 40.7535187
#> 66   32   male 39.7038290
#> 67   33 female 39.9022871
#> 68   33   male 38.8167412
#> 69   34 female 39.0495545
#> 70   34   male 37.9373063
#> 71   35 female 38.2019900
#> 72   35   male 37.0573377
#> 73   36 female 37.3684941
#> 74   36   male 36.2306405
#> 75   37 female 36.5352632
#> 76   37   male 35.4049714
#> 77   38 female 35.7072075
#> 78   38   male 34.5854414
#> 79   39 female 34.8785499
#> 80   39   male 33.7630954
#> 81   40 female 34.0513947
#> 82   40   male 32.9418588
#> 83   41 female 33.2286413
#> 84   41   male 32.1171585
#> 85   42 female 32.4110296
#> 86   42   male 31.2922401
#> 87   43 female 31.5970208
#> 88   43   male 30.4751692
#> 89   44 female 30.7860155
#> 90   44   male 29.6621103
#> 91   45 female 29.9782694
#> 92   45   male 28.8493370
#> 93   46 female 29.2128698
#> 94   46   male 28.0923046
#> 95   47 female 28.4502304
#> 96   47   male 27.3372389
#> 97   48 female 27.6909872
#> 98   48   male 26.5839843
#> 99   49 female 26.9360429
#> 100  49   male 25.8337927
#> 101  50 female 26.1817636
#> 102  50   male 25.0889735
#> 103  51 female 25.4360822
#> 104  51   male 24.3324670
#> 105  52 female 24.6934612
#> 106  52   male 23.5802690
#> 107  53 female 23.9537813
#> 108  53   male 22.8331908
#> 109  54 female 23.2181566
#> 110  54   male 22.0915938
#> 111  55 female 22.4817263
#> 112  55   male 21.3497502
#> 113  56 female 21.7599132
#> 114  56   male 20.6400679
#> 115  57 female 21.0432134
#> 116  57   male 19.9330506
#> 117  58 female 20.3317043
#> 118  58   male 19.2387258
#> 119  59 female 19.6268565
#> 120  59   male 18.5501027
#> 121  60 female 18.9229343
#> 122  60   male 17.8606242
#> 123  61 female 18.2395355
#> 124  61   male 17.1863372
#> 125  62 female 17.5601937
#> 126  62   male 16.5221245
#> 127  63 female 16.8900494
#> 128  63   male 15.8648761
#> 129  64 female 16.2242050
#> 130  64   male 15.2195187
#> 131  65 female 15.5613223
#> 132  65   male 14.5756782
#> 133  66 female 14.9080458
#> 134  66   male 13.9498817
#> 135  67 female 14.2574577
#> 136  67   male 13.3316329
#> 137  68 female 13.6087430
#> 138  68   male 12.7198828
#> 139  69 female 12.9717750
#> 140  69   male 12.1214632
#> 141  70 female 12.3357228
#> 142  70   male 11.5327616
#> 143  71 female 11.7018951
#> 144  71   male 10.9424697
#> 145  72 female 11.0699934
#> 146  72   male 10.3606638
#> 147  73 female 10.4469948
#> 148  73   male  9.7774381
#> 149  74 female  9.8342299
#> 150  74   male  9.2239136
#> 151  75 female  9.2348724
#> 152  75   male  8.6739715
#> 153  76 female  8.6980523
#> 154  76   male  8.1496129
#> 155  77 female  8.1679931
#> 156  77   male  7.6348649
#> 157  78 female  7.6571090
#> 158  78   male  7.1430028
#> 159  79 female  7.1552593
#> 160  79   male  6.6590395
#> 161  80 female  6.6647677
#> 162  80   male  6.1852238
#> 163  81 female  6.2024539
#> 164  81   male  5.7467429
#> 165  82 female  5.7603836
#> 166  82   male  5.3236871
#> 167  83 female  5.3262640
#> 168  83   male  4.9050638
#> 169  84 female  4.9171001
#> 170  84   male  4.5025516
#> 171  85 female  4.5119357
#> 172  85   male  4.1139283
#> 173  86 female  4.1724726
#> 174  86   male  3.7773820
#> 175  87 female  3.8569058
#> 176  87   male  3.4677340
#> 177  88 female  3.5667194
#> 178  88   male  3.1736085
#> 179  89 female  3.2984818
#> 180  89   male  2.8932005
#> 181  90 female  3.0379574
#> 182  90   male  2.6284733
#> 183  91 female  2.7999588
#> 184  91   male  2.4233183
#> 185  92 female  2.5800945
#> 186  92   male  2.2303144
#> 187  93 female  2.3799884
#> 188  93   male  2.0627838
#> 189  94 female  2.1990546
#> 190  94   male  1.8985373
#> 191  95 female  2.0378772
#> 192  95   male  1.7557222
#> 193  96 female  1.8871241
#> 194  96   male  1.6141030
#> 195  97 female  1.7452839
#> 196  97   male  1.5119982
#> 197  98 female  1.6402305
#> 198  98   male  1.4198364
#> 199  99 female  1.5271546
#> 200  99   male  1.3057778
#> 201 100 female  1.3739601
#> 202 100   male  1.1840309
#> 203 101 female  1.2703290
#> 204 101   male  1.0987181
#> 205 102 female  1.1742463
#> 206 102   male  1.0196199
#> 207 103 female  1.0853512
#> 208 103   male  0.9464327
#> 209 104 female  1.0032891
#> 210 104   male  0.8788614
#> 211 105 female  0.9277137
#> 212 105   male  0.8166203
#> 213 106 female  0.8582884
#> 214 106   male  0.7594338
#> 215 107 female  0.7946874
#> 216 107   male  0.7070372
#> 217 108 female  0.7365972
#> 218 108   male  0.6591771
#> 219 109 female  0.6837173
#> 220 109   male  0.6156110
#> 221 110 female  0.6357600
#> 222 110   male  0.5761076
#> 223 111 female  0.5924508
#> 224 111   male  0.5404461
#> 225 112 female  0.5535280
#> 226 112   male  0.5084153
#> 227 113 female  0.5187415
#> 228 113   male  0.4798124
#> 229 114 female  0.4878511
#> 230 114   male  0.4544415
#> 231 115 female  0.4606249
#> 232 115   male  0.4321114
#> 233 116 female  0.4368345
#> 234 116   male  0.4126328
#> 235 117 female  0.4162379
#> 236 117   male  0.3958082
#> 237 118 female  0.3984320
#> 238 118   male  0.3813392
#> 239 119 female  0.3810865
#> 240 119   male  0.3675323
#> 241 120 female  0.3330000
#> 242 120   male  0.3280000
```
