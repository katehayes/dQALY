# Calculating QALY loss on death

Calculating QALY loss on death

## Usage

``` r
calculate_dQALY(
  country = NULL,
  year = NULL,
  life_table = package_lt(country, year),
  norms = package_norms(country),
  r = 0.035,
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

- r:

  `[numeric]` or `[function]`

  Represents the discount rate that will be used in the calculation.
  Defaults to 0.035 - the NICE reference case discount rate of 3.5%

  If `r` is numeric, it must be a numeric scalar between 0 and 1.

  Alternatively, to allow the user to specify a discount rate that
  varies across time, `r` can be a vectorised function.

  The function must take as an argument an integer greater than 0 - for
  example 'x' - and return and return the desired discount rate 'x'
  years into the future.

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

A data frame. The data frame will have column `dQALY`, containing
estimates of QALY loss due to death. Additionally, depending on how the
user chooses to group function outputs, the data frame may additional
columns `sex`, `age`, and `lower`/`upper` (representing the lower and
upper bounds of age groups).

## Examples

``` r
#Output a table of dQALY values for all ages/genders, minimally specifying year & country
calculate_dQALY(country = "United Kingdom", year = 2019)
#>     age    sex      dQALY
#> 1     0 female 25.2201968
#> 2     0   male 24.9345497
#> 3     1 female 25.2194495
#> 4     1   male 24.9435579
#> 5     2 female 25.1353787
#> 6     2   male 24.8495090
#> 7     3 female 25.0460465
#> 8     3   male 24.7498746
#> 9     4 female 24.9523020
#> 10    4   male 24.6452308
#> 11    5 female 24.8545065
#> 12    5   male 24.5366655
#> 13    6 female 24.7535334
#> 14    6   male 24.4245416
#> 15    7 female 24.6492693
#> 16    7   male 24.3089801
#> 17    8 female 24.5405953
#> 18    8   male 24.1881282
#> 19    9 female 24.4278619
#> 20    9   male 24.0630401
#> 21   10 female 24.3109289
#> 22   10   male 23.9335675
#> 23   11 female 24.1906389
#> 24   11   male 23.8000425
#> 25   12 female 24.0656388
#> 26   12   male 23.6620758
#> 27   13 female 23.9360131
#> 28   13   male 23.5199889
#> 29   14 female 23.8030596
#> 30   14   male 23.3736287
#> 31   15 female 23.6659232
#> 32   15   male 23.2214134
#> 33   16 female 23.5239714
#> 34   16   male 23.0645597
#> 35   17 female 23.3775125
#> 36   17   male 22.9038308
#> 37   18 female 23.2266193
#> 38   18   male 22.7392994
#> 39   19 female 23.0725400
#> 40   19   male 22.5708045
#> 41   20 female 22.9116241
#> 42   20   male 22.3979495
#> 43   21 female 22.7450444
#> 44   21   male 22.2214637
#> 45   22 female 22.5730630
#> 46   22   male 22.0384750
#> 47   23 female 22.3959401
#> 48   23   male 21.8489794
#> 49   24 female 22.2118912
#> 50   24   male 21.6520814
#> 51   25 female 22.0220339
#> 52   25   male 21.4497235
#> 53   26 female 21.8353872
#> 54   26   male 21.2511665
#> 55   27 female 21.6432697
#> 56   27   male 21.0453194
#> 57   28 female 21.4454689
#> 58   28   male 20.8334186
#> 59   29 female 21.2400258
#> 60   29   male 20.6148005
#> 61   30 female 21.0284038
#> 62   30   male 20.3894157
#> 63   31 female 20.8103629
#> 64   31   male 20.1572056
#> 65   32 female 20.5850216
#> 66   32   male 19.9172854
#> 67   33 female 20.3519037
#> 68   33   male 19.6691623
#> 69   34 female 20.1113466
#> 70   34   male 19.4143224
#> 71   35 female 19.8644908
#> 72   35   male 19.1495219
#> 73   36 female 19.6293520
#> 74   36   male 18.8992006
#> 75   37 female 19.3866386
#> 76   37   male 18.6394508
#> 77   38 female 19.1388066
#> 78   38   male 18.3746531
#> 79   39 female 18.8813236
#> 80   39   male 18.1005997
#> 81   40 female 18.6165374
#> 82   40   male 17.8180400
#> 83   41 female 18.3443202
#> 84   41   male 17.5275178
#> 85   42 female 18.0628607
#> 86   42   male 17.2270716
#> 87   43 female 17.7734508
#> 88   43   male 16.9178786
#> 89   44 female 17.4739378
#> 90   44   male 16.6002179
#> 91   45 female 17.1669423
#> 92   45   male 16.2751738
#> 93   46 female 16.9136996
#> 94   46   male 16.0145075
#> 95   47 female 16.6537690
#> 96   47   male 15.7461783
#> 97   48 female 16.3853114
#> 98   48   male 15.4704632
#> 99   49 female 16.1089736
#> 100  49   male 15.1862069
#> 101  50 female 15.8239096
#> 102  50   male 14.8957750
#> 103  51 female 15.5329386
#> 104  51   male 14.5996561
#> 105  52 female 15.2344146
#> 106  52   male 14.2952039
#> 107  53 female 14.9260827
#> 108  53   male 13.9812435
#> 109  54 female 14.6076683
#> 110  54   male 13.6599799
#> 111  55 female 14.2824066
#> 112  55   male 13.3306211
#> 113  56 female 13.9901206
#> 114  56   male 13.0536637
#> 115  57 female 13.6907233
#> 116  57   male 12.7751332
#> 117  58 female 13.3841769
#> 118  58   male 12.4877222
#> 119  59 female 13.0695982
#> 120  59   male 12.1958689
#> 121  60 female 12.7491193
#> 122  60   male 11.9001509
#> 123  61 female 12.4209009
#> 124  61   male 11.5981998
#> 125  62 female 12.0841210
#> 126  62   male 11.2916506
#> 127  63 female 11.7465694
#> 128  63   male 10.9845269
#> 129  64 female 11.3957804
#> 130  64   male 10.6703392
#> 131  65 female 11.0381382
#> 132  65   male 10.3520386
#> 133  66 female 10.7046939
#> 134  66   male 10.0316396
#> 135  67 female 10.3614665
#> 136  67   male  9.7067317
#> 137  68 female 10.0122048
#> 138  68   male  9.3774658
#> 139  69 female  9.6570319
#> 140  69   male  9.0439681
#> 141  70 female  9.2950774
#> 142  70   male  8.7082368
#> 143  71 female  8.9286658
#> 144  71   male  8.3630656
#> 145  72 female  8.5517472
#> 146  72   male  8.0206571
#> 147  73 female  8.1714270
#> 148  73   male  7.6700049
#> 149  74 female  7.7863309
#> 150  74   male  7.3156535
#> 151  75 female  7.3974600
#> 152  75   male  6.9651553
#> 153  76 female  7.0763622
#> 154  76   male  6.6521060
#> 155  77 female  6.7535405
#> 156  77   male  6.3335929
#> 157  78 female  6.4331890
#> 158  78   male  6.0154103
#> 159  79 female  6.1151025
#> 160  79   male  5.7079492
#> 161  80 female  5.8067808
#> 162  80   male  5.4070488
#> 163  81 female  5.4988429
#> 164  81   male  5.1133837
#> 165  82 female  5.1920219
#> 166  82   male  4.8186746
#> 167  83 female  4.8907316
#> 168  83   male  4.5301025
#> 169  84 female  4.5974218
#> 170  84   male  4.2529005
#> 171  85 female  4.3139769
#> 172  85   male  3.9902609
#> 173  86 female  4.0385381
#> 174  86   male  3.7339263
#> 175  87 female  3.7782854
#> 176  87   male  3.4884047
#> 177  88 female  3.5278451
#> 178  88   male  3.2489725
#> 179  89 female  3.2887341
#> 180  89   male  3.0256335
#> 181  90 female  3.0611909
#> 182  90   male  2.8174898
#> 183  91 female  2.8505943
#> 184  91   male  2.6146384
#> 185  92 female  2.6495050
#> 186  92   male  2.4320293
#> 187  93 female  2.4648856
#> 188  93   male  2.2588318
#> 189  94 female  2.2843605
#> 190  94   male  2.1002289
#> 191  95 female  2.1218409
#> 192  95   male  1.9674125
#> 193  96 female  1.9713630
#> 194  96   male  1.8348089
#> 195  97 female  1.8319667
#> 196  97   male  1.7127394
#> 197  98 female  1.7024866
#> 198  98   male  1.5999192
#> 199  99 female  1.5811976
#> 200  99   male  1.4944831
#> 201 100 female  1.4654274
#> 202 100   male  1.3935113
#> 203 101 female  1.3571087
#> 204 101   male  1.2988387
#> 205 102 female  1.2560298
#> 206 102   male  1.2102666
#> 207 103 female  1.1619628
#> 208 103   male  1.1275895
#> 209 104 female  1.0746674
#> 210 104   male  1.0505970
#> 211 105 female  0.9938941
#> 212 105   male  0.9790758
#> 213 106 female  0.9193875
#> 214 106   male  0.9128116
#> 215 107 female  0.8508886
#> 216 107   male  0.8515909
#> 217 108 female  0.7881381
#> 218 108   male  0.7952019
#> 219 109 female  0.7308779
#> 220 109   male  0.7434361
#> 221 110 female  0.6788534
#> 222 110   male  0.6960889
#> 223 111 female  0.6318144
#> 224 111   male  0.6529601
#> 225 112 female  0.5895157
#> 226 112   male  0.6138541
#> 227 113 female  0.5517172
#> 228 113   male  0.5785795
#> 229 114 female  0.5181828
#> 230 114   male  0.5469485
#> 231 115 female  0.4886791
#> 232 115   male  0.5187756
#> 233 116 female  0.4629713
#> 234 116   male  0.4938733
#> 235 117 female  0.4408081
#> 236 117   male  0.4720306
#> 237 118 female  0.4217884
#> 238 118   male  0.4528154
#> 239 119 female  0.4036805
#> 240 119   male  0.4332804
#> 241 120 female  0.3550000
#> 242 120   male  0.3750000


