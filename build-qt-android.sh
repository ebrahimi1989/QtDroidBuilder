#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <url> <app_name>"
    echo "Example: $0 https://example.com MyWebApp"
    exit 1
fi

URL="$1"
APP_NAME="$2"

PROJECT_DIR="$(pwd)/qt-android-webview"
TEMPLATES_DIR="$(pwd)/templates"
echo "Creating WebView project in: $PROJECT_DIR"

mkdir -p "$PROJECT_DIR/android/res/mipmap-hdpi"
mkdir -p "$PROJECT_DIR/android/res/mipmap-mdpi"
mkdir -p "$PROJECT_DIR/android/res/mipmap-xhdpi"
mkdir -p "$PROJECT_DIR/android/res/mipmap-xxhdpi"
mkdir -p "$PROJECT_DIR/android/res/mipmap-xxxhdpi"
cd "$PROJECT_DIR" || exit 1

if [ -f "../app.png" ]; then
    cp "../app.png" "$PROJECT_DIR/android/res/mipmap-hdpi/ic_launcher.png"
    cp "../app.png" "$PROJECT_DIR/android/res/mipmap-mdpi/ic_launcher.png"
    cp "../app.png" "$PROJECT_DIR/android/res/mipmap-xhdpi/ic_launcher.png"
    cp "../app.png" "$PROJECT_DIR/android/res/mipmap-xxhdpi/ic_launcher.png"
    cp "../app.png" "$PROJECT_DIR/android/res/mipmap-xxxhdpi/ic_launcher.png"
    echo "App icon (app.png) copied to mipmap directories."
else
    echo "Warning: app.png not found in current directory. Default icon will be used."
fi

cp "$TEMPLATES_DIR/CMakeLists.txt" .
sed "s|\$URL|$URL|g" "$TEMPLATES_DIR/main.cpp" > main.cpp
cp "$TEMPLATES_DIR/main.qml" .
sed "s|\$APP_NAME|$APP_NAME|g" "$TEMPLATES_DIR/AndroidManifest.xml" > android/AndroidManifest.xml
cp "$TEMPLATES_DIR/android-libwebviewapp.so-deployment-settings.json" android/
cp "$TEMPLATES_DIR/Dockerfile" .
cp "$TEMPLATES_DIR/build.sh" .

echo "Generating keystore for signing APK..."
keytool -genkeypair -v -keystore android/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-alias -dname "CN=Test, OU=Test, O=Test, L=Test, S=Test, C=US" -storepass password -keypass password

echo "Building Docker image..."
docker build -t my-android-webview-builder .

echo "Running Docker container to build signed APKs..."
CONTAINER_ID=$(docker run -d my-android-webview-builder)

echo "Waiting for build to complete..."
EXIT_CODE=$(docker wait "$CONTAINER_ID")

if [ "$EXIT_CODE" -ne 0 ]; then
    echo "Build failed with exit code $EXIT_CODE. Checking logs..."
    docker logs "$CONTAINER_ID"
    exit 1
fi

echo "Copying build log to host..."
docker cp "$CONTAINER_ID:/src/build.log" ./build.log

echo "Copying APKs to host..."
docker cp "$CONTAINER_ID:/src/build-android/android-build/build/outputs/apk/debug/android-build-debug.apk" "./${APP_NAME}-armv7-debug.apk" || echo "Failed to copy ARMv7 debug APK"
docker cp "$CONTAINER_ID:/src/build-android/android-build/build/outputs/apk/debug/android-build-signed.apk" "./${APP_NAME}-armv7-signed.apk" || echo "Failed to copy ARMv7 signed APK"
docker cp "$CONTAINER_ID:/src/build-android-arm64/android-build/build/outputs/apk/debug/android-build-debug.apk" "./${APP_NAME}-arm64-debug.apk" || echo "Failed to copy ARM64 debug APK"
docker cp "$CONTAINER_ID:/src/build-android-arm64/android-build/build/outputs/apk/debug/android-build-signed.apk" "./${APP_NAME}-arm64-signed.apk" || echo "Failed to copy ARM64 signed APK"

echo "Cleaning up container..."
docker rm "$CONTAINER_ID"

echo "Build completed. APK files are in the current directory:"
ls -lh "${APP_NAME}"-arm*-*.apk
echo "Build log is saved as build.log. Check it if there were issues."
echo "You can install them with: adb install ${APP_NAME}-arm64-signed.apk"
