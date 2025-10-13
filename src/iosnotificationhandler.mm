#include "iosnotificationhandler.h"

#ifdef Q_OS_IOS

#include "notificationmanager.h"
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

@interface NotificationDelegate : NSObject <UNUserNotificationCenterDelegate>
@end

@implementation NotificationDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center 
       willPresentNotification:(UNNotification *)notification 
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    // Handle notification when app is in foreground
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSString *title = notification.request.content.title;
    NSString *body = notification.request.content.body;
    
    // Convert userInfo to JSON string
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&error];
    NSString *jsonString = @"{}";
    if (!error && jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    QString titleStr = QString::fromNSString(title);
    QString bodyStr = QString::fromNSString(body);
    QString dataStr = QString::fromNSString(jsonString);
    
    QJsonDocument doc = QJsonDocument::fromJson(dataStr.toUtf8());
    QVariantMap dataMap = doc.object().toVariantMap();
    
    if (IOSNotificationHandler::s_notificationManager) {
        QMetaObject::invokeMethod(IOSNotificationHandler::s_notificationManager, 
                                  "handleNotificationReceived",
                                  Qt::QueuedConnection,
                                  Q_ARG(QString, titleStr),
                                  Q_ARG(QString, bodyStr),
                                  Q_ARG(QVariantMap, dataMap));
    }
    
    // Show notification even when app is in foreground
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center 
didReceiveNotificationResponse:(UNNotificationResponse *)response 
         withCompletionHandler:(void (^)(void))completionHandler {
    
    // Handle notification tap
    IOSNotificationHandler::handleNotificationResponse((__bridge void*)response);
    completionHandler();
}

@end

NotificationManager *IOSNotificationHandler::s_notificationManager = nullptr;
void *IOSNotificationHandler::s_delegate = nullptr;

void IOSNotificationHandler::initialize(NotificationManager *manager)
{
    s_notificationManager = manager;
    setupNotificationDelegate();
    
    // Check if app was launched from notification
    NSDictionary *launchOptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"LaunchOptions"];
    if (launchOptions) {
        handleLaunchOptions((__bridge void*)launchOptions);
    }
}

void IOSNotificationHandler::requestPermission()
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (s_notificationManager) {
                QMetaObject::invokeMethod(s_notificationManager, 
                                          "notificationPermissionResult",
                                          Qt::QueuedConnection,
                                          Q_ARG(bool, granted));
            }
        });
    }];
}

void IOSNotificationHandler::handleLaunchOptions(void *launchOptions)
{
    if (!launchOptions) return;
    
    NSDictionary *options = (__bridge NSDictionary*)launchOptions;
    NSDictionary *notificationInfo = options[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (notificationInfo) {
        // Extract notification data
        NSString *title = notificationInfo[@"aps"][@"alert"][@"title"] ?: @"";
        NSString *body = notificationInfo[@"aps"][@"alert"][@"body"] ?: @"";
        
        // Convert to JSON string
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:notificationInfo options:0 error:&error];
        NSString *jsonString = @"{}";
        if (!error && jsonData) {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        QString titleStr = QString::fromNSString(title);
        QString bodyStr = QString::fromNSString(body);
        QString dataStr = QString::fromNSString(jsonString);
        
        QJsonDocument doc = QJsonDocument::fromJson(dataStr.toUtf8());
        QVariantMap dataMap = doc.object().toVariantMap();
        
        if (s_notificationManager) {
            s_notificationManager->handleAppLaunchedFromNotification(titleStr, bodyStr, dataMap);
        }
    }
}

void IOSNotificationHandler::handleNotificationResponse(void *response)
{
    if (!response) return;
    
    UNNotificationResponse *notificationResponse = (__bridge UNNotificationResponse*)response;
    UNNotification *notification = notificationResponse.notification;
    
    NSString *title = notification.request.content.title;
    NSString *body = notification.request.content.body;
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // Convert userInfo to JSON string
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&error];
    NSString *jsonString = @"{}";
    if (!error && jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    QString titleStr = QString::fromNSString(title);
    QString bodyStr = QString::fromNSString(body);
    QString dataStr = QString::fromNSString(jsonString);
    
    QJsonDocument doc = QJsonDocument::fromJson(dataStr.toUtf8());
    QVariantMap dataMap = doc.object().toVariantMap();
    
    if (s_notificationManager) {
        s_notificationManager->handleAppLaunchedFromNotification(titleStr, bodyStr, dataMap);
    }
}

void IOSNotificationHandler::setupNotificationDelegate()
{
    NotificationDelegate *delegate = [[NotificationDelegate alloc] init];
    s_delegate = (__bridge_retained void*)delegate;
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = delegate;
}

#endif // Q_OS_IOS