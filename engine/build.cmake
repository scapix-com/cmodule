# Download (with shared cache) and add a recipe to the build, isolated from the requesting directory.

function(cmodule_host out_var)
  set(${out_var} "${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}" PARENT_SCOPE)
endfunction()

# Replace {placeholders} in a recipe value.

function(cmodule_expand recipe value out_var)
  cmodule_host(host)
  cmodule_recipe_get(${recipe} VERSION version)
  get_property(source_dir GLOBAL PROPERTY CMODULE_SOURCE_DIR_${recipe})
  get_property(binary_dir GLOBAL PROPERTY CMODULE_BINARY_DIR_${recipe})

  if(CMODULE_SHARED)
    set(shared ON)
    set(static OFF)
  else()
    set(shared OFF)
    set(static ON)
  endif()

  foreach(name IN ITEMS host version source_dir binary_dir shared static)
    string(REPLACE "{${name}}" "${${name}}" value "${value}")
  endforeach()

  while(value MATCHES "{location:([^}]+)}")
    set(target "${CMAKE_MATCH_1}")
    if(NOT TARGET "${target}")
      message(FATAL_ERROR "cmodule recipe ${recipe}: {location:${target}}: no such target")
    endif()
    get_target_property(location "${target}" IMPORTED_LOCATION)
    string(REPLACE "{location:${target}}" "${location}" value "${value}")
  endwhile()

  set(${out_var} "${value}" PARENT_SCOPE)
endfunction()

# Isolation for adding dependency sources to the build.
#
# Macros: they set variables in the calling function's scope, which the added subdirectory inherits.
# Variables don't leak back to the requesting directory, because callers are functions.
#
# Kept from the project: toolchain, CMAKE_<LANG>_FLAGS, configurations, language standards,
# CMAKE_MSVC_RUNTIME_LIBRARY, CMAKE_POSITION_INDEPENDENT_CODE, etc.
# Dropped: directory properties of whichever directory happened to request the package first.

macro(cmodule_isolation_begin recipe)
  set(CMAKE_POLICY_DEFAULT_CMP0077 NEW) # option() honors normal variables
  set(CMAKE_POLICY_DEFAULT_CMP0126 NEW) # set(CACHE) doesn't override normal variables
  set(BUILD_TESTING OFF)
  set(BUILD_SHARED_LIBS ${CMODULE_SHARED})
  set(CMAKE_COMPILE_WARNING_AS_ERROR OFF)
  set(CMAKE_FOLDER "cmodule")

  cmodule_recipe_get(${recipe} OPTIONS _cmodule_options)
  foreach(_cmodule_option IN LISTS _cmodule_options)
    if(NOT _cmodule_option MATCHES "^([^=]+)=(.*)$")
      message(FATAL_ERROR "cmodule recipe ${recipe}: OPTIONS entry must be <var>=<value>: ${_cmodule_option}")
    endif()
    set(_cmodule_option_name "${CMAKE_MATCH_1}")
    cmodule_expand(${recipe} "${CMAKE_MATCH_2}" ${_cmodule_option_name})
  endforeach()

  set(_cmodule_directory_properties COMPILE_OPTIONS COMPILE_DEFINITIONS INCLUDE_DIRECTORIES LINK_OPTIONS LINK_DIRECTORIES)

  foreach(_cmodule_property IN LISTS _cmodule_directory_properties)
    get_property(_cmodule_saved_${_cmodule_property} DIRECTORY PROPERTY ${_cmodule_property})
    set_property(DIRECTORY PROPERTY ${_cmodule_property} "")
  endforeach()

  if(CMODULE_DISABLE_WARNINGS)
    if(MSVC)
      add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/W0>)
    else()
      add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:-w>)
    endif()

    # CMake 4.4+: see cmodule_diagnostics_begin()
    if(CMAKE_VERSION VERSION_LESS "4.4")
      set(_cmodule_saved_warn_deprecated "${CMAKE_WARN_DEPRECATED}")
      set(CMAKE_WARN_DEPRECATED OFF CACHE BOOL "" FORCE)
    endif()
  endif()

  # Recipe hook (should be a macro if it sets variables)

  if(COMMAND cmodule_${recipe}_configure)
    cmake_language(CALL cmodule_${recipe}_configure)
  endif()
endmacro()

