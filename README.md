# cmodule

🇺🇦 If you like this project, please consider donating to one of the funds helping victims of russian aggression against Ukraine: [ukraine.ua](https://war.ukraine.ua/donate/)

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
  URL "https://github.com/scapix-com/cmodule/archive/refs/tags/v2.0.0.tar.gz"
  URL_HASH SHA256=58695a9d73dc95a2c214097729917c7d9c366bf511e162d566cf55dd2b9cd7be
)
FetchContent_MakeAvailable(cmodule)

find_package(Boost REQUIRED COMPONENTS filesystem)
target_link_libraries(mytarget PUBLIC Boost::filesystem)

find_package(Boost REQUIRED COMPONENTS iostreams)
target_link_libraries(mytarget PUBLIC Boost::iostreams)

find_package(ZLIB REQUIRED)
target_link_libraries(mytarget PRIVATE ZLIB::ZLIB)

find_package(BZip2 REQUIRED)
target_link_libraries(mytarget PRIVATE BZip2::BZip2)

find_package(CURL REQUIRED)
target_link_libraries(mytarget PRIVATE CURL::libcurl)
```

## How cmodule differs from other package managers?

Instead of providing compiled binaries, cmodule builds libraries as part of your project build.

This has multiple advantages:

- libraries seamlessly build for any target, including cross-compiling targets (iOS, Android, etc.)
- libraries build using the same settings (compiler options) as the rest of the project
- non intrusive syntax: automatically works for projects with regular find_package() calls
- downloaded and extracted sources are cached by cmodule to speedup builds for different targets and builds of different projects

## More info

[Documentation](https://www.scapix.com/cmodule)\
[Example](https://github.com/scapix-com/cmodule_test)
