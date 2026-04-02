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
#>        sex age      dQALY
#> 1   female   0 25.2201968
#> 2     male   0 24.9345497
#> 3   female   1 25.2194495
#> 4     male   1 24.9435579
#> 5   female   2 25.1353787
#> 6     male   2 24.8495090
#> 7   female   3 25.0460465
#> 8     male   3 24.7498746
#> 9   female   4 24.9523020
#> 10    male   4 24.6452308
#> 11  female   5 24.8545065
#> 12    male   5 24.5366655
#> 13  female   6 24.7535334
#> 14    male   6 24.4245416
#> 15  female   7 24.6492693
#> 16    male   7 24.3089801
#> 17  female   8 24.5405953
#> 18    male   8 24.1881282
#> 19  female   9 24.4278619
#> 20    male   9 24.0630401
#> 21  female  10 24.3109289
#> 22    male  10 23.9335675
#> 23  female  11 24.1906389
#> 24    male  11 23.8000425
#> 25  female  12 24.0656388
#> 26    male  12 23.6620758
#> 27  female  13 23.9360131
#> 28    male  13 23.5199889
#> 29  female  14 23.8030596
#> 30    male  14 23.3736287
#> 31  female  15 23.6659232
#> 32    male  15 23.2214134
#> 33  female  16 23.5239714
#> 34    male  16 23.0645597
#> 35  female  17 23.3775125
#> 36    male  17 22.9038308
#> 37  female  18 23.2266193
#> 38    male  18 22.7392994
#> 39  female  19 23.0725400
#> 40    male  19 22.5708045
#> 41  female  20 22.9116241
#> 42    male  20 22.3979495
#> 43  female  21 22.7450444
#> 44    male  21 22.2214637
#> 45  female  22 22.5730630
#> 46    male  22 22.0384750
#> 47  female  23 22.3959401
#> 48    male  23 21.8489794
#> 49  female  24 22.2118912
#> 50    male  24 21.6520814
#> 51  female  25 22.0220339
#> 52    male  25 21.4497235
#> 53  female  26 21.8353872
#> 54    male  26 21.2511665
#> 55  female  27 21.6432697
#> 56    male  27 21.0453194
#> 57  female  28 21.4454689
#> 58    male  28 20.8334186
#> 59  female  29 21.2400258
#> 60    male  29 20.6148005
#> 61  female  30 21.0284038
#> 62    male  30 20.3894157
#> 63  female  31 20.8103629
#> 64    male  31 20.1572056
#> 65  female  32 20.5850216
#> 66    male  32 19.9172854
#> 67  female  33 20.3519037
#> 68    male  33 19.6691623
#> 69  female  34 20.1113466
#> 70    male  34 19.4143224
#> 71  female  35 19.8644908
#> 72    male  35 19.1495219
#> 73  female  36 19.6293520
#> 74    male  36 18.8992006
#> 75  female  37 19.3866386
#> 76    male  37 18.6394508
#> 77  female  38 19.1388066
#> 78    male  38 18.3746531
#> 79  female  39 18.8813236
#> 80    male  39 18.1005997
#> 81  female  40 18.6165374
#> 82    male  40 17.8180400
#> 83  female  41 18.3443202
#> 84    male  41 17.5275178
#> 85  female  42 18.0628607
#> 86    male  42 17.2270716
#> 87  female  43 17.7734508
#> 88    male  43 16.9178786
#> 89  female  44 17.4739378
#> 90    male  44 16.6002179
#> 91  female  45 17.1669423
#> 92    male  45 16.2751738
#> 93  female  46 16.9136996
#> 94    male  46 16.0145075
#> 95  female  47 16.6537690
#> 96    male  47 15.7461783
#> 97  female  48 16.3853114
#> 98    male  48 15.4704632
#> 99  female  49 16.1089736
#> 100   male  49 15.1862069
#> 101 female  50 15.8239096
#> 102   male  50 14.8957750
#> 103 female  51 15.5329386
#> 104   male  51 14.5996561
#> 105 female  52 15.2344146
#> 106   male  52 14.2952039
#> 107 female  53 14.9260827
#> 108   male  53 13.9812435
#> 109 female  54 14.6076683
#> 110   male  54 13.6599799
#> 111 female  55 14.2824066
#> 112   male  55 13.3306211
#> 113 female  56 13.9901206
#> 114   male  56 13.0536637
#> 115 female  57 13.6907233
#> 116   male  57 12.7751332
#> 117 female  58 13.3841769
#> 118   male  58 12.4877222
#> 119 female  59 13.0695982
#> 120   male  59 12.1958689
#> 121 female  60 12.7491193
#> 122   male  60 11.9001509
#> 123 female  61 12.4209009
#> 124   male  61 11.5981998
#> 125 female  62 12.0841210
#> 126   male  62 11.2916506
#> 127 female  63 11.7465694
#> 128   male  63 10.9845269
#> 129 female  64 11.3957804
#> 130   male  64 10.6703392
#> 131 female  65 11.0381382
#> 132   male  65 10.3520386
#> 133 female  66 10.7046939
#> 134   male  66 10.0316396
#> 135 female  67 10.3614665
#> 136   male  67  9.7067317
#> 137 female  68 10.0122048
#> 138   male  68  9.3774658
#> 139 female  69  9.6570319
#> 140   male  69  9.0439681
#> 141 female  70  9.2950774
#> 142   male  70  8.7082368
#> 143 female  71  8.9286658
#> 144   male  71  8.3630656
#> 145 female  72  8.5517472
#> 146   male  72  8.0206571
#> 147 female  73  8.1714270
#> 148   male  73  7.6700049
#> 149 female  74  7.7863309
#> 150   male  74  7.3156535
#> 151 female  75  7.3974600
#> 152   male  75  6.9651553
#> 153 female  76  7.0763622
#> 154   male  76  6.6521060
#> 155 female  77  6.7535405
#> 156   male  77  6.3335929
#> 157 female  78  6.4331890
#> 158   male  78  6.0154103
#> 159 female  79  6.1151025
#> 160   male  79  5.7079492
#> 161 female  80  5.8067808
#> 162   male  80  5.4070488
#> 163 female  81  5.4988429
#> 164   male  81  5.1133837
#> 165 female  82  5.1920219
#> 166   male  82  4.8186746
#> 167 female  83  4.8907316
#> 168   male  83  4.5301025
#> 169 female  84  4.5974218
#> 170   male  84  4.2529005
#> 171 female  85  4.3139769
#> 172   male  85  3.9902609
#> 173 female  86  4.0385381
#> 174   male  86  3.7339263
#> 175 female  87  3.7782854
#> 176   male  87  3.4884047
#> 177 female  88  3.5278451
#> 178   male  88  3.2489725
#> 179 female  89  3.2887341
#> 180   male  89  3.0256335
#> 181 female  90  3.0611909
#> 182   male  90  2.8174898
#> 183 female  91  2.8505943
#> 184   male  91  2.6146384
#> 185 female  92  2.6495050
#> 186   male  92  2.4320293
#> 187 female  93  2.4648856
#> 188   male  93  2.2588318
#> 189 female  94  2.2843605
#> 190   male  94  2.1002289
#> 191 female  95  2.1218409
#> 192   male  95  1.9674125
#> 193 female  96  1.9713630
#> 194   male  96  1.8348089
#> 195 female  97  1.8319667
#> 196   male  97  1.7127394
#> 197 female  98  1.7024866
#> 198   male  98  1.5999192
#> 199 female  99  1.5811976
#> 200   male  99  1.4944831
#> 201 female 100  1.4654274
#> 202   male 100  1.3935113
#> 203 female 101  1.3571087
#> 204   male 101  1.2988387
#> 205 female 102  1.2560298
#> 206   male 102  1.2102666
#> 207 female 103  1.1619628
#> 208   male 103  1.1275895
#> 209 female 104  1.0746674
#> 210   male 104  1.0505970
#> 211 female 105  0.9938941
#> 212   male 105  0.9790758
#> 213 female 106  0.9193875
#> 214   male 106  0.9128116
#> 215 female 107  0.8508886
#> 216   male 107  0.8515909
#> 217 female 108  0.7881381
#> 218   male 108  0.7952019
#> 219 female 109  0.7308779
#> 220   male 109  0.7434361
#> 221 female 110  0.6788534
#> 222   male 110  0.6960889
#> 223 female 111  0.6318144
#> 224   male 111  0.6529601
#> 225 female 112  0.5895157
#> 226   male 112  0.6138541
#> 227 female 113  0.5517172
#> 228   male 113  0.5785795
#> 229 female 114  0.5181828
#> 230   male 114  0.5469485
#> 231 female 115  0.4886791
#> 232   male 115  0.5187756
#> 233 female 116  0.4629713
#> 234   male 116  0.4938733
#> 235 female 117  0.4408081
#> 236   male 117  0.4720306
#> 237 female 118  0.4217884
#> 238   male 118  0.4528154
#> 239 female 119  0.4036805
#> 240   male 119  0.4332804
#> 241 female 120  0.3550000
#> 242   male 120  0.3750000


