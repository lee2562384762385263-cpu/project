#include "notificationmanager.h"
#include <QDebug>
#include <QCoreApplication>

#ifdef Q_OS_ANDROID
#include "androidnotificationhandler.h"
#endif

#ifdef Q_OS_IOS
#include "iosnotificationhandler.h"
#endif

NotificationManager::NotificationManager(QObject *parent)
    : QObject(parent)
{
    initializePlatformSpecific();
    
    // Check if app was launched from notification
    QStringList args = QCoreApplication::arguments();
    for (int i = 0; i < args.size(); ++i) {
        if (args[i] == "--notification-data" && i + 1 < args.size()) {
            // Parse notification data from command line arguments
            // This is a simplified approach - in real implementation,
            // platform-specific code would handle this
            qDebug() << "App launched from notification with data:" << args[i + 1];
            break;
        }
    }
}

void NotificationManager::requestNotificationPermission()
{
    qDebug() << "Requesting notification permission...";
    
#ifdef Q_OS_ANDROID
    AndroidNotificationHandler::requestPermission();
#elif defined(Q_OS_IOS)
    IOSNotificationHandler::requestPermission();
#else
    // Desktop - simulate permission granted
    emit notificationPermissionResult(true);
#endif
}

void NotificationManager::clearNotificationData()
{
    m_lastNotificationTitle.clear();
    m_lastNotificationBody.clear();
    m_lastNotificationData.clear();
    emit lastNotificationChanged();
}

void NotificationManager::handleNotificationReceived(const QString &title, const QString &body, const QVariantMap &data)
{
    qDebug() << "Notification received:" << title << body;
    
    m_lastNotificationTitle = title;
    m_lastNotificationBody = body;
    m_lastNotificationData = data;
    
    emit lastNotificationChanged();
    emit notificationReceived(title, body);
}

void NotificationManager::handleAppLaunchedFromNotification(const QString &title, const QString &body, const QVariantMap &data)
{
    qDebug() << "App launched from notification:" << title << body;
    
    m_lastNotificationTitle = title;
    m_lastNotificationBody = body;
    m_lastNotificationData = data;
    
    emit lastNotificationChanged();
}

void NotificationManager::initializePlatformSpecific()
{
#ifdef Q_OS_ANDROID
    // Initialize Android-specific notification handling
    AndroidNotificationHandler::initialize(this);
#elif defined(Q_OS_IOS)
    // Initialize iOS-specific notification handling
    IOSNotificationHandler::initialize(this);
#else
    qDebug() << "Running on desktop - notification features limited";
#endif
}