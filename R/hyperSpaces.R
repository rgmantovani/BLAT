#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getHyperSpace = function(learner) {

  temp = gsub(x = learner$id, pattern = ".preproc", replacement = "")
  name = sub('classif.', '', temp)
  name = sub('.customized', '', name)
  name = sub('.imputed', '', name)
  substring(name, 1, 1) = toupper(substring(name, 1, 1)) 
  
  fn.space = get(paste0("get", name , "Space"))
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getJ48Space = function() {
  par.set = makeParamSet(
    makeDiscreteParam(id = "M", values = 10^c(-4,-3,-2,-1)),
    makeDiscreteParam(id = "C", values = c(0.1, 0.15, 0.2, 0.25, 0.3))
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getJRipSpace = function() {
  par.set = makeParamSet(
    makeDiscreteParam(id = "N", values = c(1, 2, 3, 4, 5)),
    makeDiscreteParam(id = "O", values = c(1, 2, 3, 4, 5))
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getBayesNetSpace = function() {
  par.set = makeParamSet(
    makeDiscreteParam(id = "Q", values = paste0("weka.classifiers.bayes.net.search.local.", 
      c("K2", "HillClimber", "LAGDHillClimber", "SimulatedAnnealing", "TabuSearch", "TAN")))
  )
  return(par.set)
}


#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
