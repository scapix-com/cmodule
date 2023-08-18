include(cmodule)

get_property(__cmodule_boost_guard GLOBAL PROPERTY __cmodule_boost_guard)
if(NOT __cmodule_boost_guard)
set_property(GLOBAL PROPERTY __cmodule_boost_guard ON)

cmodule_add(
  boost 1.83.0
  URL      "https://github.com/boostorg/boost/releases/download/boost-1.83.0/boost-1.83.0.7z"
  URL_HASH SHA256=0b37c3ed4c92167000e9d0af4ab382a46a7bd1b3534aa71eb07d4734f3980e55
  SOURCE_SUBDIR "nonexistent"
)

# Detect Boost version

file(STRINGS "${CMODULE_boost_SOURCE_DIR}/libs/config/include/boost/version.hpp" __cmodule_boost_version REGEX "define BOOST_VERSION ")
string(REGEX MATCH "[0-9]+" __cmodule_boost_version "${__cmodule_boost_version}")
math(EXPR BOOST_VERSION_MAJOR "${__cmodule_boost_version} / 100000")
math(EXPR BOOST_VERSION_MINOR "${__cmodule_boost_version} / 100 % 1000")
math(EXPR BOOST_VERSION_PATCH "${__cmodule_boost_version} % 100")
set(BOOST_VERSION "${BOOST_VERSION_MAJOR}.${BOOST_VERSION_MINOR}.${BOOST_VERSION_PATCH}")
unset(__cmodule_boost_version)

function(cmodule_boost_add_libraries)

  set(BUILD_TESTING OFF)

  if(NOT CMAKE_MSVC_RUNTIME_LIBRARY)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    if(NOT BOOST_RUNTIME_LINK STREQUAL "static")
      string(APPEND CMAKE_MSVC_RUNTIME_LIBRARY "DLL")
    endif()
  endif()

  foreach(lib IN ITEMS ${ARGN})
    get_property(guard GLOBAL PROPERTY __cmodule_boost_${lib}_guard)
    if(NOT guard)
      set_property(GLOBAL PROPERTY __cmodule_boost_${lib}_guard ON)

      if(lib STREQUAL "headers")
        file(GLOB path_list LIST_DIRECTORIES true "${CMODULE_boost_SOURCE_DIR}/libs/*")
        foreach(path IN LISTS path_list)
          if (IS_DIRECTORY "${path}/include")
            get_filename_component(include_dir "${path}/include" ABSOLUTE)
            list(APPEND include_list "${include_dir}")
          endif()
        endforeach()
        add_library(boost_headers INTERFACE)
        add_library(Boost::headers ALIAS boost_headers)
        target_include_directories(boost_headers INTERFACE ${include_list})
        continue()
      endif()

      if(lib STREQUAL "numeric_ublas")
        file(GLOB path_list LIST_DIRECTORIES true "${CMODULE_boost_SOURCE_DIR}/libs/*")
        foreach(path IN LISTS path_list)
          if (IS_DIRECTORY "${path}/include")
            get_filename_component(include_dir "${path}/include" ABSOLUTE)
            list(APPEND include_list "${include_dir}")
          endif()
        endforeach()
        add_library(boost_numeric_ublas INTERFACE)
        add_library(Boost::numeric_ublas ALIAS boost_numeric_ublas)
        target_include_directories(boost_numeric_ublas INTERFACE ${CMODULE_boost_SOURCE_DIR}/libs/numeric/ublas/include)
        continue()
      endif()

      string(REGEX REPLACE "^numeric_" "numeric/" lib ${lib})

      file(STRINGS "${CMODULE_boost_SOURCE_DIR}/libs/${lib}/CMakeLists.txt" data)
      set(dependencies "")
      foreach(line IN LISTS data)
        if(line MATCHES "^[ ]*Boost::([A-Za-z0-9_]+)[ ]*$")
          list(APPEND dependencies ${CMAKE_MATCH_1})
        endif()
      endforeach()
      cmodule_boost_add_libraries(${dependencies})

      cmodule_set_local_options()
      add_subdirectory(${CMODULE_boost_SOURCE_DIR}/libs/${lib} ${CMAKE_BINARY_DIR}/_deps/cmodule/boost/${lib})
      cmodule_restore_local_options()
    endif()
  endforeach()

endfunction()
endif()

cmodule_boost_add_libraries(headers ${${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS})
