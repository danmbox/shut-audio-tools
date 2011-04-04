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
TMP_PAT := $(subst *,%,$(TMP_WILD))

SCRIPTS := $(filter-out $(TMP_PAT), $(wildcard src/*))
MANS := $(addprefix man/, $(notdir $(SCRIPTS:=.1)))
DESKTOPS := $(wildcard data/*.desktop)

CLEAN_FILES := $(MANS)

.PHONY: clean all srcdist

man/%.1: src/%
	help2man -N -o $@ $<

all: $(MANS)

installdirs: mkinstalldirs
	./mkinstalldirs $(DESTDIR)$(bindir) $(DESTDIR)$(datadir) \
	$(DESTDIR)$(mandir) $(DESTDIR)$(man1dir) $(DESTDIR)$(datadir)/applications

install: all installdirs
	$(INSTALL_PROGRAM) $(SCRIPTS) $(DESTDIR)$(bindir)
	$(INSTALL_DATA) $(MANS) $(DESTDIR)$(man1dir)
	$(INSTALL_DATA) $(DESKTOPS) $(DESTDIR)$(datadir)/applications

clean:
	for pat in $(TMP_WILD); do find . -iname $$pat -exec rm {} \; ; done
	rm -rf $(CLEAN_FILES)

srcdist: clean
	find . '(' -name '.git' -prune ')' -o -type f -print | \
	  tar -cvzf /tmp/shut-audio-tools.tar.gz -T -

showvars:
	@echo TMP_PAT: $(TMP_PAT)
	@echo SCRIPTS: $(SCRIPTS)
	@echo MANS   : $(MANS)
