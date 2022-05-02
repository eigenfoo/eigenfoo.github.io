---
title: Pollen and Digital Publishing (a.k.a. _The Book is a Program_)
date: 2020-09-10
tags:
  - typography
---

I've picked up a new hobby (or perhaps just another fleeting fascination) ---
digital publishing. The catalyst was the book [_Practical Typography_ by
Matthew Butterick](https://practicaltypography.com/). There were so many
interesting things about it: it is gorgeous, it expounds well-argued (if
slightly controversial) views on how the average writer should think about
typography, it has a little widget that would change the book's typeface to
showcase Buttericks' fonts for sale, it is published online but --- and
Butterick makes a big point of this --- is not free.

Most interesting to me, however, was how the book was written and published
with a tool written specifically for the book ---
[Pollen](https://docs.racket-lang.org/pollen/). A good explanatory analogy (at
least for those in the data science and engineering world) is that it’s like R
Markdown (in that it’s a markup language that allows arbitrary R code to be
embedded in it), but instead of R, it’s Racket, and instead of Markdown, it’s
your own domain-specific markup language that you build with Racket.

After playing around with Pollen for a bit, I think I'm sold. Two big reasons:

1. Write your own markup
   * You can write your own "HTML tags" --- so for example, if you're writing a
     technical document and want to emphasize certain jargon upon first
     mention, you can write a `firstmention` tag, and have it italicize the
     tagged text and append it to a glossary with a link to its first mention
     in your document. The cool thing is that tags are just functions in
     Racket, which allow you to transform the input text arbitrarily.
   * As you can imagine, the ability to write your own markup really lets you
     tailor it to the content at hand.
2. Multi-format publishing
   * This lets you write in one input format, and output to multiple formats -
     so once I make changes to the source files, I can immediately have an
     HTML, LaTeX, PDF, and plain text format of my writing.

_But what about Markdown or LaTeX or ReStructured Text or ---_ none of them
give you flexibility or extensibility that Pollen does. In the case of Markdown
or ReStructured Text, you just get a subset of HTML features in a way that
looks more palatable to the average developer. If this suffices for your
publishing needs, that's great - but if it doesn't, you're left in a tough
place. LaTeX - as Butterick readily admits - did a lot of things right, but at
the end of the day it's just another format that Pollen can target. (I think
Pollen was named in the spirit of LaTeX by the way - in the sense that people
are commonly allergic to both of them.)

Now here's the "downside" - Pollen is written in
[Racket](https://racket-lang.org) (which is a dialect of Lisp), and any
non-trivial applications will probably involve you learning a bit of Racket.
I'd say that that's a good thing, if nothing else than for some self-education.

Here's a very simple example to convince you (if you want a longer form answer,
I'd recommend Butterick's [_Why Racket? Why
Lisp?_](https://beautifulracket.com/appendix/why-racket-why-lisp.html))

Most languages represent HTML as a string (which conceals the semantics of HTML
tags), or as a tree (which conceals the sequential nature of the HTML). Neither
option is great. Lisps, however, could represent a snippet of HTML as follows:

```bash
'(span ((class "author")(id "primary")(living "true")) "Prof. Leonard")
```

Keeping in mind that `(f x y)` is Lisp's way of saying `f(x, y)` and we see
that Lisps cleanly model HTML as _nested function application_, which really
blows open the door to opportunities in marking up your text.

At any rate, that's probably enough said about Pollen. Let me show you what I
managed to put together with it in one or two spare weekends ---
[`cooper.georgeho.org`](https://cooper.georgeho.org/). I was hunting around for
dummy text that I could use to play around with --- Lorem Ipsum seemed trite,
and the U.S. Constitution seemed overdone, so I reached for some historical
documents of my alma mater. Hope you like it!
