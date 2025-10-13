#include "iosnotificationhandler.h"
#include <QDebug>

#ifndef Q_OS_IOS

// Stub implementations for non-iOS platforms
void IOSNotificationHandler::initialize(NotificationManager *manager)
{
    Q_UNUSED(manager)
    qDebug() << "IOSNotificationHandler::initialize() - stub implementation (not on iOS)";
}

void IOSNotificationHandler::requestPermission()
{
    qDebug() << "IOSNotificationHandler::requestPermission() - stub implementation (not on iOS)";
}

#endif // !Q_OS_IOS