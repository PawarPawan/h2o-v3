setwd(normalizePath(dirname(R.utils::commandArgs(asValues=TRUE)$"f")))
source('../h2o-runit.R')

test.rdoc_naive_bayes.golden <- function(H2Oserver) {
  
  votesPath <- system.file("extdata", "housevotes.csv", package="h2o")
  votes.hex <- h2o.uploadFile(H2Oserver, path = votesPath, header = TRUE)
  h2o.naiveBayes(x = 2:17, y = 1, training_frame = votes.hex, laplace = 3)
  
  testEnd()
}

doTest("R Doc Naive Bayes", test.rdoc_naive_bayes.golden)
