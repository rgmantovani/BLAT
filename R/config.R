#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

# needs mlr, batchtools, RWeka (used indirectly)
library("mlr")
library("BatchExperiments")

# mlr config
configureMlr(on.learner.error = "warn")
configureMlr(show.info = TRUE)

predefined.learners = list("classif.JRip", "classif.BayesNet", "classif.J48")

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

