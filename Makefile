.PHONY: help setup draft serve clean stop
.DEFAULT_GOAL = help

help:
	@printf "Usage:\n"
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[1;34mmake %-10s\033[0m%s\n", $$1, $$2}'

draft:  # Start a draft blog post.
	( \
	touch draft.md; \
	echo "---" >> draft.md; \
	echo "title:" >> draft.md; \
	echo "date: $(shell date +%Y-%m-%d)" >> draft.md; \
	echo "tags:" >> draft.md; \
	echo "  - " >> draft.md; \
	echo "draft: true" >> draft.md; \
	echo "---" >> draft.md; \
	echo "" >> draft.md; \
	mv draft.md content/blog/; \
	)

serve:  # Serve site locally.
	hugo serve --buildDrafts

test:  # Test generated HTML files.
	# Ignore broken links from /r/TheRedPill and Tweets (some people delete tweets)
	bundle exec jekyll build --future
	bundle exec htmlproofer ./_site/ --only-4xx --check-html --url-ignore "/reddit.com\/r\/TheRedPill/,/twitter.com\/[a-zA-Z0-9_]*\/status\/[0-9]*/"

compress:  # Compress images losslessly
	jpegoptim static/assets/images/*.jpg
	optipng static/assets/images/*.png

submodule:
	( \
	cd themes/hugo-bearblog; \
	git submodule update --init --recursive; \
	)
