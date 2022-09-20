---
title: Merriam-Webster and Unstructured Data Processing
date: 2022-09-18
tags:
  - dataset
comments:
  - Hello!
---

I recently finished reading [_Word by Word: The Secret Life of Dictionaries_ by
Kory
Stamper](https://bookshop.org/books/word-by-word-the-secret-life-of-dictionaries/9781101970263),
which was an unexpected page-turner. What intrigued me most was (perhaps
unsurprisingly) Stamper's description of how Merriam-Webster gets written, and
what a striking resemblance that process has to many successful unstructured
data projects in the wild. I want to use this blog post to ruminate on this.

---

**First** it begins with collection and curation of raw, unstructured data.
Stamper describes a fascinating process called _"reading and marking"_, whereby
editors are assigned reading of current magazines, periodicals, blogs ---
almost anything written in English, it seems --- and read and underline any
words that catch their eye: new words, or words that get used in new ways.
(This is, contrary to first impressions, a non-trivial task for which requires
training: good readers-and-markers will pick up on the recent trend of _"bored
of"_, instead of the more historically common _"bored with"_ --- this doesn't
imply that _bored_ is picking up a new meaning, but rather that _of_ is...
which as you can imagine, can get lexicographers very excited.)

Stamper also describes the use of corpora, which are basically large structured
datasets of English being used in the wild --- a dataset of tweets, say, or
transcripts of popular TV shows. As data gets increasingly commoditized, data
projects will increasingly have the luxury of starting with structured data (or
at least, supplementing their raw unstructured data with structured data).

**Second** is the actual structuring of the data. This entails a small army of
editors dividing the entire dictionary amongst themselves, and defining (or
revising definitions of) each word by hand. In practice, that means opening up
the database of read-and-marked words (and maybe also the structured corpora),
seeing if the current definition needs to be revised to accommodate new senses
or usage of the word, and potentially writing or rewriting a definition for new
words... all in the span of maybe 15 minutes per word, on average.

This seems to be the most labor-intensive step in the "Merriam-Webster data
pipeline", but of course is also the one that adds the most value. There's no
reason to think that this phase (or any of these three phases, really!) needs
to be technologically sophisticated --- the dictionary-maker still makes use of
index cards and filing cabinets today. Lucrative products [being underpinned by
vast amounts of manual human labor is unfortunately nothing
new](https://vicki.substack.com/p/neural-nets-are-just-people-all-the), but
it's good to be reminded of it. The fact that product value and technological
sophistication are unrelated is underappreciated: you don't unlock more value
from your data by writing better code or training better machine learning
models.

**Finally** comes any ancillary features or datasets that Merriam-Webster
offers on top of their existing data (a.k.a. the dictionary), simply because
they are best positioned to deliver them. Think of things like etymology,
pronunciations and dates[^1].

[^1]: I was surprised to learn that words with multiple definitions are defined
  in chronological order of first usage, and not, as I imagined, some kind of
  "importance" of definitions.

It can seem funny that a dataset's true value to users (or, if you like, the
dataset's "product-market fit") might come from one of these subsidiary
datasets or features, instead of "the real thing". This makes sense though:
just as companies pivot products and business models to stay relevant, so too
can unstructured datasets --- after all, it's not a huge stretch to think of
unstructured datasets as products in their own right.

---

So here we have a recipe for a successful data project:

1. Collect and curate raw, unstructured data,
2. Structure it (ideally also adding some value to the data in the process, but
   structuring the data is value enough), and
3. Offer subsidiary datasets that you are best positioned to offer

What other data projects have followed this recipe?

1. **Google Search**: Google [crawled the
   internet](https://developers.google.com/search/docs/advanced/crawling/googlebot),
   and continues to do so on an ongoing basis; they invented
   [PageRank](https://en.wikipedia.org/wiki/PageRank) and other methods
   algorithms to make searching (a weak form of "structuring", I suppose) the
   internet possible; and their question-answering and
   [carousels](https://developers.google.com/search/docs/advanced/structured-data/carousel)
   are good examples of ancillary features on top of their core offering.

2. **[`cryptics.georgeho.org`](https://cryptics.georgeho.org/)**: my [dataset
   of cryptic crossword clues](/cryptic-clues/) started by indexing several
   blogs for cryptic crosswords; I then wrote a ton of `BeautifulSoup` to parse
   structured clue information out of the blog post HTML; finally, I ran some
   simple searches and regular expressions to produce more valuable resources
   for constructors of cryptic crosswords.

I wouldn't be convinced that this is the _only_ way for data projects succeed,
but it does seem like a helpful pattern to keep in mind!
