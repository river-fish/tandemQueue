load('data/test_queues.RData')

ComputeLengthHistogramsRec = function(queues, list_hists, start_time, end_time){
  
  # Args: queues      - Output of "QueuesFunction"
  #       list_hists  - A list of k vectors, where k is the number of queues. 
  #                     The i-th vector represents a weighed histogram (see Output) for queue i up to time 'start_time'.
  #                     This argument allows to extend a histogram up to time 'start_time' to a later 'end_time'
  #                     When computing a fresh histogram, a list of c(0)-vectors can be supplied.
  #       start_time  - A time to continue computing the weighed histograms from. 
  #                     This parameter allows burn-in as well as starting from the end_time of
  #                     previously computed histograms.
  #       end_time    - Time to stop computing histograms. 
  #                     This enables some flexibility: histograms can be computed at different times.
  #
  # Output: A list of k weighed histograms for the lengths of the k queues, in the queue order. 
  #         For queue i, starting from 'start_time', the observed queue lengths are weighed by their occuring time spans.
  #         Entry j in the vector corresponds to the time spent at a queue length of j+1!
  
  if (length(queues) != length(list_hists)){
    stop('Queues length does not match list_hists length!')
  }
  
  
  for (i in seq_len(length(list_hists))){
    times = queues[[i]]$time
    q_lengths = queues[[i]]$nr_people
    hist_i = list_hists[[i]]
    
    # TODO: change output from QueuesFunction or solve smaller start_time than first recorded time here:
    if ( start_time <= times[1]){
      stop(paste("'start_time' is smaller than the first recorded time in queue", i))
    }
    
    # Filter out the specified time frame
    start_index = sum(times <= start_time) # Counts 0 if start_time == 0
    end_index = sum(times < end_time)
    if(start_index != end_index) {
      times = times[(start_index) + seq_len(end_index - start_index)] # Starts from start_index + 1
    } else {
      times = c()
    }
    q_lengths = q_lengths[(start_index - 1) + seq_len(end_index - start_index + 1)] # Starts from start_index
    
    # Compute time differences
    time_diffs = c(times, end_time) - c(start_time, times) # Same lenngth as 'q_lengths'
    # print(time_diffs)
    # print(q_lengths)
    
    # Compute weighed histogram
    max_q_length = max(q_lengths)
    if (max_q_length + 1 > length(hist_i)) {
      hist_i = c(hist_i, rep(0, max_q_length + 1 - length(hist_i) ))
    }
    for (j in seq_len(length(q_lengths))){
      hist_i[q_lengths[j] + 1] = hist_i[q_lengths[j] + 1] + time_diffs[j]
    }
    # print(hist_i)
    list_hists[[i]] = hist_i
  }
  return(list_hists)
}


PlotLengthHistograms = function(list_hists, start_time, end_time){
  max_q_length = max(sapply(list_hists, length))
  print(max_q_length)
  for (i in seq_len(length(list_hists))){
    points_to_plot = (seq_len(1001) - 1) / 1000 * (length(list_hists[[i]]) - .1) 
    corresponding_index = floor(points_to_plot) + 1
    hist_value_per_point = list_hists[[i]][corresponding_index] 
    plot(points_to_plot - .5, hist_value_per_point, type = 'l', xlab="Queue length",
         xlim=c(-.5,max_q_length - .5), ylab = "Time span")
  }
}


ComputeRunningLengthAverages = function(queues, start_time, end_time){
  
}

test_hists = ComputeLengthHistogramsRec(test_queues, list(c(0),c(0),c(0)), 1.5, 30)
PlotLengthHistograms(test_hists)
