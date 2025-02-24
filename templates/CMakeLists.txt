cmake_minimum_required(VERSION 3.16)
project(WebViewApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 COMPONENTS Core Quick WebView QuickControls2 REQUIRED)

qt_add_executable(webviewapp
    main.cpp
)

qt_add_qml_module(webviewapp
    URI WebViewApp
    VERSION 1.0
    QML_FILES main.qml
    RESOURCE_PREFIX /qt/qml
)

target_link_libraries(webviewapp PRIVATE Qt6::Core Qt6::Quick Qt6::WebView Qt6::QuickControls2)

set_target_properties(webviewapp PROPERTIES
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
    QT_ANDROID_MIN_SDK_VERSION "23"
    QT_ANDROID_TARGET_SDK_VERSION "33"
)
