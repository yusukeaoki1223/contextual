UnpooledUCBPlusPolicy <- R6::R6Class(
  portable = FALSE,
  class = FALSE,
  inherit = Policy,
  public = list(
    class_name = "UnpooledUCBPlusPolicy",
    n_subjects = NULL,
    initialize = function(n_subjects = 1, name = "UnpooledUCBPlusPolicy") {
      self$n_subjects <- n_subjects
    },
    set_parameters = function(context_params) {
      self$theta <- list("n_total" = rep(0,self$n_subjects), n = rep(list(list(0,0)),self$n_subjects),
                         p = rep(list(list(0,0)), self$n_subjects))
    },
    get_action = function(t, context) {
      user <- context$user_context
      if (self$theta$n_total[[user]] < context$k) {
        for (arm in 1:context$k) {
          if (self$theta$n[[user]][[arm]] == 0) {
            action$choice <- arm
            return(action)
          }
        }
      }
      expected_rewards <- rep(0.0, context$k)
      for (arm in 1:context$k) {
        expected_rewards[arm] <- self$theta$p[[user]][[arm]] +
          sqrt(max(0, log(self$theta$n_total[[user]]) / (self$theta$n[[user]][[arm]]))) / (2 * self$theta$n[[user]][[arm]])
      }
      action$choice  <- which_max_tied(expected_rewards)
      action
    },
    set_reward = function(t, context, action, reward) {
      arm    <- action$choice
      user   <- context$user_context
      reward <- reward$reward
      inc(self$theta$n_total[[user]])  <- 1
      inc(self$theta$n[[user]][[arm]]) <- 1
      inc(self$theta$p[[user]][[arm]]) <- (reward - self$theta$p[[user]][[arm]]) / self$theta$n[[user]][[arm]]
      self$theta
    }
  )
)

PooledUCBPlusPolicy <- R6::R6Class(
  portable = FALSE,
  class = FALSE,
  inherit = Policy,
  public = list(
    class_name = "PooledUCBPlusPolicy",
    n_subjects = NULL,
    initialize = function() {
      super$initialize()
    },
    set_parameters = function(context_params) {
      self$theta_to_arms <- list("P" = 0, "N" = 0)
      self$theta <- list("N_total" = 0)
    },
    get_action = function(t, context) {
      if (self$theta$N_total < context$k) {
        for (arm in 1:context$k) {
          if (self$theta$N[[arm]] == 0) {
            action$choice <- arm
            return(action)
          }
        }
      }
      expected_rewards <- rep(0.0, context$k)
      for (arm in 1:context$k) {
        expected_rewards[[arm]] <- self$theta$P[[arm]] +
          sqrt(max(0, log(self$theta$N_total) / (self$theta$N[[arm]]))) / (2 * self$theta$N[[arm]])
      }
      action$choice  <- which_max_tied(expected_rewards)
      action
    },
    set_reward = function(t, context, action, reward) {
      arm <- action$choice
      reward <- reward$reward
      inc(self$theta$N_total)  <- 1
      inc(self$theta$N[[arm]])   <- 1
      inc(self$theta$P[[arm]])   <- (reward - self$theta$P[[arm]]) / self$theta$N[[arm]]
      self$theta
    }
  )
)

PartiallyPooledUCBPlusPolicy <- R6::R6Class(
  portable = FALSE,
  class = FALSE,
  inherit = Policy,
  public = list(
    class_name = "PartiallyPooledUCBPlusPolicy",
    n_subjects = NULL,
    initialize = function(n_subjects = 1) {
      super$initialize()
      self$n_subjects <- n_subjects
    },
    set_parameters = function(context_params) {
      self$theta <- list("N_total" = 0, "n_total" = rep(0,self$n_subjects),
                         n = rep(list(list(0,0)),self$n_subjects), p = rep(list(list(0,0)), self$n_subjects))
      self$theta_to_arms <- list("P" = 0, "N" = 0)
    },
    get_action = function(t, context) {
      user <- context$user_context
      if (self$theta$n_total[[user]] < context$k) {
        for (arm in 1:context$k) {
          if (self$theta$n[[user]][[arm]] == 0) {
            action$choice <- arm
            return(action)
          }
        }
      }
      expected_rewards <- rep(0.0, context$k)
      beta = 1/sqrt(self$theta$n_total[[user]])
      for (arm in 1:context$k) {
        p_mean <- self$theta$P[[arm]] + sqrt(max(0, log(self$theta$N_total) / (self$theta$N[[arm]]))) / (2 * self$theta$N[[arm]])
        p_choice <- self$theta$p[[user]][[arm]] +  sqrt(max(0, log(self$theta$n_total[[user]]) / (self$theta$n[[user]][[arm]]))) / (2 * self$theta$n[[user]][[arm]])
        p_hat = (beta * p_mean + (1-beta) * p_choice)
        expected_rewards[arm] = p_hat
      }
      action$choice  <- which_max_tied(expected_rewards)
      action
    },
    set_reward = function(t, context, action, reward) {
      arm                              <- action$choice
      user                             <- context$user_context
      reward                           <- reward$reward
      inc(self$theta$n_total[[user]])  <- 1
      inc(self$theta$n[[user]][[arm]]) <- 1
      inc(self$theta$p[[user]][[arm]]) <- (reward - self$theta$p[[user]][[arm]]) / self$theta$n[[user]][[arm]]
      inc(self$theta$N_total)          <- 1
      inc(self$theta$N[[arm]])         <- 1
      inc(self$theta$P[[arm]])         <- (reward - self$theta$P[[arm]]) / self$theta$N[[arm]]
      self$theta
    }
  )
)

