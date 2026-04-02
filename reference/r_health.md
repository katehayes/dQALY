# Green Book Health Discount Rate

One of a set of functions that can be passed to argument `r` in the
`calculate_dQALY` function, that implement common discounting regimes.
Passing `r_health` to `calculate_dQALY` means choosing to apply the NICE
alternative discount rate/ Green Book recommended discount rate for
health or life values of 1.5% when calculating QALY loss due to death.

## Usage

``` r
r_health(x)
```

## Arguments

- x:

  `[numeric]`

  Number of years into the future.

## Value

`[numeric]`

Discount rate `x` years the future.

## Details

See also functions `r_none`, `r_default`, `r_lt_health`,
`r_lt_health_reduced`.

## Examples

``` r
r_health(10)
#> [1] 0.015
r_health(50)
#> [1] 0.015
r_health(100)
#> [1] 0.015
```
