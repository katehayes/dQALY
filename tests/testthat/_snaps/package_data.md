# package_lt returns (probably) same numbers for list of avail countries & years

    Code
      copy(country_list[country != "England"])[, paste0("sum", c(15:23)) := lapply(c(
        2015:2023), function(x) sum(package_lt(country, year = x)$q, na.rm = T)), by = country]
    Output
                           country    sum15    sum16    sum17    sum18    sum19
                            <char>    <num>    <num>    <num>    <num>    <num>
       1:                Argentina 30.72807 31.18038 31.08864 30.43956 30.64058
       2:                  Belgium 37.86423 36.60832 36.96137 36.74806 36.10615
       3:                    China 43.25341 43.03517 43.12577 42.53303 42.31307
       4:                  Denmark 36.77813 36.72732 37.08688 36.99741 36.86336
       5:                  Finland 36.57627 37.54674 37.29550 37.96839 37.63386
       6:                   France 35.76447 35.47787 36.05924 35.78941 36.02212
       7:                  Germany 38.11565 37.15992 37.90704 38.12228 37.61310
       8:                   Greece 33.59487 32.74504 33.31523 32.63103 32.77010
       9:                  Hungary 38.04238 37.34684 35.95907 35.20101 33.21376
      10:                    Italy 36.75109 35.57809 36.82279 36.21900 35.95402
      11:              Netherlands 37.89363 37.28124 37.54250 37.95379 37.68660
      12:              New Zealand 37.66130 36.15109 36.30458 37.46239 35.91236
      13:        Republic of Korea 32.44456 32.24790 32.06311 32.36844 32.20352
      14:                  Romania 43.06805 41.69739 42.18643 41.99049 41.19003
      15:                 Slovenia 32.92802 32.93589 33.04511 32.59574 31.81769
      16:                    Spain 36.14294 35.71151 36.12404 36.12620 35.03488
      17:                   Sweden 37.25443 37.79158 37.57887 37.53420 36.93092
      18:                 Thailand 29.13581 28.72659 28.40631 28.42046 26.03441
      19:           United Kingdom 36.93458 35.83813 36.45421 36.15048 35.00962
      20: United States of America 34.91406 34.38186 34.91795 34.85329 34.27358
                           country    sum15    sum16    sum17    sum18    sum19
                            <char>    <num>    <num>    <num>    <num>    <num>
             sum20    sum21    sum22    sum23
             <num>    <num>    <num>    <num>
       1: 31.25553 30.21458 32.13126 30.12326
       2: 39.54634 34.88605 37.71574 36.63376
       3: 42.41608 44.25562 43.04047 44.05349
       4: 36.81072 37.39328 37.72713 38.57118
       5: 37.56927 38.39589 42.38912 40.39789
       6: 37.14041 36.38252 37.95633 35.98260
       7: 37.80596 31.03776 40.47487 38.85768
       8: 34.87186 33.34673 37.31101 31.74936
       9: 31.74525 38.48945 34.10478 32.86369
      10: 38.02895 34.76680 39.05545 36.38500
      11: 38.77959 38.68237 40.30324 39.90590
      12: 34.67928 35.08658 38.55201 36.85846
      13: 34.84941 35.95258 43.03464 35.16688
      14: 39.34390 37.95944 41.54431 40.25322
      15: 35.36259 32.38717 32.13058 31.62990
      16: 37.30423 36.86070 37.35912 35.64878
      17: 38.79205 36.67423 38.12563 37.64094
      18: 26.42801 28.37464 30.15532 29.64032
      19: 36.79450 37.32980 36.67986 36.72518
      20: 35.76797 33.37663 36.07610 34.72573
             sum20    sum21    sum22    sum23
             <num>    <num>    <num>    <num>

---

    Code
      copy(country_list[country == "England"])[, paste0("sum", c(15:23)) := lapply(c(
        2018:2022), function(x) sum(package_lt(country, year = x)$q, na.rm = T)), by = country]
    Output
         country    sum15    sum16    sum17    sum18    sum19    sum20    sum21
          <char>    <num>    <num>    <num>    <num>    <num>    <num>    <num>
      1: England 36.28119 36.55472 36.20258 36.56531 36.19015 36.28119 36.55472
            sum22    sum23
            <num>    <num>
      1: 36.20258 36.56531

