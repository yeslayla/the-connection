#!python
import os, sys

opts = Variables([], ARGUMENTS)

# Gets the standard flags CC, CCX, etc.
env = DefaultEnvironment()

# Define our options
opts.Add(EnumVariable('target', "Compilation target", 'debug', ['d', 'debug', 'r', 'release']))
opts.Add(EnumVariable('platform', "Compilation platform", '', ['', 'windows', 'x11', 'linux', 'osx']))
opts.Add(EnumVariable('p', "Compilation target, alias for 'platform'", '', ['', 'windows', 'x11', 'linux', 'osx']))
opts.Add(BoolVariable('use_llvm', "Use the LLVM / Clang compiler", 'no'))
opts.Add(PathVariable('target_path', 'The path where the lib is installed.', 'client/bin/'))
opts.Add(PathVariable('target_name', 'The library name.', 'connection', PathVariable.PathAccept))

# Local dependency paths, adapt them to your setup
godot_headers_path = "godot-cpp/godot-headers/"
cpp_bindings_path = "godot-cpp/"
cpp_library = "libgodot-cpp"

# only support 64 at this time..
bits = 64

# Updates the environment with the option variables.
opts.Update(env)

# Process some arguments
if env['use_llvm']:
    env['CC'] = 'clang'
    env['CXX'] = 'clang++'

if env['p'] != '':
    env['platform'] = env['p']

if env['platform'] == '':
    print("No valid target platform selected.")
    quit();

# Try to detect the host platform automatically.
# This is used if no `platform` argument is passed
if sys.platform.startswith('linux'):
    host_platform = 'linux'
elif sys.platform == 'darwin':
    host_platform = 'osx'
elif sys.platform == 'win32' or sys.platform == 'msys':
    host_platform = 'windows'
else:
    raise ValueError(
        'Could not detect platform automatically, please specify with '
        'platform=<platform>'
    )

#############
## Mac OSX ##
#############
# Check our platform specifics
if env['platform'] == "osx":

    # Throw error if not running on Mac
    if host_platform != "osx":
        raise "Cross compile not supported for OSX!"

    env['target_path'] += 'osx/'
    cpp_library += '.osx'
    env['target_suffix'] = "dylib"
    env.Append(CCFLAGS=['-arch', 'x86_64'])
    env.Append(CXXFLAGS=['-std=c++17'])
    env.Append(LINKFLAGS=['-arch', 'x86_64'])
    if env['target'] in ('debug', 'd'):
          env.Append(CCFLAGS=['-g', '-O2'])
    else:
        env.Append(CCFLAGS=['-g', '-O3'])

###########
## Linux ##
###########
elif env['platform'] in ('x11', 'linux'):
    env['target_path'] += 'x11/'
    env['target_suffix'] = "so"
    cpp_library += '.linux'
    env.Append(CCFLAGS=['-fPIC'])
    env.Append(CXXFLAGS=['-std=c++17'])
    if env['target'] in ('debug', 'd'):
        env.Append(CCFLAGS=['-g3', '-Og'])
    else:
        env.Append(CCFLAGS=['-g', '-O3'])

#############
## Windows ##
#############
elif env['platform'] == "windows":
    env['target_path'] += 'win64/'
    cpp_library += '.windows'
    env['target_suffix'] = "dll"

    # Configure compiler for visual studio if bulding windows on windows
    if host_platform == 'windows' and not env['use_mingw']:
        # This makes sure to keep the session environment variables on windows,
        # that way you can run scons in a vs 2017 prompt and it will find all the required tools
        env.Append(ENV=os.environ)

        env.Append(CPPDEFINES=['WIN32', '_WIN32', '_WINDOWS', '_CRT_SECURE_NO_WARNINGS'])
        env.Append(CCFLAGS=['-W3', '-GR'])
        if env['target'] in ('debug', 'd'):
            env.Append(CPPDEFINES=['_DEBUG'])
            env.Append(CCFLAGS=['-EHsc', '-MDd', '-ZI'])
            env.Append(LINKFLAGS=['-DEBUG'])
        else:
            env.Append(CPPDEFINES=['NDEBUG'])
            env.Append(CCFLAGS=['-O2', '-EHsc', '-MD'])

    # Configure compiler for mingw if building for windows on another OS
    elif host_platform == 'linux' or host_platform == 'osx':
        # MinGW
        if bits == 64:
            env['CXX'] = 'x86_64-w64-mingw32-g++'
            env['AR'] = "x86_64-w64-mingw32-ar"
            env['RANLIB'] = "x86_64-w64-mingw32-ranlib"
            env['LINK'] = "x86_64-w64-mingw32-g++"
        elif bits == 32:
            env['CXX'] = 'i686-w64-mingw32-g++'
            env['AR'] = "i686-w64-mingw32-ar"
            env['RANLIB'] = "i686-w64-mingw32-ranlib"
            env['LINK'] = "i686-w64-mingw32-g++"

        env.Append(CCFLAGS=['-O3', '-std=c++14', '-Wwrite-strings'])
        env.Append(LINKFLAGS=[
            '--static',
            '-Wl,--no-undefined',
            '-static-libgcc',
            '-static-libstdc++',
        ])

if env['target'] in ('debug', 'd'):
    cpp_library += '.debug'
else:
    cpp_library += '.release'

cpp_library += '.' + str(bits)

# Add paths to libraries and dependencies
env.Append(CPPPATH=['.', godot_headers_path, cpp_bindings_path + 'include/', cpp_bindings_path + 'include/core/', cpp_bindings_path + 'include/gen/'])
env.Append(LIBPATH=[cpp_bindings_path + 'bin/'])
env.Append(LIBS=[cpp_library])

# Add project files
env.Append(CPPPATH=['src/'])
sources = Glob('src/*.cpp')

library = env.SharedLibrary(target=env['target_path'] + env['target_name'] + "." + env['target_suffix'], source=sources)

Default(library)

# Generates help for the -h scons option.
Help(opts.GenerateHelpText(env))
