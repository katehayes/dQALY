# NICE Reference Case Discount Rate

One of a set of functions that can be passed to argument `r` in the
`calculate_dQALY` function, that implement common discounting regimes.
Passing `r_default` to `calculate_dQALY` means choosing to apply the
NICE reference case discount rate of 3.5% when calculating QALY loss due
to death.

## Usage

``` r
r_default(x)
```

## Arguments

- x:

  `[numeric]`

  Number of years into the future.

## Value

`[numeric]`

Discount rate `x` years the future.

## Details

See also functions `r_none`, `r_health`, `r_lt_health`,
`r_lt_health_reduced`.

## Examples

``` r
r_default(10)
#> [1] 0.035
r_default(50)
#> [1] 0.035
r_default(100)
#> [1] 0.035
```
