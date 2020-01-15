
ROOT_DIR := $(shell dirname "$(realpath $(firstword $(MAKEFILE_LIST)))")

CURL              := $(shell command -v curl)
STOW              := $(ROOT_DIR)/bin/stow
STOW_VERSION      := 2.3.1
STOW_TARBALL_FILE := stow-$(STOW_VERSION).tar.gz
STOW_TARBALL_URL  := https://ftp.gnu.org/gnu/stow/$(STOW_TARBALL_FILE)
SYSTEM_STOW       := $(shell command -v stow)
ifeq ($(SYSTEM_STOW), )
    STOW_DEPS := stow
endif

$(STOW_TARBALL_FILE):
	$(CURL) -LO $(STOW_TARBALL_URL)

stow-$(STOW_VERSION): $(STOW_TARBALL_FILE)
	tar zxvf $<

stow: stow-$(STOW_VERSION)
	@(set -e ; \
		cd stow-$(STOW_VERSION) ; \
		./configure --prefix=$(ROOT_DIR)/$@ ; \
		make install)

bin:
	mkdir -p $@

bin/stow: $(STOW_DEPS)
	@if [ -n "$(SYSTEM_STOW)" ]; then \
			source="$(SYSTEM_STOW)" ; \
		else \
			source="$(ROOT_DIR)/stow/bin/stow" ; \
		fi ; \
		echo $$source $(STOW) ; \
		ln -s "$$source" "$(STOW)"

clean:
	-rm -rf stow-2.3.1
	-rm $(STOW_TARBALL_FILE)

install: bin/stow

.PHONY: install-stow