# package_lt default extension to 120 works

    Code
      copy(country_list[country != "England"])[, paste0("length", c(15:23)) := lapply(
        c(2015:2023), function(x) nrow(package_lt(country, year = x))), by = country]
    Output
                           country length15 length16 length17 length18 length19
                            <char>    <int>    <int>    <int>    <int>    <int>
       1:                Argentina      242      242      242      242      242
       2:                  Belgium      242      242      242      242      242
       3:                    China      242      242      242      242      242
       4:                  Denmark      242      242      242      242      242
       5:                  Finland      242      242      242      242      242
       6:                   France      242      242      242      242      242
       7:                  Germany      242      242      242      242      242
       8:                   Greece      242      242      242      242      242
       9:                  Hungary      242      242      242      242      242
      10:                    Italy      242      242      242      242      242
      11:              Netherlands      242      242      242      242      242
      12:              New Zealand      242      242      242      242      242
      13:        Republic of Korea      242      242      242      242      242
      14:                  Romania      242      242      242      242      242
      15:                 Slovenia      242      242      242      242      242
      16:                    Spain      242      242      242      242      242
      17:                   Sweden      242      242      242      242      242
      18:                 Thailand      242      242      242      242      242
      19:           United Kingdom      242      242      242      242      242
      20: United States of America      242      242      242      242      242
                           country length15 length16 length17 length18 length19
                            <char>    <int>    <int>    <int>    <int>    <int>
          length20 length21 length22 length23
             <int>    <int>    <int>    <int>
       1:      242      242      242      242
       2:      242      242      242      242
       3:      242      242      242      242
       4:      242      242      242      242
       5:      242      242      242      242
       6:      242      242      242      242
       7:      242      242      242      242
       8:      242      242      242      242
       9:      242      242      242      242
      10:      242      242      242      242
      11:      242      242      242      242
      12:      242      242      242      242
      13:      242      242      242      242
      14:      242      242      242      242
      15:      242      242      242      242
      16:      242      242      242      242
      17:      242      242      242      242
      18:      242      242      242      242
      19:      242      242      242      242
      20:      242      242      242      242
          length20 length21 length22 length23
             <int>    <int>    <int>    <int>

# turning off package_lt default extension works

    Code
      copy(country_list[country != "England"])[, paste0("length", c(15:23)) := lapply(
        c(2015:2023), function(x) nrow(package_lt(country, year = x, lt_extend = F))),
      by = country]
    Output
                           country length15 length16 length17 length18 length19
                            <char>    <int>    <int>    <int>    <int>    <int>
       1:                Argentina      200      200      200      200      200
       2:                  Belgium      200      200      200      200      200
       3:                    China      200      200      200      200      200
       4:                  Denmark      200      200      200      200      200
       5:                  Finland      200      200      200      200      200
       6:                   France      200      200      200      200      200
       7:                  Germany      200      200      200      200      200
       8:                   Greece      200      200      200      200      200
       9:                  Hungary      200      200      200      200      200
      10:                    Italy      200      200      200      200      200
      11:              Netherlands      200      200      200      200      200
      12:              New Zealand      200      200      200      200      200
      13:        Republic of Korea      200      200      200      200      200
      14:                  Romania      200      200      200      200      200
      15:                 Slovenia      200      200      200      200      200
      16:                    Spain      200      200      200      200      200
      17:                   Sweden      200      200      200      200      200
      18:                 Thailand      200      200      200      200      200
      19:           United Kingdom      200      200      200      200      200
      20: United States of America      200      200      200      200      200
                           country length15 length16 length17 length18 length19
                            <char>    <int>    <int>    <int>    <int>    <int>
          length20 length21 length22 length23
             <int>    <int>    <int>    <int>
       1:      200      200      200      200
       2:      200      200      200      200
       3:      200      200      200      200
       4:      200      200      200      200
       5:      200      200      200      200
       6:      200      200      200      200
       7:      200      200      200      200
       8:      200      200      200      200
       9:      200      200      200      200
      10:      200      200      200      200
      11:      200      200      200      200
      12:      200      200      200      200
      13:      200      200      200      200
      14:      200      200      200      200
      15:      200      200      200      200
      16:      200      200      200      200
      17:      200      200      200      200
      18:      200      200      200      200
      19:      200      200      200      200
      20:      200      200      200      200
          length20 length21 length22 length23
             <int>    <int>    <int>    <int>

# package_lt returns error if country arg is invalid

    Code
      package_lt("Ireland")
    Condition
      Error in `package_lt()`:
      ! Value for `country` must be chosen from the list of available
            countries. Use hrqol_norms() to see the list.

---

    Code
      package_lt()
    Condition
      Error in `package_lt()`:
      ! argument "country" is missing, with no default

# package_lt returns error if year arg is invalid

    Code
      package_lt(country = "England", year = 1990)
    Condition
      Error in `package_lt()`:
      ! Currently the package only stores life table data for England for the years 2018-2022.
                       Please set `year` to a value within this period.

---

    Code
      package_lt(country = "England", year = NULL)
    Condition
      Error in `package_lt()`:
      ! No value for `year` supplied to function `package_lt`.

# package_norms return (probably) same default for list of avail countries

    Code
      copy(country_list)[, .(sum = sum(package_norms(country)$avg_hrqol, na.rm = T),
      mean = mean(package_norms(country)$avg_hrqol, na.rm = T)), by = country]
    Output
                           country    sum      mean
                            <char>  <num>     <num>
       1:                Argentina 14.240 0.8900000
       2:                  Belgium 14.118 0.8823750
       3:                    China 15.120 0.9450000
       4:                  Denmark 14.154 0.8846250
       5:                  England 29.422 0.8172778
       6:                  Finland  9.448 0.7873333
       7:                   France 14.150 0.8843750
       8:                  Germany 14.960 0.9350000
       9:                   Greece 14.304 0.8940000
      10:                  Hungary 13.128 0.8205000
      11:                    Italy 15.106 0.9441250
      12:              Netherlands 14.516 0.9072500
      13:              New Zealand 13.152 0.8220000
      14:        Republic of Korea 13.354 0.9538571
      15:                  Romania 14.833 0.9270625
      16:                 Slovenia 11.512 0.7195000
      17:                    Spain 14.768 0.9230000
      18:                   Sweden 13.444 0.8402500
      19:                 Thailand 11.844 0.7402500
      20:           United Kingdom 13.740 0.8587500
      21: United States of America 13.812 0.8632500
                           country    sum      mean
                            <char>  <num>     <num>