#Output a table of dQALY values for all ages/genders, specifying year, country and
#selecting a set of norms other than the default set for that country
calculate_dQALY(country = "United Kingdom", year = 2019,
                norms = package_norms(country, id ="janssen_euvas"))
#>     age    sex      dQALY
#> 1     0 female 25.0868719
#> 2     0   male 24.8310237
#> 3     1 female 25.0871971
#> 4     1   male 24.8421698
#> 5     2 female 25.0046754
#> 6     2   male 24.7507589
#> 7     3 female 24.9169588
#> 8     3   male 24.6538644
#> 9     4 female 24.8248932
#> 10    4   male 24.5520625
#> 11    5 female 24.7288393
#> 12    5   male 24.4464398
#> 13    6 female 24.6296677
#> 14    6   male 24.3373608
#> 15    7 female 24.5272671
#> 16    7   male 24.2249493
#> 17    8 female 24.4205256
#> 18    8   male 24.1073620
#> 19    9 female 24.3097937
#> 20    9   male 23.9856531
#> 21   10 female 24.1949336
#> 22   10   male 23.8596782
#> 23   11 female 24.0767855
#> 24   11   male 23.7297718
#> 25   12 female 23.9540048
#> 26   12   male 23.5955501
#> 27   13 female 23.8266774
#> 28   13   male 23.4573376
#> 29   14 female 23.6960973
#> 30   14   male 23.3149860
#> 31   15 female 23.5614154
#> 32   15   male 23.1669218
#> 33   16 female 23.4220042
#> 34   16   male 23.0143635
#> 35   17 female 23.2781732
#> 36   17   male 22.8580774
#> 37   18 female 23.1299971
#> 38   18   male 22.6981418
#> 39   19 female 22.9787218
#> 40   19   male 22.5344018
#> 41   20 female 22.8207144
#> 42   20   male 22.3664675
#> 43   21 female 22.6571456
#> 44   21   male 22.1950735
#> 45   22 female 22.4882793
#> 46   22   male 22.0173581
#> 47   23 female 22.3143778
#> 48   23   male 21.8333233
#> 49   24 female 22.1336663
#> 50   24   male 21.6420807
#> 51   25 female 21.9472616
#> 52   25   male 21.4455786
#> 53   26 female 21.7662611
#> 54   26   male 21.2551564
#> 55   27 female 21.5799854
#> 56   27   male 21.0577339
#> 57   28 female 21.3882293
#> 58   28   male 20.8545588
#> 59   29 female 21.1890463
#> 60   29   male 20.6449788
#> 61   30 female 20.9839030
#> 62   30   male 20.4289568
#> 63   31 female 20.7725678
#> 64   31   male 20.2064471
#> 65   32 female 20.5541690
#> 66   32   male 19.9765768
#> 67   33 female 20.3282393
#> 68   33   male 19.7388652
#> 69   34 female 20.0951244
#> 70   34   male 19.4948189
#> 71   35 female 19.8559735
#> 72   35   male 19.2411971
#> 73   36 female 19.6257079
#> 74   36   male 18.9993668
#> 75   37 female 19.3880413
#> 76   37   male 18.7484126
#> 77   38 female 19.1454366
#> 78   38   male 18.4927548
#> 79   39 female 18.8933677
#> 80   39   male 18.2281761
#> 81   40 female 18.6341909
#> 82   40   male 17.9554466
#> 83   41 female 18.3677866
#> 84   41   male 17.6751317
#> 85   42 female 18.0923501
#> 86   42   male 17.3852727
#> 87   43 female 17.8091840
#> 88   43   male 17.0870764
#> 89   44 female 17.5161414
#> 90   44   male 16.7808470
#> 91   45 female 17.2158591
#> 92   45   male 16.4677060
#> 93   46 female 16.9654393
#> 94   46   male 16.2049270
#> 95   47 female 16.7084428
#> 96   47   male 15.9344311
#> 97   48 female 16.4430304
#> 98   48   male 15.6565003
#> 99   49 female 16.1698569
#> 100  49   male 15.3699671
#> 101  50 female 15.8880797
#> 102  50   male 15.0772279
#> 103  51 female 15.6005363
#> 104  51   male 14.7787796
#> 105  52 female 15.3055826
#> 106  52   male 14.4719462
#> 107  53 female 15.0009615
#> 108  53   male 14.1555409
#> 109  54 female 14.6864052
#> 110  54   male 13.8317989
#> 111  55 female 14.3651758
#> 112  55   male 13.4999215
#> 113  56 female 14.0822821
#> 114  56   male 13.2048247
#> 115  57 female 13.7926658
#> 116  57   male 12.9075349
#> 117  58 female 13.4963131
#> 118  58   male 12.6006253
#> 119  59 female 13.1923600
#> 120  59   male 12.2885373
#> 121  60 female 12.8829878
#> 122  60   male 11.9718016
#> 123  61 female 12.5663735
#> 124  61   male 11.6479788
#> 125  62 female 12.2417210
#> 126  62   male 11.3186514
#> 127  63 female 11.9169660
#> 128  63   male 10.9877771
#> 129  64 female 11.5795194
#> 130  64   male 10.6487735
#> 131  65 female 11.2359088
#> 132  65   male 10.3045008
#> 133  66 female 10.9058165
#> 134  66   male  9.9766373
#> 135  67 female 10.5661750
#> 136  67   male  9.6438464
#> 137  68 female 10.2208375
#> 138  68   male  9.3062339
#> 139  69 female  9.8699704
#> 140  69   male  8.9638736
#> 141  70 female  9.5127315
#> 142  70   male  8.6186844
#> 143  71 female  9.1515548
#> 144  71   male  8.2634627
#> 145  72 female  8.7803048
#> 146  72   male  7.9101881
#> 147  73 female  8.4063452
#> 148  73   male  7.5478900
#> 149  74 female  8.0283644
#> 150  74   male  7.1809314
#> 151  75 female  7.6475150
#> 152  75   male  6.8165653
#> 153  76 female  7.3155632
#> 154  76   male  6.5101944
#> 155  77 female  6.9818292
#> 156  77   male  6.1984763
#> 157  78 female  6.6506490
#> 158  78   male  5.8870816
#> 159  79 female  6.3218101
#> 160  79   male  5.5861797
#> 161  80 female  6.0030664
#> 162  80   male  5.2916984
#> 163  81 female  5.6847192
#> 164  81   male  5.0042981
#> 165  82 female  5.3675269
#> 166  82   male  4.7158762
#> 167  83 female  5.0560521
#> 168  83   male  4.4334603
#> 169  84 female  4.7528276
#> 170  84   male  4.1621719
#> 171  85 female  4.4598014
#> 172  85   male  3.9051353
#> 173  86 female  4.1750521
#> 174  86   male  3.6542692
#> 175  87 female  3.9060021
#> 176  87   male  3.4139854
#> 177  88 female  3.6470962
#> 178  88   male  3.1796611
#> 179  89 female  3.3999026
#> 180  89   male  2.9610867
#> 181  90 female  3.1646678
#> 182  90   male  2.7573834
#> 183  91 female  2.9469524
#> 184  91   male  2.5588594
#> 185  92 female  2.7390658
#> 186  92   male  2.3801460
#> 187  93 female  2.5482057
#> 188  93   male  2.2106433
#> 189  94 female  2.3615783
#> 190  94   male  2.0554240
#> 191  95 female  2.1935651
#> 192  95   male  1.9254411
#> 193  96 female  2.0380006
#> 194  96   male  1.7956664
#> 195  97 female  1.8938924
#> 196  97   male  1.6762010
#> 197  98 female  1.7600355
#> 198  98   male  1.5657875
#> 199  99 female  1.6346466
#> 200  99   male  1.4626008
#> 201 100 female  1.5149630
#> 202 100   male  1.3637831
#> 203 101 female  1.4029828
#> 204 101   male  1.2711301
#> 205 102 female  1.2984871
#> 206 102   male  1.1844476
#> 207 103 female  1.2012404
#> 208 103   male  1.1035343
#> 209 104 female  1.1109942
#> 210 104   male  1.0281843
#> 211 105 female  1.0274906
#> 212 105   male  0.9581888
#> 213 106 female  0.9504654
#> 214 106   male  0.8933383
#> 215 107 female  0.8796511
#> 216 107   male  0.8334236
#> 217 108 female  0.8147794
#> 218 108   male  0.7782376
#> 219 109 female  0.7555836
#> 220 109   male  0.7275761
#> 221 110 female  0.7018006
#> 222 110   male  0.6812390
#> 223 111 female  0.6531716
#> 224 111   male  0.6390303
#> 225 112 female  0.6094430
#> 226 112   male  0.6007585
#> 227 113 female  0.5703668
#> 228 113   male  0.5662364
#> 229 114 female  0.5356988
#> 230 114   male  0.5352803
#> 231 115 female  0.5051978
#> 232 115   male  0.5077084
#> 233 116 female  0.4786210
#> 234 116   male  0.4833373
#> 235 117 female  0.4557086
#> 236 117   male  0.4619606
#> 237 118 female  0.4360460
#> 238 118   male  0.4431554
#> 239 119 female  0.4173260
#> 240 119   male  0.4240371
#> 241 120 female  0.3670000
#> 242 120   male  0.3670000