macro(cmodule_isolation_end)
  if(CMODULE_DISABLE_WARNINGS AND CMAKE_VERSION VERSION_LESS "4.4")
    set(CMAKE_WARN_DEPRECATED "${_cmodule_saved_warn_deprecated}" CACHE BOOL "" FORCE)
  endif()

  foreach(_cmodule_property IN LISTS _cmodule_directory_properties)
    set_property(DIRECTORY PROPERTY ${_cmodule_property} "${_cmodule_saved_${_cmodule_property}}")
  endforeach()
endmacro()

# Add a subdirectory of a recipe's sources, with isolation. For recipe hooks (e.g. per-library builds).

function(cmodule_add_subdirectory recipe source_dir binary_dir)
  if(CMODULE_DISABLE_WARNINGS AND CMAKE_VERSION VERSION_GREATER_EQUAL "4.4")
    cmake_diagnostic(PUSH) # PUSH/POP must be in the same function, can't be split between macros
    cmake_diagnostic(SET CMD_DEPRECATED IGNORE)
  endif()

  cmodule_isolation_begin(${recipe})
  add_subdirectory("${source_dir}" "${binary_dir}" EXCLUDE_FROM_ALL SYSTEM)
  cmodule_isolation_end()

  if(CMODULE_DISABLE_WARNINGS AND CMAKE_VERSION VERSION_GREATER_EQUAL "4.4")
    cmake_diagnostic(POP)
  endif()
endfunction()

