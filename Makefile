# Copyright (C) 2009, 2010, 2011, 2012 Jason aka bofh28 <bofh28@gmail.com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13, USA

# General variables
PACKAGE	    = crunch
VERSION	    = 3.4
PREFIX	    = /usr
DISTDIR	    = $(PACKAGE)-$(VERSION)
DISTFILES   = crunch.c crunch.1 charset.lst
BINDIR	    = $(PREFIX)/bin
BTBINDIR    = /pentest/passwords/$(PACKAGE)
MANDIR	    = $(PREFIX)/share/man/man1
INSTALL	    = $(shell which install)
CC	    = $(shell which gcc)
LIBFLAGS    = -lm
THREADFLAGS = -pthread
OPTFLAGS    = -g -o0
LINTFLAGS   = -Wall -pedantic
CFLAGS	    = $(THREADFLAGS) $(LINTFLAGS) -std=c99
VCFLAGS	    = $(THREADFLAGS) $(LINTFLAGS) -std=c99 $(OPTFLAGS)
LFS	    = $(shell getconf POSIX_V6_ILP32_OFFBIG_CFLAGS)
INSTALL_OPTIONS	= -o root -g root

# Default target
all: build

build: crunch

val:	crunch.c
	@echo "Building valgrind compatible binary..."
	$(CC) $(VCFLAGS) $(LFS) $? $(LIBFLAGS) -o $(PACKAGE)
	@echo "valgrind --leak-check=yes crunch ..."
	@echo ""

crunch: crunch.c
	@echo "Building binary..."
	$(CC) $(CFLAGS) $(LFS) $? $(LIBFLAGS) -o $@
	@echo ""

# Clean target
clean:
	@echo "Cleaning sources..."
	rm -f *.o $(PACKAGE) *~
	@echo ""

# Install generic target 
geninstall: build
	@echo "Creating directories..."
	$(INSTALL) -d -m 755 $(INSTALL_OPTIONS) $(BINDIR)
	$(INSTALL) -d -m 755 $(INSTALL_OPTIONS) $(MANDIR)
	@echo "Copying binary..."
	$(INSTALL) crunch -m 755 $(INSTALL_OPTIONS) $(BINDIR)
	@echo "Copying charset.lst..."
	$(INSTALL) charset.lst -m 644 $(INSTALL_OPTIONS) $(BINDIR)
	@echo "Copying GPL.TXT..."
	$(INSTALL) GPL.TXT -m 644 $(INSTALL_OPTIONS) $(BINDIR)
	@echo "Installing man page..."
	$(INSTALL) crunch.1 -m 644 $(INSTALL_OPTIONS) $(MANDIR)
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
