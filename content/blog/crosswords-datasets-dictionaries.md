---
title: Datasets and Dictionaries for Crosswords
date: 2022-07-30
tags:
  - crossword
  - dataset
  - natural-language-processing
---

Lately, I've become worryingly knowledgeable in datasets for crosswords... so
I've written up basically everything I know that might be helpful to crossword
constructors (and makers of other word puzzles, too). However, in writing this,
I realized that this may be helpful to just about anybody who works with words
--- lyricists, poets, marketers, scholars, etc. Hopefully there's something for
everybody! So without further ado,

## Dictionaries

I'll assume you know what a dictionary is --- if you're reading this you may
even have a _favorite_ dictionary (or a favorite dictionary _edition!_),
whether it's [Chambers](https://chambers.co.uk),
[Merriam-Webster](https://www.merriam-webster.com) or [Google
Dictionary](https://en.wikipedia.org/wiki/Google_Dictionary) (which, [fun
fact](https://support.google.com/websearch/answer/10106608), is mostly sourced
from [Oxford Languages](https://languages.oup.com/google-dictionary-en/)).

More interesting are dictionaries that allow you to search or query them in
more sophisticated ways: the most popular are [OneLook](https://onelook.com)
and [OneLook Thesaurus](https://www.onelook.com/thesaurus), where a user can,
for example, search `bl????rd` to find words that start with _bl_, end with
_rd_, and have four letters in between --- so `bluebird` would be a result.

The main asset with these dictionaries is the *expressiveness* of the query
language, and in that regard [Qat](https://www.quinapalus.com/qat.html) (which
is also available in French) handily beats OneLook: it can match vowels and
consonants (`bl@@#@rd`) and ranges of letters and lengths (`8-10:bl*rd`).  Qat
is also able to solve "word equations" (e.g.
[`ABCDE=.....;!=A<B<C<D<E`](https://www.quinapalus.com/cgi-bin/qat?pat=ABCDE%3D.....%3B!%3DA%3CB%3CC%3CD%3CE)
finds five-letter words whose letters are in strictly alphabetical order, such
as `abhor` and `first`), and even _simultaneous_ word equations (e.g.
[`ACB;ADB;AEB;|ACB|=5;|E|=1;!=C<D<E`](https://www.quinapalus.com/cgi-bin/qat?pat=ACB%3BADB%3BAEB%3B|ACB|%3D5%3B|E|%3D1%3B!%3DC%3CD%3CE)
finds sets of three five-letter words that are all one letter apart, such as
`beats, boats, brats` --- useful for finding crossing words!).

## Augmented Dictionaries

Many tools supplement dictionaries with other data, such as etymology,
pronunciation or sets of related words. You might think that your favorite
dictionary would already give you all of those things, but the strength here is
in the ability to easily write very sophisticated queries, such as [_"what
comprises a car that starts with the letter
T?"_](https://api.datamuse.com/words?rel_com=car&sp=t*), to give you phrases
like `trunk, throttle, tailfin, third gear`.

- The [Online Etymology Dictionary](https://www.etymonline.com/) looks up word
  etymologies, which is helpful for avoiding *"shared roots"* in cryptic
  crosswords.
- The [Carnegie Mellon University Pronouncing
  Dictionary](http://www.speech.cs.cmu.edu/cgi-bin/cmudict) looks up word
  pronunciations, splitting words up into phonemes. This may seem silly
  _("can't you just Google to learn the pronounciation of words?"),_ but with a
  bit of work, this dataset lets you look up homophones and Spoonerisms, as
  some crossword construction software --- such as [Exet](https://exet.app) --- do!
- [RhymeZone](https://rhymezone.com/) and its Spanish cousin
  [Rimar.io](https://rimar.io/) let you look up homophones, rhymes or near
  rhymes (RhymeZone actually uses the CMU Pronouncing Dictionary, among other
  datasets!)
- [Spruce](https://onelook.com/spruce/) looks up "inspiring sentences" ---
  quotes, lyrics, proverbs and jokes, which are indexed from
  [WikiQuote](https://en.wikiquote.org/wiki/Main_Page) and [Common
  Crawl](https://commoncrawl.org/).
- [Nutrimatic](https://nutrimatic.org/) looks up words or phrases mined from
  Wikipedia. This allows you to, for example, find anagrams that form
  natural-sounding phrases (e.g. `<dictionaries>` finds anagrams like `is a
  direction` or `i consider it a`, instead of anagrams that technically work
  but are not natural-sounding, such as `ratio incised` or `tonic dairies`).
- The [Datamuse API](https://www.datamuse.com/api/) is a very expressive search
  engine that sits on top of OneLook and RhymeZone. Unfortunately, there isn't
  a user-friendly frontend, so it's effectively restricted to people who are
  able to make use of programmatic access.

Here, another shoutout goes to [OneLook
Thesaurus](https://www.onelook.com/thesaurus/) and
[Qat](https://www.quinapalus.com/qat.html), which use several datasets (such as
the [Princeton WordNet](https://wordnet.princeton.edu/) and Wikipedia category
lists) to search words based on their meaning. For example, in OneLook,
`process by which plants eat` gives you `photosynthesis` as the top result; in
Qat, `{hypo:color}` gives you words that mean "color", such as `acrylic apricot
blacken blueing`; also in Qat, `{hyper:agate}` gives you words that "agate"
means, such as `entity matter quartz`. These searches make it easy to find
synonyms, hypernyms, hyponyms and other related words.

## Curated Dictionaries

In the other direction are datasets that don't *augment* dictionaries, but
rather *curate* them: their usefulness comes not just in what you *can* find in
them, but equally in what you *can't*.

The most prevalent examples are wordlists and their cousins, seedlists. As far
as I can tell, these are more useful for American-style crosswords, where there
is a hard requirement for fully interlocking grids (and grid-filling
consequently is a more difficult and computer-assisted task).

Wordlists tend to be personalized by puzzle constructors, and you can find some
wordlists for sale, most notably [Jeff Chen's Personal
List](https://www.xwordinfo.com/WordList). There are also several
freely-accessible ones such as [spread the
word(list)](https://www.spreadthewordlist.com/), [The Collaborative Word
List](https://github.com/Crossword-Nexus/collaborative-word-list), and [Peter
Broda's wordlist](https://peterbroda.me/crosswords/wordlist/).

Other examples of curated dictionaries would just be lists of specific things.
One amazing example is the [Expanded Crossword Name
Database](https://sites.google.com/view/expandedcrosswordnamedatabase/home),
which contains the names of notable women and non-binary people, with an eye to
increasing their representation in crosswords. Aside from that, I've found
Wikipedia's "listicles" to be very helpful (e.g. here's a list of [notable
Native Americans of the United
States](https://en.wikipedia.org/wiki/List_of_Native_Americans_of_the_United_States)).

## Datasets of Crosswords

Finally, let's not neglect the most obvious thing: literal datasets of
crosswords! These datasets are are significant works of crossword archivism,
since acquiring crosswords in bulk and structuring their contents requires
effort and cleaning that few are willing to do for such trivial data. (Fun
fact: according to [this 2004 selection
guide](https://cryptics.georgeho.org/static/documents/Selection_AppendixE_v2.pdf),
the Library of Congress explicitly does not collect crossword puzzles,
suggesting that they're too trivial for the national library!)

- [XWord Info](https://www.xwordinfo.com/) is probably the dataset with largest
  following, as it covers the *The New York Times'* crossword and is actively
  maintained.
- Among constructors of American-style crosswords, [Matt Ginsberg's clue
  dataset](https://tiwwdty.com/clue/) is the go-to dataset (since it's free and
  accessible to download), but it's unfortunately no longer actively
  maintained.
- [`xd.saul.pw`](https://xd.saul.pw/) is an excellent dataset of American-style
  crossword and clues from various publications that is also free and
  accessible to download.
- The [Cruciverb database](https://www.cruciverb.com/data.php) is also a
  dataset of American-style crossword and clues, but unfortunately requires a
  membership to access.
- Finally, to plug my own dataset,
  [`cryptics.georgeho.org`](https://cryptics.georgeho.org/) is a dataset of
  cryptic clues, with auxiliary datasets of cryptic indicators and charades.
