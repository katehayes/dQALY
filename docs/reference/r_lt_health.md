# Green Book Long Term Health Discount Rate

One of a set of functions that can be passed to argument `r` in the
`calculate_dQALY` function, that implement common discounting regimes.
Passing `r_lt_health` to `calculate_dQALY` means choosing to apply the
Green Book recommended declining long term discount rate for health or
life values when calculating QALY loss due to death.

## Usage

``` r
r_lt_health(x)
```

## Arguments

- x:

  `[numeric]`

  Number of years into the future.

## Value

`[numeric]`

Discount rate `x` years the future.

## Details

See also functions `r_none`, `r_default`, `r_health`,
`r_lt_health_reduced`.

## Examples

``` r
r_lt_health(10)
#> [1] 0.015
r_lt_health(50)
#> [1] 0.0129
r_lt_health(100)
#> [1] 0.0107
```
