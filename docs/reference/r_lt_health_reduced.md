# Green Book Reduced Long Term Health Discount Rate

One of a set of functions that can be passed to argument `r` in the
`calculate_dQALY` function, that implement common discounting regimes.
Passing `r_lt_health_reduced` to `calculate_dQALY` means choosing to
apply the Green Book recommended rate reduced by excluding pure social
time preference (relevant if intervention may effect
substantial/irreversible wealth transfers between generations) when
calculating QALY loss due to death.

## Usage

``` r
r_lt_health_reduced(x)
```

## Arguments

- x:

  `[numeric]`

  Number of years into the future.

## Value

`[numeric]`

Discount rate `x` years the future.

## Details

See also functions `r_none`, `r_default`, `r_health`, `r_lt_health`.

## Examples

``` r
r_lt_health_reduced(10)
#> [1] 0.01
r_lt_health_reduced(50)
#> [1] 0.0086
r_lt_health_reduced(100)
#> [1] 0.0071
```
