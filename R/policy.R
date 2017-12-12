#' @export
AbstractPolicy <- R6::R6Class(
  "AbstractPolicy",
  portable = FALSE,
  inherit = Contextual,
  public = list(
    name = "",
    action = NULL,
    initialize = function(name = "ImplementMe") {
      self$name   <- name
      self$action <- list()
    },
    get_action = function(context, theta) {
      warning("Don't forget to implement get_action()!")
      self$action
    },
    set_reward = function(reward, context, theta) {
      warning("Don't forget to implement  set_reward()!")
      theta
    },
    set_theta = function(arms, features) {
      parameters_per_arm <- list('value' = 0)
      populate_theta(arms, parameters_per_arm)
    },
    populate_theta = function(arms, parameters_per_arm) {
      theta = list()                                                            ## if we check whats there and add defaults, becomes.. dynamic :D
      for (arm in 1:arms) theta[[arm]] <- parameters_per_arm
      theta
    }
  )
)

#' External AbstractPolicy
#'
#' AbstractPolicy intro
#'
#' @section Usage:
#' \preformatted{b <- AbstractPolicy$new()
#'
#' b$reset()
#'
#' print(b)
#' }
#'
#' @section Arguments:
#' \describe{
#'   \item{b}{A \code{AbstractPolicy} object.}
#' }
#'
#' @section Details:
#' \code{$new()} starts a new AbstractPolicy,
#' it uses \code{\link[base]{pipe}}.
#' R does \emph{not} wait for the process to finish, but returns
#' immediately.
#'
#' @importFrom R6 R6Class
#' @name AbstractPolicy
#' @examples
#'\dontrun{}
#'
NULL