library(contextual)

prob_per_arm       <- c(0.9, 0.1, 0.1)
horizon            <- 100
simulations        <- 100

bandit             <- BasicBernoulliBandit$new(prob_per_arm)

agents             <- list(Agent$new(EpsilonGreedyPolicy$new(0.1), bandit),
                           Agent$new(ThompsonSamplingPolicy$new(1, 1), bandit),
                           Agent$new(Exp3Policy$new(0.1), bandit),
                           Agent$new(GittinsBrezziLaiPolicy$new(), bandit),
                           Agent$new(UCB1Policy$new(), bandit),
                           Agent$new(UCB2Policy$new(0.1), bandit))

simulation         <- Simulator$new(agents, horizon, simulations, save_interval = 30)
history            <- simulation$run()

plot(history, type = "cumulative")

summary(history)

dt <- history$get_data_table()
