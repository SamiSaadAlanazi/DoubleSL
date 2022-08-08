
#' The Double Machine-Learning Method (DML): Continuous Case Treatment
#' @description  Estimates the treatment effect using the DML method when the treatment variable is considered to be continuous.
#' @export
#' @param data The data set. Treatment variable D must be continuous, and the number of variables must be greater than 3.
#' @param y.col.n The column number in the data set that represents the response.
#' @param d.col.n The column number in the data set that represents the treatment variable.
#' @examples
#' DataSet <- DATA1(N=100, p=5, theta=0.5)
#' DML1(data=DataSet, y.col.n=1, d.col.n=2)

DML1 <- function(data, y.col.n, d.col.n) {
  R=y.col.n
  Tr=d.col.n
  N=nrow(data)
  DAT=data
  # Perform Sample Splitting #
  I=sort(sample(1:N,N/2))
  IC=setdiff(1:N,I)
  DAT.I <- DAT[I,]
  DAT.IC <- DAT[IC,]
  # Retain g(X).hat and U.hat on both samples #
  model1=randomForest(DAT.IC[,-c(R, Tr)], DAT.IC[,R])
  model2=randomForest(DAT.I[,-c(R, Tr)],DAT.I[,R])
  G1=predict(model1,DAT.I[,-c(R, Tr)])
  G2=predict(model2,DAT.IC[,-c(R, Tr)])
  U1=DAT.I[,R]-G1
  U2=DAT.IC[,R]-G2
  # Retain m(X).hat and V.hat on both samples #
  modeld1=randomForest(DAT.IC[,-c(R, Tr)],DAT.IC[,Tr])
  modeld2=randomForest(DAT.I[,-c(R, Tr)],DAT.I[,Tr])
  M1=predict(modeld1,DAT.I[,-c(R, Tr)])
  M2=predict(modeld2,DAT.IC[,-c(R, Tr)])
  V1=DAT.I[,Tr]-M1
  V2=DAT.IC[,Tr]-M2
  # Compute Cross-Fitting DML estimator of theta #
  theta1=mean(V1*U1)/mean(V1*V1)
  theta2=mean(V2*U2)/mean(V2*V2)
  theta.DML=mean(c(theta1,theta2))
  # compute the asymptotic variance #
  sigma1 =mean(V1^2*U1^2)/(mean(V1^2))^2
  sigma2 =mean(V2^2*U2^2)/(mean(V2^2))^2
  sigma.DML = 0.5*(sigma1+sigma2+(theta1-theta.DML)^2+(theta2-theta.DML)^2)
  return(data.frame(theta.DML, sigma.DML))
}
