#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

reducingMyResults = function() {

  devtools::load_all()
  
  reg = loadRegistry(file.dir = "registry")
  
  # Reduce results
  ids = findDone(reg = reg)
  params = getJobPars(ids, reg = reg)

  # results = reduceResultsDataTable(ids, fun = function(res) list(res = res$aggr), reg = reg)
  results = reduceResultsList(ids, fun = function(job, res) c(job$id, res$aggr), reg = reg)
  teste = do.call("rbind", results)
  colnames(teste)[1] = "job.id"

  tab = ljoin(teste, params, by = "job.id")
  write.csv(x = tab, file = "test.csv")

}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

reducingMyResults()
 
#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
