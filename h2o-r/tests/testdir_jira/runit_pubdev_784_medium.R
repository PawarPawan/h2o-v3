setwd(normalizePath(dirname(R.utils::commandArgs(asValues=TRUE)$"f")))
source('../h2o-runit.R')

test <- function(conn) {
  data <- h2o.uploadFile(locate("bigdata/laptop/usecases/cup98LRN_z.csv"))
  dim(data)
  split = h2o.splitFrame(data=data,ratios=.8)
  train = h2o.assign(split[[1]],key="train")
  test = h2o.assign(split[[2]],key="test")
  dim(train)
  dim(test)

  data <- as.h2o(iris)
  split = h2o.splitFrame(data=data,ratios=.8)
  train = h2o.assign(split[[1]],key="train")
  test = h2o.assign(split[[2]],key="test")
  dim(train)
  dim(test)

  testEnd()
}

doTest("PUBDEV-784", test)
