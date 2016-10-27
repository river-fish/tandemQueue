
QueuesFunction <- function(T, lambda, mu){
  # the function performs simulations  corresponding to the Queueing Model M/M/1
  # Args: T - time considered, a number
  #       lambda - parameter lambda corresponding to the arrival times Poisson process 
  #       mu - numerical vector; parameters mu describing serving times in queues
  #
  # Output: a list with the following elemnets: 
  #                  a data frame containing information about number of people at each timepoint
  #                  a vector of 'total times' spent by each person in all queues (from arrival to leaving the last queue)
  #
  # Note: the length of mu indicates how many queues are under consideration in our model
  # Note: we assume (according to R default settings that the expected value of the exponential distribution wit parameter lambda is 1/lambda)
  #
  # Test: set.seed(9)
  #       T = 40
  #       lambda = 0.5
  #       mu <- c(1.2)
  #       res <- QueuesFunction(T, lambda, mu[1])
  
  if(T<=0){
    stop('T should be a positive number')
  }
  
  if(lambda<=0){
    stop('lambda should be a positive number')
  }
  
  if(length(mu)==0 | any(mu<=0)){
    stop('The vector mu should have positive number of entries and all its entries should be positive')
  }
  # TODO: write a proper warning here
  if(any(mu<lambda)){
    warning('?')
  }
  
  # arrival times following the Poisson process
  vector_arrival_times <- c(0)
  while(vector_arrival_times[length(vector_arrival_times)] <= T){
    vector_arrival_times <- c(vector_arrival_times, vector_arrival_times[length(vector_arrival_times)] + rexp(1, lambda))
  }
  
  # number of patients
  n <- length(vector_arrival_times)  
  
  # serving times in all queues
  serving_times <- as.data.frame(lapply(mu, function(x) rexp(n, x)))
  colnames(serving_times) <- paste0('Q_serving_',seq_along(mu)) # not really needed probably
  
  # the following data frames keep information about times of 'entering GP's room' and 'leaving the room'
  entering_times <- data.frame(matrix(NA, nrow=n, ncol=length(mu)))
  # column 1 in leaving_times is the arrival times
  leaving_times <- data.frame(matrix(NA, nrow=n, ncol=length(mu)+1))
  leaving_times[,1] <- vector_arrival_times
  
  
  for(i in seq_along(mu)){
    entering_times[,i] <- pmax(leaving_times[,i], leaving_times[1,i] + c(0,cumsum(serving_times[-nrow(serving_times),i])))
    leaving_times[,i+1] <- entering_times[,i] + serving_times[,i]
  }
  
  # TODO: make a better grid (?)
  # number of people in different queues
  nr_people_queue <-  sapply(seq_along(mu), function(i){
    sapply(seq_len(ceiling(T)), function(t){
      sum((leaving_times[,i] <t) & (leaving_times[,i+1]>=t))
    })})
  
  return(list(nr_people_queue = nr_people_queue,
              total_times = leaving_times[,length(mu)+1] - leaving_times[,1]))
}






