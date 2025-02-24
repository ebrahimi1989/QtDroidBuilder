#!/bin/bash
set -e
PROJECT_DIR="$1"
BUILD_DIR="${PROJECT_DIR}/build-android"
echo "Building for ARMv7 in $BUILD_DIR..."
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1
if [ ! -f "${PROJECT_DIR}/CMakeLists.txt" ]; then echo "Error: CMakeLists.txt not found"; exit 1; fi
cmake "$PROJECT_DIR" -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/opt/qt/6.3.2/android_armv7 -DCMAKE_TOOLCHAIN_FILE=/opt/qt/6.3.2/android_armv7/lib/cmake/Qt6/qt.toolchain.cmake -DANDROID_SDK=/opt/android-sdk -DANDROID_NDK=/opt/android-sdk/ndk/25.1.8937393 -DANDROID_PLATFORM=android-33 -DANDROID_ABI=armeabi-v7a -DQT_ANDROID_GENERATE_APK=ON || { echo "CMake failed for ARMv7"; exit 1; }
ninja || { echo "Ninja failed for ARMv7"; exit 1; }
echo "Signing ARMv7 APK..."
/opt/android-sdk/build-tools/33.0.0/apksigner sign --ks /src/android/my-release-key.jks --ks-pass pass:password --out android-build/build/outputs/apk/debug/android-build-signed.apk android-build/build/outputs/apk/debug/android-build-debug.apk || { echo "Signing failed for ARMv7"; exit 1; }
BUILD_DIR_ARM64="${PROJECT_DIR}/build-android-arm64"
echo "Building for ARM64 in $BUILD_DIR_ARM64..."
mkdir -p "$BUILD_DIR_ARM64"
cd "$BUILD_DIR_ARM64" || exit 1
cmake "$PROJECT_DIR" -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/opt/qt/6.3.2/android_arm64_v8a -DCMAKE_TOOLCHAIN_FILE=/opt/qt/6.3.2/android_arm64_v8a/lib/cmake/Qt6/qt.toolchain.cmake -DANDROID_SDK=/opt/android-sdk -DANDROID_NDK=/opt/android-sdk/ndk/25.1.8937393 -DANDROID_PLATFORM=android-33 -DANDROID_ABI=arm64-v8a -DQT_ANDROID_GENERATE_APK=ON || { echo "CMake failed for ARM64"; exit 1; }
ninja || { echo "Ninja failed for ARM64"; exit 1; }
echo "Signing ARM64 APK..."
/opt/android-sdk/build-tools/33.0.0/apksigner sign --ks /src/android/my-release-key.jks --ks-pass pass:password --out android-build/build/outputs/apk/debug/android-build-signed.apk android-build/build/outputs/apk/debug/android-build-debug.apk || { echo "Signing failed for ARM64"; exit 1; }
echo "Build completed. Signed APK files can be found in:"
echo "ARMv7: ${BUILD_DIR}/android-build/build/outputs/apk/debug/android-build-signed.apk"
echo "ARM64: ${BUILD_DIR_ARM64}/android-build/build/outputs/apk/debug/android-build-signed.apk"
