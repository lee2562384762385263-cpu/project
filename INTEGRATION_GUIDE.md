# 📱 Notification System Integration Guide

## 🎯 Files to Copy to Your Project

### **Core Notification System Files:**
```
src/notificationmanager.h
src/notificationmanager.cpp
src/iosnotificationhandler.h  
src/iosnotificationhandler.mm
src/androidnotificationhandler.h
src/androidnotificationhandler.cpp
```

### **iOS Configuration Files:**
```
ios/Info.plist                    # iOS app configuration
```

### **Project Configuration:**
```
NotificationApp.pro               # Reference for .pro file changes
```

---

## 🔧 **Step-by-Step Integration**

### **Step 1: Copy Source Files**
Copy the notification system files to your project's source directory:
- `src/notificationmanager.*` - Cross-platform notification manager
- `src/iosnotificationhandler.*` - iOS-specific implementation  
- `src/androidnotificationhandler.*` - Android-specific implementation

### **Step 2: Update Your .pro File**
Add these sections to your existing `.pro` file:

```qmake
# Notification system sources
SOURCES += \
    src/notificationmanager.cpp

HEADERS += \
    src/notificationmanager.h

# iOS-specific configuration
ios {
    SOURCES += src/iosnotificationhandler.mm
    HEADERS += src/iosnotificationhandler.h
    
    # iOS frameworks
    LIBS += -framework Foundation
    LIBS += -framework UIKit  
    LIBS += -framework UserNotifications
    
    # iOS deployment target
    QMAKE_IOS_DEPLOYMENT_TARGET = 14.0
    
    # Bundle identifier (change to your app's ID)
    QMAKE_BUNDLE_IDENTIFIER = com.yourcompany.yourapp
    
    # Info.plist
    QMAKE_INFO_PLIST = ios/Info.plist
}

# Android-specific configuration  
android {
    SOURCES += src/androidnotificationhandler.cpp
    HEADERS += src/androidnotificationhandler.h
}
```

### **Step 3: Update Your main.cpp**
Add notification manager registration to your existing `main.cpp`:

```cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "src/notificationmanager.h"  // Add this

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    
    // Register notification manager (ADD THIS)
    NotificationManager notificationManager;
    engine.rootContext()->setContextProperty("notificationManager", &notificationManager);
    
    // Your existing QML loading code
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    
    return app.exec();
}
```

### **Step 4: Create iOS Info.plist**
Create `ios/Info.plist` in your project (copy from our working version):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>Your App Name</string>
    <key>CFBundleExecutable</key>
    <string>${EXECUTABLE_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>com.yourcompany.yourapp</string>
    <key>CFBundleName</key>
    <string>Your App Name</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
</dict>
</plist>
```

### **Step 5: Add QML Integration**
In your main QML file, add notification functionality:

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    // Your existing app content
    
    // Add notification display area
    Rectangle {
        id: notificationArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100
        color: "lightblue"
        visible: false
        
        Column {
            anchors.centerIn: parent
            Text {
                id: notificationTitle
                font.bold: true
            }
            Text {
                id: notificationBody
            }
        }
    }
    
    // Add notification request button
    Button {
        text: "Request Notification Permission"
        onClicked: notificationManager.requestPermission()
    }
    
    // Connect to notification signals
    Connections {
        target: notificationManager
        
        function onNotificationReceived(title, body, data) {
            notificationTitle.text = title
            notificationBody.text = body
            notificationArea.visible = true
            
            // Hide after 5 seconds
            hideTimer.start()
        }
        
        function onPermissionGranted() {
            console.log("Notification permission granted!")
        }
        
        function onPermissionDenied() {
            console.log("Notification permission denied!")
        }
    }
    
    Timer {
        id: hideTimer
        interval: 5000
        onTriggered: notificationArea.visible = false
    }
}
```

---

## 🔍 **Key Differences from didFinishLaunchingWithOptions**

### **Traditional iOS Approach:**
```objc
// AppDelegate.m
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Handle launch from notification
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        // Process notification
    }
    return YES;
}
```

### **Our Qt/QML Approach:**
```cpp
// iosnotificationhandler.mm
- (void)userNotificationCenter:(UNUserNotificationCenter *)center 
       didReceiveNotificationResponse:(UNNotificationResponse *)response 
                withCompletionHandler:(void (^)(void))completionHandler {
    
    // Extract notification data
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    // Send to Qt/QML via signals
    emit notificationReceived(title, body, customData);
    
    completionHandler();
}
```

**Key Advantage:** Our approach works seamlessly with Qt's event system and QML, automatically handling app launch and notification processing.

---

## 🧪 **Testing Your Integration**

### **1. Build and Test:**
```bash
# Clean build
qmake && make clean && make

# Test on iOS simulator
# (Build through Qt Creator or Xcode)
```

### **2. Test Notification Script:**
Create a test script for your app (modify bundle identifier):

```bash
#!/bin/bash
# send_test_notification_yourapp.sh

BUNDLE_ID="com.yourcompany.yourapp"  # Change this!

xcrun simctl push booted "$BUNDLE_ID" - <<EOF
{
    "aps": {
        "alert": {
            "title": "Your App Notification",
            "body": "This is a test notification for your app!"
        },
        "sound": "default"
    },
    "customData": {
        "type": "test",
        "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    }
}
EOF
```

### **3. Test Scenarios:**
1. **Permission Request:** Tap "Request Notification Permission"
2. **Send Notification:** Run your test script
3. **App Launch:** Close app, send notification, tap to launch
4. **Content Display:** Verify notification content appears in your app

---

## ✅ **Integration Checklist**

- [ ] Copy notification source files
- [ ] Update .pro file with iOS/Android configurations  
- [ ] Modify main.cpp to register NotificationManager
- [ ] Create ios/Info.plist with your bundle ID
- [ ] Add QML notification UI components
- [ ] Update bundle identifier in .pro and test script
- [ ] Test permission request
- [ ] Test notification delivery
- [ ] Test app launch from notification
- [ ] Test notification content display

**The system handles app launch automatically - no need for didFinishLaunchingWithOptions!** 🎉