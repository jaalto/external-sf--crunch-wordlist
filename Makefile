#   Copyright
#
#	Copyright (C) 2009-2012 Jason aka bofh28 <bofh28@gmail.com>
#
#   License
#
#	This program is free software; you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation; either version 2 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program. If not, see <http://www.gnu.org/licenses/>.
#
#   Description
#
#	For standard FHS directory structure install, use command:
#
#		make PREFIX=/usr INSTALL_OPTIONS= geninstall

# General variables
PACKAGE	    = crunch
VERSION	    = 3.4
PREFIX	    = /usr
DISTDIR	    = $(PACKAGE)-$(VERSION)
DISTFILES   = crunch.c crunch.1 charset.lst
BINDIR	    = $(PREFIX)/bin
LIBDIR	    = $(PREFIX)/lib/$(PACKAGE)
SHAREDIR    = $(PREFIX)/share/$(PACKAGE)
DOCDIR	    = $(PREFIX)/share/doc/$(PACKAGE)
MANDIR	    = $(PREFIX)/share/man/man1
BTBINDIR    = /pentest/passwords/$(PACKAGE)
INSTALL	    = $(shell which install)
CC	    = $(shell which gcc)
LIBFLAGS    = -lm
THREADFLAGS = -pthread
OPTFLAGS    = -g -o0
LINTFLAGS   = -Wall -pedantic
CFLAGS	    = $(THREADFLAGS) $(LINTFLAGS) -std=c99
VCFLAGS	    = $(THREADFLAGS) $(LINTFLAGS) -std=c99 $(OPTFLAGS)
LFS	    = $(shell getconf POSIX_V6_ILP32_OFFBIG_CFLAGS)
INSTALL_OPTIONS = -o root -g root

# Default target
all: build

build: crunch

val:	crunch.c
	@echo "Building valgrind compatible binary..."
	$(CC) $(CPPFLAGS) $(VCFLAGS) $(LFS) $? $(LIBFLAGS) $(LDFLAGS) -o $(PACKAGE)
	@echo "valgrind --leak-check=yes crunch ..."
	@echo ""

crunch: crunch.c
	@echo "Building binary..."
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LFS) $? $(LIBFLAGS) $(LDFLAGS) -o $@
	@echo ""

# Clean target
clean:
	@echo "Cleaning sources..."
	rm -f *.o $(PACKAGE) *~
	@echo ""

# Install generic target
geninstall: build
	@echo "Creating directories..."
	$(INSTALL) -d -m 755 $(INSTALL_OPTIONS) \
		$(DESTDIR)$(BINDIR) \
		$(DESTDIR)$(MANDIR) \
		$(DESTDIR)$(SHAREDIR) \
		$(DESTDIR)$(DOCDIR)
	@echo "Copying binary..."
	$(INSTALL) crunch -m 755 $(INSTALL_OPTIONS) $(DESTDIR)$(BINDIR)
	@echo "Copying charset.lst..."
	$(INSTALL) charset.lst -m 644 $(INSTALL_OPTIONS) $(DESTDIR)$(SHAREDIR)
	@echo "Copying GPL.TXT..."
	$(INSTALL) GPL.TXT -m 644 $(INSTALL_OPTIONS) $(DESTDIR)$(DOCDIR)
	@echo "Installing man page..."
	$(INSTALL) crunch.1 -m 644 $(INSTALL_OPTIONS) $(DESTDIR)$(MANDIR)
	@echo ""

# Install BT specific target
install: build
	@echo "Creating directories..."
	$(INSTALL) -d -m 755 $(INSTALL_OPTIONS) $(BTBINDIR)
	$(INSTALL) -d -m 755 $(INSTALL_OPTIONS) $(MANDIR)
	@echo "Copying binary..."
	$(INSTALL) crunch -m 755 $(INSTALL_OPTIONS) $(BTBINDIR)
	@echo "Copying charset.lst..."
	$(INSTALL) charset.lst -m 644 $(INSTALL_OPTIONS) $(BTBINDIR)
	@echo "Copying GPL.TXT..."
	$(INSTALL) GPL.TXT -m 644 $(INSTALL_OPTIONS) $(BTBINDIR)
	@echo "Installing man page..."
	$(INSTALL) crunch.1 -m 644 $(INSTALL_OPTIONS) $(MANDIR)
	@echo ""

# Uninstall target
uninstall:
	@echo "Deleting binary and manpages..."
	rm -rf $(BTBINDIR)/
	rm -rf $(BINDIR)/$(PACKAGE)
	rm -f $(MANDIR)/crunch.1
	@echo ""

zip: clean
	cd .. ;\
	zip -r $(DISTDIR).zip $(DISTDIR)

tarball: clean
	cd .. ;\
	tar -czf $(DISTDIR).tgz $(DISTDIR)

bzip: clean
	cd .. ;\
	tar -cjf $(DISTDIR).tar.bz2 $(DISTDIR)
