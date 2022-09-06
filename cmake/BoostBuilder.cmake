cmake_minimum_required(VERSION 3.15)

include(ExternalProject)

set(BOOST_PREFIX ${CMAKE_INSTALL_PREFIX})
set(BOOST_SRC_TOP ${BOOST_PREFIX}/src/BoostBuilder)

if (NOT DEFINED BOOST_BOOTSTRAP_TOOLSET)
    message(FATAL_ERROR "BOOST_BOOTSTRAP_TOOLSET not defined")
endif()
if (NOT DEFINED BOOST_B2_TOOLSET)
    message(FATAL_ERROR "BOOST_B2_TOOLSET not defined")
endif()

if(WIN32)
    message(STATUS "Windows build")
    set(BOOST_BOOTSTRAP_COMMAND ${BOOST_SRC_TOP}/bootstrap.bat ${BOOST_BOOTSTRAP_TOOLSET})
    set(BOOST_B2_COMMAND ${BOOST_SRC_TOP}/b2.exe install
        --prefix=<INSTALL_DIR> --layout=tagged
        -q -d+2 -o commands.log
        --without-python --without-mpi --without-graph-parallel
        cxxflags=/std:c++14 toolset=${BOOST_B2_TOOLSET}
        architecture=x86 address-model=64 threading=multi
        variant=debug,release debug-symbols=on
        link=static,shared runtime-link=shared)
elseif(APPLE)
    message(FATAL "APPLE not supported yet")
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

## https://cmake.org/cmake/help/v3.11/module/ExternalProject.html
## https://www.boost.org/users/history/version_1_71_0.html
ExternalProject_Add(BoostBuilder
    #URL "https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.bz2"
    #URL "https://boostorg.jfrog.io/artifactory/main/release/1.71.0/source/boost_1_71_0.tar.gz"
    URL "http://192.168.56.101:8001/boost_1_71_0.tar.gz"
    #URL_HASH MD5=5f521b41b79bf8616582c4a8a2c10177
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