#Output a table of dQALY values for all ages/genders, specifying year & country,
#with user-supplied norms
my_norms <- data.frame(sex = c(rep("male", 3), rep("female", 3)),
                       lower = c(0, 20, 90),
                       upper = c(19, 89, 150),
                       avg_hrqol = c(1, 0.85, 0.67, 0.99, 0.4, 0.2))
calculate_dQALY(country = "United Kingdom", year = 2019, norms = my_norms)
#>     age    sex      dQALY
#> 1     0 female 19.6619068
#> 2     0   male 25.3603037
#> 3     1 female 19.3946916
#> 4     1   male 25.3238798
#> 5     2 female 19.0535510
#> 6     2   male 25.1811255
#> 7     3 female 18.6986568
#> 8     3   male 25.0310414
#> 9     4 female 18.3303440
#> 10    4   male 24.8741592
#> 11    5 female 17.9485483
#> 12    5   male 24.7115208
#> 13    6 female 17.5535428
#> 14    6   male 24.5434289
#> 15    7 female 17.1448559
#> 16    7   male 24.3699376
#> 17    8 female 16.7213099
#> 18    8   male 24.1891208
#> 19    9 female 16.2827455
#> 20    9   male 24.0019660
#> 21   10 female 15.8286453
#> 22   10   male 23.8082511
#> 23   11 female 15.3591088
#> 24   11   male 23.6082287
#> 25   12 female 14.8727969
#> 26   12   male 23.4014302
#> 27   13 female 14.3692901
#> 28   13   male 23.1880876
#> 29   14 female 13.8488577
#> 30   14   male 22.9679584
#> 31   15 female 13.3104381
#> 32   15   male 22.7393950
#> 33   16 female 12.7531125
#> 34   16   male 22.5034965
#> 35   17 female 12.1764709
#> 36   17   male 22.2609019
#> 37   18 female 11.5799320
#> 38   18   male 22.0115660
#> 39   19 female 10.9634482
#> 40   19   male 21.7552102
#> 41   20 female 10.3245777
#> 42   20   male 21.4913242
#> 43   21 female 10.2739291
#> 44   21   male 21.3757659
#> 45   22 female 10.2217064
#> 46   22   male 21.2558802
#> 47   23 female 10.1680596
#> 48   23   male 21.1317314
#> 49   24 female 10.1122117
#> 50   24   male 21.0025248
#> 51   25 female 10.0547042
#> 52   25   male 20.8702194
#> 53   26 female  9.9949650
#> 54   26   male 20.7338391
#> 55   27 female  9.9336277
#> 56   27   male 20.5923890
#> 57   28 female  9.8706298
#> 58   28   male 20.4471534
#> 59   29 female  9.8051051
#> 60   29   male 20.2975651
#> 61   30 female  9.7377639
#> 62   30   male 20.1436617
#> 63   31 female  9.6685350
#> 64   31   male 19.9854777
#> 65   32 female  9.5970506
#> 66   32   male 19.8222325
#> 67   33 female  9.5231304
#> 68   33   male 19.6535335
#> 69   34 female  9.4469763
#> 70   34   male 19.4809710
#> 71   35 female  9.3691730
#> 72   35   male 19.3014059
#> 73   36 female  9.2885050
#> 74   36   male 19.1187078
#> 75   37 female  9.2053424
#> 76   37   male 18.9290198
#> 77   38 female  9.1208955
#> 78   38   male 18.7368905
#> 79   39 female  9.0330543
#> 80   39   male 18.5381558
#> 81   40 female  8.9429854
#> 82   40   male 18.3336934
#> 83   41 female  8.8506811
#> 84   41   male 18.1241894
#> 85   42 female  8.7553233
#> 86   42   male 17.9077524
#> 87   43 female  8.6575938
#> 88   43   male 17.6857420
#> 89   44 female  8.5565067
#> 90   44   male 17.4586105
#> 91   45 female  8.4534087
#> 92   45   male 17.2276800
#> 93   46 female  8.3479299
#> 94   46   male 16.9923381
#> 95   47 female  8.2398646
#> 96   47   male 16.7504134
#> 97   48 female  8.1283347
#> 98   48   male 16.5022720
#> 99   49 female  8.0136924
#> 100  49   male 16.2467588
#> 101  50 female  7.8955519
#> 102  50   male 15.9864883
#> 103  51 female  7.7753584
#> 104  51   male 15.7220891
#> 105  52 female  7.6523357
#> 106  52   male 15.4508243
#> 107  53 female  7.5253972
#> 108  53   male 15.1715306
#> 109  54 female  7.3944483
#> 110  54   male 14.8867157
#> 111  55 female  7.2611782
#> 112  55   male 14.5956583
#> 113  56 female  7.1248169
#> 114  56   male 14.2965888
#> 115  57 female  6.9853146
#> 116  57   male 13.9959681
#> 117  58 female  6.8426791
#> 118  58   male 13.6858027
#> 119  59 female  6.6964880
#> 120  59   male 13.3709674
#> 121  60 female  6.5478662
#> 122  60   male 13.0521099
#> 123  61 female  6.3959080
#> 124  61   male 12.7266489
#> 125  62 female  6.2402295
#> 126  62   male 12.3963953
#> 127  63 female  6.0849023
#> 128  63   male 12.0657878
#> 129  64 female  5.9235324
#> 130  64   male 11.7277244
#> 131  65 female  5.7594829
#> 132  65   male 11.3854725
#> 133  66 female  5.5927602
#> 134  66   male 11.0412796
#> 135  67 female  5.4212515
#> 136  67   male 10.6925303
#> 137  68 female  5.2469418
#> 138  68   male 10.3394310
#> 139  69 female  5.0699274
#> 140  69   male  9.9821683
#> 141  70 female  4.8897881
#> 142  70   male  9.6230042
#> 143  71 female  4.7077898
#> 144  71   male  9.2540408
#> 145  72 female  4.5207934
#> 146  72   male  8.8888518
#> 147  73 female  4.3326084
#> 148  73   male  8.5153457
#> 149  74 female  4.1425857
#> 150  74   male  8.1386679
#> 151  75 female  3.9513517
#> 152  75   male  7.7673674
#> 153  76 female  3.7581292
#> 154  76   male  7.4039406
#> 155  77 female  3.5626697
#> 156  77   male  7.0333889
#> 157  78 female  3.3669742
#> 158  78   male  6.6619781
#> 159  79 female  3.1706503
#> 160  79   male  6.3009611
#> 161  80 female  2.9772153
#> 162  80   male  5.9453753
#> 163  81 female  2.7813610
#> 164  81   male  5.5955181
#> 165  82 female  2.5829257
#> 166  82   male  5.2417779
#> 167  83 female  2.3833948
#> 168  83   male  4.8913006
#> 169  84 female  2.1829608
#> 170  84   male  4.5487421
#> 171  85 female  1.9811455
#> 172  85   male  4.2160810
#> 173  86 female  1.7752448
#> 174  86   male  3.8826430
#> 175  87 female  1.5658903
#> 176  87   male  3.5505835
#> 177  88 female  1.3472121
#> 178  88   male  3.2114498
#> 179  89 female  1.1149649
#> 180  89   male  2.8699224
#> 181  90 female  0.8623073
#> 182  90   male  2.5169576
#> 183  91 female  0.8029843
#> 184  91   male  2.3357436
#> 185  92 female  0.7463394
#> 186  92   male  2.1726129
#> 187  93 female  0.6943340
#> 188  93   male  2.0178897
#> 189  94 female  0.6434818
#> 190  94   male  1.8762044
#> 191  95 female  0.5977017
#> 192  95   male  1.7575552
#> 193  96 female  0.5553135
#> 194  96   male  1.6390960
#> 195  97 female  0.5160470
#> 196  97   male  1.5300472
#> 197  98 female  0.4795737
#> 198  98   male  1.4292611
#> 199  99 female  0.4454078
#> 200  99   male  1.3350716
#> 201 100 female  0.4127964
#> 202 100   male  1.2448701
#> 203 101 female  0.3822842
#> 204 101   male  1.1602959
#> 205 102 female  0.3538112
#> 206 102   male  1.0811715
#> 207 103 female  0.3273135
#> 208 103   male  1.0073133
#> 209 104 female  0.3027232
#> 210 104   male  0.9385333
#> 211 105 female  0.2799702
#> 212 105   male  0.8746410
#> 213 106 female  0.2589824
#> 214 106   male  0.8154451
#> 215 107 female  0.2396869
#> 216 107   male  0.7607545
#> 217 108 female  0.2220107
#> 218 108   male  0.7103804
#> 219 109 female  0.2058811
#> 220 109   male  0.6641363
#> 221 110 female  0.1912263
#> 222 110   male  0.6218394
#> 223 111 female  0.1779759
#> 224 111   male  0.5833110
#> 225 112 female  0.1660608
#> 226 112   male  0.5483763
#> 227 113 female  0.1554133
#> 228 113   male  0.5168643
#> 229 114 female  0.1459670
#> 230 114   male  0.4886073
#> 231 115 female  0.1376561
#> 232 115   male  0.4634395
#> 233 116 female  0.1304144
#> 234 116   male  0.4411935
#> 235 117 female  0.1241713
#> 236 117   male  0.4216806
#> 237 118 female  0.1188136
#> 238 118   male  0.4045151
#> 239 119 female  0.1137128
#> 240 119   male  0.3870639
#> 241 120 female  0.1000000
#> 242 120   male  0.3350000


