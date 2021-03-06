% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions_utility.R
\name{prob_winner}
\alias{prob_winner}
\title{Binomial Win Probability}
\usage{
prob_winner(post)
}
\arguments{
\item{post}{Simulated results from the posterior, as provided by sim_post()}
}
\value{
Probabilities each arm is the winner.
}
\description{
Function to compute probability that each arm is the winner,
given simulated posterior results.
}
\examples{

x=c(10,20,30,50)
n=c(100,102,120,130)
betaPost = sim_post(x,n)
prob_winner(betaPost)

}
\author{
Thomas Lotze and Markus Loecher
}
