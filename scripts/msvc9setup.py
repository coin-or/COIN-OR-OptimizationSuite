"""CCompiler implementation for the Microsoft Visual Studio 2008 compiler.

The MSVCCompiler class is compatible with VS 2005 and VS 2008.  Legacy
support for older versions of VS are in the msvccompiler module.
"""

# Written by Perry Stoll
# hacked by Robin Becker and Thomas Heller to do a better job of
#   finding DevStudio (through the registry)
# ported to VS2005 and VS 2008 by Christian Heimes
import os
import subprocess
import sys
import re

import cygwinreg as winreg

RegOpenKeyEx = winreg.OpenKeyEx
RegEnumKey = winreg.EnumKey
RegEnumValue = winreg.EnumValue
RegError = winreg.WindowsError

HKEYS = (winreg.HKEY_USERS,
         winreg.HKEY_CURRENT_USER,
         winreg.HKEY_LOCAL_MACHINE,
         winreg.HKEY_CLASSES_ROOT)

VS_BASE = r"Software\Microsoft\VisualStudio\%0.1f"
WINSDK_BASE = r"Software\Microsoft\Microsoft SDKs\Windows"
NET_BASE = r"Software\Microsoft\.NETFramework"

# A map keyed by get_platform() return values to values accepted by
# 'vcvarsall.bat'.  Note a cross-compile may combine these (eg, 'x86_amd64' is
# the param to cross-compile on x86 targetting amd64.)
PLAT_TO_VCVARS = {
    'win32' : 'x86',
    'win-amd64' : 'amd64',
    'win-ia64' : 'ia64',
}

class Reg:
    """Helper class to read values from the registry
    """

    def get_value(cls, path, key):
        for base in HKEYS:
            d = cls.read_values(base, path)
            if d and key in d:
                return d[key]
        raise KeyError(key)
    get_value = classmethod(get_value)

    def read_keys(cls, base, key):
        """Return list of registry keys."""
        try:
            handle = RegOpenKeyEx(base, key)
        except RegError:
            return None
        L = []
        i = 0
        while True:
            try:
                k = RegEnumKey(handle, i)
            except RegError:
                break
            L.append(k)
            i += 1
        return L
    read_keys = classmethod(read_keys)

    def read_values(cls, base, key):
        """Return dict of registry keys and values.

        All names are converted to lowercase.
        """
        try:
            handle = RegOpenKeyEx(base, key)
        except RegError:
            return None
        d = {}
        i = 0
        while True:
            try:
                name, value, type = RegEnumValue(handle, i)
            except RegError:
                break
            name = name.lower()
            d[cls.convert_mbcs(name)] = cls.convert_mbcs(value)
            i += 1
        return d
    read_values = classmethod(read_values)

    def convert_mbcs(s):
        dec = getattr(s, "decode", None)
        if dec is not None:
            try:
                s = dec("mbcs")
            except UnicodeError:
                pass
        return s
    convert_mbcs = staticmethod(convert_mbcs)

class MacroExpander:

    def __init__(self, version):
        self.macros = {}
        self.vsbase = VS_BASE % version
        self.load_macros(version)

    def set_macro(self, macro, path, key):
        self.macros["$(%s)" % macro] = Reg.get_value(path, key)

    def load_macros(self, version):
        self.set_macro("VCInstallDir", self.vsbase + r"\Setup\VC", "productdir")
        self.set_macro("VSInstallDir", self.vsbase + r"\Setup\VS", "productdir")
        self.set_macro("FrameworkDir", NET_BASE, "installroot")
        try:
            if version >= 8.0:
                self.set_macro("FrameworkSDKDir", NET_BASE,
                               "sdkinstallrootv2.0")
            else:
                raise KeyError("sdkinstallrootv2.0")
        except KeyError:
            raise Exception(
"""Python was built with Visual Studio 2008; extensions must be built with a
compiler than can generate compatible binaries. Visual Studio 2008 was not
found on this system. If you have Cygwin installed, you can try compiling
with MingW32, by passing "-c mingw32" to pysetup.""")

        if version >= 9.0:
            self.set_macro("FrameworkVersion", self.vsbase, "clr version")
            self.set_macro("WindowsSdkDir", WINSDK_BASE, "currentinstallfolder")
        else:
            p = r"Software\Microsoft\NET Framework Setup\Product"
            for base in HKEYS:
                try:
                    h = RegOpenKeyEx(base, p)
                except RegError:
                    continue
                key = RegEnumKey(h, 0)
                d = Reg.get_value(base, r"%s\%s" % (p, key))
                self.macros["$(FrameworkVersion)"] = d["version"]

    def sub(self, s):
        for k, v in self.macros.items():
            s = s.replace(k, v)
        return s

def get_build_version():
    """Return the version of MSVC that was used to build Python.

    For Python 2.3 and up, the version number is included in
    sys.version.  For earlier versions, assume the compiler is MSVC 6.
    """
    prefix = "MSC v."
    i = sys.version.find(prefix)
    if i == -1:
        return 6
    i = i + len(prefix)
    s, rest = sys.version[i:].split(" ", 1)
    majorVersion = int(s[:-2]) - 6
    minorVersion = int(s[2:3]) / 10.0
    # I don't think paths are affected by minor version in version 6
    if majorVersion == 6:
        minorVersion = 0
    if majorVersion >= 6:
        return majorVersion + minorVersion
    # else we don't know what version of the compiler this is
    return None