#Output a table of dQALY values for all ages/genders, with user-specified norms and life tables
my_life_table <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
                            age = c(0:100, 0:100),
                            q = c(seq(0, 1, 0.01)))

calculate_dQALY(life_table = my_life_table, norms = my_norms)
#>     age    sex      dQALY
#> 1     0 female  9.8101917
#> 2     0   male 10.0118522
#> 3     1 female  9.1288984
#> 4     1   male  9.3272671
#> 5     2 female  8.5140233
#> 6     2   male  8.7110065
#> 7     3 female  7.9567455
#> 8     3   male  8.1543283
#> 9     4 female  7.4494344
#> 10    4   male  7.6497472
#> 11    5 female  6.9854246
#> 12    5   male  7.1908212
#> 13    6 female  6.5588218
#> 14    6   male  6.7719736
#> 15    7 female  6.1643298
#> 16    7   male  6.3883433
#> 17    8 female  5.7970904
#> 18    8   male  6.0356562
#> 19    9 female  5.4525267
#> 20    9   male  5.7101132
#> 21   10 female  5.1261807
#> 22   10   male  5.4082881
#> 23   11 female  4.8135328
#> 24   11   male  5.1270313
#> 25   12 female  4.5097890
#> 26   12   male  4.8633735
#> 27   13 female  4.2096143
#> 28   13   male  4.6144223
#> 29   14 female  3.9067851
#> 30   14   male  4.3772438
#> 31   15 female  3.5937187
#> 32   15   male  4.1487178
#> 33   16 female  3.2608208
#> 34   16   male  3.9253505
#> 35   17 female  2.8955613
#> 36   17   male  3.7030211
#> 37   18 female  2.4811460
#> 38   18   male  3.4766287
#> 39   19 female  1.9945788
#> 40   19   male  3.2395863
#> 41   20 female  1.4038035
#> 42   20   male  2.9830824
#> 43   21 female  1.3504208
#> 44   21   male  2.8696442
#> 45   22 female  1.3001968
#> 46   22   male  2.7629183
#> 47   23 female  1.2528766
#> 48   23   male  2.6623627
#> 49   24 female  1.2082302
#> 50   24   male  2.5674892
#> 51   25 female  1.1660504
#> 52   25   male  2.4778570
#> 53   26 female  1.1261495
#> 54   26   male  2.3930677
#> 55   27 female  1.0883577
#> 56   27   male  2.3127602
#> 57   28 female  1.0525209
#> 58   28   male  2.2366069
#> 59   29 female  1.0184988
#> 60   29   male  2.1643099
#> 61   30 female  0.9861637
#> 62   30   male  2.0955979
#> 63   31 female  0.9553992
#> 64   31   male  2.0302233
#> 65   32 female  0.9260988
#> 66   32   male  1.9679599
#> 67   33 female  0.8981651
#> 68   33   male  1.9086008
#> 69   34 female  0.8715087
#> 70   34   male  1.8519560
#> 71   35 female  0.8460478
#> 72   35   male  1.7978515
#> 73   36 female  0.8217068
#> 74   36   male  1.7461270
#> 75   37 female  0.7984165
#> 76   37   male  1.6966350
#> 77   38 female  0.7761128
#> 78   38   male  1.6492396
#> 79   39 female  0.7547366
#> 80   39   male  1.6038154
#> 81   40 female  0.7342335
#> 82   40   male  1.5602462
#> 83   41 female  0.7145528
#> 84   41   male  1.5184247
#> 85   42 female  0.6956477
#> 86   42   male  1.4782513
#> 87   43 female  0.6774747
#> 88   43   male  1.4396338
#> 89   44 female  0.6599936
#> 90   44   male  1.4024863
#> 91   45 female  0.6431667
#> 92   45   male  1.3667292
#> 93   46 female  0.6269591
#> 94   46   male  1.3322881
#> 95   47 female  0.6113383
#> 96   47   male  1.2990939
#> 97   48 female  0.5962739
#> 98   48   male  1.2670820
#> 99   49 female  0.5817375
#> 100  49   male  1.2361921
#> 101  50 female  0.5677025
#> 102  50   male  1.2063678
#> 103  51 female  0.5541442
#> 104  51   male  1.1775564
#> 105  52 female  0.5410393
#> 106  52   male  1.1497085
#> 107  53 female  0.5283660
#> 108  53   male  1.1227777
#> 109  54 female  0.5161038
#> 110  54   male  1.0967206
#> 111  55 female  0.5042336
#> 112  55   male  1.0714963
#> 113  56 female  0.4927372
#> 114  56   male  1.0470665
#> 115  57 female  0.4815977
#> 116  57   male  1.0233951
#> 117  58 female  0.4707991
#> 118  58   male  1.0004480
#> 119  59 female  0.4603262
#> 120  59   male  0.9781932
#> 121  60 female  0.4501650
#> 122  60   male  0.9566006
#> 123  61 female  0.4403019
#> 124  61   male  0.9356416
#> 125  62 female  0.4307244
#> 126  62   male  0.9152893
#> 127  63 female  0.4214203
#> 128  63   male  0.8955182
#> 129  64 female  0.4123785
#> 130  64   male  0.8763042
#> 131  65 female  0.4035881
#> 132  65   male  0.8576246
#> 133  66 female  0.3950390
#> 134  66   male  0.8394578
#> 135  67 female  0.3867216
#> 136  67   male  0.8217833
#> 137  68 female  0.3786267
#> 138  68   male  0.8045817
#> 139  69 female  0.3707457
#> 140  69   male  0.7878347
#> 141  70 female  0.3630704
#> 142  70   male  0.7715246
#> 143  71 female  0.3555930
#> 144  71   male  0.7556350
#> 145  72 female  0.3483059
#> 146  72   male  0.7401501
#> 147  73 female  0.3412022
#> 148  73   male  0.7250547
#> 149  74 female  0.3342751
#> 150  74   male  0.7103346
#> 151  75 female  0.3275182
#> 152  75   male  0.6959762
#> 153  76 female  0.3209254
#> 154  76   male  0.6819665
#> 155  77 female  0.3144909
#> 156  77   male  0.6682932
#> 157  78 female  0.3082091
#> 158  78   male  0.6549444
#> 159  79 female  0.3020748
#> 160  79   male  0.6419089
#> 161  80 female  0.2960828
#> 162  80   male  0.6291759
#> 163  81 female  0.2902283
#> 164  81   male  0.6167351
#> 165  82 female  0.2845067
#> 166  82   male  0.6045768
#> 167  83 female  0.2789135
#> 168  83   male  0.5926914
#> 169  84 female  0.2734443
#> 170  84   male  0.5810697
#> 171  85 female  0.2680925
#> 172  85   male  0.5697012
#> 173  86 female  0.2628385
#> 174  86   male  0.5585630
#> 175  87 female  0.2575563
#> 176  87   male  0.5475375
#> 177  88 female  0.2512365
#> 178  88   male  0.5357117
#> 179  89 female  0.2349144
#> 180  89   male  0.5150134
#> 181  90 female  0.1215132
#> 182  90   male  0.4070692
#> 183  91 female  0.1191616
#> 184  91   male  0.3991913
#> 185  92 female  0.1168581
#> 186  92   male  0.3914745
#> 187  93 female  0.1146012
#> 188  93   male  0.3839141
#> 189  94 female  0.1123897
#> 190  94   male  0.3765054
#> 191  95 female  0.1102221
#> 192  95   male  0.3692440
#> 193  96 female  0.1080971
#> 194  96   male  0.3621254
#> 195  97 female  0.1060136
#> 196  97   male  0.3551457
#> 197  98 female  0.1039704
#> 198  98   male  0.3483007
#> 199  99 female  0.1019662
#> 200  99   male  0.3415867
#> 201 100 female  0.1000000
#> 202 100   male  0.3350000


