---
title: "`littlemcmc` — A Standalone HMC and NUTS Sampler in Python"
date: 2020-10-06
tags:
  - bayes
  - open-source
  - probabilistic-programming
  - pymc
  - python
---


<center>
  <img
   src="https://raw.githubusercontent.com/eigenfoo/littlemcmc/master/docs/_static/logo/default-cropped.png"
   alt="LittleMCMC logo">
</center>

Recently there has been a modularization (or, if you're hip with tech-lingo, an
[_unbundling_](https://techcrunch.com/2015/04/18/the-unbundling-of-everything/))
of Bayesian modelling libraries. Whereas before, probability distributions,
model specification, inference and diagnostics were more or less rolled into one
library, it's becoming more and more realistic to specify a model in one
library, accelerate it using another, perform inference with a third and use a
fourth to visualize the results. (For example, Junpeng Lao has recently had
[good success](https://twitter.com/junpenglao/status/1309470970223226882) doing
exactly this!)

It's in this spirit of unbundling that the PyMC developers wanted to [spin out
the core HMC and NUTS samplers from PyMC3 into a separate
library](https://discourse.pymc.io/t/isolate-nuts-into-a-new-library/3974).
PyMC3 has a very well-tested and performant Python implementation of HMC and
NUTS, which would be very useful to any users who have their own functions for
computing log-probability and its gradients, and who want to use a lightweight
and reliable sampler.

So for example, if you're a physical scientist with a Bayesian model who's
written your own functions to compute the log probability and its gradients
(perhaps for performance or interoperability reasons), and need a good MCMC
sampler, then `littlemcmc` is for you! As long as you can call your functions
from Python, you can use the same HMC or NUTS sampler that's used by the rest of
the PyMC3 community.

So without further ado: please check out `littlemcmc`!

- [GitHub](https://github.com/eigenfoo/littlemcmc)
- [Read the Docs](https://littlemcmc.readthedocs.io/en/latest/)
