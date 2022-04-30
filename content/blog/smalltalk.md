---
title: Best Practice Patterns in Smalltalk
date: 2020-04-09
tags:
  - typography
---

- [Book Preview (Amazon)](https://read.amazon.com/kp/embed?asin=B00BBDLIME)

At [Avi Bryant's
recommendation](https://twitter.com/avibryant/status/1231677904943058944), I
decided to pick up _Smalltalk: Best Practice Patterns_ by Kent Beck. I
initially was pretty skeptical of the book: it sounded like a book on Smalltalk
--- not exactly something I know much about (in either sense of the word :P).
But people seemed to be giving it rave reviews on Twitter (just click around
the replies on Avi's quoted tweet!), so I decided to give it a shot.

First, let's talk about Smalltalk. Smalltalk is an _extremely_ influential
language with a [storied
history](https://hackernoon.com/back-to-the-future-with-smalltalk-57c68fab583a).
It was the progenitor of so many ideas that we now take for granted. IDEs.
Test-driven development. The
[model-view-controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)
architecture pattern. Language virtual machines. JIT compilation. I can't
possibly do its legacy justice here, so I'll just focus on one thing.

Smalltalk was the first _purely objected oriented_ language: the phrase
"everything is an object" started with Smalltalk. Objects can have _methods_,
and communicate to each other via _messages_. This fastidiousness makes it
difficult to translate the book's lessons into Python: most popular languages
today aren't as strict as Smalltalk (i.e.  not everything has to be
encapsulated in a object), so I mentally substituted "message" with "function",
and most of the best practice patterns still seemed to make a lot of sense.
However, I'm not totally sure that this is the best way to translate it.
Smalltalkers please chime in!

Despite what the book's title might suggest, I would say that this book is
about _best practice patterns_ --- design decisions that are made repeatedly by
experienced developers and are generally (but not universally!) helpful ---
that happen to be _illustrated_ in Smalltalk. In other words, the most
important lessons of the book are language-agnostic.

At first, I was actually a bit underwhelmed by this book, since it seemed to be
explaining a lot of patterns that I already seemed to know, and I was hoping to
learn more patterns: perhaps my code sucked because I was just shooting myself
in the foot by structuring it wrong!

Instead, the book focussed on a lot of patterns that I had already seen in
various Python libraries/APIs. It devoted a lot of time to explaining what
problems these patterns solved, what kind of trade-offs they made, and when not
to use these patterns.  It forced me to think critically about the patterns I
had already seen (instead of teaching me new patterns) and convinced me to
double down on following these best practices patterns in my code.

Here are some best practice patterns that I found interesting and
well-explained:

1. The pattern of **using classes as functions**.

   > How do you code a method where many lines of code share many arguments
   > and temporary variables?
   >
   > _Create a class named after the method. Give it an instance variable for
   > [...] each argument and each temporary variable [...] Give it once instance
   > method, `compute`, implemented by copying the body of the original method.
   > Replace the method with one which creates an instance of the new class and
   > sends it `compute`._

   This practice pattern immediately reminded me of `scikit-learn`'s API,
   which exposes machine learning algorithms as classes with a `.fit()` and
   `.predict()` methods. This design made sense to me (there is generally some
   state that needs to be saved after training, and a class is the right way
   to encapsulate that state), but struck me as a bit unsettling. Most classes
   are nouns, and it feels weird to have a class that is a verb. However, Beck
   emphasized that the organization and clarity are worth the strange nature
   of these objects.

2. The idea that **the behavior of programs is more important to get right than
   its state or representation**.

   This is best explained with a quote from the book:

   > Objects model the world through behavior and state. Behavior is the
   > dynamic, active, computational part of the model. State is what is left
   > after behavior is done, how the model is represented before, after and
   > during a computation.
   >
   > Of the two, behavior is the more important to get right. The primacy of
   > behavior is one of the odd truths of objects; odd because it flies in the
   > face of so much accumulated experience. Back in the bad old days, you
   > wanted to get the representation right as quickly as possible because
   > every change to the representation bred changes in many different
   > computations.
   >
   > Objects (done right) change all that. No longer is your system a slave of
   > its representation. Because objects can hide their representation behind
   > a wall of messages, you are free to change representation and only affect
   > one object.

   I've anecdotally found this to be true in my own writing, but I only have a
   fairly half-baked reason why this should be true in general. For one, state
   is the _permanent_ part of your program and so is much harder to change: it
   persists between script executions, program invocations, and function
   calls. Secondly, it is incredibly easy to code in implicit assumptions
   about state into other parts of the program: when the state representation
   changes, all these assumptions must then be weeded out of your code and
   modified appropriately.

   The meatiest example I can give is the one below, so let's move along!

3. The pattern of **refining protocols between two programs**.

   > How do you code the interaction between two objects that need to remain
   > independent?
   >
   > Refine the protocol between the objects so the words used are consistent.

   I actually talked about this best practice pattern in my [last
   newsletter](https://buttondown.email/eigenfoo/archive/tfp-joint-dists/),
   where I discussed the design of TFP. The somewhat more concrete problem is
   this: if program A constructs some object that program B consumes, then it
   is crucially important to get the representation of that object kosher. Any
   changes to that object will require significant (and probably painful!)
   changes to both programs A and B.

   The best practice pattern here is to refine the protocol between the two
   programs and specify a contract for these intermediate objects: all objects
   must have such and such properties, so that programs A and B can do whatever
   they want, so long as they fulfill the contract. This was exactly the
   situation with specifying and constructing joint distributions before
   passing them off to inference algorithms: by refining and specifying a
   contract for `tfp.JointDistribution`s, the TFP team was able to maintain the
   independence of the model specification programs and the inference
   algorithms.
