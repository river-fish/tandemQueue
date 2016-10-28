
# Tandem queues

This README is meant as an interactive communication platform. It lists the goals of the project, ways to approach it and goals of experiments. Please update me with results, both experimental as theoretical thoughts (e.g. design, motivation for experiments and methodology, theoretical issues, ...)!!

## Goal

The goals of this project are:

1) Review the theory for the Poisson arrivals and exponentially distributed service times, for servers in sequence that are reversible;
Conclusions:
- For M/M/1: the distribution of the amount of people in the queue converges to a Geometric distribution with parameter the traffic intensity.
- In series:
TODO: complete

2) Design and conduct simulation studies to see whether the "slowest server controls stability" remains true for a sequence of queues as above, when service times are not exponentially distributed.
We formulate a hypothesis and try to break it. The question becomes: how can we design scenario's where it is not decided by the slowest. Current hypothesis:

" The server with the slowest mean serving rate dominates the behaviour of the queues. "

Expectation: we will need higher order moments to account for heavy tails.

Notes: experiment with ratio's of mean server rates, compare a different global (i.e. for all) distributions, compare how distributions can be combined to break it (e.g. heavy-tailed right before or after the slow one). 

Try mixtures, Hamemersly, play around reversibility?

Inspiration: literature....


# We can draw notes here!

## Fancy ones...

* ... in
* a
* list