#Calculate dQALY values using a variable discount rate
rfun = function(x) ifelse(x < 31, 0.015, ifelse(x > 75, 0.0107, 0.0129))
calculate_dQALY(country = "United Kingdom", year = 2019, r = rfun)
#>     age    sex      dQALY
#> 1     0 female 43.3454531
#> 2     0   male 42.2604265
#> 3     1 female 43.1462033
#> 4     1   male 42.0789832
#> 5     2 female 42.8034912
#> 6     2   male 41.7226884
#> 7     3 female 42.4527771
#> 8     3   male 41.3582837
#> 9     4 female 42.0957107
#> 10    4   male 40.9869560
#> 11    5 female 41.7330771
#> 12    5   male 40.6106970
#> 13    6 female 41.3664600
#> 14    6   male 40.2302211
#> 15    7 female 40.9957875
#> 16    7   male 39.8458519
#> 17    8 female 40.6193413
#> 18    8   male 39.4547096
#> 19    9 female 40.2378659
#> 20    9   male 39.0587001
#> 21   10 female 39.8512854
#> 22   10   male 38.6577383
#> 23   11 female 39.4611187
#> 24   11   male 38.2525117
#> 25   12 female 39.0652986
#> 26   12   male 37.8425425
#> 27   13 female 38.6641355
#> 28   13   male 37.4284952
#> 29   14 female 38.2598682
#> 30   14   male 37.0102690
#> 31   15 female 37.8512432
#> 32   15   male 36.5855367
#> 33   16 female 37.4373257
#> 34   16   male 36.1563206
#> 35   17 female 37.0187704
#> 36   17   male 35.7239609
#> 37   18 female 36.5958461
#> 38   18   male 35.2886928
#> 39   19 female 36.1706452
#> 40   19   male 34.8503897
#> 41   20 female 35.7376091
#> 42   20   male 34.4085755
#> 43   21 female 35.2988095
#> 44   21   male 33.9645041
#> 45   22 female 34.8548575
#> 46   22   male 33.5139561
#> 47   23 female 34.4063482
#> 48   23   male 33.0571742
#> 49   24 female 33.9507617
#> 50   24   male 32.5930698
#> 51   25 female 33.4900550
#> 52   25   male 32.1248194
#> 53   26 female 33.0325463
#> 54   26   male 31.6610852
#> 55   27 female 32.5704668
#> 56   27   male 31.1904922
#> 57   28 female 32.1037018
#> 58   28   male 30.7151291
#> 59   29 female 31.6295665
#> 60   29   male 30.2342518
#> 61   30 female 31.1505112
#> 62   30   male 29.7480396
#> 63   31 female 30.6664156
#> 64   31   male 29.2566587
#> 65   32 female 30.1762374
#> 66   32   male 28.7590930
#> 67   33 female 29.6795656
#> 68   33   male 28.2549288
#> 69   34 female 29.1771830
#> 70   34   male 27.7465817
#> 71   35 female 28.6710037
#> 72   35   male 27.2297162
#> 73   36 female 28.1776910
#> 74   36   male 26.7302576
#> 75   37 female 27.6785591
#> 76   37   male 26.2229288
#> 77   38 female 27.1773480
#> 78   38   male 25.7141655
#> 79   39 female 26.6678728
#> 80   39   male 25.1983145
#> 81   40 female 26.1537715
#> 82   40   male 24.6767437
#> 83   41 female 25.6351270
#> 84   41   male 24.1505008
#> 85   42 female 25.1097038
#> 86   42   male 23.6171964
#> 87   43 female 24.5796132
#> 88   43   male 23.0787821
#> 89   44 female 24.0421972
#> 90   44   male 22.5359423
#> 91   45 female 23.5013847
#> 92   45   male 21.9904260
#> 93   46 female 23.0170712
#> 94   46   male 21.5125544
#> 95   47 female 22.5288450
#> 96   47   male 21.0297563
#> 97   48 female 22.0344617
#> 98   48   male 20.5426424
#> 99   49 female 21.5350658
#> 100  49   male 20.0499277
#> 101  50 female 21.0297946
#> 102  50   male 19.5549692
#> 103  51 female 20.5226310
#> 104  51   male 19.0585724
#> 105  52 female 20.0115919
#> 106  52   male 18.5574772
#> 107  53 female 19.4939813
#> 108  53   male 18.0504333
#> 109  54 female 18.9697617
#> 110  54   male 17.5405495
#> 111  55 female 18.4434034
#> 112  55   male 17.0270304
#> 113  56 female 17.9536649
#> 114  56   male 16.5689504
#> 115  57 female 17.4606035
#> 116  57   male 16.1140232
#> 117  58 female 16.9643564
#> 118  58   male 15.6531079
#> 119  59 female 16.4640009
#> 120  59   male 15.1919459
#> 121  60 female 15.9624029
#> 122  60   male 14.7313166
#> 123  61 female 15.4574167
#> 124  61   male 14.2683724
#> 125  62 female 14.9482312
#> 126  62   male 13.8052386
#> 127  63 female 14.4445898
#> 128  63   male 13.3468470
#> 129  64 female 13.9312904
#> 130  64   male 12.8853365
#> 131  65 female 13.4164513
#> 132  65   male 12.4244005
#> 133  66 female 12.9306691
#> 134  66   male 11.9664909
#> 135  67 female 12.4392979
#> 136  67   male 11.5087621
#> 137  68 female 11.9470622
#> 138  68   male 11.0514794
#> 139  69 female 11.4542497
#> 140  69   male 10.5948768
#> 141  70 female 10.9599852
#> 142  70   male 10.1413520
#> 143  71 female 10.4671569
#> 144  71   male  9.6826393
#> 145  72 female  9.9688672
#> 146  72   male  9.2329727
#> 147  73 female  9.4736257
#> 148  73   male  8.7796972
#> 149  74 female  8.9799467
#> 150  74   male  8.3282030
#> 151  75 female  8.4891214
#> 152  75   male  7.8870830
#> 153  76 female  8.0711935
#> 154  76   male  7.4894214
#> 155  77 female  7.6566464
#> 156  77   male  7.0905014
#> 157  78 female  7.2501834
#> 158  78   male  6.6968806
#> 159  79 female  6.8514417
#> 160  79   male  6.3199416
#> 161  80 female  6.4685967
#> 162  80   male  5.9547496
#> 163  81 female  6.0909563
#> 164  81   male  5.6018013
#> 165  82 female  5.7192808
#> 166  82   male  5.2518896
#> 167  83 female  5.3583136
#> 168  83   male  4.9127782
#> 169  84 female  5.0105114
#> 170  84   male  4.5898876
#> 171  85 female  4.6776402
#> 172  85   male  4.2862811
#> 173  86 female  4.3574006
#> 174  86   male  3.9927677
#> 175  87 female  4.0572104
#> 176  87   male  3.7139516
#> 177  88 female  3.7709229
#> 178  88   male  3.4445842
#> 179  89 female  3.4998765
#> 180  89   male  3.1950285
#> 181  90 female  3.2440284
#> 182  90   male  2.9639493
#> 183  91 female  3.0087270
#> 184  91   male  2.7406898
#> 185  92 female  2.7857799
#> 186  92   male  2.5406906
#> 187  93 female  2.5822205
#> 188  93   male  2.3523047
#> 189  94 female  2.3848396
#> 190  94   male  2.1807273
#> 191  95 female  2.2079725
#> 192  95   male  2.0371795
#> 193  96 female  2.0450792
#> 194  96   male  1.8948631
#> 195  97 female  1.8949341
#> 196  97   male  1.7643991
#> 197  98 female  1.7561295
#> 198  98   male  1.6442919
#> 199  99 female  1.6267178
#> 200  99   male  1.5324840
#> 201 100 female  1.5038362
#> 202 100   male  1.4258926
#> 203 101 female  1.3893821
#> 204 101   male  1.3263372
#> 205 102 female  1.2830324
#> 206 102   male  1.2335373
#> 207 103 female  1.1844573
#> 208 103   male  1.1472125
#> 209 104 female  1.0933233
#> 210 104   male  1.0670839
#> 211 105 female  1.0092959
#> 212 105   male  0.9928762
#> 213 106 female  0.9320432
#> 214 106   male  0.9243190
#> 215 107 female  0.8612375
#> 216 107   male  0.8611483
#> 217 108 female  0.7965583
#> 218 108   male  0.8031071
#> 219 109 female  0.7376930
#> 220 109   male  0.7499468
#> 221 110 female  0.6843392
#> 222 110   male  0.7014269
#> 223 111 female  0.6362044
#> 224 111   male  0.6573159
#> 225 112 female  0.5930070
#> 226 112   male  0.6173903
#> 227 113 female  0.5544749
#> 228 113   male  0.5814345
#> 229 114 female  0.5203449
#> 230 114   male  0.5492398
#> 231 115 female  0.4903601
#> 232 115   male  0.5206021
#> 233 116 female  0.4642657
#> 234 116   male  0.4953181
#> 235 117 female  0.4417927
#> 236 117   male  0.4731617
#> 237 118 female  0.4225189
#> 238 118   male  0.4536788
#> 239 119 female  0.4041519
#> 240 119   male  0.4338448
#> 241 120 female  0.3550000
#> 242 120   male  0.3750000


