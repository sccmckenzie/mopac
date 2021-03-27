
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mopac <img src='man/figures/logo.png' align="right" height="250" />

<!-- badges: start -->
<!-- badges: end -->

mopac provides a collection of datasets pertaining to Loop 1 “Mopac”
located in Austin, Texas.

## Installation

``` r
devtools::install_github("sccmckenzie/mopac")
```

## Datasets

-   `rush_hour`: Time series of real traffic observations, collected for
    this package.

``` r
mopac::rush_hour
#> # A tibble: 962 x 7
#>    day   time                commercial color type  make    model    
#>    <ord> <dttm>              <lgl>      <chr> <chr> <chr>   <chr>    
#>  1 Sun   2020-05-17 17:27:00 FALSE      Blue  Truck Ford    F-150    
#>  2 Sun   2020-05-17 17:27:02 FALSE      Grey  Sedan Honda   Civic    
#>  3 Sun   2020-05-17 17:27:02 FALSE      White SUV   Lexus   LX       
#>  4 Sun   2020-05-17 17:27:02 FALSE      Red   Truck GMC     Sierra   
#>  5 Sun   2020-05-17 17:27:03 FALSE      Green SUV   Honda   CR-V     
#>  6 Sun   2020-05-17 17:27:04 FALSE      Black SUV   Nissan  Rogue    
#>  7 Sun   2020-05-17 17:27:05 FALSE      Black Sedan Hyundai Genesis  
#>  8 Sun   2020-05-17 17:27:06 FALSE      Blue  SUV   GMC     Acadia   
#>  9 Sun   2020-05-17 17:27:06 FALSE      White SUV   Honda   Pilot    
#> 10 Sun   2020-05-17 17:27:07 FALSE      Blue  Van   Ford    Econoline
#> # ... with 952 more rows
```

-   `express`: Simulated express lane records, shares a similar
    structure as rush\_hour.

``` r
mopac::express
#> # A tibble: 13,032 x 6
#>    direction time                plate    make       model    color 
#>    <chr>     <dttm>              <chr>    <chr>      <chr>    <chr> 
#>  1 North     2020-05-20 05:00:33 DZR-9238 Mercedes   S-Series Black 
#>  2 North     2020-05-20 05:01:13 GRG-6684 Nissan     Altima   White 
#>  3 North     2020-05-20 05:03:47 QZS-9962 Mazda      6        Grey  
#>  4 North     2020-05-20 05:04:54 OHK-6273 BMW        i1       White 
#>  5 North     2020-05-20 05:10:41 EAS-7585 Ford       F-250    Blue  
#>  6 North     2020-05-20 05:13:53 OKP-1047 Dodge      Journey  White 
#>  7 North     2020-05-20 05:13:55 HNN-3587 Volkswagen Passat   Grey  
#>  8 North     2020-05-20 05:15:59 EWL-4779 Toyota     Venza    Silver
#>  9 North     2020-05-20 05:16:01 YVH-7047 GMC        Safari   White 
#> 10 North     2020-05-20 05:18:16 DLU-6632 Nissan     Titan    White 
#> # ... with 13,022 more rows
```

-   `rates`: Express lane rates for a typical weekday.

``` r
mopac::rates
#> # A tibble: 25 x 3
#>    direction time    rate
#>    <chr>     <time> <dbl>
#>  1 north     05:00   0.3 
#>  2 north     15:00   0.6 
#>  3 north     15:30   1.75
#>  4 north     16:00   1.61
#>  5 north     16:30   2.59
#>  6 north     17:00   3.74
#>  7 north     17:30   4.65
#>  8 north     18:00   5.1 
#>  9 north     18:30   2.44
#> 10 north     19:00   0.3 
#> # ... with 15 more rows
```

-   `exits`: Information for all Mopac exits.

``` r
mopac::exits
#> # A tibble: 32 x 4
#>       mi    km destination                       notes                          
#>    <dbl> <dbl> <chr>                             <chr>                          
#>  1   0     0   SH 45 west                        <NA>                           
#>  2   0.7   1.1 South Bay Lane                    At-grade intersection; dead en~
#>  3   1.5   2.4 La Crosse Avenue                  <NA>                           
#>  4   2.3   3.7 Slaughter Lane                    Diverging Diamond Interchange  
#>  5   2.9   4.7 Davis Lane                        Southbound exit and northbound~
#>  6   4.7   7.6 William Cannon Drive              <NA>                           
#>  7   6     9.7 US 290 / SH 71 / Southwest Parkw~ Access to Baylor Scott & White~
#>  8   6.6  10.6 Frontage Road                     Southbound exit only           
#>  9   7.5  12.1 Loop 360 (Capital of Texas Highw~ Only one exit ramp travels fro~
#> 10   8.9  14.3 Barton Skyway                     <NA>                           
#> # ... with 22 more rows
```
