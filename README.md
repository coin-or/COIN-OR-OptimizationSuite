# COIN-OR OPTIMIZATION SUITE

**Important notice: The master branch of the Optimization Suite does not currently include
all projects because we are mid-way through the migration to new build system and only 
projects that have been migrated are included. This is being actively worked on, but it will 
be some time before all projects are migrated. In the meantime, the stable/1.9 branch builds
out of the box using [coinbrew](https://github.com/coin-or/coinbrew).**

**An expanded version of this README that is updated with more details is available at**

https://coin-or.github.io/user_introduction.html

The COIN-OR Optimization Suite is a collection of interoperable open source
solvers from the respository of open source software maintained by the COIN-OR
Foundation. It consists of the following projects.

 * [CoinUtils](https://github.com/coin-or/CoinUtils) (COIN-OR utility library)
 * [Osi](https://github.com/coin-or/Osi) (Open Solver Interface)
 * [Clp](https://github.com/coin-or/Clp) (COIN-OR LP Solver)
 * [FlopCpp](https://github.com/coin-or/FlopCpp) (C++-based algebraic modeling language)
 * [DyLP](https://github.com/coin-or/DyLP) (LP solver based on dynamic simplex method)
 * [Vol](https://github.com/coin-or/Vol) (approximate LP solver based on Volume Algorithm)
 * [Cgl](http://projects.coin-or.org/Cgl) (Cut generation library)
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
 * [CppAD](https://github.com/coin-or/CppAD) (Automatic differentiation in C++)
 * [Bonmin](https://github.com/coin-or/Bonmin) (Solver for Convex MINLP)
 * [Couenne](https://github.com/coin-or/Couenne) (Solver for non-convex MINLP)
 * [OS](https://github.com/coin-or/OS) (Optimization Services)
 * [MibS](https://github.com/coin-or/MibS) (Mixed Integer Bilevel Solver)

# INSTALL

## Pre-built Binaries

Binaries for most platforms are available for download from [Bintray](https://bintray.com/coin-or/download/). 
Binaries can also be installed on specific platforms, as follows. AMPL also kindly provides executables of some 
solvers for download at

http://ampl.com/products/solvers/open-source/.

We are working on some other better ways of getting binaries, such as conda
packages, and will keep this README updated as things progress.

## Installers

### Windows

There is a Windows GUI installer available
[here](http://www.coin-or.org/download/binary/OptimizationSuite) for
installing libraries compatible with Visual Studio (you will need to install
the free Intel compiler redistributable libraries). This may get updated someday, but in the meantime, 
you can get binaries from [BinTray](http://bintray.com/coin-or/download).

### OS X

There are Homebrew recipes for some projects available [here](https://github.com/coin-or-tools/homebrew-coinor). Just do
```
brew tap coin-or-tools/coinor
brew install Xyz
```
It is also easy to build binaries from source with [coinbrew](https://github.com/coin-or/coinbrew).

### Linux 

For Linux, there are now Debian and Fedora packages for most projects in
the suite and we are investigating the possiblity of providing Linuxbrew
packages.
 * Click [here](https://packages.debian.org/search?keywords=coinor&searchon=names&suite=stable&section=all) for list of Debian packages.
 * Click [here](https://apps.fedoraproject.org/packages/s/coin-or) for a list of Fedora packages.
It is also easy to build binaries from source with [coinbrew](https://github.com/coin-or/coinbrew).

## Docker Image

The Docker image available at

https://hub.docker.com/r/tkralphs/coinor-optimization-suite/

is another excellent way to use the COIN-OR Optimization Suite, although it is currently out of date. For details on
how to obtain and use this image, see the project's Github page
[here](https://github.com/tkralphs/optimization-suite-docker).

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

### Building on Linux

Most Linux distributions come with all the required tools installed. To obtain
the source code, the first step is to get the installer that will then
fetch the source for `ProjName` and all its dependencies. *You do not need to
clone the repository first, just do the following!* Open a terminal and execute

```
git clone https://www.github.com/coin-or/coinbrew
```

Next, to check out source code for and build all the necessary projects
(including dependencies), execute the script in the `coinbrew`
subdirectory. To execute the script, do

```
cd coinbrew
chmod u+x coinbrew
./coinbrew
```

(Note: The `chmod` command is only needed if the execute permission is not
automatically set by git on cloning). Once you run the script,
you will be prompted interactively to select a project to fetch and build. The
rest should happen automagically. Alternatively, the following command-line
incantation will execute the procedure non-interactively.

```
./coinbrew fetch --no-prompt ProjName@stable/x.y
./coinbrew build --no-prompt ProjName --prefix=/path/to/install/dir
```
Note that the prefix specified above is the directory where the packages will be
installed. If the specified prefix is writable, then all packages will be
automatically installed immediately after building. If no prefix is specified,
the package will be installed in the directory dist/. Options that would have
been passed to the `configure` script under the old build system can simply be
added to the command-line. For example, to build with debugging symbols, do

```
./coinbrew build --no-prompt ProjName --prefix=/path/to/install/dir --enable-debug
```

To get help with additional options available in running the script, do

```
./coinbrew --help
```

After installation, you will also need to add `/path/to/install/dir/bin` to your
`PATH` variable in your `.bashrc` and also add `/path/to/install/dir/lib`
to your `LD_LIBRARY_PATH` if you want to link to COIN libraries. 

### Building on Windows (MSys2/CYGWIN and MinGW/MSVC)

By far, the easiest way to build on Windows is with the GNU autotools and the
GCC compilers. The first step is to install either
   * [Msys2](https://msys2.github.io/)
   * [CYGWIN](http://cygwin.org/)
   * [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
Bash and the gcc compilers also come with the [Anaconda Python distribution](https://www.anaconda.com/distribution/)

If you don't already have CYGWIN installed and don't want to fool around with
WSL (which is a great option if you already know your way around Unix), it is
recommended to use MSys2, since it provides a minimal toolset that is easy to
install. To get MSys2, either download the installer
[here](https://msys2.github.io/) or download and unzip MSys2 base from
[here](http://kent.dl.sourceforge.net/project/msys2/Base/x86_64/msys2-base-x86_64-20190512.tar.xz) 
(this is an out-of-date version, there may be a better place to get an archive
version). 

Following any of the above steps, you should have the `bash` command
(with Msys2, be sure to run `msys2_shell.bat` 
or manually add `msys64\usr\bin`, `msys64\mingw32\bin`, and
`msys64\mingw64\bin` to your Windows path).   

Once you have bash installed and in your `PATH`, open a Windows terminal and
type 

```
bash
pacman -S make wget tar patch dos2unix diffutils git svn
git clone https://www.github.com/coin-or/coinbrew
```
Next, to check out source code for and build all the necessary projects
(including dependencies), execute the script in the `COIN-OR-OptimizationSuite`
subdirectory. To execute the script, do

```
cd coinbrew
chmod u+x coinbrew
./coinbrew
```
(Note: The `chmod` command is only needed if the execute permission is not
automatically set by git on cloning). Once you run the script,
you will be prompted interactively to select a project to fetch and build. The
rest should happen automagically. Alternatively, the following command-line
incantation will execute the procedure non-interactively.

```
./coinbrew fetch --no-prompt ProjName@stable/x.y
./coinbrew build --no-prompt ProjName --prefix=C:\path\to\install\dir
```
Note that the prefix specified above is the directory where the packages will be
installed. If the specified prefix is writable, then all packages will be
automatically installed immediately after building. If no prefix is specified,
the package will be installed in the directory dist/. Options that would have
been passed to the `configure` script under the old build system can simply be
added to the command-line. For example, to build with debugging symbols, do
```
./coinbrew build --no-prompt ProjName --prefix=C:\path\to\install\dir --enable-debug
```

To get help with additional options available in running the script, do

```
./coinbrew --help
```

To use the resulting binaries and/or libraries, you will need to add the
full path of the directory `build\bin` to your Windows executable
search `PATH`, or, alternatively, copy the conents of the build directory to 
`C:\Program Files (x86)\ProjName` and add the directory
`C:\Program Files (x86)\ProjName\bin` 
to your Windows executable search `PATH`. You may also consider adding
`C:\Program Files (x86)\ProjName\lib` to the `LIB` path and 
`C:\Program Files (x86)\ProjName\include` to the `INCLUDE` path. 

It is possible to use almost the exact same commands to build with the Visual
Studio compilers. Before doing any of the above commands in the Windows
terminal, first run the `vcvarsall.bat` script for your version of Visual
Studio. Note that you will also need a compatible Fortran compiler if you want
to build any projects requiring Fortran (`ifort` is recommended, but not
free). Then follow all the steps above, but replace the `build` command
with

```
./coinbrew build --no-prompt ProjName --prefix=C:\path\to\install\dir --enable-msvc
```

## Building on Windows (Visual Studio IDE)

After obtaining source for the projects you want to build with [coinbrew](https://github.com/coin-or/coinbrew),
find the solution file in the directory `MSVisualStudio`. Note that some projects that require a Fortran compiler cannot be built this way. 

### Building on OS X

OS X is a Unix-based OS and ships with many of the basic components needed to
build COIN-OR, but it's missing some things. For examples, the latest versions
of OS X come with the `clang` compiler but no Fortran compiler. You may also
be missing the `wget` utility and `subversion` and `git` clients (needed for
obtaining source code). The easiest way to get these missing utilitites is to
install Homebrew (see http://brew.sh). After installation, open a terminal and
do

```
brew install gcc wget svn git
```

To obtain
the source code, the first step is to get the installer that will then
fetch the source for ProjName and all its dependencies. *You do not need to
clone ProjName first, just do the following!* Open a terminal and execute

```
git clone https://www.github.com/coin-or/coinbrew
```

Next, to check out source code for and build all the necessary projects
(including dependencies), execute the script in the `coinbrew`
subdirectory. To execute the script, do

```
cd coinbrew
chmod u+x coinbrew
./coinbrew
```

(Note: The `chmod` command is only needed if the execute permission is not
automatically set by git on cloning). Once you run the script,
you will be prompted interactively to select a project to fetch and build. The
rest should happen automagically. Alternatively, the following command-line
incantation will execute the procedure non-interactively.

```
./coinbrew fetch --no-prompt ProjName@stable/x.y
./coinbrew build --no-prompt ProjName --prefix=/path/to/install/dir
```
Note that the prefix specified above is the directory where the packages will be
installed. If the specified prefix is writable, then all packages will be
automatically installed immediately after building. If no prefix is specified,
the package will be installed in the directory dist/. Options that would have
been passed to the `configure` script under the old build system can simply be
added to the command-line. For example, to build with debugging symbols, do

```
./coinbrew build --no-prompt ProjName --prefix=/path/to/install/dir --enable-debug
```

To get help with additional options available in running the script, do

```
./coinbrew --help
```
After installation, you will also need to add `/path/to/install/dir/bin` to your
`PATH` variable in your `.bashrc` and also add `/path/to/install/dir/lib`
to your `DYLD_LIBRARY_PATH` if you want to link to COIN libraries. 

# Additional Useful Information

## Organization of the repositories

All projects are now (or will soon be) managed using `git`. Within
the repository, the development branch is `master`, while branches named 
`stable/x.y` contain long-running stable versions and tags names
`releases/x.y.z` indicate point releases. 

The source tree for the root of project Xxx currently looks something like this

```
ProjName/
doxydoc/
INSTALL.md
README.md
AUTHORS
Dependencies 
configure 
Makefile.am
... 
```

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

## About version numbers 

COIN numbers versions by a standard semantic versioning scheme: each version
has a *major*, *minor*, and *patch/release* number. All version within a
*major.minor* series are compatible. All versions within a *major* series are
backwards compatible. The versions with the `stable/` subdirectory have two
digits, e.g., `1.1`, whereas the releases have three digits, e.g., `2.1.0`.
The first two digits of the release version number indicates the stable series
of which the release is a snapshot. The third digit is the release number in
that series.

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
   arguments to `coinbrew build`, as follows:

   ```
   --enable-static \ 
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
 argument to `coinbrew`.  
 * Cbc has shared memory parallelism, which can be enabled with the
 `--enable-cbc-parallel` to `coinbrew` 
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
Individual project also have their own options.
 * `ProjName/configure --help` will list the options for project ProjName.
 * The options for individual projects can be given to the root `coinbrew`
 script---they will be passed on to subprojects automatically.

## Documentation

Some documentation on using the full optimization suite will someday be available at
http://coin-or.github.io/.
There is also a full tutorial on the Optimization Suite and much more at
http://coral.ie.lehigh.edu/~ted/teaching/coin-or.

User's manuals and documentation for project ProjName can be obtained at either
http://coin-or.github.io/ProjName or http://www.coin-or.org/ProjName.
Doxygen source code documentation for some projects can also be obtained at
http://coin-or.github.io/Doxygen

## Support

Support is available primarily through mailing lists and bug reports at
http://github.com/coin-orProjName/issues/new. 