#Calculate grouped dQALY values - using default country-level population weightings:
#1) collapse sex
calculate_dQALY(country = "United Kingdom", year = 2019,
                collapse_sex = TRUE)
#>     age     dQALY
#> 1     0 25.073515
#> 2     1 25.077857
#> 3     2 24.988739
#> 4     3 24.894077
#> 5     4 24.794767
#> 6     5 24.691529
#> 7     6 24.584969
#> 8     7 24.475032
#> 9     8 24.360111
#> 10    9 24.241112
#> 11   10 24.117697
#> 12   11 23.990355
#> 13   12 23.858625
#> 14   13 23.722836
#> 15   14 23.583074
#> 16   15 23.437926
#> 17   16 23.288005
#> 18   17 23.134158
#> 19   18 22.976211
#> 20   19 22.814395
#> 21   20 22.647207
#> 22   21 22.475353
#> 23   22 22.297849
#> 24   23 22.114542
#> 25   24 21.924725
#> 26   25 21.729391
#> 27   26 21.538536
#> 28   27 21.340586
#> 29   28 21.135482
#> 30   29 20.923853
#> 31   30 20.709076
#> 32   31 20.486947
#> 33   32 20.253668
#> 34   33 20.012589
#> 35   34 19.765202
#> 36   35 19.509246
#> 37   36 19.266709
#> 38   37 19.017553
#> 39   38 18.761792
#> 40   39 18.495108
#> 41   40 18.219555
#> 42   41 17.937855
#> 43   42 17.647795
#> 44   43 17.348145
#> 45   44 17.038095
#> 46   45 16.717413
#> 47   46 16.458593
#> 48   47 16.209649
#> 49   48 15.948530
#> 50   49 15.660886
#> 51   50 15.377130
#> 52   51 15.086347
#> 53   52 14.782114
#> 54   53 14.471709
#> 55   54 14.150530
#> 56   55 13.826113
#> 57   56 13.541342
#> 58   57 13.247284
#> 59   58 12.947095
#> 60   59 12.644781
#> 61   60 12.337437
#> 62   61 12.022909
#> 63   62 11.702320
#> 64   63 11.379365
#> 65   64 11.047675
#> 66   65 10.711243
#> 67   66 10.385284
#> 68   67 10.050866
#> 69   68  9.707820
#> 70   69  9.360866
#> 71   70  9.010396
#> 72   71  8.654050
#> 73   72  8.295173
#> 74   73  7.933837
#> 75   74  7.568680
#> 76   75  7.198116
#> 77   76  6.881879
#> 78   77  6.562763
#> 79   78  6.242294
#> 80   79  5.928237
#> 81   80  5.623786
#> 82   81  5.325198
#> 83   82  5.027280
#> 84   83  4.734008
#> 85   84  4.450505
#> 86   85  4.178582
#> 87   86  3.913568
#> 88   87  3.662377
#> 89   88  3.420228
#> 90   89  3.190878
#> 91   90  2.973500
#> 92   91  2.768426
#> 93   92  2.576921
#> 94   93  2.399378
#> 95   94  2.229118
#> 96   95  2.078552
#> 97   96  1.935755
#> 98   97  1.803230
#> 99   98  1.679608
#> 100  99  1.563108
#2) age groups
my_age_groups <- data.frame(lower = c(seq(0,90,5)), upper = c(seq(4,89,5), 100))
calculate_dQALY(country = "United Kingdom", year = 2019,
                collapse_age = my_age_groups)
