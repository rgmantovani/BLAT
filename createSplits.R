#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

set.seed(42)

datasets = list.files(path = "data/")
schedule = c(25, 35, 50, 70, 100)
total = length(datasets)

if(!dir.exists("samples/")) {
  dir.create("samples/")
}

cat(" - Generating Samples ... \n")
aux = lapply(1:total, function(k){

  dataset = datasets[k]
  print(dataset)
  cat(k, "/", total, "- @Dataset: ", dataset, "\n")
  data = RWeka::read.arff(file = paste0("data/", dataset))

  available = 1:nrow(data)
  used = NULL
  idxs = list()
  
  for(i in 1:(length(schedule))){

    if( i == (length(schedule))){
      samp = 1:nrow(data)
    }else{
      s = round(((schedule[i+1] - schedule[i]) * nrow(data))/ 100)
      samp = sample(available, size = s)
    }
    used = c(used, samp)
    idxs[[i]] = unique(used)
  
    # save file
    filename = paste0("samples/", gsub(x = dataset, pattern = ".arff", replacement = ""), 
      "_schedule_", schedule[i], ".arff")

    cat("  ->", filename, "\n")
    RWeka::write.arff(x = data[idxs[[i]],], file = filename)
    available = setdiff(available, used)
  }
})

cat("Done!")


#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
