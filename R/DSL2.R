#' The Double Super Learner Method (DSL): Binary Case Treatment
#' @description  Estimates the treatment effect using the DSL method when the treatment variable is considered to be binary.
#' @export
#' @param data The data set. Treatment variable D must be binary, and the number of variables must be greater than 3. Variables must be numeric with no missing values.
#' @param y.col.n The column number in the data set that represents the response.
#' @param d.col.n The column number in the data set that represents the treatment variable.
#' @param SL.library The candidate machine-learning algorithms. Must be uploaded first. See example.
#' @param cv The number of cross-validation folds followed by the letter L. See example.
#' @examples
#' DataSet <- DATA2(N=100, p=5, theta=0.5)
#' SL.library <- c("SL.biglasso", "SL.glm", "SL.kernelKnn", "SL.ranger", "SL.xgboost")
#' DSL2(data=DataSet, y.col.n=1, d.col.n=2, SL.library=SL.library, cv=3L)

DSL2 <- function(data, y.col.n, d.col.n, SL.library, cv) {
  R=y.col.n
  Tr=d.col.n
  N=nrow(data)
  DAT=data
  FOLDS <- SuperLearner.CV.control(V = cv, stratifyCV = FALSE, shuffle = FALSE,
                                   validRows = NULL)
  # Perform Sample Splitting #
  I=sort(sample(1:N,N/2))
  IC=setdiff(1:N,I)
  DAT.I <- DAT[I,]
  DAT.IC <- DAT[IC,]
  # Retain g(X).hat and U.hat on both samples #
  modely1.SL=SuperLearner(Y=DAT.IC[,R],X=DAT.IC[,-c(R, Tr)],SL.library=SL.library, cvControl=FOLDS,
                          family=gaussian(),method="method.NNLS", verbose=FALSE)
  modely2.SL=SuperLearner(Y=DAT.I[,R],X=DAT.I[,-c(R, Tr)],SL.library=SL.library, cvControl=FOLDS,
                          family=gaussian(),method="method.NNLS", verbose=FALSE)
  Gu1=predict.SuperLearner(modely1.SL,DAT.I[,-c(R, Tr)])$pred
  Gu2=predict.SuperLearner(modely2.SL,DAT.IC[,-c(R, Tr)])$pred
  U.SL1=DAT.I[,R]-Gu1
  U.SL2=DAT.IC[,R]-Gu2
  # Retain the weights of Each Learner #
  Y.Testing = matrix(modely1.SL$coef,1,5)
  Y.Training = matrix(modely2.SL$coef,1,5)
  # Retain m(X).hat and V.hat on both samples #
  modeld1.SL=SuperLearner(Y=DAT.IC[,Tr],X=DAT.IC[,-c(R, Tr)],SL.library=SL.library, cvControl=FOLDS,
                          family=binomial(),method="method.NNLS", verbose=FALSE)
  modeld2.SL=SuperLearner(Y=DAT.I[,Tr],X=DAT.I[,-c(R, Tr)],SL.library=SL.library, cvControl=FOLDS,
                          family=binomial(),method="method.NNLS", verbose=FALSE)
  Mu1=predict.SuperLearner(modeld1.SL,DAT.I[,-c(R, Tr)])$pred
  Mu2=predict.SuperLearner(modeld2.SL,DAT.IC[,-c(R, Tr)])$pred
  V.SL1=DAT.I[,Tr]-Mu1
  V.SL2=DAT.IC[,Tr]-Mu2
  # Retain the weights of Each Learner #
  D.Testing = matrix(modeld1.SL$coef,1,5)
  D.Training = matrix(modeld2.SL$coef,1,5)

  Performance = rbind(Y.Testing, Y.Training, D.Testing, D.Training)
  colnames(Performance)= c(SL.library)
  rownames(Performance)= c("gXt", "gXtr", "mXt", "mXtr")

  # Compute Cross-Fitting DSL estimator of theta #
  theta1.SL=mean(V.SL1*U.SL1)/mean(V.SL1*DAT.I[,Tr])
  theta2.SL=mean(V.SL2*U.SL2)/mean(V.SL2*DAT.IC[,Tr])
  theta.DSL=mean(c(theta1.SL,theta2.SL))
  # compute the asymptotic variance #
  sigma1.SL =mean(V.SL1^2*U.SL1^2)/(mean(V.SL1^2))^2
  sigma2.SL =mean(V.SL2^2*U.SL2^2)/(mean(V.SL2^2))^2
  sigma.DSL = 0.5*(sigma1.SL+sigma2.SL)+(theta1.SL-theta.DSL)^2+(theta2.SL-theta.DSL)^2
  return(list(Coefficients= data.frame(theta.DSL, sigma.DSL),
              Learners.Performence= Performance))
}