# package_norms return (probably) same numbers for list of avail countries, after adjustment

    Code
      copy(country_list)[, .(sum = sum(package_norms(country, avg_hrqol_young = 0)$
        avg_hrqol, na.rm = T), mean = mean(package_norms(country, avg_hrqol_young = 0)$
        avg_hrqol, na.rm = T)), by = country]
    Output
                           country    sum      mean
                            <char>  <num>     <num>
       1:                Argentina 12.338 0.7711250
       2:                  Belgium 12.222 0.7638750
       3:                    China 13.140 0.8212500
       4:                  Denmark 12.298 0.7686250
       5:                  England 27.626 0.7673889
       6:                  Finland  9.448 0.6748571
       7:                   France 12.254 0.7658750
       8:                  Germany 13.016 0.8135000
       9:                   Greece 12.346 0.7716250
      10:                  Hungary 11.260 0.7037500
      11:                    Italy 13.138 0.8211250
      12:              Netherlands 12.616 0.7885000
      13:              New Zealand 11.372 0.7107500
      14:        Republic of Korea 11.392 0.8137143
      15:                  Romania 12.873 0.8045625
      16:                 Slovenia  9.774 0.6108750
      17:                    Spain 12.804 0.8002500
      18:                   Sweden 11.668 0.7292500
      19:                 Thailand 10.216 0.6385000
      20:           United Kingdom 11.860 0.7412500
      21: United States of America 11.964 0.7477500
                           country    sum      mean
                            <char>  <num>     <num>

# package_norms returns error if country arg is invalid

    Code
      package_norms("Ireland")
    Condition
      Error in `package_norms()`:
      ! Value for `country` must be chosen from the list of available
            countries. Use hrqol_norms() to see the list.

---

    Code
      package_norms()
    Condition
      Error in `package_norms()`:
      ! argument "country" is missing, with no default

# package_norms returns error if id arg is invalid

    Code
      package_norms(country = "England", id = "england_default")
    Condition
      Error in `package_norms()`:
      ! Invalid norm ID. Use function hrqol_norms() to see the IDs for the norms available for your chosen country.

---

    Code
      package_norms(country = "England", id = NULL)
    Condition
      Error in `package_norms()`:
      ! No value for `id` supplied to function `package_norms`.
               Use function `hrqol_norms` to see the list of available countries and corresponding norm IDs.

---

    Code
      package_norms(country = "England", id = default_norms(country = "england"))
    Condition
      Error in `default_norms()`:
      ! Country not found. Countries for which utility norms are available currently include: Argentina, Belgium, China, Denmark, England, Finland, France, Germany, Greece, Hungary, Italy, Netherlands, New Zealand, Republic of Korea, Romania, Slovenia, Spain, Sweden, Thailand, United Kingdom, United States of America

# package_norms returns error if avg_hrqol_young arg is invalid

    Code
      package_norms(country = "England", avg_hrqol_young = c(1, 0))
    Condition
      Error in `package_norms()`:
      ! If not set to its default value of NULL, 'avg_hrqol_young' must be
                 a numeric scalar.

---

    Code
      package_norms(country = "England", avg_hrqol_young = "a")
    Condition
      Error in `package_norms()`:
      ! If not set to its default value of NULL, 'avg_hrqol_young' must be
                 a numeric scalar.

# package_norms returns warning message if avg_hrqol_young arg is unusual

    Code
      package_norms(country = "England", avg_hrqol_young = 100)
    Condition
      Warning in `.is_valid_avg_hrqol_young()`:
      The argument 'avg_hrqol_young' has been supplied a value that is not
                  between 0 and 1. This argument sets the utility score of the
                  youngest population group and utility scores are generally between
                  0 and 1, likely closer to 1 in younger age groups. Please reconsider
                  the value you have supplied to this argument.
    Output
         lower upper    sex avg_hrqol
      1      0    15 female   100.000
      2      0    15   male   100.000
      3     16    17 female     0.878
      4     16    17   male     0.918
      5     18    19 female     0.856
      6     18    19   male     0.930
      7     20    24 female     0.859
      8     20    24   male     0.894
      9     25    29 female     0.869
      10    25    29   male     0.895
      11    30    34 female     0.869
      12    30    34   male     0.915
      13    35    39 female     0.854
      14    35    39   male     0.863
      15    40    44 female     0.846
      16    40    44   male     0.872
      17    45    49 female     0.806
      18    45    49   male     0.822
      19    50    54 female     0.798
      20    50    54   male     0.836
      21    55    59 female     0.791
      22    55    59   male     0.809
      23    60    64 female     0.776
      24    60    64   male     0.803
      25    65    69 female     0.775
      26    65    69   male     0.797
      27    70    74 female     0.784
      28    70    74   male     0.801
      29    75    79 female     0.730
      30    75    79   male     0.788
      31    80    84 female     0.710
      32    80    84   male     0.767
      33    85    89 female     0.666
      34    85    89   male     0.727
      35    90   200 female     0.666
      36    90   200   male     0.656

