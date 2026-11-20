cmodule_recipe(catch2
  VERSION 3.16.1
  PACKAGES Catch2
  URL https://github.com/catchorg/Catch2/archive/refs/tags/v{version}.tar.gz
  SHA256 d16bd1b8b2364918bd472cb216394acb93bde6784890df0d91bccfb3f28d777d
  LICENSE BSL-1.0
  OPTIONS
    CATCH_INSTALL_DOCS=OFF
    CATCH_INSTALL_EXTRAS=OFF
)
