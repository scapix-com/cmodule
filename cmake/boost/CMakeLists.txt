cmake_minimum_required(VERSION 3.14)

project(boost)

if(NOT BOOST_SOURCE)
  set(BOOST_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}")
endif()

if(NOT BOOST_CMAKE_DIR)
  set(BOOST_CMAKE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
endif()

option(BOOST_DISABLE_TESTS "Do not build test targets, even if building standalone" OFF)

include(cmake/StandaloneBuild.cmake)
include(cmake/AddBoostLib.cmake)
include(cmake/AddBoostTest.cmake)

set_property(GLOBAL PROPERTY USE_FOLDERS TRUE)

macro(include_guarded file)
  get_property(guard GLOBAL PROPERTY CMODULE_GUARD_${file})
  if(NOT guard)
    set_property(GLOBAL PROPERTY CMODULE_GUARD_${file} TRUE)
    include("${file}")
  endif()
endmacro()

macro(boost_add_components)
  file(GLOB files "${BOOST_CMAKE_DIR}/libs/*.cmake")
  foreach(file ${files})
    get_filename_component(lib ${file} NAME_WLE)
    # In case only a subset of modules is available (eg. after using bcp)
    if(EXISTS "${BOOST_SOURCE}/libs/${lib}" AND (NOT BOOST_COMPONENTS OR lib IN_LIST BOOST_COMPONENTS))
      include_guarded("${BOOST_CMAKE_DIR}/libs/${lib}.cmake")
    endif()
  endforeach()
endmacro()

boost_add_components()
