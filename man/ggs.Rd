% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/ggs.R
\name{ggs}
\alias{ggs}
\title{Import MCMC samples into a ggs object than can be used by all ggs_* graphical functions.}
\usage{
ggs(S, family = NA, description = NA, burnin = TRUE, par_labels = NA,
  inc_warmup = FALSE, stan_include_auxiliar = FALSE)
}
\arguments{
\item{S}{Either a \code{mcmc.list} object with samples from JAGS, a \code{mcmc} object with samples from MCMCpack, a \code{stanfit} object with samples from rstan, or a list with the filenames of \code{csv} files generated by stan outside rstan (where the order of the files is assumed to be the order of the chains). ggmcmc guesses what is the original object and tries to import it accordingly. rstan is not expected to be in CRAN soon, and so coda::mcmc is used to extract stan samples instead of the more canonical rstan::extract.}

\item{family}{Name of the family of parameters to process, as given by a character vector or a regular expression. A family of parameters is considered to be any group of parameters with the same name but different numerical value between square brackets (as beta[1], beta[2], etc).}

\item{description}{Character vector giving a short descriptive text that identifies the model.}

\item{burnin}{Logical or numerical value. When logical and TRUE (the default), the number of samples in the burnin period will be taken into account, if it can be guessed by the extracting process. Otherwise, iterations will start counting from 1. If a numerical vector is given, the user then supplies the length of the burnin period.}

\item{par_labels}{data frame with two colums. One named "Parameter" with the same names of the parameters of the model. Another named "Label" with the label of the parameter. When missing, the names passed to the model are used for representation. When there is no correspondence between a Parameter and a Label, the original name of the parameter is used. The order of the levels of the original Parameter does not change.}

\item{inc_warmup}{Logical. When dealing with stanfit objects from rstan, logical value whether the warmup samples are included. Defaults to FALSE.}

\item{stan_include_auxiliar}{Logical value to include "lp__" parameter in rstan, and "lp__", "treedepth__" and "stepsize__" in stan running without rstan. Defaults to FALSE.}
}
\value{
D A data frame tbl with the data arranged and ready to be used by the rest of the \code{ggmcmc} functions. The data frame has four columns, namely: Iteration, Chain, Parameter and value, and six attributes: nChains, nParameters, nIterations, nBurnin, nThin and description. A data frame tbl is a wrapper to a local data frame, behaves like a data frame and its advantage is related to printing, which is compact. For more details, see \code{tbl_df()} in package \code{dplyr}.
}
\description{
This function manages MCMC samples from different sources (JAGS, MCMCpack, STAN -both via rstan and via csv files-) and converts them into a data frame tbl. The resulting data frame has four columns (Iteration, Chain, Parameter, value) and six attributes (nChains, nParameters, nIterations, nBurnin, nThin and description). The ggs object returned is then used as the input of the ggs_* functions to actually plot the different convergence diagnostics.
}
\examples{
# Assign 'D' to be a data frame suitable for \\code{ggmcmc} functions from
# a coda object called S
data(linear)
S <- ggs(s)        # s is a coda object

# Get samples from 'beta' parameters only
S <- ggs(s, family = "beta")
}

