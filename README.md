

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
#> → Selected Strip-Plot Design, Strip-Unit Design
some_experiment
#> design("Soil Fertility") %>%
#>   set_units(Farmer.John = 7,
#>             Treatment.A = nested_in(Farmer.John, 10),
#>             Location.X = nested_in(Farmer.John, 3),
#>             Plot = nested_in(Farmer.John, crossed_by(Treatment.A, Location.X))) %>%
#>   set_trts(NPK.Fert = 10,
#>            Organic.Manure = 3) %>%
#>   allot_trts(NPK.Fert ~ Treatment.A,
#>              Organic.Manure ~ Location.X) %>%
#>   assign_trts("random", seed = 454) %>%
#>   serve_table() 
#> 
#> # Soil Fertility 
#> # An edibble: 210 x 6
#>     Farmer.John   Treatment.A   Location.X     Plot   NPK.Fert  Organic.Manure
#>  *       <U(7)>       <U(70)>      <U(21)> <U(210)>    <T(10)>          <T(3)>
#>           <chr>         <chr>        <chr>    <chr>      <chr>           <chr>
#>  1 Farmer.John1 Treatment.A01 Location.X01  Plot001 NPK.Fert10 Organic.Manure3
#>  2 Farmer.John1 Treatment.A02 Location.X01  Plot002 NPK.Fert04 Organic.Manure3
#>  3 Farmer.John1 Treatment.A03 Location.X01  Plot003 NPK.Fert05 Organic.Manure3
#>  4 Farmer.John1 Treatment.A04 Location.X01  Plot004 NPK.Fert08 Organic.Manure3
#>  5 Farmer.John1 Treatment.A05 Location.X01  Plot005 NPK.Fert06 Organic.Manure3
#>  6 Farmer.John1 Treatment.A06 Location.X01  Plot006 NPK.Fert01 Organic.Manure3
#>  7 Farmer.John1 Treatment.A07 Location.X01  Plot007 NPK.Fert07 Organic.Manure3
#>  8 Farmer.John1 Treatment.A08 Location.X01  Plot008 NPK.Fert03 Organic.Manure3
#>  9 Farmer.John1 Treatment.A09 Location.X01  Plot009 NPK.Fert09 Organic.Manure3
#> 10 Farmer.John1 Treatment.A10 Location.X01  Plot010 NPK.Fert02 Organic.Manure3
#> # ℹ 200 more rows
```

Describe the context in words. The output here is just a simple direct
translation from the given edibble object.

``` r
describe_context(some_experiment)
#> Title: Soil Fertility
#> Units: Farmer.John, Treatment.A, Location.X, Plot
#> Treatments: NPK.Fert, Organic.Manure
#> Mappings: Farmer.John is nested in Treatment.A, Farmer.John is nested in Location.X, Farmer.John is nested in Plot, Treatment.A is related to Plot, Location.X is related to Plot, NPK.Fert is assigned to Treatment.A, Organic.Manure is assigned to Location.X
```

We can expand the context more eloquently with a LLM.

``` r
describe_scenario(some_experiment)
#> Based on the structure of the experiment, here's a description:
#> 
#> **Soil Fertility Experiment**
#> 
#> This experimental design aims to investigate the effect of two soil fertility treatments on crop growth. The experiment involves multiple levels of nesting and relationships between different factors.
#> 
#> **Layers of Nesting:**
#> 
#> 1. **Farmer**: Farmer.John is at the top level, indicating that the experiment is conducted by a single farmer (Farmer.John).
#> 2. **Treatment**: Treatment.A is nested within Farmer.John, suggesting two fertility treatments are being tested (NPK.Fert and Organic.Manure).
#> 3. **Location**: Location.X is also nested within each treatment (Treatment.A), implying multiple locations or plots where the treatments are applied.
#> 4. **Plot**: Each location (Location.X) contains multiple plots where the experiments are conducted.
#> 
#> **Relationships:**
#> 
#> * Treatment.A is related to Plot, meaning each plot receives one of the two treatments (NPK.Fert or Organic.Manure).
#> * Location.X is related to Plot, indicating that each location has multiple plots for the experiment.
#> * NPK.Fert and Organic.Manure are assigned to Treatment.A and Location.X, respectively, showing which treatment is applied in each case.
#> 
#> In summary, this design measures the effect of two soil fertility treatments (NPK.Fert and Organic.Manure) across multiple locations and plots, all conducted by the same farmer (Farmer.John). The experiment aims to compare the outcomes of these different treatment approaches on soil fertility.
```

We can ask our LLM assistant for ideas about the experimental design.

``` r
ideate_design(some_experiment)
#> Based on the previous context, here are some suggestions for improving the experimental design:
#> 
#> 1. **Replication:** The current design has only one replication of each treatment within Location.X and Plot. Consider adding multiple replications (e.g., 4-6) per treatment group to increase statistical power and account for variability.
#> 
#> 2. **Randomization:** Make sure that plots and locations were randomly assigned to treatments, rather than the treatments being applied to specific areas or based on farmer's judgment. This is critical in minimizing bias and ensuring generalizability of results.
#> 
#> 3. **Blocking:** If possible, block plots by factors like soil type, terrain slope, or vegetation cover. This can help reduce variability among plots due to non-treatment effects. Alternatively, consider splitting plots into smaller subplots (sub-locations) for more precise treatment application.
#> 
#> 4. **Additional Factors:** Incorporate other factors that might influence soil fertility, such as:
#>  * Timing of fertilizer/organic manure application
#>  * Doses/formulations of NPK.Fert and Organic.Manure
#>  * Pre-treatment characterization of soil properties (e.g., texture, pH)
#>  * Environmental conditions during sampling (weather patterns, temperature)
#> 
#> 5. **Sampling Strategy:** Instead of relying solely on Farmer.John for collecting samples, design the experiment to accommodate multiple observers or samplers. This adds robustness and redundancy in data collection.
#> 
#> 6. **Consider using a Split-Plot Design:**
#> If Treatment.A is really related to Plot at different locations within them (due to experimental requirements), but also to Location.X directly, it might simplify things if the treatment were truly a matter of how each was handled rather than an inherent trait.
#> With some data and research this might be the case.
```

Or more broadly about ideas for the experiment.

``` r
ideate_experiment(some_experiment)
#> Based on the experiment structure described, here are some suggestions for improvement:
#> 
#> 1. **Adding Replication:**
#>    - Each level of factor (farmer, treatment, location) lacks replication in the given context, which could introduce bias and limit the generalizability of findings. Including multiple replicates at each level would strengthen the experimental design.
#>    
#> 2. **Including a Control Group:**
#>    - Presently, treatments are being compared without a control group (plots to which neither treatment is applied). A control with no fertilizer added can serve as a baseline against which the two types of fertilizers can be compared, enhancing comprehension and relevance of results.
#> 
#> 3. **Randomization:**
#>    - Consider randomizing each plot allocation across different factors (e.g., treatments between plots within the same farmer) to ensure that any observed differences are due to the treatment rather than systematic variations between factors.
#> 
#> 4. **Monitoring Additional Variables:**
#>    - To better understand the effects of each fertilizer type, consider collecting data on additional variables such as crop yield, water consumption by plants, pest/disease prevalence, and environmental metrics (e.g., soil pH, biodiversity).
#> 
#> 5. **Slighting Factors for Comparison Within Treatments (Sub-Treatments):**
#>    - It might be useful to include a second level of factorial design within NPK.Fert and Organic.Manure treatments where factors are introduced that could potentially influence outcomes from these main treatments. For instance:
#>      - For NPK.Fert: Compare standard concentrations vs high concentration or different fertilizer-to-water ratios.
#>      - For Organic.Manure: Test manure quantity vs manure quality as variables influencing plot outcomes.
#> 
#> 6. **Location Variability (Soil Type, Etc.) Assessment:**
#>    - If Location (Site) is truly a controlling variable for Plot outcomes as per the design, exploring characteristics at each location independently (soils type, existing conditions, and their implications on crops) might help refine recommendations within broader insights.
#> 
#> 7. **Consideration of Temporal Variability:**
#>    - Given that soil fertility and responses from different fertilizers could shift over time, planning for at least yearly or two-year follow-up assessments is recommended to monitor sustainability and progression in outcomes as plots evolve under treatment conditions.
#> 
#> 8. **Data Analysis Methods Accounting for Complex Structure:**
#>    - The nested (or hierarchical) structure means the data's variance might differ in levels of granularity within the experiment. Thus, adopting more robust analytical techniques such as mixed-effect models, generalized least squares regression, or even machine learning algorithms with appropriate validation will help correctly interpreting relationships between variables considering this complex structure.
#> 
#> Implementing these considerations would strengthen the study's validity and allow for a comprehensive comparison between treatments based on multiple factors, offering deeper insights into soil fertility under different management scenarios.
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
#>  1 mainplot01 subplot001          A irrigatio… low       177 Poor              1
#>  2 mainplot01 subplot002          A irrigatio… low         0 Poor              1
#>  3 mainplot01 subplot003          A irrigatio… low       185 Good              1
#>  4 mainplot01 subplot004          A irrigatio… low       190 Good              1
#>  5 mainplot02 subplot005          C irrigatio… medium    701 Fair              1
#>  6 mainplot02 subplot006          C irrigatio… medium    745 Fair              1
#>  7 mainplot02 subplot007          C irrigatio… medium    734 Fair              1
#>  8 mainplot02 subplot008          C irrigatio… medium    750 Fair              1
#>  9 mainplot03 subplot009          C irrigatio… high      918 Fair              1
#> 10 mainplot03 subplot010          C irrigatio… high      644 Fair              1
#> # ℹ 110 more rows
```
