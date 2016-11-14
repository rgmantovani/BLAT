# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

library("dplyr")
library("reshape2")

# run.id, setup.id, task.id, function (measure), value, task_name
data = read.csv(file = "output.csv")
data$setup.id = 0
data$algo.setup = 0

# task.id
aux = gsub(x = data$prob, pattern = "t_", replacement = "")
aux2 = gsub(x = aux, pattern = "_.*", replacement = "")
data$task.id = as.numeric(aux2)

# JRip + N + O
jrip.ids = which(data$algo == "classif.JRip")
jrip.setups = paste(data[jrip.ids,"algo"], data[jrip.ids, "N"], data[jrip.ids, "O"], sep="_")
data[jrip.ids, "algo.setup"] = jrip.setups

# BayesNet + Q
bayesNet.ids = which(data$algo == "classif.bayesNet")
bayesNet.setups = paste(data[bayesNet.ids,"algo"], data[bayesNet.ids, "Q"], sep="_")
data[bayesNet.ids, "algo.setup"] = bayesNet.setups

# J48 + C + M
j48.ids = which(data$algo == "classif.J48")
j48.setups = paste(data[j48.ids,"algo"], data[j48.ids, "C"], data[j48.ids, "M"], sep="_")
data[j48.ids, "algo.setup"] = j48.setups

data$setup.id = as.integer(as.factor(data$algo.setup))
# write.csv(x = data, file = "full_data.csv")

df = dplyr::select(.data = data, run.id, setup.id, task.id, predictive_accuracy, multiclass_gmean, 
  usercpu_time_millis, prob)

df2 = melt(df, id.vars = c(1,2,3,7))
colnames(df2) = c("run_id", "setup_id", "task_id", "task_name", "function", "value")
df2 = df2[,c(1,2,3,5,6,4)]
df2 = df2[order(df2$run_id),]
# write.csv(x = df2, file = "AT_fulldata.csv")

# ids = c(386, 391, 392, 394, 395, 401, 1561, 1562, 90001, 90002, 90003, 90004, 90005, 90006, 
#   90007, 90008, 90009, 90010, 90011, 90012)

# has.ids = which(df$task.id %in% ids)
# train.data = df2[-has.ids, ]
 
# for(id in ids) {
#   idex = which(df2$task_id == id)
#   test.data = df2[idex, ]
#   df3 = rbind(train.data, test.data)
#   write.csv(x = df3, file = paste0("AT_", id, ".csv"))
# }



# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
