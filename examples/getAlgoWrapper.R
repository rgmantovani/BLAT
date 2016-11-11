#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getAlgoWrapper = function(lrn, outer.cv, measures) {

  lrn = lrn
  outer = outer.cv
  measures = measures

  function(job, static, dynamic) {
    ret = resample(learner = makeLearner(lrn), task = static, resampling = outer.cv, 
      measures = measures, models = FALSE, show.info = TRUE)
    return(ret)
  }
}

# c) J48
  # j48.wrapper = function(static, dynamic, ...) {
  #   lrn = makeLearner("classif.J48")
  #   outer.cv = makeResampleDesc(method = "CV", iters = 3, stratify = TRUE)
  #   measures = list(acc, ber, multiclass.gmean, timetrain, timepredict, timeboth)

  #   new.lrn = setHyperPars(learner = lrn, par.vals = list(...))
  #   ret = resample(learner = lrn, task = static, resampling = outer.cv, 
  #     measures = measures, models = FALSE, show.info = TRUE)
  #   return(ret)
  # }
  # addAlgorithm(reg = reg, id = "classif.J48", fun = j48.wrapper)

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
