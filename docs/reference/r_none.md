# No discount rate

One of a set of functions that can be passed to argument `r` in the
`calculate_dQALY` function, that implement common discounting regimes.
Passing `r_none` to `calculate_dQALY` means choosing not to apply a
discount rate when calculating QALY loss due to death (setting the
discount rate to zero).

## Usage

``` r
r_none(x)
```

## Arguments

- x:

  `[numeric]`

  Number of years into the future.

## Value

`[numeric]`

Discount rate `x` years the future.

## Details

See also functions `r_default`, `r_health`, `r_lt_health`,
`r_lt_health_reduced`.

## Examples

``` r
r_none(10)
#> [1] 0
r_none(50)
#> [1] 0
r_none(100)
#> [1] 0
```
