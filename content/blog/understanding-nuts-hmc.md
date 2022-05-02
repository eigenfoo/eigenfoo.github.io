---
title: Understanding NUTS and HMC
date: 2021-01-07
tags:
  - bayes
---

*"Bayesian modeling is harder than deep learning"* is a sentiment I've been
hearing a lot lately.  While I'm skeptical of sweeping statements like that, I
agree when it comes to the central inference algorithm --- how MCMC samplers
work (especially the *de facto* standard samplers, NUTS and HMC) is one of the
most difficult concepts I've tried to learn, and is certainly harder than
autodifferentiation or backpropagation.

So I thought I'd share what worked for me when I tried to teach myself NUTS and
HMC. In chronological order of publication, these are the three resources that
I’d recommend reading to grok NUTS/HMC:

1. [Radford Neal's chapter in the MCMC
   handbook](http://www.mcmchandbook.net/HandbookChapter5.pdf)
2. [Matthew Hoffman’s *The No-U-Turn Sampler* (a.k.a. the original NUTS
   paper)](https://arxiv.org/abs/1111.4246)
3. [Michael Betancourt’s *Conceptual Introduction to Hamiltonian Monte
   Carlo*](https://arxiv.org/abs/1701.02434)

Not only did I find it useful to read these papers several times (as one would
read any sequence of "important" papers), but also to read them in both
chronological and reverse-chronological order. Reading both forwards and
backwards gave me multiple expositions of important ideas and also let me
mentally "diff" the papers to see the progression of ideas over time. For
example, Neal's chapter was written before NUTS was discovered, which gives you
a sense of what the MCMC world looked like prior to Hoffman's work: making
progress in fits and starts, but in need of a real leap forward.

In terms of reading code, I'd recommend looking through [Colin Carroll’s
`minimc`](https://github.com/ColCarroll/minimc) for a minimal working example
of NUTS in Python, written for pedagogy rather than actual sampling. For a
"real world" implementation of NUTS/HMC, I’d recommend looking through [my
`littlemcmc`](https://github.com/eigenfoo/littlemcmc) for a standalone version
of PyMC3’s NUTS/HMC samplers.

Finally, for anyone who wants to read around computational methods for Bayesian
inference more generally (i.e. not restricted to HMC, for example), I'd
(unashamedly) point to [my blog post on
this](https://www.georgeho.org/bayesian-inference-reading/).
