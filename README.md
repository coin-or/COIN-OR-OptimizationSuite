# COIN-OR OPTIMIZATION SUITE

[![Windows Builds](https://github.com/coin-or/COIN-OR-OptimizationSuite/actions/workflows/windows-ci.yml/badge.svg?branch=master)](https://github.com/coin-or/COIN-OR-OptimizationSuite/actions/workflows/windows-ci.yml?query=branch%3Amaster)
[![Linux and MacOS Builds](https://github.com/coin-or/COIN-OR-OptimizationSuite/actions/workflows/linux-ci.yml/badge.svg?branch=master)](https://github.com/coin-or/COIN-OR-OptimizationSuite/actions/workflows/linux-ci.yml?query=branch%3Amaster)

**The master branch of the Optimization Suite lists the master branches of
all its projects, which use the new build system, in
[.coin-or/config.yml](.coin-or/config.yml). It builds out of the box using
[coinbrew](https://github.com/coin-or/coinbrew), which fetches, builds, and
installs the projects; this repository itself has nothing to build. The
stable/1.9 branch contains the latest stable versions, which use the old build
system.**

**An expanded version of this README that is updated with more details is available at**

https://coin-or.github.io/user_introduction.html

The COIN-OR Optimization Suite is a collection of interoperable open source
solvers from the repository of open source software maintained by the COIN-OR
Foundation. It consists of the following projects.

 * [CoinUtils](https://github.com/coin-or/CoinUtils) (COIN-OR utility library)
 * [Osi](https://github.com/coin-or/Osi) (Open Solver Interface)
 * [Clp](https://github.com/coin-or/Clp) (COIN-OR LP Solver)
 * [FlopCpp](https://github.com/coin-or/FlopCpp) (C++-based algebraic modeling language)
 * [DyLP](https://github.com/coin-or/DyLP) (LP solver based on dynamic simplex method)
 * [Vol](https://github.com/coin-or/Vol) (approximate LP solver based on Volume Algorithm)
 * [Cgl](https://github.com/coin-or/Cgl) (Cut generation library)
 * [SYMPHONY](https://github.com/coin-or/SYMPHONY) (MILP solver framework)
 * [Cbc](https://github.com/coin-or/Cbc) (COIN-OR branch-and-cut MILP solver)
 * [Smi](https://github.com/coin-or/Smi) (Stochastic modeling interface)
 * [CoinMP](https://github.com/coin-or/CoinMP) (Unified C API for Cbc and Clp)
 * [Bcp](https://github.com/coin-or/Bcp) (Branch, cut, and price framework)
 * [Ipopt](https://github.com/coin-or/Ipopt) (Interior point algorithm for non-linear optimization)
 * CHiPPS (COIN-OR High Performance Parallel Search framework)
   * [Alps](https://github.com/coin-or/CHiPPS-ALPS) (Abstract Library for Parallel Search)
   * [BiCePS](https://github.com/coin-or/CHiPPS-BiCePS) (Branch, Constrain, and Price Software)
   * [Blis](https://github.com/coin-or/CHiPPS-BLIS) (BiCePS Linear Integer Solver)
 * [Dip](https://github.com/coin-or/Dip) (Decomposition-based MILP solver framework)
 * [CppAD](https://github.com/coin-or/CppAD) (Automatic differentiation in C++; it
   is built with CMake, not with `coinbrew`, so install it separately, e.g.,
   from a package manager, if you need it for OS)
 * [Bonmin](https://github.com/coin-or/Bonmin) (Solver for Convex MINLP)
 * [Couenne](https://github.com/coin-or/Couenne) (Solver for non-convex MINLP)
 * [OS](https://github.com/coin-or/OS) (Optimization Services)
 * [MibS](https://github.com/coin-or/MibS) (Mixed Integer Bilevel Solver)

# INSTALL

## Pre-built Binaries

Binaries for the releases of the projects are attached to their releases on
GitHub, e.g., [here](https://github.com/coin-or/Cbc/releases) for Cbc.
Binaries of older releases are archived
[here](https://www.coin-or.org/download/binary). AMPL also kindly provides
executables of some solvers for download
[here](https://ampl.com/products/solvers/open-source-solvers/).

Many of the projects are also available from package managers.

 * *conda* (all platforms): [conda-forge](https://conda-forge.org) has
   packages of, among others, Cbc, Clp, Cgl, Osi, CoinUtils, Ipopt, Bonmin, and
   CoinMP, e.g.,
   ```
   conda install -c conda-forge coin-or-cbc ipopt
   ```
 * *Homebrew* (macOS and Linux): Homebrew has formulas for Cbc, Clp, Cgl, Osi,
   CoinUtils, and Ipopt, and the
   [coin-or-tools/coinor](https://github.com/coin-or-tools/homebrew-coinor) tap
   has formulas for some more projects, such as SYMPHONY, DyLP, and Vol, e.g.,
   ```
   brew install cbc
   brew tap coin-or-tools/coinor
   brew install coin-or-tools/coinor/symphony
   ```
 * *Linux distributions*: Debian and Ubuntu (packages
   [coinor-*](https://packages.debian.org/search?keywords=coinor&searchon=names&suite=stable&section=all)),
   Fedora (packages
   [coin-or-*](https://packages.fedoraproject.org/search?query=coin-or)), and
   other distributions have packages of many of the projects. See
   [repology](https://repology.org/projects/?search=coin-or) for a listing.
 * *MSYS2* (Windows): MSYS2 has packages of, among others, Cbc, Clp, Cgl, Osi,
   CoinUtils, and CoinMP (`mingw-w64-ucrt-x86_64-coin-or-cbc` etc.).

## Docker Image

The Docker image available at

https://hub.docker.com/r/coinor/coin-or-optimization-suite

is another way to use the COIN-OR Optimization Suite. For details on how to
obtain and use this image, see the project's Github page
[here](https://github.com/tkralphs/optimization-suite-docker).

## Other Installation Methods

Other ways of obtaining COIN-OR solvers include downloading them through a
number of modeling languages and front-ends. For example, COIN-OR solvers can
be used through
 * [GAMS](https://www.gams.com/latest/docs/S_MAIN.html),
 * [AMPL](https://ampl.com/products/solvers/open-source-solvers/),
 * [MPL](https://www.maximalsoftware.com/solvers/coin.html),
 * [JuMP](https://jump.dev) (Julia), e.g., with the packages Cbc.jl, Clp.jl,
   and Ipopt.jl,
 * Python, e.g., with [Pyomo](https://www.pyomo.org),
   [PuLP](https://github.com/coin-or/pulp), or
   [CyLP](https://github.com/coin-or/CyLP),
 * MATLAB, with the [OPTI Toolbox](https://github.com/jonathancurrie/OPTI),
 * [R](https://www.r-project.org/): Packages available
 [here](https://bioconductor.org/packages/devel/bioc/html/lpsymphony.html) or
 [here](https://cran.r-project.org/web/packages/Rsymphony/index.html) or
 [here](https://github.com/vladchimescu/lpsymphony),
 * [OpenSolver](https://opensolver.org), and
 * [SolverStudio](https://solverstudio.org).

# Building from Source

Why download and build COIN-OR yourself? There are many options for building
COIN-OR codes and the distributed binaries are built with just one set of
options. We cannot distribute binaries linked to libraries licensed under the
GPL, so you must build yourself if you want GMPL, command completion, command
history, Haskell libraries, etc. Other advanced options that require specific
hardware/software may also not be supported in distributed binaries (parallel
builds, MPI). Once you understand how to get and build source, it is much
faster to get bug fixes.

The easiest way to get and build the source code is the
[coinbrew](https://github.com/coin-or/coinbrew) script, which fetches the
source code of a project and all its dependencies, and then builds and
installs them. The tools it needs are described below for each platform,
followed by the instructions for using it, which are the same on all of them.

## Prerequisites

### Linux

Most Linux distributions come with the basic tools (`bash`, `make`, C and C++
compilers, `git`, `wget`). Some projects also need a Fortran compiler (e.g.,
for MUMPS, which Ipopt uses), and it is easiest to get BLAS, LAPACK, and Metis
from the distribution. For example, on Debian and Ubuntu, do

```
sudo apt install build-essential gfortran git wget pkg-config liblapack-dev libmetis-dev
```

### macOS

macOS ships with many of the basic components (the `clang` compiler comes
with the Xcode command line tools), but it's missing some things: `coinbrew`
needs `bash` 4 or later (macOS ships with version 3.2), and there is no Fortran
compiler. The easiest way to get these missing utilities is to install
[Homebrew](https://brew.sh). After installation, open a terminal and do

```
xcode-select --install
brew install bash gcc wget pkg-config
```

### Windows

By far, the easiest way to build on Windows is with the GNU autotools and the
GCC compilers. The first step is to install one of
 * [MSYS2](https://www.msys2.org) (recommended),
 * [CYGWIN](https://cygwin.org), or
 * [Windows Subsystem for Linux](https://learn.microsoft.com/windows/wsl/install)
   (then follow the instructions for Linux).

With MSYS2, open the "MSYS2 UCRT64" shell from the Start menu and install the
tools, compilers, and libraries:

```
pacman -S make wget tar patch dos2unix diffutils git pkgconf \
  mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-gcc-fortran \
  mingw-w64-ucrt-x86_64-lapack mingw-w64-ucrt-x86_64-metis
```

It is possible to use almost the exact same commands to build with the Visual
Studio compilers. Before running `coinbrew`, first run the `vcvarsall.bat`
script for your version of Visual Studio. Note that you will also need a
compatible Fortran compiler if you want to build any projects requiring
Fortran (such as the Intel Fortran compiler). Then add `--enable-msvc` to the
`build` command below.

## Building with coinbrew

To obtain the source code, the first step is to get `coinbrew`, which will
then fetch the source for `ProjName` and all its dependencies. *You do not need
to clone the repository of `ProjName` first, just do the following!* Open a
terminal and execute

```
git clone https://github.com/coin-or/coinbrew
cd coinbrew
./coinbrew
```

Once you run the script, you will be prompted interactively to select a
project to fetch and build. The rest should happen automagically.
Alternatively, the following command-line incantation will execute the
procedure non-interactively.

```
./coinbrew fetch ProjName@master --no-prompt
./coinbrew build ProjName --no-prompt --prefix=/path/to/install/dir
```

To get the whole Optimization Suite, use `COIN-OR-OptimizationSuite` as
`ProjName`, e.g.,

```
./coinbrew fetch COIN-OR-OptimizationSuite@master --no-prompt
```

Note that the prefix specified above is the directory where the packages will
be installed. If the specified prefix is writable, then all packages will be
automatically installed immediately after building. If no prefix is
specified, the packages will be installed in the directory `dist`. Options for
the `configure` scripts of the projects can simply be added to the command
line. For example, to build with debugging symbols, do

```
./coinbrew build ProjName --no-prompt --prefix=/path/to/install/dir --enable-debug
```

To get help with additional options available in running the script, do

```
./coinbrew --help
```

After installation, you will also need to add `/path/to/install/dir/bin` to
your `PATH` and, on Linux, `/path/to/install/dir/lib` to your
`LD_LIBRARY_PATH` (on macOS, `DYLD_LIBRARY_PATH`) if you want to link to
COIN-OR libraries. On Windows, add the `bin` directory of the installation to
your `PATH` (it contains the DLLs), and possibly its `lib` directory to `LIB`
and its `include` directory to `INCLUDE`.

## Building on Windows (Visual Studio IDE)

Some projects (e.g., Cbc, Clp, Cgl, Osi, CoinUtils, and SYMPHONY) have Visual
Studio solution files in the directory `MSVisualStudio`. After obtaining the
source code for the projects you want to build with
[coinbrew](https://github.com/coin-or/coinbrew), open the solution file. Note
that projects that require a Fortran compiler cannot be built this way.

# Additional Useful Information

## Organization of the repositories

All projects are managed using `git` and hosted on
[GitHub](https://github.com/coin-or). Within the repository, the development
branch is `master`, while branches named `stable/x.y` contain long-running
stable versions and tags named `releases/x.y.z` indicate point releases.

In the master branches of the projects, which use the new build system, the
source tree of project `ProjName` looks something like this.

```
.coin-or/
  config.yml
  Dependencies
src/
examples/
test/
doxydoc/
AUTHORS
README.md
LICENSE
configure
Makefile.am
...
```

`.coin-or/config.yml` lists the other projects that the project depends on,
and `coinbrew` uses it to fetch them. In the stable branches, which use the old
build system, the files for building the library of project `ProjName` are
in a subdirectory `ProjName`, and the root of the repository contains a
`configure` script that builds the project together with its dependencies.

## About version numbers

COIN-OR numbers versions by a standard semantic versioning scheme: each
version has a *major*, *minor*, and *patch/release* number. All versions
within a *major.minor* series are compatible. All versions within a *major*
series are backwards compatible. The stable branches have two digits, e.g.,
`stable/1.1`, whereas the releases have three digits, e.g., `releases/2.1.0`.
The first two digits of the release version number indicate the stable series
of which the release is a snapshot. The third digit is the release number in
that series.

## ThirdParty Projects

There are a number of open-source projects that COIN-OR projects can link to,
but whose source we do not distribute. For these, there are ThirdParty
projects with scripts for downloading their source code (named
`get.ProjName`) and a build harness for building them, which also produces
libraries and pkg-config files. `coinbrew` fetches the ThirdParty projects
that a project depends on (the optional ones only with `--enable-optional`),
runs their download scripts, and builds them. Some of these libraries (e.g.,
BLAS, LAPACK, and Metis) can also be taken from the system. Beware of
licensing incompatibilities if you plan to redistribute the resulting
binaries. The following are the supported libraries.
 * AMPL Solver Library (required to use solvers with AMPL)
 * BLAS (improves performance---usually available natively on Linux/macOS)
 * LAPACK (same as BLAS)
 * GLPK
 * Metis
 * MUMPS (required for Ipopt to build completely open source)
 * SoPlex
 * SCIP
 * HSL (an alternative to MUMPS that is not open source)
 * FilterSQP

## Parallel Builds

`SYMPHONY`, `DIP`, `CHiPPS`, and `Cbc` all include the ability to solve in
parallel.
 * CHiPPS uses MPI and is targeted at massive parallelism (it would be
   possible to develop a hybrid algorithm, however). To build in parallel,
   specify the compiler and linker flags for MPI with the `--with-mpi-cflags`
   and `--with-mpi-lflags` arguments to `coinbrew build`, e.g.,

   ```
   --enable-static \
   --disable-shared \
   --with-mpi-cflags=-I/usr/include/mpich \
   --with-mpi-lflags="-L/usr/lib -lmpich" \
   MPICC=mpicc \
   MPICXX=mpic++
   ```

 * SYMPHONY has both shared and distributed memory parallel modes, but we'll
 only discuss the shared memory capability here. It is enabled by default if
 the compiler supports OpenMP (`gcc` and Microsoft's `cl` both do, but `clang`
 does not). To disable shared memory parallel mode, use the
 `--disable-openmp` argument to `coinbrew`.
 * Cbc has shared memory parallelism, which is enabled by default; it can be
 disabled with the `--disable-cbc-parallel` argument to `coinbrew`.
 * DIP currently has a shared memory parallel mode that works the same way as
 SYMPHONY's.

## Other Configure-time Options

There are many configure options for customizing the builds, which is the
advantage of learning to build yourself.
 * Over-riding variables: `CC`, `CXX`, `F77`, `ADD_CFLAGS`, `ADD_CXXFLAGS`
 * `--prefix`
 * `--enable-debug`
 * `--disable-shared` (build static libraries)
 * `--disable-readline`, `--disable-zlib`, `--disable-bzlib` (the GNU
   packages readline, zlib, and bzlib are used by default if they are found)
 * `-C`

Individual projects also have their own options.
 * `configure --help` in the source directory of project ProjName will list
   the options for ProjName.
 * The options for individual projects can be given to `coinbrew`---they will
   be passed on to the projects automatically.

## Documentation

More documentation on using the full Optimization Suite is available at
https://coin-or.github.io/.

User's manuals and documentation for project ProjName can be found in the
README of the project at https://github.com/coin-or/ProjName. Doxygen source
code documentation for many projects is available at
https://coin-or.github.io/ProjName/Doxygen.

## Support

Support is available primarily through the issue trackers and discussion
forums of the projects on GitHub, at https://github.com/coin-or/ProjName/issues
and https://github.com/coin-or/ProjName/discussions.
