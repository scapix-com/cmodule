# cmodule

Non-intrusive CMake dependency management.

Normally CMake's find_package() looks for packages installed on host system (and compiled for host system).
When using **cmodule**, find_package() downloads packages and compiles them for each target independently,
using current CMake toolchain. This, among other things, allows using C/C++ libraries (like boost)
when cross-compiling for Android, iOS, WebAssembly (Emscripten), etc.
Downloaded and unpacked sources are shared between targets, while binaries are compiled for each target independently.

## CMake integration

After initializing cmodule, regular find_package() calls will work in top level CMake project and all subprojects:

```cmake
include(FetchContent)
FetchContent_Declare(
  cmodule
  URL "https://github.com/scapix-com/cmodule/archive/refs/tags/v1.0.32.tar.gz"
  URL_HASH SHA256=e6937c95d73188a5add846b27cd00160fe4f6ea31af33be417d2ab7ac19bd8d2
)
FetchContent_MakeAvailable(cmodule)

find_package(Boost REQUIRED COMPONENTS filesystem iostreams)
target_link_libraries(${target} PUBLIC Boost::filesystem Boost::iostreams)

find_package(ZLIB REQUIRED)
target_link_libraries(${target} PRIVATE ZLIB::ZLIB)

find_package(BZip2 REQUIRED)
target_link_libraries(${target} PRIVATE BZip2::BZip2)
```

## How cmodule differs from other package managers?

Other package managers (like hunter), share binaries compiled for a particular target platform, but do not share download/unpack/store of library sources.
This is designed to save build time and disk space for situations when you have multiple independently built projects which use a lot of the same libraries.

cmodule does the opposite: it shares download/unpack/store of library sources, but does not share binaries compiled for a particular platform
(they are still shared between different targets in the same CMake build, but not between independently built CMake projects).
If your projects are built together (as part of the same CMake build), and you cross-compile for multiple platforms (just building all Android ABIs is 4 different platforms),
cmodule is a better choice: it shares download/unpack/store of library sources, while building libraries with EXACTLY the same CMake platform toolchain as the rest of the project.

## More info

[Documentation](https://www.scapix.com/cmodule)\
[Example](https://github.com/scapix-com/cmodule_test)
