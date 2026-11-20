# Resolution report: one status line per package, and ${CMAKE_BINARY_DIR}/cmodule-resolved.json

function(cmodule_note package recipe status)
  get_property(noted GLOBAL PROPERTY CMODULE_NOTED_${package})
  if(noted STREQUAL status)
    return()
  endif()
  set_property(GLOBAL PROPERTY CMODULE_NOTED_${package} "${status}")

  # Print only what differs from the usual case (full details are in cmodule-resolved.json):
  #   Catch2 3.16.1
  #   ScapixCore (local: ../scapix-core)
  #   ZLIB 1.4 (overlay: ../recipes/zlib.cmake)
  #   Foo 2.0 (recipe: bar)
  #   Boost (excluded)

  if(status STREQUAL "provided")
    cmodule_recipe_get(${recipe} VERSION version)
    cmodule_recipe_get(${recipe} ORIGIN origin)
    cmodule_recipe_get(${recipe} FILE file)
    get_property(local_override GLOBAL PROPERTY CMODULE_LOCAL_OVERRIDE_${recipe})

    set(details "")

    # Recipe name only if it isn't the package name (ignoring case and underscores): ScapixCore = scapix_core
    string(TOLOWER "${package}" package_key)
    string(REPLACE "_" "" recipe_key "${recipe}")
    if(NOT package_key STREQUAL recipe_key)
      list(APPEND details "recipe: ${recipe}")
    endif()

    if(origin STREQUAL "overlay")
      file(RELATIVE_PATH file "${CMAKE_SOURCE_DIR}" "${file}")
      list(APPEND details "overlay: ${file}")
    endif()

    if(local_override)
      file(RELATIVE_PATH local_override "${CMAKE_SOURCE_DIR}" "${local_override}") # e.g. ../scapix-core
      list(APPEND details "local: ${local_override}")
      set(line "${package}")
    else()
      set(line "${package} ${version}")
    endif()

    if(details)
      list(JOIN details ", " details)
      string(APPEND line " (${details})")
    endif()
  else()
    set(line "${package} (${status})")
  endif()

  message(STATUS "cmodule: ${line}")

  set_property(GLOBAL APPEND PROPERTY CMODULE_NOTED_PACKAGES ${package})
endfunction()

function(cmodule_write_report)
  get_property(packages GLOBAL PROPERTY CMODULE_NOTED_PACKAGES)
  list(REMOVE_DUPLICATES packages)

  set(json "{}")
  string(JSON json SET "${json}" "cmodule" "\"${CMODULE_VERSION}\"")
  string(JSON json SET "${json}" "packages" "[]")

  set(index 0)
  foreach(package IN LISTS packages)
    get_property(status GLOBAL PROPERTY CMODULE_NOTED_${package})
    cmodule_recipe_for_package(${package} recipe)

    set(entry "{}")
    string(JSON entry SET "${entry}" "package" "\"${package}\"")
    string(JSON entry SET "${entry}" "status" "\"${status}\"")
    string(JSON entry SET "${entry}" "recipe" "\"${recipe}\"")

    if(status STREQUAL "provided")
      cmodule_recipe_get(${recipe} VERSION version)
      cmodule_recipe_get(${recipe} LICENSE license)
      cmodule_recipe_get(${recipe} ORIGIN origin)
      cmodule_recipe_get(${recipe} FILE file)
      cmodule_recipe_get(${recipe} URL url)
      cmodule_recipe_get(${recipe} SHA256 sha256)
      cmodule_recipe_get(${recipe} HOST_PREBUILT host_prebuilt)
      cmodule_expand(${recipe} "${url}" url)
      if(host_prebuilt)
        cmodule_host(host)
        cmodule_recipe_get(${recipe} HOST_SHA256 host_sha256)
        foreach(e IN LISTS host_sha256)
          if(e MATCHES "^${host}=(.+)$")
            set(sha256 "${CMAKE_MATCH_1}")
          endif()
        endforeach()
      endif()
      get_property(source_dir GLOBAL PROPERTY CMODULE_SOURCE_DIR_${recipe})
      get_property(local_override GLOBAL PROPERTY CMODULE_LOCAL_OVERRIDE_${recipe})

      foreach(field IN ITEMS version license origin file url sha256 source_dir local_override)
        string(JSON entry SET "${entry}" "${field}" "\"${${field}}\"")
      endforeach()
    endif()

    string(JSON json SET "${json}" "packages" ${index} "${entry}")
    math(EXPR index "${index} + 1")
  endforeach()

  file(WRITE "${CMAKE_BINARY_DIR}/cmodule-resolved.json" "${json}\n")
endfunction()
