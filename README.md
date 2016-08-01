# COIN-OR OPTIMIZATION SUITE 1.8

[![Build Status](https://travis-ci.org/coin-or/COIN-OR-OptimizationSuite.svg?branch=master)](https://travis-ci.org/coin-or/COIN-OR-OptimizationSuite)

The COIN-OR Optimization Suite is a collection of interoperable open source
solvers from the respository of open source software maintained by the COIN-OR
Foundation. It consists of the following projects.

 * [CoinUtils](http://projects.coin-or.org/CoinUtils) (COIN-OR utility library)
 * [Osi](http://projects.coin-or.org/Osi) (Open Solver Interface)
 * [Clp](http://projects.coin-or.org/Clp) (COIN-OR LP Solver)
 * [FlopCpp](http://projects.coin-or.org/FlopCpp) (C++-based algebraic modeling language)
 * [DyLP](http://projects.coin-or.org/DyLP) (LP solver based on dynamic simplex method)
 * [Vol](http://projects.coin-or.org/Vol) (approximate LP solver based on Volume Algorithm)
 * [Cgl](http://projects.coin-or.org/Cgl) (Cut generation library)
 * [SYMPHONY](http://projects.coin-or.org/SYMPHONY) (MILP solver framework)
 * [Cbc](http://projects.coin-or.org/Cbc) (COIN-OR branch-and-cut MILP solver)
 * [Smi](http://projects.coin-or.org/Smi) (Stochastic modeling interface)
 * [CoinMP](http://projects.coin-or.org/CoinMP) (Unified C API for Cbc and Clp)
 * [Bcp](http://projects.coin-or.org/Bcp) (Branch, cut, and price framework)
 * [Ipopt](http://projects.coin-or.org/Ipopt) (Interior point algorithm for non-linear optimization)
 * [CHiPPS](http://projects.coin-or.org/CHiPPS) (COIN-OR High Performance Parallel Search framework)
   * Alps (Abstract Library for Parallel Search)
   * BiCePS (Branch, Constrain, and Price Software)
   * Blis (BiCePS Linear Integer Solver)
 * [Dip](http://projects.coin-or.org/Dip) (Decomposition-based MILP solver framework)
 * [CppAD](http://projects.coin-or.org/CppAD) (Automatic differentiation in C++)
 * [Bonmin](http://projects.coin-or.org/Bonmin) (Solver for Convex MINLP)
 * [Couenne](http://projects.coin-or.org/Couenne) (Solver for non-convex MINLP)
 * [OS](http://projects.coin-or.org/OS) (Optimization Services)
 * [Application Templates](https://projects.coin-or.org/CoinBazaar/wiki/Projects/ApplicationTemplates) (Examples)

# INSTALL

## Pre-built Binaries

The [CoinBinary](http://projects.coin-or.org/CoinBinary) project is a
long-term effort to provide pre-built binaries and installers for popular
platforms. You can download some binaries at

http://www.coin-or.org/download/binary/OptimizationSuite

but beware these are not automatically built and may be out of date. AMPL also
kindly provides executables of some solvers for download at

http://ampl.com/products/solvers/open-source/.

We are working on some other better ways of getting binaries, such as conda
packages, and will keep this README updated as things progress.

## Docker Image

The Docker image available at

https://hub.docker.com/r/tkralphs/coinor-optimization-suite/

is another excellent way to use the COIN-OR Optimization Suite. For details on
how to obtain and use this image, see the project's Github page
[here](https://github.com/tkralphs/optimization-suite-docker).

## Installers

### Windows

There is a Windows GUI installer available
[here](http://www.coin-or.org/download/binary/OptimizationSuite) for
installing libraries compatible with Visual Studio (you will need to install
the free Intel compiler redistributable libraries).

### OS X

There are Homebrew recipes for some projects available [here](https://github.com/coin-or-tools/homebrew-coinor). Just do
```
brew tap coin-or-tools/coin-or
```

### Linux 

For Linux, there are now Debian and Fedora packages for most projects in
the suite and we are investigating the possiblity of providing Linuxbrew
packages.
 * Click [here](https://packages.debian.org/search?keywords=coinor&searchon=names&suite=stable&section=all) for list of Debian packages.
 * Click [here](https://apps.fedoraproject.org/packages/s/coin-or) for a list of Fedora packages.

## Other Installation Methods

Other ways of obtaining COIN include downloading it through a number of
modeling language front-ends. For example, COIN-OR can be used through
 * [GAMS](http://www.gams.com/help/index.jsp?topic=%2Fgams.doc%2Fsolvers%2Findex.html),
 * [MPL](http://www.maximalsoftware.com/solvers/coin.html), and
 * [AMPL](http://ampl.com/products/solvers/open-source/),
 * [MATLAB](http://www.i2c2.aut.ac.nz/Wiki/OPTI/index.php/DL/DownloadOPTI)
 * [R](https://www.r-project.org/): Packages available
 [here](http://bioconductor.org/packages/devel/bioc/html/lpsymphony.html) or
 [here](https://cran.r-project.org/web/packages/Rsymphony/index.html) or
 [here](https://github.com/vladchimescu/lpsymphony)
 * [Open Solver](http://opensolver.org)
 * [Solver Studio](http://solverstudio.org)

# Building from Source

Why download and build COIN yourself? There are many options for building COIN
codes and the distributed binaries are built with just one set of options. We
cannot distribute binaries linked to libraries licensed under the GPL, so you
must build yourself if you want GMPL, command completion, command history,
Haskell libraries, etc. Other advanced options that require specific
hardware/software may also not be supported in distributed binaries (parallel
builds, MPI) Once you understand how to get and build source, it is
much faster to get bug fixes.

## Building on Windows (MSys2/CYGWIN and MinGW/MSVC)

By far, the easiest way to build on Windows is with the GNU autotools and the
MinGW compilers.  
 1. The first step is to install either [Msys2](https://msys2.github.io/) or
 [CYGWIN](http://cygwin.org/). If you don't already
 have CYGWIN installed, it is recommended to use MSys2, since it provides a
 minimal toolset that is easy to install.    
 2. To get MSys2, either download the installer
 [here](https://msys2.github.io/) or download and unzip MSys2 base from
 [here](http://kent.dl.sourceforge.net/project/msys2/Base/x86_64/msys2-base-x86_64-20150512.tar.xz). 
 3. Either run `msys2_shell.bat` or manually add `msys64\usr\bin`,
 `msys64\mingw32\bin`, and `msys64\mingw64\bin` to your Windows path.   
 4. Open a Windows terminal and type

   ```
   bash
   pacman -S make wget tar patch dos2unix diffutils svn
   ```

 5. Obtain the source code with 

   ```
   svn co \
   http://www.coin-or.org/svn/CoinBinary/OptimizationSuite/stable/1.8 \
   COIN-1.8
   ```

   Note that is it also possible to obtain the source with `git` (see section
   on this below) or as a zip file or tarball from
   
   http://www.coin-or.org/download/source/OptimizationSuite
   
 6. Finally, build with

   ```
   cd COIN-1.8
   ./get.AllThirdParty
   mkdir build
   cd build
   ../configure --with-gmpl --enable-gnu-packages
   make install
   ```

 7. To use the resulting binaries and/or libraries, you will need to add the
 full path of the directory `COIN-1.8\build\bin` to your Windows executable
 search `PATH`, or, alternatively, copy this directory to `C:\Program Files
 (x86)` and add the directory `C:\Program Files (x86)\COIN-1.8\bin` to your
 Windows executable search `PATH`. You may also consider copying the
 `build\lib` and `build\include` directories if you want to link to the
 COIN-OR libraries.

It is possible to use almost the exact same commands to build with the Visual
Studio compilers. Before doing any of the above commands in the Windows
terminla, first run the `vcvarsall.bat` script for your version of Visual
Studio. Note that you will also need a compatible Fortran compiler if you want
to build any projects requiring Fortran (`ifort` is recommended, but not
free). Then follow all the steps above, but replace the `configure` command
with

```
../configure --enable-msvc --with-gmpl --enable-gnu-packages
```

## Building on Windows (Visual Studio IDE)

Building on Visual Studio with the IDE is not recommended, but there are
MSVC solution files available for doing this. Obtain the source code
using [Tortoise SVN](http://tortoisesvn.net) from the URL

http://www.coin-or.org/svn/CoinBinary/OptimizationSuite/stable/1.8

and then find the solution file in the directory `MSVisualStudio\v10`. Opening
this solution file should work in any version of MSVC++. Note that this will
not build some projects that require a Fortran compiler. 

## Building on OS X

OS X is a Unix-based OS and ships with many of the basic components needed to
build COIN-OR, but it's missing some things. For examples, the latest versions
of OS X come with the `clang` compiler but no Fortran compiler. You may also
be missing the `wget` utility and a `subversion` client (needed for obtaining
source code). The easiest way to get these missing utilitites is to install
Homebrew (see http://brew.sh). After installation, open a terminal and do

```
brew install gcc wget svn
```

To obtain the source code, open a terminal and do

```
svn co \
http://www.coin-or.org/svn/CoinBinary/OptimizationSuite/stable/1.8 \
COIN-1.8
```

Note that is it also possible to obtain the source with `git` (see section
on this below). Finally, build with

```
cd COIN-1.8
./get.AllThirdParty
mkdir build
cd build
../configure --prefix=/your/install/dir --with-gmpl --enable-gnu-packages
make
make install
```

With this setup, `clang` will be used for compiling C++ by default and
`gfortran` will be used for Fortran. Since `clang` uses the GNU standard
library, `gfortran` is compatible.

If you want to use the `gcc` compiler provided by Homebrew, then replace the
`configure` command above with

```
../configure --with-gmpl --enable-gnu-packages CC=gcc-5 CXX=g++-5
```
Afterward, you will also need to add `/your/install/dir/bin` to your
`PATH` variable in your `.bashrc` and also add `/your/install/dir/lib`
to your `DYLD_LIBRARY_PATH` if you want to link to COIN libraries. 

### Building on Linux

Most Linux distributions come with all the required tools installed.
To obtain the source code, open a terminal and do

```
svn co \
http://www.coin-or.org/svn/CoinBinary/OptimizationSuite/stable/1.8 \
COIN-1.8
```

Note that it is also possible to obtain the source with `git` (see section
on this below). Finally, build with

```
cd COIN-1.8
./get.AllThirdParty
mkdir build
cd build
../configure --prefix --with-gmpl --enable-gnu-packages
make
make install
```
Afterward, you will also need to add `/your/install/dir/bin` to your
`PATH` variable in your `.bashrc` and also add `/your/install/dir/lib`
to your `LD_LIBRARY_PATH` if you want to link to COIN libraries. 

# Additional Useful Information

## Working with Single Projects

If you want to check out and build only a single COIN project and all of its
dependencies, the above instructions will work with only slight modification.
Simply obtain the source code for that project either as a zip file or tarball
from

http://www.coin-or.org/download/source

by clicking on the subdirectory for the appropriate project or by replacing the
command above for checking out the source code with `svn` by

```
svn co \
http://www.coin-or.org/svn/ProjName/releases/x.y.z ProjName-x.y.z
```

where `ProjName` is the short name of the project, e.g., `Cbc` and `x.y.z` is the
version number (see below for more on version numbers).

## Organization of the repositories

Most projects are currently managed with using `subversion`. Within
subversion, repositories have a folder-based hierachical straucture. At the
top level, all repositories have the following directory structure. 
```
html/
conf/
branches/
trunk/
stable/
releases/
```
The `trunk/` is where development takes place, so this represents the "bleeding
edge" code. The `stable/` directory contains the subdirectories with source
code for tested versions of the code that are guaranteed to have a fixed API
and fixed functionality, but may change when bug fixes are applied and
internal implementations are improved. Stable versions have two digits (see
below for explanation). The `release/` directory has fixed releases that will
never change. These are snapshots of an associated stable version. Release
versions have three digits (see below). If you are using `subversion` or `git`
to get code, you generally want the latest stable version. If you are
downloading a tarball or zip file, you want the latest release.

For a source checkout of a single version of the code, the source tree for
the root of project ProjName looks something like this

```
ProjName/
doxydoc/
INSTALL
README
AUTHORS
Dependencies 
configure 
Makefile.am
... 
```

The files in the root directory are for doing *monolithic* builds (builds
including the project *and* the dependencies. The `Dependencies` file contains
the list of URLs for all dependent projects, but source code for these is
pulled in automatically using the `svn externals` mechanism. If you only want
to build the project itself and lnk against installed  
binaries of other projects, you only need the `ProjName` subdirectory. 

The `ProjName` subdirectory for project `ProjName` looks something like this.

```
src/
examples/
MSVisualStudio/
test/
AUTHORS
README 
LICENSE 
INSTALL 
configure 
Makefile.am 
... 
```

The files in this subdirectory are for building the library of the project
itself, with no dependencies, with the exception of the `MSVisualStudio`
directory, which contains solution files that include dependencies.  

## Building the Library of a Single Project

Assuming some libraries are already installed in `/some/dir`, you can check
out the code for and build an individual project library (without
dependencies) for project `ProjName`, as follows. 

```
svn co http://projects.coin-or.org/svn/ProjName/stable/x.y/ProjName ProjName-x.y
cd ProjName-x.y
mkdir build
cd build
../configure --enable-gnu-packages -C --with-coin-instdir=/some/dir
make -j 2 
make test
make install
```
Note that this checks out `ProjName` without externals and links against
installed libraries.

## About version numbers 

COIN numbers versions by a standard semantic versioning scheme: each version
has a *major*, *minor*, and *patch/release* number. All version within a
*major.minor* series are compatible. All versions within a *major* series are
backwards compatible. The versions with the `stable/` subdirectory have two
digits, e.g., `1.1`, whereas the releases have three digits, e.g., `2.1.0`.
The first two digits of the release version number indicates the stable series
of which the release is a snapshot. The third digit is the release number in
that series.

## Working With Git

Although the Optimization Suite and most of the projects that are a part of it
are managed natively using subversion, you can also get the source from
[COIN-OR's Github site](https://github.com/coin-or). The git repositories
there are mirrors of the subversion repositories. To get the source for
project `ProjName`, open a terminal and execute

```
git clone https://github.com/coin-or/ProjName
```

The `trunk/` subdirectory of each project is mirrored to the `master` branch
and each stable versions is in a branche called `stable/x.y`. Releases are
tags of specific SHAs in each of these stable branches. To get stable version
`x.y`, open a terminal and execute

```
git clone --branch=stable/x.y
```

Although it is not recommended, you can also get a release `x.y.z` by doing 

```
git clone --branch=releases/x.y.z
```

To build from source, there is a script that fetches dependent projects
and builds automatically. To get the script, do

```
git clone --branch=stable/1.8 https://github.com/coin-or-tools/BuildTools/
```

and then execute

```
BuildTools/get.dependencies fetch
BuildTools/get.dependencies build --quiet --test
```

Run the script without arguments to see the options. 

## ThirdParty Projects

There are a number of open-source projects that COIN projects can link to, but
whose source we do not distribute. We provide convenient scripts for
downloading these projects (shell scripts named `./get.ProjName` and a build
harness for build them. We also produce libraries and pkg-config files. If you
need the capabilities of a particular third party library, simply run the
`get.ProjName` script before configuring for your build and it will be
automatically integrated. Beware of licensing in compatibilities if you plan
to redistribute the resulting binaries. The following are the supported
libraries. 
 * AMPL Solver Library (required to use solvers with AMPL)
 * Blas (improves performance---usually available natively on Linux/OS X)
 * Lapack (same as Blas)
 * Glpk
 * Metis
 * MUMPS (required for Ipopt to build completely open source)
 * Soplex
 * SCIP
 * HSL (an alternative to MUMPS that is not open source)
 * FilterSQP

## Parallel Builds

`SYMPHONY`, `DIP`, `CHiPPS`, and `Cbc` all include the ability to solve in 
parallel. 
 * CHiPPS uses MPI and is targeted at massive parallelism (it would be
   possible to develop a hybrid algorithm, however). To build in parallel,
   specify the location of MPI with the `--with-mpi-incdir` and `--with-mpi-lib`
   arguments to `configure`, as follows:

   ```
   configure --enable-static \ 
             --disable-shared \
             --with-mpi-incdir=/usr/include/mpich2 \ 
             --with-mpi-lib="-L/usr/lib  -lmpich" \
             MPICC=mpicc \
             MPICXX=mpic++ \
   ```

 * SYMPHONY has both shared and distributed memory parallel modes, but we'll
 only discuss the shared memory capability here. It is enabled by default if
 the compiler supports OpenMP (`gcc` and Microsft's `cl` both do, but `clang`
 does not). To disable share memory parallel mode, use the `--disable-openmp`
 argument to `configure`.  
 * Cbc has shared memory parallelism, which can be enabled with the
 `--enable-cbc-parallel` to `configure` 
 * DIP currently has a shared memory parallel mode that works the same way as
 SYMPHONY's.
 
## Other Configure-time Options}

There are many configure options for customizing the builds, which is the
advantage of learning to build yourself.
 * Over-riding variables: `CC, CXX, F77, CXX_ADDFLAGS`
 * `--prefix`
 * `--enable-debug`
 * `--enable-gnu-packages`
 * `-C`
`configure --help` lists many of the options, but beware that
configure is recursive and the individual project also have their own options.
 * `SYMPHONY/configure --help` will list the options for SYMPHONY.
 * The options for individual projects can be given to the root `configure`
 script---they will be passed on to subprojects automatically.

## Documentation

Some documentation on using the full optimization suite is available at
http://projects.coin-or.org/CoinHelp and http://projects.coin-or.org/CoinEasy.
There is also a full tutorial on the Optimization Suite and much more at
http://coral.ie.lehigh.edu/~ted/teaching/coin-or.

User's manuals and documentation for project ProjName can be obtained at either
http://projects.coin-or.org/ProjName or http://www.coin-or.org/ProjName.
Doxygen source code documentation for some projects can also be obtained at
http://www.coin-or.org/Doxygen

## Support

Support is available primarily through mailing lists and bug reports at
http://list.coin-or.org/mailman/listinfo/ProjName and
http://projects.coin-or.org/ProjName. It is also possible to submit issues
vis Github for most projects at https://github.com/coin-or/ProjName.
Keep in mind that the appropriate place to submit your question or bug
report may be different from the project you are actually using.
Make sure to report all information required to reproduce the bug
(platform, version number, arguments, parameters, input files, etc.)
Also, please keep in mind that support is an all-volunteer effort.
In the near future, we will be moving away from mailing lists and towards
support forums. 
