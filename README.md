
# Tandem queues

This README is meant as an interactive communication platform. It lists the goals of the project, ways to approach it and goals of experiments. Please update me with results, both experimental as theoretical thoughts (e.g. design, motivation for experiments and methodology, theoretical issues, ...)!!

It might be useful to look up some papers that compare queueing set-ups, to gain insight in diagnostics, estimates, comparability, interesting set-ups ...! (__TODO__)

## Goals

### 1) Theory
> Review the theory for the Poisson arrivals and exponentially distributed service times, for servers in sequence that are reversible;

__Conclusions:__
- For M/M/1: the distribution of the amount of people in the queue converges to a Geometric distribution with parameter the traffic intensity.
- In series:

__TODO: complete__

### 2) Simulation 

> Design and conduct simulation studies to see whether the "slowest server controls stability" remains true for a sequence of queues as above, when service times are not exponentially distributed.

We formulate a hypothesis and try to break it. The question becomes: how can we design scenario's where it is not decided by the slowest. 

__Current hypothesis:__

> The server with the slowest mean serving rate dominates the behaviour of the queues. 

_Expectation_: we will need higher order moments to account for heavy tails.

## Design of experiments

We will always take a set-up with six servers and Poisson arrival rate 1.

### 1) Comparability

1. When comparing distriubtions, keep mean server rates fixed.
2. To compare queues and account for randomness in the simulations, couple the servers with a [cdf-transform] if the quantile function is available. __TODO:__ better method for when this is not the case?

__TODO:__ 

Have a better idea of comparability: quickly glance in literature on comparing queue simulations?

### 2) Ideas for experiments/techniques

1. Change the ratio's of mean server rates.
2. Change the location of the slowest server.
3. Change all the server distributions.
4. Put different distributions in series and compare on relative position. E.g. heavy-tailed before or behind slowest.

How to link these ideas to theory? (__TODO(Jack): How to get a better intuition on other settings?__)

__Notes on distributions:__

* First try deterministic server rates and maybe uniform. 
* Heavy-tailed distributions: first try one with many moments, then maybe Cauchy-like (e.g. f(x) \propto (1+ x^2)^(-2))

__TODO, to explore:__

5. Hammersley book: control variates, ...
6. Burk's theorem: reversibility to Poisson departures ( something with innovations in one direction vs innovations in other direction)

### 3) Diagnostics/visualisation

__TODO:__ How to use covariation study between different queues?

__TODO:__ Include ideas for diagnostics

__TODO:__ Report on choices for diagnostics?visualisations. E.g. ergodic averages vs fixed times. __Literature??__

## Results of experiments

Please summarize the results of simulation studies. We can use the following format to refer to a certain set-up (in order of the server sequence):

> [Exp(.5), Exp(.3), Unif(0, .5), Deterministic(.3), Cauchy(...), Exp(.001)]

## Code

__List of TODOs:__

* Adjust queuing function
* Implement estimates of stationary distribution (histograms for every queue)


## Literature

Here we can list interesting literature, either to explore, or to have an overview of already known results. Please comment on what we have learned from them.

1. Asmussen
2. Hammersley
3. The guy from Herriott Watt that is the expert in heavy tails + queues: https://scholar.google.co.uk/citations?user=tRVsLywAAAAJ&hl=en


 [cdf-transform]: <https://en.wikipedia.org/wiki/Inverse_transform_sampling>
