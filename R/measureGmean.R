#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

#' @export multiclass.brier
#' @rdname measures
#' @format none
multiclass.gmean = makeMeasure(id = "multiclass.gmean", minimize = FALSE, best = 1, worst = 0,
  properties = c("classif", "classif.multi", "req.pred", "req.truth", "req.prob"),
  name = "Multiclass G-mean",
  note = "Geometric mean of recall and specificity",
  fun = function(task, model, pred, feats, extra.args) {
    measureMulticlassGMean(pred$data$truth, pred$data$response, pred$task.desc$negative, 
      pred$task.desc$positive)
  }
)

#' @export measureMulticlassBrier
#' @rdname measures
#' @format none

measureMulticlassGMean = function(response, truth, negative, positive) {
  mat01 = model.matrix( ~ . -1, data = as.data.frame(response))
  
  measureGMean(pred$data$truth, pred$data$response)
  

}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
