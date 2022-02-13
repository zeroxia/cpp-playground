cmake_minimum_required(VERSION 3.15)
cmake_policy(SET CMP0114 NEW)

include(ExternalProject)

set(BOOST_PREFIX ${CMAKE_INSTALL_PREFIX})
set(BOOST_SRC_TOP ${BOOST_PREFIX}/src/BoostBuilder)

if(WIN32)
    message(STATUS "Windows build")
    set(BOOST_BOOTSTRAP_COMMAND ${BOOST_SRC_TOP}/bootstrap.bat vc14)
    set(BOOST_B2_COMMAND ${BOOST_SRC_TOP}/b2 -q -d+2 -o commands.log
        --without-python --without-mpi #--with-filesystem
        --prefix=<INSTALL_DIR>
        --layout=tagged
        cxxflags=/std:c++14 toolset=msvc-14.0
        architecture=x86 address-model=64 threading=multi
        variant=debug,release debug-symbols=on
        link=static,shared runtime-link=shared
        install
        )
elseif(APPLE)
    message(STATUS "macOS build")
    set(BOOST_BOOTSTRAP_COMMAND /bin/sh ${BOOST_SRC_TOP}/bootstrap.sh --prefix=<INSTALL_DIR>
        toolset=clang architecture=x86 address-model=64
        threading=multi variant=debug,release debug-symbols=on
        link=static,shared runtime-link=shared clang)
    set(BOOST_B2_COMMAND ${BOOST_SRC_TOP}/b2 -q -d+2 -o commands.log
        --without-python --without-mpi --wihout-icu --without-graph_parallel
        --prefix=<INSTALL_DIR>
        --layout=tagged
        cxxflags=-std=c++14 toolset=clang
        architecture=x86 address-model=64 threading=multi
        variant=debug,release debug-symbols=on
        link=static,shared runtime-link=shared
        install
        )
else()
    message(STATUS "Unix build")
    set(BOOST_BOOTSTRAP_COMMAND /bin/sh ${BOOST_SRC_TOP}/bootstrap.sh --prefix=<INSTALL_DIR> gcc)
    set(BOOST_B2_COMMAND ${BOOST_SRC_TOP}/b2 -q -d+2 -o commands.log
        --without-python --without-mpi #--with-filesystem
        --prefix=<INSTALL_DIR>
        --layout=tagged
        cxxflags=-std=c++14 toolset=gcc
        architecture=x86 address-model=64 threading=multi
        variant=debug,release debug-symbols=on
        link=static,shared runtime-link=shared
        install
        )
endif()

## https://www.boost.org/users/history/version_1_71_0.html
ExternalProject_Add(BoostBuilder
    #URL "https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.bz2"
    URL "https://boostorg.jfrog.io/artifactory/main/release/1.71.0/source/boost_1_71_0.tar.gz"
    #URL_HASH MD5=4cdf9b5c2dc01fb2b7b733d5af30e558
    URL_HASH SHA256=96b34f7468f26a141f6020efb813f1a2f3dfb9797ecf76a7d7cbd843cc95f5bd
    PREFIX ${BOOST_PREFIX}
    INSTALL_DIR ${BOOST_PREFIX}
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E echo "Fake Configure..."
    BUILD_COMMAND ${CMAKE_COMMAND} -E echo "Fake Build..."
    INSTALL_COMMAND ${CMAKE_COMMAND} -E echo "Fake Install..."
)

ExternalProject_Add_Step(BoostBuilder bootstrap
    COMMAND ${BOOST_BOOTSTRAP_COMMAND}
    COMMENT "-*-  Boost bootstrap  -*-"
    DEPENDEES configure
    DEPENDERS build
    #ALWAYS TRUE
    WORKING_DIRECTORY ${BOOST_SRC_TOP}
    LOG FALSE
    USES_TERMINAL TRUE
)

ExternalProject_Add_Step(BoostBuilder b2
    COMMAND ${BOOST_B2_COMMAND}
    COMMENT "-*-  Boost build & install to: ${CMAKE_INSTALL_PREFIX} -*-"
    DEPENDEES build
    DEPENDERS install
    #ALWAYS TRUE
    WORKING_DIRECTORY ${BOOST_SRC_TOP}
    LOG FALSE
    USES_TERMINAL TRUE
)
