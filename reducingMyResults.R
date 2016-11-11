#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

reducingMyResults = function() {

  devtools::load_all()
  
  reg = loadRegistry(file.dir = "test-files")
  ids = findDone(reg = reg)
  df = reduceResultsExperiments(ids, fun = function(job, res) c(job$id, res$aggr), reg = reg)
 
  remove = grep("X", names(df), value = TRUE)
  res = df[,-which(names(df) %in% remove)]

  if(!dir.exists(path="output/")) { 
    dir.create(path = "output/", recursive = TRUE)
  } 
  write.csv(x = res, file = "output/test.csv")

}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

reducingMyResults()
 
#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
