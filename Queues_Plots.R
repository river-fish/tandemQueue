library(gridExtra)
library(ggplot2)
library(reshape2)


PlotNrPeople <- function(queues){
  # This function plots the number of people in each queue over time
  # Args:
  #     - queues, the result of a call to QueuesFunction
  # Returns:
  #     - a ggplot object (can use this as plot arg in ggsave())
  
  nr_queues = length(queues)
  queues_df <- do.call(rbind, queues)
  
  new_queues = list()
  
  for (i in seq_along(queues)){
    queue <- queues[[i]]
    queue$nr_queue <- rep(i,nrow(queue))
    new_queues[[i]] = queue
    
  }
  queues_df <- do.call(rbind, new_queues)
  
  plot = ggplot(data=queues_df, aes(x=time, y=nr_people))+
                geom_step()+
                facet_wrap(~nr_queue)
  return(plot)
}



HistNrPeopleWithGeom <- function(queues, rho){
  # This function plots the normalised weighted histogram of the queue lengths for each queue
  # Args:
  #     - queues, the result of a call to QueuesFunction
  # Returns:
  #     - a ggplot object (can use this as plot arg in ggsave())
  
  new_queues = list()
  nr_queues = length(queues)
  
  for (i in seq_along(queues)){
    queue <- queues[[i]]
    # calculate weights
    queue$time_spent = append((tail(queue, -1) - head(queue, -1))$time, NaN)
    #queue_total_time = sum(queue$time_spent, na.rm=TRUE)
    #queue$time_spent = queue$time_spent / queue_total_time
    queue$nr_queue <- rep(i,nrow(queue))
    new_queues[[i]] = queue
    
  }
  queues_df <- do.call(rbind, new_queues)
  
  queues_df <- queues_df[, c('nr_queue', 'nr_people', 'time_spent')]
  print(head(queues_df))
  
  geom_df = as.data.frame(lapply(1:nr_queues, function(i) rgeom(10000, rho[i])))
  colnames(geom_df) = 1:nr_queues
  geom_df = melt(geom_df)
  colnames(geom_df) = c('nr_queue', 'nr_people')
  geom_df$time_spent = rep(1, nr_queues)
  print(head(geom_df))
  
  queues_df$label <- "Queue"
  geom_df$label <- "Geometric"
  plot_df = rbind(geom_df, queues_df)
  
  plot = ggplot()+
    geom_histogram(data=queues_df, aes(x=nr_people, y=..count../sum(..count..), fill='Geometric', weight=time_spent), binwidth = 1, alpha = 0.3, colour='black')+
    geom_histogram(data=geom_df, aes(x=nr_people, y=..count../sum(..count..), fill='Queue', weight=time_spent), binwidth = 1, alpha = 0.3, colour='black')+
    labs(x = "State (queue length)", y = "Proportion of time spent in state")+
    facet_wrap(~nr_queue)

  return(plot)
}

