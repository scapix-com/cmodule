# Boost is added per library: only requested components (and their dependencies) are configured.

cmodule_recipe(boost
  VERSION 1.92.0
  PACKAGES Boost
  URL https://github.com/boostorg/boost/releases/download/boost-{version}/boost-{version}-cmake.tar.xz
  SHA256 9bed76128d4e46755dbe818487788c6fceb6f72b378f4daa49b7e1e600d9088d
  LICENSE BSL-1.0
  DOWNLOAD_ONLY
  COMPONENT_TARGETS Boost::{component}
  OPTIONS
    # Boost.Iostreams configure-time checks link LibLZMA in try_compile(), which can't use
    # targets built as part of the build. Answer them up front: cmodule's liblzma (>= 5.2) has lzma_cputhreads.
    BOOST_IOSTREAMS_HAS_LZMA_CPUTHREADS=ON
    # Upstream default (zstd::libzstd_shared) exists only for shared zstd
    BOOST_IOSTREAMS_ZSTD_TARGET=zstd::libzstd
  VARIABLES                                # FindBoost compatibility
    Boost_INCLUDE_DIRS={source_dir}
)

macro(cmodule_boost_configure)
  if(NOT CMAKE_MSVC_RUNTIME_LIBRARY)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    if(NOT BOOST_RUNTIME_LINK STREQUAL "static")
      string(APPEND CMAKE_MSVC_RUNTIME_LIBRARY "DLL")
    endif()
  endif()
endmacro()

# Boost::headers (all header directories) and compatibility targets

function(cmodule_boost_after)
  get_property(source_dir GLOBAL PROPERTY CMODULE_SOURCE_DIR_boost)

  file(GLOB path_list LIST_DIRECTORIES true "${source_dir}/libs/*" "${source_dir}/libs/numeric/*")
  set(include_list "")
  foreach(path IN LISTS path_list)
    if(IS_DIRECTORY "${path}/include")
      list(APPEND include_list "${path}/include")
    endif()
  endforeach()

  add_library(boost_headers INTERFACE)
  add_library(Boost::headers ALIAS boost_headers)
  target_include_directories(boost_headers SYSTEM INTERFACE ${include_list})

  add_library(Boost::boost INTERFACE IMPORTED GLOBAL)
  set_property(TARGET Boost::boost APPEND PROPERTY INTERFACE_LINK_LIBRARIES Boost::headers)

  add_library(Boost::diagnostic_definitions INTERFACE IMPORTED GLOBAL)
  add_library(Boost::disable_autolinking INTERFACE IMPORTED GLOBAL)
  add_library(Boost::dynamic_linking INTERFACE IMPORTED GLOBAL)

  if(WIN32)
    set_property(TARGET Boost::diagnostic_definitions PROPERTY INTERFACE_COMPILE_DEFINITIONS "BOOST_LIB_DIAGNOSTIC")
    set_property(TARGET Boost::disable_autolinking PROPERTY INTERFACE_COMPILE_DEFINITIONS "BOOST_ALL_NO_LIB")
    set_property(TARGET Boost::dynamic_linking PROPERTY INTERFACE_COMPILE_DEFINITIONS "BOOST_ALL_DYN_LINK")
  endif()

  set_property(GLOBAL PROPERTY CMODULE_BOOST_LIBRARY_headers TRUE)
endfunction()

function(cmodule_boost_components package)
  cmodule_boost_add_libraries(${ARGN})
endfunction()

# Add Boost libraries with their Boost dependencies (from Boost::<lib> lines in their CMakeLists.txt).
# Unknown components are skipped: generated package config reports them as not found.

function(cmodule_boost_add_libraries)
  get_property(source_dir GLOBAL PROPERTY CMODULE_SOURCE_DIR_boost)

  foreach(lib IN LISTS ARGN)
    if(lib STREQUAL "boost")
      continue()
    endif()

    get_property(added GLOBAL PROPERTY CMODULE_BOOST_LIBRARY_${lib})
    if(added)
      continue()
    endif()
    set_property(GLOBAL PROPERTY CMODULE_BOOST_LIBRARY_${lib} TRUE)

    string(REGEX REPLACE "^numeric_" "numeric/" path "${lib}")

    if(NOT EXISTS "${source_dir}/libs/${path}/CMakeLists.txt")
      continue()
    endif()

    file(STRINGS "${source_dir}/libs/${path}/CMakeLists.txt" lines)
    set(dependencies "")
    foreach(line IN LISTS lines)
      if(line MATCHES "^[ ]*Boost::([A-Za-z0-9_]+)[ ]*$")
        list(APPEND dependencies ${CMAKE_MATCH_1})
      endif()
    endforeach()

    cmodule_boost_add_libraries(${dependencies})
    cmodule_add_subdirectory(boost "${source_dir}/libs/${path}" "${CMAKE_BINARY_DIR}/_cmodule/boost-build/${path}")
  endforeach()
endfunction()