# package_cohort returns (probably) correct numbers for list of avail countries & years

    Code
      copy(country_list[country != "England"])[, paste0("sum", c(15:23)) := lapply(c(
        2015:2023), function(x) sum(package_cohort(country, year = x)$count, na.rm = T)),
      by = country]
    Output
                           country      sum15      sum16      sum17      sum18
                            <char>      <num>      <num>      <num>      <num>
       1:                Argentina   43471980   43894887   44283120   44648735
       2:                  Belgium   11273515   11331043   11375052   11427146
       3:                    China 1396113344 1404029404 1412328917 1418980550
       4:                  Denmark    5682607    5727093    5764035    5792682
       5:                  Finland    5478972    5494701    5507597    5514890
       6:                   France   64895410   65068402   65268164   65503445
       7:                  Germany   82063976   82747935   83093350   83358685
       8:                   Greece   10818030   10772550   10750566   10727801
       9:                  Hungary    9838495    9809892    9785029    9773825
      10:                    Italy   60558952   60462416   60375745   60264344
      11:              Netherlands   17105321   17202549   17313202   17419121
      12:              New Zealand    4613479    4714193    4812143    4900221
      13:        Republic of Korea   50979594   51293208   51481246   51635393
      14:                  Romania   19870562   19776543   19688696   19596974
      15:                 Slovenia    2059677    2061125    2062183    2069261
      16:                    Spain   46674186   46723028   46858594   47082520
      17:                   Sweden    9797617    9921369   10055887   10173368
      18:                 Thailand   70534527   70852933   71152602   71367825
      19:           United Kingdom   65368154   65879437   66340809   66739134
      20: United States of America  326066153  329119534  332145122  334996749
                           country      sum15      sum16      sum17      sum18
                            <char>      <num>      <num>      <num>      <num>
               sum19      sum20      sum21      sum22      sum23
               <num>      <num>      <num>      <num>      <num>
       1:   44966898   45184999   45304911   45400226   45530389
       2:   11489056   11538251   11568600   11639227   11710037
       3: 1423489124 1426071438 1426401053 1425142412 1422545612
       4:    5813464    5830318    5855509    5901655    5946913
       5:    5520896    5528686    5540038    5568223    5600082
       6:   65712615   65885112   66058726   66249783   66409347
       7:   83548682   83616326   83681427   84068322   84530073
       8:   10715391   10696187   10576411   10409322   10239588
       9:    9769667    9748597    9706871    9683217    9685220
      10:   60117406   59898342   59711981   59599635   59478620
      11:   17535326   17634419   17728088   17901866   18089941
      12:    4988756    5069196    5106920    5130943    5172056
      13:   51761723   51851565   51840539   51774322   51740129
      14:   19500690   19391727   19247466   19166027   19117621
      15:    2083187    2102113    2113128    2114792    2117889
      16:   47424295   47668041   47723483   47815238   47897309
      17:   10276990   10351371   10413601   10484694   10548796
      18:   71513176   71631339   71716241   71723553   71689921
      19:   67097053   67336596   67652373   68162167   68665374
      20:  337729542  339375646  340099456  341469642  343410702
               sum19      sum20      sum21      sum22      sum23
               <num>      <num>      <num>      <num>      <num>

---

    Code
      copy(country_list[country == "England"])[, paste0("sum", c(15:23)) := lapply(c(
        2018:2022), function(x) sum(package_cohort(country, year = x)$count, na.rm = T)),
      by = country]
    Output
         country    sum15    sum16    sum17    sum18    sum19    sum20    sum21
          <char>    <num>    <num>    <num>    <num>    <num>    <num>    <num>
      1: England 55923931 56229410 56325380 56554275 57111986 55923931 56229410
            sum22    sum23
            <num>    <num>
      1: 56325380 56554275

# package_cohort returns error if country arg is invalid

    Code
      package_cohort("Ireland")
    Condition
      Error in `package_cohort()`:
      ! Value for `country` must be chosen from the list of available
            countries. Use hrqol_norms() to see the list.

---

    Code
      package_cohort()
    Condition
      Error in `package_cohort()`:
      ! argument "country" is missing, with no default

# package_cohort returns error if year arg is invalid

    Code
      package_cohort(country = "England", year = 1990)
    Condition
      Error in `package_cohort()`:
      ! Currently the package only stores population data for England for the years 2015-2023.
                       Please set `year` to a value within this period.

---

    Code
      package_cohort(country = "England", year = NULL)
    Condition
      Error in `package_cohort()`:
      ! No value for `year` supplied to function `package_cohort`.

