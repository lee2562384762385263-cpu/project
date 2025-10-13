#ifndef IOSNOTIFICATIONHANDLER_H
#define IOSNOTIFICATIONHANDLER_H

#ifdef Q_OS_IOS

#include <QObject>
#include <QVariantMap>

class NotificationManager;

class IOSNotificationHandler : public QObject
{
    Q_OBJECT

public:
    static void initialize(NotificationManager *manager);
    static void requestPermission();
    static void handleLaunchOptions(void *launchOptions);
    static void handleNotificationResponse(void *response);

private:
    static NotificationManager *s_notificationManager;
    static void *s_delegate;
    
    static void setupNotificationDelegate();
};

#endif // Q_OS_IOS

#endif // IOSNOTIFICATIONHANDLER_H