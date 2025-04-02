#!/bin/sh
set -euo pipefail
cd $(dirname $(dirname $(realpath $0)))
set -x

platform=$(uname -s)
cd sox-src
make clean

if [ "$platform" = "Darwin" ]; then
    echo "Building for macOS (Universal Binary)..."
    
    # Build for Intel (x86_64)
    CFLAGS="-arch x86_64 -Wno-incompatible-function-pointer-types" ./configure --enable-static
    make -s
    mkdir -p ../sox-build/x86_64
    cp ./src/sox ../sox-build/x86_64/sox
    cp -r ./src/.libs ../sox-build/x86_64/
    make clean

    # Build for ARM (arm64)
    mkdir -p ../sox-build/arm64
    CFLAGS="-arch arm64 -Wno-incompatible-function-pointer-types" ./configure --enable-static
    make -s
    mkdir -p ../sox-build/arm64
    cp ./src/sox ../sox-build/arm64/sox
    cp -r ./src/.libs ../sox-build/arm64/
    make clean

    # Create universal binary
    mkdir -p ../sox-build/universal/.libs
    lipo -create "../sox-build/x86_64/sox" "../sox-build/arm64/sox" -output "../sox-build/universal/sox"

    for lib in ../sox-build/x86_64/.libs/*.dylib; do
        base_lib=$(basename "$lib")
        if [ -f "../sox-build/arm64/.libs/$base_lib" ]; then
            lipo -create "../sox-build/x86_64/.libs/$base_lib" "../sox-build/arm64/.libs/$base_lib" -output "../sox-build/universal/.libs/$base_lib"
        fi
    done

    ../sox-build/universal/sox -h
elif [ "$platform" = "Linux" ]; then
    echo "Building for Linux..."
    CFLAGS="-Wno-incompatible-function-pointer-types" ./configure
    make -s
    ./src/sox -h
else
    echo "Unsupported platform: $platform"
    exit 1
fi
