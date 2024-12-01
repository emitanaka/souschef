# op.souschef <- list(souschef.llm = list(vendor = "openai",
#                                       model = "gpt-4o-mini",
#                                       echo = TRUE))
op.souschef <- list(souschef.llm = list(vendor = "ollama",
                                      model = "llama3.1:8b",
                                      echo = TRUE))

#' Get or set an option for the `souschef` package
#'
#' @param x The name of the option to get or set.
#' @param val The value of the option to set.
#' @rdname souschef_option
#' @export
souschef_option_get <- function(x = c("llm", "all")) {
  x <- match.arg(x)
  if(x == "all") {
    op.souschef
  } else {
    opt_name <- paste0("souschef.", x)
    res <- getOption(opt_name)
    if(!is.null(res)) return(res)
    op.souschef[[opt_name]]
  }
}

#' @rdname souschef_option
#' @export
souschef_option_set <- function(x = "llm", val) {
  x <- match.arg(x)
  opt_name <- paste0("souschef.", x)
  op.souschef[[opt_name]] <- val
}