PartiallyPooledBBUCBPlusPolicy <- R6::R6Class(
  portable = FALSE,
  class = FALSE,
  inherit = Policy,
  public = list(
    class_name = "PartiallyPooledBBUCBPlusPolicy",
    n_subjects = NULL,
    initialize = function(n_subjects = 1) {
      super$initialize()
      self$n_subjects <- n_subjects
    },
    set_parameters = function(context_params) {
      self$theta <- list("N_total" = 0, "n_total" = rep(0,self$n_subjects),
                         n  = rep(list(as.list(rep(1, context_params$k))),self$n_subjects),
                         p  = rep(list(as.list(rep(0, context_params$k))),self$n_subjects),
                         ss = rep(list(as.list(rep(0, context_params$k))),self$n_subjects),
                         c  = rep(list(as.list(rep(0, context_params$k))),self$n_subjects))
      self$theta_to_arms <- list("P" = 0, "N" = 0, "SS" = 0, "C" = 0)
    },
    get_action = function(t, context) {
      user <- context$user_context
      if (self$theta$n_total[[user]] < context$k) {
        for (arm in 1:context$k) {
          if (self$theta$n[[user]][[arm]] == 0) {
            action$choice <- arm
            return(action)
          }
        }
      }
      expected_rewards <- rep(0.0, context$k)

      ns     <- self$n_subjects
      P      <- unlist(self$theta$P)
      N      <- unlist(self$theta$N)
      C      <- unlist(self$theta$C)
      SS     <- unlist(self$theta$SS)
      p      <- unlist(self$theta$p[[user]])
      n      <- unlist(self$theta$n[[user]])

      sigmasq <- (ns * SS) / (ns - 1) * N
      M = max((P * (1 - P) - sigmasq) / (sigmasq - ((P * (1 - P)) / ns) * C), 0)
      betas = M / (M + n)

      p_mean <- P + sqrt(max(0, log(self$theta$N_total) / (N))) / (2 * N)
      p_choice <- p +  sqrt(max(0, log(self$theta$n_total[[user]]) / (n))) / (2 * n)
      p_hat  <- betas * P + (1 - betas) * p
      p_hat[is.nan(p_hat)] <- 1
      action$choice <- which_max_tied(p_hat)
      action
    },
    set_reward = function(t, context, action, reward) {
      arm    <- action$choice
      user   <- context$user_context
      reward <- reward$reward

      inc(self$theta$N_total)           <- 1
      inc(self$theta$n_total[[user]])   <- 1
      inc(self$theta$n[[user]][[arm]])  <- 1
      inc(self$theta$p[[user]][[arm]])  <- (reward - self$theta$p[[user]][[arm]]) /
        self$theta$n[[user]][[arm]]
      inc(self$theta$N[[arm]])          <- 1
      inc(self$theta$P[[arm]])          <- (reward - self$theta$P[[arm]]) / self$theta$N[[arm]]
      dec(self$theta$SS[[arm]])         <- self$theta$ss[[user]][[arm]] + self$theta$n[[user]][[arm]] *
        (self$theta$p[[user]][[arm]] - self$theta$P[[arm]]) ^ 2
      dec(self$theta$C[[arm]])          <- self$theta$c[[user]][[arm]] + 1/self$theta$n[[user]][[arm]]
      self$theta$c[[user]][[arm]]       <- 1 / self$theta$n[[user]][[arm]]
      self$theta$ss[[user]][[arm]]      <- self$theta$n[[user]][[arm]] * self$theta$n[[user]][[arm]] *
        (self$theta$p[[user]][[arm]] - self$theta$P[[arm]]) ^ 2
      self$theta
    }
  )
)
