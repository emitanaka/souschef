test_that("context", {
  des <- design("Wheat yield experiment") %>%
    set_units(mainplot = 30,
              subplot = nested_in(mainplot, 4)) %>%
    set_trts(fertilizer = LETTERS[1:3],
             irrigation = 2) %>%
    allot_trts(fertilizer ~ mainplot,
               irrigation ~ subplot) %>%
    assign_trts("random", seed = 719) %>%
    serve_table() %>%
    set_rcrds(biomass = mainplot,
              yield = subplot,
              quality_score = subplot)





})
