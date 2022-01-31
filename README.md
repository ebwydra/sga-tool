# sga-tool
R Shiny app for determining whether babies are small for their gestational age (SGA) at birth. Cutoffs for SGA represent 10th percentile weights from [Fenton Preterm Growth Charts](https://www.ucalgary.ca/fenton). Cutoffs are available for 22 weeks 4 days (22.57 weeks) through 45 weeks 0 days (45.00 weeks) gestational age.

Check it out at: https://ebwydra.shinyapps.io/sga-tool/

## Required R packages

The following packages are required: `shiny`, `dplyr`, `tidyr`, `stringr`, `ggplot2`, `bslib`, `ggimage`

These packages can be installed by running the following code in R:

``` r
install.packages(c("shiny", "dplyr", "tidyr", "stringr", "ggplot2", "bslib", "ggimage"))
```

## How to run

Clone this repo or save all files needed to run the app (`global.R`, `server.R`, `ui.R`, and `baby.png`, along with the `data/` and `templates/` directories) locally in a directory called sga-tool.

It's easy to run Shiny apps locally using RStudio. Once the Shiny package is installed and attached, RStudio will automatically recognize the `global.R`, `server.R`, and `ui.R` files as part of a Shiny app and will give you the option to "Run App" instead of the usual "Run" button.

Alternatively, you can run the app from the console:

``` r
runApp("sga-tool")
```
