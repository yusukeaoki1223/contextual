% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/policy_mab_softmax.R
\name{SoftmaxPolicy}
\alias{SoftmaxPolicy}
\title{Policy: Softmax}
\description{
\code{SoftmaxPolicy} is very similar to \link{Exp3Policy}, but selects an arm based on the probability from
the Boltmann distribution. It makes use of a temperature parameter tau,
which specifies how many arms we can explore. When tau is high, all arms are explored equally,
when tau is low, arms offering higher rewards will be chosen.
}
\section{Usage}{

\preformatted{
policy <- SoftmaxPolicy(tau = 0.1)
}
}

\section{Arguments}{


\describe{
\item{\code{tau = 0.1}}{
double, temperature parameter tau specifies how many arms we can explore.
When tau is high, all arms are explored equally, when tau is low, arms offering higher
rewards will be chosen.
}
}
}

\section{Methods}{


\describe{
\item{\code{new(epsilon = 0.1)}}{ Generates a new \code{SoftmaxPolicy} object. Arguments are defined in
the Argument section above.}
}

\describe{
\item{\code{set_parameters()}}{each policy needs to assign the parameters it wants to keep track of
to list \code{self$theta_to_arms} that has to be defined in \code{set_parameters()}'s body.
The parameters defined here can later be accessed by arm index in the following way:
\code{theta[[index_of_arm]]$parameter_name}
}
}

\describe{
\item{\code{get_action(context)}}{
here, a policy decides which arm to choose, based on the current values
of its parameters and, potentially, the current context.
}
}

\describe{
\item{\code{set_reward(reward, context)}}{
in \code{set_reward(reward, context)}, a policy updates its parameter values
based on the reward received, and, potentially, the current context.
}
}
}

\examples{

horizon            <- 100L
simulations        <- 100L
weights          <- c(0.9, 0.1, 0.1)

policy             <- SoftmaxPolicy$new(tau = 0.1)
bandit             <- BasicBernoulliBandit$new(weights = weights)
agent              <- Agent$new(policy, bandit)

history            <- Simulator$new(agent, horizon, simulations, do_parallel = FALSE)$run()

plot(history, type = "cumulative")

plot(history, type = "arms")
}
\references{
Kuleshov, V., & Precup, D. (2014). Algorithms for multi-armed bandit problems.
arXiv preprint arXiv:1402.6028.

Cesa-Bianchi, N., Gentile, C., Lugosi, G., & Neu, G. (2017). Boltzmann exploration done right.
In Advances in Neural Information Processing Systems (pp. 6284-6293).
}
\seealso{
Core contextual classes: \code{\link{Bandit}}, \code{\link{Policy}}, \code{\link{Simulator}},
\code{\link{Agent}}, \code{\link{History}}, \code{\link{Plot}}

Bandit subclass examples: \code{\link{BasicBernoulliBandit}}, \code{\link{ContextualLogitBandit}},
\code{\link{OfflineReplayEvaluatorBandit}}

Policy subclass examples: \code{\link{EpsilonGreedyPolicy}}, \code{\link{ContextualThompsonSamplingPolicy}}
}
