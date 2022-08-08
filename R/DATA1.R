######################################################
# Data generating process: Continuous Case Treatment #
######################################################

#' Data generating process: Continuous Case Treatment
#' @description  Simulates data set that can used in DML and DSL analysis when the treatment variable is considered to be continuous.
#' @export
#' @param N The sample size
#' @param p The number of associated covariates
#' @param theta The true value of the targeted parameter
#' @examples
#' DataSet <- DATA1(N=100, p=5, theta=0.5)

DATA1 <- function(N, p, theta) {
  # Generate the confounder matrix of X #
  X=rmnorm(N, 0, toeplitz(c(0.7^(1:p))))
  # Generate the nuisance function g(X) #
  g=as.vector((exp(X[,1])/(1+exp(X[,1])))+(0.25*X[,3]))
  # Generate the nuisance function m(X) #
  m=as.vector(X[,1]+(0.25*exp(X[,3])/(1+exp(X[,3]))))
  # Generate the independent variable of interest D #
  d=m+rnorm(N)
  # Generate the response Y #
  y=theta*d+g+rnorm(N)
  return(data.frame(y, d, X))
}