# hrqol_norms returns same as ever

    Code
      hrqol_norms()
    Output
                     norm_country eq5d_data_year       norm_id eq5d_data_version
      1                 Argentina           2005 janssen_euvas          EQ-5D-3L
      2                 Argentina           2005   janssen_tto          EQ-5D-3L
      3                 Argentina           2005   janssen_vas          EQ-5D-3L
      4                   Belgium      2001-2003 janssen_euvas          EQ-5D-3L
      5                   Belgium      2001-2003   janssen_vas          EQ-5D-3L
      6                     China           2010 janssen_euvas          EQ-5D-3L
      7                   Denmark      2000-2001 janssen_euvas          EQ-5D-3L
      8                   Denmark      2000-2001   janssen_tto          EQ-5D-3L
      9                   Denmark      2000-2001   janssen_vas          EQ-5D-3L
      10                  England           2008 janssen_euvas          EQ-5D-3L
      11                  England           2008   janssen_tto          EQ-5D-3L
      12                  England           2008   janssen_vas          EQ-5D-3L
      13                  England      2017-2018   vih_primary          EQ-5D-5L
      14                  England      2017-2018 vih_secondary          EQ-5D-5L
      15                  Finland           2000 janssen_euvas          EQ-5D-3L
      16                  Finland           2000   janssen_vas          EQ-5D-3L
      17                   France      2001-2003 janssen_euvas          EQ-5D-3L
      18                   France      2001-2003   janssen_tto          EQ-5D-3L
      19                  Germany      2001-2003 janssen_euvas          EQ-5D-3L
      20                  Germany      2001-2003   janssen_tto          EQ-5D-3L
      21                  Germany      2001-2003   janssen_vas          EQ-5D-3L
      22                   Greece           1998 janssen_euvas          EQ-5D-3L
      23                  Hungary           2000 janssen_euvas          EQ-5D-3L
      24                    Italy      2001-2003 janssen_euvas          EQ-5D-3L
      25                    Italy      2001-2003   janssen_tto          EQ-5D-3L
      26              Netherlands      2001-2003 janssen_euvas          EQ-5D-3L
      27              Netherlands      2001-2003   janssen_tto          EQ-5D-3L
      28              New Zealand           1999 janssen_euvas          EQ-5D-3L
      29              New Zealand           1999   janssen_vas          EQ-5D-3L
      30        Republic of Korea           2007 janssen_euvas          EQ-5D-3L
      31        Republic of Korea           2007   janssen_tto          EQ-5D-3L
      32                  Romania      2018-2019        rom_3L          EQ-5D-3L
      33                  Romania      2018-2019        rom_5L          EQ-5D-5L
      34                 Slovenia           2000 janssen_euvas          EQ-5D-3L
      35                 Slovenia           2000   janssen_vas          EQ-5D-3L
      36                    Spain      2001-2003 janssen_euvas          EQ-5D-3L
      37                    Spain      2001-2003   janssen_tto          EQ-5D-3L
      38                    Spain      2001-2003   janssen_vas          EQ-5D-3L
      39                   Sweden           1994 janssen_euvas          EQ-5D-3L
      40                 Thailand           2007 janssen_euvas          EQ-5D-3L
      41           United Kingdom           1993 janssen_euvas          EQ-5D-3L
      42           United Kingdom           1993   janssen_tto          EQ-5D-3L
      43           United Kingdom           1993   janssen_vas          EQ-5D-3L
      44           United Kingdom           1993           mvh          EQ-5D-3L
      45 United States of America      2000-2002 janssen_euvas          EQ-5D-3L
      46 United States of America      2000-2002   janssen_tto          EQ-5D-3L
                value_set_country value_set_version value_set_type value_set_year
      1                    Europe          EQ-5D-3L            VAS               
      2                 Argentina          EQ-5D-3L            TTO               
      3                 Argentina          EQ-5D-3L            VAS               
      4                    Europe          EQ-5D-3L            VAS               
      5                   Belgium          EQ-5D-3L            VAS               
      6                    Europe          EQ-5D-3L            VAS               
      7                    Europe          EQ-5D-3L            VAS               
      8                   Denmark          EQ-5D-3L            TTO               
      9                   Denmark          EQ-5D-3L            VAS               
      10                   Europe          EQ-5D-3L            VAS               
      11                  England          EQ-5D-3L            TTO               
      12                  England          EQ-5D-3L            VAS               
      13                  England          EQ-5D-3L            DSU           1993
      14                  England          EQ-5D-3L             CW           1993
      15                   Europe          EQ-5D-3L            VAS               
      16                  Finland          EQ-5D-3L            VAS               
      17                   Europe          EQ-5D-3L            VAS               
      18                   France          EQ-5D-3L            TTO               
      19                   Europe          EQ-5D-3L            VAS               
      20                  Germany          EQ-5D-3L            TTO               
      21                  Germany          EQ-5D-3L            VAS               
      22                   Europe          EQ-5D-3L            VAS               
      23                   Europe          EQ-5D-3L            VAS               
      24                   Europe          EQ-5D-3L            VAS               
      25                    Italy          EQ-5D-3L            TTO               
      26                   Europe          EQ-5D-3L            VAS               
      27              Netherlands          EQ-5D-3L            TTO               
      28                   Europe          EQ-5D-3L            VAS               
      29              New Zealand          EQ-5D-3L            VAS               
      30                   Europe          EQ-5D-3L            VAS               
      31        Republic of Korea          EQ-5D-3L            TTO               
      32                  Romania          EQ-5D-3L           cTTO      2018-2019
      33                  Romania          EQ-5D-5L             VT      2018-2019
      34                   Europe          EQ-5D-3L            VAS               
      35                 Slovenia          EQ-5D-3L            VAS               
      36                   Europe          EQ-5D-3L            VAS               
      37                    Spain          EQ-5D-3L            TTO               
      38                    Spain          EQ-5D-3L            VAS               
      39                   Europe          EQ-5D-3L            VAS               
      40                   Europe          EQ-5D-3L            VAS               
      41                   Europe          EQ-5D-3L            VAS               
      42           United Kingdom          EQ-5D-3L            TTO               
      43           United Kingdom          EQ-5D-3L            VAS               
      44           United Kingdom          EQ-5D-3L            TTO           1993
      45                   Europe          EQ-5D-3L            VAS               
      46 United States of America          EQ-5D-3L            TTO               
         default
      1    FALSE
      2     TRUE
      3    FALSE
      4    FALSE
      5     TRUE
      6     TRUE
      7    FALSE
      8     TRUE
      9    FALSE
      10   FALSE
      11   FALSE
      12   FALSE
      13    TRUE
      14   FALSE
      15   FALSE
      16    TRUE
      17   FALSE
      18    TRUE
      19   FALSE
      20    TRUE
      21   FALSE
      22    TRUE
      23    TRUE
      24   FALSE
      25    TRUE
      26   FALSE
      27    TRUE
      28   FALSE
      29    TRUE
      30   FALSE
      31    TRUE
      32    TRUE
      33   FALSE
      34   FALSE
      35    TRUE
      36   FALSE
      37    TRUE
      38   FALSE
      39    TRUE
      40    TRUE
      41   FALSE
      42   FALSE
      43   FALSE
      44    TRUE
      45   FALSE
      46    TRUE