#Output a table of dQALY values for all ages/genders, specifying year, country and
#selecting a set of norms other than the default set for that country
calculate_dQALY(country = "United Kingdom", year = 2019,
                norms = package_norms(country, id ="janssen_euvas"))
#>        sex age      dQALY
#> 1   female   0 25.0868719
#> 2     male   0 24.8310237
#> 3   female   1 25.0871971
#> 4     male   1 24.8421698
#> 5   female   2 25.0046754
#> 6     male   2 24.7507589
#> 7   female   3 24.9169588
#> 8     male   3 24.6538644
#> 9   female   4 24.8248932
#> 10    male   4 24.5520625
#> 11  female   5 24.7288393
#> 12    male   5 24.4464398
#> 13  female   6 24.6296677
#> 14    male   6 24.3373608
#> 15  female   7 24.5272671
#> 16    male   7 24.2249493
#> 17  female   8 24.4205256
#> 18    male   8 24.1073620
#> 19  female   9 24.3097937
#> 20    male   9 23.9856531
#> 21  female  10 24.1949336
#> 22    male  10 23.8596782
#> 23  female  11 24.0767855
#> 24    male  11 23.7297718
#> 25  female  12 23.9540048
#> 26    male  12 23.5955501
#> 27  female  13 23.8266774
#> 28    male  13 23.4573376
#> 29  female  14 23.6960973
#> 30    male  14 23.3149860
#> 31  female  15 23.5614154
#> 32    male  15 23.1669218
#> 33  female  16 23.4220042
#> 34    male  16 23.0143635
#> 35  female  17 23.2781732
#> 36    male  17 22.8580774
#> 37  female  18 23.1299971
#> 38    male  18 22.6981418
#> 39  female  19 22.9787218
#> 40    male  19 22.5344018
#> 41  female  20 22.8207144
#> 42    male  20 22.3664675
#> 43  female  21 22.6571456
#> 44    male  21 22.1950735
#> 45  female  22 22.4882793
#> 46    male  22 22.0173581
#> 47  female  23 22.3143778
#> 48    male  23 21.8333233
#> 49  female  24 22.1336663
#> 50    male  24 21.6420807
#> 51  female  25 21.9472616
#> 52    male  25 21.4455786
#> 53  female  26 21.7662611
#> 54    male  26 21.2551564
#> 55  female  27 21.5799854
#> 56    male  27 21.0577339
#> 57  female  28 21.3882293
#> 58    male  28 20.8545588
#> 59  female  29 21.1890463
#> 60    male  29 20.6449788
#> 61  female  30 20.9839030
#> 62    male  30 20.4289568
#> 63  female  31 20.7725678
#> 64    male  31 20.2064471
#> 65  female  32 20.5541690
#> 66    male  32 19.9765768
#> 67  female  33 20.3282393
#> 68    male  33 19.7388652
#> 69  female  34 20.0951244
#> 70    male  34 19.4948189
#> 71  female  35 19.8559735
#> 72    male  35 19.2411971
#> 73  female  36 19.6257079
#> 74    male  36 18.9993668
#> 75  female  37 19.3880413
#> 76    male  37 18.7484126
#> 77  female  38 19.1454366
#> 78    male  38 18.4927548
#> 79  female  39 18.8933677
#> 80    male  39 18.2281761
#> 81  female  40 18.6341909
#> 82    male  40 17.9554466
#> 83  female  41 18.3677866
#> 84    male  41 17.6751317
#> 85  female  42 18.0923501
#> 86    male  42 17.3852727
#> 87  female  43 17.8091840
#> 88    male  43 17.0870764
#> 89  female  44 17.5161414
#> 90    male  44 16.7808470
#> 91  female  45 17.2158591
#> 92    male  45 16.4677060
#> 93  female  46 16.9654393
#> 94    male  46 16.2049270
#> 95  female  47 16.7084428
#> 96    male  47 15.9344311
#> 97  female  48 16.4430304
#> 98    male  48 15.6565003
#> 99  female  49 16.1698569
#> 100   male  49 15.3699671
#> 101 female  50 15.8880797
#> 102   male  50 15.0772279
#> 103 female  51 15.6005363
#> 104   male  51 14.7787796
#> 105 female  52 15.3055826
#> 106   male  52 14.4719462
#> 107 female  53 15.0009615
#> 108   male  53 14.1555409
#> 109 female  54 14.6864052
#> 110   male  54 13.8317989
#> 111 female  55 14.3651758
#> 112   male  55 13.4999215
#> 113 female  56 14.0822821
#> 114   male  56 13.2048247
#> 115 female  57 13.7926658
#> 116   male  57 12.9075349
#> 117 female  58 13.4963131
#> 118   male  58 12.6006253
#> 119 female  59 13.1923600
#> 120   male  59 12.2885373
#> 121 female  60 12.8829878
#> 122   male  60 11.9718016
#> 123 female  61 12.5663735
#> 124   male  61 11.6479788
#> 125 female  62 12.2417210
#> 126   male  62 11.3186514
#> 127 female  63 11.9169660
#> 128   male  63 10.9877771
#> 129 female  64 11.5795194
#> 130   male  64 10.6487735
#> 131 female  65 11.2359088
#> 132   male  65 10.3045008
#> 133 female  66 10.9058165
#> 134   male  66  9.9766373
#> 135 female  67 10.5661750
#> 136   male  67  9.6438464
#> 137 female  68 10.2208375
#> 138   male  68  9.3062339
#> 139 female  69  9.8699704
#> 140   male  69  8.9638736
#> 141 female  70  9.5127315
#> 142   male  70  8.6186844
#> 143 female  71  9.1515548
#> 144   male  71  8.2634627
#> 145 female  72  8.7803048
#> 146   male  72  7.9101881
#> 147 female  73  8.4063452
#> 148   male  73  7.5478900
#> 149 female  74  8.0283644
#> 150   male  74  7.1809314
#> 151 female  75  7.6475150
#> 152   male  75  6.8165653
#> 153 female  76  7.3155632
#> 154   male  76  6.5101944
#> 155 female  77  6.9818292
#> 156   male  77  6.1984763
#> 157 female  78  6.6506490
#> 158   male  78  5.8870816
#> 159 female  79  6.3218101
#> 160   male  79  5.5861797
#> 161 female  80  6.0030664
#> 162   male  80  5.2916984
#> 163 female  81  5.6847192
#> 164   male  81  5.0042981
#> 165 female  82  5.3675269
#> 166   male  82  4.7158762
#> 167 female  83  5.0560521
#> 168   male  83  4.4334603
#> 169 female  84  4.7528276
#> 170   male  84  4.1621719
#> 171 female  85  4.4598014
#> 172   male  85  3.9051353
#> 173 female  86  4.1750521
#> 174   male  86  3.6542692
#> 175 female  87  3.9060021
#> 176   male  87  3.4139854
#> 177 female  88  3.6470962
#> 178   male  88  3.1796611
#> 179 female  89  3.3999026
#> 180   male  89  2.9610867
#> 181 female  90  3.1646678
#> 182   male  90  2.7573834
#> 183 female  91  2.9469524
#> 184   male  91  2.5588594
#> 185 female  92  2.7390658
#> 186   male  92  2.3801460
#> 187 female  93  2.5482057
#> 188   male  93  2.2106433
#> 189 female  94  2.3615783
#> 190   male  94  2.0554240
#> 191 female  95  2.1935651
#> 192   male  95  1.9254411
#> 193 female  96  2.0380006
#> 194   male  96  1.7956664
#> 195 female  97  1.8938924
#> 196   male  97  1.6762010
#> 197 female  98  1.7600355
#> 198   male  98  1.5657875
#> 199 female  99  1.6346466
#> 200   male  99  1.4626008
#> 201 female 100  1.5149630
#> 202   male 100  1.3637831
#> 203 female 101  1.4029828
#> 204   male 101  1.2711301
#> 205 female 102  1.2984871
#> 206   male 102  1.1844476
#> 207 female 103  1.2012404
#> 208   male 103  1.1035343
#> 209 female 104  1.1109942
#> 210   male 104  1.0281843
#> 211 female 105  1.0274906
#> 212   male 105  0.9581888
#> 213 female 106  0.9504654
#> 214   male 106  0.8933383
#> 215 female 107  0.8796511
#> 216   male 107  0.8334236
#> 217 female 108  0.8147794
#> 218   male 108  0.7782376
#> 219 female 109  0.7555836
#> 220   male 109  0.7275761
#> 221 female 110  0.7018006
#> 222   male 110  0.6812390
#> 223 female 111  0.6531716
#> 224   male 111  0.6390303
#> 225 female 112  0.6094430
#> 226   male 112  0.6007585
#> 227 female 113  0.5703668
#> 228   male 113  0.5662364
#> 229 female 114  0.5356988
#> 230   male 114  0.5352803
#> 231 female 115  0.5051978
#> 232   male 115  0.5077084
#> 233 female 116  0.4786210
#> 234   male 116  0.4833373
#> 235 female 117  0.4557086
#> 236   male 117  0.4619606
#> 237 female 118  0.4360460
#> 238   male 118  0.4431554
#> 239 female 119  0.4173260
#> 240   male 119  0.4240371
#> 241 female 120  0.3670000
#> 242   male 120  0.3670000


