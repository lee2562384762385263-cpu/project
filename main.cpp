#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "src/notificationmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Create notification manager instance
    NotificationManager notificationManager;

    QQmlApplicationEngine engine;
    
    // Register the NotificationManager with QML
    engine.rootContext()->setContextProperty("notificationManager", &notificationManager);
    
    const QUrl url(QStringLiteral("qrc:/NotificationApp/Main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return app.exec();
}