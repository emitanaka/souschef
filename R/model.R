#' Create chat model
#'
#' This initiates an instance of the chat model specified
#' in the options. To get the current model, check `souschef_option_get("llm")`
#' and to set a different model, use `souschef_option_set("llm", list(vendor = "openai", model = "gpt-4o-mini"))`
#' replacing the vendor and vendor arguments. The model must be available in `elmer`.
#'
#' @param .edibble An edibble experimental design object.
#' @param ... Arguments parsed to the chat model.
#'
#' @export
chat_model <- function(...) {
  dots <- list(...)
  llm <- souschef_option_get("llm")
  for(name in names(dots)) {
    llm[[name]] <- dots[[name]]
  }
  vendor <- llm$vendor
  llm$vendor <- NULL
  do.call(eval(parse(text=paste0("elmer::chat_", vendor))), llm)
}


#' @rdname chat_model
#' @export
chat_design <- function(.edibble, ...) {
  vendor <- souschef_option_get("llm")$vendor
  if(vendor == "openai") {
    chat <- chat_model(..., echo = FALSE)
    prov <- activate_provenance(.edibble)
    lnodes <- prov$lvl_nodes
    get_factor_levels <- function(factor) {
      fid <- prov$fct_id(name = factor)
      lnodes[[as.character(fid)]]$value
    }
    get_factor_nlevels <- function(factor) {
      fid <- prov$fct_id(name = factor)
      length(lnodes[[as.character(fid)]]$value)
    }
    chat$register_tool(elmer::tool(
      get_factor_levels,
      "Get the levels of the specified factor",
      factor = elmer::type_string(
        "The name of the factor in the experimental design",
        required = TRUE
      )
    ))
    chat$register_tool(elmer::tool(
      get_factor_nlevels,
      "Get the number of levels of the specified factor",
      factor = elmer::type_string(
        "The name of the factor in the experimental design",
        required = TRUE
      )
    ))
    context <- describe_context(.edibble)
    chat$chat(paste0("The context of the experiment is as follows.", context))
    chat
  } else {
    cli::cli_abort("The tool calling for {vendor} does not work. You need to use an OpenAI model.")
  }
}
