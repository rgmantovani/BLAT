#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

# Overview over defined experiments:
getProblemIds(reg = tmp)
getAlgorithmIds(reg = tmp)
summarizeExperiments(reg = tmp)
summarizeExperiments(reg = tmp, by = c("problem", "algorithm", "n"))
ids = findExperiments(prob.pars = (n == 50), reg = tmp)
getJobPars(ids, reg = tmp)

# Chunk jobs per algorithm and submit them:
ids = chunkIds(getJobPars(reg = tmp), group.by = "algorithm", reg = tmp)
submitJobs(reg = reg, resources = list(walltime = 3600, memory = 1024))
waitForJobs(reg = tmp)

# Reduce the results of algorithm a1
ids.mean = findExperiments(algo.name = "a1", reg = tmp)
reduceResults(ids.mean, fun = function(aggr, res, ...) c(aggr, res), reg = tmp)

# Join info table with all results and calculate mean of results
# grouped by n and algorithm
ids = findDone(reg = tmp)
pars = getJobPars(ids, reg = tmp)
results = reduceResults(ids, 
  fun = function(res){
    return(res$aggr)
  },
  reg = reg
)


tab = ljoin(pars, results)
tab[, list(mres = mean(res)), by = c("n", "algorithm")]

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
