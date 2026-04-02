# Get info on utility norms

Get info on utility norms

## Usage

``` r
get_norm_info(country = NULL, references = F)
```

## Arguments

- country:

  string - name of a permissible country

- references:

  boolean - set to T if you wish to return reference information (DOI,
  URL)

## Value

A dataframe containing information about utility norms

## Examples

``` r
get_norm_info()
#>                norm_country eq5d_data_year       norm_id eq5d_data_version
#> 1                 Argentina           2005 janssen_euvas          EQ-5D-3L
#> 2                 Argentina           2005   janssen_tto          EQ-5D-3L
#> 3                 Argentina           2005   janssen_vas          EQ-5D-3L
#> 4                   Belgium      2001-2003 janssen_euvas          EQ-5D-3L
#> 5                   Belgium      2001-2003   janssen_vas          EQ-5D-3L
#> 6                     China           2010 janssen_euvas          EQ-5D-3L
#> 7                   Denmark      2000-2001 janssen_euvas          EQ-5D-3L
#> 8                   Denmark      2000-2001   janssen_tto          EQ-5D-3L
#> 9                   Denmark      2000-2001   janssen_vas          EQ-5D-3L
#> 10                  England           2008 janssen_euvas          EQ-5D-3L
#> 11                  England           2008   janssen_tto          EQ-5D-3L
#> 12                  England           2008   janssen_vas          EQ-5D-3L
#> 13                  England      2017-2018   vih_primary          EQ-5D-5L
#> 14                  England      2017-2018 vih_secondary          EQ-5D-5L
#> 15                  Finland           2000 janssen_euvas          EQ-5D-3L
#> 16                  Finland           2000   janssen_vas          EQ-5D-3L
#> 17                   France      2001-2003 janssen_euvas          EQ-5D-3L
#> 18                   France      2001-2003   janssen_tto          EQ-5D-3L
#> 19                  Germany      2001-2003 janssen_euvas          EQ-5D-3L
#> 20                  Germany      2001-2003   janssen_tto          EQ-5D-3L
#> 21                  Germany      2001-2003   janssen_vas          EQ-5D-3L
#> 22                   Greece           1998 janssen_euvas          EQ-5D-3L
#> 23                  Hungary           2000 janssen_euvas          EQ-5D-3L
#> 24                    Italy      2001-2003 janssen_euvas          EQ-5D-3L
#> 25                    Italy      2001-2003   janssen_tto          EQ-5D-3L
#> 26              Netherlands      2001-2003 janssen_euvas          EQ-5D-3L
#> 27              Netherlands      2001-2003   janssen_tto          EQ-5D-3L
#> 28              New Zealand           1999 janssen_euvas          EQ-5D-3L
#> 29              New Zealand           1999   janssen_vas          EQ-5D-3L
#> 30        Republic of Korea           2007 janssen_euvas          EQ-5D-3L
#> 31        Republic of Korea           2007   janssen_tto          EQ-5D-3L
#> 32                  Romania      2018-2019        rom_3L          EQ-5D-3L
#> 33                  Romania      2018-2019        rom_5L          EQ-5D-5L
#> 34                 Slovenia           2000 janssen_euvas          EQ-5D-3L
#> 35                 Slovenia           2000   janssen_vas          EQ-5D-3L
#> 36                    Spain      2001-2003 janssen_euvas          EQ-5D-3L
#> 37                    Spain      2001-2003   janssen_tto          EQ-5D-3L
#> 38                    Spain      2001-2003   janssen_vas          EQ-5D-3L
#> 39                   Sweden           1994 janssen_euvas          EQ-5D-3L
#> 40                 Thailand           2007 janssen_euvas          EQ-5D-3L
#> 41           United Kingdom           1993 janssen_euvas          EQ-5D-3L
#> 42           United Kingdom           1993   janssen_tto          EQ-5D-3L
#> 43           United Kingdom           1993   janssen_vas          EQ-5D-3L
#> 44           United Kingdom           1993           mvh          EQ-5D-3L
#> 45 United States of America      2000-2002 janssen_euvas          EQ-5D-3L
#> 46 United States of America      2000-2002   janssen_tto          EQ-5D-3L
#>           value_set_country value_set_version value_set_type value_set_year
#> 1                    Europe                              VAS               
#> 2                 Argentina                              TTO               
#> 3                 Argentina                              VAS               
#> 4                    Europe                              VAS               
#> 5                   Belgium                              VAS               
#> 6                    Europe                              VAS               
#> 7                    Europe                              VAS               
#> 8                   Denmark                              TTO               
#> 9                   Denmark                              VAS               
#> 10                   Europe                              VAS               
#> 11                  England                              TTO               
#> 12                  England                              VAS               
#> 13                  England          EQ-5D-3L            DSU           1993
#> 14                  England          EQ-5D-3L             CW           1993
#> 15                   Europe                              VAS               
#> 16                  Finland                              VAS               
#> 17                   Europe                              VAS               
#> 18                   France                              TTO               
#> 19                   Europe                              VAS               
#> 20                  Germany                              TTO               
#> 21                  Germany                              VAS               
#> 22                   Europe                              VAS               
#> 23                   Europe                              VAS               
#> 24                   Europe                              VAS               
#> 25                    Italy                              TTO               
#> 26                   Europe                              VAS               
#> 27              Netherlands                              TTO               
#> 28                   Europe                              VAS               
#> 29              New Zealand                              VAS               
#> 30                   Europe                              VAS               
#> 31        Republic of Korea                              TTO               
#> 32                  Romania          EQ-5D-3L           cTTO      2018-2019
#> 33                  Romania          EQ-5D-5L             VT      2018-2019
#> 34                   Europe                              VAS               
#> 35                 Slovenia                              VAS               
#> 36                   Europe                              VAS               
#> 37                    Spain                              TTO               
#> 38                    Spain                              VAS               
#> 39                   Europe                              VAS               
#> 40                   Europe                              VAS               
#> 41                   Europe                              VAS               
#> 42           United Kingdom                              TTO               
#> 43           United Kingdom                              VAS               
#> 44           United Kingdom          EQ-5D-3L            TTO           1993
#> 45                   Europe                              VAS               
#> 46 United States of America                              TTO               
#>    default
#> 1    FALSE
#> 2     TRUE
#> 3    FALSE
#> 4    FALSE
#> 5     TRUE
#> 6     TRUE
#> 7    FALSE
#> 8     TRUE
#> 9    FALSE
#> 10   FALSE
#> 11   FALSE
#> 12   FALSE
#> 13    TRUE
#> 14   FALSE
#> 15   FALSE
#> 16    TRUE
#> 17   FALSE
#> 18    TRUE
#> 19   FALSE
#> 20    TRUE
#> 21   FALSE
#> 22    TRUE
#> 23    TRUE
#> 24   FALSE
#> 25    TRUE
#> 26   FALSE
#> 27    TRUE
#> 28   FALSE
#> 29    TRUE
#> 30   FALSE
#> 31    TRUE
#> 32    TRUE
#> 33   FALSE
#> 34   FALSE
#> 35    TRUE
#> 36   FALSE
#> 37    TRUE
#> 38   FALSE
#> 39    TRUE
#> 40    TRUE
#> 41   FALSE
#> 42   FALSE
#> 43   FALSE
#> 44    TRUE
#> 45   FALSE
#> 46    TRUE
get_norm_info(country = "England")
#>   norm_country eq5d_data_year       norm_id eq5d_data_version value_set_country
#> 1      England           2008 janssen_euvas          EQ-5D-3L            Europe
#> 2      England           2008   janssen_tto          EQ-5D-3L           England
#> 3      England           2008   janssen_vas          EQ-5D-3L           England
#> 4      England      2017-2018   vih_primary          EQ-5D-5L           England
#> 5      England      2017-2018 vih_secondary          EQ-5D-5L           England
#>   value_set_version value_set_type value_set_year default
#> 1                              VAS                  FALSE
#> 2                              TTO                  FALSE
#> 3                              VAS                  FALSE
#> 4          EQ-5D-3L            DSU           1993    TRUE
#> 5          EQ-5D-3L             CW           1993   FALSE
```
