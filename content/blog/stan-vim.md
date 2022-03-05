---
title: "Introducing `stan-vim`"
date: 2019-11-11
tags:
  - open-source
  - stan
---

<center>
  <img
   src="/assets/images/stan-logo.png"
   alt="Stan logo">
</center>

I made a Vim plugin for Stan!

I've been reading and writing a lot of Stan lately, but mainly in barebones text
editors (or even just by `cat`ing out the file), so I had to make do with none
of the creature comforts of my favorite text editor, Vim.

But I also wasn't happy with the syntax highlighting provided by
[existing](https://github.com/maverickg/stan.vim)
[Vim](https://github.com/mdlerch/mc-stan.vim)
[plugins](https://github.com/ssp3nc3r/stan-syntax-vim) (and they also looked out
of date and thinly maintained...), so I just went ahead and learnt a truckload
of Vimscript[^1].

Check out the plugin! You can find installation instructions
[here](https://github.com/eigenfoo/stan-vim#installation) and documentation
[here](https://github.com/eigenfoo/stan-vim#documentation). Screenshots of
syntax highlighting and projects links are below.

- [GitHub](https://github.com/eigenfoo/stan-vim)
- [VimAwesome](https://vimawesome.com/plugin/stan-vim-is-written-on)
- [Vim Online](https://www.vim.org/scripts/script.php?script_id=5835)

<figure>
  <a href="https://raw.githubusercontent.com/eigenfoo/stan-vim/master/screenshots/screenshot0.png"><img src="https://raw.githubusercontent.com/eigenfoo/stan-vim/master/screenshots/screenshot0.png" alt="Screenshot of a Stan model in stan-vim"></a>
  <a href="https://raw.githubusercontent.com/eigenfoo/stan-vim/master/screenshots/screenshot1.png"><img src="https://raw.githubusercontent.com/eigenfoo/stan-vim/master/screenshots/screenshot1.png" alt="Screenshot of the stan-vim documentation"></a>
  <a href="https://raw.githubusercontent.com/eigenfoo/stan-vim/master/screenshots/screenshot2.png"><img src="https://raw.githubusercontent.com/eigenfoo/stan-vim/master/screenshots/screenshot2.png" alt="Screenshot of another Stan model in stan-vim"></a>
  <figcaption>Screenshots of <code>stan-vim</code> syntax highlighting.</figcaption>
</figure>

[^1]: As it turns out, [Vimscript is a very not-good
      language](https://www.reddit.com/r/vim/comments/54224o/why_is_there_so_much_hate_for_vimscript/).
      This is probably the last Vim plugin I write.