#Output a table of dQALY values for all ages/genders, specifying year & country,
#with user-supplied norms
my_norms <- data.frame(sex = c(rep("male", 3), rep("female", 3)),
                       lower = c(0, 20, 90),
                       upper = c(19, 89, 150),
                       avg_hrqol = c(1, 0.85, 0.67, 0.99, 0.4, 0.2))
calculate_dQALY(country = "United Kingdom", year = 2019, norms = my_norms)
#>        sex age      dQALY
#> 1   female   0 19.6619068
#> 2     male   0 25.3603037
#> 3   female   1 19.3946916
#> 4     male   1 25.3238798
#> 5   female   2 19.0535510
#> 6     male   2 25.1811255
#> 7   female   3 18.6986568
#> 8     male   3 25.0310414
#> 9   female   4 18.3303440
#> 10    male   4 24.8741592
#> 11  female   5 17.9485483
#> 12    male   5 24.7115208
#> 13  female   6 17.5535428
#> 14    male   6 24.5434289
#> 15  female   7 17.1448559
#> 16    male   7 24.3699376
#> 17  female   8 16.7213099
#> 18    male   8 24.1891208
#> 19  female   9 16.2827455
#> 20    male   9 24.0019660
#> 21  female  10 15.8286453
#> 22    male  10 23.8082511
#> 23  female  11 15.3591088
#> 24    male  11 23.6082287
#> 25  female  12 14.8727969
#> 26    male  12 23.4014302
#> 27  female  13 14.3692901
#> 28    male  13 23.1880876
#> 29  female  14 13.8488577
#> 30    male  14 22.9679584
#> 31  female  15 13.3104381
#> 32    male  15 22.7393950
#> 33  female  16 12.7531125
#> 34    male  16 22.5034965
#> 35  female  17 12.1764709
#> 36    male  17 22.2609019
#> 37  female  18 11.5799320
#> 38    male  18 22.0115660
#> 39  female  19 10.9634482
#> 40    male  19 21.7552102
#> 41  female  20 10.3245777
#> 42    male  20 21.4913242
#> 43  female  21 10.2739291
#> 44    male  21 21.3757659
#> 45  female  22 10.2217064
#> 46    male  22 21.2558802
#> 47  female  23 10.1680596
#> 48    male  23 21.1317314
#> 49  female  24 10.1122117
#> 50    male  24 21.0025248
#> 51  female  25 10.0547042
#> 52    male  25 20.8702194
#> 53  female  26  9.9949650
#> 54    male  26 20.7338391
#> 55  female  27  9.9336277
#> 56    male  27 20.5923890
#> 57  female  28  9.8706298
#> 58    male  28 20.4471534
#> 59  female  29  9.8051051
#> 60    male  29 20.2975651
#> 61  female  30  9.7377639
#> 62    male  30 20.1436617
#> 63  female  31  9.6685350
#> 64    male  31 19.9854777
#> 65  female  32  9.5970506
#> 66    male  32 19.8222325
#> 67  female  33  9.5231304
#> 68    male  33 19.6535335
#> 69  female  34  9.4469763
#> 70    male  34 19.4809710
#> 71  female  35  9.3691730
#> 72    male  35 19.3014059
#> 73  female  36  9.2885050
#> 74    male  36 19.1187078
#> 75  female  37  9.2053424
#> 76    male  37 18.9290198
#> 77  female  38  9.1208955
#> 78    male  38 18.7368905
#> 79  female  39  9.0330543
#> 80    male  39 18.5381558
#> 81  female  40  8.9429854
#> 82    male  40 18.3336934
#> 83  female  41  8.8506811
#> 84    male  41 18.1241894
#> 85  female  42  8.7553233
#> 86    male  42 17.9077524
#> 87  female  43  8.6575938
#> 88    male  43 17.6857420
#> 89  female  44  8.5565067
#> 90    male  44 17.4586105
#> 91  female  45  8.4534087
#> 92    male  45 17.2276800
#> 93  female  46  8.3479299
#> 94    male  46 16.9923381
#> 95  female  47  8.2398646
#> 96    male  47 16.7504134
#> 97  female  48  8.1283347
#> 98    male  48 16.5022720
#> 99  female  49  8.0136924
#> 100   male  49 16.2467588
#> 101 female  50  7.8955519
#> 102   male  50 15.9864883
#> 103 female  51  7.7753584
#> 104   male  51 15.7220891
#> 105 female  52  7.6523357
#> 106   male  52 15.4508243
#> 107 female  53  7.5253972
#> 108   male  53 15.1715306
#> 109 female  54  7.3944483
#> 110   male  54 14.8867157
#> 111 female  55  7.2611782
#> 112   male  55 14.5956583
#> 113 female  56  7.1248169
#> 114   male  56 14.2965888
#> 115 female  57  6.9853146
#> 116   male  57 13.9959681
#> 117 female  58  6.8426791
#> 118   male  58 13.6858027
#> 119 female  59  6.6964880
#> 120   male  59 13.3709674
#> 121 female  60  6.5478662
#> 122   male  60 13.0521099
#> 123 female  61  6.3959080
#> 124   male  61 12.7266489
#> 125 female  62  6.2402295
#> 126   male  62 12.3963953
#> 127 female  63  6.0849023
#> 128   male  63 12.0657878
#> 129 female  64  5.9235324
#> 130   male  64 11.7277244
#> 131 female  65  5.7594829
#> 132   male  65 11.3854725
#> 133 female  66  5.5927602
#> 134   male  66 11.0412796
#> 135 female  67  5.4212515
#> 136   male  67 10.6925303
#> 137 female  68  5.2469418
#> 138   male  68 10.3394310
#> 139 female  69  5.0699274
#> 140   male  69  9.9821683
#> 141 female  70  4.8897881
#> 142   male  70  9.6230042
#> 143 female  71  4.7077898
#> 144   male  71  9.2540408
#> 145 female  72  4.5207934
#> 146   male  72  8.8888518
#> 147 female  73  4.3326084
#> 148   male  73  8.5153457
#> 149 female  74  4.1425857
#> 150   male  74  8.1386679
#> 151 female  75  3.9513517
#> 152   male  75  7.7673674
#> 153 female  76  3.7581292
#> 154   male  76  7.4039406
#> 155 female  77  3.5626697
#> 156   male  77  7.0333889
#> 157 female  78  3.3669742
#> 158   male  78  6.6619781
#> 159 female  79  3.1706503
#> 160   male  79  6.3009611
#> 161 female  80  2.9772153
#> 162   male  80  5.9453753
#> 163 female  81  2.7813610
#> 164   male  81  5.5955181
#> 165 female  82  2.5829257
#> 166   male  82  5.2417779
#> 167 female  83  2.3833948
#> 168   male  83  4.8913006
#> 169 female  84  2.1829608
#> 170   male  84  4.5487421
#> 171 female  85  1.9811455
#> 172   male  85  4.2160810
#> 173 female  86  1.7752448
#> 174   male  86  3.8826430
#> 175 female  87  1.5658903
#> 176   male  87  3.5505835
#> 177 female  88  1.3472121
#> 178   male  88  3.2114498
#> 179 female  89  1.1149649
#> 180   male  89  2.8699224
#> 181 female  90  0.8623073
#> 182   male  90  2.5169576
#> 183 female  91  0.8029843
#> 184   male  91  2.3357436
#> 185 female  92  0.7463394
#> 186   male  92  2.1726129
#> 187 female  93  0.6943340
#> 188   male  93  2.0178897
#> 189 female  94  0.6434818
#> 190   male  94  1.8762044
#> 191 female  95  0.5977017
#> 192   male  95  1.7575552
#> 193 female  96  0.5553135
#> 194   male  96  1.6390960
#> 195 female  97  0.5160470
#> 196   male  97  1.5300472
#> 197 female  98  0.4795737
#> 198   male  98  1.4292611
#> 199 female  99  0.4454078
#> 200   male  99  1.3350716
#> 201 female 100  0.4127964
#> 202   male 100  1.2448701
#> 203 female 101  0.3822842
#> 204   male 101  1.1602959
#> 205 female 102  0.3538112
#> 206   male 102  1.0811715
#> 207 female 103  0.3273135
#> 208   male 103  1.0073133
#> 209 female 104  0.3027232
#> 210   male 104  0.9385333
#> 211 female 105  0.2799702
#> 212   male 105  0.8746410
#> 213 female 106  0.2589824
#> 214   male 106  0.8154451
#> 215 female 107  0.2396869
#> 216   male 107  0.7607545
#> 217 female 108  0.2220107
#> 218   male 108  0.7103804
#> 219 female 109  0.2058811
#> 220   male 109  0.6641363
#> 221 female 110  0.1912263
#> 222   male 110  0.6218394
#> 223 female 111  0.1779759
#> 224   male 111  0.5833110
#> 225 female 112  0.1660608
#> 226   male 112  0.5483763
#> 227 female 113  0.1554133
#> 228   male 113  0.5168643
#> 229 female 114  0.1459670
#> 230   male 114  0.4886073
#> 231 female 115  0.1376561
#> 232   male 115  0.4634395
#> 233 female 116  0.1304144
#> 234   male 116  0.4411935
#> 235 female 117  0.1241713
#> 236   male 117  0.4216806
#> 237 female 118  0.1188136
#> 238   male 118  0.4045151
#> 239 female 119  0.1137128
#> 240   male 119  0.3870639
#> 241 female 120  0.1000000
#> 242   male 120  0.3350000


