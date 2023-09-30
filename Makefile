ALL=buzztrax-additive bt-edb-alphajunoctl bt-edb-distort bt-edb-kick bt-edb-waveshaper
REPO=git@github.com:dlbeswick

.PHONY: all $(ALL) clean clone

all: $(ALL)

clean: $(ALL:%=clean-%)

clone: $(ALL:%=clone-%)

$(ALL): %: clone-% %/configure
	cd $@/build && $(MAKE) install

clean-%:
	cd $*/build && make clean

clone-%:
	test -d $* || git clone $(REPO)/$*

%/configure:
	test -z "$(BUZZTRAX_PREFIX)" && echo BUZZTRAX_PREFIX must be set && exit 1 || true
	cd $* && \
	autoreconf -i && \
	mkdir -p build && \
	cd build && \
	../configure --prefix $(BUZZTRAX_PREFIX)

