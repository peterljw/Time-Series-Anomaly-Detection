library(tidyverse)
library(anomalize)
library(readr)

# load paths and file names
path <- './Testing_Data/'
files <- list.files(path=path, pattern="*.csv")
labels <-  read_csv(paste0(path, 'label/labels.csv'))

for(file in files) {
  # load data
  dataset <- read_csv(paste0(path, file))
  # load corresponding label
  label <- labels$label[labels$name==file]
  label <- unlist(strsplit(label, split=','))
  # format label into datetime
  label <- as.POSIXct(label, format="%Y-%m-%d %H:%M:%S", tz = "UTC")
  # add label to dataset
  dataset$label <- ifelse(dataset$time %in% label, 1, 0)
  
  # set outlier fraction
  outliers_fraction = 0.002*length(label)
  
  # get anomalies
  anomalies_Twitter <- dataset %>% 
    time_decompose(value, method = "twitter", frequency = "auto", trend = "auto") %>%
    anomalize(remainder, method = "gesd", alpha = 0.05, max_anoms = outliers_fraction) %>%
    time_recompose() %>%
    filter(anomaly == 'Yes')
  
  dataset$anomaly_Twitter <- ifelse(dataset$time %in% anomalies_Twitter$time, 1, 0)
  
  # visualize
  if(nrow(anomalies_Twitter) >=1) {
    ggplot(dataset) + geom_line(aes(time, value)) +
      geom_point(data=dataset[dataset$anomaly_Twitter==1,], aes(time, value, color='forestgreen', size=1.5, alpha=0.05)) +  
      geom_point(data=dataset[dataset$label==1,], aes(time, value, color='firebrick1', size=1.5, alpha=0.05)) +
      theme(legend.position = "none")
    
    ggsave(paste0("./Plots/", unlist(strsplit(file, split='\\.'))[1],"-Twitter-", ".png")) 
  }
}