#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

# for each level "lv"
#   - lv is the positive class (in both: truth and response)
#   - make lv vs "other" (binarized problem) 
  # - call gmean
  # - average list

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

#' @export multiclass.brier
#' @rdname measures
#' @format none
multiclass.gmean = makeMeasure(id = "multiclass.gmean", minimize = FALSE, best = 1, worst = 0,
  properties = c("classif", "classif.multi", "req.pred", "req.truth"),
  name = "Multiclass G-mean",
  note = "Geometric mean of recall and specificity average by class",
  fun = function(task, model, pred, feats, extra.args) {
    measureMulticlassGMean(pred$data$truth, pred$data$response)
  }
)

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

#' @export measureMulticlassBrier
#' @rdname measures
#' @format none

measureMulticlassGMean = function(truth, response) {

  aux = lapply(levels(truth), function(lv){
    res.aux = as.character(response)
    tru.aux = as.character(truth)
    tru.aux[which(tru.aux != lv)] = "other"
    res.aux[which(res.aux != lv)] = "other"
    measureGMEAN(truth = tru.aux, response = res.aux, positive = lv, negative = "other")

  })
  return(mean(unlist(aux)))
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
