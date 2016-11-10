#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

reducingMyResults = function() {

  devtools::load_all()
  
  reg = loadRegistry(file.dir = "registry")
  
  # Reduce results
  ids = findDone(reg = reg)
  params = getJobPars(ids, reg = reg)

  results = reduceResultsList(ids, fun = function(job, res) c(job$id, res$aggr), reg = reg)
  teste = do.call("rbind", results)
  colnames(teste)[1] = "job.id"

  tab = ljoin(teste, params, by = "job.id")

  if(!dir.exists(path="output/")) { 
    dir.create(path = "output/", recursive = TRUE)
  } 

  write.csv(x = tab, file = "output/test.csv")

}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

reducingMyResults()
 
#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
