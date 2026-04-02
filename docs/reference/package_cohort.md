# Return population data stored by package

Return population data stored by package

## Usage

``` r
package_cohort(country, year)
```

## Arguments

- country:

  `[string]`

  The name of a country (for which data is available & stored in the
  package). Case-sensitive. Please use function `hrqol_norms` to see the
  list of permissible country names.

- year:

  `[integer]`

  A year (for which data is available & stored in the package).

## Value

A data frame, containing population data for the chosen country and
year.

## Examples

``` r
package_cohort(country = "Romania", year = 2022)
#>        sex age    count
#> 1   female   0  90186.5
#> 2     male   0  95036.5
#> 3   female   1  91387.0
#> 4     male   1  96506.0
#> 5   female   2  94625.5
#> 6     male   2  99351.5
#> 7   female   3  98734.0
#> 8     male   3 102915.0
#> 9   female   4 101340.5
#> 10    male   4 105859.0
#> 11  female   5 102128.0
#> 12    male   5 106854.0
#> 13  female   6 100515.0
#> 14    male   6 105217.5
#> 15  female   7  98829.0
#> 16    male   7 103423.5
#> 17  female   8  98006.5
#> 18    male   8 102429.0
#> 19  female   9  98619.5
#> 20    male   9 103069.5
#> 21  female  10  99315.0
#> 22    male  10 103926.5
#> 23  female  11 102352.5
#> 24    male  11 106775.0
#> 25  female  12 107345.5
#> 26    male  12 111924.0
#> 27  female  13 108951.0
#> 28    male  13 114051.0
#> 29  female  14 107547.5
#> 30    male  14 112506.0
#> 31  female  15 106339.5
#> 32    male  15 110777.5
#> 33  female  16 107032.5
#> 34    male  16 111166.5
#> 35  female  17 105926.0
#> 36    male  17 110200.5
#> 37  female  18 102740.5
#> 38    male  18 107178.5
#> 39  female  19  97705.5
#> 40    male  19 101891.5
#> 41  female  20  94462.5
#> 42    male  20  98565.0
#> 43  female  21  96822.0
#> 44    male  21 101126.0
#> 45  female  22  98910.0
#> 46    male  22 103320.5
#> 47  female  23  99273.0
#> 48    male  23 103487.5
#> 49  female  24  98606.0
#> 50    male  24 102833.0
#> 51  female  25  96798.5
#> 52    male  25 101277.0
#> 53  female  26  96418.5
#> 54    male  26 101032.5
#> 55  female  27  98279.5
#> 56    male  27 103167.5
#> 57  female  28  99758.5
#> 58    male  28 104816.0
#> 59  female  29 101338.0
#> 60    male  29 107028.5
#> 61  female  30 103659.0
#> 62    male  30 109916.5
#> 63  female  31 111865.0
#> 64    male  31 118353.0
#> 65  female  32 125097.5
#> 66    male  32 132084.0
#> 67  female  33 133381.0
#> 68    male  33 141071.0
#> 69  female  34 135656.0
#> 70    male  34 144036.5
#> 71  female  35 132874.5
#> 72    male  35 141258.5
#> 73  female  36 128279.5
#> 74    male  36 136887.0
#> 75  female  37 123241.0
#> 76    male  37 132244.0
#> 77  female  38 109083.5
#> 78    male  38 118533.0
#> 79  female  39 107049.0
#> 80    male  39 117012.5
#> 81  female  40 124205.0
#> 82    male  40 133864.5
#> 83  female  41 135004.0
#> 84    male  41 144231.5
#> 85  female  42 140662.0
#> 86    male  42 149923.5
#> 87  female  43 145024.5
#> 88    male  43 153644.5
#> 89  female  44 148473.5
#> 90    male  44 156071.5
#> 91  female  45 150220.5
#> 92    male  45 156633.5
#> 93  female  46 149224.0
#> 94    male  46 154741.5
#> 95  female  47 150125.0
#> 96    male  47 155110.0
#> 97  female  48 145646.0
#> 98    male  48 149541.0
#> 99  female  49 141185.0
#> 100   male  49 144235.5
#> 101 female  50 144367.5
#> 102   male  50 148379.0
#> 103 female  51 149455.5
#> 104   male  51 152896.0
#> 105 female  52 160997.0
#> 106   male  52 161850.0
#> 107 female  53 180062.0
#> 108   male  53 178428.0
#> 109 female  54 185535.5
#> 110   male  54 181918.0
#> 111 female  55 142979.5
#> 112   male  55 139875.0
#> 113 female  56 104152.0
#> 114   male  56 100763.0
#> 115 female  57 102801.5
#> 116   male  57  98051.5
#> 117 female  58 104424.0
#> 118   male  58  98356.0
#> 119 female  59 107083.5
#> 120   male  59  98111.5
#> 121 female  60 109203.5
#> 122   male  60  97947.5
#> 123 female  61 113189.5
#> 124   male  61  99712.0
#> 125 female  62 120645.5
#> 126   male  62 101935.0
#> 127 female  63 128567.5
#> 128   male  63 104200.0
#> 129 female  64 135612.5
#> 130   male  64 107476.5
#> 131 female  65 141080.5
#> 132   male  65 112095.5
#> 133 female  66 147097.0
#> 134   male  66 116159.5
#> 135 female  67 144805.0
#> 136   male  67 110681.5
#> 137 female  68 135852.5
#> 138   male  68 101355.0
#> 139 female  69 131853.0
#> 140   male  69  97231.5
#> 141 female  70 128745.5
#> 142   male  70  93676.0
#> 143 female  71 127295.5
#> 144   male  71  91127.5
#> 145 female  72 127889.5
#> 146   male  72  89455.5
#> 147 female  73 115556.5
#> 148   male  73  78975.0
#> 149 female  74  97483.0
#> 150   male  74  66341.5
#> 151 female  75  90781.0
#> 152   male  75  60868.0
#> 153 female  76  81054.5
#> 154   male  76  52424.0
#> 155 female  77  75456.5
#> 156   male  77  47119.5
#> 157 female  78  72661.0
#> 158   male  78  43979.0
#> 159 female  79  66930.0
#> 160   male  79  39199.0
#> 161 female  80  66204.0
#> 162   male  80  37224.0
#> 163 female  81  65604.5
#> 164   male  81  35528.0
#> 165 female  82  65403.5
#> 166   male  82  34227.5
#> 167 female  83  62590.0
#> 168   male  83  31621.5
#> 169 female  84  56464.0
#> 170   male  84  27901.5
#> 171 female  85  50166.0
#> 172   male  85  24362.5
#> 173 female  86  42735.0
#> 174   male  86  20474.0
#> 175 female  87  35439.5
#> 176   male  87  16730.0
#> 177 female  88  29516.5
#> 178   male  88  13740.5
#> 179 female  89  24913.5
#> 180   male  89  11601.5
#> 181 female  90  20067.5
#> 182   male  90   9207.0
#> 183 female  91  15040.0
#> 184   male  91   6753.5
#> 185 female  92  11187.5
#> 186   male  92   4983.0
#> 187 female  93   8125.0
#> 188   male  93   3607.5
#> 189 female  94   5744.0
#> 190   male  94   2566.0
#> 191 female  95   3980.0
#> 192   male  95   1806.0
#> 193 female  96   2700.0
#> 194   male  96   1266.0
#> 195 female  97   1734.5
#> 196   male  97    857.0
#> 197 female  98   1023.5
#> 198   male  98    541.5
#> 199 female  99    521.5
#> 200   male  99    309.5
```