function(cmodule_make_available recipe)
  get_property(state GLOBAL PROPERTY CMODULE_STATE_${recipe})

  if(state STREQUAL "done")
    return()
  elseif(state STREQUAL "building")
    message(FATAL_ERROR "cmodule: dependency cycle involving recipe ${recipe}")
  endif()

  set_property(GLOBAL PROPERTY CMODULE_STATE_${recipe} building)

  foreach(field IN LISTS cmodule_recipe_fields)
    cmodule_recipe_get(${recipe} ${field} r_${field})
  endforeach()

  cmodule_host(host)
  cmodule_expand(${recipe} "${r_URL}" url)
  set(sha256 "${r_SHA256}")

  if(r_HOST_PREBUILT)
    set(sha256 "")
    foreach(entry IN LISTS r_HOST_SHA256)
      if(entry MATCHES "^${host}=(.+)$")
        set(sha256 "${CMAKE_MATCH_1}")
      endif()
    endforeach()
    if(NOT sha256)
      message(FATAL_ERROR "cmodule recipe ${recipe}: no prebuilt binaries for host ${host}")
    endif()
    set(r_DOWNLOAD_ONLY TRUE)
  endif()

  if(r_DOWNLOAD_ONLY)
    set(r_SOURCE_SUBDIR "cmodule-download-only")
  endif()

  # Source location: user override (FETCHCONTENT_SOURCE_DIR_<NAME>), shared cache, or default.

  string(TOUPPER "${recipe}" upper_recipe)
  set(source_args "")
  set(local_override "")
  set(cache_hit FALSE)

  # FetchContent copies FETCHCONTENT_SOURCE_DIR_<NAME> to the cache. A value pointing into cmodule's
  # source cache was set by cmodule (possibly for an older recipe version), not by the user.

  if(CMODULE_CACHE_DIR AND FETCHCONTENT_SOURCE_DIR_${upper_recipe})
    cmake_path(IS_PREFIX CMODULE_CACHE_DIR "${FETCHCONTENT_SOURCE_DIR_${upper_recipe}}" NORMALIZE ours)
    if(ours)
      unset(FETCHCONTENT_SOURCE_DIR_${upper_recipe} CACHE)
      unset(FETCHCONTENT_SOURCE_DIR_${upper_recipe})
    endif()
  endif()

  if(FETCHCONTENT_SOURCE_DIR_${upper_recipe})
    set(local_override "${FETCHCONTENT_SOURCE_DIR_${upper_recipe}}")
  elseif(CMODULE_CACHE_DIR)
    string(SUBSTRING "${sha256}" 0 12 short_hash)
    set(cache_dir "${CMODULE_CACHE_DIR}/${recipe}/${r_VERSION}-${short_hash}")
    file(MAKE_DIRECTORY "${CMODULE_CACHE_DIR}/${recipe}")
    file(LOCK "${cache_dir}.lock" GUARD FUNCTION)
    file(GLOB cache_dir_files "${cache_dir}/*")
    if(cache_dir_files)
      set(FETCHCONTENT_SOURCE_DIR_${upper_recipe} "${cache_dir}")
      set(cache_hit TRUE)
    else()
      set(source_args SOURCE_DIR "${cache_dir}")
    endif()
  endif()

  if(r_SOURCE_SUBDIR)
    list(APPEND source_args SOURCE_SUBDIR "${r_SOURCE_SUBDIR}")
  endif()

  # Content name is the recipe name: a project's own FetchContent_Declare(<recipe>) made earlier
  # takes precedence (first declaration wins), and FETCHCONTENT_SOURCE_DIR_<RECIPE> works as usual.

  set(FETCHCONTENT_TRY_FIND_PACKAGE_MODE NEVER)

  FetchContent_Declare(${recipe}
    URL "${url}"
    URL_HASH SHA256=${sha256}
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    DOWNLOAD_NO_PROGRESS TRUE
    BINARY_DIR "${CMAKE_BINARY_DIR}/_cmodule/${recipe}-build"
    SUBBUILD_DIR "${CMAKE_BINARY_DIR}/_cmodule/${recipe}-subbuild"
    ${source_args}
    SYSTEM
    EXCLUDE_FROM_ALL
  )

  if(CMODULE_DISABLE_WARNINGS AND CMAKE_VERSION VERSION_GREATER_EQUAL "4.4")
    cmake_diagnostic(PUSH) # PUSH/POP must be in the same function, can't be split between macros
    cmake_diagnostic(SET CMD_DEPRECATED IGNORE)
  endif()

  cmodule_isolation_begin(${recipe})
  FetchContent_MakeAvailable(${recipe})
  cmodule_isolation_end()

  if(CMODULE_DISABLE_WARNINGS AND CMAKE_VERSION VERSION_GREATER_EQUAL "4.4")
    cmake_diagnostic(POP)
  endif()

  if(cache_hit)
    unset(FETCHCONTENT_SOURCE_DIR_${upper_recipe} CACHE) # don't persist cmodule's internal value
  endif()

  FetchContent_GetProperties(${recipe} SOURCE_DIR source_dir BINARY_DIR binary_dir)
  set_property(GLOBAL PROPERTY CMODULE_SOURCE_DIR_${recipe} "${source_dir}")
  set_property(GLOBAL PROPERTY CMODULE_BINARY_DIR_${recipe} "${binary_dir}")
  set_property(GLOBAL PROPERTY CMODULE_LOCAL_OVERRIDE_${recipe} "${local_override}")

  # Imported executables (host tools)

  foreach(entry IN LISTS r_EXECUTABLES)
    if(NOT entry MATCHES "^([^=]+)=(.+)$")
      message(FATAL_ERROR "cmodule recipe ${recipe}: EXECUTABLES entry must be <target>=<path>: ${entry}")
    endif()
    set(target "${CMAKE_MATCH_1}")
    cmodule_expand(${recipe} "${CMAKE_MATCH_2}" path)
    cmake_path(ABSOLUTE_PATH path BASE_DIRECTORY "${source_dir}")
    if(CMAKE_HOST_WIN32 AND NOT EXISTS "${path}" AND EXISTS "${path}.exe")
      string(APPEND path ".exe")
    endif()
    if(NOT EXISTS "${path}")
      message(FATAL_ERROR "cmodule recipe ${recipe}: executable not found: ${path}")
    endif()
    add_executable(${target} IMPORTED GLOBAL)
    set_target_properties(${target} PROPERTIES IMPORTED_LOCATION "${path}")
  endforeach()

  # Recipe hook: fix-ups after the sources are added (before aliases are created)

  if(COMMAND cmodule_${recipe}_after)
    cmake_language(CALL cmodule_${recipe}_after)
  endif()

  # Aliases expected by consumers, if upstream doesn't define them

  foreach(entry IN LISTS r_TARGETS)
    if(NOT entry MATCHES "^([^=]+)=(.+)$")
      message(FATAL_ERROR "cmodule recipe ${recipe}: TARGETS entry must be <alias>=<target>: ${entry}")
    endif()
    set(alias "${CMAKE_MATCH_1}")
    set(target "${CMAKE_MATCH_2}")
    if(NOT TARGET ${alias})
      if(NOT TARGET ${target})
        message(FATAL_ERROR "cmodule recipe ${recipe}: TARGETS ${alias}=${target}: no such target")
      endif()
      get_target_property(type ${target} TYPE)
      if(type STREQUAL "EXECUTABLE")
        add_executable(${alias} ALIAS ${target})
      else()
        add_library(${alias} ALIAS ${target})
      endif()
    endif()
  endforeach()

  set_property(GLOBAL PROPERTY CMODULE_STATE_${recipe} done)
endfunction()
