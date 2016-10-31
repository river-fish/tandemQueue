library(gridExtra)
library(ggplot2)
library(reshape2)


PlotNrPeople <- function(queues){
  # This function plots the number of people in each queue over time
  # Args:
  #     - queues, the result of a call to QueuesFunction
  # Returns:
  #     - a ggplot object (can use this as plot arg in ggsave())
  
  queues = queues$queues_list
  nr_queues = length(queues)
  queues_df <- do.call(rbind, queues)
  queues_df$nr_queue <- as.factor(rep(1:nr_queues, each=nrow(queues[[1]])))
  
  plot = ggplot(data=queues_df, aes(x=time, y=nr_people))+
                geom_step()+
                facet_wrap(~nr_queue)
  return(plot)
}


HistNrPeople <- function(queues){
  # This function plots the weighted histogram of the queue legnths for each queue
  # Args:
  #     - queues, the result of a call to QueuesFunction
  # Returns:
  #     - a ggplot object (can use this as plot arg in ggsave())
  
  queues = queues$queues_list
  new_queues = list()
  nr_queues = length(queues)
  
  for (i in seq_along(queues)){
    queue <- queues[[i]]
    # calculate weights
    queue$time_spent = append((tail(queue, -1) - head(queue, -1))$time, NaN)
    new_queues[[i]] = queue
  }
  queues_df <- do.call(rbind, new_queues)
  queues_df$nr_queue <- as.factor(rep(1:nr_queues, each=nrow(new_queues[[1]])))
  
  plot = ggplot(data=queues_df, aes(queues_df$nr_people, weight = queues_df$time_spent))+
                geom_histogram(binwidth = 1) +
                facet_wrap(~nr_queue)
  return(plot)
}
