
#load a simulation of some queues to test plot functions on
load('data/test_queues.RData')

PlotNrPeople <- function(queues=test_queues){

	for (i in seq_along(queues)){
		queue <- queues[[i]]
		library(ggplot2)
		qp <- qplot(queue$time, queue$nr_people, geom="step", direction = "hv")
		print(qp)
	}


}

PlotNrPeople()