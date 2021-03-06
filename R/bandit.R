#' @importFrom R6 R6Class
#' @export
Bandit <- R6::R6Class(
  class    = FALSE,
  public   = list(
    k           = NULL,  # Number of arms (integer, required)
    d           = NULL,  # Dimension of context feature vector (integer, required)
    unique      = NULL,  # Vector of arm indices of unique context features (vector, optional)
    shared      = NULL,  # Vector of arm indices of context features shared between arms (vector, optional)
    class_name  = "Bandit",
    initialize  = function() {
      # Initialize Bandit. Set self$d and self$k here.
    },
    post_initialization = function() {
      # Called after setting seed, but before iterating over T. Do random generation here.
      invisible(self)
    },
    get_context = function(t) {
      stop("Bandit subclass needs to implement bandit$get_context()", call. = FALSE)
      # Return a list with self$k, self$d and, where applicable, the self$d x self$k context Matrix X.
      list(X = context, k = arms, d = features) # nocov
    },
    get_reward = function(t, context, action) {
      stop("Bandit subclass needs to implement bandit$get_reward()", call. = FALSE)
      # Return a list with the reward of the chosen arm and, if possible, best arm index and reward
      list(reward = reward_for_choice_made, optimal_reward = optimal_reward, optimal_arm = optimal_arm) # nocov
    },
    generate_bandit_data = function(n) {
      # Pregenerate n contexts and rewards here.
    },
    final = function() {
      # called on object destruction
    }
  )
)

#' Bandit: Superclass
#'
#' Parent or superclass of all \code{\{contextual\}} \code{Bandit} subclasses.
#'
#' In \code{\{contextual\}}, \code{Bandits} are responsible for the generation of (either
#' synthetic or offline) contexts and rewards.
#'
#' On initialisation, a \code{Bandit} subclass has to define the number of arms \code{self$k}
#' and the number of contextual feature dimensions \code{self$d}.
#'
#' For each \emph{t} = \{1, \ldots, T\} a \code{Bandit} then generates a \code{list} containing
#' current context in \code{d x k} dimensional matrix \code{context$X},
#' the number of arms in \code{context$k} and the number of features in \code{context$d}.
#'
#' Note: in context-free scenario's, \code{context$X} can be omitted.
#'
#' ![](3abandit.jpeg "contextual diagram: get context")
#'
#' On receiving the index of a \code{\link{Policy}}-chosen arm through \code{action$choice},
#' \code{Bandit} is expected to return a named \code{list} containing at least \code{reward$reward}
#' and,  where computable, \code{reward$optimal}.
#'
#' ![](3cbandit.jpeg "contextual diagram: get context")
#'
#' @name Bandit
#' @aliases post_initialization get_context generate_bandit_data bandit
#'
#' @section Usage:
#' \preformatted{
#'   bandit <- Bandit$new()
#' }
#'
#' @section Methods:
#'
#' \describe{
#'
#'   \item{\code{new()}}{ generates and instantializes a new \code{Bandit} instance. }
#'
#'   \item{\code{get_context(t)}}{
#'      argument:
#'      \itemize{
#'          \item \code{t}: integer, time step \code{t}.
#'      }
#'      returns a named \code{list}
#'      containing the current \code{d x k} dimensional matrix \code{context$X},
#'      the number of arms \code{context$k} and the number of features \code{context$d}.
#'  }
#'
#'   \item{\code{get_reward(t, context, action)}}{
#'      arguments:
#'      \itemize{
#'          \item \code{t}: integer, time step \code{t}.
#'          \item \code{context}: list, containing the current \code{context$X} (d x k context matrix),
#'          \code{context$k} (number of arms) and \code{context$d} (number of context features)
#'          (as set by \code{bandit}).
#'          \item \code{action}:  list, containing \code{action$choice} (as set by \code{policy}).
#'      }
#'      returns a named \code{list} containing \code{reward$reward} and, where computable,
#'         \code{reward$optimal} (used by "oracle" policies and to calculate regret).
#'  }
#'
#'   \item{\code{post_initialization()}}{
#'      Called after class and seed initialisation, but before the start of the simulation.
#'      Set random values that remain available throughout the life of a \code{Bandit} here.
#'   }
#'
#'   \item{\code{generate_bandit_data()}}{
#'      Called after class and seed initialisation, but before the start of a simulation.
#'      Pregenerate \code{contexts} and \code{rewards} here.
#'   }
#' }
#'
#' @seealso
#'
#' Core contextual classes: \code{\link{Bandit}}, \code{\link{Policy}}, \code{\link{Simulator}},
#' \code{\link{Agent}}, \code{\link{History}}, \code{\link{Plot}}
#'
#' Bandit subclass examples: \code{\link{BasicBernoulliBandit}}, \code{\link{ContextualLogitBandit}},
#' \code{\link{OfflineReplayEvaluatorBandit}}
#'
#' Policy subclass examples: \code{\link{EpsilonGreedyPolicy}}, \code{\link{ContextualThompsonSamplingPolicy}}
NULL
