
library(gridExtra)
library(ggplot2)
library(reshape2)


PlotNrPeople <- function(queues){
  # This function plots the number of people in each queue over time
  # Args:
  #    - queues, the first element of the result of a call to
  QueuesFunction
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
    labs(x = "t", y = "State (queue length)", size=16)+
    facet_wrap(~nr_queue)
  return(plot)
}



HistNrPeopleWithGeom <- function(queues, rho, ...){
  # This function plots the normalised weighted histogram of the queue
  lengths for each queue
  # Args:
  #     - queues, the first element of the result of a call to
  QueuesFunction
  # Returns:
  #     - a ggplot object (can use this as plot arg in ggsave())
  
  new_queues = list()
  nr_queues = length(queues)
  
  for (i in seq_along(queues)){
    queue <- queues[[i]]
    # calculate weights
    queue$time_spent = append((tail(queue, -1) - head(queue, -1))$time,
                              NaN)
    #queue_total_time = sum(queue$time_spent, na.rm=TRUE)
    #queue$time_spent = queue$time_spent / queue_total_time
    queue$nr_queue <- rep(i,nrow(queue))
    new_queues[[i]] = queue
    
  }
  
  queues_df <- do.call(rbind, new_queues)
  
  queues_df <- queues_df[, c('nr_queue', 'nr_people', 'time_spent')]
  
  geom_df = as.data.frame(lapply(1:nr_queues, function(i) rgeom(100000,
                                                                rho[i])))
  colnames(geom_df) = 1:nr_queues
  geom_df = melt(geom_df)
  colnames(geom_df) = c('nr_queue', 'nr_people')
  
  # plot = ggplot()+
  #    geom_histogram(data=queues_df, aes(x=nr_people,
  y=10*..density.., fill='Queue', weight=time_spent), alpha =0.8,
  binwidth=10, ...)+
  #    geom_histogram(data=geom_df, aes(x=nr_people, y=10*..density..,
  fill='Geometric', show_guide=FALSE), alpha = 0,
  colour='#FF9999',show_guide=FALSE, binwidth=10,  ...)+
  #    labs(x = "State (queue length)", y = "Proportion of time spent
  in state", size=16)+
  #    guides(fill=guide_legend(title=NULL)) +
  #    theme(legend.key = element_blank()) +
  #    facet_wrap(~nr_queue)

   plot = ggplot()+
     geom_histogram(data=queues_df, aes(x=nr_people, y=1*..density..,
fill='Queue', weight=time_spent), alpha =0.8, ...)+
     geom_histogram(data=geom_df, aes(x=nr_people, y=1*..density..,
fill='Geometric', show_guide=FALSE), alpha = 0,
colour='#FF9999',show_guide=FALSE,   ...)+
     labs(x = "State (queue length)", y = "Proportion of time spent in
state", size=16)+
     guides(fill=guide_legend(title=NULL)) +
     theme(legend.key = element_blank()) +
     xlim(0,200)+
     facet_wrap(~nr_queue)

  return(plot)
}