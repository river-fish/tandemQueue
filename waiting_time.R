ColorHue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}



QueueingTimePlot <- function(leaving_times, serving_times, title,  line_size=2, expected_means=NULL){
  require(ggplot2)
  
  waiting_times <- data.frame(leaving_times[,2:ncol(leaving_times)] - leaving_times[,1:(ncol(leaving_times)-1)] - serving_times)
  
  
  waiting_times$id <- 1:nrow(waiting_times)
  
  # compute average waiting times
  av_waiting_times <-  sapply(1:ncol(serving_times), function(i){
    cumsum(waiting_times[,i])/waiting_times$id
  })
  
  df <- data.frame(id = rep(waiting_times$id, times=ncol(serving_times)),
                   time = as.vector(as.matrix(leaving_times[-1])),
                   average_waiting = as.vector(av_waiting_times),
                   queue_nr = as.factor(rep(1:ncol(serving_times), each=nrow(leaving_times))))
  # basic plot
  p  <- ggplot(df, aes(x = time, y = average_waiting, color=queue_nr)) + geom_step(size=line_size) + ggtitle(title)
  
  if(!is.null(expected_means)){
    p <- p + geom_hline(yintercept=expected_means, color=ColorHue(length(expected_means)))
  }
  p
}

