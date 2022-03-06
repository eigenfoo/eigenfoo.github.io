---
title: Migrating to Hugo
date: 2022-03-05
tags:
  - typography
---

<center><img src="/assets/images/blog-rewrite-meme.png"></center>

This weekend I migrated my blog to Hugo.

My website is now based on the [Hugo Bear Blog
theme](https://github.com/janraasch/hugo-bearblog/), generated with
[Hugo](https://gohugo.io/), hosted by [GitHub Pages](https://pages.github.com/)
and served with [Cloudflare](https://www.cloudflare.com/). I've also migrated
from the `eigenfoo.xyz` domain to the more creditable-sounding `georgeho.org`
(sadly, `georgeho.com` and `georgeho.net` were already taken). In terms of
typography, the header typeface is [Nicholson
Gothic](https://www.1001freefonts.com/nicholson-gothic.font), the body typeface
is [Equity](https://mbtype.com/fonts/equity/) and the monospaced typeface for
occasional code snippets is [Triplicate](https://mbtype.com/fonts/triplicate/).
In all, I probably spend the equivalent of two fancy lattes a year for this
setup.

## Why Hugo? Why Not Jekyll?

Honestly, no good reason! [Some people point
out](https://vickiboykis.com/2022/01/08/migrating-to-hugo/) that Jekyll is not
actively maintained or used anymore, and that GitHub Pages doesn't support
Jekyll 4.0. However, those aren't really good enough reasons for migrating a
blogging stack.

Here's a short list of things I like about Hugo over Jekyll --- but again, none
of these things really should have enticed me to make the jump.

- Ease of installation and use (Hugo is a binary executable instead of a Ruby
  library), and it was very easy to make changes to the theme (e.g. changing
  the font or [increasing the font
  size](https://practicaltypography.com/line-length.html)) --- although that
  could just be because [the theme that I'm
  using](https://github.com/janraasch/hugo-bearblog/) is dead simple.
- Automatic generation of a [sitemap](/sitemap.xml) and [RSS feed](/feed.xml)
  --- with Jekyll, these needed to be done manually (or by your theme).
- Typographical conveniences like automatic [smart
  quotes](https://practicaltypography.com/straight-and-curly-quotes.html),
  rendering `-`, `--` and `---` into [the appropriate hyphen or
  dash](https://practicaltypography.com/hyphens-and-dashes.html), and `...`
  into [an ellipsis](https://practicaltypography.com/ellipses.html).
- Faster builds of my website... although this isn't really that helpful for
  me, since my blog barely has a few dozen pages.

## The Migration

...was surprisingly painless! All I _really_ needed to do was to [pick out a
theme](https://themes.gohugo.io/), follow the [Hugo Quick
Start](https://gohugo.io/getting-started/quick-start/), dump my Markdown blog
posts into the `content/` directory and change some of the YAML front matter in
all of my blog posts.

In reality, I spent a few extra hours fiddling with the typography and making
sure that all my links were back-compatible with my previous website.

## Pollen

This is actually not the first time I tried to rewrite my website: earlier this
year I experimented with writing a
[Tufte-inspired](https://edwardtufte.github.io/tufte-css/) blog using
[Pollen](https://pollenpub.com). For those unfamiliar, it's like R Markdown (in
that it's a markup language that allows arbitrary R code to be embedded in it),
but instead of R, it's [Racket](https://racket-lang.org/), and instead of
Markdown, it's your own domain-specific markup language that you build with
Racket.

This means that I wrote a custom language specifically for formatting
Tufte-style two-column blog posts. It actually worked out pretty well (and the
resulting blog posts looked _damn good_), but I couldn't justify maintaining my
own language specifically for writing blog posts. I'd probably recommend using
Pollen for large, one-off pieces of writing (like a book), instead of small,
recurring pieces of writing (like a blog).
