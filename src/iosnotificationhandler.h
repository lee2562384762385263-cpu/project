#ifndef IOSNOTIFICATIONHANDLER_H
#define IOSNOTIFICATIONHANDLER_H

#include <QObject>
#include <QVariantMap>

class NotificationManager;

class IOSNotificationHandler : public QObject
{
    Q_OBJECT

public:
    static void initialize(NotificationManager *manager);
    static void requestPermission();

#ifdef Q_OS_IOS
    static void handleLaunchOptions(void *launchOptions);
    static void handleNotificationResponse(void *response);
    static void setupNotificationDelegate();
#endif // Q_OS_IOS

private:
    static NotificationManager *s_notificationManager;
#ifdef Q_OS_IOS
    static void *s_delegate;
#endif // Q_OS_IOS
};

#endif // IOSNOTIFICATIONHANDLER_H