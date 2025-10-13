#include "iosnotificationhandler.h"
#include "notificationmanager.h"
#include <QDebug>

// Static member definition (shared across all platforms)
NotificationManager *IOSNotificationHandler::s_notificationManager = nullptr;

#ifndef Q_OS_IOS

// Stub implementations for non-iOS platforms
void IOSNotificationHandler::initialize(NotificationManager *manager)
{
    s_notificationManager = manager;
    qDebug() << "IOSNotificationHandler::initialize() - stub implementation (not on iOS)";
}

void IOSNotificationHandler::requestPermission()
{
    qDebug() << "IOSNotificationHandler::requestPermission() - stub implementation (not on iOS)";
}

#endif // !Q_OS_IOS