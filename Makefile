SHELLCHECK ?= shellcheck
SHELLCHECK_SOURCES := $(shell find . -type f \( -name '*.sh' -o -path './bin/*' \) ! -path './.git/*')

.PHONY: check shellcheck

check: shellcheck

shellcheck:
	$(SHELLCHECK) $(SHELLCHECK_SOURCES)
