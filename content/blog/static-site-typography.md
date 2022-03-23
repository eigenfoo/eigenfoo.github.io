---
title: How to Improve Your Static Site's Typography
date: 2022-03-21
tags:
  - typography
---

You've read that [web design is 95%
typography](https://ia.net/topics/the-web-is-all-about-typography-period). You
have a static website. You've wanted to improve its typography but have never
had the time or patience. You've might've even heard of Butterick's [_Practical
Typography_](https://practicaltypography.com/). If this sounds like you, you're
in luck!

A foreword: you can achieve almost everything I describe here by adding CSS in
a `<style>` tag at the end of your webpages'  `<head>`s, but the code snippets
I include here aren't meant to be copypasta solutions, but illustrative
examples.

{{< toc >}}

## Easy Wins

Body text --- the text that forms the main content of your website --- is the
most important part of your website. These three things largely determine how
your body text looks, and nailing them can immediately improve your website's
typography.

### Choose a font

Many static sites default to system fonts[^1]: that is, fonts that are likely
already installed on readers' devices. This putatively boosts performance
(because readers need not download font files), and can give a more comfortable
look, since it can blend in with the fonts of the reader's operating system.

However, many system fonts aren't good, and many others have become hackneyed
_precisely because they are default fonts_. It's also straightforward to use
custom webfonts or font hosting services like [Google
Fonts](https://fonts.google.com/).

Obviously you should do what you think is best for your website, but I'd point
out that **changing your body font is an easy and effective way to upgrade your
typography and distinguish your writing from the sea of sans-serif on the
Internet.** Live a little!

```css
/* Use your own static font file(s). 
   You should have a font face for regular, bold and italics. */
@font-face{
  font-family: "Fira Sans";
  src: url("/assets/fonts/FiraSansRegular.woff2") format("woff2");
  font-style: normal;
  font-weight: 400;
}

/* Fall back on system fonts. */
body { font-family: "Fira Sans", Verdana, sans-serif; }
```

```css
/* Alternatively, use a font hosting service like Google Fonts.
   Again, have a font face for regular, bold and italics. */
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fira+Sans&display=swap" rel="stylesheet"> 

/* Fall back on system fonts. */
body { font-family: "Fira Sans", Verdana, sans-serif; }
```

### Adjust the line width and point size

The ultimate goal is to control the _average number of characters per line:_
too many, and lines run on interminably; too few, and you force readers' eyes
to dart uncomfortably back and forth. **Aim to fit between two and three full
English alphabets per line.**

The twist is that this has to be done regardless of the screen size --- most
obviously, it has to work on both desktop and mobile screens. This leads to
concept of _fluid type_, which just means that the font size changes in reponse
to the screen width.

Try adjusting your window size (or rotating your phone) to see how the line
width and point size adjust to always fit between two and three alphabets in
the following paragraph:

abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz

CSS Tricks has an [excellent
tutorial](https://css-tricks.com/simplified-fluid-typography/) for fluid type
with CSS, which boils down to clever use of `min`, `max` and `vw`: the font
sizes goes between 16px on a 320px screen to 22px on a 1000px screen.

```css
body { max-width: 720px; }
html { font-size: min(max(16px, 4vw), 22px); }
```

### Adjust the line height

The goal is to control *how closely consecutive lines sit next to each other:*
too tightly and you get intimidating walls of text; too loosely and your text
becomes a vaporous jumble of lines. **Aim to space lines between 120% to 145%
of the point size.** (The text in this paragraph has a spacing of 145%. Just
right!)

<p style="line-height:1.1">
  The goal is to control <i>how closely consecutive lines sit next to each
  other:</i> too tightly and you get intimidating walls of text; too loosely
  and your text becomes a vaporous jumble of lines. <b>Aim to space lines
  between 120% to 145% of the point size.</b> (The text in this paragraph has a
  spacing of 110%. Too dense.)
</p>

<p style="line-height:1.6">
  The goal is to control <i>how closely consecutive lines sit next to each
  other:</i> too tightly and you get intimidating walls of text; too loosely
  and your text becomes a vaporous jumble of lines. <b>Aim to space lines
  between 120% to 145% of the point size.</b> (The text in this paragraph has a
  spacing of 160%. Too sparse.)
</p>

```css
body { line-height: 1.45; }
```

## Low-Hanging Fruit

### Adjust paragraph and header spacing

The goal is to *enclose related pieces of text (i.e. sections and paragraphs)
with whitespace.[^2]* Done right, readers are presented with a structured and
scannable hierarchy of sections and paragraphs, instead of a soup of
equally-spaced lines.

**Aim for paragraph spacing that is just large enough to be easily noticed:** a
space equal to 50–100% of the body text size usually suffices. **Header spacing
is more of a judgement call.** However, to quote [Matthew
Butterick](https://practicaltypography.com/space-above-and-below.html):

> Semantically, headings relate to the text that follows, not the text before.
> Thus you’ll probably want the space below to be smaller than the space above
> so the heading is visually closer to the text it introduces.

```css
p { margin-top: 20px;  margin-bottom: 20px; }
h1, h2, h3, h4, h5, h6 { margin-top: 8%; margin-bottom: -1%; }
```

### Choose a monospaced font and display font

Body text is the most important part of a website, so spend time making it look
good (you'll notice that all three [Easy Wins](#easy-wins) were for the body
text). Once you've done that though, consider more fonts.

Monospaced fonts (for code) lets readers easily distinguish between prose and
code, and display fonts (for titles and headers) can have much more color and
character. **Using a monospaced font can make technical, code-heavy text more
readable, and using a display font can lend your website personality.**

```css
h1, h2, h3, h4, h5, h6 { font-family: Verdana, sans-serif; }
code { font-family: Consolas, monospace; }
```

### Set a background color

(This will involve some aesthetic redesign for your website, which is why it
isn't higher on the list.)

High contrast between text and background is good for legibility, but the
contrast between pure white (`#ffffff`) and pure black (`#000000`) can look
harsh and unsettling. **Web pages are better served by off-white and off-black
backgrounds**, which are easier on the eyes while still retaining high
contrast. [Tufte CSS](https://edwardtufte.github.io/tufte-css/) suggests
`#fffff8` and `#111111`.

```css
/* If the reader prefers dark mode, use off-black instead of off-white. */
body { background-color: #fffff8; }
@media (prefers-color-scheme: dark) { body { background-color: #111111; } }
```

## Braver Undertakings

### Format code blocks

If you're unlucky enough to know something about programming and noisy enough
to want to blog about it (both of which are unfortunately quite likely, if
you're reading this), then **you probably want your code blocks to look good.**

CSS Tricks has [a fantastic tutorial on how to style `<pre><code>`
blocks](https://css-tricks.com/considerations-styling-pre-tag/), which walks
through code wrapping, code block auto-expansion, syntax highlighting and space
control.

Frustratingly, there was [one bug that drove me up the
wall](https://stackoverflow.com/a/22417120/13372802), in which some lines of
code had their font size increased for seemingly no reason:

> WebKit has the annoying behavior (for a properly designed responsive site) of
> trying to enlarge the font size for the "primary" text on the screen, where
> primary is simply its best guess.

```css
pre code {
  /* Don't wrap long lines, force horizontal scrolling. */
  white-space: pre;
  overflow-x: auto;

  /* https://stackoverflow.com/a/22417120/13372802 */
  text-size-adjust: 100%;
  -ms-text-size-adjust: 100%;
  -moz-text-size-adjust: 100%;
  -webkit-text-size-adjust: 100%;
}
```

### Support sidenotes

*Sidenotes* are when footnotes are placed in the margins beside the text they
reference, instead of at the end of the page. They allow readers to instantly
read annotations instead of having to constantly click or scroll to and fro.
**Sidenotes greatly improve footnotes for the web, but are fairly difficult to
implement despite recent efforts.**

Gwern has compiled [an exhaustive bibliography of sidenote
implementations](https://www.gwern.net/Sidenotes), which I recommend skimming
over being turning to [Tufte CSS](https://edwardtufte.github.io/tufte-css/) for
a simpler implementation.

[^1]: Yeah I know, I'm interchanging _font_ and _typeface_, but at least I have
  a life.

[^2]: Graphic designers may call this _active whitespace:_ whitespace
  deliberately added for the sake of emphasis or structure.
