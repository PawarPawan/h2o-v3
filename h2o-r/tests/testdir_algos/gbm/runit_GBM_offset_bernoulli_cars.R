####### This tests offset in gbm for bernoulli by comparing results with R ######

setwd(normalizePath(dirname(R.utils::commandArgs(asValues=TRUE)$"f")))
source('../../h2o-runit.R')

test <- function(h) {
    cars = h2o.uploadFile(conn, locate("smalldata/junit/cars_20mpg.csv"))
    cars = cars[!is.na(cars$economy_20mpg),]
    cars$economy_20mpg = as.factor(cars$economy_20mpg)
    offset = as.h2o(data.frame(rep(.5,398)))
    names(offset) = "x1"
    cars = h2o.cbind(cars,offset)
    df = as.data.frame(cars)

	gg = gbm(formula = economy_20mpg~cylinders+displacement+power+weight+acceleration+year+offset(rep(.5,398)),distribution = "bernoulli",data = df,n.trees = 1,interaction.depth = 1,n.minobsinnode = 1,shrinkage = 1,train.fraction = 1,bag.fraction = 1)
	hh = h2o.gbm(x = 3:8,y = "economy_20mpg",training_frame = cars,distribution = "bernoulli",ntrees = 1,max_depth = 1,min_rows = 1,learn_rate = 1,offset_column = "x1")
	print(gg$initF)
	expect_equal(gg$initF, hh@model$init_f)
	ph = h2o.predict(object = hh,newdata = cars)
	pr = predict.gbm(object = gg,newdata = df,n.trees = 1,type = "link")
	pr = 1/(1+exp(-df$x1 - pr))
	print(mean(pr))
    print(min(pr))
    print(max(pr))
	expect_equal(mean(pr), mean(ph[,3]),tolerance=1e-6 )
	expect_equal(min(pr), min(ph[,3]),tolerance=1e-6 )
	expect_equal(max(pr), max(ph[,3]),tolerance=1e-6 )

	testEnd()
}
doTest("GBM offset Test: GBM w/ offset for bernoulli distribution", test)