#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
  
  # Running simple task
  devtools::load_all()
  task = iris.task
  # task = pid.task

  lrn = makeLearner("classif.BayesNet")
  outer.cv = makeResampleDesc(method = "CV", iters = 3, stratify = TRUE)
  measures = list(acc, ber, multiclass.gmean)

  results = resample(learner = lrn, task = task, resampling = outer.cv, measures = measures, 
    models = TRUE, show.info = TRUE)

  obj = list(aggr = results$aggr, pred = results$pred$data, all.measures = results$measures.test)

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
