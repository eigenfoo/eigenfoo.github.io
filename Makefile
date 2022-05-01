.PHONY: help draft serve test compress submodule
.DEFAULT_GOAL = help

help:
	@printf "Usage:\n"
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[1;34mmake %-10s\033[0m%s\n", $$1, $$2}'

draft:  # Start a draft blog post
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

serve:  # Serve site locally
	hugo serve --buildDrafts --buildFuture

test:  # Test generated HTML files.
	hugo
	link_check public/ --host georgeho.org > link_check.txt 2>&1
	rm -rf public/

clean:  # Clean generated files
	rm -rf link_check.txt public/

compress:  # Compress images losslessly
	jpegoptim static/assets/images/*.jpg
	optipng static/assets/images/*.png
