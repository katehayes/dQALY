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
#> 1     0 female 25.2178101
#> 2     0   male 24.9285659
#> 3     1 female 25.2185446
#> 4     1   male 24.9388650
#> 5     2 female 25.1344452
#> 6     2   male 24.8448668
#> 7     3 female 25.0452848
#> 8     3   male 24.7450620
#> 9     4 female 24.9516077
#> 10    4   male 24.6403951
#> 11    5 female 24.8539677
#> 12    5   male 24.5318078
#> 13    6 female 24.7530868
#> 14    6   male 24.4196480
#> 15    7 female 24.6489453
#> 16    7   male 24.3039296
#> 17    8 female 24.5403351
#> 18    8   male 24.1829672
#> 19    9 female 24.4276622
#> 20    9   male 24.0577032
#> 21   10 female 24.3108612
#> 22   10   male 23.9281803
#> 23   11 female 24.1906674
#> 24   11   male 23.7944784
#> 25   12 female 24.0657543
#> 26   12   male 23.6564373
#> 27   13 female 23.9361204
#> 28   13   male 23.5142751
#> 29   14 female 23.8032752
#> 30   14   male 23.3676713
#> 31   15 female 23.6661248
#> 32   15   male 23.2152091
#> 33   16 female 23.5241203
#> 34   16   male 23.0580246
#> 35   17 female 23.3775141
#> 36   17   male 22.8970005
#> 37   18 female 23.2266449
#> 38   18   male 22.7320803
#> 39   19 female 23.0723929
#> 40   19   male 22.5633823
#> 41   20 female 22.9114137
#> 42   20   male 22.3902481
#> 43   21 female 22.7448109
#> 44   21   male 22.2135758
#> 45   22 female 22.5727318
#> 46   22   male 22.0304722
#> 47   23 female 22.3954926
#> 48   23   male 21.8410171
#> 49   24 female 22.2112627
#> 50   24   male 21.6442222
#> 51   25 female 22.0212780
#> 52   25   male 21.4422794
#> 53   26 female 21.8345340
#> 54   26   male 21.2443090
#> 55   27 female 21.6422346
#> 56   27   male 21.0388719
#> 57   28 female 21.4442930
#> 58   28   male 20.8274920
#> 59   29 female 21.2387202
#> 60   29   male 20.6093763
#> 61   30 female 21.0268425
#> 62   30   male 20.3843984
#> 63   31 female 20.8084093
#> 64   31   male 20.1525378
#> 65   32 female 20.5826276
#> 66   32   male 19.9127431
#> 67   33 female 20.3489829
#> 68   33   male 19.6646217
#> 69   34 female 20.1078836
#> 70   34   male 19.4097292
#> 71   35 female 19.8605132
#> 72   35   male 19.1448642
#> 73   36 female 19.6249746
#> 74   36   male 18.8944813
#> 75   37 female 19.3819064
#> 76   37   male 18.6347079
#> 77   38 female 19.1337167
#> 78   38   male 18.3697332
#> 79   39 female 18.8757647
#> 80   39   male 18.0955005
#> 81   40 female 18.6104192
#> 82   40   male 17.8124618
#> 83   41 female 18.3376553
#> 84   41   male 17.5216864
#> 85   42 female 18.0554660
#> 86   42   male 17.2208503
#> 87   43 female 17.7653802
#> 88   43   male 16.9111231
#> 89   44 female 17.4652097
#> 90   44   male 16.5929250
#> 91   45 female 17.1574161
#> 92   45   male 16.2673007
#> 93   46 female 16.9034449
#> 94   46   male 16.0059988
#> 95   47 female 16.6427535
#> 96   47   male 15.7371397
#> 97   48 female 16.3734588
#> 98   48   male 15.4606336
#> 99   49 female 16.0963085
#> 100  49   male 15.1757215
#> 101  50 female 15.8103025
#> 102  50   male 14.8840500
#> 103  51 female 15.5185429
#> 104  51   male 14.5869281
#> 105  52 female 15.2190441
#> 106  52   male 14.2813486
#> 107  53 female 14.9100238
#> 108  53   male 13.9666231
#> 109  54 female 14.5907835
#> 110  54   male 13.6445938
#> 111  55 female 14.2646054
#> 112  55   male 13.3142619
#> 113  56 female 13.9713720
#> 114  56   male 13.0363103
#> 115  57 female 13.6711431
#> 116  57   male 12.7571589
#> 117  58 female 13.3638392
#> 118  58   male 12.4690452
#> 119  59 female 13.0485652
#> 120  59   male 12.1761502
#> 121  60 female 12.7270761
#> 122  60   male 11.8785034
#> 123  61 female 12.3985160
#> 124  61   male 11.5756663
#> 125  62 female 12.0610945
#> 126  62   male 11.2677954
#> 127  63 female 11.7229383
#> 128  63   male 10.9596905
#> 129  64 female 11.3719913
#> 130  64   male 10.6449542
#> 131  65 female 11.0139981
#> 132  65   male 10.3260732
#> 133  66 female 10.6802060
#> 134  66   male 10.0051339
#> 135  67 female 10.3367284
#> 136  67   male  9.6793957
#> 137  68 female  9.9871500
#> 138  68   male  9.3495059
#> 139  69 female  9.6321306
#> 140  69   male  9.0157023
#> 141  70 female  9.2702369
#> 142  70   male  8.6800581
#> 143  71 female  8.9039175
#> 144  71   male  8.3350736
#> 145  72 female  8.5255821
#> 146  72   male  7.9913347
#> 147  73 female  8.1454587
#> 148  73   male  7.6412831
#> 149  74 female  7.7602265
#> 150  74   male  7.2871871
#> 151  75 female  7.3721629
#> 152  75   male  6.9381026
#> 153  76 female  7.0488442
#> 154  76   male  6.6214843
#> 155  77 female  6.7262757
#> 156  77   male  6.3033557
#> 157  78 female  6.4054564
#> 158  78   male  5.9842623
#> 159  79 female  6.0873085
#> 160  79   male  5.6773780
#> 161  80 female  5.7782735
#> 162  80   male  5.3761890
#> 163  81 female  5.4693699
#> 164  81   male  5.0825869
#> 165  82 female  5.1631486
#> 166  82   male  4.7893930
#> 167  83 female  4.8614858
#> 168  83   male  4.5011273
#> 169  84 female  4.5679804
#> 170  84   male  4.2248444
#> 171  85 female  4.2839544
#> 172  85   male  3.9611711
#> 173  86 female  4.0094386
#> 174  86   male  3.7063844
#> 175  87 female  3.7495096
#> 176  87   male  3.4605001
#> 177  88 female  3.4989846
#> 178  88   male  3.2229746
#> 179  89 female  3.2655066
#> 180  89   male  3.0156428
#> 181  90 female  3.0424037
#> 182  90   male  2.8261664
#> 183  91 female  2.8330354
#> 184  91   male  2.6280678
#> 185  92 female  2.6345927
#> 186  92   male  2.4452112
#> 187  93 female  2.4514679
#> 188  93   male  2.2665861
#> 189  94 female  2.2725677
#> 190  94   male  2.1085391
#> 191  95 female  2.1100922
#> 192  95   male  1.9731954
#> 193  96 female  1.9696743
#> 194  96   male  1.8447719
#> 195  97 female  1.8423067
#> 196  97   male  1.7211025
#> 197  98 female  1.7264110
#> 198  98   male  1.6169568
#> 199  99 female  1.6449263
#> 200  99   male  1.5472729
#> 201 100 female  1.5674123
#> 202 100   male  1.5008013
#> 203 101 female  1.4633009
#> 204 101   male  1.3876912
#> 205 102 female  1.3653444
#> 206 102   male  1.3033641
#> 207 103 female  1.2733705
#> 208 103   male  1.2239424
#> 209 104 female  1.1871977
#> 210 104   male  1.1492700
#> 211 105 female  1.1066371
#> 212 105   male  1.0791885
#> 213 106 female  1.0314944
#> 214 106   male  1.0135383
#> 215 107 female  0.9615718
#> 216 107   male  0.9521598
#> 217 108 female  0.8966701
#> 218 108   male  0.8948941
#> 219 109 female  0.8365896
#> 220 109   male  0.8415840
#> 221 110 female  0.7811320
#> 222 110   male  0.7920744
#> 223 111 female  0.7301015
#> 224 111   male  0.7462131
#> 225 112 female  0.6833054
#> 226 112   male  0.7038512
#> 227 113 female  0.6405548
#> 228 113   male  0.6648425
#> 229 114 female  0.6016639
#> 230 114   male  0.6290433
#> 231 115 female  0.5664465
#> 232 115   male  0.5963068
#> 233 116 female  0.5346980
#> 234 116   male  0.5664594
#> 235 117 female  0.5060923
#> 236 117   male  0.5391659
#> 237 118 female  0.4795160
#> 238 118   male  0.5130863
#> 239 119 female  0.4480659
#> 240 119   male  0.4798661
#> 241 120 female  0.3550000
#> 242 120   male  0.3750000


