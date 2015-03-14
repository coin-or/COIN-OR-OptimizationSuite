# Copyright (C) 2006 International Business Machines and others.
# All Rights Reserved.
# This file is distributed under the Eclipse Public License.

## $Id$

# Author:  Andreas Waechter           IBM    2006-04-13

AUTOMAKE_OPTIONS = foreign

########################################################################
#                          Subdirectories                              #
########################################################################

# subdirs is set by configure as the list of all subdirectories to recurse
# into
SUBDIRS = $(subdirs)

########################################################################
#                           Extra Targets                              #
########################################################################

test: tests

tests: all
	for dir in $(subdirs); do \
	  if test -r $$dir/test/Makefile; then \
	    (cd $$dir; make test) || exit 1 ; \
	  fi; \
	done

unitTests: tests

.PHONY: tests unitTests

thirdparty: asl blas glpk lapack metis mumps

asl: @srcdir@/ThirdParty/ASL/solvers/asl.h

@srcdir@/ThirdParty/ASL/solvers/asl.h:
	cd @srcdir@/ThirdParty/ASL; ./get.ASL -y

blas: @srcdir@/ThirdParty/Blas/ccopy.f

@srcdir@/ThirdParty/Blas/ccopy.f:
	cd @srcdir@/ThirdParty/Blas; ./get.Blas

lapack: @srcdir@/ThirdParty/Lapack/LAPACK/SRC/cbbcsd.f

@srcdir@/ThirdParty/Lapack/LAPACK/SRC/cbbcsd.f:
	cd @srcdir@/ThirdParty/Lapack; ./get.Lapack

glpk: @srcdir@/ThirdParty/Glpk/glpk/src/glpapi01.c

@srcdir@/ThirdParty/Glpk/glpk/src/glpapi01.c:
	cd @srcdir@/ThirdParty/Glpk; ./get.Glpk

metis: @srcdir@/ThirdParty/Metis/metis-4.0/Lib/balance.c

@srcdir@/ThirdParty/Metis/metis-4.0/Lib/balance.c:
	cd @srcdir@/ThirdParty/Metis; ./get.Metis

mumps: @srcdir@/ThirdParty/Mumps/MUMPS/src/mumps_c.c

@srcdir@/ThirdParty/Mumps/MUMPS/src/mumps_c.c:
	cd @srcdir@/ThirdParty/Mumps; ./get.Mumps

########################################################################
#                         Maintainer Stuff                             #
########################################################################

# Files that are generated and should be cleaned with make distclean
DISTCLEANFILES = coin_subdirs.txt

EXTRA_DIST =
include BuildTools/Makemain.inc
