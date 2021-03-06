% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions_utility.R
\name{get_full_context}
\alias{get_full_context}
\title{Get full context matrix over all arms}
\usage{
get_full_context(X, d, k, select_features = NULL)
}
\arguments{
\item{X}{d x k Matrix or d dimensional context vector.}

\item{d}{number of features.}

\item{k}{number of arms.}

\item{select_features}{indices of to be returned feature rows.b}
}
\value{
A d x k context Matrix
}
\description{
Given matrix or d dimensional vector X,
number of arms k and number of features d
returns a matrix with d x k context matrix
}