#Output a table of dQALY values for all ages/genders, specifying year, country and
#selecting a set of norms other than the default set for that country
calculate_dQALY(country = "United Kingdom", year = 2019,
                norms = package_norms(country, id ="janssen_euvas"))
#>     age    sex      dQALY
#> 1     0 female 25.0844222
#> 2     0   male 24.8251033
#> 3     1 female 25.0862186
#> 4     1   male 24.8375366
#> 5     2 female 25.0036657
#> 6     2   male 24.7461776
#> 7     3 female 24.9161171
#> 8     3   male 24.6491148
#> 9     4 female 24.8241156
#> 10    4   male 24.5472914
#> 11    5 female 24.7282134
#> 12    5   male 24.4416484
#> 13    6 female 24.6291304
#> 14    6   male 24.3325354
#> 15    7 female 24.5268484
#> 16    7   male 24.2199693
#> 17    8 female 24.4201670
#> 18    8   male 24.1022739
#> 19    9 female 24.3094919
#> 20    9   male 23.9803916
#> 21   10 female 24.1947595
#> 22   10   male 23.8543684
#> 23   11 female 24.0767035
#> 24   11   male 23.7242880
#> 25   12 female 23.9540055
#> 26   12   male 23.5899943
#> 27   13 female 23.8266660
#> 28   13   male 23.4517090
#> 29   14 female 23.6961894
#> 30   14   male 23.3091170
#> 31   15 female 23.5614893
#> 32   15   male 23.1608091
#> 33   16 female 23.4220213
#> 34   16   male 23.0079234
#> 35   17 female 23.2780389
#> 36   17   male 22.8513457
#> 37   18 female 23.1298820
#> 38   18   male 22.6910250
#> 39   19 female 22.9784297
#> 40   19   male 22.5270854
#> 41   20 female 22.8203542
#> 42   20   male 22.3588757
#> 43   21 female 22.6567570
#> 44   21   male 22.1872991
#> 45   22 female 22.4877879
#> 46   22   male 22.0094726
#> 47   23 female 22.3137649
#> 48   23   male 21.8254822
#> 49   24 female 22.1328671
#> 50   24   male 21.6343467
#> 51   25 female 21.9463294
#> 52   25   male 21.4382639
#> 53   26 female 21.7652255
#> 54   26   male 21.2484330
#> 55   27 female 21.5787619
#> 56   27   male 21.0514255
#> 57   28 female 21.3868587
#> 58   28   male 20.8487769
#> 59   29 female 21.1875394
#> 60   29   male 20.6397054
#> 61   30 female 20.9821337
#> 62   30   male 20.4240967
#> 63   31 female 20.7703995
#> 64   31   male 20.2019433
#> 65   32 female 20.5515534
#> 66   32   male 19.9722050
#> 67   33 female 20.3250896
#> 68   33   male 19.7345019
#> 69   34 female 20.0914248
#> 70   34   male 19.4904098
#> 71   35 female 19.8517510
#> 72   35   male 19.2367307
#> 73   36 female 19.6210771
#> 74   36   male 18.9948461
#> 75   37 female 19.3830467
#> 76   37   male 18.7438763
#> 77   38 female 19.1400748
#> 78   38   male 18.4880490
#> 79   39 female 18.8875271
#> 80   39   male 18.2232988
#> 81   40 female 18.6277806
#> 82   40   male 17.9500961
#> 83   41 female 18.3608187
#> 84   41   male 17.6695361
#> 85   42 female 18.0846408
#> 86   42   male 17.3792942
#> 87   43 female 17.8007867
#> 88   43   male 17.0805697
#> 89   44 female 17.5070740
#> 90   44   male 16.7738092
#> 91   45 female 17.2059801
#> 92   45   male 16.4600939
#> 93   46 female 16.9548177
#> 94   46   male 16.1966851
#> 95   47 female 16.6970458
#> 96   47   male 15.9256668
#> 97   48 female 16.4307807
#> 98   48   male 15.6469499
#> 99   49 female 16.1567788
#> 100  49   male 15.3597681
#> 101  50 female 15.8740424
#> 102  50   male 15.0657899
#> 103  51 female 15.5856933
#> 104  51   male 14.7663430
#> 105  52 female 15.2897461
#> 106  52   male 14.4583858
#> 107  53 female 14.9844185
#> 108  53   male 14.1412241
#> 109  54 female 14.6690169
#> 110  54   male 13.8167259
#> 111  55 female 14.3468503
#> 112  55   male 13.4838833
#> 113  56 female 14.0629876
#> 114  56   male 13.1878010
#> 115  57 female 13.7725179
#> 116  57   male 12.8899046
#> 117  58 female 13.4753855
#> 118  58   male 12.5823066
#> 119  59 female 13.1707148
#> 120  59   male 12.2691896
#> 121  60 female 12.8603065
#> 122  60   male 11.9505333
#> 123  61 female 12.5433308
#> 124  61   male 11.6258407
#> 125  62 female 12.2180133
#> 126  62   male 11.2952077
#> 127  63 female 11.8926302
#> 128  63   male 10.9633707
#> 129  64 female 11.5550088
#> 130  64   male 10.6238375
#> 131  65 female 11.2110278
#> 132  65   male 10.2790033
#> 133  66 female 10.8805684
#> 134  66   male  9.9506182
#> 135  67 female 10.5406592
#> 136  67   male  9.6170178
#> 137  68 female 10.1949863
#> 138  68   male  9.2788016
#> 139  69 female  9.8442640
#> 140  69   male  8.9361533
#> 141  70 female  9.4870761
#> 142  70   male  8.5910650
#> 143  71 female  9.1259836
#> 144  71   male  8.2360413
#> 145  72 female  8.7532712
#> 146  72   male  7.8814654
#> 147  73 female  8.3795065
#> 148  73   male  7.5197687
#> 149  74 female  8.0013806
#> 150  74   male  7.1530677
#> 151  75 female  7.6213628
#> 152  75   male  6.7900897
#> 153  76 female  7.2871150
#> 154  76   male  6.4802260
#> 155  77 female  6.9536428
#> 156  77   male  6.1688841
#> 157  78 female  6.6219789
#> 158  78   male  5.8565981
#> 159  79 female  6.2930767
#> 160  79   male  5.5562606
#> 161  80 female  5.9735954
#> 162  80   male  5.2614970
#> 163  81 female  5.6542500
#> 164  81   male  4.9741584
#> 165  82 female  5.3376776
#> 166  82   male  4.6872193
#> 167  83 female  5.0258177
#> 168  83   male  4.4051032
#> 169  84 female  4.7223910
#> 170  84   male  4.1347143
#> 171  85 female  4.4287641
#> 172  85   male  3.8766661
#> 173  86 female  4.1449689
#> 174  86   male  3.6273148
#> 175  87 female  3.8762536
#> 176  87   male  3.3866761
#> 177  88 female  3.6172601
#> 178  88   male  3.1542178
#> 179  89 female  3.3758899
#> 180  89   male  2.9513091
#> 181  90 female  3.1452455
#> 182  90   male  2.7658748
#> 183  91 female  2.9287999
#> 184  91   male  2.5720024
#> 185  92 female  2.7236493
#> 186  92   male  2.3930466
#> 187  93 female  2.5343345
#> 188  93   male  2.2182322
#> 189  94 female  2.3493869
#> 190  94   male  2.0635569
#> 191  95 female  2.1814193
#> 192  95   male  1.9311006
#> 193  96 female  2.0362548
#> 194  96   male  1.8054167
#> 195  97 female  1.9045819
#> 196  97   male  1.6843856
#> 197  98 female  1.7847686
#> 198  98   male  1.5824617
#> 199  99 female  1.7005295
#> 200  99   male  1.5142644
#> 201 100 female  1.6203953
#> 202 100   male  1.4687842
#> 203 101 female  1.5127646
#> 204 101   male  1.3580871
#> 205 102 female  1.4114969
#> 206 102   male  1.2755590
#> 207 103 female  1.3164140
#> 208 103   male  1.1978316
#> 209 104 female  1.2273284
#> 210 104   male  1.1247522
#> 211 105 female  1.1440445
#> 212 105   male  1.0561658
#> 213 106 female  1.0663618
#> 214 106   male  0.9919161
#> 215 107 female  0.9940757
#> 216 107   male  0.9318471
#> 217 108 female  0.9269801
#> 218 108   male  0.8758031
#> 219 109 female  0.8648687
#> 220 109   male  0.8236302
#> 221 110 female  0.8075365
#> 222 110   male  0.7751768
#> 223 111 female  0.7547810
#> 224 111   male  0.7302939
#> 225 112 female  0.7064031
#> 226 112   male  0.6888357
#> 227 113 female  0.6622074
#> 228 113   male  0.6506592
#> 229 114 female  0.6220018
#> 230 114   male  0.6156237
#> 231 115 female  0.5855940
#> 232 115   male  0.5835856
#> 233 116 female  0.5527723
#> 234 116   male  0.5543749
#> 235 117 female  0.5231997
#> 236 117   male  0.5276637
#> 237 118 female  0.4957250
#> 238 118   male  0.5021405
#> 239 119 female  0.4632118
#> 240 119   male  0.4696290
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
#> 1     0 female 19.6601487
#> 2     0   male 25.3542436
#> 3     1 female 19.3940845
#> 4     1   male 25.3191323
#> 5     2 female 19.0529251
#> 6     2   male 25.1764299
#> 7     3 female 18.6981628
#> 8     3   male 25.0261734
#> 9     4 female 18.3299024
#> 10    4   male 24.8692677
#> 11    5 female 17.9482223
#> 12    5   male 24.7066066
#> 13    6 female 17.5532848
#> 14    6   male 24.5384776
#> 15    7 female 17.1446860
#> 16    7   male 24.3648274
#> 17    8 female 16.7211857
#> 18    8   male 24.1838982
#> 19    9 female 16.2826640
#> 20    9   male 23.9965652
#> 21   10 female 15.8286524
#> 22   10   male 23.8027972
#> 23   11 female 15.3591797
#> 24   11   male 23.6025956
#> 25   12 female 14.8729241
#> 26   12   male 23.3957190
#> 27   13 female 14.3694143
#> 28   13   male 23.1822970
#> 29   14 female 13.8490481
#> 30   14   male 22.9619223
#> 31   15 female 13.3106229
#> 32   15   male 22.7331099
#> 33   16 female 12.7532707
#> 34   16   male 22.4968803
#> 35   17 female 12.1765535
#> 36   17   male 22.2539894
#> 37   18 female 11.5800298
#> 38   18   male 22.0042662
#> 39   19 female 10.9634648
#> 40   19   male 21.7477026
#> 41   20 female 10.3245680
#> 42   20   male 21.4835351
#> 43   21 female 10.2739119
#> 44   21   male 21.3677837
#> 45   22 female 10.2216482
#> 46   22   male 21.2477736
#> 47   23 female 10.1679519
#> 48   23   male 21.1236505
#> 49   24 female 10.1120251
#> 50   24   male 20.9945306
#> 51   25 female 10.0544631
#> 52   25   male 20.8626157
#> 53   26 female  9.9946830
#> 54   26   male 20.7267944
#> 55   27 female  9.9332663
#> 56   27   male 20.5857325
#> 57   28 female  9.8702077
#> 58   28   male 20.4409954
#> 59   29 female  9.8046274
#> 60   29   male 20.2918890
#> 61   30 female  9.7371724
#> 62   30   male 20.1383753
#> 63   31 female  9.6677663
#> 64   31   male 19.9805256
#> 65   32 female  9.5960819
#> 66   32   male 19.8173937
#> 67   33 female  9.5219210
#> 68   33   male 19.6486854
#> 69   34 female  9.4455183
#> 70   34   male 19.4760594
#> 71   35 female  9.3674789
#> 72   35   male 19.2964190
#> 73   36 female  9.2866286
#> 74   36   male 19.1136483
#> 75   37 female  9.2033049
#> 76   37   male 18.9239264
#> 77   38 female  9.1186956
#> 78   38   male 18.7316074
#> 79   39 female  9.0306387
#> 80   39   male 18.5326801
#> 81   40 female  8.9403106
#> 82   40   male 18.3277171
#> 83   41 female  8.8477529
#> 84   41   male 18.1179439
#> 85   42 female  8.7520527
#> 86   42   male 17.9010952
#> 87   43 female  8.6540064
#> 88   43   male 17.6785218
#> 89   44 female  8.5526111
#> 90   44   male 17.4508218
#> 91   45 female  8.4491353
#> 92   45   male 17.2192756
#> 93   46 female  8.3433128
#> 94   46   male 16.9832578
#> 95   47 female  8.2348882
#> 96   47   male 16.7407687
#> 97   48 female  8.1229611
#> 98   48   male 16.4917840
#> 99   49 female  8.0079342
#> 100  49   male 16.2355708
#> 101  50 female  7.8893448
#> 102  50   male 15.9739738
#> 103  51 female  7.7687793
#> 104  51   male 15.7084999
#> 105  52 female  7.6452918
#> 106  52   male 15.4360245
#> 107  53 female  7.5180327
#> 108  53   male 15.1559101
#> 109  54 female  7.3866949
#> 110  54   male 14.8702735
#> 111  55 female  7.2529907
#> 112  55   male 14.5781678
#> 113  56 female  7.1161807
#> 114  56   male 14.2780265
#> 115  57 female  6.9762901
#> 116  57   male 13.9767438
#> 117  58 female  6.8333057
#> 118  58   male 13.6658276
#> 119  59 female  6.6867994
#> 120  59   male 13.3498711
#> 121  60 female  6.5377032
#> 122  60   male 13.0289208
#> 123  61 female  6.3856164
#> 124  61   male 12.7025116
#> 125  62 female  6.2296579
#> 126  62   male 12.3708331
#> 127  63 female  6.0740738
#> 128  63   male 12.0391765
#> 129  64 female  5.9126817
#> 130  64   male 11.7005410
#> 131  65 female  5.7485148
#> 132  65   male 11.3576847
#> 133  66 female  5.5816813
#> 134  66   male 11.0129343
#> 135  67 female  5.4101172
#> 136  67   male 10.6633115
#> 137  68 female  5.2357229
#> 138  68   male 10.3095700
#> 139  69 female  5.0588768
#> 140  69   male  9.9520203
#> 141  70 female  4.8788646
#> 142  70   male  9.5930092
#> 143  71 female  4.6970188
#> 144  71   male  9.2243152
#> 145  72 female  4.5093863
#> 146  72   male  8.8577251
#> 147  73 female  4.3214298
#> 148  73   male  8.4849667
#> 149  74 female  4.1314724
#> 150  74   male  8.1086660
#> 151  75 female  3.9408229
#> 152  75   male  7.7390498
#> 153  76 female  3.7465850
#> 154  76   male  7.3717706
#> 155  77 female  3.5514401
#> 156  77   male  7.0017800
#> 157  78 female  3.3556940
#> 158  78   male  6.6295034
#> 159  79 female  3.1595500
#> 160  79   male  6.2692842
#> 161  80 female  2.9659803
#> 162  80   male  5.9135553
#> 163  81 female  2.7698847
#> 164  81   male  5.5639583
#> 165  82 female  2.5720200
#> 166  82   male  5.2120757
#> 167  83 female  2.3725960
#> 168  83   male  4.8621497
#> 169  84 female  2.1723800
#> 170  84   male  4.5208144
#> 171  85 female  1.9706241
#> 172  85   male  4.1873015
#> 173  86 female  1.7654790
#> 174  86   male  3.8557312
#> 175  87 female  1.5566019
#> 176  87   male  3.5235218
#> 177  88 female  1.3381948
#> 178  88   male  3.1864645
#> 179  89 female  1.1082049
#> 180  89   male  2.8605000
#> 181  90 female  0.8570151
#> 182  90   male  2.5247086
#> 183  91 female  0.7980381
#> 184  91   male  2.3477406
#> 185  92 female  0.7421388
#> 186  92   male  2.1843886
#> 187  93 female  0.6905543
#> 188  93   male  2.0248169
#> 189  94 female  0.6401599
#> 190  94   male  1.8836282
#> 191  95 female  0.5943922
#> 192  95   male  1.7627212
#> 193  96 female  0.5548378
#> 194  96   male  1.6479962
#> 195  97 female  0.5189596
#> 196  97   male  1.5375182
#> 197  98 female  0.4863130
#> 198  98   male  1.4444814
#> 199  99 female  0.4633595
#> 200  99   male  1.3822305
#> 201 100 female  0.4415246
#> 202 100   male  1.3407158
#> 203 101 female  0.4121974
#> 204 101   male  1.2396708
#> 205 102 female  0.3846041
#> 206 102   male  1.1643386
#> 207 103 female  0.3586959
#> 208 103   male  1.0933885
#> 209 104 female  0.3344219
#> 210 104   male  1.0266812
#> 211 105 female  0.3117288
#> 212 105   male  0.9640750
#> 213 106 female  0.2905618
#> 214 106   male  0.9054275
#> 215 107 female  0.2708653
#> 216 107   male  0.8505961
#> 217 108 female  0.2525831
#> 218 108   male  0.7994388
#> 219 109 female  0.2356590
#> 220 109   male  0.7518150
#> 221 110 female  0.2200372
#> 222 110   male  0.7075864
#> 223 111 female  0.2056624
#> 224 111   male  0.6666171
#> 225 112 female  0.1924804
#> 226 112   male  0.6287737
#> 227 113 female  0.1804380
#> 228 113   male  0.5939260
#> 229 114 female  0.1694828
#> 230 114   male  0.5619453
#> 231 115 female  0.1595624
#> 232 115   male  0.5327008
#> 233 116 female  0.1506192
#> 234 116   male  0.5060371
#> 235 117 female  0.1425612
#> 236 117   male  0.4816548
#> 237 118 female  0.1350749
#> 238 118   male  0.4583571
#> 239 119 female  0.1262157
#> 240 119   male  0.4286804
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
#> 1     0 female 43.3336393
#> 2     0   male 42.2398430
#> 3     1 female 43.1368897
#> 4     1   male 42.0606215
#> 5     2 female 42.7940871
#> 6     2   male 41.7044698
#> 7     3 female 42.4436203
#> 8     3   male 41.3398391
#> 9     4 female 42.0866187
#> 10    4   male 40.9685352
#> 11    5 female 41.7241930
#> 12    5   male 40.5923015
#> 13    6 female 41.3576710
#> 14    6   male 40.2118276
#> 15    7 female 40.9871387
#> 16    7   male 39.8272632
#> 17    8 female 40.6107297
#> 18    8   male 39.4360062
#> 19    9 female 40.2292823
#> 20    9   male 39.0397790
#> 21   10 female 39.8428416
#> 22   10   male 38.6388060
#> 23   11 female 39.4527498
#> 24   11   male 38.2333663
#> 25   12 female 39.0569836
#> 26   12   male 37.8233513
#> 27   13 female 38.6557164
#> 28   13   male 37.4092571
#> 29   14 female 38.2515282
#> 30   14   male 36.9907199
#> 31   15 female 37.8427811
#> 32   15   male 36.5656782
#> 33   16 female 37.4286779
#> 34   16   male 36.1360282
#> 35   17 female 37.0097876
#> 36   17   male 35.7032995
#> 37   18 female 36.5867988
#> 38   18   male 35.2675269
#> 39   19 female 36.1612229
#> 40   19   male 34.8290167
#> 41   20 female 35.7279863
#> 42   20   male 34.3868855
#> 43   21 female 35.2890479
#> 44   21   male 33.9426465
#> 45   22 female 34.8448416
#> 46   22   male 33.4920457
#> 47   23 female 34.3960509
#> 48   23   male 33.0354483
#> 49   24 female 33.9400877
#> 50   24   male 32.5716202
#> 51   25 female 33.4790903
#> 52   25   male 32.1041048
#> 53   26 female 33.0213396
#> 54   26   male 31.6413431
#> 55   27 female 32.5588942
#> 56   27   male 31.1714405
#> 57   28 female 32.0918304
#> 58   28   male 30.6969141
#> 59   29 female 31.6174178
#> 60   29   male 30.2168270
#> 61   30 female 31.1379041
#> 62   30   male 29.7312472
#> 63   31 female 30.6531593
#> 64   31   male 29.2404005
#> 65   32 female 30.1622759
#> 66   32   male 28.7430350
#> 67   33 female 29.6647896
#> 68   33   male 28.2388896
#> 69   34 female 29.1615888
#> 70   34   male 27.7304833
#> 71   35 female 28.6546490
#> 72   35   male 27.2135439
#> 73   36 female 28.1607578
#> 74   36   male 26.7140159
#> 75   37 female 27.6611247
#> 76   37   male 26.2066730
#> 77   38 female 27.1594187
#> 78   38   male 25.6976810
#> 79   39 female 26.6493052
#> 80   39   male 25.1816036
#> 81   40 female 26.1344549
#> 82   40   male 24.6593999
#> 83   41 female 25.6150967
#> 84   41   male 24.1328477
#> 85   42 female 25.0887254
#> 86   42   male 23.5990559
#> 87   43 female 24.5577844
#> 88   43   male 23.0599706
#> 89   44 female 24.0195656
#> 90   44   male 22.5164713
#> 91   45 female 23.4777792
#> 92   45   male 21.9702526
#> 93   46 female 22.9926109
#> 94   46   male 21.4916214
#> 95   47 female 22.5035098
#> 96   47   male 21.0082234
#> 97   48 female 22.0081745
#> 98   48   male 20.5201807
#> 99   49 female 21.5078861
#> 100  49   male 20.0267391
#> 101  50 female 21.0015775
#> 102  50   male 19.5303108
#> 103  51 female 20.4936059
#> 104  51   male 19.0327875
#> 105  52 female 19.9815394
#> 106  52   male 18.5304355
#> 107  53 female 19.4633035
#> 108  53   male 18.0226324
#> 109  54 female 18.9383021
#> 110  54   male 17.5120088
#> 111  55 female 18.4110688
#> 112  55   male 16.9975073
#> 113  56 female 17.9204424
#> 114  56   male 16.5384457
#> 115  57 female 17.4266667
#> 116  57   male 16.0830285
#> 117  58 female 16.9298209
#> 118  58   male 15.6215376
#> 119  59 female 16.4289648
#> 120  59   male 15.1593957
#> 121  60 female 15.9264908
#> 122  60   male 14.6967204
#> 123  61 female 15.4214808
#> 124  61   male 14.2330571
#> 125  62 female 14.9119089
#> 126  62   male 13.7686952
#> 127  63 female 14.4079364
#> 128  63   male 13.3095181
#> 129  64 female 13.8948645
#> 130  64   male 12.8477667
#> 131  65 female 13.3800191
#> 132  65   male 12.3865629
#> 133  66 female 12.8942395
#> 134  66   male 11.9284441
#> 135  67 female 12.4029942
#> 136  67   male 11.4701769
#> 137  68 female 11.9108074
#> 138  68   male 11.0126181
#> 139  69 female 11.4186010
#> 140  69   male 10.5561236
#> 141  70 female 10.9248243
#> 142  70   male 10.1031652
#> 143  71 female 10.4325127
#> 144  71   male  9.6451301
#> 145  72 female  9.9329900
#> 146  72   male  9.1943954
#> 147  73 female  9.4384081
#> 148  73   male  8.7422839
#> 149  74 female  8.9449989
#> 150  74   male  8.2915441
#> 151  75 female  8.4555170
#> 152  75   male  7.8524663
#> 153  76 female  8.0354774
#> 154  76   male  7.4512315
#> 155  77 female  7.6216633
#> 156  77   male  7.0532333
#> 157  78 female  7.2151133
#> 158  78   male  6.6590917
#> 159  79 female  6.8167443
#> 160  79   male  6.2832873
#> 161  80 female  6.4335437
#> 162  80   male  5.9182681
#> 163  81 female  6.0552880
#> 164  81   male  5.5658850
#> 165  82 female  5.6847338
#> 166  82   male  5.2181158
#> 167  83 female  5.3238122
#> 168  83   male  4.8798142
#> 169  84 female  4.9762560
#> 170  84   male  4.5583920
#> 171  85 female  4.6432228
#> 172  85   male  4.2541650
#> 173  86 female  4.3244534
#> 174  86   male  3.9628248
#> 175  87 female  4.0250800
#> 176  87   male  3.6841619
#> 177  88 female  3.7391858
#> 178  88   male  3.4173982
#> 179  89 female  3.4745984
#> 180  89   male  3.1852455
#> 181  90 female  3.2238430
#> 182  90   male  2.9740120
#> 183  91 female  2.9901935
#> 184  91   male  2.7556944
#> 185  92 female  2.7703930
#> 186  92   male  2.5553556
#> 187  93 female  2.5687792
#> 188  93   male  2.3613005
#> 189  94 female  2.3735238
#> 190  94   male  2.1903902
#> 191  95 female  2.1972334
#> 192  95   male  2.0444041
#> 193  96 female  2.0454087
#> 194  96   male  1.9066899
#> 195  97 female  1.9083487
#> 196  97   male  1.7749842
#> 197  98 female  1.7842280
#> 198  98   male  1.6644197
#> 199  99 female  1.6963391
#> 200  99   male  1.5899083
#> 201 100 female  1.6127511
#> 202 100   male  1.5391727
#> 203 101 female  1.5021626
#> 204 101   male  1.4202326
#> 205 102 female  1.3985450
#> 206 102   male  1.3314816
#> 207 103 female  1.3016401
#> 208 103   male  1.2481729
#> 209 104 female  1.2111869
#> 210 104   male  1.1700942
#> 211 105 female  1.1269234
#> 212 105   male  1.0970359
#> 213 106 female  1.0485887
#> 214 106   male  1.0287914
#> 215 107 female  0.9759242
#> 216 107   male  0.9651579
#> 217 108 female  0.9086754
#> 218 108   male  0.9059378
#> 219 109 female  0.8465932
#> 220 109   male  0.8509384
#> 221 110 female  0.7894347
#> 222 110   male  0.7999729
#> 223 111 female  0.7369640
#> 224 111   male  0.7528604
#> 225 112 female  0.6889530
#> 226 112   male  0.7094261
#> 227 113 female  0.6451815
#> 228 113   male  0.6695012
#> 229 114 female  0.6054356
#> 230 114   male  0.6329210
#> 231 115 female  0.5695044
#> 232 115   male  0.5995202
#> 233 116 female  0.5371599
#> 234 116   male  0.5691060
#> 235 117 female  0.5080487
#> 236 117   male  0.5413175
#> 237 118 female  0.4810044
#> 238 118   male  0.5147553
#> 239 119 female  0.4489670
#> 240 119   male  0.4808815
#> 241 120 female  0.3550000
#> 242 120   male  0.3750000


