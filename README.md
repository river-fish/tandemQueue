
# Tandem queues

This README is meant as an interactive communication platform. It lists the goals of the project, ways to approach it and goals of experiments. Please update me with results, both experimental as theoretical thoughts (e.g. design, motivation for experiments and methodology, theoretical issues, ...)!!

It might be useful to look up some papers that compare queueing set-ups! (__TODO__)

## Goal

The goals of this project are:

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

__Notes:__

experiment with ratio's of mean server rates, compare a different global (i.e. for all) distributions, compare how distributions can be combined to break it (e.g. heavy-tailed right before or after the slow one). 

Try mixtures, Hamemersly, play around reversibility?

Inspiration: literature....


## Design of experiments

We will always take a set-up with six servers and Poisson arrival rate 1.

### Comparability

1. When comparing distriubtions, keep mean server rates fixed.
2. To compare queues and account for randomness in the simulations, couple the servers with a [cdf-transform] if the quantile function is available. __TODO:__ better method for when this is not the case?

__TODO:__ 

Have a better idea of comparability: quickly glance in literature on comparing queue simulations?

### Ideas for experiments/ Techniques

1. Change the ratio's of mean server rates.
2. Change the location of the slowest server.
3. Change all the server distributions.
4. Put different distributions in series and compare on relative position. E.g. heavy-tailed before or behind slowest.

How to link these ideas to theory? (__TODO(Jack): How to get a better intuition on other settings?__)

__Notes on distributions:__
* First try deterministic server rates and maybe uniform. 
* Heavy-tailed distributions: first try one with many moments, then maybe Cauchy-like (e.g. f(x) \propto (1+ x^2)^(-2))

__Exploration:__
5. Hammersley book: control variates, ...
6. Burk's theorem: reversibility to Poisson departures ( something with innovations in one direction vs innovations in other direction)
7. __TODO(Tamar):__ What did Wilfrid mention again on "that" guy from "that" company?

### Diagnostics/visualisation

__TODO:__ How to use covariation study between different queues?

### Code

__List of TODOs:__
* Adjust queuing function
* Implement estimates of stationary distribution (histograms for every queue)

## Literature

Here we can list interesting literature, either to explore, or to have an overview of already known results. Please comment on what we have learned from them.

1. Asmussen
2. Hammersley



[//]: 

 [cdf-transform]: <https://en.wikipedia.org/wiki/Inverse_transform_sampling>
