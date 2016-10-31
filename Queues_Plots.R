library(gridExtra)
library(ggplot2)
library(reshape2)


PlotNrPeople <- function(queues){
  
  queues = queues$queues_list
  
  queues_df <- do.call(rbind, queues)
  queues_df$nr_queue <- as.factor(rep(1:4, each=nrow(queues[[1]])))
  
  ggplot(data=queues_df, aes(x=time, y=nr_people))+
    geom_point()+
    facet_wrap(~nr_queue)
}


HistNrPeople <- function(queues, ...){
  
  queues = queues$queues_list
  p <- list()
  
  for (i in seq_along(queues)){
    queue <- queues[[i]]

    # calculate weights
    queue$time_spent = append((tail(queue, -1) - head(queue, -1))$time, NaN)
    print(queue)
    print(summary(queue))
    p[[i]] <- ggplot(data=queue, aes(queue$nr_people, weight = queue$time_spent)) + 
      geom_histogram(binwidth = 1) +
      ggtitle(paste("Queue ", i))
  }
  do.call(grid.arrange,p)
}
