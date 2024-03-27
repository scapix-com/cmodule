cmake_minimum_required(VERSION 3.14...3.26)

project(cmodule)

if(CMAKE_HOST_WIN32)
  set(CMODULE_USER_HOME_DIR "$ENV{USERPROFILE}")
else()
  set(CMODULE_USER_HOME_DIR "$ENV{HOME}")
endif()

if(NOT CMODULE_USER_HOME_DIR)
  set(CMODULE_USER_HOME_DIR "${CMAKE_SOURCE_DIR}")
endif()

set(CMODULE_CACHE_SOURCE_DIR ${CMODULE_USER_HOME_DIR}/.cmodule CACHE PATH "Folder to cache sources downloaded by cmodule, empty string to disable")
option(CMODULE_DISABLE_WARNINGS "Disable all compiler warnings and CMake deprecation warnings for libraries built by cmodule" ON)
option(BUILD_SHARED_LIBS "Build shared libraries" OFF)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} PARENT_SCOPE)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

macro(cmodule_set_local_options)
  set(CMODULE_BACKUP_CMAKE_FOLDER ${CMAKE_FOLDER})
  set(CMAKE_FOLDER "cmodule")

  if(CMODULE_DISABLE_WARNINGS)
    set(CMODULE_BACKUP_CMAKE_WARN_DEPRECATED ${CMAKE_WARN_DEPRECATED})
    set(CMAKE_WARN_DEPRECATED OFF CACHE BOOL "" FORCE)
  endif()

  get_property(CMODULE_BACKUP_COMPILE_OPTIONS DIRECTORY PROPERTY COMPILE_OPTIONS)
  if(CMODULE_DISABLE_WARNINGS AND DEFINED CMAKE_CXX_COMPILER_ID)
    if(${CMAKE_CXX_COMPILER_ID} STREQUAL MSVC)
      add_compile_options(/W0)
    else()
      add_compile_options(-w)
    endif()
  endif()
endmacro()

macro(cmodule_restore_local_options)
  set(CMAKE_FOLDER ${CMODULE_BACKUP_CMAKE_FOLDER})

  if(CMODULE_DISABLE_WARNINGS)
    set(CMAKE_WARN_DEPRECATED ${CMODULE_BACKUP_CMAKE_WARN_DEPRECATED} CACHE BOOL "" FORCE)
  endif()

  set_property(DIRECTORY PROPERTY COMPILE_OPTIONS ${CMODULE_BACKUP_COMPILE_OPTIONS})
endmacro()

macro(find_package_next name)
  set(TEMP ${CMAKE_MODULE_PATH})
  list(REMOVE_ITEM CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")
  find_package(${name})
  set(CMAKE_MODULE_PATH ${TEMP})
endmacro()

include(FetchContent)

function(cmodule_add name version)
  message(STATUS "cmodule: ${name} ${version}")

  cmake_parse_arguments(PARSE_ARGV 2 ARG "" "SOURCE_SUBDIR" "")

  set(content_name cmodule_${name})
  set(content_source_dir "")

  if(CMODULE_CACHE_SOURCE_DIR)
    set(source_dir ${CMODULE_CACHE_SOURCE_DIR}/${name}/${version})
    file(LOCK ${source_dir}.lock)
    string(TOUPPER ${content_name} upper_content_name)
    if (NOT FETCHCONTENT_SOURCE_DIR_${upper_content_name})
      file(GLOB source_dir_files ${source_dir}/*)
      if (source_dir_files)
        set(FETCHCONTENT_SOURCE_DIR_${upper_content_name} ${source_dir})
      else()
        set(content_source_dir SOURCE_DIR ${source_dir})
      endif()
    endif()
  endif()

  FetchContent_Declare(
    ${content_name}
    ${content_source_dir}
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    ${ARGN}
  )

  FetchContent_GetProperties(${content_name})
  string(TOLOWER ${content_name} lower_content_name)
  if(NOT ${lower_content_name}_POPULATED)
    FetchContent_Populate(${content_name})
    if(EXISTS "${${lower_content_name}_SOURCE_DIR}/${ARG_SOURCE_SUBDIR}/CMakeLists.txt")
      cmodule_set_local_options()
      add_subdirectory("${${lower_content_name}_SOURCE_DIR}/${ARG_SOURCE_SUBDIR}" "${${lower_content_name}_BINARY_DIR}" EXCLUDE_FROM_ALL)
      cmodule_restore_local_options()
    endif()
  endif()

  if(CMODULE_CACHE_SOURCE_DIR)
    file(LOCK ${source_dir}.lock RELEASE)
  endif()

  # Can also use FetchContent_GetProperties(cmodule_${name}), cmodule_${lower_name}_SOURCE_DIR / cmodule_${lower_name}_BINARY_DIR.
  set(CMODULE_${name}_SOURCE_DIR ${${lower_content_name}_SOURCE_DIR} PARENT_SCOPE)
  set(CMODULE_${name}_BINARY_DIR ${${lower_content_name}_BINARY_DIR} PARENT_SCOPE)

  string(TOUPPER ${CMAKE_FIND_PACKAGE_NAME} upper_find_package_name)
  set(${upper_find_package_name}_FOUND TRUE PARENT_SCOPE)
  set(${CMAKE_FIND_PACKAGE_NAME}_FOUND TRUE PARENT_SCOPE)
endfunction()
