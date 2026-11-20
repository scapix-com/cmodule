# Update recipes (VERSION and SHA256) to the latest upstream releases.
#
#   cmake -P tools/update-recipes.cmake [<recipe> [<version>]]   # default: all recipes, latest versions
#   cmake -D DRY_RUN=ON -P tools/update-recipes.cmake            # report only
#
# Latest version: the highest git tag matching the tag in recipe URL (GitHub only), e.g. v{version} -> v2.6.0.
# Pre-releases (2.6.0-rc1, 1.92.0.beta1) are ignored.
# Prints "update <recipe> to version <version>" to stdout for each update; errors don't stop other recipes.

cmake_minimum_required(VERSION 3.28)

set(recipes_dir "${CMAKE_CURRENT_LIST_DIR}/../recipes")

function(latest_version recipe url out_var)
  set(${out_var} "" PARENT_SCOPE)

  if(url MATCHES "^https://github\\.com/([^/]+/[^/]+)/(archive/refs/tags/(.+)\\.tar\\.|releases/download/([^/]+)/)")
    set(repo "https://github.com/${CMAKE_MATCH_1}.git")
    set(tag "${CMAKE_MATCH_3}${CMAKE_MATCH_4}")
  endif()
  if(NOT tag MATCHES "{version}")
    message("${recipe}: skipped (no GitHub tag with {version} in URL)")
    return()
  endif()

  string(REPLACE "." "\\." tag "${tag}")
  string(REPLACE "{version}" "([0-9]+(\\.[0-9]+)*)" tag "${tag}")
  string(REPLACE "{host}" ".+" tag "${tag}")

  execute_process(COMMAND git ls-remote --tags --refs "${repo}" OUTPUT_VARIABLE refs)
  string(REGEX MATCHALL "refs/tags/[^\r\n]+" refs "${refs}")

  set(latest "")
  foreach(ref IN LISTS refs)
    if(ref MATCHES "^refs/tags/${tag}$")
      if(NOT latest OR CMAKE_MATCH_1 VERSION_GREATER latest)
        set(latest "${CMAKE_MATCH_1}")
      endif()
    endif()
  endforeach()

  if(NOT latest)
    message(SEND_ERROR "${recipe}: no tags matching ${tag} in ${repo}")
  endif()
  set(${out_var} "${latest}" PARENT_SCOPE)
endfunction()

function(update_recipe recipe version)
  set(path "${recipes_dir}/${recipe}.cmake")
  file(READ "${path}" content)

  # Edit only cmodule_recipe() call, which ends with the first line starting with ")".
  string(FIND "${content}" "\n)" end)
  string(SUBSTRING "${content}" 0 ${end} call)
  string(SUBSTRING "${content}" ${end} -1 rest)

  string(REGEX MATCH "\n[ \t]*VERSION[ \t]+([^ \t\r\n]+)" _ "${call}")
  set(current "${CMAKE_MATCH_1}")
  string(REGEX MATCH "\n[ \t]*URL[ \t]+([^ \t\r\n]+)" _ "${call}")
  set(url "${CMAKE_MATCH_1}")

  if(NOT version)
    latest_version(${recipe} "${url}" version)
    if(NOT version)
      return()
    elseif(NOT version VERSION_GREATER current)
      message("${recipe}: ${current} is up to date")
      return()
    endif()
  endif()

  # SHA256 <hash>, or HOST_SHA256 <host>=<hash> per host.
  string(REGEX MATCHALL "\n[ \t]*[A-Za-z0-9_]+-[A-Za-z0-9_]+=" hosts "${call}")
  list(TRANSFORM hosts REPLACE "[\n \t=]" "")
  if(NOT hosts)
    set(hosts "-")
  endif()

  foreach(host IN LISTS hosts)
    string(REPLACE "{version}" "${version}" file_url "${url}")
    string(REPLACE "{host}" "${host}" file_url "${file_url}")
    set(hash "")
    file(DOWNLOAD "${file_url}" "${path}.download" STATUS status)
    if(status MATCHES "^0;")
      file(SHA256 "${path}.download" hash)
    endif()
    file(REMOVE "${path}.download")
    if(NOT hash)
      message(SEND_ERROR "${recipe}: download ${file_url} failed: ${status}")
      return()
    endif()

    if(host STREQUAL "-")
      set(key "SHA256[ \t]+")
    else()
      set(key "${host}=")
    endif()
    string(REGEX REPLACE "(\n[ \t]*${key})[0-9a-fA-F]+" "\\1${hash}" call "${call}")
  endforeach()

  string(REGEX REPLACE "(\n[ \t]*VERSION[ \t]+)[^ \t\r\n]+" "\\1${version}" call "${call}")

  if(DRY_RUN)
    message("${recipe}: ${current} -> ${version} (dry run)")
  else()
    file(WRITE "${path}" "${call}${rest}")
    execute_process(COMMAND "${CMAKE_COMMAND}" -E echo "update ${recipe} to version ${version}")
  endif()
endfunction()

# Arguments after script name: [<recipe> [<version>]]

math(EXPR last "${CMAKE_ARGC} - 1")
foreach(i RANGE ${last})
  list(APPEND argv "${CMAKE_ARGV${i}}")
endforeach()
list(FIND argv "-P" i)
math(EXPR i "${i} + 2")
if(i LESS CMAKE_ARGC)
  list(SUBLIST argv ${i} -1 args)
  list(POP_FRONT args recipes version)
endif()

if(NOT recipes)
  file(GLOB recipes RELATIVE "${recipes_dir}" "${recipes_dir}/*.cmake")
  list(TRANSFORM recipes REPLACE "\\.cmake$" "")
endif()

foreach(recipe IN LISTS recipes)
  update_recipe(${recipe} "${version}")
endforeach()