#Calculate grouped dQALY values - using default country-level population weightings:
#1) collapse sex
calculate_dQALY(country = "United Kingdom", year = 2019,
                collapse_sex = TRUE)
#>     age     dQALY
#> 1     0 25.069192
#> 2     1 25.075078
#> 3     2 24.985973
#> 4     3 24.891208
#> 5     4 24.792101
#> 6     5 24.688958
#> 7     6 24.582104
#> 8     7 24.472156
#> 9     8 24.357019
#> 10    9 24.238297
#> 11   10 24.114842
#> 12   11 23.987882
#> 13   12 23.855804
#> 14   13 23.719900
#> 15   14 23.579336
#> 16   15 23.434049
#> 17   16 23.284428
#> 18   17 23.131991
#> 19   18 22.974964
#> 20   19 22.813509
#> 21   20 22.647512
#> 22   21 22.477282
#> 23   22 22.302258
#> 24   23 22.120665
#> 25   24 21.930838
#> 26   25 21.736056
#> 27   26 21.545511
#> 28   27 21.348352
#> 29   28 21.143161
#> 30   29 20.932541
#> 31   30 20.714642
#> 32   31 20.490716
#> 33   32 20.259083
#> 34   33 20.015582
#> 35   34 19.767185
#> 36   35 19.511491
#> 37   36 19.268581
#> 38   37 19.016387
#> 39   38 18.759978
#> 40   39 18.492617
#> 41   40 18.217191
#> 42   41 17.935653
#> 43   42 17.642853
#> 44   43 17.343737
#> 45   44 17.034645
#> 46   45 16.718108
#> 47   46 16.460386
#> 48   47 16.196059
#> 49   48 15.925376
#> 50   49 15.643700
#> 51   50 15.354781
#> 52   51 15.060504
#> 53   52 14.756489
#> 54   53 14.446636
#> 55   54 14.125632
#> 56   55 13.797658
#> 57   56 13.511403
#> 58   57 13.220960
#> 59   58 12.922034
#> 60   59 12.617887
#> 61   60 12.309041
#> 62   61 11.993260
#> 63   62 11.671516
#> 64   63 11.348031
#> 65   64 11.016533
#> 66   65 10.678675
#> 67   66 10.351187
#> 68   67 10.018264
#> 69   68  9.678640
#> 70   69  9.335448
#> 71   70  8.986207
#> 72   71  8.631397
#> 73   72  8.269694
#> 74   73  7.905521
#> 75   74  7.536223
#> 76   75  7.167051
#> 77   76  6.849487
#> 78   77  6.531041
#> 79   78  6.213383
#> 80   79  5.901504
#> 81   80  5.597791
#> 82   81  5.297351
#> 83   82  4.999469
#> 84   83  4.706453
#> 85   84  4.422126
#> 86   85  4.150145
#> 87   86  3.886266
#> 88   87  3.635094
#> 89   88  3.393627
#> 90   89  3.174085
#> 91   90  2.964692
#> 92   91  2.761846
#> 93   92  2.571209
#> 94   93  2.393131
#> 95   94  2.223495
#> 96   95  2.072041
#> 97   96  1.937079
#> 98   97  1.813408
#> 99   98  1.702251
#> 100  99  1.624372
#> 101 100  1.554784
#> 102 101  1.451122
#> 103 102  1.355070
#> 104 103  1.266372
#> 105 104  1.182800
#2) age groups
my_age_groups <- data.frame(lower = c(seq(0,90,5)), upper = c(seq(4,89,5), 100))
calculate_dQALY(country = "United Kingdom", year = 2019,
                collapse_age = my_age_groups)
