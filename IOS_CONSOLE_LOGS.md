# iOS Console Logs & Debugging Guide

## 📱 Viewing Console Logs in iOS Simulator

### Method 1: Xcode Console (Recommended)
1. **Open Xcode**
2. **Go to**: `Window` → `Devices and Simulators`
3. **Select**: Your iOS Simulator device
4. **Click**: "Open Console" button
5. **Filter**: Type "NotificationApp" to see only your app's logs

### Method 2: Console.app (macOS)
1. **Open**: Console.app (in Applications/Utilities)
2. **Select**: Your iOS Simulator device in sidebar
3. **Filter**: Search for "NotificationApp" or "com.example.notificationapp"
4. **View**: Real-time logs from your app

### Method 3: Terminal (Command Line)
```bash
# View all simulator logs
xcrun simctl spawn booted log stream --predicate 'process == "NotificationApp"'

# Or view system logs
log stream --predicate 'process == "NotificationApp"'
```

### Method 4: Qt Creator Application Output
1. **In Qt Creator**: Look at "Application Output" tab (bottom panel)
2. **Shows**: qDebug(), qWarning(), qCritical() messages
3. **Real-time**: Updates as app runs

## 🔧 Fixing Bundle Identifier Issue

### Problem: "Ungültiger (leerer) Bundle-Identifier"
**Translation**: "Invalid (empty) Bundle-Identifier"

### Solution Applied:
Added explicit bundle identifier to `.pro` file:
```qmake
QMAKE_BUNDLE_IDENTIFIER = com.example.notificationapp
```

### Alternative Solutions:
1. **Clean and Rebuild**: Sometimes Qt Creator cache issues
2. **Check Info.plist**: Verify CFBundleIdentifier is set
3. **Restart Simulator**: Close and reopen iOS Simulator

## 🧪 Running Notification Tests

### Step 1: Ensure App is Running
- App should be running in iOS Simulator
- Notification permission should be granted

### Step 2: Send Test Notification (on Mac)
```bash
# In project directory
./send_test_notification.sh
```

### Step 3: Test Scenarios
1. **Foreground**: App running, notification appears as banner
2. **Background**: App backgrounded, notification appears in notification center
3. **Terminated**: App closed, notification appears, tap to launch app

### Step 4: Verify Notification Content
- Check console logs for notification data
- Verify app displays notification title, body, and custom data

## 🐛 Common Issues & Solutions

### Issue: App doesn't launch from Qt Creator
**Solution**: 
1. Clean build (`Build` → `Clean All`)
2. Rebuild with explicit bundle identifier
3. Launch manually from simulator if needed

### Issue: No console output visible
**Solutions**:
1. Use Xcode Console (most reliable)
2. Check Qt Creator "Application Output" tab
3. Use Console.app with device filter

### Issue: Notifications not appearing
**Solutions**:
1. Check notification permissions in Settings app
2. Verify bundle identifier matches in script
3. Ensure simulator is "booted" (not just open)

## 📋 Debug Checklist

✅ **Bundle identifier set**: `com.example.notificationapp`
✅ **Info.plist configured**: Contains all required keys
✅ **Notification permissions**: Granted in app
✅ **Console logs visible**: Using Xcode Console or Console.app
✅ **Test script ready**: `send_test_notification.sh` available

The bundle identifier issue should now be resolved!