#' The Selected Double Super Learner Method (SDSL): Continuous Case Treatment
#' @description  Estimates the treatment effect using the selected DSL method when the treatment variable is considered to be continuous.
#' @export
#' @param data The data set. Treatment variable D must be continuous, and the number of variables must be greater than 3. Variables must be numeric with no missing values.
#' @param y.col.n The column number in the data set that represents the response.
#' @param d.col.n The column number in the data set that represents the treatment variable.
#' @param SL.library The candidate machine-learning algorithms. Must be uploaded first. See example.
#' @param cv The number of cross-validation folds followed by the letter L. See example.
#' @param Best.Yt The number of the best learner in library in predicting Y using the testing set. For example learner number 1.
#' @param Best.Ytr The number of the best learner in library in predicting Y using the training set.
#' @param Best.Dt The number of the best learner in library in predicting D using the testing set. For example learner number 5.
#' @param Best.Dtr The number of the best learner in library in predicting D using the training set.
#' @examples
#' DataSet <- DATA1(N=100, p=5, theta=0.5)
#' SL.library <- c("SL.biglasso", "SL.glm", "SL.kernelKnn", "SL.ranger", "SL.xgboost")
#' S.DSL1(data=DataSet, y.col.n=1, d.col.n=2, SL.library=SL.library, cv=3L, Best.Yt=1, Best.Ytr=1, Best.Dt=5, Best.Dtr=5)

S.DSL1 <- function(data, y.col.n, d.col.n, SL.library, cv, Best.Yt, Best.Ytr, Best.Dt, Best.Dtr ) {
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
  modely1.SL=SuperLearner(Y=DAT.IC[,R],X=DAT.IC[,-c(R, Tr)],SL.library=SL.library[Best.Yt], cvControl=FOLDS,
                          family=gaussian(),method="method.NNLS", verbose=FALSE)
  modely2.SL=SuperLearner(Y=DAT.I[,R],X=DAT.I[,-c(R, Tr)],SL.library=SL.library[Best.Ytr], cvControl=FOLDS,
                          family=gaussian(),method="method.NNLS", verbose=FALSE)
  Gu1=predict.SuperLearner(modely1.SL,DAT.I[,-c(R, Tr)])$pred
  Gu2=predict.SuperLearner(modely2.SL,DAT.IC[,-c(R, Tr)])$pred
  U.SL1=DAT.I[,R]-Gu1
  U.SL2=DAT.IC[,R]-Gu2
  # Retain m(X).hat and V.hat on both samples #
  modeld1.SL=SuperLearner(Y=DAT.IC[,Tr],X=DAT.IC[,-c(R, Tr)],SL.library=SL.library[Best.Dt], cvControl=FOLDS,
                          family=gaussian(),method="method.NNLS", verbose=FALSE)
  modeld2.SL=SuperLearner(Y=DAT.I[,Tr],X=DAT.I[,-c(R, Tr)],SL.library=SL.library[Best.Dtr], cvControl=FOLDS,
                          family=gaussian(),method="method.NNLS", verbose=FALSE)
  Mu1=predict.SuperLearner(modeld1.SL,DAT.I[,-c(R, Tr)])$pred
  Mu2=predict.SuperLearner(modeld2.SL,DAT.IC[,-c(R, Tr)])$pred
  V.SL1=DAT.I[,Tr]-Mu1
  V.SL2=DAT.IC[,Tr]-Mu2
  # Compute Cross-Fitting DSL estimator of theta #
  theta1.SL=mean(V.SL1*U.SL1)/mean(V.SL1*V.SL1)
  theta2.SL=mean(V.SL2*U.SL2)/mean(V.SL2*V.SL2)
  theta.SDSL=mean(c(theta1.SL,theta2.SL))
  # compute the asymptotic variance #
  sigma1.SL =mean(V.SL1^2*U.SL1^2)/(mean(V.SL1^2))^2
  sigma2.SL =mean(V.SL2^2*U.SL2^2)/(mean(V.SL2^2))^2
  sigma.SDSL = 0.5*(sigma1.SL+sigma2.SL)+(theta1.SL-theta.SDSL)^2+(theta2.SL-theta.SDSL)^2
  return(data.frame(theta.SDSL, sigma.SDSL))
}