#>       age lower upper    sex     dQALY
#> 1     0-4     0     4 female 25.110838
#> 2     0-4     0     4   male 24.820439
#> 3     5-9     5     9 female 24.644077
#> 4     5-9     5     9   male 24.303266
#> 5   10-14    10    14 female 24.066453
#> 6   10-14    10    14   male 23.663576
#> 7   15-19    15    19 female 23.371017
#> 8   15-19    15    19   male 22.897024
#> 9   20-24    20    24 female 22.560536
#> 10  20-24    20    24   male 22.024996
#> 11  25-29    25    29 female 21.632047
#> 12  25-29    25    29   male 21.035445
#> 13  30-34    30    34 female 20.567442
#> 14  30-34    30    34   male 19.899701
#> 15  35-39    35    39 female 19.379214
#> 16  35-39    35    39   male 18.633302
#> 17  40-44    40    44 female 18.058194
#> 18  40-44    40    44   male 17.221675
#> 19  45-49    45    49 female 16.630226
#> 20  45-49    45    49   male 15.736611
#> 21  50-54    50    54 female 15.231087
#> 22  50-54    50    54   male 14.291466
#> 23  55-59    55    59 female 13.696808
#> 24  55-59    55    59   male 12.776166
#> 25  60-64    60    64 female 12.097794
#> 26  60-64    60    64   male 11.308739
#> 27  65-69    65    69 female 10.368467
#> 28  65-69    65    69   male  9.710620
#> 29  70-74    70    74 female  8.577491
#> 30  70-74    70    74   male  8.058652
#> 31  75-79    75    79 female  6.803965
#> 32  75-79    75    79   male  6.384617
#> 33  80-84    80    84 female  5.237293
#> 34  80-84    80    84   male  4.880922
#> 35  85-89    85    89 female  3.838118
#> 36  85-89    85    89   male  3.565916
#> 37 90-100    90   100 female  2.546045
#> 38 90-100    90   100   male  2.412617
#3) collapse sex and group age
calculate_dQALY(country = "United Kingdom", year = 2019,
                collapse_age = my_age_groups, collapse_sex = TRUE)
