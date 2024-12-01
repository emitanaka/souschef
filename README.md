

<!-- README.md is generated from README.Rmd. Please edit that file -->

# souschef

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

This package is a **work-in-progress**! You need the [latest development
version of edibble](https://github.com/emitanaka/edibble) for some
functions to work.

Currently the default is to use llama3.1:8b but in future, my plan is to
use Open AI gpt models as the default.

## Installation

You can install the development version of souschef as:

``` r
# install.packages("pak")
pak::pak("emitanaka/souschef")
```

## Example

``` r
library(souschef)
#> Loading required package: edibble
```

Let’s make up an experiment. Let’s be lazy and choose a random named
experiment with some made up context.

``` r
some_experiment <- takeauto()
#> → No name was supplied so selecting a random named experimental design...
#> → Selected Completely Randomised Design
some_experiment
#> design("Fertilizer Effect") %>%
#>   set_units(Plot = 18) %>%
#>   set_trts(Fertilizer.Effect = 2) %>%
#>   allot_trts(Fertilizer.Effect ~ Plot) %>%
#>   assign_trts("random", seed = 215) %>%
#>   serve_table() 
#> 
#> # Fertilizer Effect 
#> # An edibble: 18 x 2
#>       Plot  Fertilizer.Effect
#>  * <U(18)>             <T(2)>
#>      <chr>              <chr>
#>  1  Plot01 Fertilizer.Effect2
#>  2  Plot02 Fertilizer.Effect2
#>  3  Plot03 Fertilizer.Effect1
#>  4  Plot04 Fertilizer.Effect1
#>  5  Plot05 Fertilizer.Effect1
#>  6  Plot06 Fertilizer.Effect1
#>  7  Plot07 Fertilizer.Effect1
#>  8  Plot08 Fertilizer.Effect2
#>  9  Plot09 Fertilizer.Effect2
#> 10  Plot10 Fertilizer.Effect2
#> 11  Plot11 Fertilizer.Effect1
#> 12  Plot12 Fertilizer.Effect2
#> 13  Plot13 Fertilizer.Effect1
#> 14  Plot14 Fertilizer.Effect2
#> 15  Plot15 Fertilizer.Effect1
#> 16  Plot16 Fertilizer.Effect1
#> 17  Plot17 Fertilizer.Effect2
#> 18  Plot18 Fertilizer.Effect2
```

Describe the context in words. The output here is just a simple direct
translation from the given edibble object.

``` r
describe_context(some_experiment)
#> Title: Fertilizer Effect
#> Units: Plot
#> Treatments: Fertilizer.Effect
#> Mappings: Fertilizer.Effect is assigned to Plot
```

We can expand the context more eloquently with a LLM.

``` r
describe_scenario(some_experiment)
#> This appears to be a description of an agricultural or gardening type experiment.
#> 
#> The experiment seems to be investigating the effect of different fertilizers on plant growth, presumably in plots. The treatments (factors being tested) are the various types of fertilizers, and each plot receives a specific fertilizer treatment. 
#> 
#> Here's how I would describe the experiment:
#> 
#> **Purpose:** This experiment aims to compare and contrast the effects of different fertilizers on plant growth and development in controlled plots.
#> 
#> **Methodology:**
#> 
#> 1. Various plots are designated for use.
#> 2. Each plot is assigned a different type of fertilizer, representing multiple fertilizer treatments (e.g., regular fertilizer, organic fertilizer, etc.).
#> 
#> 3. The experiment likely observes key variables such as:
#>    - Growth parameters (e.g., height, leaf area index, etc.)  
#>    - Yield (measured in quantity and quality) 
#>    - Visual inspection to identify effects on foliage color, texture, disease prevalence and overall vigor.
#> 
#> **Primary Research Question:**
#> 
#> - How does different fertilizers impact plant growth outcomes?
```

We can ask our LLM assistant for ideas about the experimental design.

``` r
ideate_design(some_experiment)
#> Based on the provided information, here are some suggested improvements to the experimental design:
#> 
#> 1. **Replication**: Each treatment should be replicated multiple times (e.g., 3-5 replicates) across different plots. This ensures that any observed differences are not due to chance or a specific plot characteristic but rather the effect of the fertilizer.
#> 
#> 2. **Control Group**: Including a control group receiving no fertilization would serve as a baseline for comparisons, making it easier to assess the actual impact of each fertilizer type over just varying levels of some application (fertilizer).
#> 
#> 3. **Multiple Application Rates or Timing**: If the goal is to understand optimal use, consider varying the rate at which different fertilizers are applied across plots. This could help in pinpointing whether there's an ideal concentration for maximum yield. 
#> 
#> 4. **Randomization**: While it seems like plots were assigned treatments randomly ("Mappings: Fertilizer.Effect is assigned to Plot"), explicitly stating this within the experimental design section can help ensure that future studies adhere to similar protocols.
#> 
#> 5. **Sampling Strategy**: For measurements or outcome analysis, consider a balanced incomplete block (BIB) design where each fertilizer type is represented across multiple plots with varying complements of treatments, helping to eliminate bias due to plot-specific factors.
#> 
#> 6. **Measure Outcomes Directly Relevant to Fertilizer Use**: Instead of assuming plant yield as the primary metric, directly measure effects or consider outcomes such as soil pH change, nutrient uptake rates by plants, microbial communities, and other indicators directly linked to fertilizer impact.
#> 
#> 7. **Long-Term Observations**: Incorporate provisions for observing these plots over prolonged periods. Fertilizer efficacy can vary significantly depending on growth stages, especially considering delayed effectiveness in some soil conditions.
#> 
#> 8. **Controlling Other Variables**: Identify and control factors like climate variations (precipitation), sunlight exposure levels (microclimates within the larger field or greenhouse settings), as such parameters would directly impact plant growth response to different fertilizers.
#> 
#> 9. **Multiple Data Collectors**: Have multiple individuals, blinded to treatment types where appropriate, collect data to rule out measurement errors potentially biasing results towards an expected outcome.
#> 
#> Adopting these measures can enhance the experimental design's sensitivity and provide insights that are not as significantly influenced by random chance or other irrelevant variables.
```

Or more broadly about ideas for the experiment.

``` r
ideate_experiment(some_experiment)
#> Based on the provided structure and description of the "Fertilizer Effect" experiment, here are some suggestions for improvement:
#> 
#> 1. **Add a Control Group**:
#>    Include an untreated control plot or plot(s) that receive no fertilizer application as a baseline comparison. This would allow researchers to understand the natural variability within the system and provide a standard against which the effects of fertilizers can be compared.
#> 
#> 2. **Increase Numerosity and Replication**:
#>    Conducting the experiment on more than one unit (i.e., having multiple plots) and replicating the study in different environmental conditions, if possible, could enhance the reliability of the results by accounting for any uncontrolled variables such as seasonal changes or unique soil characteristics.
#> 
#> 3. **Consider Additional Factors**:
#>    In addition to fertilizer type, consider studying other factors that might influence the outcome, such as timing of application (pre-planting vs. at planting), dose (quantity of fertilizer used), and crop variety/age when comparing different fertilization methods.
#> 
#> 4. **Precise Definitions of Treatments**:
#>    Elaborate on what is meant by "Fertilizer.Effect". For example, are treatments for specific nutrients lacking in the soil (e.g., nitrogen, phosphorus), types of fertilizers (organic vs. synthetic), application rates, or the timing of these applications being compared?
#> 
#> 5. **Statistical Analysis and Data Collection**:
#>    Ensure that a systematic approach is taken to collecting data throughout the experiment. Implement randomization and proper controls for confounding variables across treatment groups. Consider employing advanced statistical methods like MANOVA (Multivariate Analysis of Variance) or regression analysis, if appropriate for the design.
#> 
#> 6. **Measure Outcome Variables Carefully**:
#>    Clearly define what you mean by "effect" in the context of fertilizers (e.g., yield, plant height, color intensity). Develop a detailed protocol for how these measures will be taken, ideally using reliable and precise instruments or methods to accurately attribute any differences observed across treatment groups.
#> 
#> 7. **Consider an Experimental Design Other Than Mapped Treatments**:
#>    Think about employing a randomized complete block design (RCBD), split plots, replicated nested, latin square designs if your treatments, blocks, replicates etc., are different in character. The standard mapping of the experiment as shown here is straightforward for comparison but does not optimize yields with factors having high variance.
#> 
#> 8. **Document and Consider Ethics**:
#>    Document and consider any potential risks when carrying out agricultural/field experiments (e.g., pesticide use, safety around agricultural equipment). This would involve obtaining necessary permissions and conducting your study in compliance with all regulatory stipulations and scientific ethics guidelines.
#> 
#> By addressing these suggestions, the experiment can be made more robust scientifically to yield meaningful improvements on how different fertilizers affect a specified system.
```

Context-aware simulation

``` r
des <- design("Wheat yield experiment") |> 
    set_units(mainplot = 30,
              subplot = nested_in(mainplot, 4)) |>
    set_trts(fertilizer = LETTERS[1:3],
             irrigation = 2) |>
    allot_trts(fertilizer ~ mainplot,
               irrigation ~ subplot) |>
    assign_trts("random", seed = 719) |>
    serve_table() |>
    set_rcrds(biomass = mainplot,
              yield = subplot,
              quality_score = subplot)

autosim_rcrds(des)
#> # Wheat yield experiment 
#> # An edibble: 120 x 8
#>      mainplot    subplot fertilizer irrigation biomass yield quality_score  .sim
#>       <U(30)>   <U(120)>     <T(3)>     <T(2)>                                  
#>         <chr>      <chr>      <chr>      <chr> <fct>   <int> <fct>         <int>
#>  1 mainplot01 subplot001          A irrigatio… low       221 very_low          1
#>  2 mainplot01 subplot002          A irrigatio… low        NA very_low          1
#>  3 mainplot01 subplot003          A irrigatio… low       231 medium            1
#>  4 mainplot01 subplot004          A irrigatio… low       237 medium            1
#>  5 mainplot02 subplot005          C irrigatio… medium    876 low               1
#>  6 mainplot02 subplot006          C irrigatio… medium    931 low               1
#>  7 mainplot02 subplot007          C irrigatio… medium    917 low               1
#>  8 mainplot02 subplot008          C irrigatio… medium    937 low               1
#>  9 mainplot03 subplot009          C irrigatio… high     1147 low               1
#> 10 mainplot03 subplot010          C irrigatio… high      805 low               1
#> # ℹ 110 more rows
```

## Naming credit

The name `souschef` was inspired by Francis Hui from the idea of a sous
chef in the kitchen. The sous-chef is a chef who is second-in-command in
a kitchen. This is a metaphor for the role of the package in assisting
the user in the design of experiments.