#Output a table of dQALY values for all ages/genders, with user-specified norms and life tables
my_life_table <- data.frame(sex = c(rep("male", 101), rep("female", 101)),
                            age = c(0:100, 0:100),
                            q = c(seq(0, 1, 0.01)))

calculate_dQALY(life_table = my_life_table, norms = my_norms)
#>        sex age      dQALY
#> 1     male   0 10.0118522
#> 2     male   1  9.3272671
#> 3     male   2  8.7110065
#> 4     male   3  8.1543283
#> 5     male   4  7.6497472
#> 6     male   5  7.1908212
#> 7     male   6  6.7719736
#> 8     male   7  6.3883433
#> 9     male   8  6.0356562
#> 10    male   9  5.7101132
#> 11    male  10  5.4082881
#> 12    male  11  5.1270313
#> 13    male  12  4.8633735
#> 14    male  13  4.6144223
#> 15    male  14  4.3772438
#> 16    male  15  4.1487178
#> 17    male  16  3.9253505
#> 18    male  17  3.7030211
#> 19    male  18  3.4766287
#> 20    male  19  3.2395863
#> 21    male  20  2.9830824
#> 22    male  21  2.8696442
#> 23    male  22  2.7629183
#> 24    male  23  2.6623627
#> 25    male  24  2.5674892
#> 26    male  25  2.4778570
#> 27    male  26  2.3930677
#> 28    male  27  2.3127602
#> 29    male  28  2.2366069
#> 30    male  29  2.1643099
#> 31    male  30  2.0955979
#> 32    male  31  2.0302233
#> 33    male  32  1.9679599
#> 34    male  33  1.9086008
#> 35    male  34  1.8519560
#> 36    male  35  1.7978515
#> 37    male  36  1.7461270
#> 38    male  37  1.6966350
#> 39    male  38  1.6492396
#> 40    male  39  1.6038154
#> 41    male  40  1.5602462
#> 42    male  41  1.5184247
#> 43    male  42  1.4782513
#> 44    male  43  1.4396338
#> 45    male  44  1.4024863
#> 46    male  45  1.3667292
#> 47    male  46  1.3322881
#> 48    male  47  1.2990939
#> 49    male  48  1.2670820
#> 50    male  49  1.2361921
#> 51    male  50  1.2063678
#> 52    male  51  1.1775564
#> 53    male  52  1.1497085
#> 54    male  53  1.1227777
#> 55    male  54  1.0967206
#> 56    male  55  1.0714963
#> 57    male  56  1.0470665
#> 58    male  57  1.0233951
#> 59    male  58  1.0004480
#> 60    male  59  0.9781932
#> 61    male  60  0.9566006
#> 62    male  61  0.9356416
#> 63    male  62  0.9152893
#> 64    male  63  0.8955182
#> 65    male  64  0.8763042
#> 66    male  65  0.8576246
#> 67    male  66  0.8394578
#> 68    male  67  0.8217833
#> 69    male  68  0.8045817
#> 70    male  69  0.7878347
#> 71    male  70  0.7715246
#> 72    male  71  0.7556350
#> 73    male  72  0.7401501
#> 74    male  73  0.7250547
#> 75    male  74  0.7103346
#> 76    male  75  0.6959762
#> 77    male  76  0.6819665
#> 78    male  77  0.6682932
#> 79    male  78  0.6549444
#> 80    male  79  0.6419089
#> 81    male  80  0.6291759
#> 82    male  81  0.6167351
#> 83    male  82  0.6045768
#> 84    male  83  0.5926914
#> 85    male  84  0.5810697
#> 86    male  85  0.5697012
#> 87    male  86  0.5585630
#> 88    male  87  0.5475375
#> 89    male  88  0.5357117
#> 90    male  89  0.5150134
#> 91    male  90  0.4070692
#> 92    male  91  0.3991913
#> 93    male  92  0.3914745
#> 94    male  93  0.3839141
#> 95    male  94  0.3765054
#> 96    male  95  0.3692440
#> 97    male  96  0.3621254
#> 98    male  97  0.3551457
#> 99    male  98  0.3483007
#> 100   male  99  0.3415867
#> 101   male 100  0.3350000
#> 102 female   0  9.8101917
#> 103 female   1  9.1288984
#> 104 female   2  8.5140233
#> 105 female   3  7.9567455
#> 106 female   4  7.4494344
#> 107 female   5  6.9854246
#> 108 female   6  6.5588218
#> 109 female   7  6.1643298
#> 110 female   8  5.7970904
#> 111 female   9  5.4525267
#> 112 female  10  5.1261807
#> 113 female  11  4.8135328
#> 114 female  12  4.5097890
#> 115 female  13  4.2096143
#> 116 female  14  3.9067851
#> 117 female  15  3.5937187
#> 118 female  16  3.2608208
#> 119 female  17  2.8955613
#> 120 female  18  2.4811460
#> 121 female  19  1.9945788
#> 122 female  20  1.4038035
#> 123 female  21  1.3504208
#> 124 female  22  1.3001968
#> 125 female  23  1.2528766
#> 126 female  24  1.2082302
#> 127 female  25  1.1660504
#> 128 female  26  1.1261495
#> 129 female  27  1.0883577
#> 130 female  28  1.0525209
#> 131 female  29  1.0184988
#> 132 female  30  0.9861637
#> 133 female  31  0.9553992
#> 134 female  32  0.9260988
#> 135 female  33  0.8981651
#> 136 female  34  0.8715087
#> 137 female  35  0.8460478
#> 138 female  36  0.8217068
#> 139 female  37  0.7984165
#> 140 female  38  0.7761128
#> 141 female  39  0.7547366
#> 142 female  40  0.7342335
#> 143 female  41  0.7145528
#> 144 female  42  0.6956477
#> 145 female  43  0.6774747
#> 146 female  44  0.6599936
#> 147 female  45  0.6431667
#> 148 female  46  0.6269591
#> 149 female  47  0.6113383
#> 150 female  48  0.5962739
#> 151 female  49  0.5817375
#> 152 female  50  0.5677025
#> 153 female  51  0.5541442
#> 154 female  52  0.5410393
#> 155 female  53  0.5283660
#> 156 female  54  0.5161038
#> 157 female  55  0.5042336
#> 158 female  56  0.4927372
#> 159 female  57  0.4815977
#> 160 female  58  0.4707991
#> 161 female  59  0.4603262
#> 162 female  60  0.4501650
#> 163 female  61  0.4403019
#> 164 female  62  0.4307244
#> 165 female  63  0.4214203
#> 166 female  64  0.4123785
#> 167 female  65  0.4035881
#> 168 female  66  0.3950390
#> 169 female  67  0.3867216
#> 170 female  68  0.3786267
#> 171 female  69  0.3707457
#> 172 female  70  0.3630704
#> 173 female  71  0.3555930
#> 174 female  72  0.3483059
#> 175 female  73  0.3412022
#> 176 female  74  0.3342751
#> 177 female  75  0.3275182
#> 178 female  76  0.3209254
#> 179 female  77  0.3144909
#> 180 female  78  0.3082091
#> 181 female  79  0.3020748
#> 182 female  80  0.2960828
#> 183 female  81  0.2902283
#> 184 female  82  0.2845067
#> 185 female  83  0.2789135
#> 186 female  84  0.2734443
#> 187 female  85  0.2680925
#> 188 female  86  0.2628385
#> 189 female  87  0.2575563
#> 190 female  88  0.2512365
#> 191 female  89  0.2349144
#> 192 female  90  0.1215132
#> 193 female  91  0.1191616
#> 194 female  92  0.1168581
#> 195 female  93  0.1146012
#> 196 female  94  0.1123897
#> 197 female  95  0.1102221
#> 198 female  96  0.1080971
#> 199 female  97  0.1060136
#> 200 female  98  0.1039704
#> 201 female  99  0.1019662
#> 202 female 100  0.1000000


