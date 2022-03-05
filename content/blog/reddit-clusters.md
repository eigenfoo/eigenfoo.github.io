---
title: Understanding Hate Speech on Reddit through Text Clustering
date: 2018-03-18
tags:
  - machine-learning
  - natural-language-processing
---

> Note: the following article contains several examples of hate speech
> (including but not limited to racist, misogynistic and homophobic views).

Have you heard of `/r/TheRedPill`? It’s an online forum (a subreddit, but I’ll
explain that later) where people (usually men) espouse an ideology predicated
entirely on gender. “Swallowers of the red pill”, as they call themselves,
maintain that it is _men_, not women, who are socially marginalized; that feminism
is something between a damaging ideology and a symptom of societal retardation;
that the patriarchy should actively assert its dominance over female
compatriots.

Despite being shunned by the world (or perhaps, because of it), `/r/TheRedPill`
has grown into a sizable community and evolved its own slang, language and
culture. Let me give you an example.

```
Cluster #14:
Cluster importance: 0.0489376285127
shit: 2.433590
test: 1.069885
frame: 0.396684
pass: 0.204953
bitch: 0.163619
```

This is a snippet from a text clustering of `/r/TheRedPill` — you don’t really
need to understand the details right now: all you need to know is that each
cluster is simply a bunch of words that frequently appear together in Reddit
posts and comments. Following each word is a number indicating its importance in
the cluster, and on line 2 is the importance of this cluster to the subreddit
overall.

As it turns out, this cluster has picked up on a very specific meme on
`/r/TheRedPill`: the concept of the _shit test_, and how your frame can _pass_ the
_shit tests_ that life (but predominantly, _bitches_) can throw at you.

There’s absolutely no way I could explain this stuff better than the swallowers
of the red pill themselves, so I’ll just quote from a post on `/r/TheRedPill` and
a related blog.

The concept of the shit test very broad:

> … when somebody “gives you shit” and fucks around with your head to see how
> you will react, what you are experiencing is typically a (series of) shit
> test(s).

A shit test is designed to test your temperament, or more colloquially,
_“determine your frame”_.

> Frame is a concept which essentially means “composure and self-control”.
>
> … if you can keep composure/seem unfazed and/or assert your boundaries
> despite a shit test, generally speaking you will be considered to have passed
> the shit test. If you get upset, offended, doubt yourself or show weakness in
> any discernible way when shit tested, it will be generally considered that you
> failed the test.

Finally, not only do shit tests test your frame, but they also serve a specific,
critical social function:

> When it comes right down to it shit tests are typically women’s way of
> flirting.
>
> … Those who “pass” show they can handle the woman’s BS and is “on her
> level”, so to speak. This is where the evolutionary theory comes into play:
> you’re demonstrating her faux negativity doesn’t phase you [sic] and that
> you’re an emotionally developed person who isn’t going to melt down at the
> first sign of trouble. Ergo you’ll be able to protect her when threats to
> her safety emerge.

