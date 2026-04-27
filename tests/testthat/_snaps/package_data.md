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
      19:           United Kingdom      202      202      202      202      202
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
      19:      202      202      202      202
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
      package_lt(country = "England", year = 3)
    Condition
      Error in `package_lt()`:
      ! Currently the package only stores life table data for England for the years 1981-2072.
                       Please set `year` to a value within this period.

---

    Code
      package_lt(country = "England", year = NULL)
    Condition
      Error in `package_lt()`:
      ! No value for `year` supplied to function `package_lt`.

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
      package_cohort(country = "England", year = 1890)
    Condition
      Error in `package_cohort()`:
      ! Currently the package only stores population data for England for the years 1981-2072.
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

