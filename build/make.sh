#!/bin/sh
set -euo pipefail
cd $(dirname $(dirname $(realpath $0)))

# Detect platform
platform=$(uname -s)

if [ "$platform" = "Darwin" ]; then
    echo "Building for macOS (Universal Binary)..."
    
    # Build for Intel (x86_64)
    mkdir -p sox-build/x86_64
    cd sox-src
    CFLAGS="-arch x86_64 -Wno-incompatible-function-pointer-types" ./configure --prefix=$(pwd)/../sox-build/x86_64
    make -s
    make install
    make clean

    # Build for ARM (arm64)
    mkdir -p sox-build/arm64
    CFLAGS="-arch arm64 -Wno-incompatible-function-pointer-types" ./configure --prefix=$(pwd)/../sox-build/arm64
    make -s
    make install
    make clean

    # Create universal binary
    cd ../sox-build
    mkdir -p universal/bin
    lipo -create x86_64/bin/sox arm64/bin/sox -output universal/bin/sox
    lipo -create x86_64/bin/soxi arm64/bin/soxi -output universal/bin/soxi
    lipo -create x86_64/bin/play arm64/bin/play -output universal/bin/play
    lipo -create x86_64/bin/rec arm64/bin/rec -output universal/bin/rec
    
    # Create universal lib directory and combine libraries
    mkdir -p universal/lib
    for lib in x86_64/lib/*.dylib; do
        base_lib=$(basename "$lib")
        if [ -f "arm64/lib/$base_lib" ]; then
            lipo -create "x86_64/lib/$base_lib" "arm64/lib/$base_lib" -output "universal/lib/$base_lib"
        fi
    done

elif [ "$platform" = "Linux" ]; then
    echo "Building for Linux (x86_64)..."
    
    cd sox-src
    ./configure --prefix=$(pwd)/../sox-build/x86_64
    make -s
    make install
else
    echo "Unsupported platform: $platform"
    exit 1
fi
