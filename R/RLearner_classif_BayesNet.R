#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

#' @export
makeRLearner.classif.BayesNet = function() {
  makeRLearnerClassif(
    cl = "classif.BayesNet",
    package = "RWeka",
    par.set = makeParamSet(
      makeLogicalLearnerParam(id = "D", default = FALSE),
      makeDiscreteLearnerParam(id = "Q", 
        values = paste0("weka.classifiers.bayes.net.search.local.", c("K2", "HillClimber", 
          "LAGDHillClimber", "SimulatedAnnealing", "TabuSearch", "TAN")), 
      default = "weka.classifiers.bayes.net.search.local.K2")
    ),
    properties = c("twoclass", "multiclass", "missings", "numerics", "factors", "prob"),
    name = "Bayesian Network",
    short.name = "bayesNet",
    note = "NAs are directly passed to WEKA with `na.action = na.pass`."
  )
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

#' @export
trainLearner.classif.BayesNet = function(.learner, .task, .subset, .weights = NULL, ...) {
  f = getTaskFormula(.task)
  ctrl = RWeka::Weka_control(...)
  BayesNet = RWeka::make_Weka_classifier("weka/classifiers/bayes/BayesNet")
  BayesNet(f, data = getTaskData(.task, .subset), control = ctrl, na.action = na.pass)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

#' @export
predictLearner.classif.BayesNet = function(.learner, .model, .newdata, ...) {
  type = switch(.learner$predict.type, prob = "prob", "class")
  predict(.model$learner.model, newdata = .newdata, type = type, ...)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

