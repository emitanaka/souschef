
#' Ideate about possible improvements on the design or experiment.
#'
#' If the focus is on the design use `ideate_design()`. For the whole experiment, then `ideate_experiment()`.
#'
#' @param .edibble An edibble design or edibble context.
#' @name ideate
#' @export
ideate_design <- function(.edibble) {
  ideate_shell(.edibble, "Given the previous context, suggest improvements to the experimental design.")
}

#' @rdname ideate
#' @export
ideate_experiment <- function(.edibble) {
  ideate_shell(.edibble, "Given the previous context, suggest improvements to the experiment.")
}

ideate_shell <- function(.edibble, prompt) {
  if(is_edibble_context(.edibble)) {
    scenario <- .edibble
  } else {
    not_edibble(.edibble)
    scenario <- describe_scenario(.edibble)
  }
  chat <- extract_chat(scenario)
  define_context(chat$chat(prompt),
                 design = .edibble,
                 chat = chat)
}

#' @rdname ideate
#' @export
ideate_live_browser <- function(.edibble) {
  res <- ideate_shell(.edibble, "Describe experiment")
  elmer::live_browser(extract_chat(res))
}

#' @rdname ideate
#' @export
ideate_live_console <- function(.edibble) {
  res <- ideate_shell(.edibble, "Describe experiment")
  elmer::live_console(extract_chat(res))
}
