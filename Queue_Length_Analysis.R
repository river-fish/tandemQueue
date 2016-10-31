library(lattice)
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
    # TODO: change output from QueuesFunction or solve "smaller start_time than first recorded time" here:
    if ( start_time <= queues[[i]]$time[1]){
      stop(paste("'start_time' is smaller than the first recorded time in queue", i))
    }
  }
  
  for (i in seq_len(length(list_hists))){
    times = queues[[i]]$time
    q_lengths = queues[[i]]$nr_people
    hist_i = list_hists[[i]]
    
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
    time_diffs = c(times, end_time) - c(start_time, times) # Same length as 'q_lengths'
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

# TODO: check corectness: still deviation up to 3rd significant decimal?
ComputeRunningLengthAverages = function(queues, start_time, end_time){
  
  #
  #
  #
  #
  # Output: A list of a time grid and the corresponding mean queue lengths.  
  #         The output starts at start_time + .5 * (end_time - start_time).
  #
  
  for (i in seq_len(length(queues))){
    # TODO: change output from QueuesFunction or solve "smaller start_time than first recorded time" here:
    if ( start_time <= queues[[i]]$time[1]){
      stop(paste("'start_time' is smaller than the first recorded time in queue", i))
    }
  }
  
  running_average_q_length = list()
  for (i in seq_len(length(queues))){
    times = queues[[i]]$time
    q_lengths = queues[[i]]$nr_people

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
    time_diffs = c(times, end_time) - c(start_time, times) # Same length as 'q_lengths'
    
    # Compute cumulative queue length; TODO: eliminate overhead in calculations
    # Needs to be improved/cleaned up...
    time_grid = (seq_len(501) - 1) / 500 * (end_time - start_time) + start_time
    cum_q_length_at_times = c(0,cumsum(time_diffs * q_lengths)) # At start_time, times[1], times[2], ...
    cum_q_length_at_grid = c()
    next_jump_time_index = 1
    times = c(times, end_time * 2) # To not go out of index range
    for (j in seq_len(501)){
      t = time_grid[j]
      while(t > times[next_jump_time_index]){
        next_jump_time_index = next_jump_time_index + 1
      }
      if (next_jump_time_index == 1){
        cum_q_length_at_grid[j] = cum_q_length_at_times[next_jump_time_index] + (t - start_time) * q_lengths[next_jump_time_index]
      } else {
        cum_q_length_at_grid[j] = cum_q_length_at_times[next_jump_time_index] + (t - times[next_jump_time_index - 1]) * q_lengths[next_jump_time_index]
        # print(paste("Point", j))
        # print(t)
        # print(times[next_jump_time_index])
        # print(cum_q_length_at_grid)
        # print(q_lengths[next_jump_time_index])
      }
    }
    # print(length(cum_q_length_at_grid))
    running_average_q_length[[i]] = cum_q_length_at_grid[250 + seq_len(250)] / (time_grid[250 + seq_len(250)] - start_time)
  }
  
  return(list(time_grid[250 + seq_len(250)], running_average_q_length))
}

PlotRunningLengthAverages = function(output_running_averages) {
  time_grid = output_running_averages[[1]]
  running_averages = output_running_averages[[2]]
  nr_queues = length(running_averages)
  
  largest_queue_length = max(sapply(running_averages, max))
  
  plot(time_grid, running_averages[[1]], type = 'l', col = 2, xlab = "Time", ylab = "Average queue length",
       ylim = c(0, largest_queue_length * 1.1))
  if (nr_queues > 1){
    for (i in (1 + seq_len(nr_queues -1))){
      par(new = TRUE)
      plot(time_grid, running_averages[[i]], col=i+1, type = 'l', xlab = "", ylab = "",
           ylim = c(0, largest_queue_length * 1.1), bty = "n", axes = FALSE)
    }
  }
  legend_names = sapply(seq_len(nr_queues), function(i) {paste("Queue", i)})
  legend("bottomright", legend_names, col= 1 + seq_len(nr_queues), lty=c(1,1))
}

test_hists = ComputeLengthHistogramsRec(test_queues, list(c(0),c(0),c(0)), 1.5, 30)
PlotLengthHistograms(test_hists)

running_averages = ComputeRunningLengthAverages(test_queues, 1.5,30)
running_averages[[2]][[1]]
running_averages[[1]]
test_hists[[3]]
PlotRunningLengthAverages(running_averages)
