---
title: Thoughts on Hanukkah of Data 2022
date: 2022-12-26
tags:
  - data
  - visidata
---

> This blog post contains spoilers for Hanukkah of Data 2022.

This holiday season I've been doing the [Hanukkah of
Data](https://hanukkah.bluebird.sh/), which is a puzzle suite by a group of
hackers called [the Devottys](https://bluebird.sh/). It's a sequence of
programming puzzles, with one puzzle dropping for every day of Hanukkah. If
you're familiar with [Advent of Code](https://adventofcode.com/), it's very
similar to that, except (a) it only lasts 8 days instead of 25, and (b) it's
more data-oriented, instead of coding or algorithms-oriented.

I did it in [VisiData](https://www.visidata.org/), which is a tool I've been
using a lot recently (both at work and for my side projects) that I really
wanted to develop expert proficiency with.

Here were my solve statistics:

```text
 Puzzle | Solve Time | # Attempts ║
      0 |  3 minutes |          2 ║
      1 | 82 minutes |          2 ║
      2 | 20 minutes |          1 ║
      3 | 20 minutes |          5 ║
      4 | 37 minutes |          1 ║
      5 |  7 minutes |          1 ║
      6 |  6 minutes |          1 ║
      7 | 24 minutes |          1 ║
      8 |  5 minutes |          1 ║
```

## Overall Impressions

**Hanukkah of Data is much shorter than Advent of Code**, which I think is a
hugely underrated benefit --- in previous years, Advent of Code sometimes felt
more like homework than a puzzle suite.

It's also **more of a puzzle than Advent of Code** --- for example, Puzzle 2
required very non-trivial reading comprehension and logical inference to
realize that you were looking for (a) a customer with the initials JD (b) who
had, in the same order, bought coffee and bagels at Noah's market (c) in 2017.
I found this much more enjoyable than Advent of Code, where the solution is
usually straightforward, and the implementation is the meat of the challenge.

On VisiData: for those comfortable with command line interfaces, Vim-style key
bindings, or simply willing to put in the time to learn a mini-language of
keyboard shortcuts, I think **VisiData is the best tool for doing well-scoped,
one-off data explorations or analyses.**

Towards the end of Hanukkah, the puzzles became less conceptually ambiguous and
more technically difficult (in terms of the sophistication of the data
wrangling required). As someone already experienced with querying data, I was
pleased to finish these puzzles in single-digit minutes --- an achievement that
I credit almost entirely to VisiData, which makes visualizing, filtering and
aggregating data seamlessly interactive.

I only see two downsides of VisiData: the sparse documentation of advanced
features (more on that below) and performance. Performance is most obviously an
issue when you're doing joins --- joining two tables with a few thousand rows
each takes a noticeably long time. I'm looking forward to
[`vdsql`](https://github.com/visidata/vdsql), which is VisiData's sibling
project that skins various databases with a VisiData interface (via
[Ibis](https://ibis-project.org/)), and should therefore be as performant as
the underlying database.

## Some Miscellaneous Thoughts

- Puzzle 1 required a non-trivial function (basically a "phonespell" to convert
  words to numbers, as if you were dialling on a phone). I struggled a lot with
  making this custom function available to me in VisiData --- I spent around an
  hour figuring out how to make [a custom
  plugin](https://www.visidata.org/docs/plugins/) (this is what really blew up
  my solve time on the first day). I later learnt that adding a Python function
  to your `.visidatarc` is a much simpler way to achieve the same thing.

  While I think the basics of VisiData are [exceptionally well
  documented](https://jsvine.github.io/intro-to-visidata/), the advanced
  features are not --- I still don't really understand how to extend VisiData
  with its API. Nevertheless, this won't be an issue for most users, since 90%
  of VisiData's value is in its interactivity and interoperability, not in its
  extensibility.

- For me, the most challenging puzzle was Puzzle 4, which asked to find someone
  who buys pastries. When you have a dataset with over a thousand products, how
  do find all the pastries?

  ```txt
  sku     | desc                                    | wholesale_cost ║
  DLI0002 | Smoked Whitefish Sandwich               |           9.33 ║
  PET0005 | Vegan Cat Food, Turkey & Chicken        |           4.35 ║
  HOM0018 | Power Radio (red)                       |          21.81 ║
  KIT0034 | Azure Ladle                             |           2.81 ║
  PET0041 | Gluten-free Cat Food, Pumpkin & Pumpkin |           4.60 ║
  ```

  What I ended up doing was to split out the "suffix" of each product
  `desc`ription (with some special handling for parenthetical modifiers), like
  so:

  ```txt
  sku     | desc                                    | descsuffix | wholesale_cost ║
  DLI0002 | Smoked Whitefish Sandwich               | Sandwich   |           9.33 ║
  PET0005 | Vegan Cat Food, Turkey & Chicken        | Chicken    |           4.35 ║
  HOM0018 | Power Radio (red)                       | Radio      |          21.81 ║
  KIT0034 | Azure Ladle                             | Ladle      |           2.81 ║
  PET0041 | Gluten-free Cat Food, Pumpkin & Pumpkin | Pumpkin    |           4.60 ║
  ```

  This number of _kinds_ of products is drastically fewer than the number of
  products, to the point where it's feasible to look through them all manually
  and pick out the pastries.

  This obviously won't work in general: for example, `Vegan Cat Food, Turkey &
  Chicken` isn't a kind of `Chicken`, and you could imagine that this would
  really let you down for a product called `Rugelach, Raspberry` instead of
  `Raspberry Rugelach`. Still, I thought this was a neat trick, and I managed
  to eke out the correct solution.

  Later in the week I realized that all pastries had an `sku` that started with
  `BKY`, which would've helped considerably --- similarly, cat foods start with
  `PET` and collectibles start with `COL`. Sometimes it pays to actually read
  random-looking alphanumeric codes!

- I was surprised that the puzzles didn't seem to be monotonically increasing
  in difficulty --- as you'll see from my times, and as you might expect from
  Advent of Code. [Saul Pwanson](https://www.saul.pw/) (the creator of Hanukkah
  of Data) had this to say:

  > There is a ramp in difficulty, but it is not very steep, and for people who
  > are already familiar with data queries, it might feel like not much has
  > been added between puzzles. But if you look at each puzzle compared with
  > the previous one, there is always something new. Sometimes it's structural
  > (now you need to do a join), sometimes it's worldly (what is a pastry?),
  > and sometimes it's technical (it's surprisingly difficult in most tools to
  > filter based on a date range that doesn't include the year).

  It's a really good observation --- I suppose I shouldn't be surprised that
  Saul's thought about the puzzle design a lot more than I have! 😅

- The text art is just stunning! Each solved puzzle reveals a new animal, until
  the whole tapestry is illuminated:

  [![The whole tapestry for Hanukkah of Data
  2022](/assets/images/hanukkah-of-data.png)](/assets/images/hanukkah-of-data.png)
