SHELLCHECK ?= shellcheck
SHELLCHECK_SOURCES := \
	bootstrap.sh \
	install.sh \
	macOS/install.sh \
	linux/install.sh \
	bin/dotfiles

.PHONY: check shellcheck

check: shellcheck

shellcheck:
	$(SHELLCHECK) $(SHELLCHECK_SOURCES)
