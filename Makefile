ALL=buzztrax-additive bt-edb-alphajunoctl bt-edb-distort bt-edb-kick bt-edb-waveshaper
REPO=git@github.com:dlbeswick
BUZZTRAX_PREFIX=
CONFIGURE_FLAGS=

.PHONY: all clean

all: $(ALL:%=build-%)

clean: $(ALL:%=clean-%)

$(ALL):
	git clone $(REPO)/$@

build-%: % %/configure
	cd $*/build && $(MAKE) install

clean-%:
	cd $*/build && $(MAKE) clean

%/configure:
	test -z "$(BUZZTRAX_PREFIX)" && echo BUZZTRAX_PREFIX must be set && exit 1 || true

	cd $* \
	&& autoreconf -i \
	&& mkdir -p build \
	&& cd build \
	&& ../configure --prefix $(BUZZTRAX_PREFIX) $(CONFIGURE_FLAGS)

