---
title: Use Your Computer Faster By Reading Less
date: 2022-11-06
tags:
  - productivity
---

Suppose you want your computer to take some action (whether it's showing you information about something, navigating to a particular file, etc.). You're not reading through a menu and thinking through what to do: you already know what you want to do, and you just have to execute.

In these instances, **the slowest thing you could possibly do is read.**[^1] The more you can make your computer do what you want *with your eyes literally closed*, the faster and more efficient you will be at the computer.[^2]

[^1]: The particular phrasing of this idea is from Gary Bernhardt's [Destroy All Software](https://www.destroyallsoftware.com/screencasts/catalog/some-vim-tips) screencasts, which I can't recommend highly enough.

[^2]: As an aside, this is also true with crosswords! Crossword speed solvers know that the slowest thing you can do is _read clues_, so the trick is to solve only the down clues while reading the across entries as they solve to make sure that they still form valid words or phrases. In this way, they can cut down on around half of the time they would have normally spent reading the across clues.

## Coding Environment

I spend a lot of my time writing code, and I experienced a real step change in my programming quality of life once I configured my coding environment to be able to do all of the below without looking at the screen. (For those ~~un~~lucky enough to code in Vim, I've briefly outlined my setup.)

- Open a file, even if you only partially know its name and path (mappings to `fzf.vim` `:Buffers` and `:Files`)
- Search text in files, both currently open and not (mappings to `fzf.vim` `:Lines` and `:Rg`)
- Run the current file (a mapping to `dispatch.vim` `:Dispatch`)
- Run the current file's tests (again `dispatch.vim`)

## Search, Don't Skim

I generally try to avoid skimming webpages and documents (which is basically light reading), and instead search for what I'm looking for.

For example, I recently had the [XGBoost Python API documentation](https://xgboost.readthedocs.io/en/stable/python/python_api.html) open. It is long and tortuous, and I only want to know the name of the argument that controls the sample weight (which corrects for label class imbalance).

I could scroll and skim for `XGBClassifier`, and then skim each of the several dozen arguments to find it... or I could simply search for it directly. I searched for `weight`, saw several hundred search hits and realized that was too vague a term (it could also refer to the weights of the XGBoost model itself). I then tried `reweight` and got no hits, so I tried `balanc` (I don't search the final `e` because that would exclude conjugations like `balancing`), and found what I was looking for: the first search hit was next to the argument `scale_pos_weight`. A bit of scrolling around to double check, and I was done.

## Keyboard Shortcuts

Outside of coding, I interact with a lot of other applications every day, almost all of which have keyboard shortcuts.

Anecdotally, I know many people get turned off from learning keyboard shortcuts, because there are just so many of them. I would start small: learning two or three keyboard shortcuts per application will probably cover 90% of your use cases. I'll just go over the ones I use most frequently.

**Google Chrome:**

- `Ctrl-Shift-A` to search tabs, both currently open and recently closed
- `Ctrl-F` to search in the current tab
- `Ctrl-T` to open a new tab
- `Ctrl-W` to close a tab

Here are a ton more [Chrome](https://support.google.com/chrome/answer/157179) and [Firefox](https://support.mozilla.org/en-US/kb/keyboard-shortcuts-perform-firefox-tasks-quickly) shortcuts.

**Slack:**

- `Cmd-G` to search Slack
- `Cmd-F` to send a new Slack
- `Cmd-Shift-A` to go to your unread messages, `Esc` to mark unread messages as read

Here are a ton more [Slack](https://slack.com/help/articles/201374536-Slack-keyboard-shortcuts) keyboard shortcuts.

**Gmail:**

- `/` to search your emails
- `gi` to go to your inbox
- `c` to compose a new email
- `?` to see all shortcuts

Here are a ton more [Outlook](https://support.microsoft.com/en-us/office/keyboard-shortcuts-for-outlook-3cdeb221-7ae5-4c1d-8c1d-9e63216c1efd) and [ProtonMail](https://proton.me/support/keyboard-shortcuts) keyboard shortcuts.
