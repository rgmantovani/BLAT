#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

main = function() {

  devtools::load_all()
  unlink(x = "registry/", recursive = TRUE)
  reg = makeExperimentRegistry(make.default = TRUE, packages = c("foreign", "mlr"))

  datasets = list.files(path = "data/training")

  aux = lapply(datasets, function(datafile) {
    data = RWeka::read.arff(paste0("data/training/", datafile))
    id = gsub(x = datafile, pattern = ".arff", replacement = "")
    colnames(data) = make.names(colnames(data), unique = TRUE)
    task = makeClassifTask(id = id, data = data, target = "Class")
    addProblem(name = id, data = task, reg = reg)
  })

  # add algos
  outer.cv = makeResampleDesc(method = "CV", iters = 10, stratify = TRUE)
  measures = list(acc, ber, multiclass.gmean, timetrain, timepredict, timeboth)
    
  aux = lapply(predefined.learners, function(algo){
    addAlgorithm(name = algo, reg = reg,
      fun = getAlgoWrapper(lrn = algo, outer.cv = outer.cv, measures = measures)
    )
  })

  # Define algo desings
  algo.designs = list(
    classif.JRip = expand.grid(N = (1:2), O = 1:2),
    classif.BayesNet = expand.grid( Q = paste0("weka.classifiers.bayes.net.search.local.", 
    c("K2", "HillClimber", "LAGDHillClimber", "SimulatedAnnealing", "TabuSearch", "TAN"))),
    classif.J48 = expand.grid(M = 10^c(-4,-3,-2,-1), C = c(0.1, 0.15, 0.2, 0.25, 0.3))
  )
  
  ids = addExperiments(prob.designs = NULL, algo.designs = algo.designs, repls = 1L, 
    combine = "crossprod", reg = reg)

  # resources = 1 h, 8 Gb memory
  submitJobs(reg = reg, resources = list(walltime = 3600, memory = 1024 * 8))
  cat("Execution Done! ")

}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

main()

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------