If you want to learn more, I took all the above quotes from
[here](https://www.reddit.com/r/TheRedPill/comments/22qnmk/newbies_read_this_the_definitive_guide_to_shit/)
and [here](https://illimitablemen.com/2014/12/14/the-shit-test-encyclopedia/):
feel free to toss yourself down that rabbit hole (but you may want to open those
links in Incognito mode).

Clearly though, the cluster did a good job of identifying one topic of
discussion on `/r/TheRedPill`. In fact, not only can clustering pick up on a
general topic of conversation, but also on specific memes, motifs and vocabulary
associated with it.

Interested? Read on! I’ll explain what I did, and describe some of my other
results.

---

Reddit is — well, it’s pretty hard to describe what Reddit _is_, mainly because
Reddit comprises several thousand communities, called _subreddits_, which center
around topics broad (`/r/Sports`) and niche (`/r/thinkpad`), delightful
(`/r/aww`) and unsavory (`/r/Incels`).

Each subreddit is a unique community with its own rules, culture and standards.
Some are welcoming and inclusive, and anyone can post and comment; others, not
so much: you must be invited to even read their front page. Some have pliant
standards about what is acceptable as a post; others have moderators willing to
remove posts and ban users upon any infraction of community guidelines.

Whatever Reddit is though, two things are for certain:

1. It’s widely used. _Very_ widely used. At the time of writing, it’s the [fourth
   most popular website in the United
   States](https://www.alexa.com/topsites/countries/US) and the [sixth most popular
   globally](https://www.alexa.com/topsites).

1. Where there is free speech, there is hate speech. Reddit’s hate speech
   problem is [well
   documented](https://www.wired.com/2015/08/reddit-mods-handle-hate-speech/),
   the [center of recent
   controversy](https://www.inverse.com/article/43611-reddit-ceo-steve-huffman-hate-speech),
   and even [the subject of statistical
   analysis](https://fivethirtyeight.com/features/dissecting-trumps-most-rabid-online-following/).

Now, there are many well-known hateful subreddits. The three that I decided to
focus on were `/r/TheRedPill`, `/r/The_Donald`, and`/r/CringeAnarchy`.

The goal here is to understand what these subreddits are like, and expose their
culture for people to see. To quote [Steve Huffman, Reddit’s
CEO](https://www.inverse.com/article/43611-reddit-ceo-steve-huffman-hate-speech):

> “I believe the best defense against racism and other repugnant views, both
> on Reddit and in the world, is instead of trying to control what people
> can and cannot say through rules, is to repudiate these views in a free
> conversation, and empower our communities to do so on Reddit.”

And there’s no way we can refute and repudiate these deplorable views without
knowing what those views are. And instead of spending hours of each of these
subreddits ourselves, let’s have a machine learn what gets talked about on these
subreddits.

---

Now, how do we do this? This can be done using _clustering_, a machine learning
technique in which we’re given data points, and tasked with grouping them in
some way. A picture will explain better than words:

<figure>
  <a href="/assets/images/clusters.png"><img src="/assets/images/clusters.png" alt="Illustration of clustering"></a>
  <figcaption>Clustering.</figcaption>
</figure>

The clustering algorithm was hard to decide on. After several dead ends were
explored, I settled on non-negative matrix factorization of the document-term
matrix, featurized using tf-idfs. I don’t really want to go into the technical
details now: suffice to say that this technique is [known to work well for this
application](http://scikit-learn.org/stable/auto_examples/applications/plot_topics_extraction_with_nmf_lda.html)
(perhaps I’ll write another piece on this in the future).

Finally, we need our data points: [Google
BigQuery](https://bigquery.cloud.google.com/dataset/fh-bigquery:reddit_comments)
has all posts and comments across all of Reddit, from the the beginning of
Reddit right up until the end of 2017. We decided to focus on the last two
months for which there is data: November and December, 2017.

I could talk at length about the technical details, but right now, I want to
focus on the results of the clustering. What follows are two hand-picked
clusters from each of the three subreddits, visualized as word clouds (you can
think of word clouds as visual representations of the code snippet above), as
well as an example comment from each of the clusters.

## `/r/TheRedPill`

You already know `/r/TheRedPill`, so let me describe the clusters in more detail:
a good number of them are about sex, or about how to approach girls. Comments in
these clusters tend to give advice on how to pick up girls, or describe the
social/sexual exploits of the commenter.

What is interesting is that, as sex-obsessed as `/r/TheRedPill` is, many
swallowers (of the red pill) profess that sex is _not_ the purpose of the
subreddit: the point is to becoming an “alpha male”. Even more interesting,
there is more talk about what an alpha male _is_, and what kind of people
_aren’t_ alpha, than there is about how people can _become_ alpha. This is the
first cluster shown below, and comprises around 3% of all text on
`/r/TheRedPill`.

The second cluster comprises around 6% of all text on `/r/TheRedPill`, and
contains comments that expound theories on the role of men, women and feminism
in today’s society (it isn’t pretty). Personally, the most repugnant views that
I’ve read are to be found in this cluster.

```
I feel like the over dramatization of beta qualities in media/pop culture is due
to the fact that anyone representing these qualities is already Alpha by
default.

The actors who play the white knight lead roles, the rock stars that sing about
pining for some chick… these men/characters are already very Alpha in both looks
and status, so when beta BS comes from their mouths, it’s seen as attractive
because it balances out their already alpha state into that "mostly alpha but
some beta" balance that makes women swoon.

…
```

<figure>
  <a href="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/TheRedPill/13_3.21%25.png"><img src="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/TheRedPill/13_3.21%25.png" alt="/r/TheRedPill cluster #13"></a>
  <a href="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/TheRedPill/06_6.41%25.png"><img src="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/TheRedPill/06_6.41%25.png" alt="/r/TheRedPill cluster #6"></a>
  <figcaption>Wordclouds from /r/TheRedPill.</figcaption>
</figure>

```
…

Since the dawn of humanity men were always in control, held all the power and
women were happy because of it. But now men are forced to lose their masculinity
and power or else they'll be killed/punished by other pussy men with big guns
and laws who believe feminism is the right path for humanity.

…

Feminism is really a blessing in disguise because it's a wake up call for men
and a hidden cry for help from women for men to regain their masculinity,
integrity and control over women.

…

```

## `/r/The_Donald`

You may have already heard of `/r/The_Donald` (a.k.a. the “pro-Trump cesspool”),
famed for their [takeover of the Reddit front
page](https://en.wikipedia.org/wiki//r/The_Donald#Conflict_with_Reddit_management),
and their [involvement in several recent
controversies](https://en.wikipedia.org/wiki//r/The_Donald#Controversies). It
may therefore be surprising to learn that there is an iota of lucid discussion
that goes on, although in a jeering, bullying tone.

`/r/The_Donald` is the subreddit which has developed the most language and inside
jokes: from “nimble navigators” to “swamp creatures”, “spezzes” to the
“Trumpire”… Explaining these memes would take too long: reach out, or Google, if
you really want to know.

The first cluster accounts for 5% of all text on `/r/The_Donald`, and contains
(relatively) coherent arguments both for and against net neutrality. The second
cluster accounts for 1% of the all text on `/r/The_Donald`, and is actually from
the subreddit’s `MAGABrickBot`, which is a bot that keeps count of how many times
the word “brick” has been used in comments, by automatically generating this
comment.

```
So much misinformation perpetuated by the Swamp... Abolishing Net Neutrality
would benefit swamp creatures with corporate payouts but would be most damaging
to conservatives long term.

Net Neutrality was NOT created by Obama, it was actually in effect from the very
beginning...
```

<figure>
  <a href="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/The_Donald/00_5.19%25.png"><img src="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/The_Donald/00_5.19%25.png" alt="/r/The_Donald cluster #0"></a>
  <a href="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/The_Donald/02_1.26%25.png"><img src="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/The_Donald/02_1.26%25.png" alt="/r/The_Donald cluster #2"></a>
  <figcaption>Wordclouds from /r/The_Donald.</figcaption>
</figure>

```
**FOR THE LOVE OF GOD GET THIS PATRIOT A BRICK! THAT'S 92278 BRICKS HANDED
OUT!**

We are at **14.3173880911%** of our goal to **BUILD THE WALL** starting from Imperial
Beach, CA to Brownsville, Texas! Lets make sure everyone gets a brick in the
United States! For every Centipede a brick, for every brick a Centipede!

At this rate, the wall will be **1071.35224786 MILES WIDE** and **353.552300867 FEET
HIGH** by tomorrow! **DO YOUR PART!**
```

## `/r/CringeAnarchy`

On the Internet, _cringe_ is the second-hand embarrassment you feel when someone
acts extremely awkwardly or uncomfortably. And on `/r/CringeAnarchy` you can find
memes about the _real_ cringe, which is, um, liberals and anyone else who
advocates for an inclusionary, equitable ideology. Their morally grey jokes run
the gamut of delicate topics: gender, race, sexuality, nationality…

In some respects, the clustering provided very little insight into this
subreddit: each such delicate topic had one or two clusters, and there’s nothing
really remarkable about any of them. This speaks to the inherent difficulty of
training a topic model on memes: I rant at greater length about this topic on
[one of my blog posts](https://www.georgeho.org/lda-sucks/).

Both clusters below comprise around 3% of text on `/r/CringeAnarchy`: one is to do
with race, and the other is to do with homosexuality.

```
Has anyone here, non-black or otherwise, ever wished someone felt sorry for
being black? Maybe it's just where I live... the majority is black. It's
whatever.
```

<figure>
  <a href="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/CringeAnarchy/08_3.10%25.png"><img src="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/CringeAnarchy/08_3.10%25.png" alt="/r/CringeAnarchy cluster #8"></a>
  <a href="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/CringeAnarchy/12_2.92%25.png"><img src="https://raw.githubusercontent.com/eigenfoo/reddit-clusters/master/wordclouds/images/CringeAnarchy/12_2.92%25.png" alt="/r/CringeAnarchy cluster #8"></a>
  <figcaption>Wordclouds from /r/CringeAnarchy.</figcaption>
</figure>

```
…

Also, the distinction between bisexual and gay is academic. If you do a gay
thing, you have done a gay thing. That's what "being gay" means to a LOT of
people. Redefining it is as useful as all the other things SJWs are redefining.
```

---

As much information as that might have been, this was just a glimpse into what
these subreddits are like: I made 20 clusters for each subreddit, and you could
argue that (for somewhat technical reasons) 20 clusters isn’t even enough!
Moreover, there is just no way I could distill everything I learned about these
communities into one Medium story: I’ve curated just the more remarkable or
provocative results to put here.

If you still have the stomach for this stuff, scroll through the complete log
files
[here](https://github.com/eigenfoo/reddit-clusters/tree/master/clustering/nmf/results),
or look through images of the word clouds
[here](https://github.com/eigenfoo/reddit-clusters/tree/master/wordclouds/images).

Finally, as has been said before, “Talk is cheap. Show me the code.” For
everything I’ve written to make these clusters, check out [this GitHub
repository](https://github.com/eigenfoo/reddit-clusters).

---

**Update (11-08-2018):** If you're interested in the technical, data science side
of the project, check out the slide deck and speaker notes from [my recent
talk](https://www.georgeho.org/reddit-slides/) on exactly that!

---

_This post was originally published on Medium on May 18, 2018: I have since
[migrated away from
Medium](https://medium.com/@nikitonsky/medium-is-a-poor-choice-for-blogging-bb0048d19133)
and [deleted my account](https://bts.nomadgate.com/medium-evergreen-content) and
[all my stories](https://www.joshjahans.com/ditching-medium/)._

_This post was also reprinted in the inaugural issue of The Cooper Union's
[UNION Journal](https://www.facebook.com/theunionjournal/)._
