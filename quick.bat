@echo off

:loop_args
if "%~1"=="" goto :main
if "%~1"=="-gcc" set enable_gcc=1
if "%~1"=="-thirdparty" set enable_thirdparty=1
shift
goto :loop_args

:main
echo Setup: enable_gcc=%enable_gcc% enable_thirdparty=%enable_thirdparty%

if "%enable_gcc%"=="1" (
    set generator=Ninja Multi-Config
    set boost_bootstrap_toolset="gcc"
    set boost_b2_toolset="gcc"
) else (
    set generator=Visual Studio 14 2015 Win64
    set boost_bootstrap_toolset="vc14"
    set boost_b2_toolset="msvc-14.0"
)

if "%enable_thirdparty%"=="1" (
    echo Building thirdparty
    echo cmake -B"%~dp0thirdparty/build" -S"%~dp0" -G "%generator%" ^
 "-DENABLE_THIRDPARTY=ON" ^
 "-DBOOST_BOOTSTRAP_TOOLSET=%boost_bootstrap_toolset%" ^
 "-DBOOST_B2_TOOLSET=%boost_b2_toolset%" ^
 "-DCMAKE_CONFIGURATION_TYPES=Debug;Release"
)