def normalize_and_reduce_paths(paths):
    """Return a list of normalized paths with duplicates removed.

    The current order of paths is maintained.
    """
    # Paths are normalized so things like:  /a and /a/ aren't both preserved.
    reduced_paths = []
    for p in paths:
        np = os.path.normpath(p)
        # XXX(nnorwitz): O(n**2), if reduced_paths gets long perhaps use a set.
        if np not in reduced_paths:
            reduced_paths.append(np)
    return reduced_paths

def removeDuplicates(variable):
    """Remove duplicate values of an environment variable.
    """
    oldList = variable.split(os.pathsep)
    newList = []
    for i in oldList:
        if i not in newList:
            newList.append(i)
    newVariable = os.pathsep.join(newList)
    return newVariable

def find_vcvarsall(version):
    """Find the vcvarsall.bat file

    At first it tries to find the productdir of VS 2008 in the registry. If
    that fails it falls back to the VS90COMNTOOLS env var.
    """
    vsbase = VS_BASE % version
    try:
        productdir = Reg.get_value(r"%s\Setup\VC" % vsbase,
                                   "productdir")
    except KeyError:
        print "Unable to find productdir in registry"
        productdir = None

    if not productdir or not os.path.isdir(productdir):
        toolskey = "VS%0.f0COMNTOOLS" % version
        print toolskey
        toolsdir = os.environ.get(toolskey, None)
        print toolsdir

        if toolsdir and os.path.isdir(toolsdir):
            productdir = os.path.join(toolsdir, os.pardir, os.pardir, "VC")
            productdir = os.path.abspath(productdir)
            if not os.path.isdir(productdir):
                print "%s is not a valid directory" % productdir
                return None
        else:
            print "env var %s is not set or invalid" % toolskey
    if not productdir:
        print "no productdir found"
        return None
    print productdir
    vcvarsall = os.path.join(productdir, "vcvarsall.bat")
    if os.path.isfile(vcvarsall):
        return vcvarsall
    print "unable to find vcvarsall.bat"
    return None

def query_vcvarsall(version, arch="x86"):
    """Launch vcvarsall.bat and read the settings from its environment
    """
#    vcvarsall = find_vcvarsall(version)
    interesting = set(("include", "lib", "libpath", "path"))
    result = {}

#    if vcvarsall is None:
#        raise Exception("Unable to find vcvarsall.bat")

    popen = subprocess.Popen('/cygdrive/c/Program Files (x86)/Microsoft Visual Studio 9.0/VC/bin/vcvars32.bat',
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE)
#    popen = subprocess.Popen('"%s" %s & set' % (vcvarsall, arch),
#                             stdout=subprocess.PIPE,
#                             stderr=subprocess.PIPE)
    popen = subprocess.Popen('set',
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE)

    stdout, stderr = popen.communicate()
    print stdout
    if popen.wait() != 0:
        raise Exception(stderr.decode("mbcs"))

    stdout = stdout.decode("mbcs")
    for line in stdout.split("\n"):
        line = Reg.convert_mbcs(line)
        if '=' not in line:
            continue
        line = line.strip()
        key, value = line.split('=', 1)
        key = key.lower()
        if key in interesting:
            if value.endswith(os.pathsep):
                value = value[:-1]
            result[key] = removeDuplicates(value)

    if len(result) != len(interesting):
        raise ValueError(str(list(result)))

    return result

# More globals
VERSION = get_build_version()
if VERSION < 8.0:
    print "VC %0.1f is not supported. Please set version explicitly" % VERSION

def setup_msvc_environment(build_plat, target_plat, version = VERSION):
    ok_plats = 'win32', 'win-amd64', 'win-ia64'
    if target_plat not in ok_plats:
        raise Exception("target_plat must be one of %s" %
                        (ok_plats,))

    # On x86, 'vcvars32.bat amd64' creates an env that doesn't work;
    # to cross compile, you use 'x86_amd64'.
    # On AMD64, 'vcvars32.bat amd64' is a native build env; to cross
    # compile use 'x86' (ie, it runs the x86 compiler directly)
    # No idea how itanium handles this, if at all.
    if target_plat == 'win32':
        # native build or cross-compile to win32
        plat_spec = PLAT_TO_VCVARS[target_plat]
    else:
        # cross compile from win32 -> some 64bit
        plat_spec = PLAT_TO_VCVARS[build_plat] + '_' + \
                    PLAT_TO_VCVARS[target_plat]

    vc_env = query_vcvarsall(version, plat_spec)

    # take care to only use strings in the environment.
    paths = vc_env['path'].split(os.pathsep)
    os.environ['lib'] = vc_env['lib']
    os.environ['include'] = vc_env['include']

    # extend the MSVC path with the current path
    try:
        for p in os.environ['path'].split(';'):
            paths.append(p)
    except KeyError:
        pass
    paths = normalize_and_reduce_paths(paths)
    print paths
    os.environ['path'] = ";".join(paths)

if __name__ == "__main__":

    setup_msvc_environment('win32', 'win32', 9.0)
