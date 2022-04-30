---
title: Thoughts on _Working in Public_
date: 2020-08-13
tags:
  - open-source
---

[_Working in Public: The Making and Maintenance of Open Source Sofware_ by
Nadia Eghbal](https://www.amazon.com/dp/0578675862/) was a delight to read. I
had initially come across Eghbal's work through her [research report for the
Ford
Foundation](https://www.fordfoundation.org/work/learning/research-reports/roads-and-bridges-the-unseen-labor-behind-our-digital-infrastructure/),
but that piece seemed to be more geared towards raising awareness of open
source in boardrooms, whereas her latest book was a much more nuanced
discussion of open source.

The first half was basically describing the open source software, how it works,
and how it's maintained (with a healthy focus on GitHub). Despite being an open
source contributor for a while, I was surprised at some particularly lucid
thoughts here. Here are just two of them:

1. This table classifying the "kinds" of open source projects:

    |                         | High User Growth        | Low User Growth      |
    |-------------------------|-------------------------|----------------------|
    | High Contributor Growth | Federations (e.g. Rust) | Clubs (e.g. Astropy) |
    | Low Contributor Growth  | Stadiums (e.g. Babel)   | Toys (e.g. ssh-chat) |

2. The idea of there being _two_ economic goods in open source: the code itself
   (which is what is consumed), and developer attention (which is how the code
   is produced), the first of which is a positive externality of the latter.
   These two goods have _very_ different properties: the open source code is a
   public good, whereas developer attention is a commons (of _tragedy of the
   commons_ fame).

The second half of the book was much more enlightening to me: having discussed
why open source software gets created ("for fun and street cred" is basically
the short answer), Eghbal delves into how it is maintained - including thorny
topics like developer chemistry, governance structure, funding sources... all
issues that I feel the open source community is getting a better and better
grip on.

Now, what struck me was an interesting disconnect between the first and second
halves of the book.

The problems of _making_ open source seem to be not so grievous: Eghbal even
acknowledges this, citing developer's "intrinsic motivation", and pointing to
several examples of developers making open-source software just for fun. These
problems are generally solved because of the nature of open source software
itself.

However, the problems of _maintaining_ open source seem startlingly similar to
those of almost any other kind of public good on the internet information
economy: I'm thinking of things like Wikipedia, Sci-Hub, Hacker News --- any
website or app that satisfies (2) above (e.g. in the case of Sci-Hub the
academic articles are offered to anyone for free, but the entire project is
held together by the PHP skills of [one Kazakh
woman](https://sci-hub.tw/alexandra)).

I think Eghbal realizes that these problems aren't specific to just open
source, but rather are endemic to the internet information economy --- she
concludes the book by meditating on the similarities of open source software
and online content more generally. Food for thought!
