#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("initialUrl", "https://www.aparat.com");
    const QUrl url(QStringLiteral("qrc:/qt/qml/WebViewApp/main.qml"));
    engine.load(url);
    if (engine.rootObjects().isEmpty()) {
        qWarning() << "Failed to load QML file";
        return -1;
    }
    return app.exec();
}