#>       age lower upper    sex     dQALY
#> 1     0-4     0     4 female 25.110922
#> 2     0-4     0     4   male 24.816826
#> 3     5-9     5     9 female 24.642446
#> 4     5-9     5     9   male 24.296648
#> 5   10-14    10    14 female 24.066257
#> 6   10-14    10    14   male 23.657137
#> 7   15-19    15    19 female 23.370372
#> 8   15-19    15    19   male 22.892185
#> 9   20-24    20    24 female 22.560383
#> 10  20-24    20    24   male 22.021362
#> 11  25-29    25    29 female 21.628924
#> 12  25-29    25    29   male 21.026943
#> 13  30-34    30    34 female 20.576536
#> 14  30-34    30    34   male 19.905116
#> 15  35-39    35    39 female 19.374279
#> 16  35-39    35    39   male 18.624997
#> 17  40-44    40    44 female 18.052143
#> 18  40-44    40    44   male 17.216857
#> 19  45-49    45    49 female 16.620260
#> 20  45-49    45    49   male 15.715961
#> 21  50-54    50    54 female 15.208391
#> 22  50-54    50    54   male 14.271558
#> 23  55-59    55    59 female 13.683430
#> 24  55-59    55    59   male 12.767380
#> 25  60-64    60    64 female 12.080936
#> 26  60-64    60    64   male 11.289858
#> 27  65-69    65    69 female 10.335272
#> 28  65-69    65    69   male  9.684336
#> 29  70-74    70    74 female  8.560464
#> 30  70-74    70    74   male  8.028007
#> 31  75-79    75    79 female  6.779212
#> 32  75-79    75    79   male  6.367964
#> 33  80-84    80    84 female  5.209055
#> 34  80-84    80    84   male  4.848161
#> 35  85-89    85    89 female  3.811490
#> 36  85-89    85    89   male  3.542967
#> 37 90-100    90   100 female  2.525903
#> 38 90-100    90   100   male  2.420528
#3) collapse sex and group age
calculate_dQALY(country = "United Kingdom", year = 2019,
                collapse_age = my_age_groups, collapse_sex = TRUE)
