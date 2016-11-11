# https://github.com/tudo-r/BatchExperiments/blob/9b77e64c588df6fcd47492e510d4b0e286c98fd5/R/addExperiments.R

# Define algorithm "tree":
# Decision tree on the iris dataset, modeling Species.
tree.wrapper = function(static, dynamic, ...) {
   library(rpart)
   mod = rpart(Species ~ ., data = static[dynamic$train, ], ...)
   pred = predict(mod, newdata = static[dynamic$test, ], type = "class")
   table(static$Species[dynamic$test], pred)
 }
addAlgorithm(reg, id = "tree", fun = tree.wrapper)

# Define algorithm "forest":
# Random forest on the iris dataset, modeling Species.
forest.wrapper = function(static, dynamic, ...) {
   library(randomForest)
   mod = randomForest(Species ~ ., data = static, subset = dynamic$train, ...)
   pred = predict(mod, newdata = static[dynamic$test, ])
   table(static$Species[dynamic$test], pred)
}
addAlgorithm(reg, id = "forest", fun = forest.wrapper)

# Define decision tree parameters:
pars = list(minsplit = c(10, 20), cp = c(0.01, 0.1))
tree.design = makeDesign("tree", exhaustive = pars)

# Define random forest parameters:
pars = list(ntree = c(100, 500))
forest.design = makeDesign("forest", exhaustive = pars)

# Add experiments to the registry:
# Use  previously defined experimental designs.
addExperiments(reg, prob.designs = iris.design,
                algo.designs = list(tree.design, forest.design),
                repls = 2) # usually you would set repls to 100 or more.

# Optional: Short summary over problems and algorithms.
summarizeExperiments(reg)

# Optional: Test one decision tree job and one expensive (ntree = 1000)
# random forest job. Use findExperiments to get the right job ids.
do.tests = FALSE
 if (do.tests) {
   id1 = findExperiments(reg, algo.pattern = "tree")[1]
   id2 = findExperiments(reg, algo.pattern = "forest",
                          algo.pars = (ntree == 1000))[1]
   testJob(reg, id1)
   testJob(reg, id2)
}

# Submit the jobs to the batch system
 submitJobs(reg)