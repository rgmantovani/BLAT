#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

  devtools::load_all()

  data = iris
  task =  makeClassifTask( data = data, target = "Species")

  lrn = makeLearner("classif.BayesNet")
  outer.cv = makeResampleDesc(method = "CV", iters = 3, stratify = TRUE)
  measures = list(acc, ber)

  # results = resample(learner = lrn, task = task, resampling = outer.cv, measures = measures, 
    # models = TRUE, show.info = TRUE)

  # mod = train(lrn, task)
  # newdata.pred = predict(mod, newdata = iris.test)

  # obj = results$pred$data
  # truth = obj$truth
  # response = obj$response

  par.set = makeParamSet(
    makeDiscreteParam(id = "Q", values = paste0("weka.classifiers.bayes.net.search.local.", 
      c("K2", "HillClimber", "LAGDHillClimber", "SimulatedAnnealing", "TabuSearch", "TAN")))
  )

  # Tunning - OK

  inner.cv = makeResampleDesc(method = "CV", iters = 3, stratify = TRUE)
  BUDGET = 10 
  ctrl = makeTuneControlRandom(maxit = BUDGET)

  new.lrn = makeTuneWrapper(learner = lrn, resampling = inner.cv,
    measure = ber, par.set = par.set, control = ctrl, show.info = TRUE)
  
  res = benchmark(learners = new.lrn, tasks = list(task), resamplings = outer.cv, 
      measures = measures, show.info = TRUE, models = FALSE)

  
# weka.classifiers.bayes.net.search.local.


#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