---

    Code
      hrqol_norms(references = T)
    Output
                     norm_country eq5d_data_year       norm_id eq5d_data_version
      1                 Argentina           2005 janssen_euvas          EQ-5D-3L
      2                 Argentina           2005   janssen_tto          EQ-5D-3L
      3                 Argentina           2005   janssen_vas          EQ-5D-3L
      4                   Belgium      2001-2003 janssen_euvas          EQ-5D-3L
      5                   Belgium      2001-2003   janssen_vas          EQ-5D-3L
      6                     China           2010 janssen_euvas          EQ-5D-3L
      7                   Denmark      2000-2001 janssen_euvas          EQ-5D-3L
      8                   Denmark      2000-2001   janssen_tto          EQ-5D-3L
      9                   Denmark      2000-2001   janssen_vas          EQ-5D-3L
      10                  England           2008 janssen_euvas          EQ-5D-3L
      11                  England           2008   janssen_tto          EQ-5D-3L
      12                  England           2008   janssen_vas          EQ-5D-3L
      13                  England      2017-2018   vih_primary          EQ-5D-5L
      14                  England      2017-2018 vih_secondary          EQ-5D-5L
      15                  Finland           2000 janssen_euvas          EQ-5D-3L
      16                  Finland           2000   janssen_vas          EQ-5D-3L
      17                   France      2001-2003 janssen_euvas          EQ-5D-3L
      18                   France      2001-2003   janssen_tto          EQ-5D-3L
      19                  Germany      2001-2003 janssen_euvas          EQ-5D-3L
      20                  Germany      2001-2003   janssen_tto          EQ-5D-3L
      21                  Germany      2001-2003   janssen_vas          EQ-5D-3L
      22                   Greece           1998 janssen_euvas          EQ-5D-3L
      23                  Hungary           2000 janssen_euvas          EQ-5D-3L
      24                    Italy      2001-2003 janssen_euvas          EQ-5D-3L
      25                    Italy      2001-2003   janssen_tto          EQ-5D-3L
      26              Netherlands      2001-2003 janssen_euvas          EQ-5D-3L
      27              Netherlands      2001-2003   janssen_tto          EQ-5D-3L
      28              New Zealand           1999 janssen_euvas          EQ-5D-3L
      29              New Zealand           1999   janssen_vas          EQ-5D-3L
      30        Republic of Korea           2007 janssen_euvas          EQ-5D-3L
      31        Republic of Korea           2007   janssen_tto          EQ-5D-3L
      32                  Romania      2018-2019        rom_3L          EQ-5D-3L
      33                  Romania      2018-2019        rom_5L          EQ-5D-5L
      34                 Slovenia           2000 janssen_euvas          EQ-5D-3L
      35                 Slovenia           2000   janssen_vas          EQ-5D-3L
      36                    Spain      2001-2003 janssen_euvas          EQ-5D-3L
      37                    Spain      2001-2003   janssen_tto          EQ-5D-3L
      38                    Spain      2001-2003   janssen_vas          EQ-5D-3L
      39                   Sweden           1994 janssen_euvas          EQ-5D-3L
      40                 Thailand           2007 janssen_euvas          EQ-5D-3L
      41           United Kingdom           1993 janssen_euvas          EQ-5D-3L
      42           United Kingdom           1993   janssen_tto          EQ-5D-3L
      43           United Kingdom           1993   janssen_vas          EQ-5D-3L
      44           United Kingdom           1993           mvh          EQ-5D-3L
      45 United States of America      2000-2002 janssen_euvas          EQ-5D-3L
      46 United States of America      2000-2002   janssen_tto          EQ-5D-3L
                value_set_country value_set_version value_set_type value_set_year
      1                    Europe          EQ-5D-3L            VAS               
      2                 Argentina          EQ-5D-3L            TTO               
      3                 Argentina          EQ-5D-3L            VAS               
      4                    Europe          EQ-5D-3L            VAS               
      5                   Belgium          EQ-5D-3L            VAS               
      6                    Europe          EQ-5D-3L            VAS               
      7                    Europe          EQ-5D-3L            VAS               
      8                   Denmark          EQ-5D-3L            TTO               
      9                   Denmark          EQ-5D-3L            VAS               
      10                   Europe          EQ-5D-3L            VAS               
      11                  England          EQ-5D-3L            TTO               
      12                  England          EQ-5D-3L            VAS               
      13                  England          EQ-5D-3L            DSU           1993
      14                  England          EQ-5D-3L             CW           1993
      15                   Europe          EQ-5D-3L            VAS               
      16                  Finland          EQ-5D-3L            VAS               
      17                   Europe          EQ-5D-3L            VAS               
      18                   France          EQ-5D-3L            TTO               
      19                   Europe          EQ-5D-3L            VAS               
      20                  Germany          EQ-5D-3L            TTO               
      21                  Germany          EQ-5D-3L            VAS               
      22                   Europe          EQ-5D-3L            VAS               
      23                   Europe          EQ-5D-3L            VAS               
      24                   Europe          EQ-5D-3L            VAS               
      25                    Italy          EQ-5D-3L            TTO               
      26                   Europe          EQ-5D-3L            VAS               
      27              Netherlands          EQ-5D-3L            TTO               
      28                   Europe          EQ-5D-3L            VAS               
      29              New Zealand          EQ-5D-3L            VAS               
      30                   Europe          EQ-5D-3L            VAS               
      31        Republic of Korea          EQ-5D-3L            TTO               
      32                  Romania          EQ-5D-3L           cTTO      2018-2019
      33                  Romania          EQ-5D-5L             VT      2018-2019
      34                   Europe          EQ-5D-3L            VAS               
      35                 Slovenia          EQ-5D-3L            VAS               
      36                   Europe          EQ-5D-3L            VAS               
      37                    Spain          EQ-5D-3L            TTO               
      38                    Spain          EQ-5D-3L            VAS               
      39                   Europe          EQ-5D-3L            VAS               
      40                   Europe          EQ-5D-3L            VAS               
      41                   Europe          EQ-5D-3L            VAS               
      42           United Kingdom          EQ-5D-3L            TTO               
      43           United Kingdom          EQ-5D-3L            VAS               
      44           United Kingdom          EQ-5D-3L            TTO           1993
      45                   Europe          EQ-5D-3L            VAS               
      46 United States of America          EQ-5D-3L            TTO               
                            norm_doi
      1  10.1007/978-94-007-7596-1_3
      2  10.1007/978-94-007-7596-1_3
      3  10.1007/978-94-007-7596-1_3
      4  10.1007/978-94-007-7596-1_3
      5  10.1007/978-94-007-7596-1_3
      6  10.1007/978-94-007-7596-1_3
      7  10.1007/978-94-007-7596-1_3
      8  10.1007/978-94-007-7596-1_3
      9  10.1007/978-94-007-7596-1_3
      10 10.1007/978-94-007-7596-1_3
      11 10.1007/978-94-007-7596-1_3
      12 10.1007/978-94-007-7596-1_3
      13  10.1016/j.jval.2022.07.005
      14  10.1016/j.jval.2022.07.005
      15 10.1007/978-94-007-7596-1_3
      16 10.1007/978-94-007-7596-1_3
      17 10.1007/978-94-007-7596-1_3
      18 10.1007/978-94-007-7596-1_3
      19 10.1007/978-94-007-7596-1_3
      20 10.1007/978-94-007-7596-1_3
      21 10.1007/978-94-007-7596-1_3
      22 10.1007/978-94-007-7596-1_3
      23 10.1007/978-94-007-7596-1_3
      24 10.1007/978-94-007-7596-1_3
      25 10.1007/978-94-007-7596-1_3
      26 10.1007/978-94-007-7596-1_3
      27 10.1007/978-94-007-7596-1_3
      28 10.1007/978-94-007-7596-1_3
      29 10.1007/978-94-007-7596-1_3
      30 10.1007/978-94-007-7596-1_3
      31 10.1007/978-94-007-7596-1_3
      32  10.1186/s12955-023-02144-8
      33  10.1186/s12955-023-02144-8
      34 10.1007/978-94-007-7596-1_3
      35 10.1007/978-94-007-7596-1_3
      36 10.1007/978-94-007-7596-1_3
      37 10.1007/978-94-007-7596-1_3
      38 10.1007/978-94-007-7596-1_3
      39 10.1007/978-94-007-7596-1_3
      40 10.1007/978-94-007-7596-1_3
      41 10.1007/978-94-007-7596-1_3
      42 10.1007/978-94-007-7596-1_3
      43 10.1007/978-94-007-7596-1_3
      44                            
      45 10.1007/978-94-007-7596-1_3
      46 10.1007/978-94-007-7596-1_3
                                                                            norm_url
      1                                https://www.ncbi.nlm.nih.gov/books/NBK500364/
      2                                https://www.ncbi.nlm.nih.gov/books/NBK500364/
      3                                https://www.ncbi.nlm.nih.gov/books/NBK500364/
      4                                https://www.ncbi.nlm.nih.gov/books/NBK500364/
      5                                https://www.ncbi.nlm.nih.gov/books/NBK500364/
      6                                https://www.ncbi.nlm.nih.gov/books/NBK500364/
      7                                https://www.ncbi.nlm.nih.gov/books/NBK500364/
      8                                https://www.ncbi.nlm.nih.gov/books/NBK500364/
      9                                https://www.ncbi.nlm.nih.gov/books/NBK500364/
      10                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      11                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      12                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      13 https://www.valueinhealthjournal.com/article/S1098-3015(22)02101-5/fulltext
      14 https://www.valueinhealthjournal.com/article/S1098-3015(22)02101-5/fulltext
      15                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      16                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      17                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      18                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      19                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      20                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      21                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      22                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      23                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      24                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      25                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      26                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      27                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      28                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      29                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      30                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      31                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      32          https://hqlo.biomedcentral.com/articles/10.1186/s12955-023-02144-8
      33          https://hqlo.biomedcentral.com/articles/10.1186/s12955-023-02144-8
      34                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      35                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      36                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      37                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      38                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      39                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      40                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      41                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      42                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      43                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      44                                    https://www.york.ac.uk/che/pdf/DP172.pdf
      45                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
      46                               https://www.ncbi.nlm.nih.gov/books/NBK500364/
         default
      1    FALSE
      2     TRUE
      3    FALSE
      4    FALSE
      5     TRUE
      6     TRUE
      7    FALSE
      8     TRUE
      9    FALSE
      10   FALSE
      11   FALSE
      12   FALSE
      13    TRUE
      14   FALSE
      15   FALSE
      16    TRUE
      17   FALSE
      18    TRUE
      19   FALSE
      20    TRUE
      21   FALSE
      22    TRUE
      23    TRUE
      24   FALSE
      25    TRUE
      26   FALSE
      27    TRUE
      28   FALSE
      29    TRUE
      30   FALSE
      31    TRUE
      32    TRUE
      33   FALSE
      34   FALSE
      35    TRUE
      36   FALSE
      37    TRUE
      38   FALSE
      39    TRUE
      40    TRUE
      41   FALSE
      42   FALSE
      43   FALSE
      44    TRUE
      45   FALSE
      46    TRUE