#>       age lower upper     dQALY
#> 1     0-4     0     4 24.960039
#> 2     5-9     5     9 24.465244
#> 3   10-14    10    14 23.856497
#> 4   15-19    15    19 23.125798
#> 5   20-24    20    24 22.291035
#> 6   25-29    25    29 21.334691
#> 7   30-34    30    34 20.250431
#> 8   35-39    35    39 19.007874
#> 9   40-44    40    44 17.640019
#> 10  45-49    45    49 16.174836
#> 11  50-54    50    54 14.747556
#> 12  55-59    55    59 13.232179
#> 13  60-64    60    64 11.692252
#> 14  65-69    65    69 10.019622
#> 15  70-74    70    74  8.305950
#> 16  75-79    75    79  6.588852
#> 17  80-84    80    84  5.050859
#> 18  85-89    85    89  3.705216
#> 19 90-100    90   100  2.492342

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
#> 1  89 3.203041
#> 2  90 2.970325
#> 3  91 2.696390
#> 4  92 2.539902
#> 5  93 2.266586
#> 6  95 2.110092
#> 7  96 1.969674
#> 8  97 1.842307
#> 9 100 1.567412
#2) age groups (note: of the age groups specified, only estimates for age groups that contain a
#member of the specified cohort are returned)
calculate_dQALY(country = "United Kingdom", year = 2019,
                collapse_age = my_age_groups, cohort = my_cohort)
