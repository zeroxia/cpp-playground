#!/bin/sh

set -e
cd "$(dirname "$0")"

if [ ! -f CMakeLists.txt ]; then
    echo "No CMakeLists.txt"
    exit 1
fi

if [ "$1" = "thirdparty" ]; then
    echo ThirdParty
    cmake -B thirdparty/build -S . -G "Ninja Multi-Config" -DTHIRDPARTY=TRUE \
        "-DCMAKE_CONFIGURATION_TYPES=Debug;Release" "-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE"
    cmake --build thirdparty/build --config Debug
    cmake --build thirdparty/build --config Release
else
    echo Project
    cmake -B build -S . -G "Ninja" -DTHIRDPARTY=FALSE -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE
    # cmake -B build -S . -G "Visual Studio 14 2015 Win64" -DTHIRDPARTY=FALSE -DCMAKE_CONFIGURATION_TYPES=Debug;Release -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE
fi
