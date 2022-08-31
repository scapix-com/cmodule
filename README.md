# cmodule

Non-intrusive CMake dependency management.

Normally CMake's find_package() looks for packages installed on host system (and compiled for host system).
When using **cmodule**, find_package() downloads packages and compiles them using current CMake toolchain.
This allows using C/C++ libraries (like boost) whether you are building for host system or cross-compiling for Android, iOS, WebAssembly, etc.

## CMake integration

After initializing cmodule, regular find_package() calls will work in top level CMake project and all subprojects:

```cmake
include(FetchContent)
FetchContent_Declare(
  cmodule
  URL "https://github.com/scapix-com/cmodule/archive/refs/tags/v1.0.36.tar.gz"
  URL_HASH SHA256=1abd27aa1338bd79daba32543fd7546342eaec949b29401d283a2434b8b568e9
)
FetchContent_MakeAvailable(cmodule)

find_package(Boost REQUIRED COMPONENTS filesystem iostreams)
target_link_libraries(mytarget PUBLIC Boost::filesystem Boost::iostreams)

find_package(ZLIB REQUIRED)
target_link_libraries(mytarget PRIVATE ZLIB::ZLIB)

find_package(BZip2 REQUIRED)
target_link_libraries(mytarget PRIVATE BZip2::BZip2)

find_package(CURL REQUIRED)
target_link_libraries(mytarget PRIVATE CURL::libcurl)
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
