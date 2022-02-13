#!/bin/sh
set -e
CONFIGURATION=Debug
if test "$CONFIGURATION" = "Debug"; then :
  cd /Users/zerox/cpp-playground/thirdparty/src/BoostBuilder
  /Users/zerox/cpp-playground/thirdparty/src/BoostBuilder/b2 -q -d+2 -o commands.log --without-python --without-mpi --prefix=/Users/zerox/cpp-playground/thirdparty --layout=tagged "cxxflags=-std=c++14" toolset=darwin architecture=x86 address-model=64 threading=multi variant=debug,release debug-symbols=on link=static,shared runtime-link=shared install
  #/usr/local/Cellar/cmake/3.22.2/bin/cmake -E touch /Users/zerox/cpp-playground/thirdparty/src/BoostBuilder-stamp/$CONFIGURATION$EFFECTIVE_PLATFORM_NAME/BoostBuilder-b2
fi
if test "$CONFIGURATION" = "Release"; then :
  cd /Users/zerox/cpp-playground/thirdparty/src/BoostBuilder
  /Users/zerox/cpp-playground/thirdparty/src/BoostBuilder/b2 -q -d+2 -o commands.log --without-python --without-mpi --prefix=/Users/zerox/cpp-playground/thirdparty --layout=tagged "cxxflags=\"-std=c++14 -arch=x86_64\"" toolset=darwin architecture=x86 address-model=64 threading=multi variant=debug,release debug-symbols=on link=static,shared runtime-link=shared install
  /usr/local/Cellar/cmake/3.22.2/bin/cmake -E touch /Users/zerox/cpp-playground/thirdparty/src/BoostBuilder-stamp/$CONFIGURATION$EFFECTIVE_PLATFORM_NAME/BoostBuilder-b2
fi

