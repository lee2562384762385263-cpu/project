#!/bin/bash

# Build script for NotificationApp
# Usage: ./build.sh [platform]
# Platforms: desktop, android, ios

PLATFORM=${1:-desktop}
BUILD_DIR="build-${PLATFORM}"

echo "Building NotificationApp for ${PLATFORM}..."

# Create build directory
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

case ${PLATFORM} in
    desktop)
        echo "Building for desktop..."
        cmake ..
        cmake --build .
        ;;
    android)
        echo "Building for Android..."
        if [ -z "$ANDROID_NDK" ]; then
            echo "Error: ANDROID_NDK environment variable not set"
            exit 1
        fi
        cmake .. \
            -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
            -DANDROID_ABI=arm64-v8a \
            -DANDROID_PLATFORM=android-23 \
            -DQT_HOST_PATH=/path/to/qt/host \
            -DCMAKE_FIND_ROOT_PATH=/path/to/qt/android
        cmake --build .
        ;;
    ios)
        echo "Building for iOS..."
        cmake .. -GXcode -DCMAKE_SYSTEM_NAME=iOS
        cmake --build . --config Release
        ;;
    *)
        echo "Unknown platform: ${PLATFORM}"
        echo "Supported platforms: desktop, android, ios"
        exit 1
        ;;
esac

echo "Build completed for ${PLATFORM}"