---

    Code
      hrqol_norms(country = "France")
    Output
        norm_country eq5d_data_year       norm_id eq5d_data_version value_set_country
      1       France      2001-2003 janssen_euvas          EQ-5D-3L            Europe
      2       France      2001-2003   janssen_tto          EQ-5D-3L            France
        value_set_version value_set_type value_set_year default
      1          EQ-5D-3L            VAS                  FALSE
      2          EQ-5D-3L            TTO                   TRUE

# default_norms return correct default for list of avail countries

    Code
      copy(country_list)[, default_norm := default_norms(country), by = country]
    Output
      Index: <country>
                           country  default_norm
                            <char>        <char>
       1:                Argentina   janssen_tto
       2:                  Belgium   janssen_vas
       3:                    China janssen_euvas
       4:                  Denmark   janssen_tto
       5:                  England   vih_primary
       6:                  Finland   janssen_vas
       7:                   France   janssen_tto
       8:                  Germany   janssen_tto
       9:                   Greece janssen_euvas
      10:                  Hungary janssen_euvas
      11:                    Italy   janssen_tto
      12:              Netherlands   janssen_tto
      13:              New Zealand   janssen_vas
      14:        Republic of Korea   janssen_tto
      15:                  Romania        rom_3L
      16:                 Slovenia   janssen_vas
      17:                    Spain   janssen_tto
      18:                   Sweden janssen_euvas
      19:                 Thailand janssen_euvas
      20:           United Kingdom           mvh
      21: United States of America   janssen_tto
                           country  default_norm
                            <char>        <char>

# default_norms returns error if country arg is invalid

    Code
      default_norms("Ireland")
    Condition
      Error in `default_norms()`:
      ! Country not found. Countries for which utility norms are available currently include: Argentina, Belgium, China, Denmark, England, Finland, France, Germany, Greece, Hungary, Italy, Netherlands, New Zealand, Republic of Korea, Romania, Slovenia, Spain, Sweden, Thailand, United Kingdom, United States of America

---

    Code
      default_norms(7)
    Condition
      Error in `default_norms()`:
      ! Country not found. Countries for which utility norms are available currently include: Argentina, Belgium, China, Denmark, England, Finland, France, Germany, Greece, Hungary, Italy, Netherlands, New Zealand, Republic of Korea, Romania, Slovenia, Spain, Sweden, Thailand, United Kingdom, United States of America

