import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebView 1.1

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "WebView App"

    WebView {
        id: webView
        anchors.fill: parent
        url: initialUrl
    }
}