#Calculate dQALY values using a variable discount rate
rfun = function(x) ifelse(x < 31, 0.015, ifelse(x > 75, 0.0107, 0.0129))
calculate_dQALY(country = "United Kingdom", year = 2019, r = rfun)
#>        sex age      dQALY
#> 1   female   0 43.3454531
#> 2     male   0 42.2604265
#> 3   female   1 43.1462033
#> 4     male   1 42.0789832
#> 5   female   2 42.8034912
#> 6     male   2 41.7226884
#> 7   female   3 42.4527771
#> 8     male   3 41.3582837
#> 9   female   4 42.0957107
#> 10    male   4 40.9869560
#> 11  female   5 41.7330771
#> 12    male   5 40.6106970
#> 13  female   6 41.3664600
#> 14    male   6 40.2302211
#> 15  female   7 40.9957875
#> 16    male   7 39.8458519
#> 17  female   8 40.6193413
#> 18    male   8 39.4547096
#> 19  female   9 40.2378659
#> 20    male   9 39.0587001
#> 21  female  10 39.8512854
#> 22    male  10 38.6577383
#> 23  female  11 39.4611187
#> 24    male  11 38.2525117
#> 25  female  12 39.0652986
#> 26    male  12 37.8425425
#> 27  female  13 38.6641355
#> 28    male  13 37.4284952
#> 29  female  14 38.2598682
#> 30    male  14 37.0102690
#> 31  female  15 37.8512432
#> 32    male  15 36.5855367
#> 33  female  16 37.4373257
#> 34    male  16 36.1563206
#> 35  female  17 37.0187704
#> 36    male  17 35.7239609
#> 37  female  18 36.5958461
#> 38    male  18 35.2886928
#> 39  female  19 36.1706452
#> 40    male  19 34.8503897
#> 41  female  20 35.7376091
#> 42    male  20 34.4085755
#> 43  female  21 35.2988095
#> 44    male  21 33.9645041
#> 45  female  22 34.8548575
#> 46    male  22 33.5139561
#> 47  female  23 34.4063482
#> 48    male  23 33.0571742
#> 49  female  24 33.9507617
#> 50    male  24 32.5930698
#> 51  female  25 33.4900550
#> 52    male  25 32.1248194
#> 53  female  26 33.0325463
#> 54    male  26 31.6610852
#> 55  female  27 32.5704668
#> 56    male  27 31.1904922
#> 57  female  28 32.1037018
#> 58    male  28 30.7151291
#> 59  female  29 31.6295665
#> 60    male  29 30.2342518
#> 61  female  30 31.1505112
#> 62    male  30 29.7480396
#> 63  female  31 30.6664156
#> 64    male  31 29.2566587
#> 65  female  32 30.1762374
#> 66    male  32 28.7590930
#> 67  female  33 29.6795656
#> 68    male  33 28.2549288
#> 69  female  34 29.1771830
#> 70    male  34 27.7465817
#> 71  female  35 28.6710037
#> 72    male  35 27.2297162
#> 73  female  36 28.1776910
#> 74    male  36 26.7302576
#> 75  female  37 27.6785591
#> 76    male  37 26.2229288
#> 77  female  38 27.1773480
#> 78    male  38 25.7141655
#> 79  female  39 26.6678728
#> 80    male  39 25.1983145
#> 81  female  40 26.1537715
#> 82    male  40 24.6767437
#> 83  female  41 25.6351270
#> 84    male  41 24.1505008
#> 85  female  42 25.1097038
#> 86    male  42 23.6171964
#> 87  female  43 24.5796132
#> 88    male  43 23.0787821
#> 89  female  44 24.0421972
#> 90    male  44 22.5359423
#> 91  female  45 23.5013847
#> 92    male  45 21.9904260
#> 93  female  46 23.0170712
#> 94    male  46 21.5125544
#> 95  female  47 22.5288450
#> 96    male  47 21.0297563
#> 97  female  48 22.0344617
#> 98    male  48 20.5426424
#> 99  female  49 21.5350658
#> 100   male  49 20.0499277
#> 101 female  50 21.0297946
#> 102   male  50 19.5549692
#> 103 female  51 20.5226310
#> 104   male  51 19.0585724
#> 105 female  52 20.0115919
#> 106   male  52 18.5574772
#> 107 female  53 19.4939813
#> 108   male  53 18.0504333
#> 109 female  54 18.9697617
#> 110   male  54 17.5405495
#> 111 female  55 18.4434034
#> 112   male  55 17.0270304
#> 113 female  56 17.9536649
#> 114   male  56 16.5689504
#> 115 female  57 17.4606035
#> 116   male  57 16.1140232
#> 117 female  58 16.9643564
#> 118   male  58 15.6531079
#> 119 female  59 16.4640009
#> 120   male  59 15.1919459
#> 121 female  60 15.9624029
#> 122   male  60 14.7313166
#> 123 female  61 15.4574167
#> 124   male  61 14.2683724
#> 125 female  62 14.9482312
#> 126   male  62 13.8052386
#> 127 female  63 14.4445898
#> 128   male  63 13.3468470
#> 129 female  64 13.9312904
#> 130   male  64 12.8853365
#> 131 female  65 13.4164513
#> 132   male  65 12.4244005
#> 133 female  66 12.9306691
#> 134   male  66 11.9664909
#> 135 female  67 12.4392979
#> 136   male  67 11.5087621
#> 137 female  68 11.9470622
#> 138   male  68 11.0514794
#> 139 female  69 11.4542497
#> 140   male  69 10.5948768
#> 141 female  70 10.9599852
#> 142   male  70 10.1413520
#> 143 female  71 10.4671569
#> 144   male  71  9.6826393
#> 145 female  72  9.9688672
#> 146   male  72  9.2329727
#> 147 female  73  9.4736257
#> 148   male  73  8.7796972
#> 149 female  74  8.9799467
#> 150   male  74  8.3282030
#> 151 female  75  8.4891214
#> 152   male  75  7.8870830
#> 153 female  76  8.0711935
#> 154   male  76  7.4894214
#> 155 female  77  7.6566464
#> 156   male  77  7.0905014
#> 157 female  78  7.2501834
#> 158   male  78  6.6968806
#> 159 female  79  6.8514417
#> 160   male  79  6.3199416
#> 161 female  80  6.4685967
#> 162   male  80  5.9547496
#> 163 female  81  6.0909563
#> 164   male  81  5.6018013
#> 165 female  82  5.7192808
#> 166   male  82  5.2518896
#> 167 female  83  5.3583136
#> 168   male  83  4.9127782
#> 169 female  84  5.0105114
#> 170   male  84  4.5898876
#> 171 female  85  4.6776402
#> 172   male  85  4.2862811
#> 173 female  86  4.3574006
#> 174   male  86  3.9927677
#> 175 female  87  4.0572104
#> 176   male  87  3.7139516
#> 177 female  88  3.7709229
#> 178   male  88  3.4445842
#> 179 female  89  3.4998765
#> 180   male  89  3.1950285
#> 181 female  90  3.2440284
#> 182   male  90  2.9639493
#> 183 female  91  3.0087270
#> 184   male  91  2.7406898
#> 185 female  92  2.7857799
#> 186   male  92  2.5406906
#> 187 female  93  2.5822205
#> 188   male  93  2.3523047
#> 189 female  94  2.3848396
#> 190   male  94  2.1807273
#> 191 female  95  2.2079725
#> 192   male  95  2.0371795
#> 193 female  96  2.0450792
#> 194   male  96  1.8948631
#> 195 female  97  1.8949341
#> 196   male  97  1.7643991
#> 197 female  98  1.7561295
#> 198   male  98  1.6442919
#> 199 female  99  1.6267178
#> 200   male  99  1.5324840
#> 201 female 100  1.5038362
#> 202   male 100  1.4258926
#> 203 female 101  1.3893821
#> 204   male 101  1.3263372
#> 205 female 102  1.2830324
#> 206   male 102  1.2335373
#> 207 female 103  1.1844573
#> 208   male 103  1.1472125
#> 209 female 104  1.0933233
#> 210   male 104  1.0670839
#> 211 female 105  1.0092959
#> 212   male 105  0.9928762
#> 213 female 106  0.9320432
#> 214   male 106  0.9243190
#> 215 female 107  0.8612375
#> 216   male 107  0.8611483
#> 217 female 108  0.7965583
#> 218   male 108  0.8031071
#> 219 female 109  0.7376930
#> 220   male 109  0.7499468
#> 221 female 110  0.6843392
#> 222   male 110  0.7014269
#> 223 female 111  0.6362044
#> 224   male 111  0.6573159
#> 225 female 112  0.5930070
#> 226   male 112  0.6173903
#> 227 female 113  0.5544749
#> 228   male 113  0.5814345
#> 229 female 114  0.5203449
#> 230   male 114  0.5492398
#> 231 female 115  0.4903601
#> 232   male 115  0.5206021
#> 233 female 116  0.4642657
#> 234   male 116  0.4953181
#> 235 female 117  0.4417927
#> 236   male 117  0.4731617
#> 237 female 118  0.4225189
#> 238   male 118  0.4536788
#> 239 female 119  0.4041519
#> 240   male 119  0.4338448
#> 241 female 120  0.3550000
#> 242   male 120  0.3750000


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