#>       age lower upper     dQALY
#> 1     0-4     0     4 24.961818
#> 2     5-9     5     9 24.469507
#> 3   10-14    10    14 23.859980
#> 4   15-19    15    19 23.127510
#> 5   20-24    20    24 22.285050
#> 6   25-29    25    29 21.329255
#> 7   30-34    30    34 20.235616
#> 8   35-39    35    39 19.009906
#> 9   40-44    40    44 17.642048
#> 10  45-49    45    49 16.190309
#> 11  50-54    50    54 14.779186
#> 12  55-59    55    59 13.251883
#> 13  60-64    60    64 11.717068
#> 14  65-69    65    69 10.054301
#> 15  70-74    70    74  8.329081
#> 16  75-79    75    79  6.611874
#> 17  80-84    80    84  5.079288
#> 18  85-89    85    89  3.729266
#> 19 90-100    90   100  2.503295

#Do any of these groupings with a user-supplied cohort
my_cohort <- data.frame(sex = c(rep("male", 5), rep("female", 8)),
                        age = c(89:93, 89:92, 95:97, 100),
                        count = c(1, 1, 2, 1, 1, 3, 2, 1, 1, 2, 1, 1, 1))
#note: any age and gender for which no count value is supplied is considered
#outside the cohort (count zero)
#1) collapse sex
calculate_dQALY(country = "United Kingdom", year = 2019,
                collapse_sex = TRUE, cohort = my_cohort)
#> Warning: User-supplied data does not have same number of values for sex =  "female" and sex = "male".
#>   age    dQALY
#> 1  89 3.222959
#> 2  90 2.979957
#> 3  91 2.693290
#> 4  92 2.540767
#> 5  93 2.258832
#> 6  95 2.121841
#> 7  96 1.971363
#> 8  97 1.831967
#> 9 100 1.465427
#2) age groups (note: of the age groups specified, only estimates for age groups that contain a
#member of the specified cohort are returned)
calculate_dQALY(country = "United Kingdom", year = 2019,
                collapse_age = my_age_groups, cohort = my_cohort)
#> Warning: User-supplied data does not have same number of values for sex =  "female" and sex = "male".
#>      age lower upper    sex    dQALY
#> 1  85-89    85    89   male 3.025634
#> 2  85-89    85    89 female 3.288734
#> 3 90-100    90   100   male 2.547526
#> 4 90-100    90   100 female 2.348324
#3) collapse sex and group age
calculate_dQALY(country = "United Kingdom", year = 2019,
                collapse_age = my_age_groups,
                collapse_sex = TRUE, cohort = my_cohort)
#> Warning: User-supplied data does not have same number of values for sex =  "female" and sex = "male".
#>      age lower upper    dQALY
#> 1  85-89    85    89 3.222959
#> 2 90-100    90   100 2.419468

#It's possible (though perhaps not often advisable) to perform the calculation
#using data from various countries/years
calculate_dQALY(life_table = package_lt(country = "England", year = 2019),
                norms = package_norms(country = "France"),
                cohort = package_cohort(country = "Spain", year = 2020),
                collapse_sex = TRUE)
#>     age     dQALY
#> 1     0 25.502775
#> 2     1 25.515568
#> 3     2 25.433179
#> 4     3 25.345268
#> 5     4 25.253834
#> 6     5 25.158321
#> 7     6 25.059701
#> 8     7 24.957760
#> 9     8 24.851514
#> 10    9 24.741761
#> 11   10 24.627884
#> 12   11 24.510315
#> 13   12 24.388884
#> 14   13 24.263527
#> 15   14 24.134584
#> 16   15 24.000733
#> 17   16 23.862642
#> 18   17 23.719877
#> 19   18 23.573463
#> 20   19 23.424148
#> 21   20 23.270904
#> 22   21 23.113146
#> 23   22 22.949701
#> 24   23 22.781560
#> 25   24 22.605985
#> 26   25 22.424916
#> 27   26 22.240305
#> 28   27 22.049688
#> 29   28 21.852655
#> 30   29 21.649085
#> 31   30 21.439454
#> 32   31 21.223438
#> 33   32 20.999712
#> 34   33 20.768852
#> 35   34 20.531097
#> 36   35 20.285260
#> 37   36 20.065309
#> 38   37 19.838404
#> 39   38 19.606220
#> 40   39 19.366895
#> 41   40 19.120832
#> 42   41 18.866183
#> 43   42 18.603996
#> 44   43 18.335660
#> 45   44 18.060023
#> 46   45 17.777016
#> 47   46 17.477948
#> 48   47 17.171392
#> 49   48 16.856705
#> 50   49 16.532706
#> 51   50 16.200415
#> 52   51 15.859781
#> 53   52 15.510029
#> 54   53 15.147933
#> 55   54 14.777435
#> 56   55 14.397526
#> 57   56 14.077348
#> 58   57 13.750788
#> 59   58 13.417510
#> 60   59 13.080169
#> 61   60 12.732127
#> 62   61 12.373415
#> 63   62 12.008502
#> 64   63 11.641300
#> 65   64 11.265158
#> 66   65 10.880961
#> 67   66 10.532463
#> 68   67 10.176964
#> 69   68  9.817249
#> 70   69  9.454502
#> 71   70  9.084898
#> 72   71  8.708587
#> 73   72  8.321412
#> 74   73  7.929980
#> 75   74  7.537125
#> 76   75  7.139449
#> 77   76  6.816157
#> 78   77  6.493847
#> 79   78  6.176277
#> 80   79  5.864653
#> 81   80  5.559396
#> 82   81  5.253703
#> 83   82  4.952560
#> 84   83  4.659830
#> 85   84  4.371238
#> 86   85  4.091460
#> 87   86  3.823072
#> 88   87  3.567702
#> 89   88  3.325746
#> 90   89  3.100095
#> 91   90  2.890420
#> 92   91  2.683273
#> 93   92  2.492013
#> 94   93  2.312458
#> 95   94  2.150102
#> 96   95  1.995348
#> 97   96  1.855055
#> 98   97  1.727267
#> 99   98  1.609939
#> 100  99  1.495606
```
