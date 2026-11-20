# Dependency provider: called for every find_package() in the build.
#
# For packages with a recipe: build it (once), write a redirect package config,
# then decline the request, so built-in find_package() loads that config.

# Is recipe version compatible with requested version?

function(cmodule_version_compatible recipe requested exact out_var)
  cmodule_recipe_get(${recipe} VERSION version)
  cmodule_recipe_get(${recipe} COMPATIBILITY compatibility)

  set(result FALSE)

  if(exact OR compatibility STREQUAL "ExactVersion")
    if(version VERSION_EQUAL requested)
      set(result TRUE)
    endif()
  elseif(version VERSION_GREATER_EQUAL requested)
    string(REGEX MATCH "^[0-9]+" version_major "${version}")
    string(REGEX MATCH "^[0-9]+" requested_major "${requested}")
    string(REGEX MATCH "^[0-9]+(\\.[0-9]+)?" version_minor "${version}")
    string(REGEX MATCH "^[0-9]+(\\.[0-9]+)?" requested_minor "${requested}")

    if(compatibility STREQUAL "AnyNewerVersion")
      set(result TRUE)
    elseif(compatibility STREQUAL "SameMajorVersion" AND version_major EQUAL requested_major)
      set(result TRUE)
    elseif(compatibility STREQUAL "SameMinorVersion" AND version_minor VERSION_EQUAL requested_minor)
      set(result TRUE)
    endif()
  endif()

  set(${out_var} ${result} PARENT_SCOPE)
endfunction()

function(cmodule_provide_dependency method package)
  cmake_parse_arguments(PARSE_ARGV 2 arg
    "EXACT;QUIET;REQUIRED;CONFIG;MODULE;NO_MODULE;GLOBAL;NO_POLICY_SCOPE;BYPASS_PROVIDER"
    ""
    "COMPONENTS;OPTIONAL_COMPONENTS;NAMES;CONFIGS;HINTS;PATHS;PATH_SUFFIXES"
  )

  # find_package(<pkg> [version] [REQUIRED] [<components>...] ...)

  set(requested_version "")
  set(components ${arg_COMPONENTS} ${arg_OPTIONAL_COMPONENTS})

  if(arg_UNPARSED_ARGUMENTS)
    list(GET arg_UNPARSED_ARGUMENTS 0 first)
    if(first MATCHES "^[0-9]")
      set(requested_version "${first}")
      list(REMOVE_AT arg_UNPARSED_ARGUMENTS 0)
    endif()
    if(arg_REQUIRED)
      list(APPEND components ${arg_UNPARSED_ARGUMENTS}) # find_package(<pkg> REQUIRED <components>...)
    endif()
  endif()

  # Recipe for the package name, or for one of NAMES

  set(recipe "")
  foreach(name IN ITEMS ${package} ${arg_NAMES})
    cmodule_recipe_for_package("${name}" recipe)
    if(recipe)
      break()
    endif()
  endforeach()

  if(NOT recipe)
    return()
  endif()

  if(package IN_LIST CMODULE_EXCLUDE OR recipe IN_LIST CMODULE_EXCLUDE)
    cmodule_note(${package} ${recipe} "excluded")
    return()
  endif()

  if(requested_version AND NOT requested_version MATCHES "\\.\\.\\.")
    cmodule_version_compatible(${recipe} "${requested_version}" "${arg_EXACT}" compatible)
    if(NOT compatible)
      cmodule_recipe_get(${recipe} VERSION version)
      cmodule_recipe_get(${recipe} COMPATIBILITY compatibility)
      set(text "find_package(${package} ${requested_version}): recipe ${recipe} ${version} is not compatible (${compatibility})")
      if(CMODULE_ON_VERSION_MISMATCH STREQUAL "FALLBACK")
        cmodule_note(${package} ${recipe} "version mismatch, fallback")
        message(STATUS "cmodule: ${text}, falling back to regular find_package()")
        return()
      endif()
      message(FATAL_ERROR "cmodule: ${text}.\n"
        "Options: update the recipe or add one to CMODULE_RECIPE_PATH, "
        "add ${package} to CMODULE_EXCLUDE, or set CMODULE_ON_VERSION_MISMATCH=FALLBACK.")
    endif()
  endif()

  cmodule_make_available(${recipe})

  if(components AND COMMAND cmodule_${recipe}_components)
    cmake_language(CALL cmodule_${recipe}_components ${package} ${components})
  endif()

  # With NAMES, find_package() searches only <name>-config.cmake for each of NAMES.

  if(arg_NAMES)
    foreach(name IN LISTS arg_NAMES)
      cmodule_write_package(${recipe} ${name})
    endforeach()
  else()
    cmodule_write_package(${recipe} ${package})
  endif()

  cmodule_note(${package} ${recipe} "provided")

  # Decline: built-in find_package() loads the redirect config.
  # A stale <pkg>_FOUND (from an earlier call in this scope) would count as "provided".

  string(TOUPPER "${package}" upper_package)
  unset(${package}_FOUND PARENT_SCOPE)
  unset(${upper_package}_FOUND PARENT_SCOPE)
endfunction()
