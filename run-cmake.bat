@echo off

setlocal

cd /D "%~dp0"
if not exist CMakeLists.txt (echo No CMakeLists.txt & exit /b 1)

if "%~1" == "thirdparty" (
    echo ThirdParty
    cmake -B thirdparty/build -S . -G "Visual Studio 14 2015" -A x64 -DTHIRDPARTY=TRUE ^
        "-DCMAKE_CONFIGURATION_TYPES=Debug;Release"
    cmake --build thirdparty/build --config Debug
    cmake --build thirdparty/build --config Release
) else (
    REM cmake -B build -S . -G "Ninja" -DTHIRDPARTY=FALSE -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE
    cmake -B build -S . -G "Visual Studio 14 2015 Win64" -DTHIRDPARTY=FALSE -DCMAKE_CONFIGURATION_TYPES=Debug;Release
)

endlocal
