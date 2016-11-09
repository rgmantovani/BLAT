#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

  # Testing Tuning (to check BayesNet parameters)
  devtools::load_all()
  task = iris.task
  # task = pid.task

  lrn = makeLearner("classif.BayesNet")
  outer.cv = makeResampleDesc(method = "CV", iters = 3, stratify = TRUE)
  measures = list(acc, ber, multiclass.gmean)

  par.set = makeParamSet(
    makeDiscreteParam(id = "Q", values = paste0("weka.classifiers.bayes.net.search.local.", 
      c("K2", "HillClimber", "LAGDHillClimber", "SimulatedAnnealing", "TabuSearch", "TAN")))
  )

  # Tunning - OK
  inner.cv = makeResampleDesc(method = "CV", iters = 3, stratify = TRUE)
  BUDGET = 10 
  ctrl = makeTuneControlRandom(maxit = BUDGET)

  new.lrn = makeTuneWrapper(learner = lrn, resampling = inner.cv,
    measure = multiclass.gmean, par.set = par.set, control = ctrl, show.info = TRUE)
  
  res = benchmark(learners = new.lrn, tasks = list(task), resamplings = outer.cv, 
    measures = measures, show.info = TRUE, models = FALSE)


#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
