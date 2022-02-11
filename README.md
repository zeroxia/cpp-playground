# C++ Playground

A CMake based C++ project with various libraries.

The top `CMakeLists.txt` presents two stages: "thirdparty" and "main".

When `-DTHIRDPARTY=TRUE` is passed to cmake configure command, the thirdparty stage is configured,
the "binary directory" is `thirdparty/build`. This build employs
[ExternalProject feature of CMake](https://cmake.org/cmake/help/v3.15/module/ExternalProject.html)
to download and build libraries.

This should be done before the "main" stage and rarely needs to repeat.

Without the "THIRDPARTY" variable set, the main stage is configured, the "binary directory" is
"./build". This is the major playground for user. User's CMake targets can just link to those
thirdparty libraries as CMake packages.

A "run-cmake" helper script (`run-cmake.sh` is for Unix, and `run-cmake.bat` is for Windows) runs
the "configure" and "build" for "thirdparty" stage directly, but for "main" stage, it only runs
"configure".

Note that for "thirdparty" stage, generator is set to platform specific (with preference to IDE
favors if available), rather than Ninja, since "compile_commands.json" is not necessary for this
stage. Using platform specific generator may ease the toolchain configuration.

# Building

## Dependencies

### CMake

CMake 3.15 or later versions should be OK, though more recent versions like 3.20+ are not tested.

### Ninja

In order to enable CMake to export "compile_commands.json" file, the "Ninja" generator is used for
the user project.

You need to install the [`ninja`](https://ninja-build.org/) build tool, I recommend going to
[official release page](https://github.com/ninja-build/ninja/releases) to download the binary and
just put the binary at your `PATH`.

## Using the "run-cmake" script

The following example applies on Linux. You should use `run-cmake.bat` for Windows.

```shell
# To configure and build the "thirdparty" stage
./run-cmake thirdparty

# To configure the "main" stage (must be done AFTER "thirdparty")
./run-cmake
```

# Developing

If you prefer to use Visual Studio (on Windows) or Xcode (on macOS), you should change the generator
at "main" stage to the corresponding IDE's flavors, e.g. "Visual Studio 14 2015 Win64" for Windows,
or "Xcode" for macOS).

## Visual Studio Code

(TODO)
