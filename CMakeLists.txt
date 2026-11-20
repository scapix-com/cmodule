# cmodule 3
#
# Builds dependencies from source as part of your build, with your toolchain,
# so the same project works for native and any cross-compiling target.
#
# cmodule is a CMake dependency provider. It must be loaded via CMAKE_PROJECT_TOP_LEVEL_INCLUDES,
# typically with a small bootstrap file (see README.md):
#
#   cmake -B build -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=cmake/cmodule.cmake

cmake_minimum_required(VERSION 3.28...4.5)

# No project() call: this file is processed during the top level project() call,
# while languages are being enabled, where a nested project() call is an error.

# Require loading from CMAKE_PROJECT_TOP_LEVEL_INCLUDES
# (a file from that list must be on the include stack).

set(cmodule_top_level_include OFF)

if(CMAKE_PROJECT_TOP_LEVEL_INCLUDES)
  get_property(cmodule_listfile_stack DIRECTORY "${CMAKE_SOURCE_DIR}" PROPERTY LISTFILE_STACK)
  foreach(cmodule_include IN LISTS CMAKE_PROJECT_TOP_LEVEL_INCLUDES)
    file(REAL_PATH "${cmodule_include}" cmodule_include BASE_DIRECTORY "${CMAKE_SOURCE_DIR}")
    foreach(cmodule_file IN LISTS cmodule_listfile_stack)
      file(REAL_PATH "${cmodule_file}" cmodule_file)
      if(cmodule_file STREQUAL cmodule_include)
        set(cmodule_top_level_include ON)
      endif()
    endforeach()
  endforeach()
endif()

if(NOT cmodule_top_level_include)
  message(FATAL_ERROR
    "cmodule 3 must be loaded via CMAKE_PROJECT_TOP_LEVEL_INCLUDES, for example:\n"
    "  cmake -B build -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=cmake/cmodule.cmake\n"
    "Do not include() it from CMakeLists.txt.")
endif()

set(CMODULE_VERSION "3.0.0" CACHE INTERNAL "")
set(CMODULE_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "")

# Options

# Default source cache, same on all platforms:
#   1. CMODULE_CACHE_DIR environment variable (machine-wide override, e.g. Dev Drive or CI cache)
#   2. $XDG_CACHE_HOME/cmodule
#   3. ~/.cache/cmodule (home is %USERPROFILE% on Windows: HOME set by Git Bash/MSYS may be a Unix-style path)

if(CMAKE_HOST_WIN32)
  set(cmodule_home "$ENV{USERPROFILE}")
else()
  set(cmodule_home "$ENV{HOME}")
endif()

if(DEFINED ENV{CMODULE_CACHE_DIR})
  set(cmodule_default_cache_dir "$ENV{CMODULE_CACHE_DIR}")
elseif(DEFINED ENV{XDG_CACHE_HOME})
  set(cmodule_default_cache_dir "$ENV{XDG_CACHE_HOME}/cmodule")
elseif(cmodule_home)
  set(cmodule_default_cache_dir "${cmodule_home}/.cache/cmodule")
else()
  set(cmodule_default_cache_dir "")
endif()

file(TO_CMAKE_PATH "${cmodule_default_cache_dir}" cmodule_default_cache_dir)

set(CMODULE_CACHE_DIR "${cmodule_default_cache_dir}" CACHE PATH "Shared cache of downloaded sources, empty to disable")
set(CMODULE_RECIPE_PATH "" CACHE STRING "Overlay directories with recipes, searched before built-in recipes")
set(CMODULE_EXCLUDE "" CACHE STRING "Packages or recipes cmodule must not provide (left to regular find_package())")
option(CMODULE_SHARED "Build shared libraries (BUILD_SHARED_LIBS for dependencies)" OFF)
option(CMODULE_DISABLE_WARNINGS "Disable compiler warnings and CMake deprecation warnings for dependencies" ON)
set(CMODULE_ON_VERSION_MISMATCH "ERROR" CACHE STRING "Requested version not compatible with recipe: ERROR or FALLBACK (to regular find_package())")
set_property(CACHE CMODULE_ON_VERSION_MISMATCH PROPERTY STRINGS ERROR FALLBACK)

include(FetchContent)
include(CMakePackageConfigHelpers)

include("${CMAKE_CURRENT_LIST_DIR}/engine/recipe.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/engine/build.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/engine/package.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/engine/report.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/engine/provider.cmake")

cmodule_load_recipes()

cmake_language(SET_DEPENDENCY_PROVIDER cmodule_provide_dependency SUPPORTED_METHODS FIND_PACKAGE)
cmake_language(DEFER DIRECTORY "${CMAKE_SOURCE_DIR}" CALL cmodule_write_report)

message(STATUS "cmodule ${CMODULE_VERSION}: dependency provider enabled")