#> Warning: User-supplied data does not have same number of values for sex =  "female" and sex = "male".
#>      age lower upper    sex    dQALY
#> 1  85-89    85    89   male 3.015643
#> 2  85-89    85    89 female 3.265507
#> 3 90-100    90   100   male 2.558820
#> 4 90-100    90   100 female 2.350224
#3) collapse sex and group age
calculate_dQALY(country = "United Kingdom", year = 2019,
                collapse_age = my_age_groups,
                collapse_sex = TRUE, cohort = my_cohort)
#> Warning: User-supplied data does not have same number of values for sex =  "female" and sex = "male".
#>      age lower upper    dQALY
#> 1  85-89    85    89 3.203041
#> 2 90-100    90   100 2.424722

#It's possible (though perhaps not often advisable) to perform the calculation
#using data from various countries/years
calculate_dQALY(life_table = package_lt(country = "England", year = 2019),
                norms = package_norms(country = "France"),
                cohort = package_cohort(country = "Spain", year = 2020),
                collapse_sex = TRUE)
#>     age     dQALY
#> 1     0 25.524825
#> 2     1 25.540139
#> 3     2 25.458868
#> 4     3 25.372414
#> 5     4 25.281870
#> 6     5 25.187278
#> 7     6 25.089926
#> 8     7 24.989697
#> 9     8 24.884462
#> 10    9 24.775639
#> 11   10 24.662727
#> 12   11 24.546466
#> 13   12 24.426215
#> 14   13 24.302160
#> 15   14 24.175019
#> 16   15 24.042437
#> 17   16 23.905301
#> 18   17 23.764175
#> 19   18 23.619162
#> 20   19 23.471554
#> 21   20 23.319890
#> 22   21 23.164019
#> 23   22 23.002933
#> 24   23 22.836983
#> 25   24 22.663430
#> 26   25 22.484935
#> 27   26 22.302352
#> 28   27 22.114218
#> 29   28 21.919681
#> 30   29 21.718717
#> 31   30 21.512006
#> 32   31 21.299082
#> 33   32 21.078002
#> 34   33 20.849833
#> 35   34 20.614512
#> 36   35 20.371055
#> 37   36 20.153604
#> 38   37 19.928705
#> 39   38 19.699519
#> 40   39 19.463176
#> 41   40 19.219830
#> 42   41 18.968622
#> 43   42 18.708327
#> 44   43 18.442112
#> 45   44 18.167316
#> 46   45 17.886916
#> 47   46 17.590857
#> 48   47 17.287392
#> 49   48 16.975336
#> 50   49 16.652635
#> 51   50 16.321783
#> 52   51 15.984753
#> 53   52 15.638118
#> 54   53 15.278968
#> 55   54 14.910202
#> 56   55 14.533321
#> 57   56 14.215799
#> 58   57 13.892870
#> 59   58 13.561141
#> 60   59 13.224240
#> 61   60 12.878784
#> 62   61 12.521505
#> 63   62 12.157262
#> 64   63 11.793361
#> 65   64 11.417955
#> 66   65 11.035525
#> 67   66 10.690489
#> 68   67 10.335060
#> 69   68  9.976863
#> 70   69  9.614899
#> 71   70  9.246434
#> 72   71  8.870593
#> 73   72  8.486963
#> 74   73  8.098534
#> 75   74  7.705793
#> 76   75  7.309539
#> 77   76  6.986207
#> 78   77  6.663600
#> 79   78  6.340999
#> 80   79  6.027704
#> 81   80  5.723328
#> 82   81  5.419895
#> 83   82  5.116017
#> 84   83  4.821561
#> 85   84  4.532410
#> 86   85  4.252896
#> 87   86  3.984900
#> 88   87  3.726912
#> 89   88  3.477399
#> 90   89  3.253880
#> 91   90  3.041701
#> 92   91  2.834248
#> 93   92  2.640325
#> 94   93  2.457278
#> 95   94  2.286082
#> 96   95  2.128868
#> 97   96  1.987940
#> 98   97  1.863809
#> 99   98  1.746630
#> 100  99  1.662975
```
