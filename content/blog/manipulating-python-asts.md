---
title: Adventures in Manipulating Python ASTs
date: 2020-03-27
tags:
  - pymc
  - python
---

A while back, I explored the possibility of simplifying [^1] PyMC4's model specification
API by manipulating the [Python abstract syntax
tree](https://docs.python.org/3/library/ast.html) (AST) of the model code. The PyMC
developers didn't end up pursuing those API changes any further, but not until I had the
chance to learn a lot about Python ASTs.

Enough curious people have asked me about my experience tinkering with ASTs that I
figure I'd write a short post about the details of my project, in the hope that someone
else will find it useful.

You should read this blog post as a quick overview of my experience with Python ASTs, or
an annotated list of links, and not a comprehensive tutorial on model specification APIs
or Python ASTs. For a full paper trail of my adventures with Python ASTs, check out [my
notebooks on
GitHub](https://github.com/eigenfoo/random/tree/master/python/ast-hiding-yield).

## The Problem

Originally, PyMC4's proposed model specification API looked something like this:

```python
def linear_regression(x):
    scale = yield tfd.HalfCauchy(0, 1)
    coefs = yield tfd.Normal(tf.zeros(x.shape[1]), 1)
    predictions = yield tfd.Normal(tf.linalg.matvec(x, coefs), scale)
    return predictions
```

The main drawback to this API was that the `yield` keyword was confusing. Many users
don’t really understand Python generators, and those who do might only understand
`yield` as a drop-in replacement for `return` (that is, they might understand what it
means for a function to end in `yield foo`, but would be uncomfortable with `bar = yield
foo`).

Furthermore, the `yield` keyword introduces a leaky abstraction[^2]: users don’t care
about whether model is a function or a generator, and they shouldn't need to. More
generally, users shouldn't have to know anything about how PyMC works in order to use
it: ideally, the only thing users would need to think about would be their data and
their model. Having to graft several `yield` keywords into their code is a fairly big
intrusion in that respect.

Finally, this model specification API is essentially moving the problem off of our
plates and onto our users. The entire point of the PyMC project is to provide a friendly
and easy-to-use interface for Bayesian modelling.

To enumerate the problem further, we wanted to:

1. Hide the `yield` keyword from the user-facing model specification API.
1. Obtain the user-defined model as a generator.

The main difficulty with the first goal is that as soon as we remove `yield` from the
model function, it is no longer a generator. However, the PyMC inference engine needs the
model as a generator, since this allows us to interrupt the control flow of the model at
various points to do certain things:

  - Manage random variable names.
  - Perform sampling.
  - Other arbitrary PyMC magic that I'm truthfully not familiar with.

In short, the user writes their model as a function, but we require the model as a
generator.

I opine on why this problem is challenging a lot more
[here](https://github.com/eigenfoo/random/tree/master/python/ast-hiding-yield/00-prototype#why-is-this-problem-hard).

## The Solution

First, I wrote a `FunctionToGenerator` class:

```python
class FunctionToGenerator(ast.NodeTransformer):
    """
    This subclass traverses the AST of the user-written, decorated,
    model specification and transforms it into a generator for the
    model. Subclassing in this way is the idiomatic way to transform
    an AST.
    Specifically:

    1. Add `yield` keywords to all assignments
       E.g. `x = tfd.Normal(0, 1)` -> `x = yield tfd.Normal(0, 1)`
    2. Rename the model specification function to
       `_pm_compiled_model_generator`. This is done out an abundance
       of caution more than anything.
    3. Remove the @Model decorator. Otherwise, we risk running into
       an infinite recursion.
    """
    def visit_Assign(self, node):
        new_node = node
        new_node.value = ast.Yield(value=new_node.value)

        # Tie up loose ends in the AST.
        ast.copy_location(new_node, node)
        ast.fix_missing_locations(new_node)
        self.generic_visit(node)
        return new_node

    def visit_FunctionDef(self, node):
        new_node = node
        new_node.name = "_pm_compiled_model_generator"
        new_node.decorator_list = []

        # Tie up loose ends in the AST.
        ast.copy_location(new_node, node)
        ast.fix_missing_locations(new_node)
        self.generic_visit(node)
        return new_node
```

Subclassing `ast.NodeTransformer` (as `FunctionToGenerator` does) is the [recommended
way of modifying
ASTs](https://greentreesnakes.readthedocs.io/en/latest/manipulating.html#modifying-the-tree).
The functionality of `FunctionToGenerator` is pretty well described by the docstring:
the `visit_Assign` method adds the `yield` keyword to all assignments by wrapping the
visited `Assign` node within a `Yield` node. The `visit_FunctionDef` method removes the
decorator and renames the function to `_pm_compiled_model_generator`. All told, after
the `NodeTransformer` is done with the AST, we have one function,
`_pm_compiled_model_generator`, which is a modified version of the user-defined
function.

Second, the `Model` class:

```python
class Model:
    """ pm.Model decorator. """

    def __init__(self, func):
        self.func = func

        # Introspect wrapped function, instead of the decorator class.
        functools.update_wrapper(self, func)

        # Uncompile wrapped function.
        uncompiled = uncompile(func.__code__)

        # Parse AST and modify it.
        tree = parse_snippet(*uncompiled)
        tree = FunctionToGenerator().visit(tree)
        uncompiled[0] = tree

        # Recompile wrapped function.
        self.recompiled = recompile(*uncompiled)

        # Execute recompiled code (defines `_pm_compiled_model_generator`)
        # in the locals() namespace and assign it to an attribute.
        # Refer to http://lucumr.pocoo.org/2011/2/1/exec-in-python/
        exec(self.recompiled, None, locals())
        self.model_generator = locals()["_pm_compiled_model_generator"]
```

This class isn't meant to be instantiated: rather, it's [meant to be used as a Python
decorator](https://realpython.com/primer-on-python-decorators/#classes-as-decorators).
Essentially, it "uncompiles" the function to get the Python source code of the function.
This source code is then passed to the `parse_snippet`[^3] function, which returns the
AST for the function. We then modify this AST with the `FunctionToGenerator` class that
we defined above. Finally, we recompile this AST and execute it. Recall that executing
this recompiled AST defines a new function called `_pm_compiled_model_generator`. This
new function, accessed via the `locals` variable[^4], is then bound to the class's
`self.model_generator`, which explains the confusing-looking
`self.model_generator = locals()["_pm_compiled_model_generator"]`.

Finally, the user facing API looks like this:

```python
@Model
def linear_regression(x):
    scale = tfd.HalfCauchy(0, 1)
    coefs = tfd.Normal(tf.zeros(x.shape[1]), 1)
    predictions = tfd.Normal(tf.linalg.matvec(x, coefs), scale)
    return predictions


linear_regression.model_generator(tf.zeros([3, 10]))  # Shape is irrelevant here

# Out[8]:
# <generator object _pm_compiled_model_generator at 0x107a5c5c8>
```

As you can see, the users need not write `yield` while specifying their models, and the
PyMC inference engine can now simply call the `model_generator` method of
`linear_regression` to produce a generator called `_pm_compiled_model_generator`, as
desired. Success!

## Lessons Learnt

Again, PyMC4's model specification API will _not_ be incorporating these changes: the
PyMC developers have since decided that the `yield` keyword is the most elegant (but not
necessarily the easiest) way for users to specify statistical models. This post is just
meant to summarize the lessons learnt while pursuing this line of inquiry. 

Reading and parsing the AST is perfectly safe: that's basically just a form of code
introspection, which is totally a valid thing to do! It's when you want to modify or
even rewrite the AST that things start getting ~~janky~~ dangerous (especially if you
want to execute the modified AST _instead_ of the written code, as I was trying to do!).

If you want to programmatically modify the AST (e.g. "insert a `yield` keyword in front
of every assignment of a TensorFlow Distribution", as in our case), stop and consider if
you're attempting to modify the _semantics_ of the written code, and if you're sure that
that's a good idea (e.g. the `yield` keywords in the code _mean something_, and remove
those keywords changes the apparent semantics of the code).

## Further Reading

I've only given a high-level overview of this project here, and a lot of the technical
details were glossed over. If you're hungry for more, check out the following resources:

- Notebooks and more extensive documentation on this project [are on
  GitHub](https://github.com/eigenfoo/random/tree/master/python/ast-hiding-yield). In
  particular, it might be helpful to peruse the [links and references at the end of the
  READMEs](https://github.com/eigenfoo/random/tree/master/python/ast-hiding-yield/00-prototype#links-and-references).
- For those looking to programmatically inspect/modify Python ASTs the same way I did
  here, you might find [this Twitter
  thread](https://twitter.com/remilouf/status/1213079103156424704) helpful.
- And for those wondering how PyMC4's model specification API ended up, some very smart
  people gave their feedback on this work [on
  Twitter](https://twitter.com/avibryant/status/1150827954319982592).

[^1]: Or should I say, complicating? At any rate, changing!

[^2]: I was [subsequently
convinced](https://twitter.com/avibryant/status/1150827954319982592) that this
isn't a leaky abstraction after all.

[^3]: I omitted the implementation of `parse_snippet` for brevity. If you want
to see it, check out the "AST Helper Functions" section of [this
notebook](https://github.com/eigenfoo/random/blob/master/python/ast-hiding-yield/00-prototype/hiding-yield.ipynb).

[^4]: For way more information on `exec`, `eval`, `locals` and `globals`, check
out [Armin Ronacher's blog
post](https://lucumr.pocoo.org/2011/2/1/exec-in-python/) and [this
StackOverflow
answer](https://stackoverflow.com/questions/2220699/whats-the-difference-between-eval-exec-and-compile).
