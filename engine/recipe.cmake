# Recipe registry.
#
# cmodule_recipe(<name>
#   VERSION <version>
#   PACKAGES <find_package name>...       # names served, case-insensitive
#   URL <url>                             # may contain {version} and {host}
#   SHA256 <hash>                         # or HOST_SHA256 for HOST_PREBUILT
#   [LICENSE <spdx>]
#   [COMPATIBILITY AnyNewerVersion|SameMajorVersion|SameMinorVersion|ExactVersion]  # default SameMajorVersion
#   [SOURCE_SUBDIR <dir>]
#   [OPTIONS <var>=<value>...]            # set before add_subdirectory()
#   [TARGETS <alias>=<target>...]         # aliases created if upstream doesn't define them
#   [VARIABLES <var>=<value>...]          # set by generated package config, <var>+=<value> appends to a list
#
# Values of URL, OPTIONS, VARIABLES and EXECUTABLES may use placeholders:
#   {version} {host} {source_dir} {binary_dir} {location:<imported target>}
#   {shared} {static}: ON/OFF according to CMODULE_SHARED
#   [COMPONENTS <component>...]           # components provided; others requested as REQUIRED fail
#   [COMPONENT_TARGETS <pattern>]         # component found if target exists, e.g. Boost::{component}
#   [DOWNLOAD_ONLY]                       # don't add_subdirectory(); hooks add parts with cmodule_add_subdirectory()
#   [HOST_PREBUILT]                       # prebuilt host tools: download only, no add_subdirectory()
#   [HOST_SHA256 <host>=<hash>...]        # <host> is ${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}
#   [EXECUTABLES <target>=<path>...]      # imported executables; path relative to source dir, may use {host}
# )
#
# Optional hooks a recipe file may define:
#   cmodule_<name>_configure()                     before each add_subdirectory(), in its scope (use a macro to set variables)
#   cmodule_<name>_after()                         after sources are added, before TARGETS aliases
#   cmodule_<name>_components(<package> <comp>...) on every find_package() request with components
#   cmodule_<name>_config(<package> <out_var>)     extra code appended to generated package config

set(cmodule_recipe_fields
  VERSION URL SHA256 LICENSE COMPATIBILITY SOURCE_SUBDIR COMPONENT_TARGETS DOWNLOAD_ONLY
  PACKAGES OPTIONS TARGETS VARIABLES COMPONENTS HOST_PREBUILT HOST_SHA256 EXECUTABLES
  ORIGIN FILE
  CACHE INTERNAL "")

function(cmodule_recipe name)
  cmake_parse_arguments(PARSE_ARGV 1 arg
    "HOST_PREBUILT;DOWNLOAD_ONLY"
    "VERSION;URL;SHA256;LICENSE;COMPATIBILITY;SOURCE_SUBDIR;COMPONENT_TARGETS"
    "PACKAGES;OPTIONS;TARGETS;VARIABLES;COMPONENTS;HOST_SHA256;EXECUTABLES"
  )

  if(arg_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "cmodule recipe ${name}: unknown arguments: ${arg_UNPARSED_ARGUMENTS}")
  endif()

  foreach(required IN ITEMS VERSION URL PACKAGES)
    if(NOT arg_${required})
      message(FATAL_ERROR "cmodule recipe ${name}: ${required} is required")
    endif()
  endforeach()

  if(arg_HOST_PREBUILT)
    if(NOT arg_HOST_SHA256)
      message(FATAL_ERROR "cmodule recipe ${name}: HOST_PREBUILT requires HOST_SHA256")
    endif()
  elseif(NOT arg_SHA256)
    message(FATAL_ERROR "cmodule recipe ${name}: SHA256 is required (downloads without hash are refused)")
  endif()

  if(NOT arg_COMPATIBILITY)
    set(arg_COMPATIBILITY SameMajorVersion)
  endif()

  if(NOT arg_COMPATIBILITY MATCHES "^(AnyNewerVersion|SameMajorVersion|SameMinorVersion|ExactVersion)$")
    message(FATAL_ERROR "cmodule recipe ${name}: invalid COMPATIBILITY ${arg_COMPATIBILITY}")
  endif()

  # A recipe registered again (from an overlay) replaces the previous one.

  cmodule_recipe_get(${name} PACKAGES previous_packages)
  foreach(package IN LISTS previous_packages)
    string(TOLOWER "${package}" package)
    set_property(GLOBAL PROPERTY CMODULE_PACKAGE_${package})
  endforeach()

  set(arg_ORIGIN "${cmodule_loading_origin}")
  set(arg_FILE "${CMAKE_CURRENT_LIST_FILE}")

  foreach(field IN LISTS cmodule_recipe_fields)
    set_property(GLOBAL PROPERTY CMODULE_RECIPE_${name}_${field} "${arg_${field}}")
  endforeach()

  get_property(recipes GLOBAL PROPERTY CMODULE_RECIPES)
  if(NOT name IN_LIST recipes)
    set_property(GLOBAL APPEND PROPERTY CMODULE_RECIPES ${name})
  endif()

  foreach(package IN LISTS arg_PACKAGES)
    string(TOLOWER "${package}" package)
    set_property(GLOBAL PROPERTY CMODULE_PACKAGE_${package} ${name})
  endforeach()
endfunction()

function(cmodule_recipe_get name field out_var)
  get_property(value GLOBAL PROPERTY CMODULE_RECIPE_${name}_${field})
  set(${out_var} "${value}" PARENT_SCOPE)
endfunction()

# Recipe name for a find_package() name, empty if none.

function(cmodule_recipe_for_package package out_var)
  string(TOLOWER "${package}" package)
  get_property(recipe GLOBAL PROPERTY CMODULE_PACKAGE_${package})
  set(${out_var} "${recipe}" PARENT_SCOPE)
endfunction()

function(cmodule_load_recipes)
  set(cmodule_loading_origin builtin)
  file(GLOB files "${CMODULE_DIR}/recipes/*.cmake")
  foreach(file IN LISTS files)
    include("${file}")
  endforeach()

  set(cmodule_loading_origin overlay)
  foreach(dir IN LISTS CMODULE_RECIPE_PATH)
    file(REAL_PATH "${dir}" dir BASE_DIRECTORY "${CMAKE_SOURCE_DIR}")
    file(GLOB files "${dir}/*.cmake")
    foreach(file IN LISTS files)
      include("${file}")
    endforeach()
  endforeach()
endfunction()
