#!/bin/sh

set -euf -o pipefail

last_puzzle_number=$(find content/crosswords/ -name "*.md" | rg -o "[0-9]{3}" | sort | tail -n 1)
next_puzzle_number=$((10#${last_puzzle_number} + 1))
next_puzzle_number=`printf %03d ${next_puzzle_number}`

echo "Creating puzzle #${next_puzzle_number}..."
echo

# Look for .puz and .pdf files in downloads, the desktop and the home directory
cp ~/Downloads/loplop-${next_puzzle_number}.puz static/crosswords/ \
    || cp ~/Desktop/loplop-${next_puzzle_number}.puz static/crosswords/ \
    || cp ~/loplop-${next_puzzle_number}.puz static/crosswords/
cp ~/Downloads/loplop-${next_puzzle_number}.pdf static/crosswords/ \
    || cp ~/Desktop/loplop-${next_puzzle_number}.pdf static/crosswords/ \
    || cp ~/loplop-${next_puzzle_number}.pdf static/crosswords/
cp ~/Downloads/loplop-${next_puzzle_number}-solutions.pdf static/crosswords/ \
    || cp ~/Desktop/loplop-${next_puzzle_number}-solutions.pdf static/crosswords/ \
    || cp ~/loplop-${next_puzzle_number}-solutions.pdf static/crosswords/

read -p "Puzzle title: " puzzle_title
read -p "Favorite clue: " description
read -p "Crosshare link: " crosshare_link
read -p "Crosshare embed code: " crosshare_embed_code
echo

# Get OpenGraph image URL from Crosshare
ogimage_url=$(curl -s ${crosshare_link} | rg -o "https?://crosshare.org/api/ogimage/.*?(\"|')/>")
ogimage_url=${ogimage_url::-3}

cat << EOT > "content/crosswords/${next_puzzle_number}.md"
---
title: "${puzzle_title}"
date: $(date +%Y-%m-%d)
description: ${description}
images:
  - ${ogimage_url}
embed: '${crosshare_embed_code}'
blogSubscribeFooter: false
---



## Clue Workshop



<p style="text-align:center">

</p>

<details>
<summary>Click here for solution and discussion</summary>

- **Answer:** 
- **Definition:** 
- **Wordplay:** 

</details>

[web](${crosshare_link})
/ [puz](/crosswords/loplop-${next_puzzle_number}.puz)
/ [pdf](/crosswords/loplop-${next_puzzle_number}.pdf)
/ [solutions and annotations](/crosswords/loplop-${next_puzzle_number}-solutions.pdf)
EOT

echo "Successfully created blog post template! Press Enter to begin editing blog post."
read

vim "content/crosswords/${next_puzzle_number}.md"

git add "content/crosswords/${next_puzzle_number}.md" \
    "static/crosswords/loplop-${next_puzzle_number}.puz" \
    "static/crosswords/loplop-${next_puzzle_number}.pdf" \
    "static/crosswords/loplop-${next_puzzle_number}-solutions.pdf"
git status
