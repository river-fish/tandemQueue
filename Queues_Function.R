
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
  
  if(T <= 0){
    stop('T should be a positive number')
  }
  
  if(lambda <= 0){
    stop('lambda should be a positive number')
  }
  
  if(length(mu) == 0 | any(mu <= 0)){
    stop('The vector mu should have positive number of entries and all its entries should be positive')
  }
  # TODO: write a proper warning here
  if(any(mu<lambda)){
    warning('?')
  }
  
  # simulate poisson process on [0,T]
  # TODO: optimise so we don't need the while loop
  vector_arrival_times <- c(0)
  while(vector_arrival_times[length(vector_arrival_times)] <= T){
    vector_arrival_times <- c(vector_arrival_times, vector_arrival_times[length(vector_arrival_times)] + rexp(1, lambda))
  }
  
  # number of patients   TODO correct this for optimised vector_arrival_times
  n <- length(vector_arrival_times)  
  
  # serving times in all queues
  serving_times <- as.data.frame(lapply(mu, function(x) rexp(n, x)))
  colnames(serving_times) <- paste0('Q_serving_',seq_along(mu)) # not really needed probably
  
  # the following data frames keep information about times of 'entering GP's room' and 'leaving the room'
  entering_times <- data.frame(matrix(NA, nrow = n, ncol = length(mu)))
  leaving_times <- data.frame(matrix(NA, nrow = n+1, ncol = length(mu)+1))
  # column 1 in leaving_times is the arrival times, as if people left home
  leaving_times[ ,1] <- c(0, vector_arrival_times)
  # leaving times of person zero equal to zero - so all docs are empty to begin with
  leaving_times[1, ] <- rep(0, length(mu) + 1)

  for(j in seq_along(mu)){
    for(i in seq_len(n)){

    entering_times[i, j] <- max(leaving_times[i, j+1], leaving_times[i+1, j])
    leaving_times[i+1, j+1] <- entering_times[i, j] + serving_times[i, j]

    }
  }
  
  # TODO: make a better grid (?)
  # number of people in different queues
  nr_people_queue <-  sapply(seq_along(mu), function(i){
  	# make the number of gridpoints an argument of the function
    sapply(seq_len(ceiling(T)), function(t){
      sum((leaving_times[,i] <t) & (leaving_times[,i+1]>=t))
    })})
  
  #TODO make the output a df for each queue, with the first 
  #column time that the queue legnth changes, the second 
  #the new number of people in the queue
  return(list(nr_people_queue = nr_people_queue,
              total_times = leaving_times[,length(mu)+1] - leaving_times[,1]))
}

