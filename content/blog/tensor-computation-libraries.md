---
title: What I Wish Someone Had Told Me About Tensor Computation Libraries
date: 2020-12-15
tags:
  - open-source
  - machine-learning
  - deep-learning
---

I get confused with tensor computation libraries (or computational graph libraries, or symbolic
algebra libraries, or whatever they're marketing themselves as these days).

I was first introduced to PyTorch and TensorFlow and, having no other reference, thought they were
prototypical examples of tensor computation libraries. Then I learnt about Theano --- an older and
less popular project, but different from PyTorch and TensorFlow and better in some meaningful ways.
This was followed by JAX, which seemed to be basically NumPy with more bells and whistles (although
I couldn't articulate what exactly they were). Then came [the announcement by the PyMC developers
that Theano would have a new JAX
backend](https://pymc-devs.medium.com/the-future-of-pymc3-or-theano-is-dead-long-live-theano-d8005f8a0e9b).

Anyways, this confusion prompted a lot of research and eventually, this blog post.

Similar to [my previous post on the anatomy of probabilistic programming
frameworks](https://www.georgeho.org/prob-prog-frameworks/), I’ll first discuss tensor computation
libraries in general --- what they are and how they can differ from one another. Then I'll discuss
some libraries in detail, and finally offer an observation on the future of Theano in the context of
contemporary tensor computation libraries.

{{< toc >}}

## Dissecting Tensor Computation Libraries

First, a characterization: what do tensor computation libraries even do?

1. They provide ways of specifying and building computational graphs,
1. They run the computation itself (duh), but also run "related" computations that either (a) _use
   the computational graph_, or (b) operate _directly on the computational graph itself_,
   * The most salient example of the former is computing gradients via
     [autodifferentiation](https://arxiv.org/abs/1502.05767),
   * A good example of the latter is optimizing the computation itself: think symbolic
     simplifications (e.g.  `xy/x = y`) or modifications for numerical stability (e.g. [`log(1 + x)`
     for small values of `x`](https://cs.stackexchange.com/q/68411)).
1. And they provide "best execution" for the computation: whether it's changing the execution by JIT
   (just-in-time) compiling it, by utilizing special hardware (GPUs/TPUs), by vectorizing the
   computation, or in any other way.

### "Tensor Computation Library" --- Maybe Not The Best Name

As an aside: I realize that the name "tensor computation library" is too broad, and that the
characterization above precludes some libraries that might also justifiably be called "tensor
computation libraries".  Better names might be "graph computation library" (although that might get
mixed up with libraries like [`networkx`](https://networkx.org/)) or "computational graph management
library" or even "symbolic tensor algebra libraries".

So for the avoidance of doubt, here is a list of libraries that this blog post is _not_ about:

- NumPy and SciPy
  * These libraries don't have a concept of a computational graph --- they’re more like a toolbox of
    functions, called from Python and executed in C or Fortran.
  * However, this might be a controversial distinction --- as we’ll see later, JAX also doesn't build
    an explicit computational graph either, and I definitely want to include JAX as a "tensor
    computation library"... ¯\\\_(ツ)\_/¯
- Numba and Cython
  * These libraries provide best execution for code (and in fact some tensor computation libraries,
    such as Theano, make good use them), but like NumPy and SciPy, they do not actually manage the
    computational graph itself.
- Keras, Trax, Flax and PyTorch-Lightning
  * These libraries are high-level wrappers around tensor computation libraries --- they basically
    provide abstractions and a user-facing API to utilize tensor computation libraries in a
    friendlier way.

### (Some) Differences Between Tensor Computation Libraries

Anyways, back to tensor computation libraries.

All three aforementioned goals are ambitious undertakings with sophisticated solutions, so it
shouldn't be surprising to learn that decisions in pursuit on goal can have implications for (or
even incur a trade-off with!) other goals. Here's a list of common differences along all three axes:

1. Tensor computation libraries can differ in how they represent the computational graph, and how it
   is built.
   - Static or dynamic graphs: do we first define the graph completely and then inject data to run
     (a.k.a. define-and-run), or is the graph defined on-the-fly via the actual forward computation
     (a.k.a. define-by-run)?
     * TensorFlow 1.x was (in)famous for its static graphs, which made users feel like they were
       "working with their computational graph through a keyhole", especially when [compared to
       PyTorch's dynamic graphs](https://news.ycombinator.com/item?id=13429355).
   - Lazy or eager execution: do we evaluate variables as soon as they are defined, or only when a
     dependent variable is evaluated? Usually, tensor computation libraries either choose to support
     dynamic graphs with eager execution, or static graphs with lazy execution --- for example,
     [TensorFlow 2.0 supports both modes](https://www.tensorflow.org/guide/eager).
   - Interestingly, some tensor computation libraries (e.g. [Thinc](https://thinc.ai/)) don't even
     construct an explicit computational graph: they represent it as [chained higher-order
     functions](https://thinc.ai/docs/concept).

1. Tensor computation libraries can also differ in what they want to use the computational graph
   _for_ --- for example, are we aiming to do things that basically amount to running the
   computational graph in a "different mode", or are we aiming to modify the computational graph
   itself?
   - Almost all tensor computation libraries support autodifferentiation in some capacity (either
     forward-mode, backward-mode, or both).
   - Obviously, how you represent the computational graph and what you want to use it for are very
     related questions! For example, if you want to be able to represent aribtrary computation as a
     graph, you'll have to handle control flow like if-else statements or for-loops --- this leads
     to common gotchas with [using Python for-loops in
     JAX](https://jax.readthedocs.io/en/latest/notebooks/Common_Gotchas_in_JAX.html#%F0%9F%94%AA-Control-Flow)
     or needing to use [`torch.nn.ModuleList` in for-loops with
     PyTorch](https://discuss.pytorch.org/t/can-you-have-for-loops-in-the-forward-prop/68295).
   - Some tensor computation libraries (e.g. [Theano](https://github.com/Theano/Theano) and it's
     fork, [Theano-PyMC](https://theano-pymc.readthedocs.io/en/latest/index.html)) aim to [optimize
     the computational graph
     itself](https://theano-pymc.readthedocs.io/en/latest/extending/optimization.html), for which an
     [explicit graph is necessary](#an-observation-on-static-graphs-and-theano).

1. Finally, tensor computation libraries can also differ in how they execute code.
   - All tensor computation libraries run on CPU, but the strength of GPU and TPU support is a major
     differentiator among tensor computation libraries.
   - Another differentiator is how tensor computation libraries compile code to be executed on
     hardware. For example, do they use JIT compilation or not? Do they use "vanilla" C or CUDA
     compilers, or [the XLA compiler for machine-learning specific
     code](https://tensorflow.google.cn/xla)?

## A Zoo of Tensor Computation Libraries

Having outlined the basic similarities and differences of tensor computation libraries, I think
it'll be helpful to go through several of the popular libraries as examples. I've tried to link to
the relevant documentation where possible.[^1]

### [PyTorch](https://pytorch.org/)

1. How is the computational graph represented and built?
   - PyTorch dynamically builds (and eagerly evaluates) an explicit computational graph. For more
     detail on how this is done, check out [the PyTorch docs on autograd
     mechanics](https://pytorch.org/docs/stable/notes/autograd.html).
   - For more on how PyTorch computational graphs, see [`jdhao`'s introductory blog post on
     computational graphs in
     PyTorch](https://jdhao.github.io/2017/11/12/pytorch-computation-graph/).
1. What is the computational graph used for?
   - To quote the [PyTorch docs](https://pytorch.org/docs/stable/index.html), "PyTorch is an
     optimized tensor library for deep learning using GPUs and CPUs" --- as such, the main focus is
     on [autodifferentiation](https://pytorch.org/docs/stable/notes/autograd.html).
1. How does the library ensure "best execution" for computation?
   - PyTorch has [native GPU support](https://pytorch.org/docs/stable/notes/cuda.html) via CUDA.
   - PyTorch also has support for TPU through projects like
     [PyTorch/XLA](https://github.com/pytorch/xla) and
     [PyTorch-Lightning](https://www.pytorchlightning.ai/).

### [JAX](https://jax.readthedocs.io/en/latest/)

1. How is the computational graph represented and built?
   - Instead of building an explicit computational graph to compute gradients, JAX simply supplies a
     `grad()` that returns the gradient function of any supplied function. As such, there is
     technically no concept of a computational graph --- only pure (i.e. stateless and
     side-effect-free) functions and their gradients.
   - [Sabrina Mielke summarizes the situation very well](https://sjmielke.com/jax-purify.htm):

     > PyTorch builds up a graph as you compute the forward pass, and one call to `backward()` on
     > some "result" node then augments each intermediate node in the graph with the gradient of the
     > result node with respect to that intermediate node. JAX on the other hand makes you express
     > your computation as a Python function, and by transforming it with `grad()` gives you a
     > gradient function that you can evaluate like your computation function — but instead of the
     > output it gives you the gradient of the output with respect to (by default) the first
     > parameter that your function took as input.

1. What is the computational graph used for?
   - According to the [JAX quickstart](https://jax.readthedocs.io/en/latest/notebooks/quickstart.html),
     JAX bills itself as "NumPy on the CPU, GPU, and TPU, with great automatic differentiation for
     high-performance machine learning research". Hence, its focus is heavily on
     autodifferentiation.
1. How does the library ensure "best execution" for computation?
   - This is best explained by quoting the [JAX quickstart](https://jax.readthedocs.io/en/latest/notebooks/quickstart.html):

     > JAX uses XLA to compile and run your NumPy code on [...] GPUs and TPUs. Compilation happens
     > under the hood by default, with library calls getting just-in-time compiled and executed. But
     > JAX even lets you just-in-time compile your own Python functions into XLA-optimized kernels
     > [...] Compilation and automatic differentiation can be composed arbitrarily [...]

   - For more detail on JAX’s four-function API (`grad`, `jit`, `vmap` and `pmap`), see
     [Alex Minaar's overview of how JAX works](http://alexminnaar.com/2020/08/15/jax-overview.html).

### [Theano](https://theano-pymc.readthedocs.io/en/latest/)

> **Note:** the [original Theano](https://github.com/Theano/Theano) (maintained by
> [MILA](https://mila.quebec/en/)) has been discontinued, and the PyMC developers have forked the
> project: [Theano-PyMC](https://github.com/pymc-devs/Theano-PyMC) (soon to be renamed Aesara). I'll
> discuss both the original and forked projects below.

1. How is the computational graph represented and built?
   - Theano statically builds (and lazily evaluates) an explicit computational graph.
1. What is the computational graph used for?
   - Theano is unique among tensor computation libraries in that it places more emphasis on
     reasoning about the computational graph itself. In other words, while Theano has [strong
     support for
     autodifferentiation](https://theano-pymc.readthedocs.io/en/latest/library/gradient.html),
     running the computation and computing gradients isn't the be-all and end-all: Theano has an
     entire module for [optimizing the computational graph
     itself](https://theano-pymc.readthedocs.io/en/latest/optimizations.html), and makes it fairly
     straightforward to compile the Theano graph to different computational backends (by default,
     Theano compiles to C or CUDA, but it’s straightforward to compile to JAX).
   - Theano is often remembered as a library for deep learning research, but it’s so much more than
     that!
1. How does the library ensure "best execution" for computation?
   - The original Theano used the GCC C compiler for CPU computation, and the NVCC CUDA compiler for
     GPU computation.
   - The Theano-PyMC fork project [will use JAX as a
     backend](https://pymc-devs.medium.com/the-future-of-pymc3-or-theano-is-dead-long-live-theano-d8005f8a0e9b),
     which can utilize CPUs, GPUs and TPUs as available.

## An Observation on Static Graphs and Theano

Finally, a quick observation on static graphs and the niche that Theano fills that other tensor
computation libraries do not. I had huge help from [Thomas Wiecki](https://twiecki.io/) and
[Brandon Willard](https://brandonwillard.github.io/) with this section.

There's been a consistent movement in most tensor computation libraries away from static graphs (or
more precisely, statically _built_ graphs): PyTorch and TensorFlow 2 both support dynamically
generated graphs by default, and JAX forgoes an explicit computational graph entirely.

This movement is understandable --- building the computational graph dynamically matches people's
programming intuition much better. When I write `z = x + y`, I don't mean _"I want to register a sum
operation with two inputs, which is waiting for data to be injected"_ --- I mean _"I want to compute
the sum of `x` and `y`"._ The extra layer of indirection is not helpful to most users, who just want
to run their tensor computation at some reasonable speed.

So let me speak in defence of statically built graphs.

Having an explicit representation of the computational graph is immensely useful for certain things,
even if it makes the graph harder to work with. You can modify the graph (e.g. graph optimizations,
simplifications and rewriting), and you can reason about and analyze the graph. Having the
computation as an actual _object_ helps immeasurably for tasks where you need to think about the
computation itself, instead of just blindly running it.

On the other hand, with dynamically generated graphs, the computational graph is never actually
defined anywhere: the computation is traced out on the fly and behind the scene. You can no longer
do anything interesting with the computational graph: for example, if the computation is slow, you
can't reason about _what_ parts of the graph are slow. The end result is that you basically have to
hope that the framework internals are doing the right things, which they might not!

This is the niche that Theano (or rather, Theano-PyMC/Aesara) fills that other contemporary tensor
computation libraries do not: the promise is that if you take the time to specify your computation
up front and all at once, Theano can optimize the living daylight out of your computation --- whether
by graph manipulation, efficient compilation or something else entirely --- and that this is something
you would only need to do once.

[^1]: Some readers will notice the conspicuous lack of TensorFlow from this list - its exclusion isn't out of malice, merely a lack of time and effort to do the necessary research to do it justice. Sorry.
