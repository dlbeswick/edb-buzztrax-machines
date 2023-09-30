DIRS=buzztrax-additive bt-edb-alphajunoctl bt-edb-distort bt-edb-kick bt-edb-waveshaper
REPO=git@github.com:dlbeswick
BUZZTRAX_PREFIX=
CONFIGURE_FLAGS=

.PHONY: all clean $(DIRS:%=install-%) $(DIRS:%=clean-%)

install: $(DIRS:%=install-%)

clean: $(DIRS:%=clean-%)

$(DIRS):
	git clone $(REPO)/$@

# Use static patterns rather than implicit patterns, because the "install-*" and "clean-*" targets are PHONY, and
# implicit patterns are not processed for PHONY targets.
#
# This means: Given one of the targets install-buzztrax-additive, install-bt-edb-alphajunoctl, etc... pattern match to
# find the text that comes after "install-". Then, prerequisite targets of the resulting target will be
# "buzztrax-additive" (to clone the dir), "buzztrax-additive/configure" (to generate autoconf output) and
# "buzztrax-additive/build/config.status" (to run configure were necessary.)
$(DIRS:%=install-%): install-%: % %/configure %/build/config.status
	cd $*/build && $(MAKE) install

$(DIRS:%=clean-%): clean-%:
	cd $*/build && $(MAKE) clean

%/configure:
	cd $* && autoreconf -i

%/build/config.status: %/configure
	test -z "$(BUZZTRAX_PREFIX)" && echo BUZZTRAX_PREFIX must be set && exit 1 || true

	cd $* \
	&& mkdir -p build \
	&& cd build \
	&& ../configure --prefix $(BUZZTRAX_PREFIX) $(CONFIGURE_FLAGS)
