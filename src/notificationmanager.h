#ifndef NOTIFICATIONMANAGER_H
#define NOTIFICATIONMANAGER_H

#include <QObject>
#include <QString>
#include <QVariantMap>

class NotificationManager : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(QString lastNotificationTitle READ lastNotificationTitle NOTIFY lastNotificationChanged)
    Q_PROPERTY(QString lastNotificationBody READ lastNotificationBody NOTIFY lastNotificationChanged)
    Q_PROPERTY(QVariantMap lastNotificationData READ lastNotificationData NOTIFY lastNotificationChanged)
    Q_PROPERTY(bool hasNotificationData READ hasNotificationData NOTIFY lastNotificationChanged)

public:
    explicit NotificationManager(QObject *parent = nullptr);
    
    // Property getters
    QString lastNotificationTitle() const { return m_lastNotificationTitle; }
    QString lastNotificationBody() const { return m_lastNotificationBody; }
    QVariantMap lastNotificationData() const { return m_lastNotificationData; }
    bool hasNotificationData() const { return !m_lastNotificationTitle.isEmpty(); }

public slots:
    // Called from QML
    void requestNotificationPermission();
    void clearNotificationData();
    
    // Called from platform-specific code
    void handleNotificationReceived(const QString &title, const QString &body, const QVariantMap &data);
    void handleAppLaunchedFromNotification(const QString &title, const QString &body, const QVariantMap &data);

signals:
    void lastNotificationChanged();
    void notificationPermissionResult(bool granted);
    void notificationReceived(const QString &title, const QString &body);

private:
    QString m_lastNotificationTitle;
    QString m_lastNotificationBody;
    QVariantMap m_lastNotificationData;
    
    void initializePlatformSpecific();
};

#endif // NOTIFICATIONMANAGER_H