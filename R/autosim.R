#' Auto-simulate the records
#'
#' This function would read in an edibble experiment (that must include record factors)
#' and infers the context to determine what the appropriate values or distributions
#' that the record factor takes place using the power of large language models (LLM).
#' This function is similar in spirit with `edibble::autofill_rcrds()`, however,
#' does not require the manual specification of providing expected values and
#' the simulation scheme is inferred from some context provided by LLM.
#'
#' @export
autosim_rcrds <- function(.edibble) {
  context <- describe_context(.edibble)
  ask_yn <- function(question) {
    chatyn <- chat_model(turns = list(elmer::Turn("assistant", context)),
                         system_prompt = "Just return yes or no.",
                         echo = FALSE)
    grepl("yes", tolower(chatyn$chat(question)))
  }

  ask_value <- function(question) {
    chatval <- chat_model(turns = list(elmer::Turn("assistant", context)),
                         system_prompt = "Answer based on the experimental context from the chat. Just return the number.",
                         echo = FALSE)
    suppressWarnings(as.numeric(chatval$chat(question)))
  }

  ask_json <- function(question) {
    chatjson <- chat_model(turns = list(elmer::Turn("assistant", context)),
                          system_prompt = "Return as json object.",
                          api_args = list(response_format = list(type = "json_object")),
                          echo = FALSE)
    jsonlite::fromJSON(chatjson$chat(question))[[1]]
  }

  ask_rcrd_type <- function(rcrd, type) {
    q <- glue_c("Given the experimental context from previous chat, is {rcrd} commonly recorded as {type}?")
    ask_yn(q)
  }


  prov <- activate_provenance(.edibble)
  rcrds <- prov$rcrd_names()
  current <- prov$get_validation()$rcrds
  # don't overwrite existing validation schemes
  rcrds_new <- setdiff(rcrds, names(current))
  get_rcrd_type <- function(rcrd) {
    ret <- list(type = NA, lower = NA, upper = NA, values = NA)
    num <- ask_rcrd_type(rcrd, "numerical")
    if(num) {
      ret$type <- "numerical"
      int <- ask_rcrd_type(rcrd, "integer")
      if(int) ret$type <- "integer"
      pnum <- ask_rcrd_type(rcrd, "a positive value")
      if(pnum) ret$lower <- 0
      out <- ask_value(glue_c("What is the absolute lower bound for {rcrd} if any?"))
      if(!is.na(out)) ret$lower <- out
      out <- ask_value(glue_c("What is the absolute upper bound for {rcrd} if any?"))
      if(!is.na(out) && out > ret$lower) ret$upper <- out

    } else {
      ret$type <- "factor"
      ret$values <- unlist(ask_json(glue_c("What are all the possible levels for {rcrd}? Return just the levels (there should be more than one).")))
    }
    return(ret)
  }



  expect_new <- list()
  for(rcrd in rcrds_new) {
    type <- get_rcrd_type(rcrd)
    if(is.na(type$lower) & is.na(type$upper)) {
      wv <- with_value(between = c(-Inf, Inf))
    } else if(is.na(type$lower)) {
      wv <- with_value("<=", value = type$upper)
    } else if(is.na(type$upper)) {
      wv <- with_value(">=", value = type$lower)
    } else {
      wv <- with_value(between = c(type$lower, type$upper))
    }
    if(type$type == "numerical") {
      expect_new[[rcrd]] <- to_be_numeric(wv)
    } else if(type$type == "integer") {
      expect_new[[rcrd]] <- to_be_integer(wv)
    } else if(type$type == "factor") {
      expect_new[[rcrd]] <- to_be_factor(levels = type$values)
    }
  }

  out <- do.call("expect_rcrds", c(list(.edibble), expect_new))

  # FIXME: in future, add distributional information
  autofill_rcrds(out)
}
