# cmodule

Non-intrusive CMake dependency management.

Normally CMake's find_package() looks for packages installed on host system (and compiled for host system).
When using **cmodule**, find_package() downloads packages and compiles them for each target independently,
using current CMake toolchain. This, among other things, allows using C/C++ libraries (like boost)
when cross-compiling for Android, iOS, WebAssembly (Emscripten), etc.
Downloaded and unpacked sources are shared between targets, while binaries are compiled for each target independently.

## Getting started

After initializing cmodule, regular find_package() calls will work in top level CMake project and all subprojects:

```cmake
include(FetchContent)
FetchContent_Declare(
  cmodule
  URL "https://github.com/scapix-com/cmodule/archive/v1.0.4.tar.gz"
  URL_HASH SHA256=89171634a367cb580860c3cc2adbc93dda7c59fdcd03b2b8c92cc783eb5c5c92
)
FetchContent_MakeAvailable(cmodule)

find_package(Boost REQUIRED COMPONENTS filesystem iostreams)
target_link_libraries(${target} PUBLIC Boost::filesystem Boost::iostreams)

find_package(ZLIB REQUIRED)
target_link_libraries(${target} PRIVATE ZLIB::ZLIB)

find_package(BZip2 REQUIRED)
target_link_libraries(${target} PRIVATE BZip2::BZip2)
```

## More info

[Documentation](https://www.scapix.com/cmodule)\
[Example](https://github.com/scapix-com/cmodule_test)
