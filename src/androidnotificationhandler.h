#ifndef ANDROIDNOTIFICATIONHANDLER_H
#define ANDROIDNOTIFICATIONHANDLER_H

#ifdef Q_OS_ANDROID

#include <QObject>
#include <QVariantMap>
#include <QJniObject>

class NotificationManager;

class AndroidNotificationHandler : public QObject
{
    Q_OBJECT

public:
    static void initialize(NotificationManager *manager);
    static void requestPermission();
    static void handleNotificationIntent(const QJniObject &intent);

private:
    static NotificationManager *s_notificationManager;
    static void registerNativeMethods();
    
    // JNI callback methods
    static void onNotificationReceived(JNIEnv *env, jobject thiz, jstring title, jstring body, jstring data);
    static void onPermissionResult(JNIEnv *env, jobject thiz, jboolean granted);
};

#endif // Q_OS_ANDROID

#endif // ANDROIDNOTIFICATIONHANDLER_H