# 📱 iOS Console Logging Guide

## 🎯 **What to Filter For in Mac Console**

### **Primary Filters (Use These):**
```
1. Your Bundle ID: "com.example.notificationapp" (or your actual bundle ID)
2. Process Name: "NotificationApp" (or your actual app name)
3. Specific Log Messages: "IOSNotificationHandler" or "NotificationManager"
```

### **Console.app Filter Setup:**
1. Open **Console.app** on Mac
2. Connect your iOS device
3. Select your device in sidebar
4. In the search box, try these filters:

**Option A - Bundle ID Filter:**
```
process:com.example.notificationapp
```

**Option B - App Name Filter:**
```
process:NotificationApp
```

**Option C - Specific Component Filter:**
```
subsystem:com.example.notificationapp AND category:default
```

**Option D - Content-based Filter:**
```
IOSNotificationHandler OR NotificationManager OR "Creating NotificationManager"
```

## 📋 **Expected Log Messages (Even Without QML Frontend)**

### **1. App Startup Logs:**
```
Creating NotificationManager instance
IOSNotificationHandler::initialize() called
IOSNotificationHandler: Setting up notification delegate
IOSNotificationHandler::requestPermission() called
iOS notification permission result: 1
```

### **2. When Notification Arrives (App Running):**
```
iOS: Notification tapped while app running: [Title] [Body]
Notification received: [Title] [Body]
```

### **3. When App Launched from Notification (Terminated State):**
```
Creating NotificationManager instance
IOSNotificationHandler::initialize() called
iOS: App launched from notification: [Title] [Body]
App launched from notification: [Title] [Body]
```

## 🔧 **Troubleshooting Missing Logs**

### **If No Logs Appear:**

1. **Check Bundle ID Match:**
   ```bash
   # In your .pro file, verify:
   QMAKE_BUNDLE_IDENTIFIER = com.example.notificationapp
   ```

2. **Enable Qt Logging:**
   Add to your app's environment or code:
   ```cpp
   // In main.cpp, add before QGuiApplication:
   QLoggingCategory::setFilterRules("*=true");
   ```

3. **Use Broader Filter:**
   In Console.app, try just:
   ```
   NotificationApp
   ```
   (without process: prefix)

4. **Check Device Logs:**
   Sometimes logs appear under "All Messages" instead of your specific process.

## 🚀 **Testing Scenarios**

### **Test 1: App Startup**
- Launch your app
- Should see: "Creating NotificationManager instance"
- Should see: "IOSNotificationHandler::initialize() called"

### **Test 2: Permission Request**
- First launch should trigger permission dialog
- Should see: "IOSNotificationHandler::requestPermission() called"
- Should see: "iOS notification permission result: 1" (if granted)

### **Test 3: Notification While App Running**
- Send notification using: `./send_test_notification.sh`
- Tap notification
- Should see: "iOS: Notification tapped while app running: [Title] [Body]"

### **Test 4: Launch from Terminated State**
- Force quit your app
- Send notification: `./send_test_notification.sh`
- Tap notification to launch app
- Should see: "iOS: App launched from notification: [Title] [Body]"

## 🎯 **Quick Debug Commands**

### **Find Your App's Process:**
```bash
# On Mac, while app is running:
xcrun simctl spawn booted log show --predicate 'process == "NotificationApp"' --last 1m
```

### **Real Device Logging:**
```bash
# If using real device:
idevicesyslog | grep -i "NotificationApp\|IOSNotificationHandler"
```

## 💡 **Pro Tips**

1. **Too Many Logs?** Use multiple filters:
   ```
   process:NotificationApp AND (IOSNotificationHandler OR NotificationManager)
   ```

2. **Missing Logs?** Check "All Messages" view in Console.app

3. **Real-time Monitoring:** Keep Console.app open while testing

4. **Log Timestamps:** Enable timestamps in Console.app preferences

## 🎉 **Success Indicators**

✅ **System Working If You See:**
- App startup logs appear
- Permission request logs appear  
- Notification tap logs appear with correct title/body
- Launch from terminated state logs appear

❌ **Issues If You Don't See:**
- No startup logs = App not launching properly
- No permission logs = iOS handler not initializing
- No notification logs = Notification system not working