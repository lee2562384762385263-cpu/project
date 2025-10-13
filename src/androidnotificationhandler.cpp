#include "androidnotificationhandler.h"
#include <QDebug>

#ifdef Q_OS_ANDROID

#include "notificationmanager.h"
#include <QJniObject>
#include <QJniEnvironment>
#include <QCoreApplication>
#include <QJsonDocument>
#include <QJsonObject>

NotificationManager *AndroidNotificationHandler::s_notificationManager = nullptr;

void AndroidNotificationHandler::initialize(NotificationManager *manager)
{
    s_notificationManager = manager;
    registerNativeMethods();
    
    // Check if app was launched from notification
    QJniObject activity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative", 
                                                              "activity", 
                                                              "()Landroid/app/Activity;");
    if (activity.isValid()) {
        QJniObject intent = activity.callObjectMethod("getIntent", "()Landroid/content/Intent;");
        if (intent.isValid()) {
            handleNotificationIntent(intent);
        }
    }
}

void AndroidNotificationHandler::requestPermission()
{
    QJniObject::callStaticMethod<void>("com/example/notificationapp/NotificationHelper",
                                       "requestNotificationPermission",
                                       "()V");
}

void AndroidNotificationHandler::handleNotificationIntent(const QJniObject &intent)
{
    if (!intent.isValid()) return;
    
    // Check if this intent came from a notification
    QJniObject action = intent.callObjectMethod("getAction", "()Ljava/lang/String;");
    if (!action.isValid()) return;
    
    QString actionString = action.toString();
    if (actionString == "NOTIFICATION_CLICKED") {
        // Extract notification data from intent extras
        QJniObject extras = intent.callObjectMethod("getExtras", "()Landroid/os/Bundle;");
        if (extras.isValid()) {
            QJniObject titleObj = extras.callObjectMethod("getString", 
                                                          "(Ljava/lang/String;)Ljava/lang/String;",
                                                          QJniObject::fromString("notification_title").object<jstring>());
            QJniObject bodyObj = extras.callObjectMethod("getString", 
                                                         "(Ljava/lang/String;)Ljava/lang/String;",
                                                         QJniObject::fromString("notification_body").object<jstring>());
            QJniObject dataObj = extras.callObjectMethod("getString", 
                                                         "(Ljava/lang/String;)Ljava/lang/String;",
                                                         QJniObject::fromString("notification_data").object<jstring>());
            
            QString title = titleObj.isValid() ? titleObj.toString() : "";
            QString body = bodyObj.isValid() ? bodyObj.toString() : "";
            QString dataString = dataObj.isValid() ? dataObj.toString() : "{}";
            
            // Parse JSON data
            QJsonDocument doc = QJsonDocument::fromJson(dataString.toUtf8());
            QVariantMap data = doc.object().toVariantMap();
            
            if (s_notificationManager) {
                s_notificationManager->handleAppLaunchedFromNotification(title, body, data);
            }
        }
    }
}

void AndroidNotificationHandler::registerNativeMethods()
{
    JNINativeMethod methods[] = {
        {"onNotificationReceived", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", 
         reinterpret_cast<void*>(onNotificationReceived)},
        {"onPermissionResult", "(Z)V", 
         reinterpret_cast<void*>(onPermissionResult)}
    };
    
    QJniEnvironment env;
    jclass clazz = env.findClass("com/example/notificationapp/NotificationHelper");
    if (clazz) {
        env->RegisterNatives(clazz, methods, sizeof(methods) / sizeof(methods[0]));
    }
}

void AndroidNotificationHandler::onNotificationReceived(JNIEnv *env, jobject thiz, jstring title, jstring body, jstring data)
{
    Q_UNUSED(thiz)
    
    const char *titleChars = env->GetStringUTFChars(title, nullptr);
    const char *bodyChars = env->GetStringUTFChars(body, nullptr);
    const char *dataChars = env->GetStringUTFChars(data, nullptr);
    
    QString titleStr = QString::fromUtf8(titleChars);
    QString bodyStr = QString::fromUtf8(bodyChars);
    QString dataStr = QString::fromUtf8(dataChars);
    
    env->ReleaseStringUTFChars(title, titleChars);
    env->ReleaseStringUTFChars(body, bodyChars);
    env->ReleaseStringUTFChars(data, dataChars);
    
    // Parse JSON data
    QJsonDocument doc = QJsonDocument::fromJson(dataStr.toUtf8());
    QVariantMap dataMap = doc.object().toVariantMap();
    
    if (s_notificationManager) {
        QMetaObject::invokeMethod(s_notificationManager, "handleNotificationReceived",
                                  Qt::QueuedConnection,
                                  Q_ARG(QString, titleStr),
                                  Q_ARG(QString, bodyStr),
                                  Q_ARG(QVariantMap, dataMap));
    }
}

void AndroidNotificationHandler::onPermissionResult(JNIEnv *env, jobject thiz, jboolean granted)
{
    Q_UNUSED(env)
    Q_UNUSED(thiz)
    
    if (s_notificationManager) {
        QMetaObject::invokeMethod(s_notificationManager, "notificationPermissionResult",
                                  Qt::QueuedConnection,
                                  Q_ARG(bool, granted));
    }
}

#else // !Q_OS_ANDROID

// Stub implementations for non-Android platforms
void AndroidNotificationHandler::initialize(NotificationManager *manager)
{
    Q_UNUSED(manager)
    qDebug() << "AndroidNotificationHandler::initialize() - stub implementation (not on Android)";
}

void AndroidNotificationHandler::requestPermission()
{
    qDebug() << "AndroidNotificationHandler::requestPermission() - stub implementation (not on Android)";
}

#endif // Q_OS_ANDROID