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

SCRIPTS := $(filter-out %~ %.bak, $(wildcard src/*))
MANS := $(addprefix man/, $(notdir $(SCRIPTS:=.1)))
DESKTOPS := $(wildcard data/*.desktop)

CLEAN_PAT := $(CLEAN_PAT) *~ *.bak cscope.*
CLEAN_FILES := $(MANS)

.PHONY: clean all

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
	for pat in $(CLEAN_PAT); do find . -iname $$pat -exec rm {} \; ; done
	rm -rf $(CLEAN_FILES)
