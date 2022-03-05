---
title: Benchmarks for Mass Matrix Adaptation
date: 2019-12-14
tags:
  - open-source
  - pymc
---

I was lucky enough to be invited to attend the [Gradient
Retreat](https://gradientretreat.com/) earlier this month. It was an entire week
on a beautiful island with some amazingly intelligent Bayesians, and no demands
on my time other than the self-set (and admittedly vague) goal of contributing
to probabilistic programming in some way.

I initially tried to implement mass matrix adaptation in Tensorflow Probability,
but I quickly readjusted my goals to something more achievable: running some
benchmarks with tuning in Hamiltonian Monte Carlo (HMC).

<figure>
  <a href="/assets/images/galiano.jpg"><img src="/assets/images/galiano.jpg" alt="A view of a forest on Galiano Island"></a>
  <a href="/assets/images/galiano2.jpg"><img src="/assets/images/galiano2.jpg" alt="The view from a bluff on Galiano Island"></a>
  <figcaption>Pictures from Galiano Island.</figcaption>
</figure>

A quick rundown for those unfamiliar: _tuning_ is what happens before sampling,
during which the goal is not to actually draw samples, but to _prepare_ to draw
samples[^1]. For HMC and its variants, this means estimating HMC parameters such
as the step size, integration time and mass matrix[^2], the last of which is
basically the covariance matrix of the model parameters. Because my life is
finite (and I assume everybody else's is too), I limited myself to mass matrix
adaptation.

(If you're still uncertain about the details of tuning or mass matrix
adaptation, check out [Colin Carroll's essay on HMC
tuning](https://colcarroll.github.io/hmc_tuning_talk/) or the [Stan reference
manual on HMC
parameters](https://mc-stan.org/docs/2_20/reference-manual/hmc-algorithm-parameters.html):
I don't explain many more concepts in the rest of this post.)

The interesting thing about tuning is that there are no rules: there are no
asymptotic guarantees we can rely on and no mathematical results to which we can
turn for enlightened inspiration. The only thing we care about is obtaining a
decent estimate of the mass matrix, and preferably quickly.

Accompanying this lack of understanding of mass matrix adaptation is an
commensurate lack of (apparent) scientific inquiry — there is scant literature
to look to, and for open source developers, there is little prior art to draw
from when writing new implementations of HMC!

So I decided to do some empirical legwork and benchmark various methods of mass
matrix adaptation. Here are the questions I was interested in answering:

1. Is the assumption that the mass matrix is diagonal (in other words, assume
   that all parameters are uncorrelated) a good assumption to make?  What are
   the implications of this assumption for the tuning time, and the number of
   effective samples per second?
1. Does the tuning schedule (i.e. the sizes of the adaptation windows) make a
   big difference? Specifically, should we have a schedule of constant
   adaptation windows, or an "expanding schedule" of exponentially growing
   adaptation windows?
1. Besides assuming the mass matrix is diagonal, are there any other ways of
   simplifying mass matrix adaptation? For example, could we approximate the
   mass matrix as low rank?

I benchmarked five different mass matrix adaptation methods:

  1. A diagonal mass matrix (`diag`)
  1. A full (a.k.a. dense) mass matrix (`full`)
  1. A diagonal mass matrix adapted on an expanding schedule (`diag_exp`)
  1. A full mass matrix adapted on an expanding schedule (`diag_exp`)
  1. A low-rank approximation to the mass matrix using [Adrian Seyboldt's `covadapt` library](https://github.com/aseyboldt/covadapt).

I benchmarked these adaptation methods against six models:

  1. A 100-dimensional multivariate normal with a non-diagonal covariance matrix (`mvnormal`)
  1. A 100-dimensional multivariate normal with a low-rank covariance matrix (`lrnormal`)
  1. A [stochastic volatility model](https://docs.pymc.io/notebooks/stochastic_volatility.html) (`stoch_vol`)
  1. The [eight schools model](https://docs.pymc.io/notebooks/Diagnosing_biased_Inference_with_Divergences.html#The-Eight-Schools-Model) (`eight`)
  1. The [PyMC3 baseball model](https://docs.pymc.io/notebooks/hierarchical_partial_pooling.html) (`baseball`)
  1. A [sparse Gaussian process approximation](https://docs.pymc.io/notebooks/GP-SparseApprox.html#Examples) (`gp`)

Without further ado, the main results are shown below. Afterwards, I make some
general observations on the benchmarks, and finally I describe various
shortcomings of my experimental setup (which, if I were more optimistic, I would
call "directions for further work").

### Tuning Times

This tabulates the tuning time, in seconds, of each adaptation method for each
model. Lower is better. The lowest tuning time for each model is shown in bold
italics.

|              |**`mvnormal`**|**`lrnormal`**|**`stoch_vol`**|   **`gp`**|**`eight`**|**`baseball`**
|:-------------|-------------:|-------------:|--------------:|----------:|----------:|------------:|
|**`diag`**    |        365.34|        340.10|         239.59|      18.47|       2.92|         5.32|
|**`full`**    |    _**8.29**_|        364.07|         904.95|_**14.24**_| _**2.91**_|   _**4.93**_|
|**`diag_exp`**|        358.50|        360.91|   _**219.65**_|      16.25|       3.05|         5.08|
|**`full_exp`**|          8.46|        142.20|         686.58|      14.87|       3.21|         6.04|
|**`covadapt`**|        386.13|   _**89.92**_|         398.08|        N/A|        N/A|          N/A|

### Effective Samples per Second

This tabulates the number of effective samples drawn by each adaptation method
for each model. Higher is better. The highest numbers of effective samples per
second is shown in bold italics.

|              |**`mvnormal`**|**`lrnormal`**|**`stoch_vol`**|    **`gp`**| **`eight`**|**`baseball`**
|:-------------|-------------:|-------------:|--------------:|-----------:|-----------:|------------:|
|**`diag`**    |          0.02|          1.55|    _**11.22**_|       65.36|      761.82|       455.23|
|**`full`**    |          1.73|          0.01|           6.71|_**106.30**_|_**840.77**_| _**495.93**_|
|**`diag_exp`**|          0.02|          1.51|           9.79|       59.89|      640.90|       336.71|
|**`full_exp`**|_**1,799.11**_|_**1,753.65**_|           0.16|      101.99|      618.28|       360.14|
|**`covadapt`**|          0.02|        693.87|           5.71|         N/A|         N/A|          N/A|

## Observations

> **tldr:** As is typical with these sorts of things, no one adaptation method
> uniformly outperforms the others.

- A full mass matrix can provide significant improvements over a diagonal mass
  matrix for both the tuning time and the number of effective samples per
  second. This improvement can sometimes go up to two orders of magnitude!
  - This is most noticeable in the `mvnormal` model, with heavily correlated
    parameters.
  - Happily, my benchmarks are not the only instance of full mass matrices
    outperforming diagonal ones: [Dan Foreman-Mackey demonstrated something
    similar in one of his blog posts](https://dfm.io/posts/pymc3-mass-matrix/).
  - However, in models with less extreme correlations among parameters, this
    advantage shrinks significantly (although it doesn't go away entirely).
    Full matrices can also take longer to tune. You can see this in the baseball
    or eight schools model.
  - Nevertheless, full mass matrices never seem to perform egregiously _worse_
    than diagonal mass matrices. This makes sense theoretically: a full mass
    matrix can be estimated to be diagonal (at the cost of a quadratic memory
    requirement as opposed to linear), but not vice versa.
- Having an expanding schedule for tuning can sometimes give better performance,
  but nowhere near as significant as the difference between diagonal and full
  matrices. This difference is most noticeable for the `mvnormal` and `lrnormal`
  models (probably because these models have a constant covariance matrix and so
  more careful estimates using expanding windows can provide much better
  sampling).
- I suspect the number of effective samples per second for a full mass matrix on
  the `lrnormal` model (0.01 effective samples per second) is a mistake (or
  some other computational fluke): it looks way too low to be reasonable.
- I'm also surprised that `full_exp` does really badly (in terms of effective
  samples per second) on the `stoch_vol` model, despite `full` doing decently
  well! This is either a fluke, or a really interesting phenomenon to dig in to.
- `covadapt` seems to run into some numerical difficulties? While running these
  benchmarks I ran into an inscrutable and non-reproducible
  [`ArpackError`](https://stackoverflow.com/q/18436667) from SciPy.

## Experimental Setup

- All samplers were run for 2000 tuning steps and 1000 sampling steps. This is
  unusually high, but is necessary for `covadapt` to work well, and I wanted to
  use the same number of iterations across all the benchmarks.
- My expanding schedule is as follows: the first adaptation window is 100
  iterations, and each subsequent window is 1.005 times the previous window.
  These numbers give 20 updates within 2000 iterations, while maintaining an
  exponentially increasing adaptation window size.
- I didn't run `covadapt` for models with fewer than 100 model parameters.
  With so few parameters, there's no need to approximate a mass matrix as
  low-rank: you can just estimate the full mass matrix!
- I set `target_accept` (a.k.a. `adapt_delta` to Stan users) to 0.9 to make all
  divergences go away.
- All of these numbers were collected by sampling once per model per adaptation
  method (yes only once, sorry) in PyMC3, running on my MacBook Pro.

## Shortcomings

- In some sense comparing tuning times is not a fair comparison: it's possible
  that some mass matrix estimates converge quicker than others, and so comparing
  their tuning times is essentially penalizing these methods for converging
  faster than others.
- It's also possible that my expanding schedule for the adaptation windows just
  sucks! There's no reason why the first window needs to be 100 iterations, or
  why 1.005 should be a good multiplier. It looks like Stan [doubles their
  adaptation window
  sizes](https://github.com/stan-dev/stan/blob/736311d88e99b997f5b902409752fb29d6ec0def/src/stan/mcmc/windowed_adaptation.hpp#L95)
  during warmup.
- These benchmarks are done only for very basic toy models: I should test more
  extensively on more models that people in The Real World™ use.
- If you are interested in taking these benchmarks further (or perhaps just want
  to fact-check me on my results), the code is [sitting in this GitHub
  repository](https://github.com/eigenfoo/mass-matrix-benchmarks)[^3].

[^1]: It's good to point out that mass matrix adaptation is to make sampling
      more efficient, not more valid. Theoretically, any mass matrix would work,
      but a good one (i.e. a good estimate of the covariance matrix of the model
      parameters) could sample orders of magnitudes more efficiently.

[^2]: …uh, _*sweats and looks around nervously for differential geometers*_
      more formally called the _metric_…

[^3]: There are some violin plots lying around in the notebook, a relic from a
      time when I thought that I would have the patience to run each model and
      adaptation method multiple times.
