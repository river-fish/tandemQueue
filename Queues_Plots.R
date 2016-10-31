library(gridExtra)
library(ggplot2)

#load a simulation of some queues to test plot functions on
#load('data/test_queues.RData')

PlotNrPeople <- function(queues=test_queues, ...){
  queues = queues$queues_list
  p <- list()
  
	for (i in seq_along(queues)){
		queue <- queues[[i]]
		p[[i]] <- qplot(queue$time, queue$nr_people, geom="step", direction = "hv", ...)+
		  ggtitle(paste("Queue ", i))
	}
  do.call(grid.arrange,p)
}


HistNrPeople <- function(queues=test_queues, ...){
  
  queues = queues$queues_list
  p <- list()
  
  for (i in seq_along(queues)){
    queue <- queues[[i]]
    p[[i]] <- ggplot(data=queue, aes(queue$nr_people)) + 
      geom_histogram(binwidth = 1000/max(queue$nr_people)) +
      ggtitle(paste("Queue ", i))
  }
  do.call(grid.arrange,p)
}
