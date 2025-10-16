#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include <QDebug>
#include "src/notificationmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Register the NotificationManager type with QML
    qmlRegisterType<NotificationManager>("NotificationApp", 1, 0, "NotificationManager");

    // Create notification manager instance
    qDebug() << "Creating NotificationManager instance";
    NotificationManager notificationManager;

    QQmlApplicationEngine engine;
    
    // Register the NotificationManager instance with QML
    engine.rootContext()->setContextProperty("notificationManager", &notificationManager);
    
    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return app.exec();
}