DESTDIR     =
prefix      = /usr/local
exec_prefix = $(prefix)
bindir      = $(exec_prefix)/bin
sbindir     = $(exec_prefix)/sbin
datarootdir = $(prefix)/share
datadir     = $(datarootdir)
mandir      = $(datarootdir)/man
man1dir     = $(mandir)/man1

INSTALL         = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA    = $(INSTALL) -m 644

###

TMP_WILD := $(TMP_WILD) *~ *.bak cscope.*
TMP_PAT  := $(subst *,%,$(TMP_WILD))
RELEASE  := $(shell cat release.txt)
MYNAME   := shut-audio-tools
DISTNAME  := $(MYNAME)-$(RELEASE)

SCRIPTS := $(filter-out $(TMP_PAT), $(wildcard src/*))
MANS := $(addprefix man/, $(notdir $(SCRIPTS:=.1)))
DESKTOPS := $(wildcard data/*.desktop)

CLEAN_FILES := $(MANS)

.PHONY: clean all srcdist xdebian

all: $(MANS)

man/%.1: src/% $(filter-out $(wildcard man), man)
	help2man -N -o $@ $< || { $< --help || :; $< --version || :; false; }

install: all installdirs
	$(INSTALL_PROGRAM) $(SCRIPTS) $(DESTDIR)$(bindir)
	$(INSTALL_DATA) $(MANS) $(DESTDIR)$(man1dir)
	$(INSTALL_DATA) $(DESKTOPS) $(DESTDIR)$(datadir)/applications

clean:
	for pat in $(TMP_WILD); do find . -iname $$pat -exec rm {} \; ; done
	rm -rf $(CLEAN_FILES)

srcdist: clean
	TD=`mktemp -d /tmp/mkdist.XXXXXX`; \
	cp -a . $$TD/$(DISTNAME); cd $$TD; \
	find $(DISTNAME) '(' -name '.git' -prune ')' -o -type f -print | \
	  tar -cvzf /tmp/$(DISTNAME).tar.gz -T -; \
	test $$TD && $(RM) -r $$TD/*; rmdir $$TD

xdebian: srcdist
	cd ..; mv /tmp/$(DISTNAME).tar.gz .; tar xzf $(DISTNAME).tar.gz; \
	mv $(DISTNAME).tar.gz $(MYNAME)_$(RELEASE).orig.tar.gz; \
	cd $(DISTNAME); make clean; $(RM) -r debian; mv mydebian debian; \
	dch -p -v $(RELEASE)'-1~'`date '+%Y%m%d'`'~local1' "Local build."; \
	printf "%s " "Debian directory in "; pwd

showvars:
	@echo TMP_PAT: $(TMP_PAT)
	@echo SCRIPTS: $(SCRIPTS)
	@echo MANS   : $(MANS)

man:
	mkdir man

installdirs: mkinstalldirs
	./mkinstalldirs $(DESTDIR)$(bindir) $(DESTDIR)$(datadir) \
	$(DESTDIR)$(mandir) $(DESTDIR)$(man1dir) $(DESTDIR)$(datadir)/applications
