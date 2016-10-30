
QueuesFunction <- function(serving_times, vector_arrival_times){
  
  # Args: serving_times - a data frame in which the entry [i, j] is a serving time for patient i in queue j 
  #       vector_arrival_times - vector of lenght nrow(serving_times) containing patients' arrival times
  #
  # Output: a list of two elements
  #
  #         first element:
  #         a list of data frames containing times, events (+1 person or -1 person) 
  #         and the number of people at a corresponding time for a given queue
  #       
  #         second element: a data frame of leaving_times
  
  if (ncol(serving_times) == 0 | nrow(serving_times)== 0 | length(vector_arrival_times)== 0){
    stop('No dimension of the argumens can be equal to 0.')
  }
  
  if (length(vector_arrival_times) != nrow(serving_times)){
    stop('Length of vector_arrival_times is not equal to the number of rows in serving_times.')
  }
  
  n <- nrow(serving_times)  # number of patients
  nr_queues <- ncol(serving_times)  # number of queues
  
  # the following data frames keep information about times of 'entering GP's room' and 'leaving the room'
  entering_times <- data.frame(matrix(NA, nrow = n, ncol = nr_queues))
  leaving_times <- data.frame(matrix(NA, nrow = n+1, ncol = nr_queues+1))
  
  # column 1 in leaving_times is the arrival times, as if people left home
  leaving_times[ ,1] <- c(0, vector_arrival_times)
  # leaving times of person zero equal to zero - so all docs are empty to begin with
  leaving_times[1, ] <- rep(0, nr_queues + 1)
  
  for(j in seq_len(nr_queues)){
    for(i in seq_len(n)){
      
      entering_times[i, j] <- max(leaving_times[i, j+1], leaving_times[i+1, j])
      leaving_times[i+1, j+1] <- entering_times[i, j] + serving_times[i, j]
      
    }
  }
  
  # the result is a list of data frames
  result <- lapply(seq_len(nr_queues), function(i){
    df <- data.frame(time = c(leaving_times[-1,i], leaving_times[-1,i+1]),
                     event = c(rep(c(1,-1), each=n)))
    df <- df[order(df$time),]
    df$nr_people <- cumsum(df$event)
    rownames(df) <- NULL
    df
  })
  
  # deleting the first row since it was just a 'fake' person
  leaving_times <- leaving_times[-1,]
  colnames(leaving_times) <- c('Arrival_time', paste0('Leaving_queue', seq_len(nr_queues), '_time' ))
  
  return(list(queues_list = result,leaving_times = leaving_times))
}

