# cmodule

🇺🇦 If you like this project, please consider donating to one of the funds helping victims of russian aggression against Ukraine: [ukraine.ua](https://war.ukraine.ua/donate/)

Non-intrusive CMake dependency management.

cmodule builds dependencies from source as part of your build, with your toolchain,
so the same project builds natively or cross-compiles for Android, iOS, WebAssembly, etc.

cmodule is a CMake dependency provider: your `CMakeLists.txt` contains only regular `find_package()` calls,
and users of your project can provide packages with cmodule or any other package manager.

Requires CMake 3.28 or newer.

## Setup

Download bootstrap file `cmake/cmodule.cmake` (pins the latest cmodule release by URL and hash) to your project:

```
curl -L --create-dirs -o cmake/cmodule.cmake https://github.com/scapix-com/cmodule/releases/latest/download/cmodule.cmake
```

Run the same command to upgrade to a new release (in Windows PowerShell 5.1, use `curl.exe`).

Add `CMakePresets.json`:

```json
{
  "version": 6,
  "configurePresets": [
    {
      "name": "default",
      "binaryDir": "${sourceDir}/build/${presetName}",
      "cacheVariables": {
        "CMAKE_PROJECT_TOP_LEVEL_INCLUDES": "${sourceDir}/cmake/cmodule.cmake"
      }
    }
  ]
}
```

Use regular `find_package()` in `CMakeLists.txt`:

```cmake
find_package(ZLIB REQUIRED)
target_link_libraries(mytarget PRIVATE ZLIB::ZLIB)
```

Build:

```
cmake --preset default
cmake --build build/default
```

Without presets: `cmake -B build -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=cmake/cmodule.cmake`

## More info

[Documentation](https://www.scapix.com/cmodule) (options, writing recipes, upgrading from v2)\
[Example](https://github.com/scapix-com/cmodule_test)
