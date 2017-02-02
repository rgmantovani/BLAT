#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

main = function() {

  devtools::load_all()
  unlink("test-files/", recursive = TRUE)
  
  reg = makeExperimentRegistry(
    id = "test", 
    packages = c("mlr"), 
    src.dirs = "R/"
  )

  datasets = list.files(path = "samples/")

  aux.data = lapply(datasets, function(datafile) {

    data = RWeka::read.arff(paste0("samples/", datafile))
    id = paste0("t_", gsub(x = datafile, pattern = ".arff", replacement = ""))
    colnames(data) = make.names(colnames(data), unique = TRUE)

    task = makeClassifTask(id = id, data = data, target = "Class")
    BatchExperiments::addProblem(reg = reg, id = id, static = task, overwrite = FALSE)
    return(makeDesign(id = id, design = data.frame()))
  })

  
  # a) JRip
  jrip.wrapper = function(static, dynamic, ...) {
    outer.cv = makeResampleDesc(method = "CV", iters = 10, stratify = FALSE)
    measures = list(acc, ber, multiclass.gmean, timetrain, timepredict, timeboth)
    lrn = setHyperPars(learner = makeLearner("classif.JRip"), par.vals = list(...))
    ret = resample(learner = lrn, task = static, resampling = outer.cv, 
      measures = measures, models = FALSE, show.info = TRUE)
    return(ret)
  }
  addAlgorithm(reg = reg, id = "classif.JRip", fun = jrip.wrapper) 

  # b) BayesNet
  bayesNet.wrapper = function(static, dynamic, ...) {
    outer.cv = makeResampleDesc(method = "CV", iters = 10, stratify = FALSE)
    measures = list(acc, ber, multiclass.gmean, timetrain, timepredict, timeboth)
    lrn = setHyperPars(learner = makeLearner("classif.BayesNet"), par.vals = list(...))
    ret = resample(learner = lrn, task = static, resampling = outer.cv, 
      measures = measures, models = FALSE, show.info = TRUE)
    return(ret)
  }
  addAlgorithm(reg = reg, id = "classif.bayesNet", fun = bayesNet.wrapper) 

  # c) J48
  j48.wrapper = function(static, dynamic, ...) {
    outer.cv = makeResampleDesc(method = "CV", iters = 10, stratify = FALSE)
    measures = list(acc, ber, multiclass.gmean, timetrain, timepredict, timeboth)
    lrn = setHyperPars(learner = makeLearner("classif.J48"), par.vals = list(...))
    ret = resample(learner = lrn, task = static, resampling = outer.cv, 
      measures = measures, models = FALSE, show.info = TRUE)
    return(ret)
  }
  addAlgorithm(reg = reg, id = "classif.J48", fun = j48.wrapper)

  jrip.pars = list(N = 1:5, O = 1:5)
  jrip.design = makeDesign("classif.JRip", exhaustive = jrip.pars)

  bayesNet.params = list(Q = paste0("weka.classifiers.bayes.net.search.local.", 
    c("K2", "HillClimber", "LAGDHillClimber", "SimulatedAnnealing", "TabuSearch", "TAN")))
  bayesNet.design = makeDesign("classif.bayesNet", exhaustive = bayesNet.params)

  j48.pars = list(M = 2^(0:6), C = c(0.1, 0.15, 0.2, 0.25, 0.3))
  j48.design = makeDesign("classif.J48", exhaustive = j48.pars)

  aux.algo = list(jrip.design, bayesNet.design, j48.design)
  
  job.ids = addExperiments(reg = reg, prob.designs = aux.data, algo.designs = aux.algo, 
    skip.defined = TRUE)

  # 7. Submit Jobs to execute
  submitJobs(reg = reg, ids = job.ids)  
  status = waitForJobs(reg = reg, ids = job.ids)
  cat("Execution Done! ")

}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

main()

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
