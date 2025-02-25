# QtDroidBuilder

![GitHub License](https://img.shields.io/github/license/ebrahimi1989/QtDroidBuilder)  
![GitHub Issues](https://img.shields.io/github/issues/ebrahimi1989/QtDroidBuilder)  
![GitHub Stars](https://img.shields.io/github/stars/ebrahimi1989/QtDroidBuilder?style=social) 
![GitHub Workflow Status](https://github.com/ebrahimi1989/QtDroidBuilder/actions/workflows/build-apk.yml/badge.svg)

A simple Bash script to build Qt/QML-based Android applications with WebView support, packaged as signed APKs using Docker. Create your own Android app with a custom URL and icon in just a few steps!

## Features
- Builds Android APKs for ARMv7 and ARM64 architectures.
- Uses Qt 6.3.2 and WebView to display any URL as an app.
- Supports custom app icons via a single `app.png` file.
- Automated Docker-based build process for consistency.
- Generates signed APKs ready for installation on Android devices.

## Prerequisites
Before you start, ensure you have the following installed:
- **Docker**: For building the project in a containerized environment.
  - Install on Ubuntu: `sudo apt install docker.io`
- **ADB (Android Debug Bridge)**: For installing the APK on an Android device.
  - Install on Ubuntu: `sudo apt install android-tools-adb`
- **Java Development Kit (JDK)**: Required for keystore generation (e.g., OpenJDK 11).
  - Install on Ubuntu: `sudo apt install openjdk-11-jdk`
- An optional `app.png` file (e.g., 512x512 PNG) for the app icon.

## Usage
Follow these steps to build your Qt-based Android WebView application:
1. Clone the repository:
Clone the repository from GitHub and navigate to the project directory:
   ```bash
   git clone https://github.com/username/QtDroidBuilder.git
   cd QtDroidBuilder
   ```
2. Prepare the templates:
Ensure the templates directory contains all required files (CMakeLists.txt, main.cpp, main.qml, AndroidManifest.xml, android-libwebviewapp.so-deployment-settings.json, Dockerfile, and build.sh). These files are provided in the repository. If they are missing, refer to the project documentation to create them.

3. (Optional) Add a custom icon:
Place your custom icon as app.png in the project root directory (e.g., QtDroidBuilder/). This icon will be used for the Android app across various screen densities. Recommended size is 512x512 pixels, but Android will scale it automatically.

4. Run the script:
Execute the main build script with a URL and an app name. The URL will be loaded in the WebView, and the app name will be used as the application label:
  ```
chmod +x build-qt-android.sh
./build-qt-android.sh <url> <app_name>
  ```
5. Wait for the Docker build to complete. The signed APKs will be in the current directory:

- MyWebApp-armv7-signed.apk

- MyWebApp-arm64-signed.apk

Install the APK on your Android device:
```bash
adb install MyWebApp-arm64-signed.apk
```

## Project Structure
```text
QtDroidBuilder/
├── build-qt-android.sh          # Main script to orchestrate the build
├── templates/                   # Template files for the Qt project
│   ├── CMakeLists.txt           # CMake configuration
│   ├── main.cpp                 # Main C++ entry point
│   ├── main.qml                 # QML UI with WebView
│   ├── AndroidManifest.xml      # Android manifest
│   ├── android-libwebviewapp.so-deployment-settings.json  # Deployment settings
│   ├── Dockerfile               # Docker configuration
│   └── build.sh                 # Build script inside Docker
└── README.md                    # This file
```
## Troubleshooting
Docker build fails: Check build.log for errors:
```
cat build.log
```
Icon not applied: Ensure app.png is a valid PNG file in the root directory.
APK installation fails: Verify your device is connected (adb devices) and use the correct architecture (e.g., ARM64 for modern devices).
## Contributing
Feel free to fork this project, submit issues, or send pull requests! Suggestions for improvements are always welcome.
## License
This project is licensed under the MIT License - see the LICENSE file for details.
## Acknowledgments
Built with Qt for cross-platform development.
Powered by Docker for reproducible builds.
Inspired by the need for a simple Android WebView app generator.
