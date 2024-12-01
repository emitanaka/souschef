
#' Create a named experimental design with context
#'
#' Similar to `takeout()`, this function generates a named experimental design
#' but makes up a context.
#'
#' @param recipe The name of the experimental design specified as character,
#'   or a recipe deisgn.
#' @param show Whether to show the code or not.
#' @param context A text describing the context.
#'
#' @examples
#' takeauto()
#'
#'
#' @export
takeauto <- function(recipe = NULL, show = TRUE, context = "") {
  if(is.null(recipe)) {
    cli::cli_alert("No name was supplied so selecting a random named experimental design...")
    menu_all <- scan_menu()
    iselect <- sample(seq(nrow(menu_all)), 1L)
    name <- menu_all$name[iselect]
    name_full <- menu_all$name_full[iselect]
    cli::cli_alert("Selected {name_full}")
  } else if(is.character(recipe)) {
    # allow for name of the recipe
    name <- recipe
  } else if(inherits(recipe, "recipe_design")) {
    name <- recipe$name
  } else {
    cli::cli_abort("The supplied recipe must be NULL, a string for design name, or a recipe design object.")
  }

  menu_fn <- paste0("menu_", name)
  argsv <- formals(menu_fn)
  args_names <- names(argsv)[grepl("name_", names(argsv))]
  title <- argsv$name_title %||% name
  title <- sample(title, 1) # in case more than one full name

  chat <- chat_model(system_prompt = glue_c("The user is trying to design an experiment using {title}.
                                            Give a concrete example {context}.
                                            Return as a json object."),
                     echo = FALSE,
                     api_args = list(response_format = list(type = "json_object")))

  fcts <- argsv[setdiff(args_names, "name_title")]
  fcts <- gsub("unit", "experimental unit", fcts)
  ret <- chat$chat(glue_c("Give me the title, {fcts*} as names (one or two words at most) in the same order as given."))
  ret <- jsonlite::fromJSON(ret)
  if(length(ret) != (length(fcts) + 1L)) {
    cli::cli_abort("The number of results from LLM did not match the expected number of factors. Retry again.")
  }
  for(afct in names(ret)[-1]) {
    if(length(ret[[afct]]) > 1) {
      out <- chat$chat(glue_c("Given {ret[[afct]]*}, describe it in one or at most two words.")) |>
        jsonlite::fromJSON()
      ret[[afct]] <- make_robj_name(out[[1]])
    } else {
      ret[[afct]] <- make_robj_name(ret[[afct]])
    }
  }
  names(ret) <- args_names
  out_recipe <- do.call(menu_fn, ret)
  df <- eval(parse(text = cli::ansi_strip(out_recipe$code)))

  res <- structure(df,
                   class = c("takeout", class(df)),
                   recipe = out_recipe,
                   show = show)
  return(res)
}
