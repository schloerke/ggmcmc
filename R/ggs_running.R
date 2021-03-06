#' Running means of the chains
#'
#' Running means of the chains.
#'
#' @param D Data frame whith the simulations.
#' @param family Name of the family of parameters to plot, as given by a character vector or a regular expression. A family of parameters is considered to be any group of parameters with the same name but different numerical value between square brackets (as beta[1], beta[2], etc).
#' @param original_burnin Logical. When TRUE (the default), start the iteration counter in the x-axis at the end of the burnin period.
#' @param original_thin Logical. When TRUE (the default), take into account the thinning interval in the x-axis.
#' @return A \code{ggplot} object.
#' @export
#' @examples
#' data(linear)
#' ggs_running(ggs(s))
ggs_running <- function(D, family=NA, original_burnin=TRUE, original_thin=TRUE) {
  # Manage subsetting a family of parameters
  if (!is.na(family)) {
    D <- get_family(D, family=family)
  }
  # Calculate the mean of the chain
  dm.m <- D %>%
    dplyr::group_by(Parameter, Chain) %>%
    dplyr::summarize(m=mean(value))
  # Calculate the running mean
  # Force the object to be sorted by Parameter, and hence avoid 'rm' calculation
  # to be wrong
  dm.rm <- D %>%
    dplyr::arrange(Parameter, Iteration) %>%
    dplyr::group_by(Parameter, Chain) %>%
    dplyr::mutate(rm=cumsum(value) / Iteration)
  # Plot
  f <- ggplot(dm.rm, aes(x=Iteration, y=rm, colour=as.factor(Chain))) +
    geom_line() +
    geom_hline(aes(yintercept=m), dm.m, colour="black", alpha=0.5) +
    ylab("Running Mean")
  if (attributes(D)$nChains <= 1) {
    f <- f + facet_wrap(~ Parameter, ncol=1, scales="free")
  } else {
    f <- f + facet_grid(Parameter ~ Chain, scales="free")
  }
  f <- f + scale_colour_discrete(name="Chain")
  # Manage changing the scales using different sets of burnin and thinning
  # Duplicated code chunk in ggs_traceplot()
  t_format <- function(x) {
    return( ((x-1) * attributes(D)$nThin) + attributes(D)$nThin)
  }
  b_format <- function(x) {
    return(x + attributes(D)$nBurnin)
  }
  bt_format <- function(x) {
    return( attributes(D)$nBurnin + (((x-1) * attributes(D)$nThin) + attributes(D)$nThin))
  }
  if (original_burnin & !original_thin) {
    f <- f + scale_x_continuous(labels=b_format)
  } else if (!original_burnin & original_thin) {
    f <- f + scale_x_continuous(labels=t_format)
  } else if (original_burnin & original_thin) {
    f <- f + scale_x_continuous(labels=bt_format)
  } else {
    f <- f
  }
  return(f)
}
