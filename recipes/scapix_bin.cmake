# Prebuilt host tools: downloaded for the build host, never compiled for the target.

cmodule_recipe(scapix_bin
  VERSION 2.6.0
  PACKAGES ScapixBin
  URL https://github.com/scapix-com/scapix-bin/archive/refs/tags/v{version}-{host}.tar.gz
  HOST_PREBUILT
  HOST_SHA256
    Darwin-arm64=da29759159a9b901d42ff8af82a8324af64bcc5a597c4d7a836fe8212ea7d54e
    Darwin-x86_64=140b142e9a5f963229c6514bd8fd7623903e4e555426cab4ae90df672a231f28
    Linux-x86_64=2bd049d9079b740a5de4023cceee69c6e90728d97d33ff7f6a043ba4f4859877
    Windows-AMD64=fd0bcb0a8612e205441ba4a2a4a15342b400868cd625f24259648e6ab3cc2928
  LICENSE LicenseRef-Scapix
  EXECUTABLES
    scapix::scapix={host}/scapix
    scapix::scapix_java={host}/scapix_java
)

# Compatibility: scapix uses SCAPIX_EXE / SCAPIX_JAVA_EXE from functions called in any directory,
# so they are cache variables (new code should use $<TARGET_FILE:scapix::scapix>).

function(cmodule_scapix_bin_config package out_var)
  cmodule_expand(scapix_bin "{location:scapix::scapix}" scapix_exe)
  cmodule_expand(scapix_bin "{location:scapix::scapix_java}" scapix_java_exe)
  set(${out_var}
    "set(SCAPIX_EXE [==[${scapix_exe}]==] CACHE INTERNAL \"\")\nset(SCAPIX_JAVA_EXE [==[${scapix_java_exe}]==] CACHE INTERNAL \"\")\n"
    PARENT_SCOPE)
endfunction()
